#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: FEC080N

DESCRICAO: FEC080 - FECHAMENTO ANUAL -  VENDAS ANUAIS EM QUANTIDADES

ALTERACOES:
12/01/2016 - Desenvolvimento do fonte

/*/

User Function FEC080

Local oReport
Local cPerg := "FEC080"

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
12/01/2016 - Helimar Tavares - Criacao do fonte
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
cCpoPer := "B1_PROC"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Fornecedor ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA2_B"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serão consideradas todas as   ")
AADD(aHelpPor,"opções.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "vazio() .or. existcpo('SA2')", cF3Perg, "", "", cMVPAR, cOpc1,"","","", cOpc2,"","","","","","","","","","","", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH, "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
12/11/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If MV_PAR02 = '0380795'
	_cSigla := 'EGK'
Elseif MV_PAR02 = '0380796'
	_cSigla := 'LTC'
Elseif MV_PAR02 = '0380794'
	_cSigla := 'FOR'
Elseif MV_PAR02 = '031811 '
	_cSigla := 'ACF'
Elseif MV_PAR02 = '0378128'
	_cSigla := 'ATL'
Else
	_cSigla := 'GEN'
End If

//Declaracao do relatorio
oReport := TReport():New("FEC080","FEC080 - Fechamento Mensal - "+_cSigla+"     Ranking das Vendas por Cliente   "+DTOC(MV_PAR01),cPerg,{|oReport| PrintReport(oReport)},"FEC080 - Fechamento Mensal - Ranking das Vendas por Cliente",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 6    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"FEC080 - Fechamento Mensal - "+_cSigla+"     Ranking das Vendas por Cliente   "+DTOC(MV_PAR01),"")
	
//Celulas da secao
TRCell():New(oSection1,"ESTADO"		,"","UF",,5)
TRCell():New(oSection1,"CGC"		,"","CNPJ/CPF",,18) 
TRCell():New(oSection1,"CODIGO"		,"","CÓDIGO",,7) 
TRCell():New(oSection1,"LOJA"		,"","LOJA",,4) 
TRCell():New(oSection1,"DESCRICAO"	,"","DESCRIÇÃO",,20)
TRCell():New(oSection1,"ACUANO"		,"","TOTAL"		,,18,,,,,"RIGHT")
TRCell():New(oSection1,"ACUANOANT"	,"","TOTAL A.A.",,18,,,,,"RIGHT")
TRCell():New(oSection1,"PERC"		,"","% A.A"		,,12,,,,,"RIGHT")
TRCell():New(oSection1,"RANK"		,"","RANK"		,,12,,,,,"RIGHT")
TRCell():New(oSection1,"RANKACUM"	,"","R.ACU"		,,12,,,,,"RIGHT") 
TRCell():New(oSection1,"VLRJAN"		,"","JAN",,18)
TRCell():New(oSection1,"VLRFEV"		,"","FEV",,18)
TRCell():New(oSection1,"VLRMAR"		,"","MAR",,18)
TRCell():New(oSection1,"VLRABR"		,"","ABR",,18)
TRCell():New(oSection1,"VLRMAI"		,"","MAI",,18)
TRCell():New(oSection1,"VLRJUN"		,"","JUN",,18)
TRCell():New(oSection1,"VLRJUL"		,"","JUL",,18)
TRCell():New(oSection1,"VLRAGO"		,"","AGO",,18)
TRCell():New(oSection1,"VLRSET"		,"","SET",,18)
TRCell():New(oSection1,"VLROUT"		,"","OUT",,18)
TRCell():New(oSection1,"VLRNOV"		,"","NOV",,18)
TRCell():New(oSection1,"VLRDEZ"		,"","DEZ",,18)

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
12/01/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""
Local lPlanilha := oReport:nDevice == 4
Local aResult   := {}

If oReport:NDEVICE <> 4
	MsgInfo("Este relatório somente poderá ser impresso em Excel.")
	Return(.t.)
Endif
 
_cParm1 := DTOS(MV_PAR01)
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)
xTotAcum:= 0

//aResult := tcSPExec("DBA_EGK.VENDAMESOBRA_INSERT", MV_PAR01)

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery := "SELECT ' ' ESTADO, ' ' CGC, ' ' CODIGO, ' ' LOJA, ' ' DESCRICAO, SUM(ACUANO) ACUANO, SUM(ACUANOANT) ACUANOANT, ' ' PERC, ' ' RANK, ' ' RANKACUM,
	_cQuery += "       SUM(VLRJAN) VLRJAN, SUM(VLRFEV) VLRFEV, SUM(VLRMAR) VLRMAR, SUM(VLRABR) VLRABR, SUM(VLRMAI) VLRMAI, SUM(VLRJUN) VLRJUN,
	_cQuery += "       SUM(VLRJUL) VLRJUL, SUM(VLRAGO) VLRAGO, SUM(VLRSET) VLRSET, SUM(VLROUT) VLROUT, SUM(VLRNOV) VLRNOV, SUM(VLRDEZ) VLRDEZ
	_cQuery += "  FROM (SELECT SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                               			           '02', VLRJAN+VLRFEV,
	_cQuery += "                                                                   '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                                   '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                                   '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                                   '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                                   '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                                   '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                                   '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                                   '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                                   '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                                   '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) ACUANO,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                               			              '02', VLRJAN+VLRFEV,
	_cQuery += "                                                                      '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                                      '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                                      '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                                      '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                                      '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                                      '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                                      '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                                      '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                                      '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                                      '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) ACUANOANT,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', VLRJAN, 0)) VLRJAN,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN VLRFEV ELSE 0 END, 0)) VLRFEV,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN VLRMAR ELSE 0 END, 0)) VLRMAR,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN VLRABR ELSE 0 END, 0)) VLRABR,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN VLRMAI ELSE 0 END, 0)) VLRMAI,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN VLRJUN ELSE 0 END, 0)) VLRJUN,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN VLRJUL ELSE 0 END, 0)) VLRJUL,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN VLRAGO ELSE 0 END, 0)) VLRAGO,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN VLRSET ELSE 0 END, 0)) VLRSET,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN VLROUT ELSE 0 END, 0)) VLROUT,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN VLRNOV ELSE 0 END, 0)) VLRNOV,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN VLRDEZ ELSE 0 END, 0)) VLRDEZ,
	_cQuery += "               A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) CGC
	_cQuery += "          FROM DBA_EGK.VENDAMESCLIENTE_FEC
	_cQuery += "         WHERE ANO >= '"+ _cAnoAnt+"'
	If !Empty(MV_PAR02)
		_cQuery += "           AND B1_PROC = '"+MV_PAR02+"'
	Endif 
	_cQuery += "         GROUP BY A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC)) VMC
	_cQuery += "  LEFT JOIN (SELECT DISTINCT A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) A1_CGC, A1_NOME, A1_EST
	_cQuery += "               FROM SA1000
	_cQuery += "              WHERE A1_FILIAL = '" + xFilial("SA1") + "'"
	_cQuery += "                AND D_E_L_E_T_ = ' ') SA1
	_cQuery += "    ON VMC.A1_COD = SA1.A1_COD
	_cQuery += "   AND VMC.A1_LOJA = SA1.A1_LOJA
	_cQuery += "  LEFT JOIN (SELECT DISTINCT A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) A1_CGC, A1_NOME, A1_EST
	_cQuery += "               FROM APP_ATLAS.CLIENTES) CA
	_cQuery += "    ON VMC.CGC = CA.A1_CGC
	
	If Select(_cAlias1) > 0
		dbSelectArea(_cAlias1)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
	
	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
		oSection1:Init()  
	                                      
        xPerc := (_cAlias1)->ACUANO / (_cAlias1)->ACUANOANT * 100
        
		oSection1:Cell("ESTADO"):SetValue((_cAlias1)->ESTADO)
		oSection1:Cell("CGC"):SetValue((_cAlias1)->CGC)
		oSection1:Cell("CODIGO"):SetValue((_cAlias1)->CODIGO)
		oSection1:Cell("LOJA"):SetValue((_cAlias1)->LOJA)
		oSection1:Cell("DESCRICAO"):SetValue((_cAlias1)->DESCRICAO)
		//oSection1:Cell("ACUANO"):SetValue((_cAlias1)->ACUANO)
		oSection1:Cell("ACUANO"):SetValue("R$ " + Transform((_cAlias1)->ACUANO, "@E 999,999,999.99"))
		oSection1:Cell("ACUANOANT"):SetValue("R$ " + Transform((_cAlias1)->ACUANOANT, "@E 999,999,999.99"))
		oSection1:Cell("PERC"):SetValue(Transform(xPerc,"@E 9,999.99") + " %")
		oSection1:Cell("RANK"):SetValue((_cAlias1)->RANK) 
		oSection1:Cell("RANKACUM"):SetValue((_cAlias1)->RANKACUM)
		oSection1:Cell("VLRJAN"):SetValue("R$ " + Transform((_cAlias1)->VLRJAN, "@E 999,999,999.99"))
		oSection1:Cell("VLRFEV"):SetValue("R$ " + Transform((_cAlias1)->VLRFEV, "@E 999,999,999.99"))
		oSection1:Cell("VLRMAR"):SetValue("R$ " + Transform((_cAlias1)->VLRMAR, "@E 999,999,999.99"))
		oSection1:Cell("VLRABR"):SetValue("R$ " + Transform((_cAlias1)->VLRABR, "@E 999,999,999.99"))
		oSection1:Cell("VLRMAI"):SetValue("R$ " + Transform((_cAlias1)->VLRMAI, "@E 999,999,999.99"))
		oSection1:Cell("VLRJUN"):SetValue("R$ " + Transform((_cAlias1)->VLRJUN, "@E 999,999,999.99"))
		oSection1:Cell("VLRJUL"):SetValue("R$ " + Transform((_cAlias1)->VLRJUL, "@E 999,999,999.99"))
		oSection1:Cell("VLRAGO"):SetValue("R$ " + Transform((_cAlias1)->VLRAGO, "@E 999,999,999.99"))
		oSection1:Cell("VLRSET"):SetValue("R$ " + Transform((_cAlias1)->VLRSET, "@E 999,999,999.99"))
		oSection1:Cell("VLROUT"):SetValue("R$ " + Transform((_cAlias1)->VLROUT, "@E 999,999,999.99"))
		oSection1:Cell("VLRNOV"):SetValue("R$ " + Transform((_cAlias1)->VLRNOV, "@E 999,999,999.99"))
		oSection1:Cell("VLRDEZ"):SetValue("R$ " + Transform((_cAlias1)->VLRDEZ, "@E 999,999,999.99"))
	
		oSection1:PrintLine()
	
		(_cAlias1)->(dbSkip())		
	EndDo
	         
	oReport:SkipLine()
	
	_cQuery	:= ""
	
	_cQuery := "SELECT DECODE(SA1.A1_EST, NULL, CA.A1_EST, SA1.A1_EST) ESTADO, VMC.CGC CGC,
	_cQuery += "       DECODE(SA1.A1_COD, NULL, CA.A1_COD, SA1.A1_COD) CODIGO,
	_cQuery += "       DECODE(SA1.A1_LOJA, NULL, CA.A1_LOJA, SA1.A1_LOJA) LOJA,
	_cQuery += "       DECODE(SA1.A1_NOME, NULL, CA.A1_NOME, SA1.A1_NOME) DESCRICAO,
	_cQuery += "       VMC.ACUANO, VMC.ACUANOANT, SUM(VMC.ACUANO) OVER() TOTALANO,
	_cQuery += "       VMC.VLRJAN, VMC.VLRFEV, VMC.VLRMAR, VMC.VLRABR, VMC.VLRMAI, VMC.VLRJUN,
	_cQuery += "       VMC.VLRJUL, VMC.VLRAGO, VMC.VLRSET, VMC.VLROUT, VMC.VLRNOV, VMC.VLRDEZ	
	_cQuery += "  FROM (SELECT SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                               			           '02', VLRJAN+VLRFEV,
	_cQuery += "                                                                   '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                                   '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                                   '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                                   '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                                   '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                                   '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                                   '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                                   '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                                   '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                                   '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) ACUANO,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                                      '02', VLRJAN+VLRFEV,
	_cQuery += "                                                                      '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                                      '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                                      '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                                      '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                                      '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                                      '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                                      '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                                      '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                                      '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                                      '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ), 0)) ACUANOANT,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', VLRJAN, 0)) VLRJAN,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 2 THEN VLRFEV ELSE 0 END, 0)) VLRFEV,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 3 THEN VLRMAR ELSE 0 END, 0)) VLRMAR,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 4 THEN VLRABR ELSE 0 END, 0)) VLRABR,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 5 THEN VLRMAI ELSE 0 END, 0)) VLRMAI,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 6 THEN VLRJUN ELSE 0 END, 0)) VLRJUN,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 7 THEN VLRJUL ELSE 0 END, 0)) VLRJUL,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 8 THEN VLRAGO ELSE 0 END, 0)) VLRAGO,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 9 THEN VLRSET ELSE 0 END, 0)) VLRSET,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 10 THEN VLROUT ELSE 0 END, 0)) VLROUT,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 11 THEN VLRNOV ELSE 0 END, 0)) VLRNOV,
	_cQuery += "               SUM(DECODE(ANO, '"+ _cAno+"', CASE WHEN "+ _cMes +" >= 12 THEN VLRDEZ ELSE 0 END, 0)) VLRDEZ,
	_cQuery += "               A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) CGC
	_cQuery += "          FROM DBA_EGK.VENDAMESCLIENTE_FEC
	_cQuery += "         WHERE ANO >= '"+ _cAnoAnt+"'
	If !Empty(MV_PAR02)
		_cQuery += "           AND B1_PROC = '"+MV_PAR02+"'
	Endif 
	_cQuery += "         GROUP BY A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC)) VMC
	_cQuery += "  LEFT JOIN (SELECT DISTINCT A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) A1_CGC, A1_NOME, A1_EST
	_cQuery += "               FROM SA1000
	_cQuery += "              WHERE A1_FILIAL = '" + xFilial("SA1") + "'"
	_cQuery += "                AND D_E_L_E_T_ = ' ') SA1
	_cQuery += "    ON VMC.A1_COD = SA1.A1_COD
	_cQuery += "   AND VMC.A1_LOJA = SA1.A1_LOJA
	_cQuery += "  LEFT JOIN (SELECT DISTINCT A1_COD, A1_LOJA, DECODE(TRIM(A1_CGC), NULL, A1_COD||A1_LOJA, A1_CGC) A1_CGC, A1_NOME, A1_EST
	_cQuery += "               FROM APP_ATLAS.CLIENTES) CA
	_cQuery += "    ON VMC.CGC = CA.A1_CGC
	_cQuery += " WHERE VMC.ACUANO <> 0
	_cQuery += "    OR VMC.ACUANOANT <> 0
	_cQuery += " ORDER BY VMC.ACUANO DESC, VMC.ACUANOANT DESC
	
	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)
	
	Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
		oReport:IncMeter()
	
        xTotAcum  := xTotAcum + (_cAlias2)->ACUANO
		xRank 	  := (_cAlias2)->ACUANO / (_cAlias2)->TOTALANO * 100
		xRankAcum := xTotAcum / (_cAlias2)->TOTALANO * 100          
		xCGC      := ' '
        if length(trim((_cAlias2)->CGC)) = 14                       
        	xCGC := Transform((_cAlias2)->CGC, "@R 99.999.999/9999-99")
        elseif length(trim((_cAlias2)->CGC)) = 11
        	xCGC := Transform((_cAlias2)->CGC, "@R 999.999.999-99")
        end if
		if (_cAlias2)->ACUANOANT <> 0
			xPerc := (_cAlias2)->ACUANO / (_cAlias2)->ACUANOANT * 100			
		else
			xPerc := 0
		end if
		oSection1:Cell("ESTADO"):SetValue((_cAlias2)->ESTADO)
		oSection1:Cell("CGC"):SetValue(xCGC)
		oSection1:Cell("CODIGO"):SetValue((_cAlias2)->CODIGO)
		oSection1:Cell("LOJA"):SetValue((_cAlias2)->LOJA)
		oSection1:Cell("DESCRICAO"):SetValue((_cAlias2)->DESCRICAO)
		oSection1:Cell("ACUANO"):SetValue("R$ " + Transform((_cAlias2)->ACUANO, "@E 999,999,999.99"))
		oSection1:Cell("ACUANOANT"):SetValue("R$ " + Transform((_cAlias2)->ACUANOANT, "@E 999,999,999.99"))
		oSection1:Cell("PERC"):SetValue(Transform(xPerc,"@E 9,999.99") + " %")
		oSection1:Cell("RANK"):SetValue(Transform(xRank,"@E 9,999.99") + " %") 
		oSection1:Cell("RANKACUM"):SetValue(Transform(xRankAcum,"@E 9,999.99") + " %")
		oSection1:Cell("VLRJAN"):SetValue("R$ " + Transform((_cAlias2)->VLRJAN, "@E 999,999,999.99"))
		oSection1:Cell("VLRFEV"):SetValue("R$ " + Transform((_cAlias2)->VLRFEV, "@E 999,999,999.99"))
		oSection1:Cell("VLRMAR"):SetValue("R$ " + Transform((_cAlias2)->VLRMAR, "@E 999,999,999.99"))
		oSection1:Cell("VLRABR"):SetValue("R$ " + Transform((_cAlias2)->VLRABR, "@E 999,999,999.99"))
		oSection1:Cell("VLRMAI"):SetValue("R$ " + Transform((_cAlias2)->VLRMAI, "@E 999,999,999.99"))
		oSection1:Cell("VLRJUN"):SetValue("R$ " + Transform((_cAlias2)->VLRJUN, "@E 999,999,999.99"))
		oSection1:Cell("VLRJUL"):SetValue("R$ " + Transform((_cAlias2)->VLRJUL, "@E 999,999,999.99"))
		oSection1:Cell("VLRAGO"):SetValue("R$ " + Transform((_cAlias2)->VLRAGO, "@E 999,999,999.99"))
		oSection1:Cell("VLRSET"):SetValue("R$ " + Transform((_cAlias2)->VLRSET, "@E 999,999,999.99"))
		oSection1:Cell("VLROUT"):SetValue("R$ " + Transform((_cAlias2)->VLROUT, "@E 999,999,999.99"))
		oSection1:Cell("VLRNOV"):SetValue("R$ " + Transform((_cAlias2)->VLRNOV, "@E 999,999,999.99"))
		oSection1:Cell("VLRDEZ"):SetValue("R$ " + Transform((_cAlias2)->VLRDEZ, "@E 999,999,999.99"))

		oSection1:PrintLine()
	
		(_cAlias2)->(dbSkip())		
	EndDo
	oSection1:Finish()
	         
	DbSelectArea(_cAlias2)
	DbSelectArea(_cAlias1)
	DbCloseArea()
Endif
	
Return(.t.)
