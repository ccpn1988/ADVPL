#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'


User Function mvc04()
	Local oBrowser := FwmBrowse():New()
	oBrowser:SetAlias("SA1")
	oBrowser:SetDescription("Cadastro de Cliente")
	oBrowser:AddLegend("A1_MSBLQL == '2'", "BR_MARRON","Ativo")
	oBrowser:AddLegend("A1_MSBLQL == '1'", "BR_PINK","Desativado")
	oBrowser:Activate() //Ativando o objeto
	
Return(NIL)

Static Function MenuDef() //Barra de botões
	//Local aRotina:=FwMVCMenu('mvc04')//Criando os botões visualizar, incluir, alterar, excluir, copiar, imprimir
	Local aRotina := {}
	AADD(aRotina , {"Analise de Credito", 'VIEWDEF.MVC04', 0,4,0})
Return(aRotina)

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface

@author aluno

@since 08/06/2019
@version 1.0
/*/
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
	
	Local oStr2:= mldoStr2Str()
	oModel := MPFormModel():New('MDLSA1SE1',,,{|oModel|fGrava(oModel)})
	oModel:SetDescription('ANALISE DE CREDITO')
	oModel:addFields('SA1MASTER',,oStr1,,,{|oField,lCopy|fLoadSa1(oField,lCopy)})
	oModel:addGrid('SE1GRID','SA1MASTER',oStr2,,,,,{|oGrid,lCopy|LoadSE1 (oGrid, lCopy)})
	
	oModel:SetPrimaryKey({ 'A1_COD', 'A1_LOJA' })
	
	
	oModel:getModel('SA1MASTER'):SetDescription('DADOS DO CLIENTE')
	oModel:getModel('SE1GRID'):SetDescription('CONTAS A RECEBER')
    oModel:getModel('SE1GRID'):SetOptional(.T.)
    oModel:getModel('SE1GRID'):SetNoInsertLine(.F.)
    oModel:getModel('SE1GRID'):SetNoUpdateLine(.T.)



	
	
	
	
Return oModel


Static Function fLoadSa1(oField,lCopy)
	
	Local aDados := {}
	
	aAdd (aDados, {SA1->A1_COD ,;
		SA1->A1_LOJA ,;
		SA1->A1_NOME ,;
		SA1->A1_CONTATO, ;
		SA1->A1_TEL})
	
	aAdd (aDados,Recno()) //Informado recno do registro
	
Return aDados
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
	oStruct:AddTable('TSA1',,'CADASTRO DE CLIENTE ')
	oStruct:AddField('CODIGO','CODIGO DO CLIENTE' , 'A1_COD', 'C', 6, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('LOJA','LOJA' , 'A1_LOJA', 'C', 2, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('CLIENTE','NOME CLIENTE' , 'A1_NOME', 'C', 50, 0, , , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('CONTATO','NOME DO CONTATO' , 'CONTATO', 'C', 30, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('TELEFONE','TELEFONE DE CONTATO' , 'A1_TEL', 'C', 12, 0, , , {}, .F., , .F., .F., .T., , )
	
	
	
	
	
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
	oStruct:AddField( 'A1_COD','1','CODIGO','CODIGO',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'A1_LOJA','2','LOJA','LOJA',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'A1_NOME','3','CLIENTE','CLIENTE',, 'Get' ,,,,.F.,,,,,,,, )
	oStruct:AddField( 'CONTATO','4','CONTATO','CONTATO',, 'Get' ,,,,.T.,,,,,,.T.,, )
	oStruct:AddField( 'A1_TEL','5','TELEFONE','TELEFONE',, 'Get' ,,,,.F.,,,,,,.T.,, )
	
return oStruct

//-------------------------------------------------------------------
/*/{Protheus.doc} mldoStr2Str()
Retorna estrutura do tipo FWformModelStruct.

@author aluno

@since 08/06/2019
@version 1.0
/*/
//-------------------------------------------------------------------

static function mldoStr2Str()
	Local oStruct := FWFormModelStruct():New()
	oStruct:AddTable('TSE1',,'CONTAS A RECEBER')
	oStruct:AddField(' ','CHECK DO CAMPO' , 'CHECK', 'L', 1, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('NUMERO','NUMERO DO TITULO' , 'E1_NUM', 'N', 9, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('PARCELA','NUMERO DA PARCELA' , 'E1_PARCELA', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('PREFIXO','PREFIXO' , 'E1_PREFIXO', 'C', 5, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('TIPO','TIPO' , 'E1_TIPO', 'C', 3, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('VENCIMENTO','VENCIMENTO' , 'E1_VENCREA', 'D', 8, 0, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('VALOR','VALOR' , 'E1_VALOR', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )
	oStruct:AddField('SALDO','SALDO' , 'E1_SALDO', 'N', 12, 2, , , {}, .F., , .F., .F., .T., , )
	
	
	
	
	
	
	
	
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
	oStruct:AddField( 'CHECK','1',' ',' ',, 'Check' ,,,,,,,,,,.T.,, )
	oStruct:AddField( 'E1_NUM','2','NUMERO','NUMERO',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_PARCELA','3','PARCELA','PARCELA',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_PREFIXO','4','PREFIXO','PREFIXO',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_TIPO','5','TIPO','TIPO',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_VENCREA','6','VENCIMENTO','VENCIMENTO',, 'Get' ,,,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_VALOR','7','VALOR','VALOR',, 'Get' ,'@ E 999,999,999,99',,,.F.,,,,,,.T.,, )
	oStruct:AddField( 'E1_SALDO','8','SALDO','SALDO',, 'Get' ,'@ E 999,999,999,99',,,.F.,,,,,,.T.,, )
	
return oStruct



Static Function LoadSE1 (oGrid, lCopy)
	Local aDados:= {}
	Local cAlias := GetNextAlias()
	
	BeginSql Alias cAliAs
	
		COLUMN E1_VENCREA AS DATE  
		 
		Select E1_NUM,
		E1_PARCELA,
		E1_PREFIXO,
		E1_TIPO,
		E1_VENCREA,
		E1_VALOR,
		E1_VALOR,
		E1_SALDO
		FROM %Table:SE1% SE1
		Where E1_FILIAL = %XFILIAL:SE1%
		AND E1_CLIENTE = %EXP: SA1->A1_COD%
		AND E1_LOJA = %EXP: SA1->A1_LOJA%
		AND E1_SALDO > 0
		AND %NOTDEL%
		
EndSql
	
	   aSql := GetLastQuery () //Informações sobre a Query Executada
	
	DbselectArea(cAlias)
	(cAlias)->( DbGotop())
	
	While ! Eof ()
		aAdd(aDados, {0, {.F.,;
			(cAlias)->E1_NUM,;
			(cAlias)->E1_PARCELA,;
			(cAlias)->E1_PREFIXO,;
			(cAlias)->E1_TIPO,;
			(cAlias)->E1_VENCREA,;
			(cAlias)->E1_VALOR,;
			(cAlias)->E1_SALDO}})
		
		(cAlias)->(DbSkip ())
		
	Enddo
Return aDados

Static Function fGrava(oModel)

       RecLock ("SA1",.F.)
         SA1->A1_CONTATO := oModel:Getvalue("SA1MASTER","CONTATO")
       MsUnLock()   
       
 Return(.T.)      