#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xMod3Mvc()
/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	Local oBrowser := FwmBrowse():New()
	
	oBrowser:setAlias("SZ2")
	oBrowser:setDescription("Pedido de Sucata")
	oBrowser:Activate()
return;

Static Function MenuDef()

Private aRotina   := {}
	//CRIANDO OS BOTÔES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR ATRAVES DO AROTINA
	AADD( aRotina, {"Pesquisar"  , "AxPesqui" , 0, 1           } )
	AADD( aRotina, {"Visualizar" , 'VIEWDEF.xMod3Mvc', 0, 2 , 0} )
	AADD( aRotina, {"Incluir"    , 'VIEWDEF.xMod3Mvc', 0, 3 , 0} )
	AADD( aRotina, {"Alterar"    , 'VIEWDEF.xMod3Mvc', 0, 4 , 0} )
	AADD( aRotina, {"Excluir"    , 'VIEWDEF.xMod3Mvc', 0, 5 , 0} )
	
	/* OBSERVAÇÕES
	   AADD( aRotina, {"FUNÇÂO CUSTOMIZADA"    , 'U_TELA', 0, 6 , 0}) NÂO SEGUE UMA SEQUENCIA - PORÉM PODEMOS COLOCAR
	   OU CHAMAR A FUNÇÂO DO MVC PARA CRIAR A ESTRUTURA 
	   Local aRotina := FwMVCMenu('xMvcMod3')
	*/
Return(aRotina)

Static Function ModelDef()
Local oModel
Local bPosGrid := {|oGrid,nLinha,cAcao,ccampo,xValue,xOldValue|ValDados(oGrid,nLinha,cAcao,xValue,xOldValue)}

Local oStr1:= FWFormStruct(1,'SZ2')
Local oStr2:= FWFormStruct(1,'SZ3')

oModel := MPFormModel():New('MDLSZ2',,,{|oModel|Grava(oModel)})
oModel:SetDescription('Mvc - Cadastro de Pedido de Sucata Mod3')

oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, 'GetSxeNum("SZ2","Z2_COD")'))
oModel:addFields('MASTERSZ2',,oStr1)

oModel:addGrid('GRIDSZ3','MASTERSZ2',oStr2,bPosGrid,{|oGrid,nLinha|fLinhaOk(oGrid,nLinha)},,{|oGrid| fTudoOk(oGrid)})
oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_CODPRO' } )


oModel:SetRelation('GRIDSZ3', {{ 'Z3_FILIAL', "xFilial('SZ3')" },{ 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )

oModel:SetPrimaryKey({})

oModel:getModel('MASTERSZ2'):SetDescription('Dados do Fornecedor')
oModel:getModel('GRIDSZ3'):SetDescription('Itens do Pedido')

/*FAZENDO POR FUNÇÂO - DISPARA - RECEBE - QUANDO FUNCIONARÀ - CHAMA O VALOR OU PASSA O VALOR*/
oStr2:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. }, { |oGRID|fGatilho(oGRID)} ) 
oStr2:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || oModel:GetOperation() == 3 }, {|oGRID|oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR")} ) 
oModel:SetVldActivate({|oModel|fAtivaTela(oModel)})


Return oModel
/*-------------------------------------------------------------------
{Protheus.doc} ViewDef
Definição do interface
-------------------------------------------------------------------*/

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
 
Local oStr1:= FWFormStruct(2, 'SZ2')
Local oStr2:= FWFormStruct(2, 'SZ3')
 
Local oStr3:= FWFormStruct(2, 'SZ3')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORMTELA' , oStr1,'MASTERSZ2' )
oView:AddGrid('FORMGRID' , oStr3,'GRIDSZ3') 

/*CRIANDO OS COMPONENTES PARA MONTAR A TELA*/
oView:CreateHorizontalBox( 'TELA_SZ2', 50)
oView:CreateHorizontalBox( 'BOXFORM3', 50)

/*MUDANDO A ORDEM A SER EXIBIDA*/
oStr3:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01')

/*VINCULANDO MEUS FORMS AO VIEW*/
oView:SetOwnerView('FORMTELA','TELA_SZ2')
oView:SetOwnerView('FORMGRID','BOXFORM3')
/*INCREMENTANDO AO COLOCAR PARA BAIXO NO ITEM*/
oView:AddIncrementField('FORMGRID' , 'Z3_ITEM' ) 

Return oView

Static Function fGatilho(oGrid)
Local nTotal
nTotal := oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR")
Return nTotal


Static Function fTudoOk(oGrid)
Local lRet := .T.
Local nLinha := 0

For nLinha := 1 To oGrid:Length()
	oGrid:GoLine(nLinha)
	
	If oGrid:IsDeleted()
		Loop
	Endif
	
	If Empty(oGrid:GetValue("Z3_QTD") ) .OR. Empty ( oGrid:GetValue("Z3_VALOR"))
		Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou quantidade não possui valor",;
		 	 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor valido"})
		lRet := .F.
	EndIf
  Next nLinha
  
  
  
 Static Function fLinhaOk(oGrid,nLinha)
 Local lRet := .T.
 
 If ! oGrid:IsDeleted() .AND.(Empty (oGrid:GetValue("Z3_QTD") ) .OR. Empty ( oGrid:GetValue("Z3_VALOR")))
		Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou quantidade não possui valor",;
		 	 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe um valor valido"})
		lRet := .F.	
 EndIf
 
Return lRet 		
Static Function ValDados(oGrid,nLinha,cAcao,xValue,xOldValue)
Local lRet := .T.
 
 //UNDELETE", "DELETE", "SETVALUE" =>
	if cAcao == 'SETVALUE' 
		if cCampo $ "Z3_QTD|Z3_VALOR" .AND. xValue <= 0  //CANSETVALUE - BLOQUEIA CAMPO
			Help(NIL, NIL, "Obrigatorio", NIL, "O campo valor ou qtd não possui valor",; 
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar um valor valido"})
			lRet := .F.	
		EndIf	
	EndIf
	//Exercicio fazer a validação do campo Z3_QTD e Z3_VALOR
	
Return lRet

//pagina 258

Static Function fAtivaTela(oModel)
Local lRet := .T.

If oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
	If UPPER (Alltrim(SZ2->Z2_SOLICIT)) == UPPER(Alltrim(cUsername))
		lRet := .F.
			Help(NIL, NIL, "Obrigatorio", NIL, "Usuario não pode alterar o pedido:"+ SZ2->Z2_COD,; 
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Não possui Permissão"})
	Endif

EndIf
Return lRet

Static Function Grava(oModel)
Local lRet := .T.

	If FWFormCommit(oModel) //grava os dados do modelo
		If lRet
		//Envia email
		EndIf
	Else
		lret := .F.
		Help(NIL, NIL, "Atenção", NIL, "Problema na gravação do pedido",; 
					1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o adm do sistemas"})
	EndIf
Return lRet


