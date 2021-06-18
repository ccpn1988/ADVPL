#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC03()

Local oBrowser := FwMBrowse():NEW() // Novo Browse
Private INCLUI := .T. //

oBrowser:SetAlias("SZ2")
oBrowser:SetDescription("Cadastro modelo 3 MVC SZ2")
oBrowser:Activate()

Return
//--------------------------------------------------------------------

Static Function MenuDef()

Local aRotina := FwMVCMenu("MVC03") //FwMVCMenu - cria a barra de botoes automatica do browser
	
Return aRotina

//--------------------------------------------------------------------


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini��o do modelo de Dados

@author aluno

@since 20/10/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SZ2')
 
Local oStr2:= FWFormStruct(1,'SZ3')

Local bLinePre := {|oGrid,nLinha,cAcao,cCampo,xValor,xOldValor| ValCampo(oGrid,nLinha,cAcao,cCampo,xValor,xOldValor)}

oModel := MPFormModel():New('SZ2MODEL',,,,/*{|| fGrava() },*/ {|| fSair() }) // Fun��o de rollback ao clicar no botao cancelar para n�o trazer o proximo sequencial

oModel:SetDescription('Cadastro de algo')

oStr1:SetProperty('Z2_COD',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, 'GetSXeNum("SZ2","Z2_COD")'))// GetSXeNum - retorna o sequencial da tabela SZ2 | FWBuildFeature - mantem a contabilidade do fonte
oStr1:SetProperty('Z2_DATA',MODEL_FIELD_INIT,FWBuildFeature( STRUCT_FEATURE_INIPAD, "Date()")) //Retorna a data base do sistema


oStr1:SetProperty('Z2_DATA',MODEL_FIELD_OBRIGAT,.F.) // Define o campo data como n�o obrigatorio

oModel:addFields('MASTERSZ2',,oStr1) // Adiciona o field na tela

oStr2:AddTrigger( 'Z3_QTD'  , 'Z3_TOTAL', { || .T. }, {|oGRID| fGatilho(oGrid) }  ) // Adiciona um gatilho ao campo Z3_TOTAL disparado pela campo Z3_QTD
oStr2:AddTrigger( 'Z3_VALOR', 'Z3_TOTAL', { || .T. }, {|oGRID| fGatilho(oGrid) }  ) // Adiciona um gatilho ao campo Z3_TOTAL disparado pela campo Z3_VALOR

oModel:addGrid('DETAILSZ3','MASTERSZ2',oStr2,bLinePre,{|oGrid,nLinha|fLinhaOk(oGrid,nLinha)},,{|oGrid| fTudoOk(oGrid)}) // Adiciona o grid na tela
oModel:SetRelation('DETAILSZ3', { { 'Z3_FILIAL', 'Z2_FILIAL' }, { 'Z3_COD', 'Z2_COD' } }, SZ3->(IndexKey(1)) ) // Cria o relacionamento entre a tabela pai e filho
                                               // Pode ser usado a fun��o xFilial("SZ3")        IndexKey - ordena o indice em char



oModel:SetPrimaryKey({ 'Z2_COD' }) // Seta a chave primaria Z2_COD


oModel:getModel('MASTERSZ2'):SetDescription('Dados de algo')    //Descri��o do model
oModel:getModel('DETAILSZ3'):SetDescription('Dados do produto')
oModel:AddCalc( 'TOTALGERAL', 'MASTERSZ2', 'DETAILSZ3', 'Z3_TOTAL', 'TOTAL', 'SUM', /*bCondition*/, /*bInitValue*/,'Total do Pedido' /*cTitle*/, /*bFormula*/)

 //Descri��o do model




Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o do interface

@author aluno

@since 20/10/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SZ2')
 
Local oStr2:= FWFormStruct(2, 'SZ3')
 
Local oStr3:= FWCalcStruct( oModel:GetModel('TOTALGERAL') )

oStr2:SetProperty('Z3_ITEM',MVC_VIEW_ORDEM,'01') // Ordena o campo Z3_ITEM na posi��o 01



oView := FWFormView():New()

oView:SetModel(oModel)                          // Seta o model
oView:AddField('VIEWSZ2'  , oStr1,'MASTERSZ2' ) // Seta o field (enchoice) SZ2
oView:AddGrid ('VIEWSZ3'  , oStr2,'DETAILSZ3' ) // Sete o calc (total)
oView:AddField('VIEWTOTAL', oStr3,'TOTALGERAL') // Seta o grid (getdados) SZ3

oStr1:SetProperty('Z2_COD' ,MVC_VIEW_CANCHANGE,.F.) // Desabilita para n�o deixar da update (alterar) o codigo
oStr1:SetProperty('Z2_DATA',MVC_VIEW_CANCHANGE,.F.) // Desabilita para n�o deixar da update (alterar) a data

oView:CreateHorizontalBox( 'SZ2FORM' , 34) // Cria o Enchoice(Field)
oView:CreateHorizontalBox( 'BOXFORM3', 51) // Cria o grid (getdados)
oView:CreateHorizontalBox( 'BOXFORM5', 15) // Cria o total dos itens

oView:SetOwnerView('VIEWSZ2','SZ2FORM'   ) // Vincula a view do form
oView:SetOwnerView('VIEWSZ3','BOXFORM3'  ) // Vincula a view do box
oView:SetOwnerView('VIEWTOTAL','BOXFORM5') // Cria a view do total

oView:AddIncrementField('VIEWSZ3' , 'Z3_ITEM' ) // Incrementa o campo Z3_ITEM com um sequencial automatico 



Return oView

//-------------------------------------------------------------------------

Static Function fGatilho(oGrid)
Local nRet := 0

	nRet := Round (oGrid:GetValue("Z3_QTD") * oGrid:GetValue("Z3_VALOR"),2) //GetValue - pega o valor do campo na tela

Return nRet

//-------------------------------------------------------------------------

Static Function fTudoOk(oGrid) // Valida ao clicar no bot�o salvar
Local lRet := .T.
Local nLinha

For nLinha := 1 To oGrid:Length() //For que verifica da linha 1 at� o final do grid
    oGrid:GoLine(nLinha) // Informa a linha ao oGrid

//Execicio fazer a valida��o das linhas

	If ! oGrid:IsDeleted() // Verifica se a linha n�o esta deletada e faz a verifica��o abaixo
		
		If oGrid:GetValue("Z3_TOTAL") <= 0 // Verifica se o campo Z3_TOTAL � menor ou igual a 0
			
			Help(NIL, NIL, "Aten��o", NIL, "N�o � possivel salvar um pedido com itens com valor zerado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os itens do pedido."})
		    Return .F.
		    
		EndIf
		
	EndIF
	
Next nLinha // Pula para a proxima linha

Return lRet

//--------------------------------------------------------------------------

Static Function fLinhaOk(oGrid,nLinha) // Valida a linha
Local lRet := .T.

	If ! oGrid:IsDeleted() // Verifica se a linha n�o esta deletada e faz a verifica��o abaixo
		
		If oGrid:GetValue("Z3_TOTAL") <= 0 // Verifica se o campo Z3_TOTAL � menor ou igual a 0
			
			Help(NIL, NIL, "Aten��o", NIL, "N�o � possivel salvar um pedido com itens com valor zerado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os itens do pedido."})
		    Return .F.
		    
		EndIf
		
	EndIF

Return lRet

//--------------------------------------------------------------------------

Static Function ValCampo(oGrid,nLinha,cAcao,cCampo,xValor,xOldValor)
Local lRet := .T.

If cAcao == "SETVALUE" // Valida o campo na hora da digita��o

	If cCampo == "Z3_QTD" .AND. xValor <= 0

		Help(NIL, NIL, "Aten��o", NIL, "O campo 'Quantidade' n�o pode ser 0.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique a quantidade digitada no campo."})
		Return .F.
	
	ElseIf cCampo == "Z3_VALOR" .AND. xValor <= 0
	
		Help(NIL, NIL, "Aten��o", NIL, "O campo 'Valor' n�o pode ser 0.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique o valor digitado no campo."})
		Return .F.
		
	EndIf

EndIF

Return lRet

//-------------------------------------------------------------------------

Static Function fSair()
Local oModel := FWModelActive() //Fun��o que retorna o modelo ativo
Local lRet := .T.

	IF oModel:GetOperation() == MODEL_OPERATION_INSERT //GetOperation - pega a op��o (3 - incluir, 4 - alterar ou 5 - excluir)
		RollBackSX8()         //MODEL_OPERATION_INSERT == 3
	EndIf

Return lRet

//--------------------------------------------------------------------------

//Static Function fGrava()
//Local lRet   := .T.
//Local oModel := FWModelActive()
//
//	If FWFormCommit(oModel) //Grava os dados
//
//		If oModel:GetOperation() == MODEL_OPERATION_INSERT
//			
//			ConfirmSX8()
//		
//		EndIF
//	
//	Else
//	
//		Help(NIL, NIL, "Problema", NIL, "Ocorreu um erro na grava��o dos dados.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verifique os dados."})
//		lRet := .F.
//	
//	EndIF
//	
//Return lRet







