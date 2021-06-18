#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC01()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SA1")
	oBrowser:setDescription("MVC - Cadastro de Clientes")
	/*LEGENDA DA TELA*/
	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_PINK", "Ativo")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_VERDE", "Desativado")
	oBrowser:AddLegend("A1_MSBLQL==' '","BR_AZUL", "BRACO")
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()


Return (NIL)

/*SEMPRE NOSSOS BOTÔES RECEBERÀ ESTE NOME DESTA FUNCÂO POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Local aRotina := FwMVCMenu('MVC01')
	 //CRIANDO OS BOTÔES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)
//-------------------------------------------------------------------//

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
oView:AddField('VIEWSA1' , oStr1,'MASTERSA' ) 

oStr1:RemoveField( 'A1_FAX' )
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSA1','TELA')

Return oView
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

 /*ASSOCIA QUAL O DICIONARIO DE DADOS SERÀ USADO - 1 - CARREGA OS DADOS DO MEU MODELO DE DADOS / 2 CARREGUE OS DADOS DA MINHA VIEW*/
Local oStr1:= FWFormStruct(1,'SA1')
/**/
oModel := MPFormModel():New('MDLSA1')
oModel:SetDescription('Cadastro de Cliente')
/*CRIANDO O MEU ENCHOICE - SEM OBJETO DEPENDENTE DELE ,,*/

/*DEFINIÇÂO DE CAMPO PARA REMOVER OU ATRIBUIR ALGO DIFERENTE DE X3 */
oStr1:SetProperty('A1_MUN',MODEL_FIELD_OBRIGAT,.F.)
oStr1:RemoveField( 'A1_FAX' )

oStr1:AddTrigger( 'A1_END', 'A1_ENDENT', { || .T. }, { ||fGatilho()} ) 

oStr1:SetProperty('A1_END',MODEL_FIELD_TAMANHO,40)
/*DEFININDO O MODEL COM SEU ID ,,*/


oModel:AddFields('MASTERSA',,oStr1,{|oForm, cAcao, cCampo, xValor| bPre(oForm,cAcao,cCampo,xValor)},{|OField| TUDOOK(OField)})
oModel:getModel('MASTERSA'):SetDescription('Dados SA1')
Return oModel

Static Function fGatilho
Local cRet := ""
//****** Retorna o Modelo Ativo ********
Local cModel := FWModelActive() //RETORNA o MODELO ATIVO
Local OField := oModel:getModel('MASTERSA') //RETORNA ESTRUTURA DO COMPONENTE
cRet := OField:getValue('A1_END') //RETORNA CONTEPÙDO DO CAMPO
//cRet := oModel:getModel('MASTERSA1','A1_END') //RETORNA CONTEPÙDO DO CAMPO
//cRet := oModel:getModel('MASTERSA1'):getValue('A1_END') //RETORNA CONTEPÙDO DO CAMPO
Return (cRet)

Static Function bPre(oForm,cAcao,cCampo,xValor)
Local lRet := .T.
	if cAcao == 'SETVALUE' 
		if cCampo == "A1_EST" .AND. xValor == "RJ" //CANSETVALUE - BLOQUEIA CAMPO
			Help(NIL, NIL, "UF", NIL, "Dado não Válido no campo Estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe outro estado"})
			lRet := .F.	
		Elseif cCampo == "A1_TIPO" .AND. xValor <> "F" 
			/*TRATANDO JANELA EXIBIDA AO ENCONTRAR O PROBLEMA*/
			Help(NIL, NIL, "Tipo de pessoa", NIL, "Não Trabalhamos com este Tipo De Pessoa", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurara uma outro Tipo para Trabalhar"})
			lRet := .F.
		EndIf	
	EndIf	
return lRet

/*TRATANDO CAMPO RECEBIDO DA  MINHA FOLHA DE DADOS*/
Static Function TUDOOK(OField)
Local lRet := .T.

if oField:getValue("A1_EST") == "RJ"
/*TRATANDO JANELA EXIBIDA AO ENCONTRAR O PROBLEMA*/
	 Help(NIL, NIL, "UF", NIL, "Não Trabalhamos com este Estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurara uma outra empresa em outro estado"})
	lRet := .F.
Elseif oField:getValue("A1_TIPO") <> "F"
	/*TRATANDO JANELA EXIBIDA AO ENCONTRAR O PROBLEMA*/
	Help(NIL, NIL, "Tipo de pessoa", NIL, "Não Trabalhamos com este Tipo De Pessoa", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurara uma outro Tipo para Trabalhar"})
	lRet := .F.
EndIf	

Return (lRet)