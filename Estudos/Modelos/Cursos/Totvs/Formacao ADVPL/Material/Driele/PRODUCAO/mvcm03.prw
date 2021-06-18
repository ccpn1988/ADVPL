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

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= Nil
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddGrid('FORM1' , oStr1) 
oView:CreateHorizontalBox( 'BOXFORM1', 100)
oView:SetOwnerView('FORM1','BOXFORM1')

Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 25/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SZ2')
oModel := MPFormModel():New('ZZ2')
oModel:addFields('FIELD1',,oStr1)

Return oModel