#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: GER010A

DESCRICAO: RANKING DE CLIENTE POR PRODUTO

ALTERACOES:
24/03/2016 - Desenvolvimento do fonte

/*/

User Function GER010A

Local oReport
Local cPerg := "GER10A"

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
*/
Static Function f001(cPerg)

PutSx1(cPerg, "01", "Data (mês fechado)","Data (mês fechado)"	,"Data (mês fechado)"	, "mv_ch1"	, "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Produto:"			,"Produto:"		  		,"Produto:"				, "mv_ch2"	, "C",90, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Conceito FEC?"		,"Conceito FEC?"		,"Conceito FEC?"		, "mv_ch3"	, "C", 3, 0, 1, "C","", "", "", "", "MV_PAR03", "Sim", "Sim", "Sim", "", "Não", "Não", "Não", "", "", "", "", "","", "", "", "", "", "", "", "" )


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
------------------------------------------------------------------------------------------------
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

_cAno   := YEAR2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)
_cDataFim:= DTOC(LASTDATE(MV_PAR01))

//Declaracao do relatorio
oReport := TReport():New("GER010A","GER010A - Ranking de Cliente por Produto - 01/01/"+_cAno+" a "+_cDataFim,cPerg,{|oReport| PrintReport(oReport)},"GER010A - Ranking de Cliente por Produto - 01/01/"+_cAno+" a "+_cDataFim,.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Produto","")
                        
//Celulas da secao
TRCell():New(oSection1,"B1_COD"		,"","Código",,10)
TRCell():New(oSection1,"B1_ISBN"	,"","ISBN",,20)
If (MV_PAR03 == 1)
	TRCell():New(oSection1,"B1_DESC"	,"SB1","Descrição (CONCEITO FEC)",,120)
Else
	TRCell():New(oSection1,"B1_DESC"	,"SB1","Descrição",,120)
EndIf
TRCell():New(oSection1,"B5_XDTPUBL"	,"","Dt.Publicação",,18)
TRCell():New(oSection1,"Z7_DESC"	,"","Área",,25) 
TRCell():New(oSection1,"CSG_OBRA"	,"","Saldo Consig.","@E 999,999,999",18,,,,,"RIGHT")

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Cliente","")

TRCell():New(oSection2,"CNPJ"		,"","CNPJ/CPF",,18)
TRCell():New(oSection2,"DESCRICAO"	,"","Descrição",,50)
TRCell():New(oSection2,"VLRACU"		,"",_cAno+" YTD R$"					,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection2,"VLRACUAA"	,"",_cAnoAnt+" YTD R$"				,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection2,"PERCVLR"	,"","% "+_cAno+" X "+_cAnoAnt+" R$"	,"@E 9,999.99"		,22,,,,,"RIGHT")
TRCell():New(oSection2,"QTDACU"		,"",_cAno+" YTD"					,"@E 999,999,999"	,12,,,,,"RIGHT")
TRCell():New(oSection2,"QTDACUAA"	,"",_cAnoAnt+" YTD"					,"@E 999,999,999"	,12,,,,,"RIGHT")
TRCell():New(oSection2,"PERCQTD"	,"","% "+_cAno+" X "+_cAnoAnt		,"@E 9,999.99"		,18,,,,,"RIGHT")
TRCell():New(oSection2,"OFERTA"		,"",_cAno+" Oferta"					,"@E 999,999,999"	,15,,,,,"RIGHT")
TRCell():New(oSection2,"OFERTA_AA"	,"",_cAnoAnt+" Oferta"				,"@E 999,999,999"	,15,,,,,"RIGHT")
TRCell():New(oSection2,"CSG_CLI"	,"","Saldo Consig."					,"@E 999,999,999"	,18,,,,,"RIGHT")
  
//Totalizadores
TRFunction():New(oSection2:Cell("VLRACU")	 ,NIL,"SUM")
TRFunction():New(oSection2:Cell("VLRACUAA")	 ,NIL,"SUM")
TRFunction():New(oSection2:Cell("QTDACU")	 ,NIL,"SUM")
TRFunction():New(oSection2:Cell("QTDACUAA")	 ,NIL,"SUM")
TRFunction():New(oSection2:Cell("OFERTA")	 ,NIL,"SUM")
TRFunction():New(oSection2:Cell("OFERTA_AA"),NIL,"SUM")
TRFunction():New(oSection2:Cell("CSG_CLI")	 ,NIL,"SUM")

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
Local xProduto  := ""
Local lPlanilha := oReport:nDevice == 4

Local  _cProduto := MntStrPsq(MV_PAR02)
 
_cAno   := YEAR2STR(MV_PAR01)
_cMes   := MONTH2STR(MV_PAR01)
_cAnoAnt:= YEAR2STR(YEAR(MV_PAR01) - 1)

If AnoMes(MV_PAR01) >= AnoMes(Date())
	MsgInfo('Esse relatório é mês fechado, informe uma data anterior ao mês corrente!')
Else	
	If (MV_PAR03) == 1
		_cQuery += "SELECT DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, F.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) B1_COD,
		_cQuery += "       F.B5_XCODHIS, SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, SB5.B5_XDTPUBL, SZ7.Z7_DESC, CSGO.SALDO CSG_OBRA,
		_cQuery += "       DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)) CNPJ,
		_cQuery += "       DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI)) DESCRICAO,
		_cQuery += "       SUM(F.LIQUIDO) VLRACU, SUM(F.LIQUIDOAA) VLRACUAA, SUM(F.QTDE) QTDACU, SUM(F.QTDEAA) QTDACUAA,
		_cQuery += "       SUM(NVL(O.OFERTA,0)) OFERTA, SUM(NVL(O.OFERTA_AA,0)) OFERTA_AA, SUM(NVL(CSGC.SALDO,0)) CSG_CLI
		_cQuery += "  FROM (SELECT A1_COD, A1_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV,
		_cQuery += "        SUM(LIQUIDO) LIQUIDO, SUM(LIQUIDOAA) LIQUIDOAA, SUM(QTDE) QTDE, SUM(QTDEAA) QTDEAA
		_cQuery += "        FROM
		_cQuery += "       (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
		_cQuery += "        ELSE A1_COD END A1_COD,
		_cQuery += "        CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
		_cQuery += "        ELSE A1_LOJA END A1_LOJA,
		_cQuery += "        TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, A1_GRPVEN, A1_XCANALV, LIQUIDO, LIQUIDOAA, QTDE, QTDEAA
		_cQuery += "        FROM 
		_cQuery += "       (SELECT VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
		_cQuery += "        '02', VLRJAN+VLRFEV,
		_cQuery += "        '03', VLRJAN+VLRFEV+VLRMAR,
		_cQuery += "        '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
		_cQuery += "        '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
		_cQuery += "        '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
		_cQuery += "        '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
		_cQuery += "        '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
		_cQuery += "        '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
		_cQuery += "        '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
		_cQuery += "        '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
		_cQuery += "        '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO,
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
		_cQuery += "        '02', VLRJAN+VLRFEV,
		_cQuery += "        '03', VLRJAN+VLRFEV+VLRMAR,
		_cQuery += "        '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
		_cQuery += "        '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
		_cQuery += "        '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
		_cQuery += "        '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
		_cQuery += "        '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
		_cQuery += "        '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
		_cQuery += "        '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
		_cQuery += "        '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
		_cQuery += "        '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDOAA,
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "        '02', QTDJAN+QTDFEV,
		_cQuery += "        '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "        '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "        '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "        '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "        '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "        '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "        '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "        '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "        '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "        '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDE,
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "        '02', QTDJAN+QTDFEV,
		_cQuery += "        '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "        '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "        '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "        '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "        '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "        '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "        '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "        '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "        '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "        '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDEAA
		_cQuery += "        FROM GER_VENDAMESCLIENTE_OBRA VMCO
		_cQuery += "        JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "        ON SA1.A1_COD = VMCO.A1_COD
		_cQuery += "        AND SA1.A1_LOJA = VMCO.A1_LOJA
		_cQuery += "        WHERE VMCO.ANO >= '"+ _cAnoAnt+"'
		_cQuery += "        AND VMCO.B5_XCODHIS IN (SELECT B5_XCODHIS FROM " + RetSqlName("SB5") + " WHERE B5_COD IN (SELECT B1_COD FROM " + RetSqlName("SB1") + " WHERE B1_ISBN IN ("+_cProduto+")))
		_cQuery += "        GROUP BY VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "        ORDER BY LIQUIDO DESC
		_cQuery += "       )
		_cQuery += "       )
		_cQuery += "       GROUP BY A1_COD, A1_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV
		_cQuery += "       )F 
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT A1_COD, A1_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV,
		_cQuery += "        SUM(OFERTA) OFERTA, SUM(OFERTA_AA) OFERTA_AA
		_cQuery += "        FROM
		_cQuery += "       (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY OFERTA DESC)
		_cQuery += "        ELSE A1_COD END A1_COD,
		_cQuery += "        CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY OFERTA DESC)
		_cQuery += "        ELSE A1_LOJA END A1_LOJA,
		_cQuery += "        TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, A1_GRPVEN, A1_XCANALV, OFERTA, OFERTA_AA
		_cQuery += "        FROM 
		_cQuery += "	   (SELECT OMCO.B5_XCODHIS, OMCO.A1_COD, OMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "        '02', QTDJAN+QTDFEV,
		_cQuery += "        '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "        '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "        '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "        '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "        '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "        '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "        '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "        '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "        '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "        '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) OFERTA,
		_cQuery += "        SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "        '02', QTDJAN+QTDFEV,
		_cQuery += "        '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "        '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "        '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "        '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "        '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "        '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "        '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "        '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "        '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "        '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) OFERTA_AA
		_cQuery += "        FROM GER_OFERTAMESCLIENTE_OBRA OMCO
		_cQuery += "        JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "        ON SA1.A1_COD = OMCO.A1_COD
		_cQuery += "        AND SA1.A1_LOJA = OMCO.A1_LOJA
		_cQuery += "        WHERE OMCO.ANO >= '"+ _cAnoAnt+"'
		_cQuery += "        AND OMCO.B5_XCODHIS IN (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) FROM SB5000 WHERE B5_COD IN (SELECT B1_COD FROM SB1000 WHERE B1_ISBN IN ("+_cProduto+")))
		_cQuery += "        GROUP BY OMCO.B5_XCODHIS, OMCO.A1_COD, OMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "        ORDER BY OFERTA DESC
		_cQuery += "	   )
		_cQuery += "     ) GROUP BY A1_COD, A1_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV
		_cQuery += "	   ) O
		_cQuery += "    ON F.A1_COD = O.A1_COD
		_cQuery += "   AND F.A1_LOJA = O.A1_LOJA
		_cQuery += "   AND F.B5_XCODHIS = O.B5_XCODHIS
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT B6_CLIFOR, B6_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV, SUM(SALDO) SALDO
		_cQuery += "        FROM
		_cQuery += "       (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(B6_CLIFOR) OVER (PARTITION BY A1_GRPVEN ORDER BY SALDO DESC)
		_cQuery += "        ELSE B6_CLIFOR END B6_CLIFOR,
		_cQuery += "        CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(B6_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY SALDO DESC)
		_cQuery += "        ELSE B6_LOJA END B6_LOJA,
		_cQuery += "        TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, A1_GRPVEN, A1_XCANALV, SALDO
		_cQuery += "        FROM 
		_cQuery += "	   (SELECT O.B5_XCODHIS, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, SUM(B6_SALDO) SALDO
		_cQuery += "        FROM " + RetSqlName("SB6") + " SB6
		_cQuery += "        JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "        ON SB6.B6_CLIFOR = SA1.A1_COD
		_cQuery += "        AND SB6.B6_LOJA = SA1.A1_LOJA
		_cQuery += "        JOIN 
		_cQuery += "	   (SELECT SB5H.B5_COD, SB5.B5_XCODHIS
		_cQuery += "        FROM " + RetSqlName("SB1") + " SB1
		_cQuery += "        JOIN " + RetSqlName("SB5") + " SB5
		_cQuery += "        ON SB1.B1_COD = SB5.B5_COD
		_cQuery += "        JOIN " + RetSqlName("SB5") + " SB5H
		_cQuery += "        ON SB5.B5_XCODHIS = SB5H.B5_XCODHIS
		_cQuery += "        WHERE B1_ISBN IN ("+_cProduto+")
		_cQuery += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "        AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "        AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "        AND SB5H.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND SB5H.D_E_L_E_T_ = ' '
		_cQuery += "	   ) O
		_cQuery += "        ON SB6.B6_PRODUTO = O.B5_COD
		_cQuery += "        WHERE SB6.B6_FILIAL = '1022'
		_cQuery += "        AND SB6.B6_TIPO = 'E'
		_cQuery += "        AND SB6.B6_PODER3 = 'R'
		_cQuery += "        AND SB6.B6_TPCF = 'C'
		_cQuery += "        AND SB6.D_E_L_E_T_ = ' '
		_cQuery += "        AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		_cQuery += "        AND SA1.D_E_L_E_T_ = ' '
		_cQuery += "        GROUP BY O.B5_XCODHIS, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "	   )
		_cQuery += "	   ) GROUP BY B6_CLIFOR, B6_LOJA, B5_XCODHIS, A1_GRPVEN, A1_XCANALV
		_cQuery += "     ) CSGC
		_cQuery += "    ON F.A1_COD = CSGC.B6_CLIFOR
		_cQuery += "   AND F.A1_LOJA =  CSGC.B6_LOJA
		_cQuery += "   AND F.B5_XCODHIS = CSGC.B5_XCODHIS
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT B5_XCODHIS, SUM(B6_SALDO) SALDO
		_cQuery += "        FROM " + RetSqlName("SB6") + " SB6
		_cQuery += "        JOIN 
		_cQuery += "	   (SELECT SB5H.B5_COD, SB5.B5_XCODHIS
		_cQuery += "        FROM " + RetSqlName("SB1") + " SB1
		_cQuery += "        JOIN " + RetSqlName("SB5") + " SB5
		_cQuery += "        ON SB1.B1_COD = SB5.B5_COD
		_cQuery += "        JOIN " + RetSqlName("SB5") + " SB5H
		_cQuery += "        ON SB5.B5_XCODHIS = SB5H.B5_XCODHIS
		_cQuery += "        WHERE B1_ISBN IN ("+_cProduto+")
		_cQuery += "        AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "        AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "        AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "        AND SB5H.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND SB5H.D_E_L_E_T_ = ' '
		_cQuery += "	   ) O
		_cQuery += "        ON SB6.B6_PRODUTO = O.B5_COD
		_cQuery += "        WHERE SB6.B6_FILIAL = '1022'
		_cQuery += "        AND SB6.B6_TIPO = 'E'
		_cQuery += "        AND SB6.B6_PODER3 = 'R'
		_cQuery += "        AND SB6.B6_TPCF = 'C'
		_cQuery += "        AND SB6.D_E_L_E_T_ = ' '
		_cQuery += "        GROUP BY B5_XCODHIS
		_cQuery += "	   ) CSGO
		_cQuery += "      ON F.B5_XCODHIS = CSGO.B5_XCODHIS
		_cQuery += "  LEFT 
		_cQuery += "  JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "    ON F.A1_COD = SA1.A1_COD
		_cQuery += "   AND F.A1_LOJA = SA1.A1_LOJA
		_cQuery += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		_cQuery += "  LEFT
		_cQuery += "  JOIN " + RetSqlName("ACY") + " ACY
		_cQuery += "    ON ACY.ACY_GRPVEN = F.A1_GRPVEN
		_cQuery += "   AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'"
		_cQuery += "   AND ACY.D_E_L_E_T_ = ' '
		_cQuery += "  LEFT
		_cQuery += "  JOIN (SELECT SB5.B5_COD, SB5.B5_XCODHIS
		_cQuery += "        FROM " + RetSqlName("SB5") + " SB5, 
		_cQuery += "       (SELECT B5_XCODHIS, MAX(R_E_C_N_O_) R_E_C_N_O_
		_cQuery += "        FROM " + RetSqlName("SB5")
		_cQuery += "        WHERE TRIM(B5_XFEC) = '1'
		_cQuery += "        AND D_E_L_E_T_ = ' '
		_cQuery += "        GROUP BY B5_XCODHIS
		_cQuery += "	   ) M
		_cQuery += "        WHERE SB5.B5_XCODHIS = M.B5_XCODHIS
		_cQuery += "        AND SB5.R_E_C_N_O_ = M.R_E_C_N_O_
		_cQuery += "        AND TRIM(SB5.B5_XFEC) = '1'
		_cQuery += "        AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "	   ) FEC
		_cQuery += "    ON F.B5_XCODHIS = FEC.B5_XCODHIS
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT TO_NUMBER(TRIM(SB5.B5_COD)) B5_COD, TO_NUMBER(TRIM(SB5.B5_XCODHIS)) B5_XCODHIS
		_cQuery += "        FROM " + RetSqlName("SB5") + " SB5, 
		_cQuery += "       (SELECT TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, MAX(B5_XDTPUBL) B5_XDTPUBL
		_cQuery += "        FROM " + RetSqlName("SB5")
		_cQuery += "        WHERE B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND D_E_L_E_T_ = ' '
		_cQuery += "        GROUP BY B5_XCODHIS
		_cQuery += "	   ) M
		_cQuery += "        WHERE TO_NUMBER(TRIM(SB5.B5_XCODHIS)) = TO_NUMBER(TRIM(M.B5_XCODHIS))
		_cQuery += "        AND TO_NUMBER(TRIM(SB5.B5_XDTPUBL)) = TO_NUMBER(TRIM(M.B5_XDTPUBL))
		_cQuery += "        AND TRIM(SB5.B5_XFEC) <> '1'
		_cQuery += "        AND SB5.B5_XSELO <> '15'
		_cQuery += "        AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "        AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "	   ) SFEC
		_cQuery += "    ON F.B5_XCODHIS = SFEC.B5_XCODHIS
		_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
		_cQuery += "    ON DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, F.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD) = SB1.B1_COD
		_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
		_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
		_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT Z7_AREA, Z7_DESC FROM " + RetSqlName("SZ7") + " WHERE Z7_FILIAL = '" + xFilial("SZ7") + "' AND D_E_L_E_T_ = ' '
		_cQuery += "       ) SZ7
		_cQuery += "    ON SB5.B5_XAREA = SZ7.Z7_AREA
		_cQuery += " WHERE LIQUIDO <> 0
		_cQuery += "    OR LIQUIDOAA <> 0
		_cQuery += " GROUP BY DECODE(FEC.B5_COD, NULL, DECODE(SFEC.B5_COD, NULL, F.B5_XCODHIS, SFEC.B5_COD), FEC.B5_COD),
		_cQuery += "          F.B5_XCODHIS, SB1.B1_ISBN, TRIM(SB1.B1_DESC), SB5.B5_XDTPUBL, SZ7.Z7_DESC, CSGO.SALDO,
		_cQuery += "          DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)),
		_cQuery += "          DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI))
		_cQuery += " ORDER BY SB1.B1_ISBN, F.B5_XCODHIS, VLRACU DESC, VLRACUAA DESC 
	Else
		_cQuery += "SELECT F.B1_COD, F.B5_XCODHIS, SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, SB5.B5_XDTPUBL, SZ7.Z7_DESC, CSGO.SALDO CSG_OBRA,
		_cQuery += "       DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)) CNPJ,
		_cQuery += "       DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI)) DESCRICAO,
		_cQuery += "       SUM(F.LIQUIDO) VLRACU, SUM(F.LIQUIDOAA) VLRACUAA, SUM(F.QTDE) QTDACU, SUM(F.QTDEAA) QTDACUAA,
		_cQuery += "       SUM(NVL(O.OFERTA,0)) OFERTA, SUM(NVL(O.OFERTA_AA,0)) OFERTA_AA, SUM(NVL(CSGC.SALDO,0)) CSG_CLI
		_cQuery += "  FROM (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
		_cQuery += "        ELSE A1_COD END A1_COD,
		_cQuery += "        CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY LIQUIDO DESC)
		_cQuery += "        ELSE A1_LOJA END A1_LOJA,
		_cQuery += "        B1_COD, TO_NUMBER(TRIM(B5_XCODHIS)) B5_XCODHIS, A1_GRPVEN, A1_XCANALV, LIQUIDO, LIQUIDOAA, QTDE, QTDEAA
		_cQuery += "        FROM (SELECT VMCO.B1_COD, VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
		_cQuery += "              SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', VLRJAN,
		_cQuery += "              '02', VLRJAN+VLRFEV,
		_cQuery += "              '03', VLRJAN+VLRFEV+VLRMAR,
		_cQuery += "              '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
		_cQuery += "              '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
		_cQuery += "              '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
		_cQuery += "              '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
		_cQuery += "              '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
		_cQuery += "              '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
		_cQuery += "              '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
		_cQuery += "              '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
		_cQuery += "              '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDO,
		_cQuery += "              SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', VLRJAN,
		_cQuery += "              '02', VLRJAN+VLRFEV,
		_cQuery += "              '03', VLRJAN+VLRFEV+VLRMAR,
		_cQuery += "              '04', VLRJAN+VLRFEV+VLRMAR+VLRABR,
		_cQuery += "              '05', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI,
		_cQuery += "              '06', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN,
		_cQuery += "              '07', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL,
		_cQuery += "              '08', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO,
		_cQuery += "              '09', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET,
		_cQuery += "              '10', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT,
		_cQuery += "              '11', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV,
		_cQuery += "              '12', VLRJAN+VLRFEV+VLRMAR+VLRABR+VLRMAI+VLRJUN+VLRJUL+VLRAGO+VLRSET+VLROUT+VLRNOV+VLRDEZ, 0), 0)) LIQUIDOAA,
		_cQuery += "              SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "              '02', QTDJAN+QTDFEV,
		_cQuery += "              '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "              '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "              '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "              '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "              '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "              '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "              '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "              '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "              '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "              '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDE,
		_cQuery += "              SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "              '02', QTDJAN+QTDFEV,
		_cQuery += "              '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "              '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "              '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "              '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "              '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "              '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "              '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "              '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "              '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "              '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) QTDEAA
		_cQuery += "              FROM GER_VENDAMESCLIENTE_OBRA VMCO
		_cQuery += "              JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "              ON SA1.A1_COD = VMCO.A1_COD
		_cQuery += "              AND SA1.A1_LOJA = VMCO.A1_LOJA
		_cQuery += "              WHERE VMCO.ANO >= '"+ _cAnoAnt+"'
		_cQuery += "              AND VMCO.B1_COD IN (SELECT B1_COD FROM SB1000 WHERE B1_ISBN IN ("+_cProduto+"))
		_cQuery += "              GROUP BY VMCO.B1_COD, VMCO.B5_XCODHIS, VMCO.A1_COD, VMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "              ORDER BY LIQUIDO DESC)) F 
		_cQuery += "  LEFT JOIN (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "             THEN FIRST_VALUE(A1_COD) OVER (PARTITION BY A1_GRPVEN ORDER BY OFERTA DESC)
		_cQuery += "             ELSE A1_COD END A1_COD,
		_cQuery += "             CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "             THEN FIRST_VALUE(A1_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY OFERTA DESC)
		_cQuery += "             ELSE A1_LOJA END A1_LOJA,
		_cQuery += "             B1_COD, A1_GRPVEN, A1_XCANALV, OFERTA, OFERTA_AA
		_cQuery += "             FROM (SELECT OMCO.B1_COD, OMCO.A1_COD, OMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, 
		_cQuery += "                   SUM(DECODE(ANO, '"+ _cAno+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "                   '02', QTDJAN+QTDFEV,
		_cQuery += "                   '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "                   '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "                   '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "                   '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "                   '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "                   '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "                   '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "                   '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "                   '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "                   '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) OFERTA,
		_cQuery += "                   SUM(DECODE(ANO, '"+ _cAnoAnt+"', DECODE('"+ _cMes+"', '01', QTDJAN,
		_cQuery += "                   '02', QTDJAN+QTDFEV,
		_cQuery += "                   '03', QTDJAN+QTDFEV+QTDMAR,
		_cQuery += "                   '04', QTDJAN+QTDFEV+QTDMAR+QTDABR,
		_cQuery += "                   '05', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI,
		_cQuery += "                   '06', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN,
		_cQuery += "                   '07', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL,
		_cQuery += "                   '08', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO,
		_cQuery += "                   '09', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET,
		_cQuery += "                   '10', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT,
		_cQuery += "                   '11', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV,
		_cQuery += "                   '12', QTDJAN+QTDFEV+QTDMAR+QTDABR+QTDMAI+QTDJUN+QTDJUL+QTDAGO+QTDSET+QTDOUT+QTDNOV+QTDDEZ, 0), 0)) OFERTA_AA
		_cQuery += "                   FROM GER_OFERTAMESCLIENTE_OBRA OMCO
		_cQuery += "                   JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "                   ON SA1.A1_COD = OMCO.A1_COD
		_cQuery += "                   AND SA1.A1_LOJA = OMCO.A1_LOJA
		_cQuery += "                   WHERE OMCO.ANO >= '"+ _cAnoAnt+"'
		_cQuery += "                   AND OMCO.B1_COD IN (SELECT B1_COD FROM " + RetSqlName("SB1") + " WHERE B1_ISBN IN ("+_cProduto+"))
		_cQuery += "                   GROUP BY OMCO.B1_COD, OMCO.A1_COD, OMCO.A1_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "                   ORDER BY OFERTA DESC)) O
		_cQuery += "    ON F.A1_COD  = O.A1_COD
		_cQuery += "   AND F.A1_LOJA = O.A1_LOJA
		_cQuery += "   AND F.B1_COD  = O.B1_COD
		_cQuery += "  LEFT 
		_cQuery += "  JOIN (SELECT B6_CLIFOR, B6_LOJA, B1_COD, A1_GRPVEN, A1_XCANALV, SUM(SALDO) SALDO
		_cQuery += "        FROM		
		_cQuery += "	   (SELECT CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(B6_CLIFOR) OVER (PARTITION BY A1_GRPVEN ORDER BY SALDO DESC)
		_cQuery += "        ELSE B6_CLIFOR END B6_CLIFOR,
		_cQuery += "        CASE WHEN A1_GRPVEN <> '      ' 
		_cQuery += "        THEN FIRST_VALUE(B6_LOJA) OVER (PARTITION BY A1_GRPVEN ORDER BY SALDO DESC)
		_cQuery += "        ELSE B6_LOJA END B6_LOJA,
		_cQuery += "        B1_COD, A1_GRPVEN, A1_XCANALV, SALDO
		_cQuery += "        FROM (SELECT SB1.B1_COD, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV, SUM(B6_SALDO) SALDO
		_cQuery += "              FROM " + RetSqlName("SB6") + " SB6
		_cQuery += "              JOIN " + RetSqlName("SB1") + " SB1
		_cQuery += "              ON SB6.B6_PRODUTO = SB1.B1_COD
		_cQuery += "              JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "              ON SB6.B6_CLIFOR = SA1.A1_COD
		_cQuery += "              AND SB6.B6_LOJA = SA1.A1_LOJA
		_cQuery += "              WHERE SB6.B6_FILIAL = '1022'
		_cQuery += "              AND SB6.B6_TIPO = 'E'
		_cQuery += "              AND SB6.B6_PODER3 = 'R'
		_cQuery += "              AND SB6.B6_TPCF = 'C'
		_cQuery += "              AND SB6.D_E_L_E_T_ = ' '
		_cQuery += "              AND SB1.B1_ISBN IN ("+_cProduto+")
		_cQuery += "              AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "              AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "              AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		_cQuery += "              AND SA1.D_E_L_E_T_ = ' '
		_cQuery += "              GROUP BY SB1.B1_COD, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_GRPVEN, SA1.A1_XCANALV
		_cQuery += "		     )
		_cQuery += "	   )
		_cQuery += "       GROUP BY B6_CLIFOR, B6_LOJA, B1_COD, A1_GRPVEN, A1_XCANALV
		_cQuery += "	   ) CSGC
		_cQuery += "    ON F.A1_COD  = CSGC.B6_CLIFOR
		_cQuery += "   AND F.A1_LOJA = CSGC.B6_LOJA
		_cQuery += "   AND F.B1_COD  = CSGC.B1_COD
		_cQuery += "  LEFT JOIN (SELECT B1_COD, SUM(B6_SALDO) SALDO
		_cQuery += "             FROM " + RetSqlName("SB6") + " SB6
		_cQuery += "             JOIN " + RetSqlName("SB1") + " SB1
		_cQuery += "             ON SB6.B6_PRODUTO = SB1.B1_COD
		_cQuery += "             WHERE SB6.B6_FILIAL = '1022'
		_cQuery += "             AND SB6.B6_TIPO = 'E'
		_cQuery += "             AND SB6.B6_PODER3 = 'R'
		_cQuery += "             AND SB6.B6_TPCF = 'C'
		_cQuery += "             AND SB6.D_E_L_E_T_ = ' '
		_cQuery += "             AND SB1.B1_ISBN IN ("+_cProduto+")
		_cQuery += "             AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "             AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "             GROUP BY B1_COD) CSGO
		_cQuery += "      ON F.B1_COD = CSGO.B1_COD
		_cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1
		_cQuery += "    ON F.A1_COD = SA1.A1_COD
		_cQuery += "   AND F.A1_LOJA = SA1.A1_LOJA
		_cQuery += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		_cQuery += "  LEFT JOIN " + RetSqlName("ACY") + " ACY
		_cQuery += "    ON ACY.ACY_GRPVEN = F.A1_GRPVEN
		_cQuery += "   AND ACY.ACY_FILIAL = '" + xFilial("ACY") + "'"
		_cQuery += "   AND ACY.D_E_L_E_T_ = ' '
		_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
		_cQuery += "    ON F.B1_COD = SB1.B1_COD
		_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
		_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
		_cQuery += "  JOIN " + RetSqlName("SB5") + " SB5
		_cQuery += "    ON SB1.B1_COD = SB5.B5_COD
		_cQuery += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
		_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
		_cQuery += "  LEFT JOIN (SELECT Z7_AREA, Z7_DESC FROM " + RetSqlName("SZ7") + " WHERE Z7_FILIAL = '" + xFilial("SZ7") + "' AND D_E_L_E_T_ = ' ') SZ7
		_cQuery += "    ON SB5.B5_XAREA = SZ7.Z7_AREA
		_cQuery += " WHERE LIQUIDO <> 0
		_cQuery += "    OR LIQUIDOAA <> 0
		_cQuery += " GROUP BY F.B1_COD, F.B5_XCODHIS, SB1.B1_ISBN, TRIM(SB1.B1_DESC), SB5.B5_XDTPUBL, SZ7.Z7_DESC, CSGO.SALDO,
		_cQuery += "          DECODE(TRIM(F.A1_XCANALV), '3', NULL, DECODE(F.A1_GRPVEN, '      ', SA1.A1_CGC, NULL)),
		_cQuery += "          DECODE(TRIM(F.A1_XCANALV), '3', 'CONSUMIDOR FINAL', DECODE(F.A1_GRPVEN, '      ', SA1.A1_NOME, 'GRUPO '||ACY.ACY_DESCRI))
		_cQuery += " ORDER BY SB1.B1_ISBN, VLRACU DESC, VLRACUAA DESC
	EndIf			  	

	If Select(_cAlias) > 0
		dbSelectArea(_cAlias)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias, .F., .T.)
	
	Do While !(_cAlias)->(eof()) .And. !oReport:Cancel()

	 	xProduto := (_cAlias)->B5_XCODHIS
	    xDtPubl  := STOD((_cAlias)->B5_XDTPUBL)
		oReport:IncMeter()
	
		oSection1:Init()  
		oReport:SkipLine(1)
			
		oSection1:Cell("B1_COD"):SetValue((_cAlias)->B1_COD)
		oSection1:Cell("B1_ISBN"):SetValue((_cAlias)->B1_ISBN)
		oSection1:Cell("B1_DESC"):SetValue((_cAlias)->B1_DESC)
		If lPlanilha
			oSection1:Cell("CSG_OBRA"):SetValue(Transform((_cAlias)->CSG_OBRA, "@E 999,999,999"))
		Else
			oSection1:Cell("CSG_OBRA"):SetValue((_cAlias)->CSG_OBRA)
		EndIf
		oSection1:Cell("B5_XDTPUBL"):SetValue(xDtPubl)
		oSection1:Cell("Z7_DESC"):SetValue((_cAlias)->Z7_DESC)
	                                                                 
		oSection1:PrintLine()
	
		Do While !(_cAlias)->(eof()) .And. (_cAlias)->B5_XCODHIS = xProduto .And. !oReport:Cancel()        
			oReport:IncMeter()
			oSection2:Init()
	                                                                   
			If (_cAlias)->VLRACUAA <> 0
				xPercVlr :=  (_cAlias)->VLRACU / (_cAlias)->VLRACUAA * 100
			Else
				xPercVlr := 0
			EndIf
	
			If (_cAlias)->QTDACUAA <> 0
				xPercQtd :=  (_cAlias)->QTDACU / (_cAlias)->QTDACUAA * 100
			Else
				xPercQtd := 0
			EndIf

			oSection2:Cell("CNPJ"):SetValue((_cAlias)->CNPJ)
			oSection2:Cell("DESCRICAO"):SetValue((_cAlias)->DESCRICAO)
			If lPlanilha
	 			oSection2:Cell("VLRACU"):SetValue("R$ " + Transform((_cAlias)->VLRACU, "@E 999,999,999.99"))
				oSection2:Cell("VLRACUAA"):SetValue("R$ " + Transform((_cAlias)->VLRACUAA, "@E 999,999,999.99"))
				oSection2:Cell("PERCVLR"):SetValue(Transform(xPercVlr, "@E 9,999.99" + " %"))
				oSection2:Cell("QTDACU"):SetValue(Transform((_cAlias)->QTDACU, "@E 999,999,999"))
				oSection2:Cell("QTDACUAA"):SetValue(Transform((_cAlias)->QTDACUAA, "@E 999,999,999"))
				oSection2:Cell("PERCQTD"):SetValue(Transform(xPercQtd, "@E 9,999.99" + " %"))
				oSection2:Cell("OFERTA"):SetValue(Transform((_cAlias)->OFERTA, "@E 999,999,999"))
				oSection2:Cell("OFERTA_AA"):SetValue(Transform((_cAlias)->OFERTA_AA, "@E 999,999,999"))
				oSection2:Cell("CSG_CLI"):SetValue(Transform((_cAlias)->CSG_CLI, "@E 999,999,999"))
			Else
				oSection2:Cell("VLRACU"):SetValue((_cAlias)->VLRACU)
				oSection2:Cell("VLRACUAA"):SetValue((_cAlias)->VLRACUAA)
				oSection2:Cell("PERCVLR"):SetValue(xPercVlr)
				oSection2:Cell("QTDACU"):SetValue((_cAlias)->QTDACU)
				oSection2:Cell("QTDACUAA"):SetValue((_cAlias)->QTDACUAA)
				oSection2:Cell("PERCQTD"):SetValue(xPercQtd)
				oSection2:Cell("OFERTA"):SetValue((_cAlias)->OFERTA)
				oSection2:Cell("OFERTA_AA"):SetValue((_cAlias)->OFERTA_AA)
				oSection2:Cell("CSG_CLI"):SetValue((_cAlias)->CSG_CLI)
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
