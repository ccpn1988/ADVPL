#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER036    บAutor  ณHelimar Tavares     บ Data ณ  11/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Saldo Consignado de Todos os Clientes          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Gerencial                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER036()             

Local oReport
Local cPerg := "GER036"


//Cria grupo de perguntas

f001(cPerg) 

//Carrega grupo de perguntas

If !Pergunte(cPerg,.T.)
	Return
Endif

oReport := ReportDef()
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
AADD(aHelpPor,"Ordem de Impressใo.  ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSX1(cPerg, cItPerg, "Ordem Impressใo:", "Ordem Impressใo:", "Ordem Impressใo:", cMVCH, "C", 1, 0, 1, "C", "", "", "", "", cMVPAR, "Valor decresc.", "Valor decresc.", "Valor decresc.", "", "Cliente", "Cliente", "Cliente", "", "", "", "", "","", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef()

Local oReport
Local oSection

//Declaracao do relatorio
oReport := TReport():New("GER036","GER036 - CONSIGNAวรO DE TODOS OS CLIENTES",,{|oReport| PrintReport(oReport)},"GER036 - CONSIGNAวรO DE TODOS OS CLIENTES",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    

//Secao do relatorio
oSection := TRSection():New(oReport,"Cliente","SB6")  

//Celulas da secao
TRCell():New(oSection,"B6_CLIFOR"	 	,"","Cliente")
TRCell():New(oSection,"B6_LOJA"		 	,"","Loja")
//TRCell():New(oSection,"A1_CGC"		 	,"","CNPJ")
//TRCell():New(oSection,"A1_NOME"		 	,"","Descri็ใo")
TRCell():New(oSection,"A1_NREDUZ"	 	,"","Nome Fantasia")
TRCell():New(oSection,"A1_EST"		 	,"","UF")
TRCell():New(oSection,"A1_MUN"		 	,"","Municํpio")
TRCell():New(oSection,"TIPOCLIENTE"	 	,"","Tipo")
TRCell():New(oSection,"CANALVENDA"	 	,"","Canal de Venda")
TRCell():New(oSection,"A3_NOME"		 	,"","Vendedor")
TRCell():New(oSection,"TOT_QTDE"	 	,"","Saldo Total"	,'@E 9,999,999')
TRCell():New(oSection,"TOT_001"		 	,"","Sa๚de"			,'@E 9,999,999')
TRCell():New(oSection,"TOT_002"		 	,"","Exatas"		,'@E 9,999,999')
TRCell():New(oSection,"TOT_005"		 	,"","Concursos"		,'@E 9,999,999')
TRCell():New(oSection,"TOT_006"		 	,"","Jurํdica"		,'@E 9,999,999')
TRCell():New(oSection,"TOT_007"			,"","Soc.Aplic."	,'@E 9,999,999')
TRCell():New(oSection,"TOT_008"			,"","Humanas"		,'@E 9,999,999')
TRCell():New(oSection,"TOT_VALOR"		,"","Valor Total"	,'@E 999,999,999.99')
TRCell():New(oSection,"DT_ULTACERTO"	,"","ฺlt.Acerto")
TRCell():New(oSection,"VL_ULTACERTO"	,"","R$ ฺlt.30 Dias",'@E 999,999,999.99')
TRCell():New(oSection,"PERC_ULTACERTO"	,"","% ฺlt.30 Dias"	,'@E 999,999.99')
                             

//Totalizadores
TRFunction():New(oSection:Cell("B6_CLIFOR")	,NIL,"COUNT")
TRFunction():New(oSection:Cell("TOT_QTDE")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_001")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_002")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_005")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_006")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_007")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_008")	,NIL,"SUM")
TRFunction():New(oSection:Cell("TOT_VALOR")	,NIL,"SUM")

//Faz a impressao do totalizador em linha
oSection:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()

Local xDtUltAcerto:= ""
Local xPerc := 0

_cParm1 := DTOS(DAYSUB(DATE(),30))
_cParm2 := DTOS(DATE())
                                                                          
If oReport:NDEVICE <> 4
	MsgInfo("Este relat๓rio somente poderแ ser impresso em Excel.")
	Return(.t.)
Endif

oReport:SetLandScape()

_cQuery := "SELECT SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_EST, SA1.A1_MUN, 
_cQuery += "       XTP.X5_DESCRI TIPOCLIENTE, XZ2.X5_DESCRI CANALVENDA, SA3.A3_NOME,
_cQuery += "       SUM(SB6.B6_SALDO) TOT_QTDE,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000001' THEN SB6.B6_SALDO ELSE 0 END) TOT_001,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000002' THEN SB6.B6_SALDO ELSE 0 END) TOT_002,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000005' THEN SB6.B6_SALDO ELSE 0 END) TOT_005,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000006' THEN SB6.B6_SALDO ELSE 0 END) TOT_006,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000007' THEN SB6.B6_SALDO ELSE 0 END) TOT_007,
_cQuery += "       SUM(CASE WHEN SB5.B5_XAREA = '000008' THEN SB6.B6_SALDO ELSE 0 END) TOT_008,
_cQuery += "       SUM(SB6.B6_SALDO * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100))) TOT_VALOR,
_cQuery += "       NVL(UA.D2_EMISSAO,' ') DT_ULTACERTO, NVL(UAV.VALOR,0) VL_ULTACERTO
_cQuery += "  FROM (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
_cQuery += "          FROM " + RetSqlName("SB6")
_cQuery += "         WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
_cQuery += "           AND B6_TIPO    = 'E'
_cQuery += "           AND B6_PODER3  = 'R'
_cQuery += "           AND B6_TPCF    = 'C'
_cQuery += "           AND D_E_L_E_T_ = ' '
_cQuery += "         GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) SB6
_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SB6.B6_CLIFOR AND SA1.A1_LOJA = SB6.B6_LOJA
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XTP ON XTP.X5_CHAVE = SA1.A1_XTIPCLI
_cQuery += "   AND XTP.X5_TABELA = 'TP'
_cQuery += "   AND XTP.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XTP.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ2 ON XZ2.X5_CHAVE = SA1.A1_XCANALV
_cQuery += "   AND XZ2.X5_TABELA = 'Z2'
_cQuery += "   AND XZ2.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ2.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SA3.A3_COD = SA1.A1_VEND
_cQuery += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery += "   AND SA3.D_E_L_E_T_ = ' '
_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SB6.B6_PRODUTO
_cQuery += " INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB5.B5_COD = SB1.B1_COD
_cQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1.DA1_CODPRO = SB1.B1_COD
_cQuery += "   AND DA1.DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
_cQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ2") + " SZ2 ON SZ2.Z2_CLASSE = SB1.B1_GRUPO AND SZ2.Z2_TIPO = SA1.A1_XTPDES
_cQuery += "   AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
_cQuery += "   AND SZ2.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN (SELECT D2_FILIAL, D2_CLIENTE, D2_LOJA, MAX(D2_EMISSAO) D2_EMISSAO
_cQuery += "               FROM GER_SD2
_cQuery += "              WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                AND D2_TES     = '524'
_cQuery += "              GROUP BY D2_FILIAL, D2_CLIENTE, D2_LOJA) UA
_cQuery += "    ON UA.D2_CLIENTE = SB6.B6_CLIFOR
_cQuery += "   AND UA.D2_LOJA = SB6.B6_LOJA 
_cQuery += "  LEFT JOIN (SELECT D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_EMISSAO, SUM(D2_VALBRUT) VALOR
_cQuery += "               FROM GER_SD2
_cQuery += "              WHERE D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                AND D2_TES     = '524'
_cQuery += "                AND D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "              GROUP BY D2_FILIAL, D2_CLIENTE, D2_LOJA, D2_EMISSAO) UAV
_cQuery += "    ON UAV.D2_FILIAL = UA.D2_FILIAL
_cQuery += "   AND UAV.D2_CLIENTE = UA.D2_CLIENTE
_cQuery += "   AND UAV.D2_LOJA = UA.D2_LOJA
_cQuery += "   AND UAV.D2_EMISSAO = UA.D2_EMISSAO
_cQuery += " WHERE SB6.B6_SALDO  <> 0
If !Empty(MV_PAR01)
	_cQuery += "   AND SA1.A1_VEND = '"+MV_PAR01+"'"
EndIf
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += " GROUP BY SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_EST, SA1.A1_MUN, XTP.X5_DESCRI, XZ2.X5_DESCRI, SA3.A3_NOME, UA.D2_EMISSAO, UAV.VALOR
If MV_PAR02 == 1
	_cQuery += " ORDER BY TOT_VALOR DESC
Else
	_cQuery += " ORDER BY SA1.A1_NREDUZ
EndIf

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection:Init()  

    If (_cAlias1)->DT_ULTACERTO = ' '
		xDtUltAcerto:= (_cAlias1)->DT_ULTACERTO
    Else
		xDtUltAcerto:= STOD((_cAlias1)->DT_ULTACERTO)
	EndIf

	If (_cAlias1)->TOT_VALOR = 0
		xPerc := 0
	Else
		xPerc := (_cAlias1)->VL_ULTACERTO / (_cAlias1)->TOT_VALOR * 100
	EndIf

	oSection:Cell("B6_CLIFOR"):SetValue((_cAlias1)->B6_CLIFOR)
	oSection:Cell("B6_LOJA"):SetValue((_cAlias1)->B6_LOJA)
//	oSection:Cell("A1_CGC"):SetValue((_cAlias1)->A1_CGC)
//	oSection:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	oSection:Cell("A1_NREDUZ"):SetValue((_cAlias1)->A1_NREDUZ)
	oSection:Cell("A1_EST"):SetValue((_cAlias1)->A1_EST)
	oSection:Cell("A1_MUN"):SetValue((_cAlias1)->A1_MUN)
	oSection:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
	oSection:Cell("CANALVENDA"):SetValue((_cAlias1)->CANALVENDA)
	oSection:Cell("A3_NOME"):SetValue((_cAlias1)->A3_NOME)
	oSection:Cell("TOT_QTDE"):SetValue((_cAlias1)->TOT_QTDE)
	oSection:Cell("TOT_001"):SetValue((_cAlias1)->TOT_001)
	oSection:Cell("TOT_002"):SetValue((_cAlias1)->TOT_002)
	oSection:Cell("TOT_005"):SetValue((_cAlias1)->TOT_005)
	oSection:Cell("TOT_006"):SetValue((_cAlias1)->TOT_006)
	oSection:Cell("TOT_007"):SetValue((_cAlias1)->TOT_007)
	oSection:Cell("TOT_008"):SetValue((_cAlias1)->TOT_008)
	oSection:Cell("TOT_VALOR"):SetValue((_cAlias1)->TOT_VALOR)
	oSection:Cell("DT_ULTACERTO"):SetValue(xDtUltAcerto)
	oSection:Cell("VL_ULTACERTO"):SetValue((_cAlias1)->VL_ULTACERTO)
	oSection:Cell("PERC_ULTACERTO"):SetValue(xPerc)
	
	oSection:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo

//oSection:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)