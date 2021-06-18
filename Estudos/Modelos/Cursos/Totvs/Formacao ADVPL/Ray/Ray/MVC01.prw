#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC01()
	
	Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SA1")
	oBrowser:SetDescription("Cadastro de Cliente")

	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_MARRON","Ativo"     )
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_PINK"  ,"Desativado")
	oBrowser:Activate() // Ativando o obj

Return( NIL )

//------------------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina := FWMVCMenu('MVC01')//Criando os botões VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

//------------------------------------------------------------------------------

/*Static Function MenuDef()
	Local aRotina := {}

	aRotina := {;
		{ "Pesquisar" , "AxPesqui"  , 0, 1},;
		{ "Visualizar", "U_MDL02SZ0", 0, 2},;
		{ "Incluir"   , "U_MDL02SZ0", 0, 3},;
		{ "Alterar"   , "U_MDL02SZ0", 0, 4},;
		{ "Excluir"   , "U_MDL02SZ0", 0, 5},;
		{ "Legenda"   , "U_LEGSZ0"  , 0, 7};
		}
Return(aRotina)
*/
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SA1')
oModel := MPFormModel():New('MDLSA1')
oModel:SetDescription('Cadastro de Cliente')

oStr1:SetProperty('A1_MUN',MODEL_FIELD_OBRIGAT,.F.)


oStr1:RemoveField( 'A1_FAX' )
oStr1:AddTrigger( 'A1_END', 'A1_ENDENT', { || .T. }, {|| fGatilho() } )
oStr1:SetProperty('A1_END',MODEL_FIELD_TAMANHO,40)
oModel:addFields('MASTERSA1',,oStr1,{|oForm,cAcao,cCampo,xValor| bPre(oForm,cAcao,cCampo,xValor)},{|cEstado| TUDOOK(cEstado)})
oModel:getModel('MASTERSA1'):SetDescription('DadosSA1')



Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SA1')
oView := FWFormView():New()

oView:SetModel(oModel)

oView:AddField('VIEWSA1' , oStr1,'MASTERSA1' ) 

oStr1:RemoveField( 'A1_FAX' )
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSA1','TELA')

Return oView

//----------------------------------------

Static Function fGatilho()

	Local cRet := ""
	Local oModel	:=	FWModelActive() //Retorna o modelo ativo
	Local oField	:= oModel:GetModel('MASTERSA1') //Retorna a estrutura do componente

	cRet	:= oField:GetValue('A1_END') //Retorna o conteudo do campo
//cRet	:=	oModel:GetValue('MASTERSA1','A1_END')
//cRet	:=	oModel:GetModel('MASTERSA1'):GetValue('A1_END')

	
Return(cRet)

//-----------------------------------------------------------

Static Function TUDOOK(oField)
	Local lRet := .T.
	
	if oField:GetValue("A1_EST") == "RJ"
	
		//		MsgInfo("Dados de outra empresa")
		Help(NIL, NIL, "UF", NIL, "Não temos operação nesse estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outra empresa"})
		lRet := .F.
	elseif oField:GetValue("A1_TIPO") != "F"
		Help(NIL, NIL, "Tipo", NIL, "Apenas vendas para consumidor final", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Não vender"})
		lRet := .F.		
	Endif
Return(lRet)

//-----------------------------------------------------------

Static Function bPre(oForm,cAcao,cCampo,xValor)
	Local lRet := .T.
	
	//cAcao CANSETVALUE e SETVALUE

	If (cCampo == "A1_EST" .AND. xValor == "RJ") .OR. (cCampo == "A1_TIPO" .AND. xValor != "F")
		Help(NIL, NIL, cCampo, NIL, "O dado não é Valido", 1, 0,;
		 NIL, NIL, NIL, NIL, NIL, {"Informar outro valor"})
		lRet := .F.
	endif
	
Return(lRet)