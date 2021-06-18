#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC01()

Local oBrowser := FwMBrowse():NEW() // Novo Browse
Private INCLUI := .T. //

oBrowser:SetAlias("SA1")
oBrowser:SetDescription("Cadastro modelo 1 MVC SA1")
oBrowser:Activate()

Return
//--------------------------------------------------------------------

Static Function MenuDef()
Local aRotina := {}
	
	 aRotina := {;
				{ "Pesquisar"  , "AxPesqui"   , 0, 1},;
				{ "Visualizar" , "VIEWDEF.MVC01", 0, 2},; // Chamada padrão para MVC
				{ "Incluir"    , "VIEWDEF.MVC01", 0, 3},; 
				{ "Alterar"    , "VIEWDEF.MVC01", 0, 4},;  
				{ "Exlcuir"    , "VIEWDEF.MVC01", 0, 5}; 
				}

Return aRotina


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 20/10/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
Local bPre := {|oField,cAcao,cCampo,xValor| ValDados(oField,cAcao,cCampo,xValor)} //oField - retorna o bloco | cAcao - retorna a ação | cCampo - retorna o campo | xValor - retorna o valor

 
Local oStr1:= FWFormStruct(1,'SA1') // Carrega os dicionarios para o modelo | 1 - tras as validações de dados dos campos
oModel := MPFormModel():New('SA1MODEL') // Cria o modelo
oModel:SetDescription('Cadastro de Clientes') // Da um apelido

oStr1:SetProperty('A1_CEP' ,MODEL_FIELD_OBRIGAT,.T.) // Torna o campo A1_CEP obrigatorio
oStr1:SetProperty('A1_NOME',MODEL_FIELD_OBRIGAT,.F.) // Torna o campo A1_NOME não obrigatorio


oStr1:RemoveField( 'A1_FAX' )   // Remove o campo do model
oStr1:RemoveField( 'A1_TELEX' ) // Remove o campo do model

oModel:addFields('MASTERSA1',,oStr1,bPre,{||TUDOOK()}) // Cria o componente mastersa1 | TUDOOK - valida os dados
oModel:getModel('MASTERSA1'):SetDescription('Dados do cliente') // Carega os modelos de dados



Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 20/10/2018
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView //Cria a view
Local oModel := ModelDef() //Cria o modelo ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SA1') //Carrega os dicionarios para o modelo | 2 tras as validações da VIEW
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSA1' , oStr1,'MASTERSA1' ) //Adicona a VIEW no dicionario oStr1 para o componente MASTERSA1 

oStr1:RemoveField( 'A1_FAX' )

oStr1:RemoveField( 'A1_TELEX' )
oView:CreateHorizontalBox( 'SA1FORM', 100) //Cria o box
oView:SetOwnerView('VIEWSA1','SA1FORM') //Associa o objeto componente a tela

Return oView

//--------------------------------------------------------------------

Static Function TUDOOK()
Local lRet   := .T.
Local oModel := FwModelActive() // Retorna o modelo ativo
Local oField := oModel:getModel('MASTERSA1') // Puxa os dados que estão no componente MASTERSA1

If oField:GetValue("A1_EST") == "RJ"

	//MsgAlert("Atenção! Não trabalhamos com clientes do Rio de Janeiro.")
	Help(NIL, NIL, "Atenção", NIL, "Não trabalhamos com clientes do Rio de Janeiro.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outro estado."})
	lRet := .F.
EndIf

Return (lRet)

//--------------------------------------------------------------------

Static Function ValDados(oField,cAcao,cCampo,xValor)
Local lRet := .T.

If cAcao == "SETVALUE"

	If cCampo == "A1_EST" .AND. xValor == "RJ"
	
		Help(NIL, NIL, "Atenção", NIL, "Não trabalhamos com clientes do Rio de Janeiro.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outro estado."})
	    lRet := .F.
	    
	EndIf	

EndIf

Return (lRet)



