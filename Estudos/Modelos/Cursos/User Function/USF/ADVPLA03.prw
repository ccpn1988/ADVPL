#Include 'Protheus.ch'
#Include 'Parmtype.ch'
#include "FWMVCDEF.CH"
/*/{Protheus.doc} ADVPLA03
//Fonte para cadastro de contas
@author Rodrigo
@since 05/10/2018
@version 1.0
/*/
User Function ADVPLA03()
	Local oBrowse
	//Montagem do Browse principal	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZ3')
	oBrowse:SetDescription('Cadastro de Contas')
	oBrowse:SetMenuDef('ADVPLA03')
	oBrowse:Activate()
Return

//Montagem do menu 
Static Function MenuDef()
	Local aRotina := {}

	aAdd( aRotina, { 'Visualizar'	, 'VIEWDEF.ADVPLA03'	, 0, 2, 0, NIL } ) 
	aAdd( aRotina, { 'Incluir' 		, 'VIEWDEF.ADVPLA03'	, 0, 3, 0, NIL } )
	aAdd( aRotina, { 'Alterar' 		, 'VIEWDEF.ADVPLA03'	, 0, 4, 0, NIL } )
	aAdd( aRotina, { 'Excluir' 		, 'VIEWDEF.ADVPLA03'	, 0, 5, 0, NIL } )
	aAdd( aRotina, { 'Imprimir' 	, 'VIEWDEF.ADVPLA03'	, 0, 8, 0, NIL } )
	aAdd( aRotina, { 'Copiar' 		, 'VIEWDEF.ADVPLA03'	, 0, 9, 0, NIL } )

Return aRotina

//Construcao do mdelo
Static Function ModelDef()
	Local oModel
	Local oStruZZ3 := FWFormStruct(1,"ZZ3")

	oModel := MPFormModel():New("MD_ZZ3") 
	oModel:addFields('MASTERZZ3',,oStruZZ3)
	oModel:SetPrimaryKey({'ZZ3_FILIAL', 'ZZ3_CODIGO'})

Return oModel

//Construcao da visualizacao
Static Function ViewDef()
	Local oModel := ModelDef()
	Local oView
	Local oStrZZ3:= FWFormStruct(2, 'ZZ3')

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM_ZZ3' , oStrZZ3,'MASTERZZ3' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_ZZ3', 100)
	oView:SetOwnerView('FORM_ZZ3','BOX_FORM_ZZ3')

Return oView
