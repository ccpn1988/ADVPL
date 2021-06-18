#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT007    บAutor  ณErica Vieites       บ Data ณ  23/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Faturamento Por Vendedor                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT007()             

Local oReport
Local cPerg := "FAT007"


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
cCpoPer := "A1_VEND"                	
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SA3')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissใo de:", "Dt Emissใo de:" ,"Dt Emissใo de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emissใo at้:", "Dt Emissใo at้:","Dt Emissใo at้:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

_cAno   := YEAR2STR(MV_PAR02)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR02)-1)

//Declaracao do relatorio
oReport := TReport():New("GER038","GER038 - Faturamento Lํq. do Perํodo por Gestor de Vendas - Total GEN sem F๓rum",cPerg,{|oReport| PrintReport(oReport)},"GER038 - Faturamento Lํq. do Perํodo por Gestor de Vendas - Total GEN sem F๓rum")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"A3_COD"		,"","C๓digo"				,,10)
TRCell():New(oSection1,"A3_NOME"	,"","Vendedor"				,,20)
TRCell():New(oSection1,"LIQUIDO"	,"","Valor "+_cAno	 +" R$"	,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"LIQUIDOAA"	,"","Valor "+_cAnoAnt+" R$"	,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"PERCLIQ"	,"","% Valor"				,"@E 999,999.99"	 ,10,,,,,"RIGHT")
TRCell():New(oSection1,"QTDE"		,"","Qtde "+_cAno			,"@E 999,999,999"	 ,12,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEAA"		,"","Qtde "+_cAnoAnt		,"@E 999,999,999"	 ,12,,,,,"RIGHT")
TRCell():New(oSection1,"PERCQTD"	,"","% Qtde"				,'@E 999,999.99'	 ,10,,,,,"RIGHT")

//Totalizadores
TRFunction():New(oSection1:Cell("LIQUIDO"  ),"TLIQUIDO"	 ,"SUM")
TRFunction():New(oSection1:Cell("LIQUIDOAA"),"TLIQUIDOAA","SUM")                                
TRFunction():New(oSection1:Cell("PERCLIQ"  ),"TPERCLIQ"	 ,"ONPRINT")
TRFunction():New(oSection1:Cell("QTDE"     ),"TQTDE"	 ,"SUM")
TRFunction():New(oSection1:Cell("QTDEAA"   ),"TQTDEAA"	 ,"SUM")
TRFunction():New(oSection1:Cell("PERCQTD"  ),"TPERCQTD"	 ,"ONPRINT")

oReport:GetFunction("TPERCLIQ"):SetFormula({||uReport := (oReport:GetFunction("TLIQUIDO"):uLastValue / oReport:GetFunction("TLIQUIDOAA"):uLastValue) * 100})
oReport:GetFunction("TPERCQTD"):SetFormula({||uReport := (oReport:GetFunction("TQTDE"   ):uLastValue / oReport:GetFunction("TQTDEAA"   ):uLastValue) * 100})

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)


Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cQuery	:= ""
Local _cAlias   := GetNextAlias()

_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(MV_PAR03)
_cParm4 := DTOS(YEARSUB(MV_PAR02,1))
_cParm5 := DTOS(YEARSUB(MV_PAR03,1))

_cQuery := "SELECT A3_COD
_cQuery += "     , NVL(A3_NOME, '*** SEM VENDEDOR ***') A3_NOME
_cQuery += "     , SUM(QTDE) AS QTDE
_cQuery += "     , SUM(QTDEAA) AS QTDEAA
_cQuery += "     , DECODE(SUM(QTDEAA),0,0,SUM(QTDE)/SUM(QTDEAA)*100) PERCQTD
_cQuery += "     , SUM(LIQUIDO) AS LIQUIDO
_cQuery += "     , SUM(LIQUIDOAA) AS LIQUIDOAA
_cQuery += "     , DECODE(SUM(LIQUIDOAA),0,0,SUM(LIQUIDO)/SUM(LIQUIDOAA)*100) PERCLIQ
_cQuery += "  FROM (SELECT SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END),0) QTDE, NVL(SUM(SD2.D2_VALBRUT),0) LIQUIDO, 0 QTDEAA, 0 LIQUIDOAA
_cQuery += "          FROM GER_SD2 SD2
_cQuery += "         INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "         WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm2 + "' AND '" + _cParm3 + "'"
_cQuery += "           AND SB1.B1_XIDTPPU <> ' '
_cQuery += "           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' ' 
_cQuery += "         GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA
_cQuery += "         UNION ALL
_cQuery += "        SELECT SD1.D1_FORNECE, SD1.D1_LOJA, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1), NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1), 0, 0
_cQuery += "          FROM GER_SD1 SD1
_cQuery += "         INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "         WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm2 + "' AND '" + _cParm3 + "'"
_cQuery += "           AND SB1.B1_XIDTPPU <> ' '
_cQuery += "           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "         GROUP BY SD1.D1_FORNECE, SD1.D1_LOJA
_cQuery += "         UNION ALL
_cQuery += "        SELECT SD2.D2_CLIENTE, SD2.D2_LOJA, 0, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END),0), NVL(SUM(SD2.D2_VALBRUT), 0)
_cQuery += "          FROM GER_SD2 SD2
_cQuery += "         INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "         WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm4 + "' AND '" + _cParm5 + "'"
_cQuery += "           AND SB1.B1_XIDTPPU <> ' '
_cQuery += "           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' ' 
_cQuery += "         GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA
_cQuery += "        UNION ALL
_cQuery += "        SELECT SD1.D1_FORNECE, SD1.D1_LOJA, 0, 0, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1), NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "          FROM GER_SD1 SD1
_cQuery += "         INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "         WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm4 + "' AND '" + _cParm5 + "'"
_cQuery += "           AND SB1.B1_XIDTPPU <> ' '
_cQuery += "           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "         GROUP BY SD1.D1_FORNECE, SD1.D1_LOJA) F
_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1 ON F.CLIENTE = SA1.A1_COD
_cQuery += "   AND F.LOJA = SA1.A1_LOJA
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SA1.A1_VEND = SA3.A3_COD
_cQuery += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery += "   AND SA3.D_E_L_E_T_ = ' ' 
If !Empty(MV_PAR01)
	_cQuery += " WHERE A3_COD = '"+MV_PAR01+"'
Endif 
_cQuery += "HAVING SUM(LIQUIDO) <> 0 OR SUM(LIQUIDOAA) <> 0
_cQuery += " GROUP BY A3_COD, A3_NOME
_cQuery += " ORDER BY LIQUIDO DESC
	
If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias, .F., .T.)

Do While !(_cAlias)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("A3_COD"   ):SetValue((_cAlias)->A3_COD)
	oSection1:Cell("A3_NOME"  ):SetValue((_cAlias)->A3_NOME)
	oSection1:Cell("QTDE"     ):SetValue((_cAlias)->QTDE)
	oSection1:Cell("QTDEAA"   ):SetValue((_cAlias)->QTDEAA)
	oSection1:Cell("PERCQTD"  ):SetValue((_cAlias)->PERCQTD)
	oSection1:Cell("LIQUIDO"  ):SetValue((_cAlias)->LIQUIDO)
	oSection1:Cell("LIQUIDOAA"):SetValue((_cAlias)->LIQUIDOAA)
	oSection1:Cell("PERCLIQ"  ):SetValue((_cAlias)->PERCLIQ)
	
	oSection1:PrintLine()

	(_cAlias)->(dbSkip())		
EndDo

DbSelectArea(_cAlias)
DbCloseArea()

Return(.t.)