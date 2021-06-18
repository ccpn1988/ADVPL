#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC02()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SA1")
	oBrowser:setDescription("MVC - Cadastro de Produtos")
	/*LEGENDA DA TELA*/
	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_PINK", "Ativo")
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_VERDE", "Desativado")
	oBrowser:AddLegend("A1_MSBLQL==' '","BR_AZUL", "BRACO")
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()


Return (NIL)

/*SEMPRE NOSSOS BOTÔES RECEBERÀ ESTE NOME DESTA FUNCÂO POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Local aRotina := FwMVCMenu('MVC02')
	 //CRIANDO OS BOTÔES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'SB1')

oModel := MPFormModel():New('MDLSB1')
oModel:SetDescription('Cadastro de Produtos')
oModel:addFields('MASTERSB',,oStr1)

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
oView:AddField('VIEWSB1' , oStr1,'MASTERSB' ) 
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSB1','TELA')

Return oView