#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User function MVC03()
Local oBrowser := FwmBrowse():New()
	oBrowser:SetAlias("SZ2")
	oBrowser:SetDescription("Pedido de Sucata")
	oBrowser:Activate() // Ativando o obj
Return( NIL )
//----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	
	AADD( aRotina, {"Pesquisar"  , "AxPesqui"     , 0, 1    } )
	AADD( aRotina, {"Visualizar" , 'VIEWDEF.MVC03', 0, 2 , 0} )
	AADD( aRotina, {"Incluir"    , 'VIEWDEF.MVC03', 0, 3 , 0} )
	AADD( aRotina, {"Alterar"    , 'VIEWDEF.MVC03', 0, 4 , 0} )
	AADD( aRotina, {"Excluir"    , 'VIEWDEF.MVC03', 0, 5 , 0} )
	AADD( aRotina, {"X"          , 'U_TELA'       , 0, 6 , 0} )
	
Return(aRotina)


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
Local bPosGrid := {|oGrid,nLinha,cAcao,ccampo,xValue,xOldValue| ValDados(oGrid,nLinha,cAcao,ccampo,xValue,xOldValue)}

 
Local oStr1:= FWFormStruct(1,'SZ2')
 
Local oStr2:= FWFormStruct(1,'SZ3')
oModel := MPFormModel():New('MDLSZ2',,,{|oModel|Grava(oModel)}  )
oModel:SetDescription('Pedido de sucata ')

oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT, {|| GetSxeNum("SZ2","Z2_COD") })
oModel:addFields('MASTERSZ2',,oStr1)

oStr2:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || .T. }, {|oGRID|  fGatilho(oGrid) }  )
oStr2:AddTrigger( 'Z3_QTD'  , 'Z3_TOTAL', { || oModel:GetOperation() == 3 } , {|oGRID|  oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR") }  )

oModel:addGrid('GRIDSZ3','MASTERSZ2',oStr2,bPosGrid,{|oGrid,nLinha|fLinhaOk(oGrid,nLinha)},,{|oGrid| fTudoOk(oGrid) })

oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_CODPRO' } )


oModel:SetRelation('GRIDSZ3', { { 'Z3_FILIAL', "xFilial('SZ3')" }, { 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )



oModel:SetPrimaryKey({'Z2_COD'})


oModel:getModel('MASTERSZ2'):SetDescription('Dados do Fornecedor')
oModel:getModel('GRIDSZ3'):SetDescription('Dados do Produto')
oModel:AddCalc( 'CALCSZ3', 'MASTERSZ2', 'GRIDSZ3', 'Z3_TOTAL', 'TOTALGERAL', 'SUM', /*bCondition*/, /*bInitValue*/,'Total ' /*cTitle*/, /*bFormula*/)

oModel:SetVldActivate({|oModel| fAtivaTela(oModel)})







Return oModel
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
 
Local oStr2:= FWFormStruct(2, 'SZ3')

 
Local oStr3:= FWCalcStruct( oModel:GetModel('CALCSZ3') )
oStr2:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')


oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField('VIEWSZ2', oStr1,'MASTERSZ2' )
oView:AddGrid('VIEWSZ3' , oStr2,'GRIDSZ3')
oView:AddField('VIEWTOTAL', oStr3,'CALCSZ3')  

oView:CreateHorizontalBox( 'TELA', 27)
oView:CreateHorizontalBox( 'ITEM', 53)
oView:CreateHorizontalBox( 'RODAPE', 20)
oView:SetOwnerView('VIEWTOTAL','RODAPE')

oView:SetOwnerView('VIEWSZ3','ITEM')
oView:SetOwnerView('VIEWSZ2','TELA')

oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' )


Return oView

Static function fGatilho(oGrid)
Local nTotal as numeric

nTotal := oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR")
	

Return nTotal  





Static Function fTudoOk(oGrid)
Local lRet   := .T.
Local nLinha := 0
	For nLinha := 1 To oGrid:Length() 
		oGrid:GoLine(nLinha)
		
		If oGrid:IsDeleted()
			Loop
		Endif	
		
		If  Empty( oGrid:GetValue("Z3_QTD") ) .OR.  Empty( oGrid:GetValue("Z3_VALOR") )
			Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou qtd não possui valor",;
			      1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor valido"})
			lRet := .F.
		EndIf
	Next nLinha
	
Return lRet
//-------------------------------------------------------------------------------
Static Function fLinhaOk(oGrid,nLinha)
Local lRet := .T.

			If  ! oGrid:IsDeleted() .AND. (  Empty( oGrid:GetValue("Z3_QTD") ) .OR.  Empty( oGrid:GetValue("Z3_VALOR") ) )
				Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou qtd não possui valor",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor valido"})
				lRet := .F.
			EndIf

Return lRet

Static Function ValDados(oGrid,nLinha,cAcao,CCampo,xValue,xOldValue)
Local lRet := .T.
//"UNDELETE", "DELETE", "SETVALUE" => cAcao

If cAcao == "SETVALUE"
	If  cCampo $ "Z3_QTD|Z3_VALOR"  .AND.  xValue <= 0
		Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou qtd não possui valor",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor valido"})
		lRet := .F.		
	Endif			
	// Exercicio fazer a validação do campo Z3_QTD e Z3_VALOR

EndIf




Return lRet

//-----------------------------------------------------------------------------

Static Function fAtivaTela(oModel)
Local lRet := .T.

If oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
	If UPPER( Alltrim( SZ2->Z2_SOLICIT ) ) == UPPER( Alltrim(  cUsername ) )
		lRet := .F.
	
			Help(NIL, NIL, "Permissão", NIL, "Usuario não pode alterar o pedido: " + SZ2->Z2_COD  ,;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Não possui permissão"})
	EndIf	

Endif

Return lRet

Static Function Grava(oModel)
Local lRet := .T.

	If FwFormCommit(oModel) // Grava os dados do modelo 
		
		ConfirmSX8()
		
		If lRet
			// envia email
		EndIf
	Else
		lRet := .F.
		Help(NIL, NIL, "Atenção", NIL, "Problema na gravação do pedido",;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o adm do sistemas"})
			
	Endif
	


Return lRet











