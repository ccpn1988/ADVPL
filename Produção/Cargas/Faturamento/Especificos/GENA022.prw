#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function tMata140()

Local nOpc := 0
private aCabec:= {}
private aItens:= {}
private aLinha:= {}
Private lMsErroAuto := .F.

_cQuery := "SELECT SB6.B6_CLIFOR||SB6.B6_LOJA CLI_LOJA, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_NOME, SA3.A3_NOME, SA1.A1_MUN, SA1.A1_EST,
_cQuery += "       SB6.B6_PRODUTO, SB1.B1_ISBN, SB1.B1_DESC, TRIM(Z1.X5_DESCRI) SELO, SB1.B1_XSITOBR, TRIM(Z5.X5_DESCRI) SITUACAOOBRA,
_cQuery += "       DA1.DA1_PRCVEN, SZ2.Z2_PERCDES, SB6.B6_SALDO, SB6.B6_SALDO * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100)) VALOR
_cQuery += "  FROM " + RetSqlName("SA1") + " SA1, " + RetSqlName("SA3") + " SA3, " + RetSqlName("SB1") + " SB1,
_cQuery += "       " + RetSqlName("SB5") + " SB5, " + RetSqlName("SX5") + " Z1, " + RetSqlName("DA1") + " DA1,
_cQuery += "       " + RetSqlName("SZ2") + " SZ2, " + RetSqlName("SX5") + " Z5, " + RetSqlName("SA2") + " SA2,
_cQuery += "       (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
_cQuery += "          FROM " + RetSqlName("SB6")
_cQuery += "         WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
_cQuery += "           AND B6_TIPO    = 'E'
_cQuery += "           AND B6_PODER3  = 'R'
_cQuery += "           AND B6_TPCF    = 'C'
_cQuery += "           AND D_E_L_E_T_ = ' '
_cQuery += "         GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) SB6
_cQuery += " WHERE SB6.B6_CLIFOR  = SA1.A1_COD
_cQuery += "   AND SB6.B6_LOJA    = SA1.A1_LOJA
_cQuery += "   AND SA1.A1_VEND    = SA3.A3_COD
_cQuery += "   AND SB6.B6_PRODUTO = SB1.B1_COD
_cQuery += "   AND SB1.B1_COD     = SB5.B5_COD
_cQuery += "   AND SB5.B5_XSELO   = Z1.X5_CHAVE
_cQuery += "   AND SB1.B1_XSITOBR = Z5.X5_CHAVE
_cQuery += "   AND SB1.B1_COD     = DA1.DA1_CODPRO
_cQuery += "   AND SZ2.Z2_CLASSE  = SB1.B1_GRUPO
_cQuery += "   AND SZ2.Z2_TIPO    = SA1.A1_XTPDES
_cQuery += "   AND SB1.B1_PROC    = SA2.A2_COD
_cQuery += "   AND SB1.B1_LOJPROC = SA2.A2_LOJA
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "   AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery += "   AND Z1.X5_FILIAL   = '" + xFilial("Z1") + "'"
_cQuery += "   AND Z5.X5_FILIAL   = '" + xFilial("Z5") + "'"
_cQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
_cQuery += "   AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
_cQuery += "   AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
_cQuery += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery += "   AND SA3.D_E_L_E_T_ = ' '
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery += "   AND Z1.D_E_L_E_T_  = ' '
_cQuery += "   AND Z5.D_E_L_E_T_  = ' '
_cQuery += "   AND DA1.D_E_L_E_T_ = ' '
_cQuery += "   AND SZ2.D_E_L_E_T_ = ' '
_cQuery += "   AND SA2.D_E_L_E_T_ = ' '
_cQuery += "   AND Z1.X5_TABELA   = 'Z1'
_cQuery += "   AND Z5.X5_TABELA   = 'Z5'
_cQuery += "   AND DA1.DA1_CODTAB = '150'
_cQuery += "   AND SB6.B6_SALDO  <> 0
_cQuery += "   AND SA2.A2_COD = '"+MV_PAR01+"'
_cQuery += "   AND SA2.A2_LOJA = '"+MV_PAR02+"'
_cQuery += "   AND SB1.B1_XSITOBR = '"+MV_PAR03+"'
_cQuery += "   AND SA1.A1_COD = '"+MV_PAR04+"'
_cQuery += "   AND SA1.A1_LOJA = '"+MV_PAR05+"'
_cQuery += "   AND SA1.A1_GRPVEN = '"+MV_PAR06+"'
_cQuery += " ORDER BY SA1.A1_COD, SA1.A1_LOJA, SB1.B1_PROC, SB5.B5_XSELO, SB1.B1_DESC


aCabec := {}
aLinCab := {}
aAdd(aLinCab,{'F1_TIPO'		,'B'									,NIL})
aAdd(aLinCab,{'F1_FORMUL'	,'N'									,NIL})
aAdd(aLinCab,{'F1_DOC'		,padl("9",tamsx3("F1_DOC")[1],"9")		,NIL})
aAdd(aLinCab,{'F1_SERIE'	,padl("9",tamsx3("F1_SERIE")[1],"9")	,NIL})
aAdd(aLinCab,{'F1_EMISSAO'	,dDataBase								,NIL})
aAdd(aLinCab,{'F1_FORNECE'	,'000002'								,NIL})
aAdd(aLinCab,{'F1_LOJA'		,'01'									,NIL})
aAdd(aLinCab,{'F1_COND'		,'001'									,NIL})
aAdd(aCabec,aLinCab)

aItens := {}
Do While !EOF()
	aLinIt := {}
	aAdd(aLinIt,{'D1_COD'		,"PA02"		,NIL})
	aAdd(aLinIt,{'D1_UM'		,'UN'		,NIL})
	aAdd(aLinIt,{'D1_QUANT'		,1			,NIL})
	aAdd(aLinIt,{'D1_VUNIT'		,10000		,NIL})
	aAdd(aLinIt,{'D1_TOTAL'		,10000		,NIL})
	aAdd(aLinIt,{'D1_PEDIDO'	,'000009'	,NIL})
	aAdd(aLinIt,{'D1_ITEMPC'	,'0001'		,NIL})
	aAdd(aLinIt,{'D1_LOCAL'		,'01'		,NIL})
	aAdd(aItens,aLinIt)
	dbSkip()
EndDo

nOpc := 3

MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCabec, aItens, nOpc)
If lMsErroAuto
	mostraerro()
Else
	Alert("Ponto de entrada MATA140 executado com sucesso!")
EndIf

Return()
