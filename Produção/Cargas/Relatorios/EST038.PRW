#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: EST038N

DESCRICAO: EST038 - RELATORIO DE INVENTARIO

ALTERACOES:
01/04/2016 - Desenvolvimento do fonte

/*/

User Function EST038

Local oReport
Local cPerg := "EST038"

//Cria grupo de perguntas
f001(cPerg) 

//Carrega grupo de perguntas
_lTela := .t.	
//While _lTela 
If Pergunte(cPerg,.T.)
       If Empty(MV_PAR02)
		MsgStop("É necessário escolher uma filial.")
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
Alteracoes:
01/04/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function f001(cPerg)

Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor 	:= {}
//AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao considerados todos os   ")
AADD(aHelpPor,"produtos.                     ")

PutSx1(cPerg, "01", "Produto:","Produto:","Produto:","mv_ch1","C",90,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
//AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

PutSx1(cPerg,"02", "Filial:","Filial:","Filial:","mv_ch2","C",Len(cFilAnt),0,0,"G","","XM0","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

return nil

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
01/04/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

//Declaracao do relatorio
oReport := TReport():New("EST038","EST038 - Relatório de Inventário",cPerg,{|oReport| PrintReport(oReport)},"EST038 - Relatório de Inventário",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandScape()

oReport:NDEVICE := 4

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Relatório de Inventário","")
	
//Celulas da secao
TRCell():New(oSection1,"SIGLAGEN"		,"","Empresa",,10) 
TRCell():New(oSection1,"B1_COD"			,"","Código",,10) 
TRCell():New(oSection1,"B1_ISBN"		,"","ISBN",,15)
TRCell():New(oSection1,"B1_DESC"		,"","Descrição",,40)
TRCell():New(oSection1,"TIPO_PUBLICACAO","","Tipo Publicação",,20)
TRCell():New(oSection1,"SITUACAO_OBRA"	,"","Situação Obra",,20)
TRCell():New(oSection1,"CUSTO"			,"","Custo Unit.","@E 9,999.99",15,,,,,"RIGHT")
TRCell():New(oSection1,"BOM"			,"","Saldo Bom","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"RESERVA_PEDIDO"	,"","Saldo Reserva Pedido","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"DISPONIVEL"		,"","Saldo Disponível (Bom - Reserva Pedido)","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"CONSIGNACAO"	,"","Saldo Consignado","@E 999,999",18,,,,,"RIGHT")
TRCell():New(oSection1,"PRESTA_CONTAS"	,"","Saldo Prest. Contas","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"DEFEITO"		,"","Saldo Defeito","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"RESERVA"		,"","Saldo Reserva","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"TRANSITO"		,"","Saldo Trânsito","@E 999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"CORTE"			,"","Saldo Corte","@E 999,999",12,,,,,"RIGHT")
If SUBSTR(MV_PAR02,1,2) = '10'
	TRCell():New(oSection1,"TOTAL"			,"","Saldo Total (Bom + Consignado + Prest. Contas + Defeito + Reserva + Trânsito + Corte)","@E 999,999",12,,,,,"RIGHT")
Else
	TRCell():New(oSection1,"TOTAL"			,"","Saldo Total (Bom + Prest. Contas + Defeito + Reserva + Trânsito + Corte)","@E 999,999",12,,,,,"RIGHT")
EndIf
TRCell():New(oSection1,"CUSTOTOTAL"		,"","Custo Total","@E 999,999,999.99",18,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection1:Cell("BOM") 				,NIL,"SUM")
TRFunction():New(oSection1:Cell("RESERVA_PEDIDO")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("DISPONIVEL")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("CONSIGNACAO")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("RESERVA")			,NIL,"SUM")
TRFunction():New(oSection1:Cell("TOTAL")			,NIL,"SUM")
TRFunction():New(oSection1:Cell("CUSTOTOTAL")		,NIL,"SUM")

/*
//Secao do relatorio
oSection2 := TRSection():New(oReport,"Pedidos Faturados e não Separados","")
	
//Celulas da secao
TRCell():New(oSection2,"D2_PEDIDO"		,"","Pedido",,6,,,,,"RIGHT")
TRCell():New(oSection2,"D2_DOC"			,"","Nota Fiscal",,8,,,,,"RIGHT")
TRCell():New(oSection2,"D2_SERIE"		,"","Série",,2,,,,,"RIGHT")
TRCell():New(oSection2,"D2_EMISSAO"		,"","Data",,8,,,,,"RIGHT")
TRCell():New(oSection2,"D2_CLIENTE"		,"","Cód.Cli",,5,,,,,"RIGHT")
TRCell():New(oSection2,"D2_LOJA"		,"","Loja",,2,,,,,"RIGHT") 
TRCell():New(oSection2,"A1_NOME"		,"","Cliente",,20)
TRCell():New(oSection2,"D2_COD"			,"","Código",,8) 
TRCell():New(oSection2,"B1_ISBN"		,"","ISBN",,12)
TRCell():New(oSection2,"B1_DESC"		,"","Descrição",,20)
TRCell():New(oSection2,"D2_VALBRUT"		,"","Vlr.Liq.Prod.","@E 999,999.99",12,,,,,"RIGHT")
TRCell():New(oSection2,"D2_QUANT"		,"","Qtde","@E 999,999",8,,,,,"RIGHT")
TRCell():New(oSection2,"STATUS"			,"","Status",,15)

//Totalizadores
TRFunction():New(oSection2:Cell("D2_VALBRUT")	,NIL,"SUM")
TRFunction():New(oSection2:Cell("D2_QUANT")		,NIL,"SUM")

*/
//Faz a impressao do totalizador em linha
//oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
01/04/2016 - Helimar Tavares - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
//Local oSection2 := oReport:Section(2)
Local _cAlias1	:= GetNextAlias()
//Local _cAlias2	:= GetNextAlias()
Local _cQuery	:= ""

Local _cProduto := MntStrPsq(MV_PAR01)

If oReport:NDEVICE <> 4
	MsgInfo("Este relatório somente poderá ser impresso em Excel.")
	Return(.t.)
Endif

 
_cQuery := "SELECT I10.SIGLAGEN, TRIM(B1_COD) B1_COD, TRIM(B1_ISBN) B1_ISBN, TRIM(B1_DESC) B1_DESC,
_cQuery += "       TRIM(XZ4.X5_DESCRI) TIPO_PUBLICACAO, TRIM(SZ4.Z4_DESC) SITUACAO_OBRA,
_cQuery += "       CST.CUSTO, E.BOM, E.CONSIGNACAO, E.RESERVA, E.RESERVA_PEDIDO, E.PRESTA_CONTAS,
_cQuery += "       E.DEFEITO, E.TRANSITO, E.CORTE, E.BOM-E.RESERVA_PEDIDO DISPONIVEL,
_cQuery += "       CASE WHEN SUBSTR('" + MV_PAR02 + "',1,2) = '10' 
_cQuery += "            THEN E.BOM+E.CONSIGNACAO+E.PRESTA_CONTAS+E.DEFEITO+E.RESERVA+E.TRANSITO+E.CORTE
_cQuery += "            ELSE E.BOM+E.PRESTA_CONTAS+E.DEFEITO+E.RESERVA+E.TRANSITO+E.CORTE END TOTAL,
_cQuery += "       CASE WHEN SUBSTR('" + MV_PAR02 + "',1,2) = '10' 
_cQuery += "            THEN (E.BOM+E.CONSIGNACAO+E.PRESTA_CONTAS+E.DEFEITO+E.RESERVA+E.TRANSITO+E.CORTE) 
_cQuery += "            ELSE (E.BOM+E.PRESTA_CONTAS+E.DEFEITO+E.RESERVA+E.TRANSITO+E.CORTE) END * NVL(CST.CUSTO,0) CUSTOTOTAL
_cQuery += "  FROM " + RetSqlName("SB1") + " SB1
_cQuery += " INNER JOIN (SELECT B2_COD, SUM(BOM) BOM, SUM(RESERVA_PEDIDO) RESERVA_PEDIDO, SUM(PRESTA_CONTAS) PRESTA_CONTAS, SUM(DEFEITO) DEFEITO,
_cQuery += "                    SUM(RESERVA) RESERVA, SUM(TRANSITO) TRANSITO, SUM(CORTE) CORTE, SUM(CONSIGNACAO) CONSIGNACAO
_cQuery += "               FROM (SELECT B2_COD, B2_QATU BOM, B2_RESERVA RESERVA_PEDIDO, 0 PRESTA_CONTAS, 0 DEFEITO, 0 RESERVA, 0 TRANSITO, 0 CORTE, 0 CONSIGNACAO
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '01'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                      UNION ALL
_cQuery += "                     SELECT B2_COD, 0, 0, B2_QATU, 0, 0, 0, 0, 0
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '02'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                      UNION ALL
_cQuery += "                     SELECT B2_COD, 0, 0, 0, B2_QATU, 0, 0, 0, 0
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '03'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                      UNION ALL
_cQuery += "                     SELECT B2_COD, 0, 0, 0, 0, B2_QATU, 0, 0, 0
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '04'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                      UNION ALL
_cQuery += "                     SELECT B2_COD, 0, 0, 0, 0, 0, B2_QATU, 0, 0
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '05'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                      UNION ALL
_cQuery += "                     SELECT B2_COD, 0, 0, 0, 0, 0, 0, B2_QATU, 0
_cQuery += "                       FROM " + RetSqlName("SB2")
_cQuery += "                      WHERE B2_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                        AND B2_LOCAL = '06'
_cQuery += "                        AND D_E_L_E_T_  = ' '
_cQuery += "                     UNION ALL
_cQuery += "                    SELECT B6_PRODUTO, 0, 0, 0, 0, 0, 0, 0, SUM(B6_SALDO)
_cQuery += "                      FROM " + RetSqlName("SB6")
_cQuery += "                     WHERE B6_FILIAL = '" + MV_PAR02 + "'"
_cQuery += "                       AND B6_LOCAL = '01'
_cQuery += "                       AND B6_TIPO = 'E'
_cQuery += "                       AND D_E_L_E_T_  = ' '
_cQuery += "                     GROUP BY B6_PRODUTO)
_cQuery += "              GROUP BY B2_COD) E
_cQuery += "    ON SB1.B1_COD = E.B2_COD
_cQuery += "  LEFT JOIN (SELECT SB9.B9_COD, SB9.B9_CM1 CUSTO
_cQuery += "               FROM " + RetSqlName("SB9") + " SB9, " + RetSqlName("SB1") + " SB1
_cQuery += "              WHERE SB9.B9_COD = SB1.B1_COD
_cQuery += "                AND SB9.B9_LOCAL = '01'
_cQuery += "                AND SB9.B9_FILIAL = DECODE(B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
_cQuery += "                AND SB9.D_E_L_E_T_ = ' '
_cQuery += "                AND SB9.B9_DATA = (SELECT MAX(B9_DATA)
_cQuery += "                                     FROM " + RetSqlName("SB9") + ", " + RetSqlName("SB1")
_cQuery += "                                    WHERE SB9000.B9_COD = SB1000.B1_COD
_cQuery += "                                      AND SB9000.B9_COD = SB9.B9_COD
_cQuery += "                                      AND SB9000.B9_LOCAL = '01'
_cQuery += "                                      AND SB9000.B9_FILIAL = DECODE(SB1000.B1_PROC,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','378803 ','1022')
_cQuery += "                                      AND SB9000.D_E_L_E_T_ = ' ')) CST
_cQuery += "    ON E.B2_COD = CST.B9_COD
_cQuery += "  LEFT JOIN TT_I10_FILIAL_GEN_TOTVS I10
_cQuery += "    ON TO_NUMBER(TRIM(SB1.B1_XEMPRES)) = I10.IDEMPRESAGEN
_cQuery += " INNER JOIN " + RetSqlName("SX5") + " XZ4
_cQuery += "    ON SB1.B1_XIDTPPU = XZ4.X5_CHAVE
_cQuery += "   AND XZ4.X5_TABELA = 'Z4'
//_cQuery += "   AND TRIM(XZ4.X5_DESCENG) = '0'
_cQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery += "   AND XZ4.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN	" + RetSqlName("SZ4") + " SZ4
_cQuery += "	  ON SB1.B1_XSITOBR = SZ4.Z4_COD
_cQuery += "	 AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "'"
_cQuery += "	 AND SZ4.D_E_L_E_T_ = ' '
_cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB1.B1_XIDTPPU NOT IN ('11','15')
_cQuery += "   AND SB1.B1_TIPO <> 'SV'
_cQuery += "   AND CASE WHEN TRIM(SB1.B1_XSITOBR) IN ('103','109') AND E.BOM+E.CONSIGNACAO+E.PRESTA_CONTAS+E.DEFEITO+E.RESERVA+E.TRANSITO+E.CORTE = 0 THEN 0 ELSE 1 END = 1
If !Empty(MV_PAR01)
	_cQuery += "   AND SB1.B1_ISBN IN ("+_cProduto+")
EndIf
_cQuery += " ORDER BY CUSTOTOTAL DESC, B1_COD

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("SIGLAGEN"):SetValue((_cAlias1)->SIGLAGEN)
	oSection1:Cell("B1_COD"):SetValue((_cAlias1)->B1_COD)
	oSection1:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
	oSection1:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
	oSection1:Cell("TIPO_PUBLICACAO"):SetValue((_cAlias1)->TIPO_PUBLICACAO)
	oSection1:Cell("SITUACAO_OBRA"):SetValue((_cAlias1)->SITUACAO_OBRA)
	oSection1:Cell("CUSTO"):SetValue((_cAlias1)->CUSTO)
	oSection1:Cell("BOM"):SetValue((_cAlias1)->BOM)
	oSection1:Cell("RESERVA_PEDIDO"):SetValue((_cAlias1)->RESERVA_PEDIDO)
	oSection1:Cell("DISPONIVEL"):SetValue((_cAlias1)->DISPONIVEL)
	oSection1:Cell("CONSIGNACAO"):SetValue((_cAlias1)->CONSIGNACAO)
	oSection1:Cell("PRESTA_CONTAS"):SetValue((_cAlias1)->PRESTA_CONTAS)
	oSection1:Cell("DEFEITO"):SetValue((_cAlias1)->DEFEITO)
	oSection1:Cell("RESERVA"):SetValue((_cAlias1)->RESERVA)
	oSection1:Cell("TRANSITO"):SetValue((_cAlias1)->TRANSITO)
	oSection1:Cell("CORTE"):SetValue((_cAlias1)->CORTE)
	oSection1:Cell("TOTAL"):SetValue((_cAlias1)->TOTAL)
	oSection1:Cell("CUSTOTOTAL"):SetValue((_cAlias1)->CUSTOTOTAL)

	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()
         
DbSelectArea(_cAlias1)
DbCloseArea()
/*
_cQuery := ""

_cQuery := "SELECT SD2.D2_PEDIDO, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_CLIENTE, SD2.D2_LOJA, TRIM(SA1.A1_NOME) A1_NOME, 
_cQuery += "       SD2.D2_COD, SB1.B1_ISBN, TRIM(SB1.B1_DESC) B1_DESC, SD2.D2_VALBRUT, SD2.D2_QUANT,
_cQuery += "       DECODE(SPD.STATUS,'1','NFe Recebida','2','NFe Assinada','3','NFe com falha no schema XML','4','NFe sendo transmitida','5','NFe com problemas', NULL,'Não transmitida') STATUS
_cQuery += "  FROM " + RetSqlName("SD2") + " SD2
_cQuery += "  JOIN " + RetSqlName("SA1") + " SA1
_cQuery += "    ON SA1.A1_COD = SD2.D2_CLIENTE
_cQuery += "   AND SA1.A1_LOJA = SD2.D2_LOJA
_cQuery += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "    ON SB1.B1_COD = SD2.D2_COD
_cQuery += "   AND SB1.B1_ISBN IN ("+_cProduto+")
_cQuery += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SF4") + " SF4
_cQuery += "    ON SF4.F4_CODIGO = SD2.D2_TES
_cQuery += "   AND SF4.F4_ESTOQUE = 'S'
_cQuery += "   AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "   AND SF4.D_E_L_E_T_ = ' '
_cQuery += "  JOIN " + RetSqlName("SF2") + " SF2
_cQuery += "    ON SF2.F2_FILIAL = SD2.D2_FILIAL
_cQuery += "   AND SF2.F2_SERIE = SD2.D2_SERIE
_cQuery += "   AND SF2.F2_DOC = SD2.D2_DOC
_cQuery += "   AND SF2.F2_TIPO = SD2.D2_TIPO
_cQuery += "   AND SF2.F2_CHVNFE = ' '
_cQuery += "   AND SF2.F2_FILIAL = '" + xFilial("SF2") + "'"
_cQuery += "   AND SF2.D_E_L_E_T_ = ' '
_cQuery += "  LEFT JOIN SPED050 SPD
_cQuery += "    ON TRIM(SPD.NFE_ID) = (SD2.D2_SERIE || SD2.D2_DOC)
_cQuery += "   AND SPD.STATUS NOT IN ('6','7') 
_cQuery += "   AND SPD.D_E_L_E_T_ = ' '
_cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "   AND SD2.D2_EMISSAO >= '20160101'
_cQuery += "   AND SD2.D_E_L_E_T_ = ' '
_cQuery += "   AND NOT EXISTS (SELECT 1
_cQuery += "                     FROM SPED050 SPD
_cQuery += "                    WHERE SPD.D_E_L_E_T_ = ' '
_cQuery += "                      AND TRIM(SD2.D2_SERIE || SD2.D2_DOC) = TRIM(SPD.NFE_ID))
_cQuery += " ORDER BY SD2.D2_PEDIDO

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)
                                                                
Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection2:Init()  

	oSection2:Cell("D2_PEDIDO"):SetValue((_cAlias2)->D2_PEDIDO)
	oSection2:Cell("D2_DOC"):SetValue((_cAlias2)->D2_DOC)
	oSection2:Cell("D2_SERIE"):SetValue((_cAlias2)->D2_SERIE)
	oSection2:Cell("D2_EMISSAO"):SetValue((_cAlias2)->D2_EMISSAO)
	oSection2:Cell("D2_CLIENTE"):SetValue((_cAlias2)->D2_CLIENTE)
	oSection2:Cell("D2_LOJA"):SetValue((_cAlias2)->D2_LOJA)
	oSection2:Cell("A1_NOME"):SetValue((_cAlias2)->A1_NOME)
	oSection2:Cell("D2_COD"):SetValue((_cAlias2)->D2_COD)
	oSection2:Cell("B1_ISBN"):SetValue((_cAlias2)->B1_ISBN)
	oSection2:Cell("B1_DESC"):SetValue((_cAlias2)->B1_DESC)
	oSection2:Cell("D2_VALBRUT"):SetValue((_cAlias2)->D2_VALBRUT)
	oSection2:Cell("D2_QUANT"):SetValue((_cAlias2)->D2_QUANT)
	oSection2:Cell("STATUS"):SetValue((_cAlias2)->STATUS)

	oSection2:PrintLine()

	(_cAlias2)->(dbSkip())		
EndDo
oSection2:Finish()
         
DbSelectArea(_cAlias2)
DbCloseArea()
*/
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
