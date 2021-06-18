#include "protheus.ch"
#include "topconn.ch" 
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT009    ºAutor  ³Helimar Tavares     º Data ³  09/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio Quinquenal                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT009()             

Local oReport
Local cPerg := "FAT009"


//Cria grupo de perguntas
PutSx1(cPerg, "01","Produto:", "Produto:", "Produto:", "mv_ch1", "C", 8, 0, 0, "G", "", "SB1", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")


//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)
/***********************************/
Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("GER009","Quinquenal",cPerg,{|oReport| PrintReport(oReport)},"Quinquenal")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Produto","SB1")

//Celulas da secao
TRCell():New(oSection1,"B1_COD"	    ,"SB1","PRODUTO",,15)
TRCell():New(oSection1,"B1_ISBN"	,"SB1","ISBN",,25)
TRCell():New(oSection1,"B1_DESC"	,"SB1","DESCRIÇÃO")
TRCell():New(oSection1,"DA1_PRCVEN"	,"DA1","PREÇO","@E 99,999.99")

oSection2 := TRSection():New(oSection1,"Meses","SD2")

TRCell():New(oSection2,"MESEXT"		    ,"","MÊS",,3)
TRCell():New(oSection2,"ANO5"		    ,"","","@E 999,999",7)
TRCell():New(oSection2,"ACUM_ANO5"		,"","2011    ","@E 999,999",7)
TRCell():New(oSection2,"ANO4"		    ,"","","@E 999,999",7)
TRCell():New(oSection2,"ACUM_ANO4"		,"","2012    ","@E 999,999",7)
TRCell():New(oSection2,"ANO3"		    ,"","","@E 999,999",7)
TRCell():New(oSection2,"ACUM_ANO3"		,"","2013    ","@E 999,999",7)
TRCell():New(oSection2,"ANO2"		    ,"","","@E 999,999",7)
TRCell():New(oSection2,"ACUM_ANO2"		,"","2014    ","@E 999,999",7)
TRCell():New(oSection2,"ANO1"		    ,"","","@E 999,999",7)
TRCell():New(oSection2,"ACUM_ANO1"		,"","2015    ","@EZ 999,999",7)
TRCell():New(oSection2,"PERC"	    	,"","%","@EZ 9,999",5,,,,,"R")
                     
Return oReport

/************************************/
Static Function PrintReport(oReport)
/************************************/

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1) 
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery   := ""
Local _xCod     := ""
Local _xCodHis  := ""
Local _xPreco	:= 0.00
LocaL _nAcum5	:= 0
LocaL _nAcum4	:= 0
LocaL _nAcum3	:= 0
LocaL _nAcum2	:= 0
LocaL _nAcum1	:= 0

MakeSqlExpr(oReport:uParam)
oSection1:BeginQuery()
  
//Cria query
_cQuery := "SELECT SB1.B1_COD, SB5.B5_XCODHIS, SB1.B1_ISBN, SB1.B1_DESC, SB1.B1_XIDTPPU, DA1.DA1_PRCVEN
_cQuery += "  FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("DA1") + " DA1
_cQuery += " WHERE SB1.B1_COD = SB5.B5_COD
_cQuery += "   AND SB1.B1_COD = DA1.DA1_CODPRO
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' "
_cQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "' "
_cQuery += "   AND SB1.B1_COD = '" + MV_PAR01 + "' "
_cQuery += "   AND DA1.DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "   AND DA1.D_E_L_E_T_ = ' '

_cAlias1 := "QRY1"

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

TCQUERY _cQuery ALIAS "QRY1" NEW

if (_cAlias1)->(eof())
	alert("O produto não foi encontrado")
	DbSelectArea("QRY1")
	DbCloseArea()
	return (nil)
endIf

DbSelectArea("QRY1")
nCont := 0
COUNT to nCont

ProcRegua(nCont)

QRY1->(dbGoTop())

Do While !QRY1->(eof())
                                                              
    _xCod    := QRY1->B1_COD
    _xCodHis := QRY1->B5_XCODHIS
    _xPreco  := QRY1->DA1_PRCVEN
    
	oSection1:Init()  
	
	oSection1:Cell("B1_COD"):SetValue(_xCod)
	oSection1:Cell("B1_ISBN"):SetValue(QRY1->B1_ISBN) 
	oSection1:Cell("B1_DESC"):SetValue(QRY1->B1_DESC)
	oSection1:Cell("DA1_PRCVEN"):SetValue(_xPreco)
	
	oSection1:PrintLine()
	oReport:SkipLine()   
	
	oSection2:Init()
	oSection2:SetHeaderSection(.T.)

	If oReport:Cancel()
		Exit
	EndIf

	_cQuery :=	"SELECT IDOBRA, IDOBRAHISTORICO, MES,
    _cQuery +=  "       DECODE(MES,'01','JAN','02','FEV','03','MAR','04','ABR','05','MAI','06','JUN',
    _cQuery +=  "                  '07','JUL','08','AGO','09','SET','10','OUT','11','NOV','12','DEZ') MESEXT,
	_cQuery +=  "       ANO5, SUM(ANO5) OVER(ORDER BY MES) ACUM_ANO5,
	_cQuery +=  "       ANO4, SUM(ANO4) OVER(ORDER BY MES) ACUM_ANO4,
	_cQuery +=  "       ANO3, SUM(ANO3) OVER(ORDER BY MES) ACUM_ANO3,
	_cQuery +=  "       ANO2, SUM(ANO2) OVER(ORDER BY MES) ACUM_ANO2,
	_cQuery +=  "       ANO1, CASE WHEN MES < TO_CHAR(SYSDATE, 'mm') THEN SUM(ANO1) OVER(ORDER BY MES) ELSE 0 END ACUM_ANO1,
	_cQuery +=  "       CASE WHEN MES < TO_CHAR(SYSDATE, 'mm') THEN ROUND(SUM(ANO1) OVER(ORDER BY MES)/SUM(ANO2) OVER(ORDER BY MES)*100,0) ELSE 0 END PERC
	_cQuery +=  '  FROM (SELECT IDOBRA, IDOBRAHISTORICO, MES, NVL("2011", 0) ANO5, NVL("2012", 0) ANO4, NVL("2013", 0) ANO3, NVL("2014", 0) ANO2, NVL("2015", 0) ANO1
	_cQuery +=  "          FROM (SELECT *
	_cQuery +=  "                  FROM (SELECT '" + _xCod + "' IDOBRA, '" + _xCodHis + "' IDOBRAHISTORICO, MES, ANO, SUM(QTDE) QTDE
	_cQuery +=  "                          FROM (SELECT DECODE(O.IDEMPRESA, 4, O.IDOBRAORIGEM, PO.IDOBRA) IDOBRA,
	_cQuery +=  "                                       TO_CHAR(NF.DATA, 'mm') MES, TO_CHAR(NF.DATA, 'yyyy') ANO,
	_cQuery +=  "                                       SUM(PO.QTDE) QTDE, SUM(PO.LIQUIDO+PO.VALORFRETE) LIQ
	_cQuery +=  "                                  FROM NOTAFISCAL NF, PEDIDO P, PEDIDOOBRA PO, OBRA O, CLIENTE C, NATUREZAOP NOP
	_cQuery +=  "                                 WHERE P.IDPEDIDO = NF.IDPEDIDO
	_cQuery +=  "                                   AND P.IDPEDIDO = PO.IDPEDIDO
	_cQuery +=  "                                   AND PO.IDOBRA = O.IDOBRA
	_cQuery +=  "                                   AND P.IDCLIENTE = C.IDCLIENTE
	_cQuery +=  "                                   AND P.IDNATUREZAOP = NOP.IDNATUREZAOP
	_cQuery +=  "                                   AND NF.DATA BETWEEN TO_DATE('01/01/'||TO_CHAR(ADD_MONTHS(SYSDATE, -48),'yyyy'),'dd/mm/yyyy')
	_cQuery +=  "                                                   AND SYSDATE
	_cQuery +=  "                                   AND NF.STATUS <> 'CN'
	_cQuery +=  "                                   AND NOP.IDTIPONATUREZAOP = 1
	_cQuery +=  "                                   AND P.IDNATUREZAOP <> 102
	_cQuery +=  "                                   AND C.IDGRUPOCLIENTE <> 114
	_cQuery +=  "                                 GROUP BY DECODE(O.IDEMPRESA, 4, O.IDOBRAORIGEM, PO.IDOBRA), TO_CHAR(NF.DATA, 'mm'), TO_CHAR(NF.DATA, 'yyyy')
	_cQuery +=  "                                UNION ALL
	_cQuery +=  "                                SELECT DECODE(O.IDEMPRESA, 4, O.IDOBRAORIGEM, NFEO.IDOBRA),
	_cQuery +=  "                                       TO_CHAR(NFE.DATA, 'mm'), TO_CHAR(NFE.DATA, 'yyyy'),
	_cQuery +=  "                                       SUM(NFEO.QTDE)*(-1), SUM(NFEO.LIQUIDO)*(-1)
	_cQuery +=  "                                  FROM NOTAFISCALENTRADA NFE, NOTAFISCALENTRADAOBRA NFEO, OBRA O, CLIENTE C, NATUREZAOP NOP
	_cQuery +=  "                                 WHERE NFE.IDNOTAFISCALENTRADA = NFEO.IDNOTAFISCALENTRADA
	_cQuery +=  "                                   AND NFEO.IDOBRA = O.IDOBRA
	_cQuery +=  "                                   AND NFE.IDCLIENTE = C.IDCLIENTE
	_cQuery +=  "                                   AND NFEO.IDNATUREZAOP = NOP.IDNATUREZAOP
	_cQuery +=  "                                   AND NFE.DATA BETWEEN TO_DATE('01/01/'||TO_CHAR(ADD_MONTHS(SYSDATE, -48),'yyyy'),'dd/mm/yyyy')
	_cQuery +=  "                                                    AND SYSDATE
	_cQuery +=  "                                   AND NFE.STATUS NOT IN ('CN','NFES')
	_cQuery +=  "                                   AND NOP.IDTIPONATUREZAOP = 7
	_cQuery +=  "                                   AND NFEO.IDNATUREZAOP <> 174
	_cQuery +=  "                                   AND C.IDGRUPOCLIENTE <> 114
	_cQuery +=  "                                 GROUP BY DECODE(O.IDEMPRESA, 4, O.IDOBRAORIGEM, NFEO.IDOBRA), TO_CHAR(NFE.DATA, 'mm'), TO_CHAR(NFE.DATA, 'yyyy')
	_cQuery +=  "                                UNION ALL 
	_cQuery +=  "                                SELECT TO_NUMBER(TRIM(D2_COD)), SUBSTR(D2_EMISSAO,5,2), SUBSTR(D2_EMISSAO,1,4),
	_cQuery +=  "                                       NVL(SUM(D2_QUANT), 0), NVL(SUM(D2_VALBRUT), 0)
	_cQuery +=  "                                  FROM " + RetSqlName("SD2")
	_cQuery +=  "                                 WHERE D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_ = ' ')
	_cQuery +=  " 				                    AND D2_FILIAL = '" + xFilial("SD2") + "' "
	_cQuery +=  "             			            AND D2_TIPO NOT IN ('D','B')
	_cQuery +=  "						            AND D2_EMISSAO BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -48),'yyyy')||'0101'
	_cQuery +=  "                                   AND TO_CHAR(SYSDATE, 'yyyymmdd')
	_cQuery +=  "       					        AND D_E_L_E_T_ = ' ' 
	_cQuery +=  "			      	              GROUP BY TO_NUMBER(TRIM(D2_COD)), SUBSTR(D2_EMISSAO,5,2), SUBSTR(D2_EMISSAO,1,4)
	_cQuery +=  "				                 UNION ALL
	_cQuery +=  "				                 SELECT TO_NUMBER(TRIM(D1_COD)), SUBSTR(D1_EMISSAO,5,2), SUBSTR(D1_EMISSAO,1,4),
	_cQuery +=  "                                       NVL(SUM(D1_QUANT),0)*(-1), NVL(SUM(D1_TOTAL - D1_VALDESC), 0)*(-1)
	_cQuery +=  "      				 	           FROM " + RetSqlName("SD1")
	_cQuery +=  "			      	              WHERE D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_ = ' ')
	_cQuery +=  "					                AND D1_FILIAL = '" + xFilial("SD1") + "' "
	_cQuery +=  "                                   AND D1_TIPO = 'D'
	_cQuery +=  "			      			        AND D1_DTDIGIT BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -48),'yyyy')||'0101'
	_cQuery +=  "                                   AND TO_CHAR(SYSDATE, 'yyyymmdd')
	_cQuery +=  "					                AND D_E_L_E_T_ = ' '
	_cQuery +=  "                                 GROUP BY TO_NUMBER(TRIM(D1_COD)), SUBSTR(D1_EMISSAO,5,2), SUBSTR(D1_EMISSAO,1,4))
	_cQuery +=  "                         WHERE IDOBRA IN (SELECT IDOBRA FROM OBRA WHERE IDOBRAHISTORICO = '" + _xCodHis + "')
	_cQuery +=  "                         GROUP BY '" + _xCod + "', '" + _xCodHis + "', MES, ANO)
	_cQuery +=  "                 PIVOT (SUM(QTDE) FOR ANO IN (2011,2012,2013,2014,2015))))
	_cQuery +=  " ORDER BY MES
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf

	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)

	(_cAlias2)->(dbGoTop())

	Do While !(_cAlias1)->(eof()) .AND. !(_cAlias2)->(eof()) 
	
		oReport:IncMeter()
        
		oSection2:Cell("MESEXT"):SetValue((_cAlias2)->MESEXT)
		oSection2:Cell("ANO5"):SetValue((_cAlias2)->ANO5)
		oSection2:Cell("ACUM_ANO5"):SetValue((_cAlias2)->ACUM_ANO5)
		oSection2:Cell("ANO4"):SetValue((_cAlias2)->ANO4)
		oSection2:Cell("ACUM_ANO4"):SetValue((_cAlias2)->ACUM_ANO4)
		oSection2:Cell("ANO3"):SetValue((_cAlias2)->ANO3)
		oSection2:Cell("ACUM_ANO3"):SetValue((_cAlias2)->ACUM_ANO3)
		oSection2:Cell("ANO2"):SetValue((_cAlias2)->ANO2)
		oSection2:Cell("ACUM_ANO2"):SetValue((_cAlias2)->ACUM_ANO2)
		oSection2:Cell("ANO1"):SetValue((_cAlias2)->ANO1)
		oSection2:Cell("ACUM_ANO1"):SetValue((_cAlias2)->ACUM_ANO1)
		oSection2:Cell("PERC"):SetValue((_cAlias2)->PERC)
	    
		oSection2:PrintLine()

		(_cAlias2)->(dbSkip())
	
	ENDDO

//	oSection2:PrintLine()
	oSection2:Finish()
//	oReport:SkipLine()   
/*	
	oSection3:Init()
	oSection3:SetHeaderSection(.T.)
	
	oReport:IncMeter()
        
	oSection3:Cell("MESEXT"):SetValue((_cAlias2)->MESEXT)
	oSection3:Cell("ANO5"):SetValue((_cAlias2)->ANO5)
	oSection3:Cell("ACUM_ANO5"):SetValue((_cAlias2)->ACUM_ANO5)
	oSection3:Cell("ANO4"):SetValue((_cAlias2)->ANO4)
	oSection3:Cell("ACUM_ANO4"):SetValue((_cAlias2)->ACUM_ANO4)
	oSection3:Cell("ANO3"):SetValue((_cAlias2)->ANO3)
	oSection3:Cell("ACUM_ANO3"):SetValue((_cAlias2)->ACUM_ANO3)
	oSection3:Cell("ANO2"):SetValue((_cAlias2)->ANO2)
	oSection3:Cell("ACUM_ANO2"):SetValue((_cAlias2)->ACUM_ANO2)
	oSection3:Cell("ANO1"):SetValue((_cAlias2)->ANO1)
	oSection3:Cell("ACUM_ANO1"):SetValue((_cAlias2)->ACUM_ANO1)
    
	oSection3:PrintLine()

	If oReport:Cancel()
		Exit
	EndIf
*/
	
	QRY1->(dbSkip())

	DbSelectArea(_cAlias2)
	DbCloseArea()

	oSection1:Finish()

	DbSelectArea("QRY1")	
	
EndDo

DbSelectArea("QRY1")
DbCloseArea()

Return