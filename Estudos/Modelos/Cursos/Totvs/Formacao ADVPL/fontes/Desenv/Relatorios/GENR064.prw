#include "protheus.ch"
#include "topconn.ch"
#Include "Report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENR064()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg		:= "GENR064"
Private lQuebra	:= .T.
Private cQryAlias	:= GetNextAlias()

//AjustaSX1(cPerg)

If !Pergunte(cPerg,.T.)
	Return nil
EndIF

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(cPerg)

Local cTitulo	:= "Lista de pr้-notas em aberto"

Local oReport	:= Nil
Local oSection1	:= Nil

Local aOrdem	:= {}

//Declaracao do relatorio
oReport := TReport():New("GENR064",cTitulo	,cPerg		,{|oReport| PrintReport(oReport)}, cTitulo) 
oReport:PrintHeader(.F.,.F.)

//Secao do relatorio
oSection1 := TRSection():New(oReport, cTitulo,{"SF1", cQryAlias, "NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"F1_FILIAL"	, "SF1", "Filial"			,,)
TRCell():New(oSection1,"F1_DOC"		, "SF1", "Documento"	  	,,)
TRCell():New(oSection1,"F1_SERIE"	, "SF1", "Serie"		  	,,)
TRCell():New(oSection1,"F1_TIPO"	, "SF1", "Tipo Doc."		,,)
TRCell():New(oSection1,"F1_EMISSAO"	, "SF1", "Emissใo"			,,)
TRCell():New(oSection1,"F1_DTDIGIT"	, "SF1", "Dt.Digit."		,,)
If MV_PAR07 == 1		//Todos
	TRCell():New(oSection1,"F1_FORNECE"	, "SF1", "Forn/Cli"		,,)
ElseIf MV_PAR07 <> 3		//Devolucao
	TRCell():New(oSection1,"F1_FORNECE"	, "SF1", "Fornecedor"	,,)
Else
	TRCell():New(oSection1,"F1_FORNECE"	, "SF1", "Cliente"		,,)
EndIf
TRCell():New(oSection1,"F1_LOJA"	, "SF1", "Loja"				,,)
TRCell():New(oSection1,"F1_COND"	, "SF1", "Cond. Pgto"		,,)
TRCell():New(oSection1,"F1_EST"		, "SF1", "Estado"			,,)
TRCell():New(oSection1,"A2_NOME"	, "SA2", "Razใo Social"		,,)
TRCell():New(oSection1,"D1_TOTAL"	, "SA2", "Vlr.Tot.Doc."		,,)
TRCell():New(oSection1,"F1_USERLGI"	, "SF1", "Usuแrio"			,,)


//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
//oSection1:SetLeftMargin(2)
//oSection1:lPrintHeader := .F.

Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

Local cQuery	:= ""
Local cSqlExec	:= ""

Local nQtdReg	:= 0

Local aAreas	:= {SM0->(GetArea()), GetArea()}
Local aTpDoc	:= {"T", "N", "D", "B"}			//Tipos de documentos do MV_PAR07: Todos/Normal/Devolucao/Beneficiamento

cQuery := " SELECT GRP.F1_FILIAL, GRP.F1_DOC, GRP.F1_SERIE, GRP.F1_TIPO, GRP.F1_EMISSAO, GRP.F1_DTDIGIT, " + CRLF
cQuery += "        GRP.F1_FORNECE, GRP.F1_LOJA, GRP.F1_COND, GRP.F1_EST, GRP.A2_NOME, SUM(GRP.D1_TOTAL) D1_TOTAL, RECF1 " + CRLF
cQuery += "  FROM ( " + CRLF
cQuery += "        SELECT SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_TIPO, SF1.F1_EMISSAO, SF1.F1_DTDIGIT, " + CRLF
cQuery += "               SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_COND, SF1.F1_EST, SF1.F1_USERLGI, SF1.R_E_C_N_O_ RECF1, " + CRLF
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se tipo de documento for diferente de devolucao, considero tabela fornecedores, senao   ณ
//ณ considero tabela de clientes.                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR07 <> 3
	cQuery += "           SA2.A2_NOME A2_NOME, " + CRLF
Else
	cQuery += "           SA1.A1_NOME A2_NOME, " + CRLF
EndIf
cQuery += "               SD1.D1_TOTAL " + CRLF
cQuery += "          FROM " + RetSqlTab("SF1")
cQuery += "          JOIN " + RetSqlTab("SD1")
cQuery += "            ON SF1.F1_FILIAL = SD1.D1_FILIAL " + CRLF
cQuery += "           AND SF1.F1_DOC = SD1.D1_DOC " + CRLF
cQuery += "           AND SF1.F1_SERIE = SD1.D1_SERIE " + CRLF
cQuery += "           AND SF1.F1_FORNECE = SD1.D1_FORNECE " + CRLF
cQuery += "           AND SF1.F1_LOJA = SD1.D1_LOJA " + CRLF
cQuery += "           AND SD1.D1_TES = ' ' " + CRLF
cQuery += "           AND SD1.D_E_L_E_T_ <> '*' " + CRLF
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se tipo de documento for diferente de devolucao, considero tabela fornecedores, senao   ณ
//ณ considero tabela de clientes.                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR07 <> 3
	cQuery += "      JOIN " + RetSqlTab("SA2")
	cQuery += "        ON SA2.A2_FILIAL = '" + xFilial("SA2") + "' " + CRLF
	cQuery += "       AND SA2.A2_COD = SF1.F1_FORNECE " + CRLF
	cQuery += "       AND SA2.A2_LOJA = SF1.F1_LOJA " + CRLF
	cQuery += "       AND SA2.D_E_L_E_T_ <> '*' " + CRLF
Else
	cQuery += "      JOIN " + RetSqlTab("SA1")
	cQuery += "        ON SA1.A1_FILIAL = '" + xFilial("SA2") + "' " + CRLF
	cQuery += "       AND SA1.A1_COD = SF1.F1_FORNECE " + CRLF
	cQuery += "       AND SA1.A1_LOJA = SF1.F1_LOJA " + CRLF
	cQuery += "       AND SA1.D_E_L_E_T_ <> '*' " + CRLF
EndIf
cQuery += "  WHERE SF1.D_E_L_E_T_ <> '*' " + CRLF
If !Empty(MV_PAR05 + MV_PAR06)
	cQuery += "    AND SF1.F1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
EndIf
If !Empty(MV_PAR03 + MV_PAR04)
	cQuery += "    AND SF1.F1_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
EndIf
If !Empty(MV_PAR01 + MV_PAR02)
	cQuery += "    AND SF1.F1_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' " + CRLF
EndIf
If !Empty(MV_PAR08 + MV_PAR09)
	cQuery += "    AND SF1.F1_DTDIGIT BETWEEN '" + DToS(MV_PAR08) + "' AND '" + DToS(MV_PAR09) + "' " + CRLF
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se tipo de documento for diferente de TODOS, adiciono o tipo do documento.              ณ
//ณ Senao, efetuo um UNION ALL para considerar todas as notas inclusive as de devolucao     ณ
//ณ (JOIN com tabela de clientes)                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR07 <> 1
	cQuery += "    AND SF1.F1_TIPO = '" + aTpDoc[MV_PAR07] + "' " + CRLF
Else
	cQuery += " UNION ALL " + CRLF
	cQuery += "    SELECT SF1.F1_FILIAL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_TIPO, SF1.F1_EMISSAO, SF1.F1_DTDIGIT, " + CRLF
	cQuery += "           SF1.F1_FORNECE, SF1.F1_LOJA, SF1.F1_COND, SF1.F1_EST, SF1.F1_USERLGI, SF1.R_E_C_N_O_ RECF1, " + CRLF
	cQuery += "           SA1.A1_NOME A2_NOME, " + CRLF
	cQuery += "           SD1.D1_TOTAL " + CRLF
	cQuery += "      FROM " + RetSqlTab("SF1")
	cQuery += "      JOIN " + RetSqlTab("SD1")
	cQuery += "        ON SF1.F1_FILIAL = SD1.D1_FILIAL " + CRLF
	cQuery += "       AND SF1.F1_DOC = SD1.D1_DOC " + CRLF
	cQuery += "       AND SF1.F1_SERIE = SD1.D1_SERIE " + CRLF
	cQuery += "       AND SF1.F1_FORNECE = SD1.D1_FORNECE " + CRLF
	cQuery += "       AND SF1.F1_LOJA = SD1.D1_LOJA " + CRLF
	cQuery += "       AND SD1.D1_TES = ' ' " + CRLF
	cQuery += "       AND SD1.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "      JOIN " + RetSqlTab("SA1")
	cQuery += "        ON SA1.A1_FILIAL = '" + xFilial("SA2") + "' " + CRLF
	cQuery += "       AND SA1.A1_COD = SF1.F1_FORNECE " + CRLF
	cQuery += "       AND SA1.A1_LOJA = SF1.F1_LOJA " + CRLF
	cQuery += "       AND SA1.D_E_L_E_T_ <> '*' " + CRLF
	cQuery += "     WHERE SF1.D_E_L_E_T_ <> '*' " + CRLF
	If !Empty(MV_PAR05 + MV_PAR06)
		cQuery += "   AND SF1.F1_FILIAL BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' " + CRLF
	EndIf
	If !Empty(MV_PAR03 + MV_PAR04)
		cQuery += "   AND SF1.F1_FORNECE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	EndIf
	If !Empty(MV_PAR01 + MV_PAR02)
		cQuery += "   AND SF1.F1_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' " + CRLF
	EndIf
	If !Empty(MV_PAR08 + MV_PAR09)
		cQuery += "   AND SF1.F1_DTDIGIT BETWEEN '" + DToS(MV_PAR08) + "' AND '" + DToS(MV_PAR09) + "' " + CRLF
	EndIf
EndIf

cQuery += "      ) GRP " + CRLF
cQuery += "  GROUP BY GRP.F1_FILIAL, GRP.F1_DOC, GRP.F1_SERIE, GRP.F1_TIPO, GRP.F1_EMISSAO, GRP.F1_DTDIGIT, " + CRLF 
cQuery += "           GRP.F1_FORNECE, GRP.F1_LOJA, GRP.F1_COND, GRP.F1_EST, GRP.A2_NOME, RECF1 " + CRLF
 
cQuery += " ORDER BY GRP.F1_FILIAL, GRP.F1_DOC, GRP.F1_SERIE, GRP.F1_FORNECE, GRP.F1_LOJA"        

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cQryAlias, .F., .T.)
(cQryAlias)->(dbGoTop())

nQtdReg	:= Contar(cQryAlias, "!EOF()")
oReport:SetMeter(nQtdReg)

(cQryAlias)->(dbGoTop())

While !(cQryAlias)->(Eof())

	If oReport:Cancel()
		Return nil
	EndIF
	nRec := (cQryAlias)->RECF1
	
	SF1->(DBGOTO(nRec))
		
	cUserN := FWLeUserlg("F1_USERLGI")
	oReport:IncMeter()
	oSection1:Init()  
	
	oSection1:Cell("F1_FILIAL"	):SetValue(	(cQryAlias)->F1_FILIAL	)
	oSection1:Cell("F1_DOC"		):SetValue(	(cQryAlias)->F1_DOC		)
	oSection1:Cell("F1_SERIE"	):SetValue(	(cQryAlias)->F1_SERIE	)
	oSection1:Cell("F1_TIPO"	):SetValue(	(cQryAlias)->F1_TIPO	)
	oSection1:Cell("F1_EMISSAO"	):SetValue(	DToC(SToD((cQryAlias)->F1_EMISSAO))	)
	oSection1:Cell("F1_DTDIGIT"	):SetValue(	DToC(SToD((cQryAlias)->F1_DTDIGIT))	)
	oSection1:Cell("F1_FORNECE"	):SetValue(	(cQryAlias)->F1_FORNECE	)
	oSection1:Cell("F1_LOJA"	):SetValue(	(cQryAlias)->F1_LOJA	)
	oSection1:Cell("F1_COND"	):SetValue(	(cQryAlias)->F1_COND	)
	oSection1:Cell("F1_EST"		):SetValue(	(cQryAlias)->F1_EST		)
	oSection1:Cell("A2_NOME"	):SetValue(	(cQryAlias)->A2_NOME	)
	oSection1:Cell("D1_TOTAL"  	):SetValue(	(cQryAlias)->D1_TOTAL	)
	oSection1:Cell("F1_USERLGI" ):SetValue(	cUserN					)
	oSection1:PrintLine()

	(cQryAlias)->(dbSkip())
	
EndDo

(cQryAlias)->(DbCloseArea())

aEval(aAreas, {|x| RestArea(x) })

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GENR064  บ Autor ณ Renato Calabro'    บ Data ณ  06/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de listagem de pre-notas nao classificadas       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->( GetArea() )
Local aHelp		:= Array(3) 
Local cTamSX1	:= Len(SX1->X1_GRUPO)
Local cPesPerg	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define os tํtulos e Help das perguntas                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aHelp[1] := {"Informe a data inicial de notas fiscais "      ,"de entrada que serแ considerada no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
aHelp[2] := {""}
aHelp[3] := {""}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Grava as perguntas no arquivo SX1                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//		cGrupo cOrde cDesPor			cDesSpa				  	cDesEng				     cVar	   cTipo cTamanho					cDecimal	nPreSel	cGSC	cValid                            cF3 		cGrpSXG	cPyme cVar01	cDef1Por	cDef1Spa	cDef1Eng cCnt01	cDef2Por	cDef2Spa	cDef2Eng		cDef3Por		cDef3Spa			cDef3Eng	cDef4Por			cDef4Spa			cDef4Eng			cDef5Por cDef5Spa cDef5Eng aHelpPor	aHelpEng 	aHelpSpa 	cHelp)
PutSx1(cPerg,"01","Dt. Emissใo De"		,"Dt. Emissใo De"      	,"Dt. Emissใo de"		,"mv_ch1" ,"D"	, 8        					,0  	    ,        ,"G"  ,""                                  ,""		,		,"","mv_par01", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a data final de notas fiscais "      ,"de entrada que serแ considerada no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"02","Dt. Emissใo At้"		,"Dt. Emissใo Ate"		,"Dt. Emissใo Ate"		,"mv_ch2" ,"D"	, 8        					,0     	  	,        ,"G"  ,""                                  ,""	  	,	  	,"","mv_par02", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe o c๓digo do fornecedor inicial "      ,"que serแ considerado no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"03","Fornecedor De"		,"Fornecedor De"      	,"Fornecedor De"        ,"mv_ch3" ,"C"	, TamSX3("D1_FORNECE")[1]	,0     		,        ,"G"  ,""                                  ,"SA2" 	,		,"","mv_par03", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe o c๓digo do fornecedor final "      ,"que serแ considerado no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"04","Fornecedor At้"		,"Fornecedor At้"      	,"Fornecedor At้"      	,"mv_ch4" ,"C"	, TamSX3("D1_FORNECE")[1]	,0       	,        ,"G"  ,""                                  ,"SA2" 	,		,"","mv_par04", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a filial inicial que serแ con- "      ,"siderada no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"05","Filial De"			,"Filial De"			,"Filial De"			,"mv_ch5" ,"C"	, Len(cFilAnt)				,0		 	,		 ,"G"  ,""									,"XM0"	,""		,"","mv_par05", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a filial final que serแ con- "      ,"siderada no relat๓rio. "           ,"Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"06","Filial At้"			,"Filial At้"			,"Filial At้"			,"mv_ch6" ,"C"	, Len(cFilAnt)				,0		 	,		 ,"G"  ,""									,"XM0"	,""		,"","mv_par06", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe o tipo de documento a ser "      ,"considerado no relat๓rio. "           ,"" }
PutSx1(cPerg,"07","Tipo Doc."			,"Tipo Doc."			,"Tipo Doc."			,"mv_ch7" ,"C"	, 1							,0		 	,		 ,"C"  ,""									,""		,""		,"","mv_par07", "T=Todos", "T=Todos", "T=Todos"	,"", "N=Normal"	, "N=Normal"	, "N=Normal"	, "D=Devolu็ใo"	, "D=Devolu็ใo"	, "D=Devolu็ใo"	, "B=Beneficiamento", "B=Beneficiamento", "B=Beneficiamento", ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a data de digita็ใo inicial "      ,"de notas fiscais de entrada que serแ considerada "           ,"no relat๓rio. Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"08","Dt. Digit. De"		,"Dt. Digit. De"		,"Dt. Digit. De"		,"mv_ch8" ,"D"	, 8        					,0     	  	,        ,"G"  ,""                                  ,""	  	,	  	,"","mv_par08", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

aHelp[1] := {"Informe a data de digita็ใo final de "      ,"notas fiscais de entrada que serแ considerada "           ,"no relat๓rio. Se nใo for preenchido, considera todos" }
PutSx1(cPerg,"09","Dt. Digit. At้"		,"Dt. Digit. At้"		,"Dt. Digit. At้"		,"mv_ch9" ,"D"	, 8        					,0     	  	,        ,"G"  ,""                                  ,""	  	,	  	,"","mv_par09", ""		, ""		, ""		,"", ""			, ""			, ""			, ""			, ""				, ""		, ""				, ""				, ""				, ""	, ""	, ""	, aHelp[01]	, aHelp[02]	, aHelp[03]	,	"" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Salva as แreas originais                                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea( aAreaSX1 )
RestArea( aAreaAtu )

Return( Nil )  
*/