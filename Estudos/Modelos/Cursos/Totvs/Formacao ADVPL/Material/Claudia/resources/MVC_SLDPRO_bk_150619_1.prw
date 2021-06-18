#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC_SLDPRO()
Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SB1")
	oBrowser:SetDescription("Cadastro de Produto")	
	oBrowser:Activate() //Ativando o objeto

Return (NIL)

//===============================================

Static Function MenuDef()
Local aRotina := {}
	AADD( aRotina, {"Análise de Saldo" , 'VIEWDEF.MVC_SLDPRO', 0, 4 , 0} )
Return(aRotina)

//===============================================



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

 
Local oStr1:= Nil
 
Local oStr2:= mldoStr2Str()
 
Local oStr3:= FWFormStruct(1,'SB5')
oModel := MPFormModel():New('MDLPROD')
oModel:SetDescription('Dados do Produto')
oModel:addFields('MASTER',,oStr2)
oModel:addGrid('GRIDSB5','MASTER',oStr3)

oModel:SetPrimaryKey({ 'Codigo' })


//oModel:addGrid('GRID1SB1','MASTER',oStr2,,,,,)

oModel:getModel('MASTER'):SetDescription('Dados do Produto')
oModel:getModel('GRIDSB5'):SetDescription('Complemento do produto')




Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr2Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr2Str()
Local oStruct := FWFormModelStruct():New()
OSTRUCT:ADDTABLE('SB1',,'PRODUTO')
OSTRUCT:ADDFIELD('CODIGO','CODIGO DO PRODUTO' , 'B1_COD', 'C', 15, 0, , , {}, .F., , .F., .F., .T., , )
OSTRUCT:ADDFIELD('DESCRICAO','DESCRICAO DO PRODUTO' , 'B1_DESC', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
OSTRUCT:ADDFIELD('UNIDADE','UNIDADE DE MEDIDA' , 'B1_UM', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
OSTRUCT:ADDFIELD('GRUPO','GRUPO' , 'B1_GRUPO', 'C', 4, 0, , , {}, .F., , .F., .F., .T., , )
OSTRUCT:ADDFIELD('PARAMETRO','PARAMETRO' , 'PARAMETRO', 'C', 10, 0, , , {}, .F., , .F., .F., .T., , )





return oStruct

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
 
Local oStr1:= viewoStr1Str()
 
Local oStr2:= FWFormStruct(2, 'SB5')
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSB1' , oStr1,'MASTER' )
oView:AddGrid('FORM5' , oStr2,'GRIDSB5')  
oView:CreateHorizontalBox( 'TELASB1', 37)
oView:CreateHorizontalBox( 'BOX3', 63)
oView:CreateFolder( 'FOLDER4', 'BOX3')
oView:AddSheet('FOLDER4','SHEET5','Complemento')
oView:CreateHorizontalBox( 'BOXFORM5', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET5')
oView:SetOwnerView('FORM5','BOXFORM5')

oView:SetOwnerView('VIEWSB1','TELASB1')
//oView:AddGrid('FORMSB1' , oStr1,'MASTER')


//oView:SetOwnerView('FORMSB1','BOXProd')

Return oView
//-------------------------------------------------------------------

//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr1Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr1Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'B1_COD','1','CODIGO','CODIGO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_DESC','2','DESCRICAO','DESCRICAO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_UM','3','UNIDADE','UNIDADE',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_GRUPO','4','GRUPO','GRUPO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'PARAMETRO','5','PARAMETRO','PARAMETRO',, 'Get' ,,,,,,,,,,.T.,, )







return oStruct




