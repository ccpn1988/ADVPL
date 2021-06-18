#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

User Function MVCSB1()

Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SB1")
	oBrowser:SetDescription("MVC CADASTRO DE PRODUTOS")

	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_MARRON","ATIVO")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_PINK", "DESATIVADO")
	oBrowser:Activate() //Ativando o obj

Return(Nil)

Static Function MenuDef()
	Local aRotina :=FwMVCMenu('MVCSB1') //cRIANDO OS BOTÕES VISUALIZAR,INCLUIR,ALTERAR,EXCLUIR,COPIAR,IMPRIMIR{}

Return (aRotina)



Static Function ModelDef()
Local oModel

 
Local oStr1:= FWFormStruct(1,'SB1')
oModel := MPFormModel():New('ModelName')
oModel:addFields('MASTERSB1',,oStr1)
oModel:getModel('MASTERSB1'):SetDescription('DADOS SB1')


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
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('FORM1','TELA')

Return oView