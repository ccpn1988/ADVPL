#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC02()

Local oBrowser := FwMBrowse():NEW() // Novo Browse
Private INCLUI := .T. //

oBrowser:SetAlias("SB1")
oBrowser:SetDescription("Cadastro modelo 1 MVC SB1")
oBrowser:Activate()

Return
//--------------------------------------------------------------------

Static Function MenuDef()

Local aRotina := FwMVCMenu("MVC02") //FwMVCMenu - cria a barra de botoes automatica do browser
	
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
Local bPre := {|oField,cAcao,cCampo,xValor| ValDads(oField,cAcao,cCampo,xValor)}

 
Local oStr1:= FWFormStruct(1,'SB1')
oModel := MPFormModel():New('SB1MODEL')
oModel:SetDescription('Cadastro de produto')

oStr1:SetProperty('B1_POSIPI',MODEL_FIELD_OBRIGAT,.T.)
oStr1:SetProperty('B1_ORIGEM',MODEL_FIELD_OBRIGAT,.T.)

oModel:addFields('MASTERSB1',,oStr1,bPre)
oModel:getModel('MASTERSB1'):SetDescription('Dados do produto')



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
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SB1')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM1' , oStr1,'MASTERSB1' ) 

oStr1:RemoveField( 'B1_MSBLQL' )

oView:CreateHorizontalBox( 'SB1FORM', 100)
oView:SetOwnerView('FORM1','SB1FORM')

Return oView

//-------------------------------------------------------------------

Static Function ValDads(oField,cAcao,cCampo,xValor)
Local lRet := .T.

If cAcao == "SETVALUE"

	If cCampo == "B1_COD" .AND. "MOD" $ xValor  
	
		Help(NIL, NIL, "Atenção", NIL, "O campo codigo não pode conter a palavra MOD.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Altere o código de cadastro."})
	    lRet := .F.
	
	ElseIf cCampo == "B1_ORIGEM" .AND. ! xValor $ "0|1"
	
		Help(NIL, NIL, "Atenção", NIL, "O campo origem deve ser preenchido com 0 ou 1.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outra opção."})
	    lRet := .F.
	    
	EndIf
	
EndIf

Return (lRet)




