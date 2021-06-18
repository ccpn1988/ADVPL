#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xMod3Mvc()
/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	Local oBrowser := FwmBrowse():New()
	
	oBrowser:setAlias("SZ2")
	oBrowser:setDescription("Pedido de Sucata - ANTES DE ATIVAR O MODEL")
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
Local bPosGrid := {|oGrid, nLinha, cAcao, cCampo, xValue, xOldValue| ValDados(oGrid, nLinha, cAcao, cCampo, xValue, xOldValue)}

Local oStr1:= FWFormStruct(1,'SZ2')
Local oStr2:= FWFormStruct(1,'SZ3')

oModel := MPFormModel():New('MDLSZ2',,,{|oModel| fGrava(oModel)})
oModel:SetDescription('Mvc - Cadastro de Pedido de Sucata Mod3')
/*ATRIBUINDO PARA O CAMPO COD COM INICIALIZADOR PADRÃO - A FUNÇÂO FWBUILDFEATURE FAZ O CONTROLE DO SEQUENCIAL, NÂO PRECISA DO CONFIRM OU ROLLBACK*/
oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, 'GetSxeNum("SZ2","Z2_COD")'))

oStr1:SetProperty('Z2_COD',MODEL_FIELD_OBRIGAT,.F.)
oModel:addFields('MASTERSZ2',,oStr1)

oModel:addGrid('GRIDSZ3','MASTERSZ2',oStr2,bPosGrid,{|oGrid,nLinha|fTudoOk(oGrid,nLinha)},,{|oGrid|fTudoOk(oGrid)})
oModel:GetModel('GRIDSZ3'):SetUniqueLine( { 'Z3_CODPRO' } )

oModel:SetRelation('GRIDSZ3', {{ 'Z3_FILIAL', "xFilial('SZ3')" },{ 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) )

oModel:SetPrimaryKey({})

oModel:getModel('MASTERSZ2'):SetDescription('Dados do Fornecedor')
oModel:getModel('GRIDSZ3'):SetDescription('Itens do Pedido')

/*FAZENDO POR FUNÇÂO - DISPARA - RECEBE - QUANDO FUNCIONARÀ - CHAMA O VALOR OU PASSA O VALOR*/
oStr2:AddTrigger( 'Z3_QTD', 'Z3_TOTAL', { || .T. }, { |oGRID|fGatilho(oGRID)} ) 
oStr2:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || oModel:GetOperation() == 3 }, {|oGRID|oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR")} ) 
oModel:AddCalc( 'CALCTOTAL', 'MASTERSZ2', 'GRIDSZ3', 'Z3_TOTAL', 'TOTALIZADOR', 'SUM', /*bCondition*/, /*bInitValue*/,'Total :' /*cTitle*/, /*bFormula*/)
oModel:SetVldActivate({|oModel| fAtivaTela(oModel)})

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
 
Local oStr4:= FWFormStruct(2, 'SZ2')
 
Local oStr5:= FWCalcStruct( oModel:GetModel('CALCTOTAL') )
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORMTELA' , oStr1,'MASTERSZ2' )
oView:AddGrid('FORMGRID' , oStr3,'GRIDSZ3')
oView:AddField('FORMCALC', oStr5,'CALCTOTAL')


/*CRIANDO OS COMPONENTES PARA MONTAR A TELA*/
oView:CreateHorizontalBox( 'TELA_SZ2', 42)
oView:CreateHorizontalBox( 'BOXFORM3', 42)
oView:CreateHorizontalBox( 'BOXFORM5', 16)
oView:SetOwnerView('FORMCALC','BOXFORM5')



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

	for nLinha := 1 To oGrid:Length()
		oGrid:Goline(nLinha)
		if oGrid:IsDeleted()
			Loop
		EndIf	
		
		if Empty(oGrid:GetValue("Z3_QTD")) .OR. Empty(oGrid:GetValue("Z3_VALOR"))
			lRet := .F.
			Help(NIL, NIL, "Obrigatório", NIL, "Verifar campos com valores em branco ou zerados", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe um valor para a quantidade e o campo Valor"})           
		endIf
	Next nLinha

Return (lRet)

Static Function fLinhaOk(oGrid, nLinha)
Local lRet := .T.
	if ! oGrid:IsDeleted()
		if Empty(oGrid:GetValue("Z3_QTD")) .OR. Empty(oGrid:GetValue("Z3_VALOR"))
			lRet := .F.
			Help(NIL, NIL, "Obrigatório", NIL, "Verifar campos com valores em branco ou zerados", ;
			1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe um valor para a quantidade e o campo Valor"})           
		endIf
	endIf	
Return (lRet)

Static Function valDados(oGrid, nLinha, cAcao, cCampo, xValue, xOldValue)
Local lRet := .T.

	/*
		bLinePre 
		Bloco de Código de pre-edição da linha do grid. O bloco é invocado na deleção de linha, no undelete da linha e 
		nas tentativas de atribuição de valor. Recebe como parametro o objeto de modelo do FormGrid(FWFormGridModel), 
		o número da linha atual e a identificação da ação. A Identificação da ação pode ser um dos seguintes itens: 
		"UNDELETE", "DELETE", "SETVALUE" - nesse caso, serão passados mais três parametros. 
		O 4º parametro é o identificador do campo que está sendo atualizado, o 5º parametro é o valor que está sendo 
		atribuido e o 6º parametro é o valor que está atualmente no campo. "CANSETVALUE" - nesse caso será passado 
		mais um parametro. O 4º parametro é o identificador do campo que está tentando ser atualizado. O retorno do 
		bloco deve ser um valor lógico que indique se a linha está valida para continuar com a ação. Se retornar 
		verdadeiro, executa a ação do contrário atribui um erro ao Model. 
	*/
	if cAcao == "SETVALUE"
	
		if cCampo $ "Z3_QTD|Z3_VALOR" .AND. xValue <= 0 //CANSETVALUE - BLOQUEIA CAMPO
				Help(NIL, NIL, "QUANTIDADE JUNTAS", NIL, "Dado não Válido no Quantidade", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a quantidade corretao"})
				lRet := .F.	
		/*Elseif cCampo == "Z3_QTD" .AND. xValue <= 0 //CANSETVALUE - BLOQUEIA CAMPO
				Help(NIL, NIL, "QUANTIDADE", NIL, "Dado não Válido no Quantidade", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe a quantidade corretao"})
				lRet := .F.	
				
		Elseif cCampo == "Z3_VALOR" .AND. xValue <= 0 //CANSETVALUE - BLOQUEIA CAMPO
				Help(NIL, NIL, "VALOR", NIL, "Dado não Válido para o Valor", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe o Valor corretao"})
				lRet := .F.	*/
		EndIf	
	EndIf
Return (lRet)

Static Function fAtivaTela(oModel)
Local lRet := .T.
	if oModel:GetOperation() == MODEL_OPERATION_UPDATE .OR. oModel:GetOperation() == MODEL_OPERATION_DELETE
		if UPPER(AllTrim(SZ2->Z2_SOLICIT)) == UPPER(AllTrim(cUsername))
			lRet := .F.	
			Help(NIL, NIL, "USUÀRIO NÂO PERMITIDO", NIL, "Usuário Invalido", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Favor alterar para o Usuário que realizou a inclusão"})		
		EndIf
	EndIf
Return (lRet)

Static Function fGrava(oModel)
Local lRet := .T.
	
	/*AO CRIAMOS ESTA ROTINA PARAMOS DE GRAVAR OS DADOS AUTOMATICAMENTE, PRECISAMOS VOLTAR COM ESTA
	ATRAVES DA FUNÇÂO FWFORMCOMMIT(oModel)*/
	If FWFormCommit(oModel)
		If lRet
			// Envia email;
		EndIf
	Else	
		lRet := .F.	
		Help(NIL, NIL, "Atenção", NIL, "Problema na Gravação", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informar o problema para o Adm do Sistemas"})		
	EndIf
Return (lRet)
