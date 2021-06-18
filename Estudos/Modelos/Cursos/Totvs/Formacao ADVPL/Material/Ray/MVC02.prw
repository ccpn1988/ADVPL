#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------
User Function MVC02()
	
	Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SB1")
	oBrowser:SetDescription("Cadastro do Produto")
	oBrowser:Activate() // Ativando o obj

Return( NIL )

//------------------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina := FWMVCMenu('MVC02')//Criando os botões VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

//------------------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SB1')
oModel := MPFormModel():New('MDLSB1')
oModel:addFields('MASTERSB1',,oStr1)
oModel:getModel('MASTERSB1'):SetDescription('cadastro de produtos')
oModel:SetDescription('Cadastro de produtos')



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

 
Local oStr1:= FWFormStruct(2, 'SB1')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORM1' , oStr1,'MASTERSB1' ) 
oView:CreateHorizontalBox( 'BOXFORM1', 100)
oView:SetOwnerView('FORM1','BOXFORM1')

Return oView