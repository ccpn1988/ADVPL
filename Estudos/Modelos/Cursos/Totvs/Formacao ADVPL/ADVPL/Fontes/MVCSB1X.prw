#Include 'Protheus.ch'
#Include 'FWEDITPANEL.CH'
#Include 'FWMVCDef.ch'

User Function MVCSB1X()

Local oBrowser := FwmBrowse():New()
	oBrowser:SetAlias("SB1")
	oBrowser:SetDescription("Cadastro de Produto")
	oBrowser:Activate() // Ativando o obj
Return( NIL )
//----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}
	
	AADD( aRotina, {"Pesquisar"  , "AxPesqui"     , 0, 1    } )
	AADD( aRotina, {"Visualizar" , 'VIEWDEF.MVCSB1X', 0, 2 , 0} )
//	AADD( aRotina, {"Incluir"    , 'VIEWDEF.MVC03', 0, 3 , 0} )
//	AADD( aRotina, {"Alterar"    , 'VIEWDEF.MVC03', 0, 4 , 0} )
//	AADD( aRotina, {"Excluir"    , 'VIEWDEF.MVC03', 0, 5 , 0} )
	
Return(aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel
 
Local oStr1:= FWFormStruct(1,'SB1', { |cFIELD| Campo(cFIELD)} )
Local oStr2:= FWFormStruct(1,'SB2', { |cFIELD| Campo(cFIELD)})
Local oStr3:= FWFormStruct(1,'SB5')

oStr1:AddField('MV_LOTVENC','Parametro' , 'PARAMETRO', 'C', 150, 0,FWBuildFeature( STRUCT_FEATURE_VALID, "GetMv('MV_LOTVENC')") , , {}, .F., , .F., .T., .T., , )


oModel := MPFormModel():New('MDSALDO')
oModel:SetDescription('Saldo do produto')




oModel:addFields('SB1MASTER',,oStr1)
oModel:addGrid('SB2DETAIL','SB1MASTER',oStr2)
oModel:addGrid('SB5DETAIL','SB1MASTER',oStr3)
oModel:SetRelation('SB5DETAIL', { { 'B5_FILIAL', 'B1_FILIAL' }, { 'B5_COD', 'B1_COD' } }, SB5->(IndexKey(1)) )



oModel:SetRelation('SB2DETAIL', { { 'B2_FILIAL', 'B1_FILIAL' }, { 'B2_COD', 'B1_COD' } }, SB2->(IndexKey(1)) )



oModel:SetPrimaryKey({ 'B1_COD' })
oModel:getModel('SB5DETAIL'):SetDescription('Complemento do Produto')





Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= FWFormStruct(2, 'SB1', {|cFIELD| Campo(cFIELD)})
Local oStr2:= FWFormStruct(2, 'SB2', { |cFIELD| Campo(cFIELD)})
Local oStr3:= FWFormStruct(2, 'SB5')

oView := FWFormView():New()

oView:SetModel(oModel)

oStr1:AddField( 'PARAMETRO','203','MV_LOTVENC','MV_LOTVENC',, 'Get' ,,,,,,,,,,.T.,, )


oView:AddField('VIEWSB1', oStr1,'SB1MASTER')
oView:AddGrid('VIEWSB2' , oStr2,'SB2DETAIL')
oView:AddGrid('VIEWSB5' , oStr3,'SB5DETAIL')
   
oView:CreateHorizontalBox( 'BOXSB1', 27)
oView:CreateHorizontalBox( 'BOXABA', 73)

oView:CreateFolder( 'FOLDER4', 'BOXABA')
oView:AddSheet('FOLDER4','SHEET_SALDO','Saldo do Produto')

oView:CreateHorizontalBox( 'BOXSB2', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET_SALDO')

oView:AddSheet('FOLDER4','SHEET_COMPL','Complemento')

oView:CreateHorizontalBox( 'BOXSB5', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET_COMPL')
oView:SetOwnerView('VIEWSB5','BOXSB5')
oView:SetOwnerView('VIEWSB2','BOXSB2')
oView:SetOwnerView('VIEWSB1','BOXSB1')


Return oView

//-------------------------------------------------------------------

Static Function Campo(cFIELD)
Local lret := .F.

If Alltrim( cFIELD ) $ 'B1_COD|B1_DESC|B1_LOCPAD|B1_UM'
	return .T.
Endif

If Alltrim( cFIELD ) $ 'B2_LOCALIZ|B2_LOCAL|B2_TIPO|B2_QATU|B2_RESERVA|B2_QEMP|B2_BLOQUEI'
	return .T.
Endif


return lRet






