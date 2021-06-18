#include "protheus.ch"
#include "topconn.ch"
#Include "Report.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT015    บAutor  ณErica Vieites       บ Data ณ 14/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de pr้ vendas  portal.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - e-Commerce                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT015()  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg		:= "FAT015"
Private lQuebra	:= .T.

Private _cAlias1	:= GetNextAlias() 

//AjustaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return nil
EndIF

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT015    บAutor  ณMicrosiga           บ Data ณ  12/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(cPerg)

Local oReport
Local oSection1

Local aOrdem	:= {"SOURCE+PERIODO+OBRA (ISBN)+PEDIDO","MEDIUM+PERIODO+OBRA (ISBN)+PEDIDO","CAMPAIGN+PERIODO+OBRA (ISBN)+PEDIDO","OBRA (ISBN)+PERIODO+PEDIDO","PERIODO+OBRA (ISBN)+SOURCE+MEDIUM+CAMPAIGN"}

//Declaracao do relatorio
oReport := TReport():New("FAT015","PRษ-VENDA - UTM_COD E-com"	,cPerg		,{|oReport| PrintReport(oReport)},"PRษ-VENDA - UTM_COD E-com") 
oReport:PrintHeader(.F.,.F.)
//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .F. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"e-Commerce",{_cAlias1,"NAOUSADO"},aOrdem)

//Celulas da secao      
TRCell():New(oSection1,"PAGAMENTO",_cAlias1,"PAGAMENTO"	            ,				 ,15)
TRCell():New(oSection1,"CODIGO_CUPOM",_cAlias1,"CODIGO_CUPOM"	    ,				 ,15)
TRCell():New(oSection1,"NUM"		,_cAlias1,"Pedido e-Commerce"	,				 ,15)

TRCell():New(oSection1,"RAZAO"	  	,_cAlias1,"Nome Cliente"	  	,				 ,50)
TRCell():New(oSection1,"SOBRENOME"	,_cAlias1,"Sobrenome"	  		,				 ,50)
TRCell():New(oSection1,"EMAIL"		,_cAlias1,"E-Mail"	  			,				 ,50)
TRCell():New(oSection1,"UF"			,_cAlias1,"UF"	  				,				 ,05)
TRCell():New(oSection1,"CIDADE"		,_cAlias1,"Cidade"	  			,				 ,50)
TRCell():New(oSection1,"DDDF"		,_cAlias1,"DDD (Telefone)"	  	,				 ,05)
TRCell():New(oSection1,"FONE"		,_cAlias1,"Telefone"	  		,				 ,15)
TRCell():New(oSection1,"DDDC"		,_cAlias1,"DDD (Celular)"	  	,				 ,05)
TRCell():New(oSection1,"CELULAR"	,_cAlias1,"Celular"	  			,				 ,15)
TRCell():New(oSection1,"DATAPED"	,_cAlias1,"Data Pedido"	  		,				 ,15)
TRCell():New(oSection1,"SOURCE"		,_cAlias1,"UTM Source"	  		,				 ,50)
TRCell():New(oSection1,"MEDIUM"		,_cAlias1,"UTM Medium"	  		,				 ,30)
TRCell():New(oSection1,"CAMPANHA"	,_cAlias1,"UTM Campanha"	  	,				 ,30)
TRCell():New(oSection1,"AREA"		,_cAlias1,"มrea"	  			,				 ,30)
TRCell():New(oSection1,"CURSO"		,_cAlias1,"Curso"	  			,				 ,30)
TRCell():New(oSection1,"DISCIPLINA"	,_cAlias1,"Disciplina"	  		,				 ,30)
TRCell():New(oSection1,"SKU"		,_cAlias1,"SKU"	  				,				 ,30)
TRCell():New(oSection1,"ISBN"		,_cAlias1,"ISBN"	  			,				 ,30)
TRCell():New(oSection1,"TITECO"		,_cAlias1,"Titulo e-Commerce"	,				 ,50)
TRCell():New(oSection1,"TITERP"		,_cAlias1,"Titulo ERP"	  		,				 ,50)
TRCell():New(oSection1,"QUANT"		,_cAlias1,"Quantidade"			,				 ,20)
TRCell():New(oSection1,"PRCVEN"		,_cAlias1,"Pre็o unitแrio"	  	,PesqPict('SB1',"B1_PRV1"),20)
TRCell():New(oSection1,"SUBTOT"		,_cAlias1,"Subtotal"	  		,PesqPict('SC6',"C6_VALOR"),20)
TRCell():New(oSection1,"FRETE"		,_cAlias1,"Metodo Frete"	  	,				 ,20)
TRCell():New(oSection1,"VALFRETE"	,_cAlias1,"Valor Frete"	  		,PesqPict('SC6',"C6_VALOR"),15)
TRCell():New(oSection1,"VALDESC"	,_cAlias1,"Valor Desconto"	  	,PesqPict('SC6',"C6_VALOR"),15)
TRCell():New(oSection1,"VALTOTAL"	,_cAlias1,"Total"	  			,PesqPict('SC6',"C6_VALOR"),30)
TRCell():New(oSection1,"TOTNOFRE"	,_cAlias1,"Total Sem Frete"	  	,PesqPict('SC6',"C6_VALOR"),30)

//Totalizadores

Do Case
	Case MV_PAR11 == 1 // "SOURCE"
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->UTM_SOURCE)	} , {|| "Total Source -->"})	
	Case MV_PAR11 == 2 // "MEDIUM"
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->UTM_MEDIUM) 	} , {|| "Total Medium -->"})	
	Case MV_PAR11 == 3 // "CAMPAIGN"
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->CAMPANHA)		} , {|| "Total Campanha -->"})	
	Case MV_PAR11 == 4 // "OBRA (ISBN)"
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->B1_ISBN) 		} , {|| "Total Obra -->"})	
	Case MV_PAR11 == 5 // "Pedido"
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->NUM) 	   		} , {|| "Total Pedido -->"})	
	OtherWise				
		oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->NUM) 	   		} , {|| "Total Perํodo -->" })
EndCase


/*
oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->UTM_SOURCE)	} , {|| "Total Source "+AllTrim((_cAlias1)->UTM_SOURCE)+"	-->" })	
oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->UTM_MEDIUM) 	} , {|| "Total Medium "+AllTrim((_cAlias1)->UTM_MEDIUM)+"	-->" })	
oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->CAMPANHA) 		} , {|| "Total Campanha "+AllTrim((_cAlias1)->CAMPANHA)+"	-->" })	
oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->B1_ISBN) 		} , {|| "Total Obra "+AllTrim((_cAlias1)->B1_ISBN)+"	-->" })	
oBreak := TRBreak():New(oSection1, {|| (_cAlias1)->DT_PEDIDO			 	} , {|| "Total Perํodo "+DtoC((_cAlias1)->DT_PEDIDO)+"	-->" })	
*/
		
TRFunction():New(oSection1:Cell("QUANT")	    ,"QTD"	,"SUM",oBreak,,)
TRFunction():New(oSection1:Cell("VALTOTAL")	,"LIQ"	,"SUM",oBreak,,PesqPict('SC6',"C6_VALOR"))  
TRFunction():New(oSection1:Cell("TOTNOFRE")	,"LIQ"	,"SUM",oBreak,,PesqPict('SC6',"C6_VALOR"))

	
//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
oSection1:SetLeftMargin(2)
oSection1:lPrintHeader := .F.

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT014   บAutor  ณMicrosiga           บ Data ณ  12/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
//Local cFiliProc	:= "'1001','1022'" // Filial onde os pedidos do e-Commerce nใo processados  
Local _cQuery   := ""
Local cQuebra	:= Chr(13)+Chr(10)

MV_PAR01	:= IIF( EMPTY(MV_PAR01) , CtoD("01/01/1900") , MV_PAR01 )

  
/* legado */
_cQuery := " SELECT PG.TIPO_PAGAMENTO PAGAMENTO, CODIGO_CUPOM,NUMERO NUM,PED.COBRANCA_NOME_RAZAO RAZAO,PED.COBRANCA_SOBRENOME_IE SOBRENOME,PED.COBRANCA_EMAIL EMAIL,PED.COBRANCA_UF UF,PED.COBRANCA_CIDADE CIDADE,TO_CHAR(PED.COBRANCA_TELEFONE) TELEFONE,"+cQuebra
_cQuery += "        PED.COBRANCA_TELEFONE_DDD DDD,TO_CHAR(PED.COBRANCA_CELULAR) CELULAR,PED.COBRANCA_CELULAR_DDD CELDDD,TO_CHAR(DATA_PEDIDO,'YYYYMMDD') DT_PEDIDO,UTM_SOURCE,UTM_MEDIUM,PED.UTM_CAMPAIGN CAMPANHA,"+cQuebra
_cQuery += "        Z7_DESC AREA,Z5_DESC CURSO,SZ6.Z6_DESC DISCIPLINA,SKU,B1_ISBN,NOME,B1_DESC,QUANTIDADE,PRECO,METODO_FRETE FRETE,VALOR_FRETE VALFRETE,ITEM.VALOR_DESCONTO VALDESC,SUBTOTAL,DATA_PEDIDO,TOTAL,(VALOR_FRETE/PED.QTY_ITENS) FRETE_ITEM,"+cQuebra
_cQuery += "        NVL((SELECT SUM(QUANTIDADE) FROM genesb.pedido PEDB"+cQuebra
_cQuery += "               JOIN GENESB.ITEM ITEMB"+cQuebra
_cQuery += "                 ON ITEMB.PEDIDO_ENTITY_ID = PEDB.ENTITY_ID"+cQuebra
_cQuery += "              WHERE PEDB.COBRANCA_CPF_CNPJ = PED.COBRANCA_CPF_CNPJ"+cQuebra
_cQuery += "                AND PEDB.ENTITY_ID < PED.ENTITY_ID"+cQuebra
_cQuery += "                AND ITEMB.SKU = ITEM.SKU),0) QTD_COMPRA, "+cQuebra
_cQuery += "        TO_CHAR((SELECT MAX(PEDB.DATA_PEDIDO) FROM genesb.pedido PEDB"+cQuebra
_cQuery += "                   JOIN GENESB.ITEM ITEMB"+cQuebra
_cQuery += "                     ON ITEMB.PEDIDO_ENTITY_ID = PEDB.ENTITY_ID"+cQuebra
_cQuery += "                  WHERE PEDB.COBRANCA_CPF_CNPJ = PED.COBRANCA_CPF_CNPJ"+cQuebra
_cQuery += "                    AND PEDB.ENTITY_ID < PED.ENTITY_ID"+cQuebra
_cQuery += "                    AND ITEMB.SKU = ITEM.SKU),'DD/MM/YYYY') DTULCOMP"+cQuebra
_cQuery += "   FROM GENESB.PEDIDO PED"+cQuebra
_cQuery += "   JOIN GENESB.ITEM ITEM"+cQuebra
_cQuery += "     ON ITEM.PEDIDO_ENTITY_ID = PED.ENTITY_ID"+cQuebra
_cQuery += "   JOIN "+RetSqlName("SB1")+" SB1"+cQuebra
_cQuery += "     ON B1_FILIAL = '"+xFilial("SB1")+"'"+cQuebra
_cQuery += "    AND TO_NUMBER(TRIM(B1_COD)) = TO_NUMBER(TRIM(ITEM.SKU))"+cQuebra
_cQuery += "    AND TRIM(B1_XSITOBR) = '110'"+cQuebra
_cQuery += "    AND SB1.D_E_L_E_T_ <> '*'"+cQuebra 
_cQuery += "   LEFT JOIN GENESB.PAGAMENTO PG"+cQuebra
_cQuery += "     ON PED.ENTITY_ID = PG.PEDIDO_ENTITY_ID"+cQuebra  //Vivaz 30538 Beatriz Pinto
_cQuery += "   LEFT JOIN "+RetSqlName("SB5")+" SB5"+cQuebra
_cQuery += "     ON B5_FILIAL = B1_FILIAL"+cQuebra
_cQuery += "    AND B5_COD = B1_COD"+cQuebra
_cQuery += "    AND SB5.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ7")+" SZ7"+cQuebra
_cQuery += "     ON Z7_FILIAL = '"+xFilial("SZ7")+"'"+cQuebra
_cQuery += "    AND Z7_AREA = B5_XAREA "+cQuebra
_cQuery += "    AND SZ7.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ6")+" SZ6"+cQuebra
_cQuery += "     ON Z6_FILIAL = '"+xFilial("SZ6")+"'"+cQuebra
_cQuery += "    AND SZ6.Z6_DISCIPL = B5_XDISCIP "+cQuebra
_cQuery += "    AND SZ6.Z6_CURSO = B5_XCURSO"+cQuebra
_cQuery += "    AND SZ6.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ5")+" SZ5"+cQuebra
_cQuery += "     ON Z5_FILIAL = '"+xFilial("SZ5")+"'"+cQuebra
_cQuery += "    AND SZ5.Z5_CURSO = B5_XCURSO "+cQuebra
_cQuery += "    AND SZ5.Z5_AREA = B5_XAREA "+cQuebra
_cQuery += "    AND SZ5.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "  WHERE B1_ISBN BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+cQuebra
_cQuery += "    AND TO_CHAR(PED.DATA_PEDIDO,'YYYYMMDD') BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+cQuebra
_cQuery += "    AND NOT EXISTS (SELECT DISTINCT 1 FROM "+RetSqlName("SC6")+" WHERE TO_NUMBER(TRIM(C6_XPEDWEB)) = TO_NUMBER(TRIM(PED.NUMERO)) AND TO_NUMBER(TRIM(C6_PRODUTO)) = TO_NUMBER(TRIM(ITEM.SKU)) AND D_E_L_E_T_ <> '*')"+cQuebra


If !Empty(MV_PAR05)
	_cQuery += "    AND B5_XAREA = '"+MV_PAR05+"'"+cQuebra
EndIF
If !Empty(MV_PAR06)
	_cQuery += "    AND B5_XCURSO = '"+MV_PAR06+"'"+cQuebra
EndIf	
If !Empty(MV_PAR07)
	_cQuery += "    AND B5_XDISCIP = '"+MV_PAR07+"'"+cQuebra
EndIF
If !Empty(MV_PAR08)
	_cQuery += "    AND UTM_SOURCE LIKE '%"+AllTrim(MV_PAR08)+"%'"+cQuebra
EndIF	
If !Empty(MV_PAR09)
	_cQuery += "    AND UTM_MEDIUM LIKE '%"+AllTrim(MV_PAR09)+"%'"+cQuebra
EndIF
If !Empty(MV_PAR10)
	_cQuery += "    AND UTM_CAMPAIGN LIKE '%"+AllTrim(MV_PAR10)+"%'"+cQuebra
EndIF


/* novo site gen */
 _cQuery += "  UNION ALL  "+cQuebra
 _cQuery += "  SELECT PG.TIPO_PAGAMENTO PAGAMENTO, CODIGO_CUPOM,NUMERO NUM,PED.COBRANCA_NOME_RAZAO RAZAO,' ' SOBRENOME,PED.COBRANCA_EMAIL EMAIL,PED.COBRANCA_UF UF,PED.COBRANCA_CIDADE CIDADE,TO_CHAR(PED.COBRANCA_TELEFONE) TELEFONE,"+cQuebra
 _cQuery += "  0 DDD,' ' CELULAR,0 CELDDD,TO_CHAR(DATA_PEDIDO,'YYYYMMDD') DT_PEDIDO,UTM_SOURCE,UTM_MEDIUM,PED.UTM_CAMPAIGN CAMPANHA,"+cQuebra

_cQuery += "        Z7_DESC AREA,Z5_DESC CURSO,SZ6.Z6_DESC DISCIPLINA,SKU,B1_ISBN,NOME,B1_DESC,QUANTIDADE,PRECO,METODO_FRETE FRETE,VALOR_FRETE VALFRETE,ITEM.VALOR_DESCONTO VALDESC,SUBTOTAL,DATA_PEDIDO,TOTAL,(VALOR_FRETE/PED.QTY_ITENS) FRETE_ITEM,"+cQuebra
_cQuery += "        NVL((SELECT SUM(QUANTIDADE) FROM GENESB.PEDIDO_NOVO PEDB"+cQuebra
_cQuery += "               JOIN GENESB.ITEM_NOVO ITEMB"+cQuebra
_cQuery += "                 ON ITEMB.PEDIDO_ENTITY_ID = PEDB.ENTITY_ID"+cQuebra
_cQuery += "              WHERE PEDB.COBRANCA_CPF_CNPJ = PED.COBRANCA_CPF_CNPJ"+cQuebra
_cQuery += "                AND PEDB.ENTITY_ID < PED.ENTITY_ID"+cQuebra
_cQuery += "                AND ITEMB.SKU = ITEM.SKU),0) QTD_COMPRA, "+cQuebra
_cQuery += "        TO_CHAR((SELECT MAX(PEDB.DATA_PEDIDO) FROM GENESB.PEDIDO_NOVO PEDB"+cQuebra
_cQuery += "                   JOIN GENESB.ITEM_NOVO ITEMB"+cQuebra
_cQuery += "                     ON ITEMB.PEDIDO_ENTITY_ID = PEDB.ENTITY_ID"+cQuebra
_cQuery += "                  WHERE PEDB.COBRANCA_CPF_CNPJ = PED.COBRANCA_CPF_CNPJ"+cQuebra
_cQuery += "                    AND PEDB.ENTITY_ID < PED.ENTITY_ID"+cQuebra
_cQuery += "                    AND ITEMB.SKU = ITEM.SKU),'DD/MM/YYYY') DTULCOMP"+cQuebra
_cQuery += "   FROM GENESB.PEDIDO_NOVO PED"+cQuebra
_cQuery += "   JOIN GENESB.ITEM_NOVO ITEM"+cQuebra
_cQuery += "     ON ITEM.PEDIDO_ENTITY_ID = PED.ENTITY_ID"+cQuebra
_cQuery += "   JOIN "+RetSqlName("SB1")+" SB1"+cQuebra
_cQuery += "     ON B1_FILIAL = '"+xFilial("SB1")+"'"+cQuebra
_cQuery += "    AND TO_NUMBER(TRIM(B1_COD)) = TO_NUMBER(TRIM(ITEM.SKU))"+cQuebra
_cQuery += "    AND TRIM(B1_XSITOBR) = '110'"+cQuebra
_cQuery += "    AND SB1.D_E_L_E_T_ <> '*'"+cQuebra 
_cQuery += "   LEFT JOIN GENESB.PAGAMENTO_NOVO PG"+cQuebra
_cQuery += "     ON PED.ENTITY_ID = PG.PEDIDO_ENTITY_ID"+cQuebra  //Vivaz 30538 Beatriz Pinto
_cQuery += "   LEFT JOIN "+RetSqlName("SB5")+" SB5"+cQuebra
_cQuery += "     ON B5_FILIAL = B1_FILIAL"+cQuebra
_cQuery += "    AND B5_COD = B1_COD"+cQuebra
_cQuery += "    AND SB5.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ7")+" SZ7"+cQuebra
_cQuery += "     ON Z7_FILIAL = '"+xFilial("SZ7")+"'"+cQuebra
_cQuery += "    AND Z7_AREA = B5_XAREA "+cQuebra
_cQuery += "    AND SZ7.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ6")+" SZ6"+cQuebra
_cQuery += "     ON Z6_FILIAL = '"+xFilial("SZ6")+"'"+cQuebra
_cQuery += "    AND SZ6.Z6_DISCIPL = B5_XDISCIP "+cQuebra
_cQuery += "    AND SZ6.Z6_CURSO = B5_XCURSO"+cQuebra
_cQuery += "    AND SZ6.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "   LEFT JOIN "+RetSqlName("SZ5")+" SZ5"+cQuebra
_cQuery += "     ON Z5_FILIAL = '"+xFilial("SZ5")+"'"+cQuebra
_cQuery += "    AND SZ5.Z5_CURSO = B5_XCURSO "+cQuebra
_cQuery += "    AND SZ5.Z5_AREA = B5_XAREA "+cQuebra
_cQuery += "    AND SZ5.D_E_L_E_T_ <> '*'"+cQuebra
_cQuery += "  WHERE B1_ISBN BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"+cQuebra
_cQuery += "    AND TO_CHAR(PED.DATA_PEDIDO,'YYYYMMDD') BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+cQuebra
_cQuery += "    AND NOT EXISTS (SELECT DISTINCT 1 FROM "+RetSqlName("SC6")+" WHERE TO_NUMBER(TRIM(C6_XPEDWEB)) = TO_NUMBER(TRIM(PED.NUMERO)) AND TO_NUMBER(TRIM(C6_PRODUTO)) = TO_NUMBER(TRIM(ITEM.SKU)) AND D_E_L_E_T_ <> '*')"+cQuebra


If !Empty(MV_PAR05)
	_cQuery += "    AND B5_XAREA = '"+MV_PAR05+"'"+cQuebra
EndIF
If !Empty(MV_PAR06)
	_cQuery += "    AND B5_XCURSO = '"+MV_PAR06+"'"+cQuebra
EndIf	
If !Empty(MV_PAR07)
	_cQuery += "    AND B5_XDISCIP = '"+MV_PAR07+"'"+cQuebra
EndIF
If !Empty(MV_PAR08)
	_cQuery += "    AND UTM_SOURCE LIKE '%"+AllTrim(MV_PAR08)+"%'"+cQuebra
EndIF	
If !Empty(MV_PAR09)
	_cQuery += "    AND UTM_MEDIUM LIKE '%"+AllTrim(MV_PAR09)+"%'"+cQuebra
EndIF
If !Empty(MV_PAR10)
	_cQuery += "    AND UTM_CAMPAIGN LIKE '%"+AllTrim(MV_PAR10)+"%'"+cQuebra
EndIF


Do Case 
	Case oSection1:nOrder == 1
		_cQuery += "  ORDER BY UTM_SOURCE,DATA_PEDIDO,B1_ISBN,NUM "+cQuebra	
	Case oSection1:nOrder == 2
		_cQuery += "  ORDER BY UTM_MEDIUM,DATA_PEDIDO,B1_ISBN,NUM "+cQuebra	
	Case oSection1:nOrder == 3
		_cQuery += "  ORDER BY UTM_CAMPAIGN,DATA_PEDIDO,B1_ISBN,NUM "+cQuebra	
	Case oSection1:nOrder == 4
		_cQuery += "  ORDER BY B1_ISBN,DATA_PEDIDO,NUM "+cQuebra			
	OtherWise
		_cQuery += "  ORDER BY DATA_PEDIDO,B1_ISBN,UTM_SOURCE,UTM_MEDIUM,UTM_CAMPAIGN,NUM "+cQuebra 		
End Case

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
TCSetFiEld(_cAlias1,"DT_PEDIDO","D",8,0)
TCSetFiEld(_cAlias1,"DTULCOMP","D",8,0)
(_cAlias1)->(dbGoTop())

While !(_cAlias1)->(Eof())
	
	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	oSection1:Init()  
	oSection1:Cell("PAGAMENTO"):SetValue(		(_cAlias1)->PAGAMENTO)
    oSection1:Cell("CODIGO_CUPOM"):SetValue((_cAlias1)->CODIGO_CUPOM)
	oSection1:Cell("NUM"):SetValue(			(_cAlias1)->NUM			)
	
	oSection1:Cell("RAZAO"):SetValue(		(_cAlias1)->RAZAO		)
	oSection1:Cell("SOBRENOME"):SetValue(	(_cAlias1)->SOBRENOME	)     
	oSection1:Cell("EMAIL"):SetValue(		(_cAlias1)->EMAIL		)     
	oSection1:Cell("UF"):SetValue(			(_cAlias1)->UF			)     
	oSection1:Cell("CIDADE"):SetValue(		(_cAlias1)->CIDADE		)     
	oSection1:Cell("FONE"):SetValue(		(_cAlias1)->TELEFONE	)
	oSection1:Cell("DDDF"):SetValue(		(_cAlias1)->DDD			)
	oSection1:Cell("CELULAR"):SetValue(		(_cAlias1)->CELULAR		)
	oSection1:Cell("DDDC"):SetValue(		(_cAlias1)->CELDDD		)
	oSection1:Cell("DATAPED"):SetValue(		(_cAlias1)->DT_PEDIDO	)
	oSection1:Cell("SOURCE"):SetValue(		(_cAlias1)->UTM_SOURCE	)     
	oSection1:Cell("MEDIUM"):SetValue(		(_cAlias1)->UTM_MEDIUM	)     
	oSection1:Cell("CAMPANHA"):SetValue(	(_cAlias1)->CAMPANHA	)     
	oSection1:Cell("AREA"):SetValue(		(_cAlias1)->AREA   		)     
	oSection1:Cell("CURSO"):SetValue(		(_cAlias1)->CURSO		)     
	oSection1:Cell("DISCIPLINA"):SetValue(	(_cAlias1)->DISCIPLINA	)     
	oSection1:Cell("SKU"):SetValue(			(_cAlias1)->SKU			)     
	oSection1:Cell("ISBN"):SetValue(		(_cAlias1)->B1_ISBN		)     
	oSection1:Cell("TITECO"):SetValue(		(_cAlias1)->NOME		)     
	oSection1:Cell("TITERP"):SetValue(		(_cAlias1)->B1_DESC		)     
	
	oSection1:Cell("QUANT"):SetValue(		(_cAlias1)->QUANTIDADE	)     
	oSection1:Cell("PRCVEN"):SetValue(		(_cAlias1)->PRECO		)     
	nSubTot	:= (_cAlias1)->QUANTIDADE*(_cAlias1)->PRECO
	
	oSection1:Cell("SUBTOT"):SetValue(		nSubTot/*(_cAlias1)->SUBTOTAL*/	)
	
	oSection1:Cell("FRETE"):SetValue(		(_cAlias1)->FRETE  		)     
	oSection1:Cell("VALFRETE"):SetValue(	(_cAlias1)->FRETE_ITEM/*VALFRETE*/	)     
	oSection1:Cell("VALDESC"):SetValue(		(_cAlias1)->VALDESC		)     
	
  //	nTot := nSubTot+(_cAlias1)->FRETE_ITEM+(_cAlias1)->VALDESC  //marcos silva 
   
    nTot := nSubTot+(_cAlias1)->FRETE_ITEM-(_cAlias1)->VALDESC   //erica
	oSection1:Cell("VALTOTAL"):SetValue(	nTot/*(_cAlias1)->TOTAL*/		)     

	//nTotNoFre := nSubTot+(_cAlias1)->VALDESC    //marcos silva
	nTotNoFre := nSubTot-(_cAlias1)->VALDESC
	oSection1:Cell("TOTNOFRE"):SetValue(	nTotNoFre/*(_cAlias1)->TOTAL*/		)     
			
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT014   บAutor  ณMicrosiga           บ Data ณ  12/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= {} 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os tํtulos e Help das perguntas                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aHelp,{ {	"Data inicial do periodo de"    ," vendas  "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"Data final de periodo de"      ," vendas  "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )
aAdd(aHelp,{ {	"                        "      ,"         "           ,""                  },{""}, {""} } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as perguntas no arquivo SX1                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		cGrupo cOrde cDesPor			cDesSpa				  	cDesEng				           cVar	   cTipo cTamanho					cDecimal	nPreSel	cGSC	cValid                            cF3 		cGrpSXG	cPyme	cVar01			cDef1Por					cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por				cDef3Spa	cDef3Eng	cDef4Por		cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
PutSx1(cPerg,"01","Periodo De"			,"Periodo De"         	,"Periodo De"                ,"mv_ch1" ,"D" ,8        					,0       ,        ,"G"  ,""                                  ,""		,      ,"","mv_par01","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[01,1],	aHelp[01,2],	aHelp[01,3],	"" )
PutSx1(cPerg,"02","Periodo Ate"			,"Periodo Ate"       	,"Periodo Ate"               ,"mv_ch2" ,"D" ,8        					,0       ,        ,"G"  ,""                                  ,""   	  	,      ,"","mv_par02","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[02,1],	aHelp[02,2],	aHelp[02,3],	"" )
PutSx1(cPerg,"03","De ISBN (Obra)"		,"De ISBN (Obra)"      	,"De ISBN (Obra)"            ,"mv_ch3" ,"C" ,TamSX3("B1_ISBN")[1]		,0       ,        ,"G"  ,""                                  ,"ISBN"   	,      ,"","mv_par03","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[03,1],	aHelp[03,2],	aHelp[03,3],	"" )
PutSx1(cPerg,"04","Ate ISBN (Obra)"		,"Ate ISBN (Obra)"      ,"Ate ISBN (Obra)"           ,"mv_ch4" ,"C" ,TamSX3("B1_ISBN")[1]		,0       ,        ,"G"  ,""                                  ,"ISBN"   	,      ,"","mv_par04","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[04,1],	aHelp[04,2],	aHelp[04,3],	"" )

PutSx1(cPerg,"05","มrea"				,"มrea"      			,"มrea"				         ,"mv_ch5" ,"C" ,TamSX3("B5_XAREA")[1]		,0       ,        ,"G"  ,""                                  ,"SZ7"   	,      ,"","mv_par05","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[05,1],	aHelp[05,2],	aHelp[05,3],	"" )
PutSx1(cPerg,"06","Curso"				,"Curso"			    ,"Curso"		           	 ,"mv_ch6" ,"C" ,TamSX3("B5_XCURSO")[1]	,0       ,        ,"G"  ,""                                  ,"MVSZ5"   ,      ,"","mv_par06","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[06,1],	aHelp[06,2],	aHelp[06,3],	"" )
PutSx1(cPerg,"07","Disciplina"	   		,"Disciplina"      		,"Disciplina"           	 ,"mv_ch7" ,"C" ,TamSX3("B5_XDISCIP")[1]	,0       ,        ,"G"  ,""                                  ,"MVSZ6"   ,      ,"","mv_par07","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[07,1],	aHelp[07,2],	aHelp[07,3],	"" )

PutSx1(cPerg,"08","UTM Source"			,"UTM Source"      		,"UTM Source"				 ,"mv_ch8" ,"C" ,99							,0       ,        ,"G"  ,""                                  ,""	   	,      ,"","mv_par08","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[08,1],	aHelp[08,2],	aHelp[08,3],	"" )
PutSx1(cPerg,"09","UTM Medium"			,"UTM Medium"			,"UTM Medium"		         ,"mv_ch9" ,"C" ,50							,0       ,        ,"G"  ,""                                  ,""   		,      ,"","mv_par09","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[09,1],	aHelp[09,2],	aHelp[09,3],	"" )
PutSx1(cPerg,"10","UTM Campaign"	   	,"UTM Campaign"      	,"UTM Campaign"           	 ,"mv_chA" ,"C" ,50							,0       ,        ,"G"  ,""                                  ,""   		,      ,"","mv_par10","","","","","","",				"",				"",							"",				"",				"",					"",				"",				"",				"",				"",				aHelp[10,1],	aHelp[10,2],	aHelp[10,3],	"" )

PutSx1(cPerg,"11","Quebra Totalizadores","Quebra Totalizadores","Quebra Totalizadores"		 ,"mv_chB" ,"N"	,1							,0		 ,		  ,"C"	,""									  ,""		,""	   ,"","mv_par11","SOURCE","SOURCE","SOURCE","","MEDIUM","MEDIUM","MEDIUM","CAMPAIGN","CAMPAIGN","CAMPAIGN","OBRA (ISBN)","OBRA (ISBN)","OBRA (ISBN)","Pedido","Pedido","Pedido",nil,nil,nil,	"")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva as แreas originais                                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )  
*/
