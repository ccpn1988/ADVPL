#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC01()

	Local oBrowse	:= FwmBrowse():New()
		
	oBrowse:SetAlias("SA1")	// Qual tabela vou usar
	oBrowse:SetDescription("Cadastro de Cliente MVC") //Qual a descrição do meu browse
	oBrowse:AddLegend("A1_MSBLQL == '2'","BR_MARRON","Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("A1_MSBLQL <> '2'","BR_PINK"	,"Desativado")	//Adiciona legenda
	oBrowse:Activate()	// Ativa o OBJETO
	
Return(Nil)
	
Static Function MenuDef()
	Local aRotina	:= FwMVCMenu('MVC01')
Return (aRotina)


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

oStr1:AddTrigger( 'A1_END', 'A1_ENDENT', { || .T. }, {|| fGatilho}  )

oStr1:SetProperty('A1_END',MODEL_FIELD_TAMANHO,40)
oModel:addFields('MASTERSA1',,oStr1,{|oForm,cAcao,cCampo,xValor| bPre(oForm,cAcao,cCampo,xValor) },{|oBanana|TUDOOK(oBanana)}) //Enchoice
oModel:getModel('MASTERSA1'):SetDescription('Dados SA1')

Return oModel

//-----------------------------------------------------------------------------------------------------------
Static Function fGatilho
Local cRet		:= ""
Local oModel	:= FwModelActive() // Retorna o modelo ativo
Local oFields	:= oModel:GetModel("MASTERSA1")	//Retorna a estrutura do componente

cRet	:= oField:GetValue('A1_END')						// Retorna o conteúdo do campo
//cRet	:= oModel:GetValue('MASTERSA1','A1_END')			// Retorna o conteúdo do campo
//cRet	:= oModel:GetModel('MASTERSA1'):GetValue('A1_END')	// Retorna o conteúdo do campo

Return( cRet )

//-----------------------------------------------------------------------------------------------------------
Static Function TUDOOK(oField)
Local lRet	:= .T.

If oField:GetValue("A1_EST") == "RJ"
	//MsgInfo("Dados de outra empresa")
	Help(NIL,NIL,"Unidade Federativa",NIL,"Não temos operação nesse estado",1,0,NIL,NIL,NIL,NIL,NIL,{"Procurar outra empresa"})
	lRet	:= .F.
ElseIf ! oField:GetValue("A1_TIPO") == "F" //Diferente de consumidor final
	Help(NIL,NIL,"Tipo do cliente",NIL,"Tipo de cliente inválido",1,0,NIL,NIL,NIL,NIL,NIL,{"Utilize o tipo F-Consumidor Final"})
	lRet	:= .F.
EndIf

Return (lRet)

//-----------------------------------------------------------------------------------------------------------
Static Function bPre(oForm,cAcao,cCampo,xValor)
Local lRet	:= .T.
// cAcao	CANSETVALUE e SETVALUE

If cAcao == "SETVALUE"
	If cCampo == "A1_EST" .AND. xValor == "RJ"
		Help(NIL,NIL,cCampo,NIL,"O dado não é válido" + xValor,1,0,;
			 NIL,NIL,NIL,NIL,NIL,{"Informar outro valor"})
		lRet	:= .F.
	ElseIf cCampo == "A1_TIPO" .AND. ! xValor == "F"
		Help(NIL,NIL,cCampo,NIL,"O dado não é válido" + xValor,1,0,;
			 NIL,NIL,NIL,NIL,NIL,{"Informar outro valor"})
	EndIf
EndIf

Return (lRet)