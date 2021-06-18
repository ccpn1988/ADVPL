#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC_SB1()
Local oBrowser := FwmBrowse():New()
	/*ATRIBUINDO AS PROPRIEDADES DO OBJETO BROWSER*/
	oBrowser:setAlias("SB1")
	oBrowser:setDescription("MVC - Análise de Produtos ( SB1 )")
	//Ativando o OBJETO - Nada pode ser colocado abaixo deste.
	oBrowser:Activate()
Return (NIL)

/*SEMPRE NOSSOS BOTÔES RECEBERÀ ESTE NOME DESTA FUNCÂO POIS ESTA ENCAPSULADO*/
Static Function MenuDef()
	Private aRotina   := {}
	//CRIANDO OS BOTÔES VISUALIZAR, INCLUIR, ALTERAR, EXCLUIR, COPIAR, IMPRIMIR ATRAVES DO AROTINA
	AADD( aRotina, {"Análise de Produtos" , 'VIEWDEF.MVC_SB1', 0, 2 , 0})
Return(aRotina) 


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

 
Local oStr2:= viewoStr2Str()
Local oStr3:= FWFormStruct(2, 'SB5')
Local oStr5:= FWFormStruct(2, 'SB2')

oView := FWFormView():New()

oView:SetModel(oModel)

oView:AddField('VIEWSB1' , oStr2,'MASTERSB1' )
oView:AddGrid('VIEWSB5' , oStr3,'SB5GRID')
oView:AddGrid('VIEWSB2' , oStr5,'SB2GRID')  
 
oView:CreateHorizontalBox( 'BOXFORM1', 30)

oView:CreateHorizontalBox( 'BOX5', 70)
oView:CreateFolder( 'FOLDER', 'BOX5')
oView:AddSheet('FOLDER','SHEETSALDO','SALDO SB2')

oView:AddSheet('FOLDER','SHEETDADOS','DADOS ADICIONAIS SB5')
oView:CreateHorizontalBox( 'BOXFORM7', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEETSALDO')
oView:SetOwnerView('VIEWSB2','BOXFORM7')


oView:CreateHorizontalBox( 'BOXFORM5', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEETDADOS')
oView:SetOwnerView('VIEWSB5','BOXFORM5')

oView:SetOwnerView('VIEWSB1','BOXFORM1')

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
 
Local oStr1:= mldoStr1Str()
Local oStr2:= FWFormStruct(1,'SB5')
Local oStr3:= FWFormStruct(1,'SB2')

oModel := MPFormModel():New('MDLSB1SB2')

oModel:addFields('MASTERSB1',,oStr1,,,{|oField,lCopy|fLoadSB1(oField,lCopy)})
oModel:addGrid('SB5GRID','MASTERSB1',oStr2)
oModel:addGrid('SB2GRID','MASTERSB1',oStr3)

oModel:SetRelation('SB2GRID', { { 'B2_FILIAL', 'B1_FILIAL' }, { 'B2_COD', 'B1_COD' } }, SB2->(IndexKey(1)) )
oModel:SetRelation('SB5GRID', { { 'B5_COD', 'B1_COD' }      , { 'B5_FILIAL', 'B1_FILIAL' } }, SB5->(IndexKey(1)) )

oModel:SetPrimaryKey({''})

oModel:SetDescription('Análise de Produtos')
oModel:getModel('MASTERSB1'):SetDescription('Tabela de Produtos')
oModel:getModel('SB5GRID'):SetDescription('Complemento de Produtos')
oModel:getModel('SB2GRID'):SetDescription('Saldos dos Produtos')



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
oStruct:AddTable('TSB1',,'Tabela de Produtos')
oStruct:AddField('Código','Codigo do Produto' , 'B1_COD', 'C', 15, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Descrição','Descrição do Produto' , 'B1_DESC', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Grupo','Grupo de Produto' , 'B1_GRUPO', 'C', 4, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Tipo','Tipo de Produto' , 'B1_TIPO', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Unidade','Unidade de Medida' , 'B1_UM', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Armazenamento Padrão','Armazenamento Padrão' , 'B1_LOCPAD', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Filial','Filial' , 'B1_FILIAL', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )

return oStruct

Static Function fLoadSB1(oField,lCopy)
Local aDados := {}
	aAdd(aDados, {SB1->B1_COD, SB1->B1_DESC, SB1->B1_GRUPO, SB1->B1_TIPO, SB1->B1_UM, SB1->B1_LOCPAD, SB1->B1_FILIAL})
	aAdd(aDados, Recno()) //INFORMANDO O RECNO DO REGISTRO
Return aDados

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
oStruct:AddField( 'B1_COD'   ,'1','Código','Código',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_DESC'  ,'2','Descrição','Descrição',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_GRUPO' ,'3','Grupo','Grupo',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_TIPO'  ,'4','Tipo','Tipo',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_UM'    ,'5','Unidade','Unidade',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_LOCPAD','6','Armazenamento Padrão','Armazenamento Padrão',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'B1_FILIAL','7','Filial','Filial',, 'Get' ,,,,,,,,,,.T.,, )

return oStruct

//Static Function fLoadSB2(oField,lCopy)
//
//Local aDados := {}
//Local cAlias := getnextAlias()
//
//BeginSql Alias cAlias
////Column E1_EMISSAO As Date //Converte a Data no Banco
//Select *
//from %Table:SB2% SB2 WHERE E2_FILIAL = %xFILIAL:SB2%  
//AND B2_COD = %EXP:SB1->A1_COD% 
//AND %notDel%	
//EndSql
//
//aSql := GetLastQuery() //informações sobre a Query Executada 
//
//DbSelectArea(cAlias)
//(cAlias)->(DbGotop())
//	while ! EOF()
//		aAdd(aDados, {0,{.F., (cAlias)->E1_NUM, (cAlias)->E1_PARCELA, (cAlias)->E1_PREFIXO, stod((cAlias)->E1_EMISSAO), stod((cAlias)->E1_VENCREA), (cAlias)->E1_TIPO, (cAlias)->E1_VALOR, (cAlias)->E1_SALDO}})
//		(cAlias)->(dbSkip())
//	EndDo
//Return aDados



