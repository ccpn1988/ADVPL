#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER018

DESCRICAO: RANKING DOS BEST SELLERS NAO COMPRADOS

ALTERACOES:
08/08/2016 - Desenvolvimento do fonte

/*/

User Function GER018

Local oReport
Local cPerg := "GER18"

//Cria grupo de perguntas
//f001(cPerg) 

//Carrega grupo de perguntas
//If Pergunte(cPerg,.T.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
//Endif

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
*/
Static Function f001(cPerg)

PutSx1(cPerg, "01", "Data (mês fechado)","Data (mês fechado)"	,"Data (mês fechado)"	, "mv_ch1"	, "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Cliente:"			,"Cliente:"		  		,"Cliente:"				, "mv_ch2"	, "C",90, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Conceito Grupo?"	,"Conceito Grupo?"		,"Conceito Grupo?"		, "mv_ch3"	, "C", 3, 0, 1, "C","", "", "", "", "MV_PAR03", "Sim", "Sim", "Sim", "", "Não", "Não", "Não", "", "", "", "", "","", "", "", "", "", "", "", "" )


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
------------------------------------------------------------------------------------------------
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
/*
_cAno    := YEAR2STR(MV_PAR01)
_cAnoAnt := YEAR2STR(YEAR(MV_PAR01) - 1)
_cDataFim:= DTOC(LASTDATE(MV_PAR01))
*/
//Declaracao do relatorio
oReport := TReport():New("GER018","GER018 - Ranking dos Best Sellers Não Comprados",cPerg,{|oReport| PrintReport(oReport)},"GER018 - Ranking dos Best Sellers Não Comprados",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","")
	
//Celulas da secao
TRCell():New(oSection1,"RAIZ"			,"","Raiz CNPJ",,18)
TRCell():New(oSection1,"DESCRICAO"		,"","Descrição",,40)
TRCell():New(oSection1,"UF"				,"","UF",,10)
TRCell():New(oSection1,"MUNICIPIO"		,"","Município",,20)
TRCell():New(oSection1,"TIPOCLIENTE"	,"","Tipo Cliente",,20)
TRCell():New(oSection1,"VENDEDOR"		,"","Vendedor",,20)

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"","")

TRCell():New(oSection2,"SPACE1"			,"","",,2)
TRCell():New(oSection2,"B1_ISBN"		,"","ISBN",,18) 
TRCell():New(oSection2,"B1_DESC"		,"","Descrição",,20) 
TRCell():New(oSection2,"SELO"			,"","Selo",,12) 
TRCell():New(oSection2,"B5_XDTPUBL"		,"","Dt.Publicação",,15) 
TRCell():New(oSection2,"TIPOPUBLICACAO"	,"","Tp.Publicação",,15)
TRCell():New(oSection2,"CATEGORIA"		,"","Categoria",,10)
TRCell():New(oSection2,"AREA"			,"","Área"	,,15)
TRCell():New(oSection2,"CURSO"			,"","Curso"	,,15)
TRCell():New(oSection2,"DISCIPLINA"		,"","Disciplina",,15)
TRCell():New(oSection2,"DA1_PRCVEN"		,"","Preço","@E 9,999.99",12,,,,,"RIGHT")

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery1	:= ""
Local _cQuery2	:= ""
Local xCGC      := ""
//Local lPlanilha := oReport:nDevice == 4
/*
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)
*/
_cQuery1 := "SELECT R.RAIZ, SA1.DESCRICAO, SA1.UF, SA1.MUNICIPIO, SA1.TIPOCLIENTE, SA1.VENDEDOR, R.RANK, R.RANK_ACUM
_cQuery1 += "  FROM (SELECT RAIZ, LIQUIDO, TOTAL, RANK, SUM(RANK) OVER(ORDER BY RANK DESC) RANK_ACUM
_cQuery1 += "          FROM (SELECT RAIZ, LIQUIDO, SUM(LIQUIDO) OVER() TOTAL, LIQUIDO/SUM(LIQUIDO) OVER() RANK
_cQuery1 += "                  FROM (SELECT RAIZ, SUM(LIQUIDO) LIQUIDO
_cQuery1 += "                          FROM (SELECT SUBSTR(SA1.A1_CGC,1,8) RAIZ, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery1 += "                                  FROM " + RetSqlName("SD2") + " SD2
_cQuery1 += "                                  JOIN " + RetSqlName("SB1") + " SB1
_cQuery1 += "                                    ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "                                   AND SB1.B1_XIDTPPU <> ' '
_cQuery1 += "                                   AND SB1.B1_FILIAL  = '"+ xFilial("SB1") +"'"
_cQuery1 += "                                   AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                                  JOIN " + RetSqlName("SA1") + " SA1
_cQuery1 += "                                    ON SD2.D2_CLIENTE = SA1.A1_COD
_cQuery1 += "                                   AND SD2.D2_LOJA = SA1.A1_LOJA
_cQuery1 += "                                   AND SA1.A1_XCANALV = '1'
_cQuery1 += "                                   AND SA1.A1_FILIAL  = '"+ xFilial("SA1") +"'"
_cQuery1 += "                                   AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                                 WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND D_E_L_E_T_  = ' ')
_cQuery1 += "                                   AND SD2.D2_EMISSAO BETWEEN '20160101' AND '20160731'
_cQuery1 += "                                   AND SD2.D2_TIPO NOT IN ('D','B')
_cQuery1 += "                                   AND SD2.D2_FILIAL  = '"+ xFilial("SD2") +"'"
_cQuery1 += "                                   AND SD2.D_E_L_E_T_ = ' '
_cQuery1 += "                                 GROUP BY SUBSTR(SA1.A1_CGC,1,8)
_cQuery1 += "                                UNION ALL
_cQuery1 += "                                SELECT SUBSTR(SA1.A1_CGC,1,8) RAIZ, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO
_cQuery1 += "                                  FROM " + RetSqlName("SD1") + " SD1
_cQuery1 += "                                  JOIN " + RetSqlName("SB1") + " SB1
_cQuery1 += "                                    ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "                                   AND SB1.B1_FILIAL  = '"+ xFilial("SB1") +"'"
_cQuery1 += "                                   AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "                                  JOIN " + RetSqlName("SA1") + " SA1
_cQuery1 += "                                    ON SD1.D1_FORNECE = SA1.A1_COD
_cQuery1 += "                                   AND SD1.D1_LOJA = SA1.A1_LOJA
_cQuery1 += "                                   AND SA1.A1_XCANALV = '1'
_cQuery1 += "                                   AND SA1.A1_FILIAL  = '"+ xFilial("SA1") +"'"
_cQuery1 += "                                   AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "                                 WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND F4_CODIGO < '400' AND D_E_L_E_T_  = ' ')
_cQuery1 += "                                   AND SD1.D1_DTDIGIT BETWEEN '20160101' AND '20160731'
_cQuery1 += "                                   AND SD1.D1_TIPO    = 'D'
_cQuery1 += "                                   AND SD1.D1_FILIAL  = '"+ xFilial("SD1") +"'"
_cQuery1 += "                                   AND SD1.D_E_L_E_T_ = ' '
_cQuery1 += "                                  GROUP BY SUBSTR(SA1.A1_CGC,1,8))
_cQuery1 += "                         GROUP BY RAIZ)
_cQuery1 += "                 ORDER BY LIQUIDO DESC) ORDER BY RANK DESC) R
_cQuery1 += "  JOIN (SELECT SUBSTR(SA1.A1_CGC,1,8) RAIZ, MIN(SA1.A1_NOME) DESCRICAO, MIN(SA1.A1_EST) UF, MIN(CC2.CC2_MUN) MUNICIPIO,
_cQuery1 += "               MIN(STP.X5_DESCRI) TIPOCLIENTE, MIN(SZ2.X5_DESCRI) CANAL, MIN(SA3.A3_NOME) VENDEDOR
_cQuery1 += "	        FROM " + RetSqlName("SA1") + " SA1
_cQuery1 += "	        LEFT JOIN " + RetSqlName("CC2") + " CC2
_cQuery1 += "	          ON SA1.A1_EST = CC2.CC2_EST
_cQuery1 += "	         AND SA1.A1_COD_MUN = CC2.CC2_CODMUN
_cQuery1 += "	         AND CC2.CC2_FILIAL = '"+ xFilial("CC2") +"'"
_cQuery1 += "	         AND CC2.D_E_L_E_T_ = ' '
_cQuery1 += "	        LEFT JOIN " + RetSqlName("SX5") + " STP
_cQuery1 += "	          ON SA1.A1_XTIPCLI = STP.X5_CHAVE
_cQuery1 += "	         AND STP.X5_TABELA = 'TP'
_cQuery1 += "	         AND STP.X5_FILIAL = '"+ xFilial("SX5") +"'"
_cQuery1 += "	         AND STP.D_E_L_E_T_ = ' '
_cQuery1 += "	        LEFT JOIN " + RetSqlName("SX5") + " SZ2
_cQuery1 += "	          ON SA1.A1_XCANALV = SZ2.X5_CHAVE
_cQuery1 += "	         AND SZ2.X5_TABELA = 'Z2'
_cQuery1 += "	         AND SZ2.X5_FILIAL = '"+ xFilial("SX5") +"'"
_cQuery1 += "	         AND SZ2.D_E_L_E_T_ = ' '
_cQuery1 += "	        LEFT JOIN " + RetSqlName("SA3") + " SA3
_cQuery1 += "	          ON SA1.A1_VEND = SA3.A3_COD
_cQuery1 += "	          AND SA3.A3_FILIAL = '"+ xFilial("SA3") +"'"
_cQuery1 += "	          AND SA3.D_E_L_E_T_ = ' '
_cQuery1 += "	        WHERE SA1.A1_FILIAL = '"+ xFilial("SA1") +"'"
_cQuery1 += "	          AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "	        GROUP BY SUBSTR(SA1.A1_CGC,1,8)) SA1
_cQuery1 += "    ON R.RAIZ = SA1.RAIZ
_cQuery1 += " WHERE ROUND(RANK_ACUM,2) <= 0.80
_cQuery1 += " ORDER BY RANK_ACUM
		  	
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xCGC := (_cAlias1)->RAIZ

	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("RAIZ"):SetValue((_cAlias1)->RAIZ)
	oSection1:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
	oSection1:Cell("UF"):SetValue((_cAlias1)->UF)
	oSection1:Cell("MUNICIPIO"):SetValue((_cAlias1)->MUNICIPIO)
	oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
	oSection1:Cell("VENDEDOR"):SetValue((_cAlias1)->VENDEDOR)
 	
	oSection1:PrintLine()

	_cQuery2 := "SELECT SB1.B1_ISBN, SB1.B1_DESC, TRIM(XZ1.X5_DESCRI) SELO, SB5.B5_XDTPUBL, TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO,
	_cQuery2 += "       DECODE(SBM.BM_XCATEG, 'D', 'DID', 'P', 'PROF', 'I', 'INT.GER') ||' - '|| DECODE(SB5.B5_XTIPINC, 1, 'ON', 2, 'NE') CATEGORIA,
	_cQuery2 += "       TRIM(SZ7.Z7_DESC) AREA, TRIM(SZ5.Z5_DESC) CURSO, TRIM(SZ6.Z6_DESC) DISCIPLINA, DA1.DA1_PRCVEN
	_cQuery2 += "  FROM (SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, ONC.CODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD
	_cQuery2 += "          FROM (SELECT CODHIS
	_cQuery2 += "                  FROM (SELECT CODHIS, LIQUIDO, TOTAL, RANK, SUM(RANK) OVER(ORDER BY RANK DESC) RANK_ACUM
	_cQuery2 += "                          FROM (SELECT CODHIS, LIQUIDO, SUM(LIQUIDO) OVER() TOTAL, LIQUIDO/SUM(LIQUIDO) OVER() RANK
	_cQuery2 += "                                  FROM (SELECT CODHIS, SUM(LIQUIDO) LIQUIDO
	_cQuery2 += "                                          FROM (SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
	_cQuery2 += "                                                  FROM " + RetSqlName("SD2") + " SD2
	_cQuery2 += "                                                  JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "                                                    ON SD2.D2_COD = SB1.B1_COD
	_cQuery2 += "                                                   AND SB1.B1_XSITOBR IN ('101','105')
	_cQuery2 += "                                                   AND SB1.B1_XIDTPPU NOT IN ('2','11','18','3','4','9','14','15','16','17','19','20','21','22','23','24','25')
	_cQuery2 += "                                                   AND SB1.B1_FILIAL  = '"+ xFilial("SB1") +"'"
	_cQuery2 += "                                                   AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                  LEFT JOIN " + RetSqlName("SB5") + " SB5
	_cQuery2 += "                                                    ON SB1.B1_COD = SB5.B5_COD
	_cQuery2 += "                                                   AND SB5.B5_XTABPRC = '1'
	_cQuery2 += "                                                   AND SB5.B5_FILIAL  = '"+ xFilial("SB5") +"'"
	_cQuery2 += "                                                   AND SB5.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                 WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND D_E_L_E_T_  = ' ')
	_cQuery2 += "                                                   AND SD2.D2_EMISSAO BETWEEN '20160101' AND '20160731'
	_cQuery2 += "                                                   AND SD2.D2_TIPO NOT IN ('D','B')
	_cQuery2 += "                                                   AND SD2.D2_FILIAL  = '"+ xFilial("SD2") +"'"
	_cQuery2 += "                                                   AND SD2.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                 GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
	_cQuery2 += "                                                UNION ALL
	_cQuery2 += "                                                SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO
	_cQuery2 += "                                                  FROM " + RetSqlName("SD1") + " SD1
	_cQuery2 += "                                                  JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "                                                    ON SD1.D1_COD = SB1.B1_COD
	_cQuery2 += "                                                   AND SB1.B1_FILIAL  = '"+ xFilial("SB1") +"'"
	_cQuery2 += "                                                   AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                  JOIN " + RetSqlName("SB5") + " SB5
	_cQuery2 += "                                                    ON SB1.B1_COD = SB5.B5_COD
	_cQuery2 += "                                                   AND SB5.B5_FILIAL  = '"+ xFilial("SB5") +"'"
	_cQuery2 += "                                                   AND SB5.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                 WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND F4_CODIGO < '400' AND D_E_L_E_T_  = ' ')
	_cQuery2 += "                                                   AND SD1.D1_DTDIGIT BETWEEN '20160101' AND '20160731'
	_cQuery2 += "                                                   AND SD1.D1_TIPO    = 'D'
	_cQuery2 += "                                                   AND SD1.D1_FILIAL  = '"+ xFilial("SD1") +"'"
	_cQuery2 += "                                                   AND SD1.D_E_L_E_T_ = ' '
	_cQuery2 += "                                                 GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS)))
	_cQuery2 += "                                         GROUP BY CODHIS)
	_cQuery2 += "                                 ORDER BY LIQUIDO DESC))
	_cQuery2 += "                 WHERE ROUND(RANK_ACUM,2) <= 0.50
	_cQuery2 += "                 MINUS
	_cQuery2 += "                 SELECT DISTINCT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS
	_cQuery2 += "                   FROM " + RetSqlName("SD2") + " SD2
	_cQuery2 += "                   JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "                     ON SD2.D2_COD = SB1.B1_COD
	_cQuery2 += "                    AND SB1.B1_XSITOBR IN ('101','105')
	_cQuery2 += "                    AND SB1.B1_XIDTPPU NOT IN ('2','11','18','3','4','9','14','15','16','17','19','20','21','22','23','24','25')
	_cQuery2 += "                    AND SB1.B1_FILIAL  = '"+ xFilial("SB1") +"'"
	_cQuery2 += "                    AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "                   LEFT JOIN " + RetSqlName("SB5") + " SB5
	_cQuery2 += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery2 += "                    AND SB5.B5_XTABPRC = '1'
	_cQuery2 += "                    AND SB5.B5_FILIAL  = '"+ xFilial("SB5") +"'"
	_cQuery2 += "                    AND SB5.D_E_L_E_T_ = ' '
	_cQuery2 += "                   JOIN " + RetSqlName("SA1") + " SA1
	_cQuery2 += "                     ON SA1.A1_COD = SD2.D2_CLIENTE
	_cQuery2 += "                    AND SA1.A1_LOJA = SD2.D2_LOJA
	_cQuery2 += "                    AND SUBSTR(SA1.A1_CGC,1,8) = '"+ xCGC +"'"
	_cQuery2 += "                    AND SA1.A1_FILIAL = '"+ xFilial("SA1") +"'"
	_cQuery2 += "                    AND SA1.D_E_L_E_T_ = ' '
	_cQuery2 += "                  WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND D_E_L_E_T_  = ' ')
	_cQuery2 += "                    AND SD2.D2_EMISSAO BETWEEN '20160609' AND '20160808'
	_cQuery2 += "                    AND SD2.D2_TIPO NOT IN ('D','B')
	_cQuery2 += "                    AND SD2.D2_FILIAL  = '"+ xFilial("SD2") +"'"
	_cQuery2 += "                    AND SD2.D_E_L_E_T_ = ' ') ONC
	_cQuery2 += "          LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_COD)) B5_COD, TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS
	_cQuery2 += "                       FROM " + RetSqlName("SB5")
	_cQuery2 += "                      WHERE B5_XFEC = '1'                
	_cQuery2 += "                        AND B5_FILIAL = '"+ xFilial("SB5") +"'"
	_cQuery2 += "                        AND D_E_L_E_T_ = ' ') FEC
	_cQuery2 += "            ON ONC.CODHIS = FEC.B5_XCODHIS
	_cQuery2 += "          LEFT JOIN (SELECT TO_NUMBER(TRIM(SB5.B5_COD)) B5_COD, TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS
	_cQuery2 += "                       FROM " + RetSqlName("SB5") + " SB5, 
	_cQuery2 += "                            (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, MAX(B5_XDTPUBL) B5_XDTPUBL
	_cQuery2 += "                               FROM " + RetSqlName("SB5")
    _cQuery2 += "                              WHERE B5_FILIAL = '"+ xFilial("SB5") +"'"                         
	_cQuery2 += "                                AND D_E_L_E_T_ = ' '
	_cQuery2 += "                              GROUP BY TO_NUMBER(TRIM(B5_XCODHIS))) M
	_cQuery2 += "                      WHERE TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = M.B5_XCODHIS
	_cQuery2 += "                        AND SB5.B5_XDTPUBL = M.B5_XDTPUBL
	_cQuery2 += "                        AND TRIM(SB5.B5_XFEC) <> '1'
    _cQuery2 += "                        AND SB5.B5_FILIAL = '"+ xFilial("SB1") +"'"
	_cQuery2 += "                        AND SB5.D_E_L_E_T_ = ' ') SFEC
	_cQuery2 += "            ON ONC.CODHIS = SFEC.B5_XCODHIS) O
	_cQuery2 += "  JOIN " + RetSqlName("SB1") + " SB1
	_cQuery2 += "    ON O.B1_COD = SB1.B1_COD
	_cQuery2 += "   AND SB1.B1_FILIAL = '"+ xFilial("SB1") +"'"
	_cQuery2 += "   AND SB1.D_E_L_E_T_ = ' '
	_cQuery2 += "  JOIN " + RetSqlName("SB5") + " SB5
	_cQuery2 += "    ON SB1.B1_COD = SB5.B5_COD
	_cQuery2 += "   AND SB5.B5_FILIAL = '"+ xFilial("SB5") +"'"
	_cQuery2 += "   AND SB5.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
	_cQuery2 += "    ON XZ1.X5_CHAVE = B5_XSELO
	_cQuery2 += "   AND XZ1.X5_FILIAL = '"+ xFilial("SX5") +"'"
	_cQuery2 += "   AND XZ1.X5_TABELA = 'Z1'
	_cQuery2 += "   AND XZ1.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
	_cQuery2 += "    ON XZ4.X5_CHAVE = B1_XIDTPPU
	_cQuery2 += "   AND XZ4.X5_FILIAL = '"+ xFilial("SX5") +"'"
	_cQuery2 += "   AND XZ4.X5_TABELA = 'Z4'
	_cQuery2 += "   AND XZ4.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
	_cQuery2 += "    ON BM_GRUPO = B1_GRUPO
	_cQuery2 += "   AND BM_FILIAL = '"+ xFilial("SBM") +"'"
	_cQuery2 += "   AND SBM.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
	_cQuery2 += "    ON Z7_AREA = B5_XAREA
	_cQuery2 += "   AND Z7_FILIAL = '"+ xFilial("SZ7") +"'"
	_cQuery2 += "   AND SZ7.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SZ5") + " SZ5
	_cQuery2 += "    ON Z5_CURSO = B5_XCURSO
	_cQuery2 += "   AND Z5_FILIAL = '"+ xFilial("SZ5") +"'"
	_cQuery2 += "   AND SZ5.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("SZ6") + " SZ6
	_cQuery2 += "    ON Z6_DISCIPL = B5_XDISCIP
	_cQuery2 += "   AND Z6_FILIAL = '"+ xFilial("SZ6") +"'"
	_cQuery2 += "   AND SZ6.D_E_L_E_T_ = ' '
	_cQuery2 += "  LEFT JOIN " + RetSqlName("DA1") + " DA1
	_cQuery2 += "    ON DA1_CODPRO = SB1.B1_COD
	_cQuery2 += "   AND DA1_CODTAB = '160'
	_cQuery2 += "   AND DA1_FILIAL = '"+ xFilial("DA1") +"'"
	_cQuery2 += "   AND DA1.D_E_L_E_T_ = ' '
	_cQuery2 += "  ORDER BY SB1.B1_DESC
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias2, .F., .T.)
	
	Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()        

		oReport:IncMeter()
		oSection2:Init()
		oSection2:SetHeaderSection(.T.)

		oSection2:Cell("B1_ISBN"):SetValue((_cAlias2)->B1_ISBN)
		oSection2:Cell("B1_DESC"):SetValue((_cAlias2)->B1_DESC)
 		oSection2:Cell("SELO"):SetValue((_cAlias2)->SELO)
		oSection2:Cell("B5_XDTPUBL"):SetValue((_cAlias2)->B5_XDTPUBL)
		oSection2:Cell("TIPOPUBLICACAO"):SetValue((_cAlias2)->TIPOPUBLICACAO)
		oSection2:Cell("CATEGORIA"):SetValue((_cAlias2)->CATEGORIA)
		oSection2:Cell("AREA"):SetValue((_cAlias2)->AREA)
		oSection2:Cell("CURSO"):SetValue((_cAlias2)->CURSO)
		oSection2:Cell("DISCIPLINA"):SetValue((_cAlias2)->DISCIPLINA)
		oSection2:Cell("DA1_PRCVEN"):SetValue((_cAlias2)->DA1_PRCVEN)
	
		oSection2:PrintLine()

		(_cAlias2)->(dbSkip())		
	EndDo
	oSection2:Finish()  
	oReport:SkipLine(1)
	(_cAlias1)->(dbSkip())		
EndDo
oSection2:Finish()
oSection1:Finish()
         
(_cAlias2)->(DbCloseArea())
(_cAlias1)->(DbCloseArea())
Return(.t.)