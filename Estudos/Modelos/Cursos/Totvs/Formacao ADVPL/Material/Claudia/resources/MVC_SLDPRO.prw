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
 
Local oStr4:= FWFormStruct(1,'SB2')
oModel := MPFormModel():New('MDLPROD')
oModel:SetDescription('Dados do Produto')
oModel:addFields('MASTER',,oStr2,,,{|oGrid,lCopy|fLoadSB1(oGrid,lCopy)})
oModel:addGrid('GRIDSB5','MASTER',oStr3,,,,,{|oGrid,lCopy|fLoadSB5(oGrid,lCopy)})
oModel:addGrid('GRIDSB2','MASTER',oStr4,,,,,{|oGrid,lCopy|fLoadSB2(oGrid,lCopy)})

oModel:SetPrimaryKey({ 'Codigo' })

oModel:getModel('MASTER'):SetDescription('Dados do Produto')
oModel:getModel('GRIDSB5'):SetDescription('Complemento do produto')
oModel:getModel('GRIDSB2'):SetDescription('Saldo Fisico')

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
 
Local oStr3:= FWFormStruct(2, 'SB2')

oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField('VIEWSB1' , oStr1,'MASTER' )
oView:AddGrid('FORMSB5' , oStr2,'GRIDSB5')
oView:AddGrid('FORMSB2' , oStr3,'GRIDSB2')   
oView:CreateHorizontalBox( 'TELASB1', 37)
oView:CreateHorizontalBox( 'BOX3', 63)
oView:CreateFolder( 'FOLDER4', 'BOX3')
oView:AddSheet('FOLDER4','SHEET7','Saldo Fisico')
oView:AddSheet('FOLDER4','SHEET5','Complemento')

oView:CreateHorizontalBox( 'BOXFORM7', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET7')
oView:SetOwnerView('FORMSB2','BOXFORM7')
oView:CreateHorizontalBox( 'BOXFORM5', 100, /*owner*/, /*lUsePixel*/, 'FOLDER4', 'SHEET5')
oView:SetOwnerView('FORMSB5','BOXFORM5')

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








return oStruct

//-------------------------------------------------------------------------

Static Function fLoadSB1(oField,lCopy)

	
	Local aDados := {}
	
	aAdd(aDados, {SB1->B1_COD ,;
		          SB1->B1_DESC ,;
		  	      SB1->B1_UM ,;
				  SB1->B1_GRUPO})				   
				   //SB1->B1_TEL})
	
	aAdd (aDados,Recno()) //Informado recno do registro
	
Return aDados

//-------------------------------------------------------------------------

Static Function fLoadSB5(oField,lCopy)

Local aDados := {}
Local cAlias := GetNextAlias()

BeginSql Alias cAlias   
   
   Select B5_COD,;		  
		  B5_CEME ,;
		  B5_CODCLI
	From %Table:SB5% SB5
	Where B5_COD = %EXP:SB1->B1_COD%	
	
EndSql

aSql:= GetLastQuery() //Informações sobre a query executada		  

dBSelectArea(cAlias)
dbGotop()
While !eof()

   aAdd(aDados, {0,  {.F.,;
                      B5_COD,;
		  			  B5_CEME ,;
		              B5_CODCLI } })


   dbskip()
   
Enddo  
           


Return(aDados)
//-------------------------------------------------------------------------

Static Function fLoadSB2(oField,lCopy)

Local aDados := {}
Local cAlias := GetNextAlias()

BeginSql Alias cAlias   
   
   Select B2_COD,;		  
		  B2_LOCAL ,;
		  B2_QATU
	From %Table:SB2% SB2
	Where B2_COD = %EXP:SB1->B1_COD%	
	
EndSql

aSql:= GetLastQuery() //Informações sobre a query executada		  

dBSelectArea(cAlias)
dbGotop()
While !eof()

   aAdd(aDados, {0,  {.F.,;
                      B2_COD,;
		  			  B2_LOCAL ,;
		              B2_QATU } })


   dbskip()
   
Enddo  
           
Return(aDados)


