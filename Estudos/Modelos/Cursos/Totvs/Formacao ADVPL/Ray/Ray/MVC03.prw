#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------
User Function MVC03()
	
	Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SZ2")
	oBrowser:SetDescription("Cadastro de pedidos de Sucata")
	oBrowser:Activate() // Ativando o obj

Return( NIL )

//------------------------------------------------------------------------------


Static Function MenuDef()
	Local aRotina := FWMVCMenu('MVC03')//Criando os botões VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local bPos := {|oGrid,nLinha,cAcao,cCampo,xValue,xOldValue| ValDados(oGrid,nLinha,cAcao,cCampo,xValue,xOldvalue)}
 
Local oStr1:= FWFormStruct(1,'SZ2')
 
Local oStr2:= Nil
 
Local oStr3:= FWFormStruct(1,'SZ3')
oModel := MPFormModel():New('ModelName',,,{|oModel| Grava(oModel)})

oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, "GetSxeNum('SZ2','Z2_COD')"))

oModel:addFields('MasterSz2',,oStr1)
oModel:addGrid('GRIDSZ3','MasterSz2',oStr3,bPOS,{|oGrid,nLinha|,fLinhaOK(oGrid, nLinha)},,{|oGrid|fTudoOK(oGrid)})
oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_CODPRO' } )
oModel:SetRelation('GRIDSZ3', { { 'Z3_FILIAL', xFilial('SZ3')}, { 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )
oModel:SetPrimaryKey({'Z2_COD'})
oModel:getModel('GRIDSZ3'):SetDescription('Dados do Produto')

//oStr3:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. }, {|| fGatilho() } )
//oStr3:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || .T. }, {|| fGatilho() } )
//oStr3:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. }, {|oGrid| fGatilho(oGrid) } )
//oStr3:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || .T. }, {|oGrid| fGatilho(oGrid) } )

oStr3:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. }, {|oGrid| oGrid:GetValue('Z3_QTD')*oGrid:GetValue('Z3_VALOR') } )
oStr3:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || oModel:GetOperation()  == 3 }, ;
{|oGrid| oGrid:GetValue('Z3_QTD')*oGrid:GetValue('Z3_VALOR') } )  
oModel:AddCalc( 'CALC1', 'MasterSz2', 'GRIDSZ3', 'Z3_TOTAL', 'TOTALGERAL', 'SUM', ;
/*bCondition*/, /*bInitValue*/,'Total' /*cTitle*/, /*bFormula*/)
oModel:SetVldActivate({|oModel|,fAtivaTela(oModel)})

//Método GetOperation retorna a operação realizada no modelo 3 -> inclusão, 4 -> alterar, 5 -> excluir

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

Local oStr3:= FWFormStruct(2, 'SZ3')
Local oStr5:= FWFormStruct(2, 'SZ2')
 
Local oStr1:= FWCalcStruct( oModel:GetModel('CALC1') )
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSZ2' , oStr5,'MasterSz2' ) 
oView:AddGrid('VIEWSZ3' , oStr3,'GRIDSZ3')
oView:AddField('VIEWTOTAL', oStr1,'CALC1') 

oView:CreateHorizontalBox( 'BOXFORM3', 27)
oView:CreateHorizontalBox( 'BOXFORM2', 52)
oView:CreateHorizontalBox( 'Rodape', 21)
oView:SetOwnerView('VIEWTOTAL','Rodape')

oStr3:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')

oView:SetOwnerView('VIEWSZ2','BOXFORM3')
oView:SetOwnerView('VIEWSZ3','BOXFORM2')
oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' ) 


Return oView

//--------------------------------------------------------------------------------------

//Static Function fGatilho()
Static Function fGatilho(oGrid)

	Local cRet := ""
	cRet	:= oGrid:GetValue('Z3_QTD')*oGrid:GetValue('Z3_VALOR') //Retorna o conteudo do campo

//	Local oModel	:=	FWModelActive() //Retorna o modelo ativo
//	Local oField	:= oModel:GetModel('GRIDSZ3') //Retorna a estrutura do componente
//cRet	:=	oModel:GetModel('MASTERSA1'):GetValue('A1_END')

	
Return(cRet)

//--------------------------------------------------------------------------------------
Static function fTudoOK(oGrid)
	Local lRet 		:= .T.
	Local nLinha	:= 0
	
	For nLinha := 1 to oGrid:Length()
		oGrid:GoLine(nLinha)
		If oGrid:IsDeleted()
			Loop
		Endif
							
		If Empty( oGrid:GetValue("Z3_QTD")) .Or. Empty( oGrid:GetValue("Z3_VALOR"))
			Help(NIL, NIL, "Obrigatório", NIL, "O campo valor ou quantidade não possui valor", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			lRet := .F.
		Endif
	Next nLinha
		
Return(lRet)


//----------------------------------------------------------------------------
Static Function fLinhaOK(oGrid, nLinha)
	Local lRet := .T.
	
	If !oGrid:IsDeleted() .AND. (Empty( oGrid:GetValue("Z3_QTD")) .or. Empty(oGrid:GetValue("Z3_VALOR")))
		Help(NIL, NIL, "Obrigatório", NIL, "O campo valor ou quantidade não possui valor", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			lRet := .F.
		Endif
	
Return lRet

//----------------------------------------------------------------------------
/*Static Function ValDados(oGrid,nLinha,cAcao,cCampo,xValue,xOldvalue)
	Local lRet		:= .T.
//UNDELETE, DELETE, SETVALUE => cAcao

	oGrid:GoLine(nLinha)
	
	if cAcao == "SETVALUE"
		If !oGrid:IsDeleted() .AND. cCampo $ "Z3_QTD|Z3_VALOR" .AND. xVlaue <= 0
		Help(NIL, NIL, "Obrigatório", NIL, "O campo valor ou quantidade não possui valor", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			lRet := .F.
	EndIf	
	
	if cAcao == "UNDELETE"
		If cCampo $ "Z3_QTD|Z3_VALOR" .AND. xVlaue <= 0
		Help(NIL, NIL, "Obrigatório", NIL, "O campo valor ou quantidade não possui valor", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor válido"})
			lRet := .F.
	EndIf	

Return(lRet)
*/

Static Function fAtivaTela(oModel)
	Local lRet := .T.
	
	If oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
		If UPPER(ALLTRIM(SZ2 -> Z2_SOLICIT)) == UPPER(ALLTRIM(cUserName))
			Help(NIL, NIL, "Permissão", NIL, "O usuário não pode alterar um pedido que não criou", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {""})
			lRet := .F.
		endif
	Endif

	Return lRet
	
	//----------------------------------------------------------
	Static Function Grava(oModel)
		Local lRet := .T.
		
		If FwFormCommit(oModel) //Grava os dados do modelo
		
			If lRet
				//Envia e-mail
			Endif
		Else
			lRet := .F.
			Help(NIL, NIL, "Atenção", NIL, "Problema na gravação do pedido", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o adm do sistema"})
		Endif
	
	Return lRet	