#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER005A

DESCRICAO: GER005a - FATURAMENTO COMPARATIVO POR CLIENTE

ALTERACOES:
04/07/2016 - Desenvolvimento do fonte

/*/

User Function GER005A

Local oReport
Local cPerg := "GER05A"

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
04/07/2016 - Helimar Tavares - Criacao do fonte
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
cTpoCpo := "D"
cTitPer := "Data "                                               
nTamPer := 8                                                                              
cTpoPer := "G"

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH , cTpoCpo, nTamPer, 0, 0, cTpoPer,"", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------  
cCpoPer := "A3_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Vendedor ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA3_A"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "X5_CHAVE"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Tp. Cliente ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SX5TP"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------  
cCpoPer := "X5_CHAVE"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Canal Venda ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SX5Z2"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
04/07/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

_cMes   := MONTH2STR(MV_PAR01)
_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

//Declaracao do relatorio
oReport := TReport():New("GER005A","GER005A - Faturamento Líq. Mensal por Cliente - Total GEN sem Fórum",cPerg,{|oReport| PrintReport(oReport)},"GER005A - Faturamento Líq. Mensal por Cliente - Total GEN sem Fórum",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

oReport:NDEVICE := 4

//Secao do relatorio
oSection1 := TRSection():New(oReport,"GER005A - Fat. Líq. Mensal por Cliente - Total GEN sem Fórum","")
	
//Celulas da secao
TRCell():New(oSection1,"CNPJ" 			,"","CNPJ")
TRCell():New(oSection1,"DESCRICAO"		,"","Descrição")
TRCell():New(oSection1,"LIQUIDO"		,"",_cAno+" YTD R$"				,"@E 999,999,999.99")
TRCell():New(oSection1,"LIQUIDO_AA"		,"",_cAnoAnt+" YTD R$"			,"@E 999,999,999.99")
TRCell():New(oSection1,"PERC_VLR"		,"","% "+_cAno+" X "+_cAnoAnt	,"@E 999,999.99")
TRCell():New(oSection1,"META"	 		,"","META R$"					,"@E 999,999,999.99")
TRCell():New(oSection1,"PERC_META"		,"","% META"					,"@E 999,999.99")
If _cMes >= '12'
	TRCell():New(oSection1,"VLRDEZ"			,"","Dez"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '11'
	TRCell():New(oSection1,"VLRNOV"			,"","Nov"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '10'
	TRCell():New(oSection1,"VLROUT"			,"","Out"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '09'
	TRCell():New(oSection1,"VLRSET"			,"","Set"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '08'
	TRCell():New(oSection1,"VLRAGO"			,"","Ago"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '07'
	TRCell():New(oSection1,"VLRJUL"			,"","Jul"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '06'
	TRCell():New(oSection1,"VLRJUN"			,"","Jun"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '05'
	TRCell():New(oSection1,"VLRMAI"			,"","Mai"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '04'
	TRCell():New(oSection1,"VLRABR"			,"","Abr"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '03'
	TRCell():New(oSection1,"VLRMAR"			,"","Mar"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
If _cMes >= '02'
	TRCell():New(oSection1,"VLRFEV"			,"","Fev"+_cAno+" R$"			,"@E 999,999,999.99") 
EndIF
TRCell():New(oSection1,"VLRJAN"			,"","Jan"+_cAno+" R$"			,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRDEZ_AA"		,"","Dez"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRNOV_AA"		,"","Nov"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLROUT_AA"		,"","Out"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRSET_AA"		,"","Set"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRAGO_AA"		,"","Ago"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRJUL_AA"		,"","Jul"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRJUN_AA"		,"","Jun"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRMAI_AA"		,"","Mai"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRABR_AA"		,"","Abr"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRMAR_AA"		,"","Mar"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRFEV_AA"		,"","Fev"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"VLRJAN_AA"		,"","Jan"+_cAnoAnt+" R$"		,"@E 999,999,999.99") 
TRCell():New(oSection1,"UF"				,"","UF")
TRCell():New(oSection1,"MUNICIPIO"		,"","Município")
TRCell():New(oSection1,"TIPOCLIENTE"	,"","Tipo Cliente")
TRCell():New(oSection1,"CANAL"			,"","Canal")
TRCell():New(oSection1,"VENDEDOR"		,"","Vendedor")

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
04/07/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""
 
_cParm1 := DTOS(LASTDATE(MV_PAR01))
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

xLiquido    := 0
xLiquido_AA := 0
xMeta       := 0
xVlrJan_AA  := 0
xVlrFev_AA  := 0
xVlrMar_AA  := 0
xVlrAbr_AA  := 0
xVlrMai_AA  := 0
xVlrJun_AA  := 0
xVlrJul_AA  := 0
xVlrAgo_AA  := 0
xVlrSet_AA  := 0
xVlrOut_AA  := 0
xVlrNov_AA  := 0
xVlrDez_AA  := 0
xVlrJan     := 0
xVlrFev     := 0
xVlrMar     := 0
xVlrAbr     := 0
xVlrMai     := 0
xVlrJun     := 0
xVlrJul     := 0
xVlrAgo     := 0
xVlrSet     := 0
xVlrOut     := 0
xVlrNov     := 0
xVlrDez     := 0

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery	:= ""
	_cQuery += " SELECT DECODE(TRIM(F.A1_XCANALV), '3', '999999999', DECODE(F.A1_GRPVEN, '      ', F.A1_COD||F.A1_LOJA, F.A1_GRPVEN)) CODIGO,
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)) CNPJ,
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI)) DESCRICAO,
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.A1_EST) UF, 
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.MUNICIPIO) MUNICIPIO, 
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.TIPOCLIENTE) TIPOCLIENTE, 
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.CANAL) CANAL,
	_cQuery += "        DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.VENDEDOR) VENDEDOR,
	_cQuery += "        SUM(F.LIQUIDO) LIQUIDO, SUM(F.LIQUIDO_AA) LIQUIDO_AA, 0 META,
	_cQuery += "        SUM(F.VLRJAN_AA) VLRJAN_AA, SUM(F.VLRFEV_AA) VLRFEV_AA, SUM(F.VLRMAR_AA) VLRMAR_AA,
	_cQuery += "        SUM(F.VLRABR_AA) VLRABR_AA, SUM(F.VLRMAI_AA) VLRMAI_AA, SUM(F.VLRJUN_AA) VLRJUN_AA,
	_cQuery += "        SUM(F.VLRJUL_AA) VLRJUL_AA, SUM(F.VLRAGO_AA) VLRAGO_AA, SUM(F.VLRSET_AA) VLRSET_AA,
	_cQuery += "        SUM(F.VLROUT_AA) VLROUT_AA, SUM(F.VLRNOV_AA) VLRNOV_AA, SUM(F.VLRDEZ_AA) VLRDEZ_AA,
	_cQuery += "        SUM(F.VLRJAN) VLRJAN, SUM(F.VLRFEV) VLRFEV, SUM(F.VLRMAR) VLRMAR,
	_cQuery += "        SUM(F.VLRABR) VLRABR, SUM(F.VLRMAI) VLRMAI, SUM(F.VLRJUN) VLRJUN,
	_cQuery += "        SUM(F.VLRJUL) VLRJUL, SUM(F.VLRAGO) VLRAGO, SUM(F.VLRSET) VLRSET,
	_cQuery += "        SUM(F.VLROUT) VLROUT, SUM(F.VLRNOV) VLRNOV, SUM(F.VLRDEZ) VLRDEZ
	_cQuery += "   FROM (SELECT CASE WHEN A1_GRPVEN <> '      ' 
	_cQuery += "                THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
	_cQuery += "                ELSE A1_COD END A1_COD,
	_cQuery += "                CASE WHEN A1_GRPVEN <> '      ' 
	_cQuery += "                THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
	_cQuery += "                ELSE A1_LOJA END A1_LOJA,
	_cQuery += "                A1_GRPVEN, A1_XCANALV, LIQUIDO, LIQUIDO_AA, 
	_cQuery += "                VLRJAN_AA, VLRFEV_AA, VLRMAR_AA, VLRABR_AA, VLRMAI_AA, VLRJUN_AA, VLRJUL_AA, VLRAGO_AA, VLRSET_AA, VLROUT_AA, VLRNOV_AA, VLRDEZ_AA,
	_cQuery += "                VLRJAN, VLRFEV, VLRMAR, VLRABR, VLRMAI, VLRJUN, VLRJUL, VLRAGO, VLRSET, VLROUT, VLRNOV, VLRDEZ
	_cQuery += "           FROM (SELECT VMC.A1_COD, VMC.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                             '02', VLRJAN+VLRFEV,
	_cQuery += "                                                             '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                             '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                             '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                             '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                             '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                             '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                             '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                             '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                             '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                             '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                             '02', VLRJAN+VLRFEV,
	_cQuery += "                                                             '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                             '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                             '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                             '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                             '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                             '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                             '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                             '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                             '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                             '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO_AA,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJAN, 0)) VLRJAN_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRFEV, 0)) VLRFEV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRMAR, 0)) VLRMAR_AA,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRABR, 0)) VLRABR_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRMAI, 0)) VLRMAI_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJUN, 0)) VLRJUN_AA,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRJUL, 0)) VLRJUL_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRAGO, 0)) VLRAGO_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRSET, 0)) VLRSET_AA,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLROUT, 0)) VLROUT_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRNOV, 0)) VLRNOV_AA, SUM(DECODE(ANO, '"+ _cAnoAnt+"', VLRDEZ, 0)) VLRDEZ_AA,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', VLRJAN, 0)) VLRJAN,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN VLRFEV ELSE 0 END, 0)) VLRFEV,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN VLRMAR ELSE 0 END, 0)) VLRMAR,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN VLRABR ELSE 0 END, 0)) VLRABR,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN VLRMAI ELSE 0 END, 0)) VLRMAI,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN VLRJUN ELSE 0 END, 0)) VLRJUN,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN VLRJUL ELSE 0 END, 0)) VLRJUL,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN VLRAGO ELSE 0 END, 0)) VLRAGO,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN VLRSET ELSE 0 END, 0)) VLRSET,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN VLROUT ELSE 0 END, 0)) VLROUT,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN VLRNOV ELSE 0 END, 0)) VLRNOV,
	_cQuery += "                        SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN VLRDEZ ELSE 0 END, 0)) VLRDEZ
	_cQuery += "                   FROM GER_VENDAMESCLIENTE VMC
	_cQuery += "                   LEFT JOIN " + RetSqlName("SA1") + " SA1
	_cQuery += "                     ON SA1.A1_COD = VMC.A1_COD
	_cQuery += "                    AND SA1.A1_LOJA = VMC.A1_LOJA
	_cQuery += "                    AND SA1.D_E_L_E_T_ = ' '
	_cQuery += "                  WHERE VMC.ANO >= '"+ _cAnoAnt+"'
	_cQuery += "                  GROUP BY VMC.A1_COD, VMC.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
	_cQuery += "                  ORDER BY LIQUIDO DESC)) F
	_cQuery += "   LEFT JOIN " + RetSqlName("ACY") + " ACY
	_cQuery += "     ON ACY.ACY_GRPVEN = F.A1_GRPVEN
	_cQuery += "    AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'"
	_cQuery += "    AND ACY.D_E_L_E_T_ = ' '
	_cQuery += "   LEFT JOIN (SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_EST, CC2.CC2_MUN AS MUNICIPIO,
	_cQuery += "                     STP.X5_DESCRI AS TIPOCLIENTE, SZ2.X5_DESCRI AS CANAL, SA3.A3_NOME AS VENDEDOR
	_cQuery += "                FROM " + RetSqlName("SA1") + " SA1
	_cQuery += "                LEFT JOIN " + RetSqlName("CC2") + " CC2
	_cQuery += "                  ON SA1.A1_EST = CC2.CC2_EST
	_cQuery += "                 AND SA1.A1_COD_MUN = CC2.CC2_CODMUN
	_cQuery += "                 AND CC2.CC2_FILIAL = '" + xFilial("CC2") + "'"
	_cQuery += "                 AND CC2.D_E_L_E_T_ = ' '
	_cQuery += "                LEFT JOIN " + RetSqlName("SX5") + " STP
	_cQuery += "                  ON SA1.A1_XTIPCLI = STP.X5_CHAVE
	_cQuery += "                 AND STP.X5_TABELA = 'TP'
	_cQuery += "                 AND STP.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "                 AND STP.D_E_L_E_T_ = ' '
	_cQuery += "                LEFT JOIN " + RetSqlName("SX5") + " SZ2
	_cQuery += "                  ON SA1.A1_XCANALV = SZ2.X5_CHAVE
	_cQuery += "                 AND SZ2.X5_TABELA = 'Z2'
	_cQuery += "                 AND SZ2.X5_FILIAL = '" + xFilial("SX5") + "'"
	_cQuery += "                 AND SZ2.D_E_L_E_T_ = ' '
	_cQuery += "                LEFT JOIN " + RetSqlName("SA3") + " SA3
	_cQuery += "                  ON SA1.A1_VEND = SA3.A3_COD
	_cQuery += "                 AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"
	_cQuery += "                 AND SA3.D_E_L_E_T_ = ' '
	_cQuery += "               WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	If !Empty(MV_PAR02)
		_cQuery += "	             AND SA1.A1_VEND = '"+MV_PAR02+"'
	EndIf 
	If !Empty(MV_PAR03)
		_cQuery += "	             AND SA1.A1_XTIPCLI = '"+MV_PAR03+"'
	EndIf 
	If !Empty(MV_PAR04)
		_cQuery += "	             AND SA1.A1_XCANALV = '"+MV_PAR04+"'
	EndIf 
	_cQuery += "                 AND SA1.D_E_L_E_T_ = ' ') SA1
	_cQuery += "     ON F.A1_COD = SA1.A1_COD
	_cQuery += "    AND F.A1_LOJA = SA1.A1_LOJA
//	_cQuery += "  WHERE (F.LIQUIDO <> 0 OR F.LIQUIDO_AA <> 0)
    If _cMes = '01'
		_cQuery += "  WHERE (VLRJAN <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '02'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '03'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '04'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '05'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '06'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '07'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '08'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0 OR VLRAGO <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '09'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0 OR VLRAGO <> 0 OR VLRSET <> 0 
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '10'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0 OR VLRAGO <> 0 OR VLRSET <> 0 OR VLROUT <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '11'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0 OR VLRAGO <> 0 OR VLRSET <> 0 OR VLROUT <> 0  OR VLRNOV <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If _cMes = '12'
		_cQuery += "  WHERE (VLRJAN <> 0  OR VLRFEV <> 0 OR VLRMAR <> 0 OR VLRABR <> 0 OR VLRMAI <> 0 OR VLRJUN <> 0 OR VLRJUL <> 0 OR VLRAGO <> 0 OR VLRSET <> 0 OR VLROUT <> 0  OR VLRNOV <> 0 OR VLRDEZ <> 0
		_cQuery += "     OR  VLRJAN_AA <> 0 OR VLRFEV_AA <> 0 OR VLRMAR_AA <> 0 OR VLRABR_AA <> 0 OR VLRMAI_AA <> 0 OR VLRJUN_AA<> 0 OR VLRJUL_AA <> 0 OR VLRAGO_AA <> 0 OR VLRSET_AA <> 0 OR VLROUT_AA <> 0 OR VLRNOV_AA <> 0 OR VLRDEZ_AA <> 0)
	EndIf
	If !Empty(MV_PAR02)
		_cQuery += "    AND SA1.VENDEDOR IS NOT NULL
	EndIf 
	If !Empty(MV_PAR03)
		_cQuery += "    AND SA1.TIPOCLIENTE IS NOT NULL
	EndIf 
	If !Empty(MV_PAR04)
		_cQuery += "    AND SA1.CANAL IS NOT NULL
	EndIf 
	_cQuery += "  GROUP BY DECODE(TRIM(F.A1_XCANALV), '3', '999999999', DECODE(F.A1_GRPVEN, '      ', F.A1_COD||F.A1_LOJA, F.A1_GRPVEN)),
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)), 
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI)),
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.A1_EST), 
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.MUNICIPIO), 
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.TIPOCLIENTE), 
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.CANAL),
	_cQuery += "           DECODE(TRIM(F.A1_XCANALV), '3', NULL, SA1.VENDEDOR)
	_cQuery += "  ORDER BY LIQUIDO DESC, LIQUIDO_AA DESC
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
	
	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
		oSection1:Init()  
	                         
		xCNPJ       := ' '
		xDescricao  := ' '
		xUF         := ' '
		xMunicipio  := ' '
		xTipoCliente:= ' '
		xCanal      := ' '
		xVendedor   := ' '
		xLiquido    := xLiquido    + (_cAlias1)->LIQUIDO
		xLiquido_AA := xLiquido_AA + (_cAlias1)->LIQUIDO_AA
		xMeta       := xMeta       + (_cAlias1)->META
		xVlrJan_AA  := xVlrJan_AA  + (_cAlias1)->VLRJAN_AA
		xVlrFev_AA  := xVlrFev_AA  + (_cAlias1)->VLRFEV_AA
		xVlrMar_AA  := xVlrMar_AA  + (_cAlias1)->VLRMAR_AA
		xVlrAbr_AA  := xVlrAbr_AA  + (_cAlias1)->VLRABR_AA
		xVlrMai_AA  := xVlrMai_AA  + (_cAlias1)->VLRMAI_AA
		xVlrJun_AA  := xVlrJun_AA  + (_cAlias1)->VLRJUN_AA
		xVlrJul_AA  := xVlrJul_AA  + (_cAlias1)->VLRJUL_AA
		xVlrAgo_AA  := xVlrAgo_AA  + (_cAlias1)->VLRAGO_AA
		xVlrSet_AA  := xVlrSet_AA  + (_cAlias1)->VLRSET_AA
		xVlrOut_AA  := xVlrOut_AA  + (_cAlias1)->VLROUT_AA
		xVlrNov_AA  := xVlrNov_AA  + (_cAlias1)->VLRNOV_AA
		xVlrDez_AA  := xVlrDez_AA  + (_cAlias1)->VLRDEZ_AA
		xVlrJan     := xVlrJan     + (_cAlias1)->VLRJAN
		xVlrFev     := xVlrFev     + (_cAlias1)->VLRFEV
		xVlrMar     := xVlrMar     + (_cAlias1)->VLRMAR
		xVlrAbr     := xVlrAbr     + (_cAlias1)->VLRABR
		xVlrMai     := xVlrMai     + (_cAlias1)->VLRMAI
		xVlrJun     := xVlrJun     + (_cAlias1)->VLRJUN
		xVlrJul     := xVlrJul     + (_cAlias1)->VLRJUL
		xVlrAgo     := xVlrAgo     + (_cAlias1)->VLRAGO
		xVlrSet     := xVlrSet     + (_cAlias1)->VLRSET
		xVlrOut     := xVlrOut     + (_cAlias1)->VLROUT
		xVlrNov     := xVlrNov     + (_cAlias1)->VLRNOV
		xVlrDez     := xVlrDez     + (_cAlias1)->VLRDEZ

		(_cAlias1)->(dbSkip())		
	EndDo

	If xLiquido_AA <> 0
		xPercVlr := xLiquido / xLiquido_AA * 100
	Else
		xPercVlr := 0
	EndIf

	If xMeta <> 0
		xPercMeta := xLiquido / xMeta * 100
	Else
		xPercMeta := 0
	EndIf

	oSection1:Cell("CNPJ"):SetValue(xCNPJ) 
	oSection1:Cell("DESCRICAO"):SetValue(xDescricao)
	oSection1:Cell("UF"):SetValue(xUF)
	oSection1:Cell("MUNICIPIO"):SetValue(xMunicipio)
	oSection1:Cell("TIPOCLIENTE"):SetValue(xTipoCliente)
	oSection1:Cell("CANAL"):SetValue(xCanal)
	oSection1:Cell("VENDEDOR"):SetValue(xVendedor)
	oSection1:Cell("LIQUIDO"):SetValue(xLiquido)
	oSection1:Cell("LIQUIDO_AA"):SetValue(xLiquido_AA)
	oSection1:Cell("PERC_VLR"):SetValue(xPercVlr)
	oSection1:Cell("META"):SetValue(xMETA)
	oSection1:Cell("PERC_META"):SetValue(xPercMeta)
	oSection1:Cell("VLRJAN_AA"):SetValue(xVlrJan_AA)
	oSection1:Cell("VLRFEV_AA"):SetValue(xVlrFev_AA)
	oSection1:Cell("VLRMAR_AA"):SetValue(xVlrMar_AA)
	oSection1:Cell("VLRABR_AA"):SetValue(xVlrAbr_AA)
	oSection1:Cell("VLRMAI_AA"):SetValue(xVlrMai_AA)
	oSection1:Cell("VLRJUN_AA"):SetValue(xVlrJun_AA)
	oSection1:Cell("VLRJUL_AA"):SetValue(xVlrJul_AA)
	oSection1:Cell("VLRAGO_AA"):SetValue(xVlrAgo_AA)
	oSection1:Cell("VLRSET_AA"):SetValue(xVlrSet_AA)
	oSection1:Cell("VLROUT_AA"):SetValue(xVlrOut_AA)
	oSection1:Cell("VLRNOV_AA"):SetValue(xVlrNov_AA)
	oSection1:Cell("VLRDEZ_AA"):SetValue(xVlrDez_AA)
	oSection1:Cell("VLRJAN"):SetValue(xVlrJan)
	If _cMes >= '02'
		oSection1:Cell("VLRFEV"):SetValue(xVlrFev)
	EndIf
	If _cMes >= '03'
		oSection1:Cell("VLRMAR"):SetValue(xVlrMar)
	EndIf
	If _cMes >= '04'
		oSection1:Cell("VLRABR"):SetValue(xVlrAbr)
	EndIf
	If _cMes >= '05'
		oSection1:Cell("VLRMAI"):SetValue(xVlrMai)
	EndIf
	If _cMes >= '06'
		oSection1:Cell("VLRJUN"):SetValue(xVlrJun)
	EndIf
	If _cMes >= '07'
		oSection1:Cell("VLRJUL"):SetValue(xVlrJul)
	EndIf
	If _cMes >= '08'
		oSection1:Cell("VLRAGO"):SetValue(xVlrAgo)
	EndIf
	If _cMes >= '09'
		oSection1:Cell("VLRSET"):SetValue(xVlrSet)
	EndIf
	If _cMes >= '10'
		oSection1:Cell("VLROUT"):SetValue(xVlrOut)
	EndIf
	If _cMes >= '11'
		oSection1:Cell("VLRNOV"):SetValue(xVlrNov)
	EndIf
	If _cMes >= '12'
		oSection1:Cell("VLRDEZ"):SetValue(xVlrDez)
	EndIf
                                                                 
	oSection1:PrintLine()
	         
	oReport:SkipLine()

	(_cAlias1)->(dbGoTop())

	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()

		If (_cAlias1)->LIQUIDO_AA <> 0
			xPercVlr := (_cAlias1)->LIQUIDO / (_cAlias1)->LIQUIDO_AA * 100
		Else
			xPercVlr := 0
		EndIf
	
		If (_cAlias1)->META <> 0
			xPercMeta := (_cAlias1)->LIQUIDO / (_cAlias1)->META * 100
		Else
			xPercMeta := 0
		EndIf

		oSection1:Cell("CNPJ"):SetValue((_cAlias1)->CNPJ) 
		oSection1:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
		oSection1:Cell("UF"):SetValue((_cAlias1)->UF)
		oSection1:Cell("MUNICIPIO"):SetValue((_cAlias1)->MUNICIPIO)
		oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
		oSection1:Cell("CANAL"):SetValue((_cAlias1)->CANAL)
		oSection1:Cell("VENDEDOR"):SetValue((_cAlias1)->VENDEDOR)
		oSection1:Cell("LIQUIDO"):SetValue((_cAlias1)->LIQUIDO)
		oSection1:Cell("LIQUIDO_AA"):SetValue((_cAlias1)->LIQUIDO_AA)
		oSection1:Cell("PERC_VLR"):SetValue(xPercVlr)
		oSection1:Cell("META"):SetValue((_cAlias1)->META)
		oSection1:Cell("PERC_META"):SetValue(xPercMeta)
		oSection1:Cell("VLRJAN_AA"):SetValue((_cAlias1)->VLRJAN_AA)
		oSection1:Cell("VLRFEV_AA"):SetValue((_cAlias1)->VLRFEV_AA)
		oSection1:Cell("VLRMAR_AA"):SetValue((_cAlias1)->VLRMAR_AA)
		oSection1:Cell("VLRABR_AA"):SetValue((_cAlias1)->VLRABR_AA)
		oSection1:Cell("VLRMAI_AA"):SetValue((_cAlias1)->VLRMAI_AA)
		oSection1:Cell("VLRJUN_AA"):SetValue((_cAlias1)->VLRJUN_AA)
		oSection1:Cell("VLRJUL_AA"):SetValue((_cAlias1)->VLRJUL_AA)
		oSection1:Cell("VLRAGO_AA"):SetValue((_cAlias1)->VLRAGO_AA)
		oSection1:Cell("VLRSET_AA"):SetValue((_cAlias1)->VLRSET_AA)
		oSection1:Cell("VLROUT_AA"):SetValue((_cAlias1)->VLROUT_AA)
		oSection1:Cell("VLRNOV_AA"):SetValue((_cAlias1)->VLRNOV_AA)
		oSection1:Cell("VLRDEZ_AA"):SetValue((_cAlias1)->VLRDEZ_AA)
		oSection1:Cell("VLRJAN"):SetValue((_cAlias1)->VLRJAN)
		If _cMes >= '02'
			oSection1:Cell("VLRFEV"):SetValue((_cAlias1)->VLRFEV)
		EndIf
		If _cMes >= '03'
			oSection1:Cell("VLRMAR"):SetValue((_cAlias1)->VLRMAR)
		EndIf
		If _cMes >= '04'
			oSection1:Cell("VLRABR"):SetValue((_cAlias1)->VLRABR)
		EndIf
		If _cMes >= '05'
			oSection1:Cell("VLRMAI"):SetValue((_cAlias1)->VLRMAI)
		EndIf
		If _cMes >= '06'
			oSection1:Cell("VLRJUN"):SetValue((_cAlias1)->VLRJUN)
		EndIf
		If _cMes >= '07'
			oSection1:Cell("VLRJUL"):SetValue((_cAlias1)->VLRJUL)
		EndIf
		If _cMes >= '08'
			oSection1:Cell("VLRAGO"):SetValue((_cAlias1)->VLRAGO)
		EndIf
		If _cMes >= '09'
			oSection1:Cell("VLRSET"):SetValue((_cAlias1)->VLRSET)
		EndIf
		If _cMes >= '10'
			oSection1:Cell("VLROUT"):SetValue((_cAlias1)->VLROUT)
		EndIf
		If _cMes >= '11'
			oSection1:Cell("VLRNOV"):SetValue((_cAlias1)->VLRNOV)
		EndIf
		If _cMes >= '12'
			oSection1:Cell("VLRDEZ"):SetValue((_cAlias1)->VLRDEZ)
		EndIf
	
		oSection1:PrintLine()
	
		(_cAlias1)->(dbSkip())		
	EndDo
	oSection1:Finish()
	         
	DbSelectArea(_cAlias1)
	DbCloseArea()
Endif
	
Return(.t.)
