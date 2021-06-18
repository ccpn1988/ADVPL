#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MVC04()
	
	Local oBrowser := FwmBrowse():New()

	oBrowser:SetAlias("SA1")
	oBrowser:SetDescription("Cadastro de Cliente")

	oBrowser:AddLegend("A1_MSBLQL=='2'","BR_MARRON","Ativo"     )
	oBrowser:AddLegend("A1_MSBLQL=='1'","BR_PINK"  ,"Desativado")
	oBrowser:Activate() // Ativando o obj

Return( NIL )

//------------------------------------------------------------------------------

Static Function MenuDef()
	
	Local aRotina := {}
	
	AADD( aRotina, {"Analise de Credito", "VIEWDEF.MVC04", 0, 4, 0})
	
Return(aRotina)

//-----------------------------------------------------------
Static Function fLoadSA1(oFIELD,lCopy)

	Local aDados	:=	{}

	aAdd(aDados, {SA1->A1_COD	,;
              SA1->A1_LOJA	,;
              SA1->A1_NOME	,;
              SA1->A1_CONTATO	,;
              SA1->A1_TEL	})

	aAdd(aDados, Recno())

Return aDados

//------------------------------------------------------------------------------

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= mldoStr1Str()
 
Local oStr2:= Nil
 
Local oStr3:= mldoStr3Str()
oModel := MPFormModel():New('MDLSA1SE1',,,{|oModel| fGrava(oModel)})
oModel:SetDescription('Analise de credito')
oModel:addFields('SA1MASTER',,oStr1,,,{|oFIELD,lCopy|fLoadSA1(oFIELD,lCopy)})
oModel:addGrid('SE1GRID','SA1MASTER',oStr3,,,,,{|oGrid,lCopy| LoadSE1(oGrid,lCopy)})

oModel:SetPrimaryKey({ 'A1_COD', 'A1_LOJA' })


oModel:getModel('SA1MASTER'):SetDescription('Dados do Cliente')
oModel:getModel('SE1GRID'):SetDescription('Contas a Receber')
oModel:getModel('SE1GRID'):SetNoInsertLine(.F.)
oModel:getModel('SE1GRID'):SetNoUpdateLine(.F.)
oModel:getModel('SE1GRID'):SetDelAllLine(.T.)
oModel:getModel('SA1MASTER'):SetOptional(.T.)









Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr1Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr1Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('TSA1',,'Cadastro de Cliente')
oStruct:AddField('Codigo','Codigo do Cliente' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('LOJA','Loja' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Cliente','Nome do Cliente' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Contato','Nome do Contato' , 'CONTATO', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Telefone','Telefone de Contato' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .F., , )





return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

Static Function ViewDef()
Local oView
Local oModel := ModelDef()

 
Local oStr1:= viewoStr1Str()
 
Local oStr2:= viewoStr2Str()
oView := FWFormView():New()

oView:SetModel(oModel)
oView:AddField('VIEWSA1' , oStr1,'SA1MASTER' )
oView:AddGrid('VIEWSE1' , oStr2,'SE1GRID')  
oView:CreateHorizontalBox( 'CAPA', 22)
oView:CreateHorizontalBox( 'BOXGRID', 78)
oView:SetOwnerView('VIEWSE1','BOXGRID')
oView:SetOwnerView('VIEWSA1','CAPA')



Return oView
//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr1Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr1Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'A1_COD','1','Codigo','Codigo',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','2','LOJA','LOJA',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','3','Cliente','Cliente',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'CONTATO','4','Contato','Contato',, 'Get' ,,,,.T.,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','Telefone','Telefone',, 'Get' ,,,,,,,,,,,, )

return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr3Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr3Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('TSE1',,'CONTAS A RECEBER')
oStruct:AddField('CHECAR','CHECK DO CAMPO' , 'CHECK', 'L', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('NUMERO','NUMERO' , 'E1_NUM', 'C', 9, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Parcela','Numero da Parcela' , 'E1_PARCELA', 'C', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Prefixo','Prefixo da Tabela' , 'E1_PREFIXO', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Tipo','Tipo' , 'E2_TIPO', 'C', 3, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Vencimento Real','Vencimento Real' , 'E1_VENCREA', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Valor','Valor' , 'E1_VALOR', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Saldo','Saldo' , 'E1_SALDO', 'N', 12, 2, , , {}, .F., , .F., .F., .F., , )








return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} viewoStr2Str()
Retorna estrutura do tipo FWFormViewStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function viewoStr2Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'CHECK'				,'1'	,'CHECAR'				,' '				,, 'Check',,,,,,,,,,.T.,, )
	oStruct:AddField( 'E1_NUM'			,'2'	,'NUMERO'			,'NUMERO'			,, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_PARCELA'		,'3'	,'Parcela'			,'Parcela'			,, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_PREFIXO'		,'4'	,'Prefixo'			,'Prefixo'			,, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E2_TIPO'			,'5'	,'Tipo'				,'Tipo'				,, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_VENCREA'		,'6'	,'Vencimento Real'	,'Vencimento Real'	,, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_VALOR'		,'7'	,'Valor'			,'Valor'			,, 'Get' ,'@E 9,999,999,999.99',,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_SALDO'		,'8'	,'Saldo'			,'Saldo'			,, 'Get' ,'@E 9,999,999,999.99',,,.F.,,,,,,.T.,, )

return oStruct

//-------------------------------------------------------------------
Static Function LoadSE1(oGrid,lCopy)

	Local aDados	:= {}
	Local cAlias	:= GetNextAlias()
	
	BeginSql Alias cAlias
	
	Column E1_VENCREA as Date
	
	Select	E1_NUM,
			E1_PARCELA,
			E1_PREFIXO,
			E1_TIPO,
			E1_VENCREA,
			E1_VALOR,
			E1_SALDO
			
	From %Table:SE1% SE1
		Where E1_FILIAL	=	%xFILIAL:SE1%
		AND E1_CLIENTE	=	%EXP:SA1->A1_COD%
		AND	E1_LOJA		=	%EXP:SA1->A1_LOJA%
		AND E1_SALDO 	>	0
		AND %NOTDEL%
		
	EndSql
	
	aSQL	:=	GetLastQuery()	//Informações sobre a query executada.
	
	dbSelectArea(cAlias)
	(cAlias)->( dbGoTop())
	
	While ! EOF()
		aAdd(aDados, {0, {.F.	,;
				E1_NUM,;
				E1_PARCELA,;
				E1_PREFIXO,;
				E1_TIPO,;
				E1_VENCREA,;
				E1_VALOR,;
				E1_SALDO}})
	(cAlias)->( dbSkip())
	EndDo
	
Return aDados

//----------------------------------------------------------------------------------
Static Function fGrava(oModel)
	
	RecLock("SA1",.F.)
		SA1->A1_CONTATO	:= oModel:GetValue("SA1MASTER","CONTATO")
	MsUnlock()

Return .T.