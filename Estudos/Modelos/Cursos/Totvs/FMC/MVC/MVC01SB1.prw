#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function MVC01SB1()

	Local oBrowse	:= FwmBrowse():New()
		
	oBrowse:SetAlias("SB1")	// Qual tabela vou usar
	oBrowse:SetDescription("Cadastro de ProdutosMVC") //Qual a descrição do meu browse
	oBrowse:AddLegend("B1_MSBLQL == '2'","BR_MARRON","Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("B1_MSBLQL <> '2'","BR_PINK"	,"Desativado")	//Adiciona legenda
	oBrowse:Activate()	// Ativa o OBJETO
	
Return(Nil)
	
Static Function MenuDef()
	Local aRotina	:= FwMVCMenu('MVC01SB1')
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

 
Local oStr1:= FWFormStruct(1,'SB1')
oModel := MPFormModel():New('MDLSB1')
oModel:SetDescription('Cadastro de Produto')
oModel:addFields('MASTERSB1',,oStr1)
oModel:getModel('MASTERSB1'):SetDescription('Dados SB1')



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
oView:AddField('VIEWSB1' , oStr1,'MASTERSB1' ) 
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSB1','TELA')

Return oView