#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"


#Define ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENCADPR  ºAutor  ³Cleuto Lima         º Data ³  09/08/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de processo.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Projeto Gestão de Obras                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENCADPR()

Private oBrowse                                                               
Private lValid	:= .T.
Private aRotina	:= {}

DbSelectArea("ZZP")
DbSelectArea("ZZQ")
DbSelectArea("ZZR")
DbSelectArea("ZZS")
ZZP->(DbSetOrder(1))
ZZQ->(DbSetOrder(1))
ZZR->(DbSetOrder(1))
ZZS->(DbSetOrder(1))

//RpcSetEnv("99","01")

// Definição do Modelo de Dados
ModelDef()

// Definição do Modelo de Visualização
ViewDef()

// Definição das Operações disponíveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZP')
oBrowse:SetDescription("Manutenção de Processos") 

// Legendas
oBrowse:AddLegend("ZZP_MSBLQL=='2'","GREEN"	,"Ativo")
oBrowse:AddLegend("ZZP_MSBLQL=='1'","RED"	,"Desativado") 

//Para mudar a cor da linha do browse
// Linha alternada
//obrowse:SetClrAlterRow(nCor RGB)

oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENCADPR" )

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENCADPR' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENCADPR' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENCADPR' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENCADPR' OPERATION 5 ACCESS 0
//ADD OPTION aRotina TITLE 'Imprimir' ACTION 'VIEWDEF.GENCADPR' OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar' ACTION 'VIEWDEF.GENCADPR' OPERATION 9 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar Para..' ACTION 'U_GENCACPY()' OPERATION 9 ACCESS 0

Return aRotina

Static Function xIniPad()

Local xRet := ""

Return xRet

Static Function ModelDef()     
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZP  := FWFormStruct(1,'ZZP')
Local oStruZZQ  := FWFormStruct(1,'ZZQ')
Local oStruZZR  := FWFormStruct(1,'ZZR')
Local oStruZZS  := FWFormStruct(1,'ZZS')
// Cria Modelo de Dados
Local oModel 

oStruZZP:AddField ( 'Descrição', 'Descrição', 'ZZPDESC', "C", 55, 0, {|| .T. }, {|| .T. }, {},.F., {|| Posicione("ZZT",1,xFilial("ZZT")+ZZP->ZZP_IDTPPU,"ZZT_DESC") }, .F., .T., .T., ".T.")
oStruZZQ:AddField ( 'Situação', 'Situação', 'ZZQSITUAC', "C", 55, 0, {|| .T. }, {|| .T. }, {},.F., {|| Posicione("SZ4",1,xFilial("SZ4")+ZZQ->ZZQ_SITOBR,"Z4_DESC") }, .F., .T., .T., ".T.")
oStruZZR:AddField ( 'Descrição', 'Descrição', 'ZZRDESC', "C", 30, 0, {|| .T. }, {|| .T. }, {},.F., {|| GrpRetName( ZZR->ZZR_GRPUSR ) }, .F., .T., .T., ".T.")
oStruZZS:AddField ( 'Titulo', 'Titulo', 'ZZSDESC', "C", 30, 0, {|| .T. }, {|| .T. }, {},.F., {|| Posicione("SX3",2,ZZS->ZZS_CAMPO,"X3_TITULO") }, .F., .T., .T., ".T.")

oStruZZP:SetProperty( 'ZZP_NUM' , MODEL_FIELD_KEY, .T.)
oStruZZP:SetProperty( 'ZZP_IDTPPU' , MODEL_FIELD_KEY, .T.)
oStruZZS:SetProperty( "ZZS_ORDEM", MODEL_FIELD_VALID, {|x| u_GENCADPB(x) } )

//aGtZZP := FwStruTrigger('ZZP_IDTPPU','ZZPDESC' ,'ZZT->ZZT_DESC',.T.,'ZZT',1,'xFilial("ZZT")+M->ZZP_IDTPPU')
//aGtZZR := FwStruTrigger('ZZR_GRPUSR','ZZRDESC' ,'GrpRetName( M->ZZR_GRPUSR )',.F.,'',0,'M->ZZR_GRPUSR')
aGtZZP := FwStruTrigger('ZZP_IDTPPU','ZZPDESC' ,'Posicione("ZZT",1,xFilial("ZZT")+M->ZZP_IDTPPU,"ZZT_DESC") ',.F.,'',0,'M->ZZP_IDTPPU')

oStruZZP:AddTrigger( ;
aGtZZP[1] , ; // [01] identificador (ID) do campo de origem
aGtZZP[2] , ; // [02] identificador (ID) do campo de destino
aGtZZP[3] , ; // [03] Bloco de código de validação da execução do gatilho
aGtZZP[4] ) // [04] Bloco de código de execução do gatilho


aGtZZQ := FwStruTrigger('ZZQ_SITOBR','ZZQSITUAC' ,'SZ4->Z4_DESC',.T.,'SZ4',1,'xFilial("SZ4")+M->ZZQ_SITOBR')

oStruZZQ:AddTrigger( ;
aGtZZQ[1] , ; // [01] identificador (ID) do campo de origem
aGtZZQ[2] , ; // [02] identificador (ID) do campo de destino
aGtZZQ[3] , ; // [03] Bloco de código de validação da execução do gatilho
aGtZZQ[4] ) // [04] Bloco de código de execução do gatilho


aGtZZR := FwStruTrigger('ZZR_GRPUSR','ZZRDESC' ,'GrpRetName( M->ZZR_GRPUSR )',.F.,'',0,'M->ZZR_GRPUSR')

oStruZZR:AddTrigger( ;
aGtZZR[1] , ; // [01] identificador (ID) do campo de origem
aGtZZR[2] , ; // [02] identificador (ID) do campo de destino
aGtZZR[3] , ; // [03] Bloco de código de validação da execução do gatilho
aGtZZR[4] ) // [04] Bloco de código de execução do gatilho

aGtZZS := FwStruTrigger('ZZS_CAMPO','ZZSDESC' ,'SX3->X3_TITULO',.T.,'SX3',2,'M->ZZS_CAMPO')

oStruZZS:AddTrigger( ;
aGtZZS[1] , ; // [01] identificador (ID) do campo de origem
aGtZZS[2] , ; // [02] identificador (ID) do campo de destino
aGtZZS[3] , ; // [03] Bloco de código de validação da execução do gatilho
aGtZZS[4] ) // [04] Bloco de código de execução do gatilho

//aGtZZSB := FwStruTrigger('ZZS_ORDEM','u_GENCADPB()' ,'u_GENCADPB()',.F.,' ',1,'u_GENCADPB()')
//aGtZZSB := FwStruTrigger('ZZS_ORDEM','ZZS_ORDEM' ,'u_GENCADPB()',.F.,'',0,'M->ZZS_ORDEM')

//oStruZZS:AddTrigger( ;
//aGtZZSB[1] , ; // [01] identificador (ID) do campo de origem
//aGtZZSB[2] , ; // [02] identificador (ID) do campo de destino
//aGtZZSB[3] , ; // [03] Bloco de código de validação da execução do gatilho
//aGtZZSB[4] ) // [04] Bloco de código de execução do gatilho

oModel := MPFormModel():New('GENCA_MD', , , { |oModel| GENCAGRV( oModel ) } )

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('ZZP_FORM',/*cOwner*/,oStruZZP,/*blinePre*/,/*blinePos*/)   
oModel:AddGrid( 'ZZQ_GRID', 'ZZP_FORM', oStruZZQ )
oModel:AddGrid( 'ZZR_GRID', 'ZZQ_GRID', oStruZZR )
oModel:AddGrid( 'ZZS_GRID', 'ZZR_GRID', oStruZZS )
	
// Define os relacionamentos
// Necessário somente quando os dados não são carregados por query
oModel:SetRelation( 'ZZQ_GRID', { { 'ZZQ_FILIAL', 'xFilial("ZZQ")' }, { 'ZZQ_NUM', "ZZP_NUM" }, { 'ZZQ_TPPUB', 'ZZP_IDTPPU' } }, ZZQ->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZZR_GRID', { { 'ZZR_FILIAL', 'xFilial("ZZR")' }, { 'ZZR_NUM', 'ZZQ_NUM' }, { 'ZZR_TPPUB', 'ZZQ_TPPUB' } , { 'ZZR_SITOBR', 'ZZQ_SITOBR' } }, ZZR->( IndexKey( 1 ) ) )
//oModel:SetRelation( 'ZZS_GRID', { { 'ZZS_FILIAL', 'xFilial("ZZS")' }, { 'ZZS_NUM', 'ZZR_NUM' }, { 'ZZS_TPPUB', 'ZZR_TPPUB' } , { 'ZZS_SITOBR', 'ZZR_SITOBR' } , { 'ZZS_GRPUSR', 'ZZR_GRPUSR' } }, ZZS->( IndexKey( 1 ) ) )
oModel:SetRelation( 'ZZS_GRID', { { 'ZZS_FILIAL', 'xFilial("ZZS")' }, { 'ZZS_NUM', 'ZZR_NUM' }, { 'ZZS_TPPUB', 'ZZR_TPPUB' } , { 'ZZS_SITOBR', 'ZZR_SITOBR' } , { 'ZZS_GRPUSR', 'ZZR_GRPUSR' } }, "ZZS_FILIAL+ZZS_NUM+ZZS_TPPUB+ZZS_SITOBR+ZZS_GRPUSR+ZZS_FOLDER+ZZS_ORDEM+ZZS_CAMPO" )

// Definição da Chave Primária
oModel:SetPrimaryKey({"ZZP_FILIAL","ZZP_NUM","ZZP_IDTPPU"}) 

// Descrição do Modelo
oModel:SetDescription("Manutenção de Processos") 

// Descrição do Modelo
oModel:GetModel('ZZP_FORM'):SetDescription("Processos")
oModel:GetModel('ZZQ_GRID'):SetDescription("Situação do Produto") 
oModel:GetModel('ZZR_GRID'):SetDescription("Grupos de Usuários")
oModel:GetModel('ZZS_GRID'):SetDescription("Campos")

Return oModel                                

User Function GENCADPB(xParam)

Local oModel	:= FWModelActive()
Local oModelZZS	:= oModel:GetModel( 'ZZS_GRID' )
Local nLenght	:= oModelZZS:Length()
Local nBkpLine	:= oModelZZS:GetLine()
Local lRet		:= .t.
Local cOrdem	:= M->ZZS_ORDEM
Local cBkpOrdem	:= M->ZZS_ORDEM
Local cFolder	:= oModelZZS:GetValue("ZZS_FOLDER")
Local cCampo	:= oModelZZS:GetValue("ZZS_CAMPO")  
Local nAuxFor	:= 0
Local oViewAtv	:= FWViewActive()
Local aNewVlw	:= {}
Local lLoop		:= .T.
Local nPosExist	:= nBkpLine
Local aOldGrid	:= {}
Local aJaMudou	:= {}
Local nAuxFor	:= 0

//ZZS_FOLDER+ZZS_ORDEM+ZZS_CAMPO
//copyDataFromGrid
//SeekLine
//GetArrayPos
//GetValueByPos

While lLoop	
	nPosExist := xGetPosAist(cOrdem,nPosExist,oModelZZS,cFolder)
	If nPosExist > 0
		cOrdem	:= Soma1(cOrdem)
		Aadd(aNewVlw, { nPosExist , cOrdem } )
	Else
		lLoop	:= .F.
		Exit
	EndIF	
EndDO

For nAuxFor := 1 To Len(aNewVlw)
	oModelZZS:GoLine(aNewVlw[nAuxFor][1])
	oModelZZS:LoadValue("ZZS_ORDEM",aNewVlw[nAuxFor][2])	
Next
oModelZZS:GoLine(nBkpLine)
oModelZZS:LoadValue("ZZS_ORDEM",cBkpOrdem)
oViewAtv:Refresh("ZZS_GRID")
/*
For nAuxFor := 1 To nLenght
	Aadd(aOldGrid, { oModelZZS:GetValue("ZZS_CAMPO",nAuxFor),oModelZZS:GetValue("ZZS_FOLDER",nAuxFor),oModelZZS:GetValue("ZZS_ORDEM",nAuxFor) , nAuxFor } )
Next

aSort(aOldGrid,,,{|x,y| val( IIF( Empty(x[2]) ,"99" , x[2] ) +IIF( Empty(x[3]) ,"99" , x[3] )) < val( IIF( Empty(y[2]) ,"99" , y[2] ) + IIF( Empty(y[3]) ,"99" , y[3] ))  })

For nAuxFor := 1 To nLenght
	If aOldGrid[nAuxFor][4] <> nAuxFor .AND. aScan(aJaMudou, {|x| x == aOldGrid[nAuxFor][4] } ) == 0
		Aadd(aJaMudou,nAuxFor)
		//oModelZZS:GetModel("ZA2DETAIL"):LineShift(5,6)
		//oModelZZS:GoLine(aOldGrid[nAuxFor][4])
		oModelZZS:LineShift(nAuxFor,aOldGrid[nAuxFor][4])				
		//If nBkpLine == aOldGrid[nAuxFor][4]
		//	nBkpLine := nAuxFor
		//EndIf
	EndIf
	//oModelZZS:GoLine(nAuxFor)
	//oModelZZS:LoadValue("ZZS_ORDEM",aOldGrid[nAuxFor][3])
Next

//oModelZZS:GoLine(nBkpLine)
oViewAtv:Refresh("ZZS_GRID")
*/

//oObjAjus := oModelZZS
//oModelZZS:DeActivate()
//oModelZZS:SetLoadFilter( , " .T. " )
//oModelZZS:Activate()
//oModelZZS:copyDataFromGrid(oObjAjus)

/*
aOldGrid	:= oModelZZS:GetOldData()
aOldGrid[2]	:= aSort(aOldGrid[2],,,{|x,y| x[ GDFieldPos("ZZS_FOLDER",aOldGrid[1]) ] < y[ GDFieldPos("ZZS_FOLDER",aOldGrid[1]) ] .AND. ;
			x[ GDFieldPos("ZZS_ORDEM",aOldGrid[1]) ] < y[ GDFieldPos("ZZS_ORDEM",aOldGrid[1]) ] .AND. ;
			x[ GDFieldPos("ZZS_CAMPO",aOldGrid[1]) ] < y[ GDFieldPos("ZZS_CAMPO",aOldGrid[1]) ]               }) 
*/

Return lRet

Static Function xGetPosAist(cOrdem,nPos,oModelZZS,cFolder)
Local nLenght	:= oModelZZS:Length()
Local nPosExist	:= 0
Local nAuxFor	:= 0

For nAuxFor := 1 To nLenght
	If oModelZZS:IsDeleted(nAuxFor) .OR. ( oModelZZS:GetValue("ZZS_FOLDER",nAuxFor) <> cFolder ) .OR. ( nPos == nAuxFor ) .OR.  oModelZZS:GetValue("ZZS_ORDEM",nAuxFor) < cOrdem
		Loop
	EndIF
	
	IF oModelZZS:GetValue("ZZS_ORDEM",nAuxFor) == cOrdem
		nPosExist := nAuxFor
		Exit
	EndIf	
Next

Return nPosExist

                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZP  := FWFormStruct(2,'ZZP')
Local oStruZZQ  := FWFormStruct(2,'ZZQ',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZQ_FILIAL/ZZQ_NUM/ZZQ_TPPUB/"})
Local oStruZZR  := FWFormStruct(2,'ZZR',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZR_FILIAL/ZZR_NUM/ZZR_TPPUB/ZZR_SITOBR"})
Local oStruZZS  := FWFormStruct(2,'ZZS',{|cCampo| .NOT. AllTrim(cCampo) $ "ZZS_FILIAL/ZZS_NUM/ZZS_TPPUB/ZZS_SITOBR/ZZS_GRPUSR/"})
Local aGtZZQ	:= {}

// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENCADPR')

// Cria o modelo da View
Local oView := FWFormView():New()

// Cria campo virtual para exibir os bitmaps da situação 
oStruZZP:AddField( 'ZZPDESC'	, '99', "Descrição"	," "	,{},'C','',NIL,'',.F.,NIL,NIL,{},NIL,'{|| " " }',.T.,NIL)
oStruZZQ:AddField( 'ZZQSITUAC'	, '99', "Situação"	," "	,{},'C','',NIL,'',.F.,NIL,NIL,{},NIL,'{|| " " }',.T.,NIL)
oStruZZR:AddField( 'ZZRDESC'	, '99', "Descrição"	," "	,{},'C','',NIL,'',.F.,NIL,NIL,{},NIL,'{|| " " }',.T.,NIL)
oStruZZS:AddField( 'ZZSDESC'	, '13', "Titulo"	," "	,{},'C','',NIL,'',.F.,NIL,NIL,{},NIL,'{|| " " }',.T.,NIL)

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZP', oStruZZP, 'ZZP_FORM')
oView:AddGrid( 'VIEW_ZZQ', oStruZZQ, 'ZZQ_GRID' )
oView:AddGrid( 'VIEW_ZZR', oStruZZR, 'ZZR_GRID' )
oView:AddGrid( 'VIEW_ZZS', oStruZZS, 'ZZS_GRID' )

//oStruZZQ:SetProperty( 'ZZQ_SITOBR' , MVC_VIEW_ORDEM,'01')
//oStruZZQ:SetProperty( 'ZZQSITUAC' , MVC_VIEW_ORDEM,'02')

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'SUPERIOR', 20 ) // ocupar 20% da tela
oView:CreateHorizontalBox( 'TELA', 30 ) // ocupar 30% da tela
oView:CreateHorizontalBox( 'OTHER', 50 ) // ocupar 50% da tela
 
oView:CreateVerticalBox( 'ESQUERDA', 30 , 'TELA' ) // ocupar 80% da tela
oView:CreateVerticalBox( 'CENTRO', 30 , 'TELA' ) // ocupar 80% da tela
oView:CreateVerticalBox( 'DIREITA', 40 , 'TELA' ) // ocupar 80% da tela

// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZP' ,'SUPERIOR')
oView:SetOwnerView('VIEW_ZZQ' ,'ESQUERDA')
oView:SetOwnerView('VIEW_ZZR' ,'CENTRO')
oView:SetOwnerView('VIEW_ZZS' ,'DIREITA')

oView:AddOtherObject("OTHER_PANEL", {|oPanel| GENCADOT(oPanel)})
oView:SetOwnerView("OTHER_PANEL",'OTHER')

//oView:AddIncrementField('VIEW_QQ7','QQ7_ITEM')   

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZP')
oView:EnableTitleView('VIEW_ZZQ')
oView:EnableTitleView('VIEW_ZZR')
oView:EnableTitleView('VIEW_ZZS')                   

oModel:AddRules( 'ZZQ_GRID', 'ZZQ_NUM',		'ZZP_FORM', "ZZP_NUM" , 1 )
oModel:AddRules( 'ZZQ_GRID', 'ZZQ_TPPUB',	'ZZP_FORM', "ZZP_IDTPPU" , 1 )
oModel:AddRules( 'ZZQ_GRID', 'ZZQ_SITOBR',	'ZZP_FORM', "ZZP_NUM" , 1 )
oModel:AddRules( 'ZZQ_GRID', 'ZZQ_SITOBR',	'ZZP_FORM', "ZZP_IDTPPU" , 1 )

oModel:AddRules( 'ZZR_GRID', 'ZZR_NUM',		'ZZQ_GRID', "ZZQ_NUM" , 1 )
oModel:AddRules( 'ZZR_GRID', 'ZZR_TPPUB',	'ZZQ_GRID', "ZZQ_TPPUB" , 1 )
oModel:AddRules( 'ZZR_GRID', 'ZZR_SITOBR',	'ZZQ_GRID', "ZZQ_SITOBR" , 1 )

oModel:AddRules( 'ZZS_GRID', 'ZZS_NUM',		'ZZR_GRID', "ZZR_NUM" , 1 )
oModel:AddRules( 'ZZS_GRID', 'ZZS_TPPUB',	'ZZR_GRID', "ZZR_TPPUB" , 1 )
oModel:AddRules( 'ZZS_GRID', 'ZZS_SITOBR',	'ZZR_GRID', "ZZR_SITOBR" , 1 )
oModel:AddRules( 'ZZS_GRID', 'ZZS_GRPUSR',	'ZZR_GRID', "ZZR_GRPUSR" , 1 )

/*
oStruZZP:SetProperty('ZZP_NUM',MVC_VIEW_FOLDER_NUMBER,'1')

oStruZZP:AddGroup( 'GRUPO01', '' , '', 1 )

oStruZZP:SetProperty('ZZP_NUM'    ,MVC_VIEW_GROUP_NUMBER,'GRUPO01')
oStruZZP:SetProperty('ZZP_DESCRI',MVC_VIEW_GROUP_NUMBER,'GRUPO01')
oStruZZP:SetProperty('ZZP_IDTPPU'   ,MVC_VIEW_GROUP_NUMBER,'GRUPO01')
oStruZZP:SetProperty('ZZP_MSBLQL'   ,MVC_VIEW_GROUP_NUMBER,'GRUPO01')

oView:SetCloseOnOk({|| .T. })
*/
Return oView


Static Function GENCAGRV(oModel) 
Local lRet		:= .T.
FWFormCommit( oModel , ,  {|oModel,cID,cAlias| GENAFTGRV(oModel,cID,cAlias)})

Return lRet

Static Function GENAFTGRV(oModel,cID,cAlias) 

Local lRet		:= .T.

If ALLTRIM(cID) $ 'OTHER_PANEL#ZZP_FORM'
	Retur .T.
EndIF

If oModel:IsInserted()
	Do Case
		Case cAlias == "ZZS" .AND. ( Empty(ZZS->ZZS_NUM) .OR. Empty(ZZS->ZZS_TPPUB) .OR. Empty(ZZS->ZZS_SITOBR) .OR. Empty(ZZS->ZZS_GRPUSR))
			RecLock("ZZS")
			ZZS->ZZS_NUM	:= ZZR->ZZR_NUM
			ZZS->ZZS_TPPUB	:= ZZR->ZZR_TPPUB
			ZZS->ZZS_SITOBR	:= ZZR->ZZR_SITOBR
			ZZS->ZZS_GRPUSR	:= ZZR->ZZR_GRPUSR
			MsUnLock()
		Case cAlias == "ZZR" .AND. ( Empty(ZZR->ZZR_NUM) .OR. Empty(ZZR->ZZR_TPPUB) .OR. Empty(ZZR->ZZR_SITOBR))
			RecLock("ZZR")
			ZZR->ZZR_NUM	:= ZZQ->ZZQ_NUM
			ZZR->ZZR_TPPUB	:= ZZQ->ZZQ_TPPUB
			ZZR->ZZR_SITOBR	:= ZZQ->ZZQ_SITOBR
			MsUnLock()
		Case cAlias == "ZZQ" .AND. ( Empty(ZZQ->ZZQ_NUM) .OR. Empty(ZZQ->ZZQ_TPPUB) .OR. Empty(ZZQ->ZZQ_SITOBR))
			RecLock("ZZQ")
			ZZQ->ZZQ_NUM	:= ZZP->ZZP_NUM
			ZZQ->ZZQ_TPPUB	:= ZZP->ZZP_TPPUB
			ZZQ->ZZQ_SITOBR	:= ZZP->ZZP_IDTPPU
			MsUnLock()			
	EndCase
EndIf	

Return lRet


Static Function GENCADOT(oPanel)

Local lOk := .F.

//@ 10, 10 Button 'Teste' Size 36, 13 Message 'Contagem da FormGrid' Pixel Action MsgStop("Teste") of oPanel

//oTIBrowser := TIBrowser():New(10,10,260,170, "http://www.totvs.com.br", oPanel )
//oTIBrowser:Align := CONTROL_ALIGN_ALLCLIENT

Return nil

User Function GENCACPY()

Local aResult	:= {}
Local cCopyPara	:= CriaVar("ZZP_IDTPPU",.F.)
Local oDlgSit	:= nil
Local cCadastro	:= "Tipo de Produto"
Local nOpcA		:= 0
Local aButtons	:= {}
//Local oFont		:= TFont():New('Courier new',,-15,.T.)
Local oSay1		:= nil
Local oGet1		:= nil

DEFINE MSDIALOG oDlgSit TITLE cCadastro FROM 000,000 TO 100,250 COLORS 0, 16777215 PIXEL

oSay1:= TSay():New(005,005,{|| "Seleciona o tipo de produto destino da copia!" },oDlgSit,,/*oFont*/,,,,.T.,CLR_BLUE,CLR_WHITE,200,20)
 
oGet1 := TGet():New( 025, 005, { | u | If( PCount() == 0, cCopyPara, cCopyPara := u ) },oDlgSit, 030, 010, "!@",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cCopyPara"  )
oGet1:cF3	:= "ZZT"

oSButton := SButton():New( 025, 060, 1, {|| nOpcA := 1,oDlgSit:End() }, oDlgSit, .T.,,)

ACTIVATE MSDIALOG oDlgSit CENTERED

If !Empty(cCopyPara)
	aResult := TCSPEXEC("SP_COPIA_CFG_PROD", AllTrim(ZZP->ZZP_IDTPPU),AllTrim(cCopyPara),AllTrim(Posicione("ZZT",1,xFilial("ZZT")+AllTrim(cCopyPara),"ZZT_DESC")))

/*

DECLARE
  outStr VARCHAR2(1000);
  outValue INT;
BEGIN
  SP_COPIA_CFG_CAMPO( '1', '1', '300', '305', '000004', '000004','28',outStr,outValue);
END;
*/
	
	If Len(aResult) == 2
		MsgAlert("situação da Copia:"+aResult[1])
	EndIf
EndIf

Return nil