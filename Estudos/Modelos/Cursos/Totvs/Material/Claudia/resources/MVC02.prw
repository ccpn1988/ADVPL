#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


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

 
Local oStr1:= FWFormStruct(2, 'SB1')
 
Local oStr2:= Nil
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSB1' , oStr1,'MASTERSB1' )




oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSB1','TELA')

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

 
Local oStr1:= Nil
 
Local oStr2:= FWFormStruct(1,'SB1')
oModel := MPFormModel():New('MDLSB1')
oModel:SetDescription('Cadastro de Produto')
oModel:addFields('MASTERSB1',,oStr2)
oModel:getModel('MASTERSB1'):SetDescription('DADOSSB1')



Return oModel