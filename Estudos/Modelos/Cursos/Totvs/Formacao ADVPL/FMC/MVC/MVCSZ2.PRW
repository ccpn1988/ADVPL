#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function MVCSZ2()

	Local oBrowse	:= FwmBrowse():New()
		
	oBrowse:SetAlias("SZ2")	// Qual tabela vou usar
	oBrowse:SetDescription("Pedido de Sucata") //Qual a descrição do meu browse
	oBrowse:Activate()	// Ativa o OBJETO
	
Return(Nil)
	
Static Function MenuDef()
	/*Local aRotina	:= FwMVCMenu('MVCSZ2')*/
	Local aRotina	:= {}
	
	AADD( aRotina, {"Pesquisar"	, "AxPesqui"	  , 0, 1   } )
	AADD( aRotina, {"Visualizar", "VIEWDEF.MVCSZ2", 0, 2, 0} )
	AADD( aRotina, {"Incluir"	, "VIEWDEF.MVCSZ2", 0, 3, 0} )
	AADD( aRotina, {"Alterar"	, "VIEWDEF.MVCSZ2", 0, 4, 0} )
	AADD( aRotina, {"Excluir"	, "VIEWDEF.MVCSZ2", 0, 5, 0} )
	
Return (aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SZ2')
 
Local oStr2:= Nil
 
Local oStr3:= FWFormStruct(2, 'SZ3')
 
Local oStr4:= FWCalcStruct( oModel:GetModel('CALCZ3') )
oView := FWFormView():New()

oStr3:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')

oView:SetModel(oModel)

oView:AddField('VIEWSZ2' , oStr1,'MASTERSZ2' )
oView:AddGrid('VIEWSZ3' , oStr3,'GRIDSZ3')
oView:AddField('VIEWTOTAL', oStr4,'CALCZ3') 

oView:CreateHorizontalBox( 'TELA', 32)
oView:CreateHorizontalBox( 'ITEM', 47)
oView:CreateHorizontalBox( 'RODAPE', 21)
oView:SetOwnerView('VIEWTOTAL','RODAPE')

oView:SetOwnerView('VIEWSZ3','ITEM')
oView:SetOwnerView('VIEWSZ2','TELA')

oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' ) 


Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local bPosGrid := {|oGrid,nLinha,cAcao,cCampo,xValue,xOldValue| ValDados(oGrid,nLinha,cAcao,cCampo,xValue,xOldValue)} //Criado para utilizar na validação de grid 
 
Local oStr1:= FWFormStruct(1,'SZ2')
 
Local oStr2:= FWFormStruct(1,'SZ3')
oModel := MPFormModel():New('MDLSZ2',,,{|oModel| Grava(oModel)})
oModel:SetDescription('Fornecedor')

oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, 'GetSxeNum("SZ2","Z2_COD")'))
oModel:addFields('MASTERSZ2',,oStr1)

oStr2:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || .T. },{|oGrid| fGatilho(oGrid) }  )
oStr2:AddTrigger( 'Z3_QTD'  , 'Z3_TOTAL', { || .T. },{|oGrid| oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR") }  )
//oStr2:AddTrigger( 'Z3_QTD'  , 'Z3_TOTAL', { ||oModel:GetOperation() == 3 },{|oGrid| oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR") }  )

oModel:addGrid('GRIDSZ3','MASTERSZ2',oStr2,bPosGrid,{|oGrid,nLinha| fLinhaOk(oGrid,nLinha)},,{|oGrid| fTudoOk(oGrid)})

oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_CODPRO' } )

oModel:SetRelation('GRIDSZ3', { { 'Z3_FILIAL', 'xFilial("SZ3")' }, { 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )

oModel:SetPrimaryKey({ 'Z2_COD' })

oModel:getModel('MASTERSZ2'):SetDescription('Dados do Fornecedor')
oModel:getModel('GRIDSZ3'):SetDescription('Dados do Produto')
oModel:AddCalc( 'CALCZ3', 'MASTERSZ2', 'GRIDSZ3', 'Z3_TOTAL', 'TOTAL GERAL', 'SUM', /*bCondition*/, /*bInitValue*/,'Total' /*cTitle*/, /*bFormula*/)
oModel:SetVldActivate({|oModel| fAtivaTela(oModel)})


Return oModel


Static Function fGatilho(oGrid)
	Local nTotal //as numeric
	
	nTotal := oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR")

Return nTotal


Static Function fTudoOk(oGrid)
	Local lRet //as logical

	For nLinha := 1 To oGrid:Length()
	
		oGrid:GoLine(nLinha)
		
		If oGrid:IsDeleted()
			Loop
		EndIf
			
		If Empty( oGrid:GetValue("Z3_QTD") ) .OR. Empty( oGrid:GetValue("Z3_VALOR") )
			Help(NIL,NIL,"Obrigatório",NIL,"O campo valor ou quantidade não possui valor",;
				 1,0,NIL,NIL,NIL,NIL,NIL,{"Informar um valor valido"})
			lRet := .F.
		EndIf
	Next

Return lRet


Static Function fLinhaOk(oGrid,nLinha)
	Local lRet // as logical

	If !oGrid:isDeleted() .AND.  (Empty( oGrid:GetValue("Z3_QTD") ) .OR. Empty( oGrid:GetValue("Z3_VALOR") ))
		Help(NIL,NIL,"Obrigatório",NIL,"O campo valor ou quantidade não possui valor",;
			 1,0,NIL,NIL,NIL,NIL,NIL,{"Informar um valor valido"})
		lRet := .F.
	EndIf

Return lRet


Static Function ValDados(oGrid,nLinha,cAcao,cCampo,xValue,xOldValue)

	If cAcao == "SETVALUE"
		//Exercicio fazer a validação do campo Z3_QTD e Z3_VALOR

		If !oGrid:isDeleted() .AND. cCampo $ "Z3_QTD|Z3_VALOR" .AND. Negativo(xValue)
				Help(NIL,NIL,"Obrigatório",NIL,"O campo valor ou quantidade não possui valor",;
					 1,0,NIL,NIL,NIL,NIL,NIL,{"Informar um valor valido"})
				lRet := .F.
		EndIf

	EndIf

Return lRet



Static Function fAtivaTela(oModel)
	Local lRet	:= .T.
	//Pagina 258
	If oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
		If Upper( Alltrim( SZ2->Z2_SOLICIT ) ) == Upper( AllTrim( cUserName ) )
			Help(NIL,NIL,"Permissão",NIL,"Usuário não pode alterar o pedido: " + SZ2->Z2_COD,;
					 1,0,NIL,NIL,NIL,NIL,NIL,{"Não possui permissão"})
			lRet := .F.
		EndIf		
	EndIf
Return lRet



Static Function Grava(oModel)

	Local lRet	:= .T.
	
	If FwFormCommit(oModel) // Grava os dados do modelo
		If lRet
			// Envia Email	
		EndIf
	Else
		lRet := .F.
		Help(NIL,NIL,"Atenção",NIL,"Problema na gravação do pedido: " + SZ2->Z2_COD,;
					 1,0,NIL,NIL,NIL,NIL,NIL,{"Informar o problema para o adm do sistemas"})
	EndIf

Return lRet