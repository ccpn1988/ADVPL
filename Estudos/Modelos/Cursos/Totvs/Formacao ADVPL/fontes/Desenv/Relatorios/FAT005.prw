#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT005    ºAutor  ³Erica Vieites       º Data ³  12/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Faturamento Fornecedor Padrão                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT005()             

Local oReport
Local cPerg := "FAT005"
Local aAreaSM0 := SM0->(Getarea())

//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Emissão de:" , "Dt Emissão de:" ,"Dt Emissão de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissão até:", "Dt Emissão até" ,"Dt Emissão até", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relatório:"     , "Relatório:"     ,"Relatório:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Sintético", "Sintético", "Sintético", "", "Analítico", "Analítico", "Analítico", "", "", "", "", "","", "", "", "", "", "", "", "" )
                          
//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Restarea(aAreaSM0)

Return

     

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local oSection4

//Declaracao do relatorio
If (MV_PAR03 == 1)
	oReport := TReport():New("FAT003","FAT003 - Faturamento por Empresa (Sintético)",cPerg,{|oReport| PrintReport(oReport)},"FAT003 - Faturamento por Empresa (Sintético)")
else
	oReport := TReport():New("FAT003","FAT003 - Faturamento por Empresa (Analítico)",cPerg,{|oReport| PrintReport(oReport)},"FAT003 - Faturamento por Empresa (Analítico)")
Endif

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Celulas da secao
If (MV_PAR03 == 1)
	//Secao do relatorio
	oSection1 := TRSection():New(oReport,"Total","")
	
	TRCell():New(oSection1,"CHAVE"		,"","",,0)
	TRCell():New(oSection1,"SPACE1"		,"","Total Geral",,49)
	TRCell():New(oSection1,"TQTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection1,"TQTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALORVENDA","","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection1,"TQTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection2 := TRSection():New(oReport,"Filial","")
	
	TRCell():New(oSection2,"FILIAL"		,"","Filial",,4)
	TRCell():New(oSection2,"NOMEFIL"	,"","Nome",,16)
	TRCell():New(oSection2,"SPACE2"		,"","",,26)
	TRCell():New(oSection2,"FQTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection2,"FQTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALORVENDA","","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection2,"FQTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection3 := TRSection():New(oSection2,"Tipo","")

	TRCell():New(oSection3,"TIPO"		 ,"","Tipo",,50)
	TRCell():New(oSection3,"TPQTDE"		 ,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALOR"	 ,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection3,"TPQTDEVENDA" ,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALORVENDA","","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection3,"TPQTDEDEV"	 ,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALORDEV"	 ,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection4 := TRSection():New(oSection3,"Fornecedor","")

	TRCell():New(oSection4,"B1_PROC"	,"","Código",,8)
	TRCell():New(oSection4,"B1_LOJPROC"	,"","Loja",,5)
	TRCell():New(oSection4,"A2_NOME"	,"","Fornecedor",,35)
	TRCell():New(oSection4,"QTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection4,"QTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALORVENDA"	,"","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection4,"QTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")
Else
	//Secao do relatorio
	oSection1 := TRSection():New(oReport,"Total","")
	TRCell():New(oSection1,"CHAVE"		,"","",,0)
	TRCell():New(oSection1,"SPACE1"		,"","Total Geral",,9)
	TRCell():New(oSection1,"SPACE1"		,"","",,53)
	TRCell():New(oSection1,"TQTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection1,"TQTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALORVENDA","","Valor Venda",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection1,"TQTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection1,"TVALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection2 := TRSection():New(oReport,"Filial","")
	
	TRCell():New(oSection2,"FILIAL"		,"","Filial",,4)
	TRCell():New(oSection2,"NOMEFIL"	,"","Nome",,16)
	TRCell():New(oSection2,"SPACE2"		,"","",,46)
	TRCell():New(oSection2,"FQTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection2,"FQTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALORVENDA","","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection2,"FQTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection2,"FVALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection3 := TRSection():New(oSection2,"Tipo","")

	TRCell():New(oSection3,"B1_PROC"	 ,"","Código",,8)
	TRCell():New(oSection3,"B1_LOJPROC"	 ,"","Loja",,5)
	TRCell():New(oSection3,"A2_NOME"	 ,"","Fornecedor",,35)
	TRCell():New(oSection3,"TIPO"		 ,"","Tipo",,21)
	TRCell():New(oSection3,"TPQTDE"		 ,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALOR"	 ,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection3,"TPQTDEVENDA" ,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALORVENDA","","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection3,"TPQTDEDEV"	 ,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection3,"TPVALORDEV"	 ,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")

	//Secao do relatorio
	oSection4 := TRSection():New(oSection3,"Documento","")

	TRCell():New(oSection4,"DOC"		,"","Documento",,9)
	TRCell():New(oSection4,"SERIE"		,"","Série",,5)
	TRCell():New(oSection4,"EMISSAO"	,"","Emissão",,10)
	TRCell():New(oSection4,"CLIENTE"	,"","Código",,8)
	TRCell():New(oSection4,"LOJA"		,"","Loja",,5)
	TRCell():New(oSection4,"RAZAO"		,"","Descrição",,30)
	TRCell():New(oSection4,"QTDE"		,"","Qtde",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALOR"		,"","Venda Liq. ((-) Dev.)",'@E 999,999,999.99',12,,,,,"RIGHT")
	TRCell():New(oSection4,"QTDEVENDA"	,"","Qtde Venda",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALORVENDA"	,"","Valor Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
	TRCell():New(oSection4,"QTDEDEV"	,"","Qtde Dev.",'@E 9,999,999',10,,,,,"RIGHT")
	TRCell():New(oSection4,"VALORDEV"	,"","Valor Dev.",'@E 999,999,999.99',12,,,,,"RIGHT")
Endif  

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oSection2:Section(1)
Local oSection4 := oSection3:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cQuery	:= ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

If (MV_PAR03 == 1) 
	_cQuery := "SELECT CHAVE, FILIAL, B1_PROC, B1_LOJPROC, TIPO, A2_NOME, QTDE, VALOR, QTDEVENDA, VALORVENDA, QTDEDEV, VALORDEV,
	_cQuery += " 	   SUM(QTDE) OVER(PARTITION BY FILIAL||TIPO) TPQTDE, SUM(VALOR) OVER(PARTITION BY FILIAL||TIPO) TPVALOR,
	_cQuery += "  	   SUM(QTDEVENDA) OVER(PARTITION BY FILIAL||TIPO) TPQTDEVENDA, SUM(VALORVENDA) OVER(PARTITION BY FILIAL||TIPO) TPVALORVENDA,
	_cQuery += "  	   SUM(QTDEDEV) OVER(PARTITION BY FILIAL||TIPO) TPQTDEDEV, SUM(VALORDEV) OVER(PARTITION BY FILIAL||TIPO) TPVALORDEV,
	_cQuery += " 	   SUM(QTDE) OVER(PARTITION BY FILIAL) FQTDE, SUM(VALOR) OVER(PARTITION BY FILIAL) FVALOR,
	_cQuery += "  	   SUM(QTDEVENDA) OVER(PARTITION BY FILIAL) FQTDEVENDA, SUM(VALORVENDA) OVER(PARTITION BY FILIAL) FVALORVENDA,
	_cQuery += "  	   SUM(QTDEDEV) OVER(PARTITION BY FILIAL) FQTDEDEV, SUM(VALORDEV) OVER(PARTITION BY FILIAL) FVALORDEV,
	_cQuery += " 	   SUM(QTDE) OVER() TQTDE, SUM(VALOR) OVER() TVALOR,
	_cQuery += "  	   SUM(QTDEVENDA) OVER() TQTDEVENDA, SUM(VALORVENDA) OVER() TVALORVENDA,
	_cQuery += "  	   SUM(QTDEDEV) OVER() TQTDEDEV, SUM(VALORDEV) OVER() TVALORDEV
	_cQuery += "  FROM (SELECT D.FILIAL, D.B1_PROC, D.B1_LOJPROC, DECODE(D.B1_TIPO,'PA','Produto','SV','Serviço') TIPO, TRIM(SA2.A2_NOME) AS A2_NOME,
	_cQuery += " 	           SUM(D.QTDEVENDA-D.QTDEDEV) AS QTDE, SUM(D.VALORVENDA-D.VALORDEV) AS VALOR, SUM(D.QTDEVENDA) AS QTDEVENDA,
	_cQuery += "  	           SUM(D.VALORVENDA) AS VALORVENDA, SUM(D.QTDEDEV) AS QTDEDEV, SUM(D.VALORDEV) AS VALORDEV, D.FILIAL||D.B1_TIPO CHAVE
	_cQuery += "          FROM (SELECT FILIAL, B1_PROC, B1_LOJPROC, B1_TIPO, SUM(QTDEVENDA) QTDEVENDA, SUM(QTDEDEV) QTDEDEV, SUM(VALORVENDA) VALORVENDA, SUM(VALORDEV) VALORDEV
	_cQuery += "	 	          FROM (SELECT SD2.D2_FILIAL FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END),0) QTDEVENDA, 0 QTDEDEV, NVL(SUM(SD2.D2_VALBRUT),0) VALORVENDA, 0 VALORDEV
	_cQuery += "	                      FROM " + RetSqlName("SD2") + " SD2
	_cQuery += "	                      JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += "        			        ON SD2.D2_COD = SB1.B1_COD
	_cQuery += "                         WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ') 
	_cQuery += "    		         	   AND SD2.D2_TIPO NOT IN ('D','B')
	_cQuery += "                           AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery += "	         	           AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) + "'"
	_cQuery += "	                 	   AND SD2.D_E_L_E_T_ = ' '
	_cQuery += "        	         	   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += "	                 	   AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "	     	  	         GROUP BY SD2.D2_FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO
	_cQuery += "         	      	     UNION ALL 
	_cQuery += "	             	  	SELECT SD1.D1_FILIAL FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0), 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)
	_cQuery += "	       	  	          FROM " + RetSqlName("SD1") + " SD1
	_cQuery += "        	       	  	  JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += "	              	        ON SD1.D1_COD = SB1.B1_COD
	_cQuery += "                         WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ') 
	_cQuery += "                   	   	   AND SD1.D1_TIPO = 'D'
	_cQuery += "                           AND SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery += "        	       	   	   AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) + "'"
	_cQuery += "	                 	   AND SD1.D_E_L_E_T_ = ' '
	_cQuery += "	                 	   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += "	         	           AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "        	      	     GROUP BY SD1.D1_FILIAL, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO)
	_cQuery += "	             GROUP BY FILIAL, B1_PROC, B1_LOJPROC, B1_TIPO) D
	_cQuery += "          LEFT JOIN " + RetSqlName("SA2") + " SA2 
	_cQuery += "            ON D.B1_PROC = SA2.A2_COD
	_cQuery += "           AND D.B1_LOJPROC = SA2.A2_LOJA
	_cQuery += "           AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
	_cQuery += "           AND SA2.D_E_L_E_T_ = ' '
	_cQuery += "         GROUP BY D.FILIAL, D.B1_PROC, D.B1_LOJPROC, D.B1_TIPO, TRIM(SA2.A2_NOME))
	_cQuery += " ORDER BY FILIAL DESC, TIPO, A2_NOME
Else
	_cQuery := "SELECT D.FILIAL, D.B1_PROC, D.B1_LOJPROC, DECODE(D.B1_TIPO,'PA','Produto','SV','Serviço') TIPO, TRIM(SA2.A2_NOME) AS A2_NOME,
	_cQuery += "	   D.CLIENTE, D.LOJA, TRIM(SA1.A1_NOME) AS RAZAO, D.DOC, D.SERIE, D.EMISSAO, D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC CHAVE,
	_cQuery += "       D.QTDEVENDA-D.QTDEDEV AS QTDE, D.VALORVENDA-D.VALORDEV AS VALOR,
	_cQuery += "	   D.QTDEVENDA, D.VALORVENDA, D.QTDEDEV, D.VALORDEV,
	_cQuery += "	   SUM(D.QTDEVENDA-D.QTDEDEV) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPQTDE, SUM(D.VALORVENDA-D.VALORDEV) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPVALOR,
	_cQuery += "       SUM(D.QTDEVENDA) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPQTDEVENDA, SUM(D.VALORVENDA) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPVALORVENDA,
	_cQuery += "	   SUM(D.QTDEDEV) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPQTDEDEV, SUM(D.VALORDEV) OVER(PARTITION BY D.FILIAL||D.B1_TIPO||D.B1_PROC||D.B1_LOJPROC) TPVALORDEV,
	_cQuery += "	   SUM(D.QTDEVENDA-D.QTDEDEV) OVER(PARTITION BY D.FILIAL) FQTDE, SUM(D.VALORVENDA-D.VALORDEV) OVER(PARTITION BY D.FILIAL) FVALOR,
	_cQuery += "       SUM(D.QTDEVENDA) OVER(PARTITION BY D.FILIAL) FQTDEVENDA, SUM(D.VALORVENDA) OVER(PARTITION BY D.FILIAL) FVALORVENDA,
	_cQuery += "	   SUM(D.QTDEDEV) OVER(PARTITION BY D.FILIAL) FQTDEDEV, SUM(D.VALORDEV) OVER(PARTITION BY D.FILIAL) FVALORDEV,
	_cQuery += "	   SUM(D.QTDEVENDA-D.QTDEDEV) OVER() TQTDE, SUM(D.VALORVENDA-D.VALORDEV) OVER() TVALOR,
	_cQuery += "       SUM(D.QTDEVENDA) OVER() TQTDEVENDA, SUM(D.VALORVENDA) OVER() TVALORVENDA,
	_cQuery += "	   SUM(D.QTDEVENDA) OVER() TQTDEDEV, SUM(D.VALORDEV) OVER() TVALORDEV
	_cQuery += "  FROM (SELECT SD2.D2_FILIAL FILIAL, SD2.D2_DOC DOC, SD2.D2_SERIE SERIE, SD2.D2_EMISSAO EMISSAO, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END),0) QTDEVENDA, 0 QTDEDEV, NVL(SUM(SD2.D2_VALBRUT),0) VALORVENDA,0 VALORDEV
	_cQuery += "   		  FROM " + RetSqlName("SD2") + " SD2
	_cQuery += "          JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += " 		    ON SD2.D2_COD = SB1.B1_COD
	_cQuery += "         WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ') 
	_cQuery += "       	   AND SD2.D2_TIPO NOT IN ('D','B')
	_cQuery += "	       AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery += " 	  	   AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) + "'"
	_cQuery += "	   	   AND SD2.D_E_L_E_T_ = ' '
	_cQuery += " 	  	   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
	_cQuery += " 	  	   AND SB1.D_E_L_E_T_ = ' '
	_cQuery += " 	     GROUP BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, SD2.D2_CLIENTE, SD2.D2_LOJA
	_cQuery += " 		 UNION ALL
	_cQuery += " 		SELECT SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_DTDIGIT, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, SD1.D1_FORNECE, SD1.D1_LOJA, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0), 0, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)
	_cQuery += " 		  FROM " + RetSqlName("SD1") + " SD1
	_cQuery += "   		  JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += " 		    ON SD1.D1_COD = SB1.B1_COD
	_cQuery += "         WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ') 
	_cQuery += "   	   	   AND SD1.D1_TIPO = 'D'
	_cQuery += " 	  	   AND SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
	_cQuery += " 	  	   AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'"
	_cQuery += "       	   AND SD1.D_E_L_E_T_ = ' '
	_cQuery += " 	  	   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery += " 	  	   AND SB1.D_E_L_E_T_ = ' '
	_cQuery += "    	 GROUP BY SD1.D1_FILIAL, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_DTDIGIT, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_TIPO, SD1.D1_FORNECE, SD1.D1_LOJA) D
	_cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2
	_cQuery += "    ON D.B1_PROC = SA2.A2_COD
	_cQuery += "   AND D.B1_LOJPROC = SA2.A2_LOJA
	_cQuery += "   AND SA2.A2_FILIAL = '" + xFilial("SA2") + "'"
	_cQuery += "   AND SA2.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1
	_cQuery += "    ON D.CLIENTE = SA1.A1_COD
	_cQuery += "   AND D.LOJA = SA1.A1_LOJA
	_cQuery += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
	_cQuery += " ORDER BY D.FILIAL DESC, TIPO, A2_NOME, D.EMISSAO, D.DOC
Endif

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oSection1:Init()  

	oSection1:Cell("CHAVE"      ):SetValue((_cAlias1)->CHAVE)
	oSection1:Cell("TQTDE"      ):SetValue((_cAlias1)->TQTDE)
	oSection1:Cell("TVALOR"     ):SetValue((_cAlias1)->TVALOR)
	oSection1:Cell("TQTDEVENDA" ):SetValue((_cAlias1)->TQTDEVENDA)
	oSection1:Cell("TVALORVENDA"):SetValue((_cAlias1)->TVALORVENDA)
	oSection1:Cell("TQTDEDEV"   ):SetValue((_cAlias1)->TQTDEDEV)
	oSection1:Cell("TVALORDEV"  ):SetValue((_cAlias1)->TVALORDEV)

	oSection1:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()        
		xFilial := (_cAlias1)->FILIAL
		oReport:IncMeter()

		_cNomeFil:= Posicione("SM0",1,SM0->M0_CODIGO+(_cAlias1)->FILIAL,"M0_FILIAL")

		oSection2:Init()  

		oSection2:Cell("FILIAL"     ):SetValue((_cAlias1)->FILIAL)
		oSection2:Cell("NOMEFIL"    ):SetValue(_cNomeFil)
		oSection2:Cell("FQTDE"      ):SetValue((_cAlias1)->FQTDE)
		oSection2:Cell("FVALOR"     ):SetValue((_cAlias1)->FVALOR)
		oSection2:Cell("FQTDEVENDA" ):SetValue((_cAlias1)->FQTDEVENDA)
		oSection2:Cell("FVALORVENDA"):SetValue((_cAlias1)->FVALORVENDA)
		oSection2:Cell("FQTDEDEV"   ):SetValue((_cAlias1)->FQTDEDEV)
		oSection2:Cell("FVALORDEV"  ):SetValue((_cAlias1)->FVALORDEV)

		oSection2:PrintLine()

		Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->FILIAL = xFilial .And. !oReport:Cancel()        
			xChave := (_cAlias1)->CHAVE
			oReport:IncMeter()

			oSection3:Init()

			If (MV_PAR03 == 2)
				oSection3:Cell("B1_PROC"   ):SetValue((_cAlias1)->B1_PROC)
				oSection3:Cell("B1_LOJPROC"):SetValue((_cAlias1)->B1_LOJPROC)
				oSection3:Cell("A2_NOME"   ):SetValue((_cAlias1)->A2_NOME)
			EndIf
			oSection3:Cell("TIPO"        ):SetValue((_cAlias1)->TIPO)
			oSection3:Cell("TPQTDE"      ):SetValue((_cAlias1)->TPQTDE)
			oSection3:Cell("TPVALOR"     ):SetValue((_cAlias1)->TPVALOR)
			oSection3:Cell("TPQTDEVENDA" ):SetValue((_cAlias1)->TPQTDEVENDA)
			oSection3:Cell("TPVALORVENDA"):SetValue((_cAlias1)->TPVALORVENDA)
			oSection3:Cell("TPQTDEDEV"   ):SetValue((_cAlias1)->TPQTDEDEV)
			oSection3:Cell("TPVALORDEV"  ):SetValue((_cAlias1)->TPVALORDEV)

			oSection3:PrintLine()

			Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->CHAVE = xChave .And. !oReport:Cancel()        
				oReport:IncMeter()
				oSection4:Init()
				If (MV_PAR03 == 1)
					oSection4:Cell("B1_PROC"   ):SetValue((_cAlias1)->B1_PROC)
					oSection4:Cell("B1_LOJPROC"):SetValue((_cAlias1)->B1_LOJPROC)
					oSection4:Cell("A2_NOME"   ):SetValue((_cAlias1)->A2_NOME)
				Else
			        xEmissao := STOD((_cAlias1)->EMISSAO)
		
					oSection4:Cell("DOC"       ):SetValue((_cAlias1)->DOC)
					oSection4:Cell("SERIE"     ):SetValue((_cAlias1)->SERIE)
					oSection4:Cell("EMISSAO"   ):SetValue(xEmissao)
					oSection4:Cell("CLIENTE"   ):SetValue((_cAlias1)->CLIENTE)
					oSection4:Cell("LOJA"      ):SetValue((_cAlias1)->LOJA)
					oSection4:Cell("RAZAO"     ):SetValue((_cAlias1)->RAZAO)
				EndIf
				oSection4:Cell("QTDE"      ):SetValue((_cAlias1)->QTDE)
				oSection4:Cell("VALOR"     ):SetValue((_cAlias1)->VALOR)
				oSection4:Cell("QTDEVENDA" ):SetValue((_cAlias1)->QTDEVENDA)
				oSection4:Cell("VALORVENDA"):SetValue((_cAlias1)->VALORVENDA)
				oSection4:Cell("QTDEDEV"   ):SetValue((_cAlias1)->QTDEDEV)
				oSection4:Cell("VALORDEV"  ):SetValue((_cAlias1)->VALORDEV)

				oSection4:PrintLine()

				(_cAlias1)->(dbSkip())		
			Enddo
			oReport:ThinLine()
			oReport:SkipLine(1)
       		oSection4:Finish()
		Enddo             
		oSection4:Finish()
		oSection3:Finish()
	EndDo
	oSection4:Finish()
	oSection3:Finish()
	oSection2:Finish()
EndDo
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
	         
DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)