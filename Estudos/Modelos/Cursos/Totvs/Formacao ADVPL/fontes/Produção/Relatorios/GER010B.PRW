#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER010B

DESCRICAO: RANKING DE PRODUTO POR CLIENTE

ALTERACOES:
28/03/2016 - Desenvolvimento do fonte

/*/

User Function GER010B

Local oReport
Local cPerg := "GER10B"

//Cria grupo de perguntas
//f001(cPerg) 

//Carrega grupo de perguntas
_lTela := .t.	
//While _lTela 

If Pergunte(cPerg,.T.)
   If (!Empty(MV_PAR02) .And. !Empty(MV_PAR04+MV_PAR05)) .Or. (!Empty(MV_PAR02) .And. !Empty(MV_PAR03)) .Or. (!Empty(MV_PAR03) .And. !Empty(MV_PAR04+MV_PAR05))
		MsgStop("Somente um parâmetro de cliente pode ser preenchido.")
//		ElseIf (Empty(MV_PAR02) .And. MV_PAR03 == 1) .Or. (!Empty(MV_PAR04+MV_PAR05) .And. MV_PAR03 == 1)
//			MsgStop("Conceito Grupo somente para clientes com CNPJ/CPF.")
    ElseIf Empty(MV_PAR02) .And. Empty(MV_PAR04+MV_PAR05) .And. Empty(MV_PAR03)
		MsgStop("É necessário escolher um parâmetro de cliente.")
	Else
		_lTela := .f.		    
		oReport := ReportDef(cPerg)
		oReport:PrintDialog()
	EndIf
Else
	_lTela := .f.	
EndIf
//End

Return

/*
Funcao: f001

Descricao: Cria grupo de perguntas

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
*/
Static Function f001(cPerg)

PutSx1(cPerg, "01", "Data (mês fechado)","Data (mês fechado)"	,"Data (mês fechado)"	, "mv_ch1"	, "D", 8, 0, 0, "G","", ""		, "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "CNPJ/CPF:"			,"CNPJ/CPF:"	  		,"CNPJ/CPF:"			, "mv_ch2"	, "C",90, 0, 0, "G","", "SA1_B"	, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Grupo:"			,"Grupo:"				,"Grupo:"				, "mv_ch3"	, "C", 6, 0, 0, "C","", "ACY"	, "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Cliente:"			,"Cliente:"		  		,"Cliente:"				, "mv_ch4"	, "C", 7, 0, 0, "C","", "SA1"	, "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "Loja:"				,"Loja:"		  		,"Loja:"				, "mv_ch5"	, "C", 2, 0, 0, "G","", ""		, "", "", "MV_PAR05","","","","","","","","","","","","","","","","")

Return()
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
------------------------------------------------------------------------------------------------
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

_cAno    := YEAR2STR(MV_PAR01)
_cAnoAnt := YEAR2STR(YEAR(MV_PAR01) - 1)
_cDataFim:= DTOC(LASTDATE(MV_PAR01))
_xMes    := SUBSTR(MESEXTENSO(MONTHSUM(MV_PAR01,1)),1,3)

//Declaracao do relatorio
oReport := TReport():New("GER010B","GER010B - Ranking de Produto por Cliente - 01/01/"+_cAno+" a "+_cDataFim,cPerg,{|oReport| PrintReport(oReport)},"GER010B - Ranking de Produto por Cliente - 01/01/"+_cAno+" a "+_cDataFim,.T.)

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
If !Empty(MV_PAR03)
	TRCell():New(oSection1,"A1_GRPVEN"	,"","Grupo"			,,8)
Else
	TRCell():New(oSection1,"A1_COD"		,"","Código"		,,8)
	TRCell():New(oSection1,"A1_LOJA"	,"","Loja"	   		,,4)
	TRCell():New(oSection1,"A1_CGC"		,"","Raiz CNPJ"		,,18)
EndIf
TRCell():New(oSection1,"A1_NOME"	,"","Descrição"		,,50)
TRCell():New(oSection1,"A1_EST"		,"","UF"	   		,,4)
TRCell():New(oSection1,"A1_MUN"		,"","Município"		,,20)
TRCell():New(oSection1,"TIPOCLIENTE","","Tipo Cliente"	,,20)
TRCell():New(oSection1,"CANALVENDA"	,"","Canal"			,,20)
TRCell():New(oSection1,"VENDEDOR"	,"","Vendedor"		,,20)

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produtos","")

TRCell():New(oSection2,"B1_COD"			,"","Código"			,,8)
TRCell():New(oSection2,"B1_ISBN"		,"","ISBN"				,,13)
TRCell():New(oSection2,"B1_DESC"		,"","Descrição"			,,40)
TRCell():New(oSection2,"AREA"			,"","Área"				,,13)
TRCell():New(oSection2,"CURSO"			,"","Curso"				,,13)
TRCell():New(oSection2,"DISCIPLINA"		,"","Disciplina"		,,13)
TRCell():New(oSection2,"SELO"			,"","Selo"				,,8)
TRCell():New(oSection2,"DATAPUBLICACAO"	,"","Data Publicação"	,,10)
TRCell():New(oSection2,"TIPOPUBLICACAO"	,"","Tipo Publicação"	,,15)
TRCell():New(oSection2,"SITUACAOOBRA"	,"","Situação"			,,15) 
TRCell():New(oSection2,"VLRACU"			,"",_cAno+" YTD R$"	  	,"@E 999,999,999.99",15,,,,,"RIGHT")
TRCell():New(oSection2,"QTDACU"			,"",_cAno+" YTD"	  	,"@E 999,999,999",8,,,,,"RIGHT")
TRCell():New(oSection2,"QTDACUAA"		,"",_cAnoAnt+" YTD"	  	,"@E 999,999,999",8,,,,,"RIGHT")
TRCell():New(oSection2,"DIFQTD"			,"","Diferença"		  	,"@E 999,999,999",8,,,,,"RIGHT")
TRCell():New(oSection2,"QTDAAMS"		,"",_xMes+" "+_cAnoAnt	,"@E 999,999,999",8,,,,,"RIGHT")
TRCell():New(oSection2,"PARETO"			,"","Pareto"			,,6) 

  
//Totalizadores
TRFunction():New(oSection2:Cell("VLRACU")	,NIL,"SUM")
TRFunction():New(oSection2:Cell("QTDACU")	,NIL,"SUM")
TRFunction():New(oSection2:Cell("QTDACUAA")	,NIL,"SUM")
TRFunction():New(oSection2:Cell("DIFQTD")	,NIL,"SUM")
TRFunction():New(oSection2:Cell("QTDAAMS")	,NIL,"SUM")

//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local _cAlias	:= GetNextAlias()
Local _cQuery	:= ""
Local xCGC      := ""
Local lPlanilha := oReport:nDevice == 4

Local  _cCliente := MntStrPsq(MV_PAR02)
 
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	_cQuery := "SELECT F.A1_COD, F.A1_LOJA, F.A1_GRPVEN,
	_cQuery += "       DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL) A1_CGC,
	_cQuery += "       TRIM(DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI)) A1_NOME,
	_cQuery += "       SA1.A1_EST, TRIM(SA1.MUNICIPIO) A1_MUN, TRIM(SA1.TIPOCLIENTE) TIPOCLIENTE, 
	_cQuery += "       TRIM(SA1.CANALVENDA) CANALVENDA, TRIM(SA1.VENDEDOR) VENDEDOR,
	_cQuery += "       DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, F.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD,
	_cQuery += "       SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, TRIM(SZ7.Z7_DESC) AREA, TRIM(XZ5.X5_DESCRI) SITUACAOOBRA,
	_cQuery += "       TRIM(XZ1.X5_DESCRI) SELO, TRIM(SB5.B5_XDTPUBL) DATAPUBLICACAO, TRIM(XZ4.X5_DESCRI) TIPOPUBLICACAO, 
	_cQuery += "       F.LIQUIDO VLRACU, F.QTDE QTDACU, F.QTDEAA QTDACUAA, F.QTDE-F.QTDEAA DIFQTD, F.QTDAAMS, P.PERCACUM,
	_cQuery += "       CASE WHEN NVL(P.PERCACUM,100) > 80 THEN 'N' ELSE 'S' END PARETO,TRIM(SZ5.Z5_DESC) CURSO,	TRIM(SZ6.Z6_DESC) DISCIPLINA
	_cQuery += "  FROM (SELECT CASE WHEN A1_GRPVEN <> '      ' 
	_cQuery += "                    THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
	_cQuery += "                    ELSE A1_COD END A1_COD,
	_cQuery += "               CASE WHEN A1_GRPVEN <> '      ' 
	_cQuery += "                    THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
	_cQuery += "                    ELSE A1_LOJA END A1_LOJA,
	_cQuery += "               B5_XCODHIS, A1_GRPVEN, A1_XCANALV, LIQUIDO, LIQUIDOAA, QTDE, QTDEAA, QTDAAMS
	_cQuery += "          FROM (SELECT VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
	_cQuery += "                       SUM(DECODE(ANO, "+ _cAno+", DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                            '02', VLRJAN+VLRFEV,
	_cQuery += "                                                            '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                            '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                            '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                            '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                            '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                            '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                            '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                            '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                            '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                            '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO,
	_cQuery += "                       SUM(DECODE(ANO, "+ _cAnoAnt+", DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                            '02', VLRJAN+VLRFEV,
	_cQuery += "                                                            '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                            '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                            '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                            '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                            '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                            '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                            '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                            '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                            '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                            '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDOAA,
	_cQuery += "                       SUM(DECODE(ANO, "+ _cAno+", DECODE('"+ _cMes+"', '01', QTDJAN,
	_cQuery += "                                                            '02', QTDJAN+QTDFEV,
	_cQuery += "                                                            '03', QTDJAN+QTDFEV+QTDMAR,
	_cQuery += "                                                            '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
	_cQuery += "                                                            '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
	_cQuery += "                                                            '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
	_cQuery += "                                                            '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
	_cQuery += "                                                            '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
	_cQuery += "                                                            '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
	_cQuery += "                                                            '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
	_cQuery += "                                                            '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
	_cQuery += "                                                            '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDE,
	_cQuery += "                       SUM(DECODE(ANO, "+ _cAnoAnt+", DECODE('"+ _cMes+"', '01', QTDJAN,
	_cQuery += "                                                            '02', QTDJAN+QTDFEV,
	_cQuery += "                                                            '03', QTDJAN+QTDFEV+QTDMAR,
	_cQuery += "                                                            '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
	_cQuery += "                                                            '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
	_cQuery += "                                                            '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
	_cQuery += "                                                            '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
	_cQuery += "                                                            '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
	_cQuery += "                                                            '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
	_cQuery += "                                                            '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
	_cQuery += "                                                            '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
	_cQuery += "                                                            '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDEAA,
	_cQuery += "                       SUM(DECODE(ANO, "+ _cAnoAnt+", DECODE('"+ _cMes+"', '01', QTDFEV, '02', QTDMAR, '03', QTDABR, '04', QTDMAI, '05', QTDJUN, '06', QTDJUL,
	_cQuery += "	                                                          '07', QTDAGO, '08', QTDSET, '09', QTDOUT, '10', QTDNOV, '11', QTDDEZ, 0),
	_cQuery += "                                       "+ _cAno+", DECODE('"+ _cMes+"', '12', QTDJAN, 0), 0)) QTDAAMS
	_cQuery += "                  FROM GER_VENDAMESCLIENTE_OBRA VMCO
	_cQuery += "                  JOIN " + RetSqlName("SA1") + " SA1
	_cQuery += "                    ON SA1.A1_COD = VMCO.A1_COD
	_cQuery += "                   AND SA1.A1_LOJA = VMCO.A1_LOJA
	_cQuery += "                   AND SA1.D_E_L_E_T_ = ' '
	_cQuery += "                 WHERE VMCO.ANO >=  "+ _cAnoAnt
	If !Empty(MV_PAR02)
		_cQuery += "                   AND SA1.A1_CGC IN ("+_cCliente+")
	EndIf
	If !Empty(MV_PAR03)
		_cQuery += "                   AND SA1.A1_GRPVEN = '"+MV_PAR03+"'"
	EndIf
	If !Empty(MV_PAR04)
		_cQuery += "                   AND VMCO.A1_COD  = '"+MV_PAR04+"'"
		_cQuery += "                   AND VMCO.A1_LOJA = '"+MV_PAR05+"'"
	EndIf
	_cQuery += "                 GROUP BY VMCO.B1_COD, VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV)
	_cQuery += "         ORDER BY A1_COD, A1_LOJA, LIQUIDO DESC) F 
	_cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY
	_cQuery += "    ON ACY.ACY_GRPVEN = F.A1_GRPVEN
	_cQuery += "   AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'
	_cQuery += "   AND ACY.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN (SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_EST, CC2.CC2_MUN AS MUNICIPIO,
	_cQuery += "                    STP.X5_DESCRI AS TIPOCLIENTE, SZ2.X5_DESCRI AS CANALVENDA, SA3.A3_NOME AS VENDEDOR
	_cQuery += "               FROM " + RetSqlName("SA1") + " SA1
	_cQuery += "               LEFT JOIN " + RetSqlName("CC2") + " CC2
	_cQuery += "                 ON SA1.A1_EST = CC2.CC2_EST
	_cQuery += "                AND SA1.A1_COD_MUN = CC2.CC2_CODMUN
	_cQuery += "                AND CC2.CC2_FILIAL = '" + xFilial("CC2") + "'
	_cQuery += "                AND CC2.D_E_L_E_T_ = ' '
	_cQuery += "               LEFT JOIN " + RetSqlName("SX5") + " STP
	_cQuery += "                 ON SA1.A1_XTIPCLI = STP.X5_CHAVE
	_cQuery += "                AND STP.X5_TABELA = 'TP'
	_cQuery += "                AND STP.X5_FILIAL = '" + xFilial("SX5") + "'
	_cQuery += "                AND STP.D_E_L_E_T_ = ' '
	_cQuery += "               LEFT JOIN " + RetSqlName("SX5") + " SZ2
	_cQuery += "                 ON SA1.A1_XCANALV = SZ2.X5_CHAVE
	_cQuery += "                AND SZ2.X5_TABELA = 'Z2'
	_cQuery += "                AND SZ2.X5_FILIAL = '" + xFilial("SX5") + "'
	_cQuery += "                AND SZ2.D_E_L_E_T_ = ' '
	_cQuery += "               LEFT JOIN " + RetSqlName("SA3") + " SA3
	_cQuery += "                 ON SA1.A1_VEND = SA3.A3_COD
	_cQuery += "                AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'
	_cQuery += "                AND SA3.D_E_L_E_T_ = ' '
	_cQuery += "              WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "'
	_cQuery += "                AND SA1.D_E_L_E_T_ = ' ') SA1
	_cQuery += "    ON F.A1_COD = SA1.A1_COD
	_cQuery += "   AND F.A1_LOJA = SA1.A1_LOJA
	_cQuery += "  LEFT JOIN (SELECT SB5.B5_COD, SB5.B5_XCODHIS
	_cQuery += "               FROM " + RetSqlName("SB5") + " SB5, 
	_cQuery += "                    (SELECT B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
	_cQuery += "                       FROM " + RetSqlName("SB5")
	_cQuery += "                      WHERE TRIM(B5_XFEC) = '1'
	_cQuery += "                        AND D_E_L_E_T_ = ' '
	_cQuery += "                      GROUP BY B5_XCODHIS) M
	_cQuery += "              WHERE SB5.B5_XCODHIS = M.B5_XCODHIS
	_cQuery += "                AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
	_cQuery += "                AND TRIM(SB5.B5_XFEC) = '1'
	_cQuery += "                AND SB5.D_E_L_E_T_ = ' ') FEC
	_cQuery += "    ON F.B5_XCODHIS = FEC.B5_XCODHIS
	_cQuery += "  LEFT JOIN (SELECT SB5.B5_COD, SB5.B5_XCODHIS
	_cQuery += "               FROM " + RetSqlName("SB5") + " SB5, 
	_cQuery += "                    (SELECT B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
	_cQuery += "                       FROM " + RetSqlName("SB5")
	_cQuery += "                      WHERE D_E_L_E_T_ = ' '
	_cQuery += "                      GROUP BY B5_XCODHIS) M
	_cQuery += "              WHERE SB5.B5_XCODHIS = M.B5_XCODHIS
	_cQuery += "                AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
	_cQuery += "                AND TRIM(SB5.B5_XFEC) <> '1'
	_cQuery += "                AND SB5.D_E_L_E_T_ = ' ') SFEC
	_cQuery += "    ON F.B5_XCODHIS = SFEC.B5_XCODHIS
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1
	_cQuery += "    ON DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, F.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) = SB1.B1_COD
    _cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
	_cQuery += " INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
    _cQuery += "   AND SB5.B5_FILIAL  = '" + xFilial("SB1") + "'"
	_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SZ7") + " WHERE Z7_FILIAL = '" + xFilial("SZ7") + "' AND D_E_L_E_T_ = ' ') SZ7
	_cQuery += "    ON B5_XAREA = SZ7.Z7_AREA 
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SZ6") + " WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND D_E_L_E_T_ = ' ') SZ6
	_cQuery += "    ON SB5.B5_XDISCIP = SZ6.Z6_DISCIPL
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SZ5") + " WHERE Z5_FILIAL = '" + xFilial("SZ5") + "' AND D_E_L_E_T_ = ' ') SZ5
	_cQuery += "    ON SB5.B5_XCURSO = SZ5.Z5_CURSO
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SX5") + " WHERE X5_TABELA = 'Z5' AND X5_FILIAL = '" + xFilial("SX5") + "' AND D_E_L_E_T_ = ' ') XZ5
	_cQuery += "    ON SB1.B1_XSITOBR = XZ5.X5_CHAVE
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SX5") + " WHERE X5_TABELA = 'Z1' AND X5_FILIAL = '" + xFilial("SX5") + "' AND D_E_L_E_T_ = ' ') XZ1
	_cQuery += "    ON SB5.B5_XSELO = XZ1.X5_CHAVE
	_cQuery += "  LEFT JOIN (SELECT * FROM " + RetSqlName("SX5") + " WHERE X5_TABELA = 'Z4' AND X5_FILIAL = '" + xFilial("SX5") + "' AND D_E_L_E_T_ = ' ') XZ4
	_cQuery += "    ON SB1.B1_XIDTPPU = XZ4.X5_CHAVE
	_cQuery += "  LEFT JOIN (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, VALOR, SUM(VALOR) OVER(ORDER BY VALOR DESC) VALORACUM, SUM(VALOR) OVER() VALORTOT,
	_cQuery += "                    ROUND(SUM(VALOR) OVER(ORDER BY VALOR DESC)/SUM(VALOR) OVER()*100,2) PERCACUM
	_cQuery += "               FROM (SELECT B5_XCODHIS, SUM(DECODE('"+ _cMes+"', '01', VLRJAN,
	_cQuery += "                                                              '02', VLRJAN+VLRFEV,
	_cQuery += "                                                              '03', VLRJAN+VLRFEV+VLRMAR,
	_cQuery += "                                                              '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
	_cQuery += "                                                              '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
	_cQuery += "                                                              '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
	_cQuery += "                                                              '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
	_cQuery += "                                                              '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
	_cQuery += "                                                              '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
	_cQuery += "                                                              '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
	_cQuery += "                                                              '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
	_cQuery += "                                                              '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0)) VALOR
	_cQuery += "                       FROM GER_VENDAMESCLIENTE_OBRA
	_cQuery += "                      WHERE ANO = "+ _cAno
	_cQuery += "                      GROUP BY B5_XCODHIS) 
	_cQuery += "               ORDER BY VALOR DESC) P
	_cQuery += "    ON F.B5_XCODHIS = P.B5_XCODHIS
	_cQuery += " WHERE LIQUIDO <> 0
	_cQuery += "    OR LIQUIDOAA <> 0
	_cQuery += " ORDER BY A1_CGC, F.LIQUIDO DESC, F.LIQUIDOAA DESC

	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias, .F., .T.)
	
	Do While !(_cAlias)->(eof()) .And. !oReport:Cancel()
		xCGC := (_cAlias)->A1_CGC
	
		oReport:IncMeter()
	
		oSection1:Init()  
	
		If !Empty(MV_PAR03)
			oSection1:Cell("A1_GRPVEN"  ):SetValue((_cAlias)->A1_GRPVEN)
		Else
			oSection1:Cell("A1_COD"     ):SetValue((_cAlias)->A1_COD)
			oSection1:Cell("A1_LOJA"    ):SetValue((_cAlias)->A1_LOJA)
			oSection1:Cell("A1_CGC"     ):SetValue((_cAlias)->A1_CGC)
		EndIf
		oSection1:Cell("A1_NOME"    ):SetValue((_cAlias)->A1_NOME)
		oSection1:Cell("A1_EST"     ):SetValue((_cAlias)->A1_EST)
		oSection1:Cell("A1_MUN"     ):SetValue((_cAlias)->A1_MUN)
		oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias)->TIPOCLIENTE)
		oSection1:Cell("CANALVENDA" ):SetValue((_cAlias)->CANALVENDA)
		oSection1:Cell("VENDEDOR"   ):SetValue((_cAlias)->VENDEDOR)
	 	
		oSection1:PrintLine()
	
		Do While !(_cAlias)->(eof()) .And. (_cAlias)->A1_CGC = xCGC .And. !oReport:Cancel()        
			oReport:IncMeter()
			oSection2:Init()
			oSection2:SetHeaderSection(.T.)
	
	        xDataPub := STOD((_cAlias)->DATAPUBLICACAO)
	
			oSection2:Cell("B1_COD"        ):SetValue((_cAlias)->B1_COD)
			oSection2:Cell("B1_ISBN"       ):SetValue((_cAlias)->B1_ISBN)
			oSection2:Cell("B1_DESC"       ):SetValue((_cAlias)->B1_DESC)
			oSection2:Cell("AREA"          ):SetValue((_cAlias)->AREA)  
			oSection2:Cell("CURSO"          ):SetValue((_cAlias)->CURSO)
			oSection2:Cell("DISCIPLINA"     ):SetValue((_cAlias)->DISCIPLINA)
			oSection2:Cell("SELO"          ):SetValue((_cAlias)->SELO)
			oSection2:Cell("DATAPUBLICACAO"):SetValue(xDataPub)
			oSection2:Cell("TIPOPUBLICACAO"):SetValue((_cAlias)->TIPOPUBLICACAO)
			oSection2:Cell("SITUACAOOBRA"  ):SetValue((_cAlias)->SITUACAOOBRA)
			oSection2:Cell("PARETO"        ):SetValue((_cAlias)->PARETO)
 			If lPlanilha
	 			oSection2:Cell("VLRACU"  ):SetValue("R$ " + Transform((_cAlias)->VLRACU, "@E 999,999,999.99"))
				oSection2:Cell("QTDACU"  ):SetValue(Transform((_cAlias)->QTDACU  , "@E 9,999,999"))
				oSection2:Cell("QTDACUAA"):SetValue(Transform((_cAlias)->QTDACUAA, "@E 9,999,999"))
				oSection2:Cell("DIFQTD"  ):SetValue(Transform((_cAlias)->DIFQTD  , "@E 9,999,999"))
				oSection2:Cell("QTDAAMS" ):SetValue(Transform((_cAlias)->QTDAAMS , "@E 9,999,999"))
 			Else 			
	 			oSection2:Cell("VLRACU"  ):SetValue((_cAlias)->VLRACU)
				oSection2:Cell("QTDACU"  ):SetValue((_cAlias)->QTDACU)
				oSection2:Cell("QTDACUAA"):SetValue((_cAlias)->QTDACUAA)
				oSection2:Cell("DIFQTD"  ):SetValue((_cAlias)->DIFQTD)
				oSection2:Cell("QTDAAMS" ):SetValue((_cAlias)->QTDAAMS)
			EndIf
		
			oSection2:PrintLine()
	
			(_cAlias)->(dbSkip())		
		EndDo
		oSection2:Finish()
	EndDo
	oSection2:Finish()
	oSection1:Finish()
	         
	DbSelectArea(_cAlias)
	DbCloseArea()
EndIf	
Return(.t.)

/**********************************************************************************************************************/
Static Function MntStrPsq(_cParametros)
/**********************************************************************************************************************/

Local _cTipos := ""
Local _aTipos := {}
Local _nLen   := 0

_aTipos := Separa(_cParametros,";")
_nLen   := Len(_aTipos)

If _nLen > 500
	_nLen := 500 
End

For nX := 1 To _nLen
	If nX == 1
		_cTipos := "'" + ALLTRIM(_aTipos[nX]) + "'"
	Else
		_cTipos := _cTipos + ",'" + ALLTRIM(_aTipos[nX]) + "'"
	EndIf
Next

Return _cTipos
