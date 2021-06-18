#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER023

DESCRICAO: GER023 - DECUPACAO DO CATALOGO

ALTERACOES:
27/01/2016 - Desenvolvimento do fonte

/*/

User Function GER023

Local oReport
Local cPerg := "GER023"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
If Pergunte(cPerg,.T.)

	oReport := ReportDef(cPerg)
	oReport:PrintDialog()
Endif

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
Alteracoes:
27/01/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function f001(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:","Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
27/01/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

//Declaracao do relatorio
oReport := TReport():New("GER023","GER023 - DECUPAÇÃO DO CATÁLOGO - "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02),cPerg,{|oReport| PrintReport(oReport)},"GER023 - DECUPAÇÃO DO CATÁLOGO",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"GER023 - DECUPAÇÃO DO CATÁLOGO - "+DTOC(MV_PAR01)+" A "+DTOC(MV_PAR02),"")
	
//Celulas da secao
TRCell():New(oSection1,"DESCRICAO"	,"","VALORES EM R$ MIL",,34)
TRCell():New(oSection1,"AREA_1"		,"","SAÚDE",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE1"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"AREA_2"		,"","EXATAS",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE2"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"AREA_3"		,"","CONCURSO",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE3"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"AREA_4"		,"","JURÍDICO",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE4"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"AREA_5"		,"","SOCIAIS APLICADAS",,20,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE5"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"AREA_6"		,"","HUMANAS",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARE6"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 
TRCell():New(oSection1,"TAREA"		,"","TOTAL",,15,,,"RIGHT",,"RIGHT")
TRCell():New(oSection1,"SHARET"		,"","SHARE%",,8,,,"RIGHT",,"RIGHT") 

//Totalizadores
//TRFunction():New(oSection3:Cell("D2_QUANT")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 
//TRFunction():New(oSection3:Cell("D2_TOTAL")	,NIL,"SUM")//,oBreak01)  //,,,,.f.) 

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
27/01/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""
Local lPlanilha := oReport:nDevice == 4
Local aResult   := {}

 
_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

nShare := 100

_cQuery := "SELECT 'TOTAL' DESCRICAO,
_cQuery += "       SUM(DECODE(B5_XAREA, '000001', LIQUIDO, 0))/1000 AREA_1,
_cQuery += "  	   SUM(DECODE(B5_XAREA, '000002', LIQUIDO, 0))/1000 AREA_2,
_cQuery += "	   SUM(DECODE(B5_XAREA, '000005', LIQUIDO, 0))/1000 AREA_3,
_cQuery += "	   SUM(DECODE(B5_XAREA, '000006', LIQUIDO, 0))/1000 AREA_4,
_cQuery += "	   SUM(DECODE(B5_XAREA, '000007', LIQUIDO, 0))/1000 AREA_5,
_cQuery += "	   SUM(DECODE(B5_XAREA, '000008', LIQUIDO, 0))/1000 AREA_6
_cQuery += "  FROM (SELECT SB5.B5_XAREA, 
_cQuery += "               CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += "			              THEN 4
_cQuery += "			              WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "			              THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "				                      THEN 1
_cQuery += "                              ELSE 2 END
_cQuery += "				            ELSE 3 END IDCANAL,
_cQuery += "               SUM(LIQUIDO) LIQUIDO
_cQuery += "          FROM (SELECT D2_COD CODIGO, NVL(SUM(D2_VALBRUT), 0) LIQUIDO
_cQuery += "                  FROM " + RetSqlName("SD2")
_cQuery += "                 WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += "                   AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "                   AND D2_TIPO NOT IN ('D','B')
_cQuery += "                   AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "                   AND D_E_L_E_T_ = ' ' 
_cQuery += "                 GROUP BY D2_COD
_cQuery += "                UNION ALL
_cQuery += "                SELECT D1_COD, NVL(SUM(D1_TOTAL - D1_VALDESC), 0)*(-1)
_cQuery += "                  FROM " + RetSqlName("SD1")
_cQuery += "                 WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += "                   AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += "                   AND D1_TIPO = 'D'
_cQuery += "                   AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "                   AND D_E_L_E_T_ = ' '
_cQuery += "                 GROUP BY D1_COD) F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5
_cQuery += "         WHERE F.CODIGO = SB1.B1_COD 
_cQuery += "           AND SB1.B1_COD = SB5.B5_COD
_cQuery += "           AND SB1.B1_XIDTPPU = SX5.X5_CHAVE
_cQuery += "           AND SX5.X5_TABELA = 'Z4'
_cQuery += "           AND TRIM(SB1.B1_XIDTPPU) <> '11'
_cQuery += "           AND TRIM(SX5.X5_DESCENG) <> '1'
_cQuery += "           AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "           AND SX5.D_E_L_E_T_ = ' '
_cQuery += "           AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "           AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "         GROUP BY SB5.B5_XAREA, 
_cQuery += "                  CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += "	                     THEN 4
_cQuery += "	                     WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += "	                     THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "	                               THEN 1
_cQuery += "                                 ELSE 2 END
_cQuery += "	                     ELSE 3 END)
	
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection1:Init()  

    tArea_1 := (_cAlias1)->AREA_1
    tArea_2 := (_cAlias1)->AREA_2
    tArea_3 := (_cAlias1)->AREA_3
    tArea_4 := (_cAlias1)->AREA_4
    tArea_5 := (_cAlias1)->AREA_5
    tArea_6 := (_cAlias1)->AREA_6
	tArea   := (_cAlias1)->AREA_1 + (_cAlias1)->AREA_2 + (_cAlias1)->AREA_3 + (_cAlias1)->AREA_4 + (_cAlias1)->AREA_5 + (_cAlias1)->AREA_6
	
	oSection1:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
	oSection1:Cell("AREA_1"):SetValue("R$ " + Transform((_cAlias1)->AREA_1, "@E 999,999"))
	oSection1:Cell("SHARE1"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("AREA_2"):SetValue("R$ " + Transform((_cAlias1)->AREA_2, "@E 999,999"))
	oSection1:Cell("SHARE2"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("AREA_3"):SetValue("R$ " + Transform((_cAlias1)->AREA_3, "@E 999,999"))
	oSection1:Cell("SHARE3"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("AREA_4"):SetValue("R$ " + Transform((_cAlias1)->AREA_4, "@E 999,999"))
	oSection1:Cell("SHARE4"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("AREA_5"):SetValue("R$ " + Transform((_cAlias1)->AREA_5, "@E 999,999"))
	oSection1:Cell("SHARE5"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("AREA_6"):SetValue("R$ " + Transform((_cAlias1)->AREA_6, "@E 999,999"))
	oSection1:Cell("SHARE6"):SetValue(Transform(nShare,"@E 999.99") + "%")
	oSection1:Cell("TAREA"):SetValue("R$ " + Transform(tArea, "@E 999,999"))
	oSection1:Cell("SHARET"):SetValue(Transform(nShare,"@E 999.99") + "%")
                                                                 
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
         
oReport:SkipLine()

_cQuery	:= ""
	
_cQuery := "SELECT IDCANAL, 1 LINHA,
_cQuery += " DECODE(IDCANAL, 1, 'FAT.FRONT LIST NO PERÍODO', 2, 'FAT.NOVAS ED.NO PERÍODO', 3, 'FAT.BACK LIST NO PERÍODO', 4, 'FAT.PARCERIA/PROJ.ESP.(*)') DESCRICAO,
_cQuery += " SUM(DECODE(B5_XAREA, '000001', LIQUIDO, 0))/1000 AREA_1,
_cQuery += " SUM(DECODE(B5_XAREA, '000002', LIQUIDO, 0))/1000 AREA_2,
_cQuery += " SUM(DECODE(B5_XAREA, '000005', LIQUIDO, 0))/1000 AREA_3,
_cQuery += " SUM(DECODE(B5_XAREA, '000006', LIQUIDO, 0))/1000 AREA_4,
_cQuery += " SUM(DECODE(B5_XAREA, '000007', LIQUIDO, 0))/1000 AREA_5,
_cQuery += " SUM(DECODE(B5_XAREA, '000008', LIQUIDO, 0))/1000 AREA_6
_cQuery += " FROM (SELECT SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL,
_cQuery += " SUM(LIQUIDO) LIQUIDO
_cQuery += " FROM (SELECT D2_COD CODIGO, NVL(SUM(D2_VALBRUT), 0) LIQUIDO
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " GROUP BY D2_COD
_cQuery += " UNION ALL
_cQuery += " SELECT D1_COD, NVL(SUM(D1_TOTAL - D1_VALDESC), 0)*(-1)
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' '
_cQuery += " GROUP BY D1_COD) F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_XIDTPPU = SX5.X5_CHAVE
_cQuery += " AND SX5.X5_TABELA = 'Z4'
_cQuery += " AND TRIM(SB1.B1_XIDTPPU) <> '11'
_cQuery += " AND TRIM(SX5.X5_DESCENG) <> '1'
_cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += " AND SX5.D_E_L_E_T_ = ' '
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' '
_cQuery += " GROUP BY SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END)
_cQuery += " GROUP BY IDCANAL, DECODE(IDCANAL, 1, 'FAT.FRONT LIST NO PERÍODO', 2, 'FAT.NOVAS ED.NO PERÍODO', 3, 'FAT.BACK LIST NO PERÍODO', 4, 'FAT.PARCERIA/PROJ.ESP.(*)')
_cQuery += " UNION
_cQuery += " SELECT IDCANAL, 2 LINHA,
_cQuery += " DECODE(IDCANAL, 1, '# OBRAS NOVAS DE FRONT LIST', 2, '# NOVAS EDIÇÕES NO PERÍODO', 3, '# OBRAS DE BACK LIST', 4, '# OBRAS DE PARCERIA/PROJ.ESP.'),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000001' THEN CODIGO END),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000002' THEN CODIGO END),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000005' THEN CODIGO END),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000006' THEN CODIGO END),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000007' THEN CODIGO END),
_cQuery += " COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000008' THEN CODIGO END)
_cQuery += " FROM (SELECT SB5.B5_XAREA, F.CODIGO,
_cQuery += " CASE WHEN TRIM(SB1.B1_XSITOBR) IN ('101','105') THEN 1 ELSE 0 END ATIVA,
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL
_cQuery += " FROM (SELECT DISTINCT D2_COD CODIGO
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " UNION
_cQuery += " SELECT DISTINCT D1_COD
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ') F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5 "
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' ')
_cQuery += " GROUP BY IDCANAL, DECODE(IDCANAL, 1, '# OBRAS NOVAS DE FRONT LIST', 2, '# NOVAS EDIÇÕES NO PERÍODO', 3, '# OBRAS DE BACK LIST', 4, '# OBRAS DE PARCERIA/PROJ.ESP.')
_cQuery += " UNION
_cQuery += " SELECT IDCANAL, 3 LINHA, 'QUANTIDADE DE EXEMPLARES',
_cQuery += " SUM(DECODE(B5_XAREA, '000001', QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000002', QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000005', QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000006', QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000007', QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000008', QTDE, 0))
_cQuery += " FROM (SELECT SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL,
_cQuery += " SUM(QTDE) QTDE
_cQuery += " FROM (SELECT D2_COD CODIGO, NVL(SUM(D2_QUANT), 0) QTDE
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " GROUP BY D2_COD
_cQuery += " UNION ALL
_cQuery += " SELECT D1_COD, NVL(SUM(D1_QUANT), 0)*(-1)
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' '
_cQuery += " GROUP BY D1_COD) F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_XIDTPPU = SX5.X5_CHAVE
_cQuery += " AND SX5.X5_TABELA = 'Z4'
_cQuery += " AND TRIM(SB1.B1_XIDTPPU) <> '11'
_cQuery += " AND TRIM(SX5.X5_DESCENG) <> '1'
_cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += " AND SX5.D_E_L_E_T_ = ' '
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' '
_cQuery += " GROUP BY SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END)
_cQuery += " GROUP BY IDCANAL
_cQuery += " UNION
_cQuery += " SELECT IDCANAL, 4 LINHA, 'PREÇO MÉDIO',
_cQuery += " SUM(DECODE(B5_XAREA, '000001', LIQUIDO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000002', LIQUIDO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000005', LIQUIDO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000006', LIQUIDO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000007', LIQUIDO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000008', LIQUIDO/QTDE, 0))
_cQuery += " FROM (SELECT SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL,
_cQuery += " SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO
_cQuery += " FROM (SELECT D2_COD CODIGO, NVL(SUM(D2_QUANT), 0) QTDE, NVL(SUM(D2_VALBRUT), 0) LIQUIDO
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " GROUP BY D2_COD
_cQuery += " UNION ALL
_cQuery += " SELECT D1_COD, NVL(SUM(D1_QUANT), 0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC), 0)*(-1)
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' '
_cQuery += " GROUP BY D1_COD) F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_XIDTPPU = SX5.X5_CHAVE
_cQuery += " AND SX5.X5_TABELA = 'Z4'
_cQuery += " AND TRIM(SB1.B1_XIDTPPU) <> '11'
_cQuery += " AND TRIM(SX5.X5_DESCENG) <> '1'
_cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += " AND SX5.D_E_L_E_T_ = ' '
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' '
_cQuery += " GROUP BY SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END)
_cQuery += " GROUP BY IDCANAL
_cQuery += " UNION
_cQuery += " SELECT IDCANAL, 5 LINHA, 'PÁGINAS MÉDIAS',
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000001' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000001', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000001' THEN CODIGO END)),
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000002' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000002', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000002' THEN CODIGO END)),
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000005' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000005', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000005' THEN CODIGO END)),
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000006' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000006', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000006' THEN CODIGO END)),
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000007' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000007', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000007' THEN CODIGO END)),
_cQuery += " DECODE(COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000008' THEN CODIGO END), 0, 0, SUM(DECODE(B5_XAREA, '000008', QTDEPAG, 0)) / COUNT(CASE WHEN ATIVA = 1 AND B5_XAREA = '000008' THEN CODIGO END))
_cQuery += " FROM (SELECT SB5.B5_XAREA, F.CODIGO, SB5.B5_XQTDPAG QTDEPAG,
_cQuery += " CASE WHEN TRIM(SB1.B1_XSITOBR) IN ('101','105') THEN 1 ELSE 0 END ATIVA,
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL
_cQuery += " FROM (SELECT DISTINCT D2_COD CODIGO
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " UNION
_cQuery += " SELECT DISTINCT D1_COD
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ') F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5 "
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' ')
_cQuery += " GROUP BY IDCANAL
_cQuery += " UNION
_cQuery += " SELECT IDCANAL, 6 LINHA, 'PREÇO DE CAPA MÉDIO',
_cQuery += " SUM(DECODE(B5_XAREA, '000001', BRUTO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000002', BRUTO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000005', BRUTO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000006', BRUTO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000007', BRUTO/QTDE, 0)),
_cQuery += " SUM(DECODE(B5_XAREA, '000008', BRUTO/QTDE, 0))
_cQuery += " FROM (SELECT SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END IDCANAL,
_cQuery += " SUM(QTDE) QTDE, SUM(BRUTO) BRUTO
_cQuery += " FROM (SELECT D2_COD CODIGO, NVL(SUM(D2_QUANT), 0) QTDE, NVL(SUM(D2_QUANT*D2_PRUNIT), 0) BRUTO
_cQuery += " FROM " + RetSqlName("SD2")
_cQuery += " WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += " AND D2_TIPO NOT IN ('D','B')
_cQuery += " AND D2_EMISSAO BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' ' 
_cQuery += " GROUP BY D2_COD
_cQuery += " UNION ALL
_cQuery += " SELECT D1_COD, NVL(SUM(D1_QUANT), 0)*(-1), NVL(SUM(D1_TOTAL),0)*(-1)
_cQuery += " FROM " + RetSqlName("SD1")
_cQuery += " WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
_cQuery += " AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += " AND D1_TIPO = 'D'
_cQuery += " AND D1_DTDIGIT BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " AND D_E_L_E_T_ = ' '
_cQuery += " GROUP BY D1_COD) F, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " SX5
_cQuery += " WHERE F.CODIGO = SB1.B1_COD 
_cQuery += " AND SB1.B1_COD = SB5.B5_COD
_cQuery += " AND SB1.B1_XIDTPPU = SX5.X5_CHAVE
_cQuery += " AND SX5.X5_TABELA = 'Z4'
_cQuery += " AND TRIM(SB1.B1_XIDTPPU) <> '11'
_cQuery += " AND TRIM(SX5.X5_DESCENG) <> '1'
_cQuery += " AND SX5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += " AND SX5.D_E_L_E_T_ = ' '
_cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += " AND SB5.D_E_L_E_T_ = ' '
_cQuery += " GROUP BY SB5.B5_XAREA, 
_cQuery += " CASE WHEN TRIM(SB1.B1_XIDTPPU) IN ('2','3','4','5','6','12') 
_cQuery += " THEN 4
_cQuery += " WHEN SB5.B5_XDTPUBL BETWEEN '" + _cParm1 + "' and '" + _cParm2 + "'"
_cQuery += " THEN CASE WHEN TO_NUMBER(TRIM(F.CODIGO)) = TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += " THEN 1
_cQuery += " ELSE 2 END
_cQuery += " ELSE 3 END)
_cQuery += " GROUP BY IDCANAL
_cQuery += " ORDER BY IDCANAL, LINHA
 	
If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)

//DESABILITA IMPRESSAO DA SECAO
//oSection2:LHEADERSECTION := .f.

nCanal := 0
cShare := ' '

Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

    If nCanal <> (_cAlias2)->IDCANAL
		oReport:SkipLine()
		nCanal := (_cAlias2)->IDCANAL 
    EndIf

	tLinha := (_cAlias2)->AREA_1 + (_cAlias2)->AREA_2 + (_cAlias2)->AREA_3 + (_cAlias2)->AREA_4 + (_cAlias2)->AREA_5 + (_cAlias2)->AREA_6

	If (_cAlias2)->LINHA = 1
		nShare1 := (_cAlias2)->AREA_1 / tArea_1 * 100
		nShare2 := (_cAlias2)->AREA_2 / tArea_2 * 100
		nShare3 := (_cAlias2)->AREA_3 / tArea_3 * 100
		nShare4 := (_cAlias2)->AREA_4 / tArea_4 * 100
		nShare5 := (_cAlias2)->AREA_5 / tArea_5 * 100
		nShare6 := (_cAlias2)->AREA_6 / tArea_6 * 100
		nShareT := tLinha / tArea * 100
    EndIf

	oSection1:Cell("DESCRICAO"):SetValue((_cAlias2)->DESCRICAO)
    If (_cAlias2)->LINHA = 1
	 	oSection1:Cell("AREA_1"):SetValue("R$ " + Transform((_cAlias2)->AREA_1, "@E 999,999"))
		oSection1:Cell("SHARE1"):SetValue(Transform(nShare1,"@E 999.99") + "%")
	 	oSection1:Cell("AREA_2"):SetValue("R$ " + Transform((_cAlias2)->AREA_2, "@E 999,999"))
		oSection1:Cell("SHARE2"):SetValue(Transform(nShare2,"@E 999.99") + "%")
	 	oSection1:Cell("AREA_3"):SetValue("R$ " + Transform((_cAlias2)->AREA_3, "@E 999,999"))
		oSection1:Cell("SHARE3"):SetValue(Transform(nShare3,"@E 999.99") + "%")
	 	oSection1:Cell("AREA_4"):SetValue("R$ " + Transform((_cAlias2)->AREA_4, "@E 999,999"))
		oSection1:Cell("SHARE4"):SetValue(Transform(nShare4,"@E 999.99") + "%")
	 	oSection1:Cell("AREA_5"):SetValue("R$ " + Transform((_cAlias2)->AREA_5, "@E 999,999"))
		oSection1:Cell("SHARE5"):SetValue(Transform(nShare5,"@E 999.99") + "%")
	 	oSection1:Cell("AREA_6"):SetValue("R$ " + Transform((_cAlias2)->AREA_6, "@E 999,999"))
		oSection1:Cell("SHARE6"):SetValue(Transform(nShare6,"@E 999.99") + "%")
	 	oSection1:Cell("TAREA"):SetValue("R$ " + Transform(tLinha, "@E 999,999"))
		oSection1:Cell("SHARET"):SetValue(Transform(nShareT,"@E 999.99") + "%")
	ElseIf ((_cAlias2)->LINHA = 2) .or. ((_cAlias2)->LINHA = 3) .or. ((_cAlias2)->LINHA = 5)
	 	oSection1:Cell("AREA_1"):SetValue("   " + Transform((_cAlias2)->AREA_1, "@E 999,999"))
		oSection1:Cell("SHARE1"):SetValue(cShare)
	 	oSection1:Cell("AREA_2"):SetValue("   " + Transform((_cAlias2)->AREA_2, "@E 999,999"))
		oSection1:Cell("SHARE2"):SetValue(cShare)
	 	oSection1:Cell("AREA_3"):SetValue("   " + Transform((_cAlias2)->AREA_3, "@E 999,999"))
		oSection1:Cell("SHARE3"):SetValue(cShare)
	 	oSection1:Cell("AREA_4"):SetValue("   " + Transform((_cAlias2)->AREA_4, "@E 999,999"))
		oSection1:Cell("SHARE4"):SetValue(cShare)
	 	oSection1:Cell("AREA_5"):SetValue("   " + Transform((_cAlias2)->AREA_5, "@E 999,999"))
		oSection1:Cell("SHARE5"):SetValue(cShare)
	 	oSection1:Cell("AREA_6"):SetValue("   " + Transform((_cAlias2)->AREA_6, "@E 999,999"))
		oSection1:Cell("SHARE6"):SetValue(cShare)
	 	oSection1:Cell("TAREA"):SetValue("   " + Transform(tLinha, "@E 999,999"))
		oSection1:Cell("SHARET"):SetValue(cShare)
	ElseIf ((_cAlias2)->LINHA = 4) .or. ((_cAlias2)->LINHA = 6)
	 	oSection1:Cell("AREA_1"):SetValue("R$ " + Transform((_cAlias2)->AREA_1, "@E 9999.99"))
		oSection1:Cell("SHARE1"):SetValue(cShare)
	 	oSection1:Cell("AREA_2"):SetValue("R$ " + Transform((_cAlias2)->AREA_2, "@E 9999.99"))
		oSection1:Cell("SHARE2"):SetValue(cShare)
	 	oSection1:Cell("AREA_3"):SetValue("R$ " + Transform((_cAlias2)->AREA_3, "@E 9999.99"))
		oSection1:Cell("SHARE3"):SetValue(cShare)
	 	oSection1:Cell("AREA_4"):SetValue("R$ " + Transform((_cAlias2)->AREA_4, "@E 9999.99"))
		oSection1:Cell("SHARE4"):SetValue(cShare)
	 	oSection1:Cell("AREA_5"):SetValue("R$ " + Transform((_cAlias2)->AREA_5, "@E 9999.99"))
		oSection1:Cell("SHARE5"):SetValue(cShare)
	 	oSection1:Cell("AREA_6"):SetValue("R$ " + Transform((_cAlias2)->AREA_6, "@E 9999.99"))
		oSection1:Cell("SHARE6"):SetValue(cShare)
	 	oSection1:Cell("TAREA"):SetValue("R$ " + Transform(tLinha, "@E 9999.99"))
		oSection1:Cell("SHARET"):SetValue(cShare)
	EndIf
	oSection1:PrintLine()

	(_cAlias2)->(dbSkip())		
EndDo
oSection1:Finish()
         
DbSelectArea(_cAlias2)
DbSelectArea(_cAlias1)
DbCloseArea()
	
Return(.t.)
