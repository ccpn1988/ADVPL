#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FWMVCDEF.CH'

user function zZ4_MVC()
	Local oBrowse
	//MONTAGEM DO BROWSE
	oBrowse := FWMBrowse():New()
	
	//CADASTRO DE LEGENDA
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS =='A'",	"GREEN"		,"Aberto"	)
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS =='E'",	"RED"		,"Efetivado")
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS =='P'",	"YELLOW"	,"Pago"		)
	oBrowse:AddLegend("ZZ4->ZZ4_STATUS =='C'",	"CANCEL"	,"Cancelado")

	oBrowse:SetAlias('ZZ4')
	oBrowse:SetDescription('Cadastro de Movimentos')
	oBrowse:SetMenuDef('zZ4_MVC')
	oBrowse:Activate()
Return

//MONTAGEM DO MENU
Static Function MenuDef()
	Local aRotina := {}
	
	//aRotina := FwMVCMenu("zZ4_MVC") //FwMVCMenu - cria a barra de botoes automatica do browser
	aAdd(aRotina,{'Visualizar'	,'VIEWDEF.zZ4_MVC'	, 0,	2,	0,	NIL})
	aAdd(aRotina,{'Incluir'		,'VIEWDEF.zZ4_MVC'	, 0,	3,	0,	NIL})
	aAdd(aRotina,{'Alterar'		,'VIEWDEF.zZ4_MVC'	, 0,	4,	0,	NIL})
	aAdd(aRotina,{'Excluir'		,'VIEWDEF.zZ4_MVC'	, 0,	5,	0,	NIL})
	aAdd(aRotina,{'Imprimir'	,'VIEWDEF.zZ4_MVC'	, 0,	8,	0,	NIL})
	aAdd(aRotina,{'Copiar'		,'VIEWDEF.zZ4_MVC'	, 0,	9,	0,	NIL})
	aAdd(aRotina,{'Efetivar'	,'U_zZ4MVCA()'		, 0,	4,	0,	NIL}) //USA OPÇÂO 4 POIS BLOQUEIA O REGISTRO(RECLOCK)
	aAdd(aRotina,{'Cancelar'	,'U_zZ4MVCB()'		, 0,	4,	0,	NIL})
	
	
Return aRotina

//CONSTRUÇÃO MODELO
Static Function ModelDef()
	Local oModel
	Local oStruZZ4 := FWFormStruct(1,"ZZ4")
	Local oStruZZ5 := FWFormStruct(1,"ZZ5")
	
	
	oModel := MPFormModel():New("MD_ZZ4")
	oModel:addFields('MASTERZZ4',/*cOwner*/, oStruZZ4) //CAMPOS CABEÇALHOS
	oModel:addGrid('DETAILSZZ5','MASTERZZ4', oStruZZ5,{|oModel|U_TOT01A(oModel)}) //addGrid := VALIDA LINHAS ITENS
													//{|oModel|U_TOT01A(oModel)} A CADA VALIDAÇÂO DA LINHA É VALIDADA A ROTINA TOTALIZADORES	
	//RELACIONAMENTO ENTRE AS TABELAS
	oModel:SetRelation('DETAILSZZ5', { {'ZZ5_FILIAL', 'xFilial("ZZ5")'}, {'ZZ5_CODZZ4', 'ZZ4_CODIGO'} }, ZZ5->(IndexKey(1)))

	oModel:SetPrimaryKey({'ZZ4_FILIAL','ZZ4_CODIGO'})
	
	//RESTRINGINDO LINHAS DUPLICADAS
	oModel:GetModel('DETAILSZZ5'):SetUniqueLine({'ZZ5_CODZZ2'})
	
	/*//INSERINDO CALCULO DE QTD
	oModel:AddCalc('QUANT','MASTERZZ5','DETAILSZZ5','ZZ5_TOTAL','QUANTIDADE','COUNT')*/
	
Return oModel

Static Function ViewDef()
	Local oModel := ModelDef() //Definimos qual o modelo de dados (Model) que será utilizado na interface (View).
	Local oView
	Local oStrZZ4 := FWFormStruct(2,'ZZ4') //CRIA A ESTRUTURA PARAMETRO 2
	Local oStrZZ5 := FWFormStruct(2,'ZZ5')	
	
		/*//RESTRINGINDO CAMPOS
		If __cUserID <> "000000" //USUÁRIO ADMINISTRADOR
			oStruct:RemoveField( "A1_DESC" )
		Endif*/
		
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//DEFININDO ESTRUTURA DO CABEÇALHO ZZ4
	oView:AddField('FORM_ZZ4',oStrZZ4,'MASTERZZ4')
	oView:CreateHorizontalBox('BOX_FORM_ZZ4',30) //DEFINIÇÂO DO CABEÇALHO 30%
	oView:SetOwnerView('FORM_ZZ4','BOX_FORM_ZZ4')
	
	//DEFININDO ESTRUTURA DOS ITENS ZZ5 GRID
	oView:CreateHorizontalBox('BOX_FORM_ZZ5',60)
	oView:AddGrid('VIEW_ZZ5',oStrZZ5,'DETAILSZZ5')
	oView:SetOwnerView('VIEW_ZZ5','BOX_FORM_ZZ5')
	
	//DEFININDO O TITULO DA GRID
	oView:EnableTitleView('VIEW_ZZ5','Itens do Movimento')
	
	/*//SOMAR A QUANTIDADE
	oQuant	:= FWCalcStruct(oModel:GetModel('QUANT'))
	
	//DEFININDO ESTRUTURA SOMATORIA QUANTIDADE
	oView:CreateHorizontalBox('BOX_FORM_TOTAL',10)
	oView:AddField('VIEW_QUANT',oQuant,'QUANT')
	oView:SetOwnerView('VIEW_QUANT','BOX_FORM_TOTAL')*/
	
	Return oView

//VALIDAÇÂO TOTALIZADOR DA LINHA ALIMENTANDO TOTAL NO CABEÇALHO
User Function TOT01A(oModelZZ5)
	Local oModel	:= FWModelActive()
	Local oModelZZ4	:= oModel:GetModel('MASTERZZ4')
	Local nTotal	:= 0
	Local i
	
FOR i := 1 TO oModelZZ5:LENGTH() //PERCORRE AS LINHAS DOS ITENS
	oModelZZ5:GoLine(i)//VAI ATE A LINHA
	
	IF oModelZZ5:IsDeleted()
		loop
	EndIF
	
	nTotal += oModelZZ5:GetValue('ZZ5_TOTAL')//GETVALUE RETORNA O VALOR DO CAMPO NA LINHA ATUAL

NEXT
	oModelZZ4:LoadValue('ZZ4_TOTAL',nTotal)//LoadValue carrega o valor para um campo nTotal->ZZ4_TOTAL
	
Return .T.

//INCLUSÂO TITULO SE2 CONTAS A PAGAR
User Function zZ4MVCA() 
	Local 	aArray  
	Local	cPrefix		:= SuperGetMV('MS_PREFIXO',.F.,'ADV')//SuperGetMV('NOMEPAR',HELP(.T./.F.),'CONTEUDO') N EXISTIR USA O E2_PREFIXO ARRAY
	Local	cTipo		:= SuperGetMV('MS_TIPO',.F.,'NF')
	Local	cNatur		:= SuperGetMV('MS_NATUREZ',.F.,'FINAN')
	Local	cFornece	:= SuperGetMV('MS_FORNEC',.F.,'000001')
	Local	cLoja		:= SuperGetMV('MS_LOJA',.F.,'01')
	
	Private lMsErroAuto := .F. //TRATA O ERRO 
	
	
	IF ZZ4_STATUS == 'A' //ESTANDO EM ABERTO O MOVIMENTO 
	
		IF MSGYESNO('Confirma Efetivação?')//CONFIRMAR A EFETIVAÇÂO E INCLUI NA SE2
 
	aArray := { { "E2_PREFIXO"  , "PAG"             , NIL },;
	            { "E2_TIPO"     , "NF"              , NIL },;
	            { "E2_NATUREZ"  , cNatur            , NIL },;
	            { "E2_FORNECE"  , cFornece          , NIL },;
	            { "E2_LOJA"  	, cLoja	            , NIL },;
	            { "E2_EMISSAO"  , dDatabase			, NIL },;
	            { "E2_VENCTO"   , dDatabase + 30	, NIL },;
	            { "E2_YCODZZ4"  , ZZ4->ZZ4_CODIGO	, NIL },;
	            { "E2_VALOR"    , ZZ4->ZZ4_TOTAL    , NIL } }
 
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
		If lMsErroAuto //SE DER ERRO
			MostraErro()
	    Else//SE NAO DER ERRO TRAVA A ROTINA PARA ALTERAÇÂO DO STATUS E GRAVA O REGISTRO
	    	Reclock('ZZ4',.F.)
	    		ZZ4_STATUS := 'E'
	    	ZZ4->(MsUnlock())
	    	
	    	MsgInfo("Título incluído com sucesso!",'Atenção')
	    Endif
	    
	    Endif
	    
	Else
		MsgInfo("Apenas movimento em Aberto pode ser efetivado")
	Endif
	
	 
Return

//AUTOMATIZAÇÃO CANCELAMENTO DO TÌTULO
User Function zZ4MVCB()

	Local 	aArray  
	Local	cPrefix		:= SuperGetMV('MS_PREFIXO',.F.,'ADV')//SuperGetMV('NOMEPAR',HELP(.T./.F.),'CONTEUDO') N EXISTIR USA O E2_PREFIXO ARRAY
	Local	cTipo		:= SuperGetMV('MS_TIPO',.F.,'NF')
	Local	cNatur		:= SuperGetMV('MS_NATUREZ',.F.,'FINAN')
	Local	cFornece	:= SuperGetMV('MS_FORNEC',.F.,'000001')
	Local	cLoja		:= SuperGetMV('MS_LOJA',.F.,'01')
	
	Private lMsErroAuto := .F. //TRATA O ERRO 
	
	
	IF ZZ4_STATUS $ 'A,E' //ESTANDO EM ABERTO OU EFETIVADO O MOVIMENTO 
	
		IF MSGYESNO('Confirma o cancelamento?')//CONFIRMAR A EFETIVAÇÂO E INCLUI NA SE2
		
			IF ZZ4_STATUS == 'E'
			
			SE2->(DbOrderNickName('E2YCODZZ4'))
			
				IF SE2->(dbSeek(xFilial('SE2')+ZZ4->ZZ4_CODIGO)) //POSICIONOU O REGISTRO A SER TRATADO
 
	aArray := { { "E2_PREFIXO"  , SE2->E2_PREFIXO   , NIL },;
				{ "E2_NUM"	    , SE2->E2_NUM       , NIL },;
				{ "E2_PARCELA"  , SE2->E2_PARCELA	, NIL },;
	            { "E2_TIPO"     , SE2->E2_TIPO      , NIL },;
	            { "E2_FORNECE"  , SE2->E2_FORNECE   , NIL },;
	            { "E2_LOJA"  	, SE2->E2_LOJA      , NIL }}
	     
	     SE2->(dbSetOrder(1))  //VOLTA AO INDICE PRINCIPAL
	         
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
						If lMsErroAuto //SE DER ERRO
							MostraErro()
						Else//SE NAO DER ERRO TRAVA A ROTINA PARA ALTERAÇÂO DO STATUS E GRAVA O REGISTRO
					    	Reclock('ZZ4',.F.)
					    		ZZ4_STATUS := 'C'
					    	ZZ4->(MsUnlock())
					    	
					    	MsgInfo("Título excluído com sucesso!",'Atenção')
					    Endif
	    
					   Endif
					Else //CASO NÂO ENCONTRE O REGISTRO ACIMA
					  Reclock('ZZ4',.F.)
			    		ZZ4_STATUS := 'C'
			    	ZZ4->(MsUnlock())
			  Endif
	    
	    Endif
	Else
		MsgInfo("Apenas movimento em Aberto pode ser efetivado")
Endif
	
	 
Return
