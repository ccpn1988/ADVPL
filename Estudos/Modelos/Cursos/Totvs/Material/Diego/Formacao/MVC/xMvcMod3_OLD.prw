#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function xMvcMod3()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SZ3")
	oBrowser:setDescription("MVC - Modelo 3")
	oBrowser:Activate()


Return (NIL)

/*SEMPRE NOSSOS BOT�ES RECEBER� ESTE NOME DESTA FUNC�O POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Local aRotina := FwMVCMenu('xMvcMod3')
	 //CRIANDO OS BOT�ES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR
Return(aRotina)

Static Function ModelDef()
Local oModel
Local oStr1:= FWFormStruct(1,'SZ2')

oModel := MPFormModel():New('MDLSZ2')
oModel:SetDescription('Cadastro de Sucatas')

oStr1:SetProperty('Z2_COD',MODEL_FIELD_KEY,.F.)
oModel:addFields('MASTERSZ2',,oStr1)
oModel:SetPrimaryKey({ 'Z2_COD' })

Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Defini��o do interface

@author aluno

@since 11/05/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()
 
Local oStr1:= FWFormStruct(2, 'SZ2')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSZ2' , oStr1,'MASTERSZ2' ) 
oView:CreateHorizontalBox( 'TELA', 100)
oView:SetOwnerView('VIEWSZ2','TELA')

Return oView