#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEST040    บAutor  ณHelimar Tavares     บ Data ณ  08/05/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio Custo M้dio de Venda                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Estoque/Custos                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Alteraoes:

/*/

User Function EST041()

Local oReport
Local cPerg := "EST041"

//Cria grupo de perguntas
f001(cPerg)

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: f001
Descricao: Cria grupo de perguntas
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
AADD(aHelpPor,"Obrigat๓rio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissใo de:", "Dt Emissใo de:", "Dt Emissใo de:", cMVCH, "D", 8, 0, 0, "G", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigat๓rio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissใo at้:", "Dt Emissใo at้:", "Dt Emissใo at้:", cMVCH , "D", 8, 0, 0, "G", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "B1_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Produto de:"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigat๓rio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------  
cCpoPer := "B1_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Produto at้:"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigat๓rio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Armaz้m:", "Armaz้m:", "Armaz้m:", cMVCH, "C", 2, 0, 2, "C", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
cCpoPer := "B1_TIPO"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, cOpc1, "", "", "", cOpc2, "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
*/

Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio

oReport := TReport():New("EST041","EST041 - Custo M้dio de Venda",cPerg,{|oReport| PrintReport(oReport)},"EST041 - Custo M้dio de Venda",.T.)

//oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

//Secao do relatorio
oSection1 := TRSection():New(oReport,"EST041 - Custo M้dio de Venda","")

//Celulas da secao
TRCell():New(oSection1,"CODIGO"			,"   ","C๓digo"+CRLF+"Produto"	,,10)
TRCell():New(oSection1,"ISBN"			,"   ",CRLF+"ISBN"				,,15)
TRCell():New(oSection1,"DESCRICAO"		,"   ",CRLF+"Descri็ใo"			,,50)
TRCell():New(oSection1,"AREA"			,"   ",CRLF+"มrea"				,,20)
TRCell():New(oSection1,"ARMAZEM"		,"   ",CRLF+"Armaz้m"			,,10)
TRCell():New(oSection1,"QTDE"			,"   ",CRLF+"Quantidade "		,"@E 999,999",8,,,,,"RIGHT")
TRCell():New(oSection1,"CSTTOTAL"		,"   ","Custo"+CRLF+"Total"		,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"CSTANTERIOR"	,"   ","Custo"+CRLF+"Anterior"	,"@E 999,999,999.99",18,,,,,"RIGHT")

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")	   		,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTTOTAL")		,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTANTERIOR")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio
*/

Static Function PrintReport(oReport)

Local oSection1	:= oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cQuery	:= ""
/*
If oReport:NDEVICE <> 4
	MsgInfo("Este relat๓rio somente poderแ ser impresso em Excel.")
	Return(.t.)
Endif
*/
_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(LASTDATE(MONTHSUB(MV_PAR01,1)))

oReport:SetLandScape()

//Cria query
_cQuery := " SELECT NVL(SZ7.Z7_DESC,'*** SEM มREA ***') AREA,
_cQuery += "        M.CODIGO, SB1.B1_ISBN, SB1.B1_DESC, M.LOCAL,
_cQuery += "        SUM(QUANT) QTDE,
_cQuery += "        SUM(CUSTO) CSTTOTAL,
_cQuery += "        SB9.B9_CM1 CSTANTERIOR
_cQuery += "   FROM (SELECT D1_COD CODIGO, D1_LOCAL LOCAL, SUM(D1_QUANT)*(-1) QUANT, SUM(D1_CUSTO)*(-1) CUSTO
_cQuery += "           FROM " + RetSqlName("SD1")
_cQuery += "          WHERE D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "            AND D1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
_cQuery += "            AND D1_TES IN ('052','053','055','452')
If !Empty(MV_PAR05)
	_cQuery += "            AND D1_LOCAL = '" + MV_PAR05 + "'"
EndIf
_cQuery += "            AND D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += "            AND D_E_L_E_T_ = ' '
_cQuery += "          GROUP BY D1_COD, D1_LOCAL
_cQuery += "          UNION ALL
_cQuery += "         SELECT D2_COD, D2_LOCAL, SUM(D2_QUANT) QUANT, SUM(D2_CUSTO1) CUSTO
_cQuery += "           FROM " + RetSqlName("SD2")
_cQuery += "          WHERE D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "            AND D2_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
_cQuery += "            AND D2_TES IN ('501','502','503','505','506','515','524','525','536','545','801')
If !Empty(MV_PAR05)
	_cQuery += "            AND D2_LOCAL = '" + MV_PAR05 + "'"
EndIf
_cQuery += "            AND D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "            AND D_E_L_E_T_ = ' '
_cQuery += "          GROUP BY D2_COD, D2_LOCAL) M
_cQuery += "   LEFT JOIN " + RetSqlName("SB9") + " SB9 ON M.CODIGO = SB9.B9_COD AND M.LOCAL = SB9.B9_LOCAL AND B9_DATA = '" + _cParm3 + "' AND SB9.B9_FILIAL = '" + xFilial("SB9") + "' AND SB9.D_E_L_E_T_ = ' '
_cQuery += "   INNER JOIN " + RetSqlName("SB1") + " SB1 ON M.CODIGO = SB1.B1_COD AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR06)
	_cQuery += "            AND SB1.B1_TIPO = '" + MV_PAR06 + "'"
EndIf
_cQuery += "   INNER JOIN " + RetSqlName("SB5") + " SB5 ON M.CODIGO = SB5.B5_COD AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' AND SB5.D_E_L_E_T_ = ' '
_cQuery += "   LEFT JOIN " + RetSqlName("SZ7") + " SZ7 ON SB5.B5_XAREA = SZ7.Z7_AREA AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ' '
_cQuery += "  GROUP BY SZ7.Z7_DESC, M.CODIGO, SB1.B1_ISBN, SB1.B1_DESC, M.LOCAL, SB9.B9_CM1
_cQuery += "  ORDER BY M.CODIGO, M.LOCAL

If Select(cAlias1) > 0
	dbSelectArea(cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), cAlias1, .F., .T.)

(cAlias1)->(dbGoTop())

Do While !(cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection1:Init()
	
	oSection1:Cell("CODIGO"):SetValue((cAlias1)->CODIGO)
	oSection1:Cell("ISBN"):SetValue((cAlias1)->B1_ISBN)
	oSection1:Cell("DESCRICAO"):SetValue((cAlias1)->B1_DESC)
	oSection1:Cell("AREA"):SetValue((cAlias1)->AREA)
	oSection1:Cell("ARMAZEM"):SetValue((cAlias1)->LOCAL)
	oSection1:Cell("QTDE"):SetValue((cAlias1)->QTDE)
	oSection1:Cell("CSTTOTAL"):SetValue((cAlias1)->CSTTOTAL)
	oSection1:Cell("CSTANTERIOR"):SetValue((cAlias1)->CSTANTERIOR)

	oSection1:PrintLine()
	
	(cAlias1)->(dbSkip())
EndDo                    

DbSelectArea(cAlias1)
DbCloseArea()

Return(.t.)
