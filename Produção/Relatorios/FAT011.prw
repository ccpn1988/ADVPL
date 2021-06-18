#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT011    ºAutor  ³Helimar Tavares     º Data ³  27/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Faturamento Por Parceria                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT011()             

Local oReport
Local cPerg := "FAT011"


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
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:","Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03-------------------------------------------------- 
cCpoPer := "B1_XAQUIS"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')          
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, "Aquisição", "Aquisição", "Aquisição", cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "naovazio() .and. existcpo('SX5','Z0'+MV_PAR03)", cF3Perg,"","", cMVPAR, cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04-------------------------------------------------- 
cCpoPer := "D1_FORNECE"                	
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SA2')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2 
Local cTamVal:= 10 //TamSX3('D2_VALBRUT')[1]
Local cTamQtd:= 8  //TamSX3('D2_QUANT'  )[1]

//Declaracao do relatorio
oReport := TReport():New("GER011","GER011 - FATURAMENTO AQUISIÇÃO DE CATÁLOGO",cPerg,{|oReport| PrintReport(oReport)},"GER011 - FATURAMENTO AQUISIÇÃO DE CATÁLOGO")

//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"B1_ISBN"		,"SB1","ISBN"	  							,				 ,15)
TRCell():New(oSection1,"B1_DESC"   		,"SB1","DESCRIÇÃO (Conceito FEC)"			,				 ,50)
TRCell():New(oSection1,"SELO"   		,"   ","SELO"								,				 ,8)
TRCell():New(oSection1,"DATAPUBLICACAO"	,"   ","DATA"        +CRLF+"PUBLICAÇÃO"		,				 ,13)
TRCell():New(oSection1,"TIPOPUBLICACAO"	,"   ","TIPO"        +CRLF+"PUBLICAÇÃO"		,				 ,18)
TRCell():New(oSection1,"LIQUIDO"		,"   ","|    ANO    "+CRLF+"|   R$ MIL  "	,'@E 999,999,999',12)
TRCell():New(oSection1,"QTDE"		    ,"   ","    ATUAL   "+CRLF+"    QTDE    "	,'@E 999,999,999',12)
TRCell():New(oSection1,"LIQUIDOANT"		,"   ","|    ANO    "+CRLF+"|   R$ MIL  "	,'@E 999,999,999',12)
TRCell():New(oSection1,"QTDEANT"	    ,"   ","  ANTERIOR  "+CRLF+"    QTDE    "	,'@E 999,999,999',12)
TRCell():New(oSection1,"VARLIQUIDO"		,"   ","| VARIAÇÃO  "+CRLF+"|   VALOR   "	,'@E 9999,999.99',12)
TRCell():New(oSection1,"VARQTDE"	    ,"   ","          % "+CRLF+"    QTDE    "	,'@E 9999,999.99',12)
TRCell():New(oSection1,"RANK"		    ,"   ","|    RANK   "+CRLF+"|   ACUM %  "	,'@E 9999,999.99',12)

oSection2 := TRSection():New(oSection1,"Totais","")

TRCell():New(oSection2,"SPACE1"			,"   ","Total Geral ",                ,15)
TRCell():New(oSection2,"SPACE1"			,"   ","            ",                ,50)
TRCell():New(oSection2,"SPACE1"			,"   ","            ",                ,8)
TRCell():New(oSection2,"SPACE1"			,"   ","            ",                ,13)
TRCell():New(oSection2,"SPACE1"			,"   ","            ",                ,18)
TRCell():New(oSection2,"TLIQUIDO"		,"   ","            ",'@E 999,999,999',12)
TRCell():New(oSection2,"TQTDE"		    ,"   ","            ",'@E 999,999,999',12)
TRCell():New(oSection2,"TLIQUIDOANT"	,"   ","            ",'@E 999,999,999',12)
TRCell():New(oSection2,"TQTDEANT"	    ,"   ","            ",'@E 999,999,999',12)
TRCell():New(oSection2,"TVARLIQUIDO"	,"   ","            ",'@E 9999,999.99',12)
TRCell():New(oSection2,"TVARQTDE"	    ,"   ","            ",'@E 9999,999.99',12)
TRCell():New(oSection2,"SPACE1"			,"   ","            ",                ,12)


//Totalizadores
/*
TRFunction():New(oSection1:Cell("QTDE")	    	,"QTD"	,"SUM")
TRFunction():New(oSection1:Cell("LIQUIDO")		,"LIQ"	,"SUM")                                
TRFunction():New(oSection1:Cell("QTDEANT")	    ,"QTDA"	,"SUM")
TRFunction():New(oSection1:Cell("LIQUIDOANT")	,"LIQA"	,"SUM")                                

//TRFunction():New(oSection1:Cell("VARLIQUIDO")	,"VLIQ"	,"ONPRINT")
//oReport:GetFunction("VLIQ"):SetFormula({|| (oReport:GetFunction("LIQUIDO"):uLastValue / oReport:GetFunction("LIQUIDOANT"):uLastValue - 1) * 100 }) 
//oReport:GetFunction("VLIQ"):uReport := (oReport:GetFunction("LIQ"):GetValue() / oReport:GetFunction("LIQA"):GetValue() -1) * 100 

//Faz a impressao do totalizador em linha
oReport:SetTotalInLine(.f.)
*/

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias() 
Local xVarQtde  := 0
Local xVarLiq   := 0
Local xRank     := 0
Local tQtde     := 0
Local tQtdeAnt  := 0
Local tLiq      := 0
Local tLiqAnt   := 0
Local tVarQtde  := 0
Local tVarLiq   := 0

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(YEARSUB(MV_PAR01, 1))
_cParm4 := DTOS(YEARSUB(MV_PAR02, 1))

_cQuery := "SELECT B1_ISBN, B1_DESC, SELO, DATAPUBLICACAO, TIPOPUBLICACAO, QTDE, LIQUIDO, QTDEANT, LIQUIDOANT, SUM(LIQUIDO) OVER() TOTALLIQ
_cQuery += "  FROM (
_cQuery += "SELECT SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, TRIM(Z1.X5_DESCRI) SELO, SB5.B5_XDTPUBL DATAPUBLICACAO, TRIM(Z4.X5_DESCRI) TIPOPUBLICACAO,
_cQuery += "       SUM(F.QTDE) QTDE, SUM(F.LIQUIDO)/1000 LIQUIDO, SUM(F.QTDEANT) QTDEANT, SUM(F.LIQUIDOANT)/1000 LIQUIDOANT
_cQuery += "  FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5, " + RetSqlName("SA2") + " SA2, " + RetSqlName("SX5") + " Z1, "+ RetSqlName("SX5") + " Z4,
_cQuery += "     (SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "        FROM " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5
_cQuery += "       WHERE SD2.D2_COD = SB1.B1_COD
_cQuery += "         AND SB1.B1_COD = SB5.B5_COD
_cQuery += "         AND SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND D_E_L_E_T_  = ' ')
_cQuery += "         AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "         AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "         AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "         AND SD2.D2_TIPO NOT IN ('D','B')
_cQuery += "         AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "         AND SD2.D_E_L_E_T_ = ' '
_cQuery += "         AND SB1.D_E_L_E_T_ = ' '
_cQuery += "         AND SB5.D_E_L_E_T_ = ' '
_cQuery += "       GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "      UNION ALL
_cQuery += "      SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) CODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1) QTDE, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "        FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SB5") + " SB5
_cQuery += "       WHERE SD1.D1_COD = SB1.B1_COD
_cQuery += "         AND SB1.B1_COD = SB5.B5_COD
_cQuery += "         AND SD1.D1_TES IN (SELECT F4_CODIGO FROM SF4000 WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND D_E_L_E_T_  = ' ')
_cQuery += "         AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
_cQuery += "         AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "         AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "         AND SD1.D1_TIPO    = 'D'
_cQuery += "         AND SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "         AND SD1.D_E_L_E_T_ = ' '
_cQuery += "         AND SB1.D_E_L_E_T_ = ' '
_cQuery += "         AND SB5.D_E_L_E_T_ = ' '
_cQuery += "       GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "      UNION ALL
_cQuery += "      SELECT IDOBRAHISTORICO CODHIS, 0 QTDE, 0 LIQUIDO, SUM(CASE WHEN IDTIPOPUBLICACAO IN (11,15) THEN 0 ELSE QTDE END) QTDEANT, SUM(LIQUIDO) LIQUIDOANT
_cQuery += "        FROM GEN_FAT001_FATURAMENTO
_cQuery += "       WHERE TT_DATA BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'"
_cQuery += "         AND INTERCOMPANY  = 0
_cQuery += "       GROUP BY IDOBRAHISTORICO) F
_cQuery += " WHERE TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = F.CODHIS
_cQuery += "   AND SB1.B1_COD                  = SB5.B5_COD
_cQuery += "   AND SB1.B1_PROC                 = SA2.A2_COD
_cQuery += "   AND SB1.B1_LOJPROC              = SA2.A2_LOJA
_cQuery += "   AND SB5.B5_XSELO                = Z1.X5_CHAVE
_cQuery += "   AND SB1.B1_XIDTPPU              = Z4.X5_CHAVE
_cQuery += "   AND SB1.B1_FILIAL               = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB5.B5_FILIAL               = '" + xFilial("SB5") + "'"
_cQuery += "   AND SA2.A2_FILIAL               = '" + xFilial("SA2") + "'"
_cQuery += "   AND Z1.X5_FILIAL                = '" + xFilial("SX5") + "'"
_cQuery += "   AND Z4.X5_FILIAL                = '" + xFilial("SX5") + "'"
_cQuery += "   AND Z1.X5_TABELA                = 'Z1'
_cQuery += "   AND Z4.X5_TABELA                = 'Z4'
_cQuery += "   AND SB5.B5_XFEC                 = '1'
_cQuery += "   AND SB1.D_E_L_E_T_              = ' '
_cQuery += "   AND SB5.D_E_L_E_T_              = ' '
_cQuery += "   AND SA2.D_E_L_E_T_              = ' '
_cQuery += "   AND Z1.D_E_L_E_T_               = ' '
_cQuery += "   AND Z4.D_E_L_E_T_               = ' '
_cQuery += "   AND SB1.B1_XAQUIS               = '"+MV_PAR03+"'"
If !Empty(MV_PAR04)
	_cQuery += "   AND SA2.A2_COD = '"+MV_PAR04+"'
Endif 

If !Empty(MV_PAR05)
	_cQuery += "   AND SA2.A2_LOJA = '"+MV_PAR05+"'
Endif
_cQuery += " GROUP BY SB1.B1_ISBN, TRIM(SB1.B1_DESC), TRIM(Z1.X5_DESCRI), SB5.B5_XDTPUBL, TRIM(Z4.X5_DESCRI)
_cQuery += "       )
_cQuery += " ORDER BY LIQUIDO DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

(_cAlias1)->(dbGoTop())

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()

    If (_cAlias1)->LIQUIDO <> 0 .And. (_cAlias1)->LIQUIDOANT <> 0
		xVarLiq := ((_cAlias1)->LIQUIDO / (_cAlias1)->LIQUIDOANT - 1) * 100
    Else
		xVarLiq := 0
	Endif
	
    If (_cAlias1)->QTDE <> 0 .And. (_cAlias1)->QTDEANT <> 0
		xVarQtde := ((_cAlias1)->QTDE / (_cAlias1)->QTDEANT - 1) * 100
    Else
		xVarQtde := 0
	Endif

	oReport:IncMeter()

	oSection1:Init()  

    xDtPubl := STOD((_cAlias1)->DATAPUBLICACAO)
	
	oSection1:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN) 
	oSection1:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
	oSection1:Cell("SELO"):SetValue((_cAlias1)->SELO)
	oSection1:Cell("DATAPUBLICACAO"):SetValue(xDtPubl)
	oSection1:Cell("TIPOPUBLICACAO"):SetValue((_cAlias1)->TIPOPUBLICACAO)
	oSection1:Cell("QTDE"):SetValue((_cAlias1)->QTDE)
	oSection1:Cell("LIQUIDO"):SetValue((_cAlias1)->LIQUIDO)
	oSection1:Cell("QTDEANT"):SetValue((_cAlias1)->QTDEANT)
	oSection1:Cell("LIQUIDOANT"):SetValue((_cAlias1)->LIQUIDOANT)
	oSection1:Cell("VARQTDE"):SetValue(xVarQtde)
	oSection1:Cell("VARLIQUIDO"):SetValue(xVarLiq)
                    
    tQtde    := tQtde    + (_cAlias1)->QTDE
    tQtdeAnt := tQtdeAnt + (_cAlias1)->QTDEANT
    tLiq     := tLiq     + (_cAlias1)->LIQUIDO
    tLiqAnt  := tLiqAnt  + (_cAlias1)->LIQUIDOANT
    xRank    := xRank    + ((_cAlias1)->LIQUIDO/(_cAlias1)->TOTALLIQ*100)

	oSection1:Cell("RANK"):SetValue(xRank)
    
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

oSection2:Init()

oSection2:Cell("TLIQUIDO"):SetValue(tLiq)
oSection2:Cell("TQTDE"):SetValue(tQtde)
oSection2:Cell("TLIQUIDOANT"):SetValue(tLiqAnt)
oSection2:Cell("TQTDEANT"):SetValue(tQtdeAnt)
           
tVarLiq  := (tLiq  / tLiqAnt  - 1) * 100
tVarQtde := (tQtde / tQtdeAnt - 1) * 100

oSection2:Cell("TVARLIQUIDO"):SetValue(tVarLiq)
oSection2:Cell("TVARQTDE"):SetValue(tVarQtde)

oSection2:PrintLine()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)