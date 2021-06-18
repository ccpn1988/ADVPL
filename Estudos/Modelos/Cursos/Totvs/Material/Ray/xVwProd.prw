#Include 'Protheus.ch'
#INCLUDE 'FWEDITPANEL.CH'
#Include 'FWMVCDef.ch'

User Function xVwProd()

	Local oBrowser := FwmBrowse():New()
	
	oBrowser:SetAlias("SB1")
	oBrowser:SetDescription("Cadastro de Produto")
	oBrowser:Activate()
	
Return

//------------------------------------------------------------------------------

Static Function MenuDef()
	
	Local aRotina := {}
	
	AADD( aRotina, {"Visualizar Produto", "VIEWDEF.xVwProd", 0, 4, 0})
	
Return(aRotina)

//-----------------------------------------------------------

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
 
//Local oStr1:= FWFormStruct(2, 'SB1')
Local oStr2:= viewoStr2Str()
Local oStr3:= viewoStr3Str()
Local oStr4:= viewoStr4Str()

oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('FROMSB1' , oStr2,'SB1MASTER' )
oView:AddGrid('FROMSB5' , oStr3,'SB5_MASTER' )
oView:AddGrid('FROMSB2' , oStr4,'SB2_MASTER' )

oView:CreateHorizontalBox( 'BOXFORM1', 35)
oView:CreateHorizontalBox( 'BOX3', 65)
oView:CreateVerticalBox( 'BOXFORM4', 50, 'BOX3')
oView:CreateVerticalBox( 'BOXFORM6', 50, 'BOX3')


oView:SetOwnerView('FROMSB2','BOXFORM6')
oView:SetOwnerView('FROMSB5','BOXFORM4')
oView:SetOwnerView('FROMSB1','BOXFORM1')
oView:SetViewProperty('FROMSB1' , 'SETLAYOUT' , {FF_LAYOUT_HORZ_DESCR_TOP, 1}) 


//oView:SetViewProperty('FROMSB2' , 'SETLAYOUT' , {FF_LAYOUT_VERT_DESCR_TOP,1,120} ) 
//oView:SetViewProperty('FROMSB5' , 'SETLAYOUT' , {FF_LAYOUT_VERT_DESCR_TOP,1,120} ) 
//oView:SetViewProperty('FROMSB5' , 'SETCOLUMNSEPARATOR', {10})
//oView:SetViewProperty('FROMSB2' , 'SETCOLUMNSEPARATOR', {10})




Return oView
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

 
/*Local oStr1:= mldoStr1Str()
Local oStr2:= FWFormStruct(1,'SB5')*/
//Local oStr1:= FWFormStruct(1,'SB1')
Local oStr2:= mldoStr1Str()
Local oStr3:= mldoStr3Str()
Local oStr4:= mldoStr4Str()
oModel := MPFormModel():New('MDLSB1')
oModel:SetDescription('VISUALIZAR CADASTRO DE PRODUTO')


oModel:addFields('SB1MASTER',,oStr2)//,,,{|oFIELD,lCopy|fLoadSB1(oFIELD,lCopy)})
oModel:SetPrimaryKey({ 'B1_FILIAL', 'B1_COD' })
oModel:getModel('SB1MASTER'):SetDescription('DADOS SB1')


oModel:AddGRID('SB5_MASTER','SB1MASTER',oStr3,,,{|oFIELD,lCopy|fLoadSB5(oFIELD,lCopy)})
oModel:AddGRID('SB2_MASTER','SB1MASTER',oStr4,,,{|oFIELD,lCopy|fLoadSB2(oFIELD,lCopy)})

oModel:getModel('SB5_MASTER'):SetDescription('Complemento Produto')
oModel:getModel('SB2_MASTER'):SetDescription('SALDO ATUAL')
oModel:getModel('SB1MASTER'):SetDescription('TESTE')



Return oModel
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
oStruct:AddTable('SB1',,'TABELA SB1')
oStruct:AddField('Filial','Filial' , 'B1_FILIAL', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Codigo','Codigo' , 'B1_COD', 'C', 20, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('DESCRICAO','DESCRICAO' , 'B1_DESC', 'C', 60, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('UN MED','U.M.' , 'B1_UM', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('TIPO','TIPO' , 'B1_TIPO', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr3Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr3Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('SB5',,'COMPLEMENTO DO PRODUTO')
oStruct:AddField('Preco Sugerido','Preco Sugerido' , 'B5_PRV7', 'N', 10, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('POSSUI CERTIFICADO','POSSUI CERTIFICADO' , 'B5_CERT', 'C', 1, 0, , , {}, .F., , .F., .F., .T., , )


return oStruct


/*/{Protheus.doc} mldoStr4Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static function mldoStr4Str()
Local oStruct := FWFormModelStruct():New()

oStruct:AddTable('SB2',,'SALDO ATUAL')
oStruct:AddField('QTD ATUALIZADA','QTD ATUALIZADA' , 'B2_QATU', 'N', 14, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('QTD EMPENHADA','QTD EMPENHO' , 'B2_QEMP', 'N', 14, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('ALMOXARIFADO','ALMOXARIFADO' , 'B2_LOCAL', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )

return oStruct

//-----------------------------------------------------------
//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr2Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr2Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'B1_FILIAL','1','Filial','Filial',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_COD','2','Codigo','Codigo',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_DESC','3','DESCRICAO','DESCRICAO',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_UM','4','UN MED','UN MED',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_TIPO','5','TIPO','TIPO',, 'Get' ,,,,,,,,,,.T.,, )

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr3Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 15/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------
static function viewoStr3Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'B5_PRV7','1','Preco Sugerido','Preco Sugerido',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B5_CERT','2','POSSUI CERTIFICADO','POSSUI CERTIFICADO',, 'Get' ,,,,,,,,,,.T.,, )


return oStruct

//-------------------------------------------------------------------
Static Function fLoadSB1(oFIELD,lCopy)

	Local aDados	:=	{}

	aAdd(aDados, {SB1->B1_FILIAL	,;
				SB1->B1_COD	,;
				SB1->B1_DESC	,;
				SB1->B1_UM	,;
				SB1->B1_TIPO	})

	aAdd(aDados, Recno())

Return aDados


//-------------------------------------------------------------------

Static Function fLoadSB5(oFIELD,lCopy)

	Local aDados	:= {}
	Local cAlias	:= GetNextAlias()
	
	BeginSql Alias cAlias
	
	SELECT 
		B5_PRV7,
		B5_CERT
	
	From %Table:SB5% SB5
		Where B5_FILIAL	=	%xFILIAL:SB5%
		AND B5_COD		=	%EXP:SB1->B1_COD%
		AND	B5_FILIAL	=	%EXP:SB1->B1_FILIAL%
		AND %NOTDEL%
		
	EndSql
	
	dbSelectArea(cAlias)
	
	(cAlias)->( dbGoTop())
	
	While ! EOF()
		aAdd(aDados, {0, {.F.	,;
				B5_PRV7,;
				B5_CERT}})
	(cAlias)->( dbSkip())
	EndDo
	
	
Return aDados

//--------------------------------------------------------------------
Static Function fLoadSB2(oFIELD,lCopy)

	Local aDados	:= {}
	Local cAlias	:= GetNextAlias()
	
	BeginSql Alias cAlias
	
	SELECT 
		B2_QATU,
		B2_QEMP,
		B2_LOCAL
	
	From %Table:SB2% SB2
		Where B2_FILIAL	=	%xFILIAL:SB2%
		AND B2_COD		=	%EXP:SB1->B1_COD%
		AND	B2_FILIAL	=	%EXP:SB1->B1_FILIAL%
		AND %NOTDEL%
		
	EndSql
	
Return aDados