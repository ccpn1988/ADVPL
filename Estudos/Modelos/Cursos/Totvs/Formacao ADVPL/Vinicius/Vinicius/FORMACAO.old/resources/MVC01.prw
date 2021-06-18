#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC01()

Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SA1")
	oBrowser:SetDescription("CADASTRO DE CLIENTE")

	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_MARRON","ATIVO")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_PINK", "DESATIVADO")
	oBrowser:Activate() //Ativando o obj

Return(Nil)

Static Function MenuDef()
	Local aRotina :=FwMVCMenu('MVC01') //cRIANDO OS BOTÕES VISUALIZAR,INCLUIR,ALTERAR,EXCLUIR,COPIAR,IMPRIMIR{}

Return (aRotina)



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

oStr1:AddTrigger ('A1_END', 'A1_ENDENT', {|| .T. }, {||M->A1_END})



oStr1:SetProperty('A1_END',MODEL_FIELD_TAMANHO,40)
oModel:addFields('MASTERSA1',,oStr1,{|oForm,cAcao,cCampo,xvalor|bPre(oForm,cAcao,cCampo,xvalor)},{|oBANANA|TUDOOK (oBanana)})
oModel:getModel('MASTERSA1'):SetDescription('Dados SA1')



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

 
Local oStr1:= FWFormStruct(2, 'SA1')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSA1' , oStr1,'MASTERSA1' ) 

oStr1:RemoveField( 'A1_FAX' )
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSA1','TELA')

Return oView


Static Function TUDOOK(oField)
Local lRet := .T.

If oField:GetValue("A1_EST") == "RJ"
	MsgInfo("Dados de outra empresa")
	Help(NIL,NIL,"UF",NIL, "Não temos operação nesse estado", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outra empresa"})
	lRet := .F.
eLSEiF oField:GetValue("A1_TIPO") <> "F"
	Help(NIL,NIL,"Tipo",NIL, "Não temos gente", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Procurar outra empresa"})
	lRet := .F.	
Endif

Return(lRet)	

Static Function bPre(oForm,cAcao,cCampo,xvalor)
Local lRet := .T.
if cAcao=='SETVALUE'
	If cCampo =="A1_EST" .AND. Xvalor == "RJ"
	Help (NIL,NIL,cCampo,NIL, "O Dado não é valido:" + xValor, 1, 0,;
	NIL, NIL, NIL, NIL, NIL, {"Informar outro valor"})
	lRet := .F.
ElseIf cCampo =="A1_TIPO" .AND. Xvalor <> "F" //TESTAR
	Help (NIL,NIL,cCampo,NIL, "O Dado não é valido:" + xValor, 1, 0,;
	NIL, NIL, NIL, NIL, NIL, {"Informar outro valor"})
	lRet := .F.
EndIf
Endif


rETURN(lRet)