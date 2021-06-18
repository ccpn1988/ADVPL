#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC_SLDPRO()
Local oBrowser := FwmBrowse():New()

	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SB1")
	oBrowser:setDescription("MVC - Cadastro de Produto")
	
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()

Return (NIL)
//-------------------------------------------------------------------------

Static Function MenuDef()
	Local aRotina :={}
AADD( aRotina, {"Analise de Saldo" , "VIEWDEF.MVC_SLDPRO",0 ,4, 0})
Return(aRotina)

//-------------------------------------------------------------------

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

 
Local oStr1:= mldoStr1Str()
 
Local oStr2:= mldoStr2Str()
oModel := MPFormModel():New('MASTER')
oModel:SetDescription('Cadastro de Produto')
oModel:addFields('FIELDSB1',,oStr1,,,{|oFIELD,lCopy|fLoadSB1(oFIELD,lCopy)})
oModel:addGrid('GRIDSB2','FIELDSB1',oStr2)

oModel:getModel('FIELDSB1'):SetDescription('PRODUTOS')



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

 
Local oStr1:= viewoStr1Str()
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FORMSB1' , oStr1,'FIELDSB1' ) 
oView:CreateHorizontalBox( 'BOX1', 100)
oView:SetOwnerView('FORMSB1','BOX1')

Return oView
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
oStruct:AddField( 'B1_PARAMETRO','2','PARAMETRO','PARAMETRO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_DESC','3','Descricao','Descricao',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_UM','4','UNIDADE','UNIDADE',, 'Get' ,,,,,,,,,,.T.,, )

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr1Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr1Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('SB1',,'PRODUTOS')
oStruct:AddField('CODIGO','CODIGO' , 'B1_COD', 'C', 15, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('PARAMETRO','PARAMETRO' , 'B1_PARAMETRO', 'C', 150, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Descricao','DESCRICAO' , 'B1_DESC', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('UNIDADE','UNIDADE' , 'B1_UM', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )




return oStruct

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
oStruct:AddTable('SB2',,'SALDO')
oStruct:AddField(, , 'B2_COD', 'C', 0, 0, , , {}, .F., , .F., .F., .F., , )
oStruct:AddField(, , 'B2_LOCAL', 'C', 0, 0, , , {}, .F., , .F., .F., .F., , )
oStruct:AddField(, , 'FIELD3', 'C', 0, 0, , , {}, .F., , .F., .F., .F., , )



return oStruct
