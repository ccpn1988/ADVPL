#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User function MVC03 ()
	Local oBrowser := FwmBrowse():New()
	oBrowser:SetAlias("SZ2")
	oBrowser:SetDescription("Pedido de Sucata")
	oBrowser:Activate() //Ativando o objeto
	
Return(NIL)

Static Function MenuDef() //Barra de botões
	Local aRotina:=FwMVCMenu('mvc03')//Criando os botões visualizar, incluir, alterar, excluir, copiar, imprimir
Return(aRotina)

//========================================================================================
//========================================================================================
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 25/05/2019
@version 1.0
/*/
//========================================================================================
//========================================================================================

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	
	
	Local oStr1:= FWFormStruct(2, 'SZ2')
	Local oStr2:= FWFormStruct(2, 'SZ3')
	
	Local oStr3:= FWCalcStruct( oModel:GetModel('CALCSZ3') )
	oStr2:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('VIEWSZ2' , oStr1,'MASTERSZ2' )
	oView:AddGrid('VIEWSZ3' , oStr2,'GRIDSZ3')
	oView:AddField('VIEWTOTAL', oStr3,'CALCSZ3')
	oView:CreateHorizontalBox( 'BOXFORM1', 29)
	
	oView:CreateHorizontalBox( 'ITEM', 51)
	oView:CreateHorizontalBox( 'BOXFORM5', 20)
	oView:SetOwnerView('VIEWTOTAL','BOXFORM5')
	oView:SetOwnerView('VIEWSZ3','ITEM')
	oView:SetOwnerView('VIEWSZ2','BOXFORM1')
	oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' )
	
	
Return oView
//========================================================================================
//========================================================================================
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 25/05/2019
@version 1.0
/*/
//========================================================================================
//========================================================================================

Static Function ModelDef()
	Local oModel
	Local bPosGrid := {|oGrid, nLinha, cAcao, cCampo, xValue, xOldValue| ValDados (oGrid, nLinha, cAcao, cCampo, xValue, xOldValue)}
	
	Local oStr1:= FWFormStruct(1,'SZ2')
	
	Local oStr2:= FWFormStruct(1,'SZ3')
	oModel := MPFormModel():New('MDSLSZ2',,,{|oModel|Grava(oModel)})
	oModel:SetDescription('PEDIDO DE SUCATA')
	
	oStr1:SetProperty('Z2_NOMEFOR',MODEL_FIELD_TAMANHO,45)
	
	oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, 'GetSxeNum("SZ2","Z2_COD")'))
	oModel:addFields('MASTERSZ2',,oStr1)
	
	oStr2:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. },{|oGrid| fGatilho(oGrid)}  )
	oStr2:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || oModel:GetOperation () == 3 },{|oGrid| oGrid:GetValue("Z3_QTD") * oGrid:GetValue ("Z3_VALOR")} )
	
	oModel:addGrid('GRIDSZ3','MASTERSZ2',oStr2,bPosGrid,{|oGrid, nLinha| fLinhaOk(oGrid, nLinha)},,{|oGrid| fTudoOk(oGrid)})
	
	oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_COD' } )
	
	
	oModel:SetRelation('GRIDSZ3', { { 'Z3_FILIAL', "xFilial ('SZ3')" }, { 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )
	
	
	
	oModel:SetPrimaryKey({ 'Z2_COD' }) //SetPrimaryKey pode deixar em branco mais tem a necessidade do método
	
	
	oModel:getModel('MASTERSZ2'):SetDescription('DADOS DO FORNECEDOR')
	oModel:getModel('GRIDSZ3'):SetDescription('Dados do Produto')
	oModel:AddCalc( 'CALCSZ3', 'MASTERSZ2', 'GRIDSZ3', 'Z3_TOTAL', 'TOTALGERAL', 'SUM', /*bCondition*/, /*bInitValue*/,'Total' /*cTitle*/, /*bFormula*/)
	oModel:SetVldActivate({|oModel| fAtivaTela(oModel)})
	
	
Return oModel
//========================================================================================
//========================================================================================
Static Function fGatilho (oGrid)
	
	Local nTotal := 0
	
	nTotal:= oGrid:GetValue("Z3_QTD") * oGrid:GetValue ("Z3_VALOR")
	
Return nTotal
//========================================================================================
//========================================================================================
Static Function fTudook(oGrid)
	Local lRet :=.T.
	Local nLinha := 0
	For nLinha := 1 To oGrid:Length()
		oGrid:GoLine(nLinha)
		
		If OGrid:IsDeleted()
			Loop
		Endif
		
		If Empty (oGrid:GetValue("Z3_QTD")) .OR. Empty (oGrid:GetValue ("Z3_VALOR"))
			
			Help (NIL, NIL, "Obrigatório", NIL, "O Campo valor ou Qtd Não possui valor", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			
			lRet :=.F.
			
		Endif
		
	Next nLinha
	
Return (lRet)
//========================================================================================
//========================================================================================
Static Function  fLinhaOk(oGrid, nLinha)
	Local lRet:= .T.
	
	If OGrid:IsDeleted() .AND.Empty (oGrid:GetValue("Z3_QTD",nLinha)) .OR. Empty (oGrid:GetValue ("Z3_VALOR",nLinha))
		
		Help (NIL, NIL, "Obrigatório", NIL, "O Campo valor ou Qtd Não possui valor", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
		
		lRet :=.F.
		
	Endif
	
Return(lRet)
//========================================================================================
//========================================================================================
Static Function ValDados (oGrid, nLinha, cAcao, cCampo, xValue, xOldValue)
	Local lRet:= .T.
	//"UNDELETE", "DELETE", "SETVALUE", =>
	
	If cAcao == "SETVALUE"
		//EXERCICIO FAZER A VALIDAÇÃO DO CAMPO Z3_QTD E Z3_VALOR
		If cCampo $ "Z3_QTD|Z3_VALOR" .AND. xValue <= 0
			Help (NIL, NIL, "Obrigatório", NIL, "O Campo valor ou Qtd Não possui valor", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			
			lRet :=.F.
			
		EndIf
	EndIf
	
Return lRet
//========================================================================================
//========================================================================================
Static Function fAtivaTela(oModel)
	Local lRet:= .T.
	If oModel:GetOperation() ==  MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
		If ! UPPER (ALLTRIM (SZ2->Z2_SOLICIT)) == UPPER (ALLTRIM (cUsername))
			lRet :=.F.
			Help (NIL, NIL, "Permissão", NIL, "Usuário não pode alterar o pedido: "+ SZ2->Z2_COD,;
				1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o adm do Sistemas"})
		EndIf
	EndIf
	
Return lRet
//========================================================================================
//========================================================================================
Static Function Grava(oModel)
	Local lRet:= .T.
	
	If FwFormCommit(oModel)
		If lRet
			//Envia email
		EndIf
	Else
		lRet := .F.
		Help (NIL, NIL, "Atenção", NIL, "Problema na Gravação do Pedido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o adm do Sistemas"})
	Endif
Return lRet
//========================================================================================
//========================================================================================
