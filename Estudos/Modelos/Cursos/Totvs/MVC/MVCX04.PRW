#Include 'Protheus.ch'

User Function MVCX04()




Local oBrowse	:= FwmBrowse():New()
		
	oBrowse:SetAlias("SA1")	// Qual tabela vou usar
	oBrowse:SetDescription("Cadastro de Cliente MVC") //Qual a descri√ß√£o do meu browse
	oBrowse:AddLegend("A1_MSBLQL == '2'","BR_MARRON","Ativo"	 )	//Adiciona legenda
	oBrowse:AddLegend("A1_MSBLQL <> '2'","BR_PINK"	,"Desativado")	//Adiciona legenda
	oBrowse:Activate()	// Ativa o OBJETO
	
Return(Nil)
	
Static Function MenuDef()
Local aRotina := {}
	
	AADD( aRotina, {"Analise de Credito" , 'VIEWDEF.MVCX04', 0, 4 , 0} )
	
	
Return (aRotina)




//-------------------------------------------------------------------

//-------------------------------------------------------------------

Static Function ModelDef()
Local oModel

 
Local oStr1:= mldoStr1Str()
 
Local oStr2:= mldoStr2Str()
oModel := MPFormModel():New('MDLSA1SE1',,,{|oModel|fGrava(oModel)})
oModel:SetDescription('Analise de Credito')
oModel:addFields('SA1MASTER',,oStr1,,,{|oFIELD,lCopy|floadSA1(oFIELD,lCopy)})
oModel:addGrid('SE1GRID','SA1MASTER',oStr2,,,,,{|oGrid,lCopy|LoadSE1(oGrid,lCopy)})

oModel:SetPrimaryKey({ 'A1_COD', 'A1_LOJA' })


oModel:getModel('SA1MASTER'):SetDescription('Dados do Cliente')
oModel:getModel('SE1GRID'):SetDescription('Contas a Receber')

//TRATA A OP«AO DE ALTERA«¬O DELETAR E INSERIR LINHAS
oModel:getModel('SE1GRID'):SetNoUpdateLine(.F.)
oModel:getModel('SE1GRID'):SetNoInsertLine(.F.)
oModel:getModel('SE1GRID'):SetNoDeleteLine(.F.)
oModel:getModel('SE1GRID'):SetOptional(.T.)



Return oModel

Static Function fLoadSA1(oFIELD,lCopy)
Local aDados := {}

aADD(aDados,{SA1->A1_COD,;
			 SA1->A1_LOJA,;
			 SA1->A1_NOME,;
			 SA1->A1_CONTATO,;
			 SA1->A1_TEL})
			 
aADD(aDados,Recno()) //INFORMANDO recno DO REGISTRO
			 
Return aDados
//-------------------------------------------------------------------

//-------------------------------------------------------------------

static function mldoStr1Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('TSA1',,'Cadastro de Cliente')
oStruct:AddField('Codigo ','Codigo do Cliente' 	, 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('LOJA','Loja do Cliente' 		, 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Cliente','Nome Cliente' 		, 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Contato','Nome do Contato' 	, 'A1_CONTATO', 'C', 40, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Telefone','Telefone' 			, 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )


return oStruct

//-------------------------------------------------------------------

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

//-------------------------------------------------------------------

static function viewoStr1Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'A1_COD','1','Codigo ','Codigo ',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_NOME','2','Cliente','Cliente',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_LOJA','3','LOJA','LOJA',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'A1_CONTATO','4','Contato','Contato',, 'Get' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'A1_TEL','5','Telefone','Telefone',, 'Get' ,,,,.F.,,,,,,.T.,, )


return oStruct

//-------------------------------------------------------------------

//-------------------------------------------------------------------

static function mldoStr2Str()
Local oStruct := FWFormModelStruct():New()
oStruct:AddTable('TSE1',,'Contas a Receber')
oStruct:AddField(' ','Check do Campo' 			, 'CHECK', 'L', 1, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Numero','Numero do Titulo'	, 'E1_NUM', 'C', 9, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Parcela','Parcela do Titulo' 	, 'E1_PARCELA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Prefixo','Prefixo' 			, 'E1_PREFIXO'	, 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Tipo','Tipo do Titulo' 		, 'E1_TIPO', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Vencimento','Vencimento' 		, 'E1_VENCREA', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Valor','Valor Titulo' 		, 'E1_VALOR', 'N', 10, 2, , , {}, .F., , .F., .F., .T., , )
oStruct:AddField('Saldo','Saldo' 				, 'E1_SALDO', 'N', 10, 2, , , {}, .F., , .F., .F., .T., , )


return oStruct

//DECLARANDO A FUN«√O

Static Function LoadSE1(oGrid,lCopy)
Local aDados := {}
Local cAlias := GetNextAlias()

BeginSql Alias cAlias
	
	column E1_VENCREA as Date 
	
SELECT 	E1_NUM,
		E1_PARCELA,
		E1_PREFIXO,
		E1_TIPO,
		E1_VENCREA,
		E1_VALOR,
		E1_SALDO 
From %Table:SE1% SE1
		WHERE E1_FILIAL = %xFILIAL:SE1%
		AND E1_CLIENTE 	= %EXP:SA1->A1_COD%
		AND E1_LOJA 	= %EXP:SA1->A1_LOJA%
		AND E1_SALDO > 0
		AND %notDel%
EndSql

	aSql :=  GetLastQuery()//INFORMA«‘ES SOBRE A QUERY EXECUTADA

dBSelectArea(cAlias)
(cAlias)->(DbGotop())

While (cAlias)->(!EOF())

	aADD(aDados,{0,{.F.,;
					(cAlias)->E1_NUM,;
					(cAlias)->E1_PARCELA,;
					(cAlias)->E1_PREFIXO,;
					(cAlias)->E1_TIPO,;
					(cAlias)->E1_VENCREA,;
					(cAlias)->E1_VALOR,;
					(cAlias)->E1_SALDO} } )	

	(cAlias)->(dbSkip())

EndDo
	
	
Return aDados			
//-------------------------------------------------------------------
//MUDANDO ALTERA«√O CONTATO
Static Function fGrava(oModel)
	Reclock("SA1",.F.)
		SA1->A1_CONTATO := oModel:GetValue("SA1MASTER","A1_CONTATO")
	MsUnlock()
Return .T.			

//-------------------------------------------------------------------

static function viewoStr2Str()
Local oStruct := FWFormViewStruct():New()
oStruct:AddField( 'CHECK','1',' ',' ',, 'Check' ,,,,,,,,,,.T.,, )
oStruct:AddField( 'E1_NUM','2','Numero','Numero',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PARCELA','3','Parcela','Parcela',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_PREFIXO','4','Prefixo','Prefixo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_TIPO','5','Tipo','Tipo',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VENCREA','6','Vencimento','Vencimento',, 'Get' ,,,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_VALOR','7','Valor','Valor',, 'Get' ,'@E 999,999,999.99',,,.F.,,,,,,.T.,, )
oStruct:AddField( 'E1_SALDO','8','Saldo','Saldo',, 'Get' ,'999,999,999.99',,,.F.,,,,,,.T.,, )


return oStruct
