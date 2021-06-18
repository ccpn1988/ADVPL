#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


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

 
Local oStr1:= FWFormStruct(1,'MASTERSZ2')
 
Local oStr2:= Nil
oModel := MPFormModel():New('MVCmod3')
oModel:addFields('MASTERSZ2',,oStr1)



Return oModel
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

 
Local oStr1:= FWFormStruct(2, 'MASTERSZ2')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORMSZ2' , oStr1,'MASTERSZ2' ) 
oView:CreateHorizontalBox( 'BOXFORM1', 100)
oView:SetOwnerView('FORMSZ2','BOXFORM1')

Return oView