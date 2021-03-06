#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function mvc01()
Local oBrowser := FwmBrowse():New()
oBrowser:SetAlias("SA1")
oBrowser:SetDescription("Cadastro de Cliente")
oBrowser:AddLegend("A1_MSBLQL == '2'", "BR_MARRON","Ativo")
oBrowser:AddLegend("A1_MSBLQL == '1'", "BR_PINK","Desativado")
oBrowser:Activate() //Ativando o objeto

Return(NIL)

Static Function MenuDef() //Barra de bot?es
Local aRotina:=FwMVCMenu('mvc01')//Criando os bot?es visualizar, incluir, alterar, excluir, copiar, imprimir
Return(aRotina)



//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini??o do interface

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
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSA1','TELA')

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Defini??o do modelo de Dados

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SA1')
oModel := MPFormModel():New('MDLSA1')
oModel:SetDescription('Cadastro de Cliente ')
oModel:addFields('MASTERSA1',,oStr1)
oModel:getModel('MASTERSA1'):SetDescription('Dados SA1')



Return oModel