#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FAT006    ∫Autor  ≥Erica Vieites       ∫ Data ≥  13/02/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Relatorio de Faturamento Por Produto                        ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥GEN - Faturamento                                           ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function FAT006()             

Local oReport
Local cPerg := "FAT006"


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

PutSx1(cPerg, cItPerg, "Dt Emiss„o de:", "Dt Emiss„o de:" ,"Dt Emiss„o de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emiss„o atÈ:", "Dt Emiss„o atÈ:","Dt Emiss„o atÈ:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03-------------------------------------------------- 
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

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------  
cCpoPer := "Z7_AREA"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "¡rea ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SZ7"	//Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SZ7')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

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
oReport := TReport():New("FAT006","FAT006 - Faturamemto por Produto",cPerg,{|oReport| PrintReport(oReport)},"FAT006 - Faturamento por Produto")

//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 6		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"FAT006 - Faturamento por Produto","")

//Celulas da secao                                                                             
TRCell():New(oSection1,"B1_COD"			,"SB1","CÛdigo"	  							,					,8)
TRCell():New(oSection1,"B1_ISBN"		,"SB1","ISBN"	  							,					,20)
TRCell():New(oSection1,"B1_DESC"   		,"SB1","DescriÁ„o (Conceito FEC)"			,					,38)
TRCell():New(oSection1,"LIQUIDO"		,"   ","|    Ano   " +CRLF+ "|  R$ Mil  "	,'@E 999,999'		,12)
TRCell():New(oSection1,"QTDE"		    ,"   ","    Atual  " +CRLF+ "   Qtde    "	,'@E 999,999,999'	,12)
TRCell():New(oSection1,"LIQUIDOANT"		,"   ","|    Ano   " +CRLF+ "|  R$ Mil  "	,'@E 999,999'	 	,12)
TRCell():New(oSection1,"QTDEANT"	    ,"   ","  Anterior " +CRLF+ "   Qtde    "	,'@E 999,999,999'	,12)
TRCell():New(oSection1,"VARLIQUIDO"		,"   ","| VariaÁ„o"  +CRLF+ "|  Valor  "	,'@E 9,999,999.99'	,18)
TRCell():New(oSection1,"VARQTDE"	    ,"   ","        % "  +CRLF+ "   Qtde   "	,'@E 999,999.99'	,10)
TRCell():New(oSection1,"RANK"		    ,"   ","|  Rank "    +CRLF+ "| Acum %"		,'@E 999.99'		,8)
TRCell():New(oSection1,"SELO"   		,"   ","Selo"								,					,8)
TRCell():New(oSection1,"DATAPUBLICACAO"	,"   ","Data"        +CRLF+ "PublicaÁ„o"	,					,18)
TRCell():New(oSection1,"TIPOPUBLICACAO"	,"   ","Tipo"        +CRLF+ "PublicaÁ„o"	,					,18)
TRCell():New(oSection1,"SITUACAOOBRA"	,"   ","SituaÁ„o"    +CRLF+ "Venda"			,					,15)
TRCell():New(oSection1,"CATEGOGIA" 		,"   ","Categoria"							,					,15)
TRCell():New(oSection1,"AREA"   		,"   ","¡rea"								,					,15)
TRCell():New(oSection1,"CURSO"   		,"   ","Curso"								,					,15)
TRCell():New(oSection1,"DISCIPLINA" 	,"   ","Disciplina"							,					,18)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias() 
Local _cAlias2	:= GetNextAlias() 
Local xVarQtde  := 0
Local xVarLiq   := 0
Local xLiquido  := 0
Local xLiqAnt   := 0
Local xRank     := nil

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(LASTDATE(MONTHSUB(MV_PAR02,1)))
_cParm3 := DTOS(YEARSUB(MV_PAR01,1))
_cParm4 := DTOS(YEARSUB(MV_PAR02,1))
_cParm5 := DTOS(FIRSTDATE(MV_PAR02))
_cParm6 := DTOS(MV_PAR02)

_cQuery += "SELECT ' ' B1_COD, ' ' B1_ISBN, ' ' B1_DESC, ' ' SELO, ' ' DATAPUBLICACAO, ' ' TIPOPUBLICACAO, ' ' SITUACAOOBRA, ' ' CATEGORIA, ' ' AREA, ' ' CURSO, 'Total' DISCIPLINA,
_cQuery += "       SUM(F.QTDE) QTDE, SUM(F.LIQUIDO) LIQUIDO, SUM(F.QTDEANT) QTDEANT, SUM(F.LIQUIDOANT) LIQUIDOANT
_cQuery += "  FROM (SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, FAT.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD,
_cQuery += "               FAT.QTDE, FAT.LIQUIDO, FAT.QTDEANT, FAT.LIQUIDOANT
_cQuery += "          FROM (SELECT B5_XCODHIS,
_cQuery += "                       SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO, SUM(QTDEANT) QTDEANT, SUM(LIQUIDOANT) LIQUIDOANT
_cQuery += "                  FROM (SELECT TTF.IDOBRAHISTORICO B5_XCODHIS, NVL(SUM(TTF.QTDE), 0) QTDE, NVL(SUM(TTF.LIQUIDO), 0) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM TT_FATURAMENTO TTF
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON TTF.IDOBRA = TO_NUMBER(TRIM(SB1.B1_COD))
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE TTF.DATA BETWEEN '"+ _cParm1 + "' AND '" + _cParm2 +"'"
_cQuery += "                           AND TTF.FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                         GROUP BY TTF.IDOBRAHISTORICO
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TTF.IDOBRAHISTORICO B5_XCODHIS, 0 QTDE, 0 LIQUIDO, NVL(SUM(TTF.QTDE),0) QTDEANT, NVL(SUM(TTF.LIQUIDO),0) LIQUIDOANT
_cQuery += "                          FROM TT_FATURAMENTO TTF
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON TTF.IDOBRA = TO_NUMBER(TRIM(SB1.B1_COD))
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE TTF.DATA BETWEEN '"+ _cParm3 + "' AND '" + _cParm4 +"'"
_cQuery += "                           AND TTF.FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                          GROUP BY TTF.IDOBRAHISTORICO
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM " + RetSqlName("SD2") + " SD2
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND D_E_L_E_T_  = ' ')
_cQuery += "                           AND SD2.D2_EMISSAO BETWEEN '"+ _cParm5 + "' AND '" + _cParm6 +"'"
_cQuery += "                           AND SD2.D2_TIPO NOT IN ('D','B')
_cQuery += "                           AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                           AND SD2.D_E_L_E_T_ = ' '
_cQuery += "                         GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1) QTDE, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM " + RetSqlName("SD1") + " SD1
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND F4_CODIGO < '400' AND D_E_L_E_T_  = ' ')
_cQuery += "                           AND SD1.D1_DTDIGIT BETWEEN '"+ _cParm5 + "' AND '" + _cParm6 +"'"
_cQuery += "                           AND SD1.D1_TIPO    = 'D'
_cQuery += "                           AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
_cQuery += "                           AND SD1.D_E_L_E_T_ = ' '
_cQuery += "                          GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS)))
_cQuery += "                 GROUP BY B5_XCODHIS) FAT
_cQuery += "                  LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_COD)) B5_COD, TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS
_cQuery += "                               FROM " + RetSqlName("SB5")
_cQuery += "                              WHERE B5_XFEC = '1'
_cQuery += "                                AND D_E_L_E_T_ = ' ') FEC
_cQuery += "                    ON FAT.B5_XCODHIS = FEC.B5_XCODHIS
_cQuery += "                  LEFT JOIN (SELECT TO_NUMBER(TRIM(SB5.B5_COD)) B5_COD, TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS
_cQuery += "                               FROM " + RetSqlName("SB5") + " SB5
_cQuery += "                               JOIN (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
_cQuery += "                                       FROM " + RetSqlName("SB5")
_cQuery += "                                      WHERE D_E_L_E_T_ = ' '
_cQuery += "                                      GROUP BY TO_NUMBER(TRIM(B5_XCODHIS))) M
_cQuery += "                                 ON TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = M.B5_XCODHIS
_cQuery += "                                AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
_cQuery += "                              WHERE TRIM(SB5.B5_XFEC) <> '1'
_cQuery += "                                AND SB5.D_E_L_E_T_ = ' ') SFEC
_cQuery += "                    ON FAT.B5_XCODHIS = SFEC.B5_XCODHIS) F
_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "    ON TO_NUMBER(TRIM(SB1.B1_COD)) = F.B1_COD
_cQuery += "   AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "   AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "   AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "    ON SB5.B5_COD = SB1.B1_COD
If !Empty(MV_PAR05)
	_cQuery += "   AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
_cQuery += "    ON XZ1.X5_CHAVE = SB5.B5_XSELO
_cQuery += "   AND XZ1.X5_TABELA = 'Z1'
_cQuery += "   AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
_cQuery += "    ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
_cQuery += "    ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
_cQuery += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery += "    ON SBM.BM_GRUPO = SB1.B1_GRUPO
_cQuery += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ5") + " SZ5
_cQuery += "    ON SZ5.Z5_CURSO = SB5.B5_XCURSO
_cQuery += "   AND Z5_FILIAL = '" + xFilial("SZ5") + "'"
_cQuery += "   AND SZ5.D_E_L_E_T_ = ' ' 
_cQuery += "  LEFT JOIN " + RetSqlName("SZ6") + " SZ6
_cQuery += "    ON SZ6.Z6_DISCIPL = SB5.B5_XDISCIP
_cQuery += "   AND Z6_FILIAL = '" + xFilial("SZ6") + "'"
_cQuery += "   AND SZ6.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "    ON SZ7.Z7_AREA = SB5.B5_XAREA
_cQuery += "   AND Z7_FILIAL = '" + xFilial("SZ7") + "'"
_cQuery += "   AND SZ7.D_E_L_E_T_ = ' '
_cQuery += " WHERE F.LIQUIDO <> 0
_cQuery += "    OR F.LIQUIDOANT <> 0

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

(_cAlias1)->(dbGoTop())

oReport:SkipLine()

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()

    If (_cAlias1)->LIQUIDO <> 0 .And. (_cAlias1)->LIQUIDOANT <> 0
		xVarLiq := ((_cAlias1)->LIQUIDO / (_cAlias1)->LIQUIDOANT) * 100
    Else
		xVarLiq := 0
	Endif
	
    If (_cAlias1)->QTDE <> 0 .And. (_cAlias1)->QTDEANT <> 0
		xVarQtde := ((_cAlias1)->QTDE / (_cAlias1)->QTDEANT) * 100
    Else
		xVarQtde := 0
	Endif
                    
	xLiquido := (_cAlias1)->LIQUIDO / 1000
	xLiqAnt  := (_cAlias1)->LIQUIDOANT / 1000

	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("B1_COD"):SetValue((_cAlias1)->B1_COD) 
	oSection1:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN) 
	oSection1:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
	oSection1:Cell("SELO"):SetValue((_cAlias1)->SELO)
	oSection1:Cell("DATAPUBLICACAO"):SetValue((_cAlias1)->DATAPUBLICACAO)
	oSection1:Cell("TIPOPUBLICACAO"):SetValue((_cAlias1)->TIPOPUBLICACAO)
	oSection1:Cell("SITUACAOOBRA"):SetValue((_cAlias1)->SITUACAOOBRA)
	oSection1:Cell("CATEGORIA"):SetValue((_cAlias1)->CATEGORIA)
	oSection1:Cell("AREA"):SetValue((_cAlias1)->AREA)
	oSection1:Cell("CURSO"):SetValue((_cAlias1)->CURSO)
	oSection1:Cell("DISCIPLINA"):SetValue((_cAlias1)->DISCIPLINA)
	oSection1:Cell("QTDE"):SetValue((_cAlias1)->QTDE)
	oSection1:Cell("LIQUIDO"):SetValue(xLiquido)
	oSection1:Cell("QTDEANT"):SetValue((_cAlias1)->QTDEANT)
	oSection1:Cell("LIQUIDOANT"):SetValue(xLiqAnt)
	oSection1:Cell("VARQTDE"):SetValue(xVarQtde)
	oSection1:Cell("VARLIQUIDO"):SetValue(xVarLiq)
	oSection1:Cell("RANK"):SetValue(xRank)
    
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

oReport:SkipLine()
	
_cQuery	:= ""

_cQuery += "SELECT SB1.B1_COD, SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, TRIM(XZ1.X5_DESCRI) SELO, SB5.B5_XDTPUBL DATAPUBLICACAO, 
_cQuery += "       TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO, TRIM(XZ5.X5_DESCRI) SITUACAOOBRA,
_cQuery += "       DECODE(SBM.BM_XCATEG, 'D', 'DID - ', 'P', 'PROF - ', 'I', 'INT.GER - ') || DECODE(TO_NUMBER(TRIM(SB5.B5_XTIPINC)), '1', 'ON', '2', 'NE') CATEGORIA,
_cQuery += "       TRIM(Z7_DESC) AREA, TRIM(Z5_DESC) CURSO, TRIM(Z6_DESC) DISCIPLINA,
_cQuery += "       F.QTDE, F.LIQUIDO, F.QTDEANT, F.LIQUIDOANT, SUM(LIQUIDO) OVER() TOTALLIQ
_cQuery += "  FROM (SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, FAT.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD,
_cQuery += "               FAT.QTDE, FAT.LIQUIDO, FAT.QTDEANT, FAT.LIQUIDOANT
_cQuery += "          FROM (SELECT B5_XCODHIS,
_cQuery += "                       SUM(QTDE) QTDE, SUM(LIQUIDO) LIQUIDO, SUM(QTDEANT) QTDEANT, SUM(LIQUIDOANT) LIQUIDOANT
_cQuery += "                  FROM (SELECT TTF.IDOBRAHISTORICO B5_XCODHIS, NVL(SUM(TTF.QTDE), 0) QTDE, NVL(SUM(TTF.LIQUIDO), 0) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM TT_FATURAMENTO TTF
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON TTF.IDOBRA = TO_NUMBER(TRIM(SB1.B1_COD))
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE TTF.DATA BETWEEN '"+ _cParm1 + "' AND '" + _cParm2 +"'"
_cQuery += "                           AND TTF.FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                         GROUP BY TTF.IDOBRAHISTORICO
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TTF.IDOBRAHISTORICO B5_XCODHIS, 0 QTDE, 0 LIQUIDO, NVL(SUM(TTF.QTDE),0) QTDEANT, NVL(SUM(TTF.LIQUIDO),0) LIQUIDOANT
_cQuery += "                          FROM TT_FATURAMENTO TTF
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON TTF.IDOBRA = TO_NUMBER(TRIM(SB1.B1_COD))
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE TTF.DATA BETWEEN '"+ _cParm3 + "' AND '" + _cParm4 +"'"
_cQuery += "                           AND TTF.FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                          GROUP BY TTF.IDOBRAHISTORICO
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM " + RetSqlName("SD2") + " SD2
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE SD2.D2_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND F4_CODIGO < '800' AND D_E_L_E_T_  = ' ')
_cQuery += "                           AND SD2.D2_EMISSAO BETWEEN '"+ _cParm5 + "' AND '" + _cParm6 +"'"
_cQuery += "                           AND SD2.D2_TIPO NOT IN ('D','B')
_cQuery += "                           AND SD2.D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery += "                           AND SD2.D_E_L_E_T_ = ' '
_cQuery += "                         GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS))
_cQuery += "                        UNION ALL
_cQuery += "                        SELECT TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1) QTDE, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC),0)*(-1) LIQUIDO, 0 QTDEANT, 0 LIQUIDOANT
_cQuery += "                          FROM " + RetSqlName("SD1") + " SD1
_cQuery += "                          JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                            ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                           AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "	                       AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "	                       AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "                           AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "                           AND SB1.D_E_L_E_T_ = ' '
_cQuery += "                          JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "                            ON SB1.B1_COD = SB5.B5_COD
If !Empty(MV_PAR05)
	_cQuery += "	                       AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "                           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "                           AND SB5.D_E_L_E_T_ = ' '
_cQuery += "                         WHERE SD1.D1_TES IN (SELECT F4_CODIGO FROM " + RetSqlName("SF4") + " WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND F4_CODIGO < '400' AND D_E_L_E_T_  = ' ')
_cQuery += "                           AND SD1.D1_DTDIGIT BETWEEN '"+ _cParm5 + "' AND '" + _cParm6 +"'"
_cQuery += "                           AND SD1.D1_TIPO    = 'D'
_cQuery += "                           AND SD1.D1_FILIAL  = '" + xFilial("SD1") + "'"
_cQuery += "                           AND SD1.D_E_L_E_T_ = ' '
_cQuery += "                          GROUP BY TO_NUMBER(TRIM(SB5.B5_XCODHIS)))
_cQuery += "                 GROUP BY B5_XCODHIS) FAT
_cQuery += "                  LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_COD)) B5_COD, TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS
_cQuery += "                               FROM " + RetSqlName("SB5")
_cQuery += "                              WHERE B5_XFEC = '1'
_cQuery += "                                AND D_E_L_E_T_ = ' ') FEC
_cQuery += "                    ON FAT.B5_XCODHIS = FEC.B5_XCODHIS
_cQuery += "                  LEFT JOIN (SELECT TO_NUMBER(TRIM(SB5.B5_COD)) B5_COD, TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS
_cQuery += "                               FROM " + RetSqlName("SB5") + " SB5
_cQuery += "                               JOIN (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
_cQuery += "                                       FROM " + RetSqlName("SB5")
_cQuery += "                                      WHERE D_E_L_E_T_ = ' '
_cQuery += "                                      GROUP BY TO_NUMBER(TRIM(B5_XCODHIS))) M
_cQuery += "                                 ON TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = M.B5_XCODHIS
_cQuery += "                                AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
_cQuery += "                              WHERE TRIM(SB5.B5_XFEC) <> '1'
_cQuery += "                                AND SB5.D_E_L_E_T_ = ' ') SFEC
_cQuery += "                    ON FAT.B5_XCODHIS = SFEC.B5_XCODHIS) F
_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "    ON TO_NUMBER(TRIM(SB1.B1_COD)) = F.B1_COD
_cQuery += "   AND SB1.B1_XIDTPPU <> ' '
If !Empty(MV_PAR03)
	_cQuery += "   AND SB1.B1_PROC = '"+MV_PAR03+"'
EndIf 
If !Empty(MV_PAR04)
	_cQuery += "   AND SB1.B1_LOJPROC = '"+MV_PAR04+"'
EndIf
_cQuery += "   AND SB1.B1_XIDTPPU <> ' '
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
_cQuery += "    ON SB5.B5_COD = SB1.B1_COD
If !Empty(MV_PAR05)
	_cQuery += "   AND SB5.B5_XAREA = '"+MV_PAR05+"'
EndIf 
_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
_cQuery += "    ON XZ1.X5_CHAVE = SB5.B5_XSELO
_cQuery += "   AND XZ1.X5_TABELA = 'Z1'
_cQuery += "   AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ1.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
_cQuery += "    ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5
_cQuery += "    ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
_cQuery += "   AND XZ5.X5_TABELA = 'Z5'
_cQuery += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ5.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery += "    ON SBM.BM_GRUPO = SB1.B1_GRUPO
_cQuery += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ5") + " SZ5
_cQuery += "    ON SZ5.Z5_CURSO = SB5.B5_XCURSO
_cQuery += "   AND Z5_FILIAL = '" + xFilial("SZ5") + "'"
_cQuery += "   AND SZ5.D_E_L_E_T_ = ' ' 
_cQuery += "  LEFT JOIN " + RetSqlName("SZ6") + " SZ6
_cQuery += "    ON SZ6.Z6_DISCIPL = SB5.B5_XDISCIP
_cQuery += "   AND Z6_FILIAL = '" + xFilial("SZ6") + "'"
_cQuery += "   AND SZ6.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery += "    ON SZ7.Z7_AREA = SB5.B5_XAREA
_cQuery += "   AND Z7_FILIAL = '" + xFilial("SZ7") + "'"
_cQuery += "   AND SZ7.D_E_L_E_T_ = ' '
_cQuery += " WHERE F.LIQUIDO <> 0
_cQuery += "    OR F.LIQUIDOANT <> 0
_cQuery += " ORDER BY F.LIQUIDO DESC

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)

(_cAlias2)->(dbGoTop())

xRank := 0

Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()

    If (_cAlias2)->LIQUIDO <> 0 .And. (_cAlias2)->LIQUIDOANT <> 0
		xVarLiq := ((_cAlias2)->LIQUIDO / (_cAlias2)->LIQUIDOANT) * 100
    Else
		xVarLiq := 0
	Endif
	
    If (_cAlias2)->QTDE <> 0 .And. (_cAlias2)->QTDEANT <> 0
		xVarQtde := ((_cAlias2)->QTDE / (_cAlias2)->QTDEANT) * 100
    Else
		xVarQtde := 0
	Endif

	xLiquido := (_cAlias2)->LIQUIDO / 1000
	xLiqAnt  := (_cAlias2)->LIQUIDOANT / 1000
    xRank    := xRank    + ((_cAlias2)->LIQUIDO/(_cAlias2)->TOTALLIQ*100)

	oReport:IncMeter()

	oSection1:Init()  

    xDtPubl := STOD((_cAlias2)->DATAPUBLICACAO)
	
	oSection1:Cell("B1_COD"):SetValue((_cAlias2)->B1_COD) 
	oSection1:Cell("B1_ISBN"):SetValue((_cAlias2)->B1_ISBN) 
	oSection1:Cell("B1_DESC"):SetValue((_cAlias2)->B1_DESC)
	oSection1:Cell("SELO"):SetValue((_cAlias2)->SELO)
	oSection1:Cell("DATAPUBLICACAO"):SetValue(xDtPubl)
	oSection1:Cell("TIPOPUBLICACAO"):SetValue((_cAlias2)->TIPOPUBLICACAO)
	oSection1:Cell("SITUACAOOBRA"):SetValue((_cAlias2)->SITUACAOOBRA)
	oSection1:Cell("CATEGORIA"):SetValue((_cAlias2)->CATEGORIA)
	oSection1:Cell("AREA"):SetValue((_cAlias2)->AREA)
	oSection1:Cell("CURSO"):SetValue((_cAlias2)->CURSO)
	oSection1:Cell("DISCIPLINA"):SetValue((_cAlias2)->DISCIPLINA)
	oSection1:Cell("QTDE"):SetValue((_cAlias2)->QTDE)
	oSection1:Cell("LIQUIDO"):SetValue(xLiquido)
	oSection1:Cell("QTDEANT"):SetValue((_cAlias2)->QTDEANT)
	oSection1:Cell("LIQUIDOANT"):SetValue(xLiqAnt)
	oSection1:Cell("VARQTDE"):SetValue(xVarQtde)
	oSection1:Cell("VARLIQUIDO"):SetValue(xVarLiq)
	oSection1:Cell("RANK"):SetValue(xRank)
    
	oSection1:PrintLine()

	(_cAlias2)->(dbSkip())
	
EndDo

oSection1:Finish()
	         
DbSelectArea(_cAlias2)
DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)