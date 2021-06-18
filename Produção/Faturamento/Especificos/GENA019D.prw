#INCLUDE "rwmake.ch"

User Function GENA019D             

Local oReport
Local cPerg := "GENA019A"

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("GENA019D","Prestação de Contas",cPerg,{|oReport| PrintReport(oReport)},"Prévia da Prestação de Contas")

//Ajuste nas definicoes
//oReport:nLineHeight := 50
//oReport:cFontBody 	:= "Courier New"
//oReport:nFontBody 	:= 9    		&& 10
//oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SZA")

//Celulas da secao  
TRCell():New(oSection1,"PRES"		,"   ","Prestação"	,"@!"				,12)
TRCell():New(oSection1,"EMP"		,"   ","Empresa"	,"@!"				,12)
TRCell():New(oSection1,"TIPO"		,"   ","Operação"	,"@!"				,12)
TRCell():New(oSection1,"SERIE"		,"   ","Serie"		,"@!"				,03)
TRCell():New(oSection1,"DOC"		,"   ","Nota"		,"@!"				,09)
TRCell():New(oSection1,"ITEM"		,"   ","Item"		,"@!"				,04)
TRCell():New(oSection1,"PROD"		,"   ","Produto"	,"@!"				,20)
TRCell():New(oSection1,"DSCR"		,"   ","Descrição"	,"@!"				,30)
TRCell():New(oSection1,"ISBN"		,"   ","Isbn"		,"@!"				,20)
TRCell():New(oSection1,"PUBI"		,"   ","Publicação"	,"@!"				,20)
TRCell():New(oSection1,"VQTD"		,"   ","Quant Venda","@E 999,999,999.99",15)
TRCell():New(oSection1,"DQTD"		,"   ","Quant Devol","@E 999,999,999.99",15)
TRCell():New(oSection1,"CQTD"		,"   ","Quant Cance","@E 999,999,999.99",15)
TRCell():New(oSection1,"PRECO"		,"   ","Preço na NF","@E 999,999,999.99",15)
TRCell():New(oSection1,"TOTAL"		,"   ","Total na NF","@E 999,999,999.99",15)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("ZA_PROC"),"Subtotal",.f.)

//Totalizadores
TRFunction():New(oSection1:Cell("VQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1) 
TRFunction():New(oSection1:Cell("DQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1) 
TRFunction():New(oSection1:Cell("CQTD"),, "SUM",,,,,.T.,.F.,.F., oSection1) 

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()

MV_PAR04 := Alltrim(Str(MV_PAR04)) 

//Query para pegar os TES que serão utilizados no processo de consignação³
_cSQL := " SELECT F4_CODIGO, F4_XPRCONT, F4_XTPCONT
_cSQL += " FROM " + RetSqlName("SF4") + " SF4
_cSQL += " WHERE F4_XPRCONT = 'S'
_cSQL += " AND F4_XTPCONT = '" + MV_PAR04 + "'
_cSQL += " AND D_E_L_E_T_ = ' '

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

_cTesPr := "" //Limpando a variavel

While (_cAlias1)->(!EOF())
	_cTesPr += (_cAlias1)->F4_CODIGO + "','"
	(_cAlias1)->(DbSkip())
EndDo

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

_cTesPr := Substr(_cTesPr,1,Len(_cTesPr)-3) 

_cSQL := " SELECT 'VENDA' AS TIPO,
_cSQL += "   D2_SERIE AS SERIE,
_cSQL += "   D2_DOC AS DOC,
_cSQL += "   D2_ITEM AS ITEM,
_cSQL += "   D2_COD AS PROD,
_cSQL += "   B1_ISBN AS ISBN,
_cSQL += "   B1_DESC AS DSCR,
_cSQL += "   X5_DESCRI AS PUBI,
_cSQL += "   D2_QUANT  AS VQTD ,
_cSQL += "   0         AS DQTD,
_cSQL += "   0         AS CQTD,
_cSQL += "   D2_PRCVEN AS PRECO,
_cSQL += "   D2_TOTAL  AS TOTAL
_cSQL += " FROM " + RetSqlName("SD2") + " SD2PR,
_cSQL += "   " + RetSqlName("SB1") + " SB1
_cSQL += " INNER JOIN " + RetSqlName("SZ4") + " SZ4
_cSQL += " ON SB1.B1_XSITOBR   = SZ4.Z4_COD
_cSQL += " AND SZ4.Z4_MSBLQL   = '2'
_cSQL += " AND SZ4.Z4_FILIAL   = '"+xFilial("SZ4")+"'
_cSQL += " AND SZ4.D_E_L_E_T_  = ' '
_cSQL += " LEFT JOIN " + RetSqlName("SX5") + " SX5_1 
_cSQL += " ON SX5_1.X5_FILIAL = '"+xFilial("SX5")+"'
_cSQL += " AND SX5_1.X5_TABELA = 'Z4'
_cSQL += " AND SX5_1.X5_CHAVE = SB1.B1_XIDTPPU
_cSQL += " WHERE SD2PR.D2_TES IN ('" + _cTesPr + "')
_cSQL += " AND SD2PR.D2_COD    = SB1.B1_COD
_cSQL += " AND SD2PR.D2_FILIAL = '"+xFilial("SD2")+"'
_cSQL += " AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "'
_cSQL += " AND SD2PR.D_E_L_E_T_ = ' '
_cSQL += " AND SB1.B1_FILIAL    = '"+xFilial("SB1")+"'
_cSQL += " AND SB1.D_E_L_E_T_   = ' '
_cSQL += " AND SB1.B1_ISBN     <> ' '
_cSQL += " AND SB1.B1_PROC      = '"+MV_PAR02+"'
_cSQL += " AND SB1.B1_LOJPROC   = '"+MV_PAR03+"'
_cSQL += " UNION ALL
_cSQL += " SELECT 'DEVOLUÇÕES',
_cSQL += "   D1_SERIE,
_cSQL += "   D1_DOC,
_cSQL += "   D1_ITEM,
_cSQL += "   D1_COD,
_cSQL += "   B1_ISBN,
_cSQL += "   B1_DESC,   
_cSQL += "   X5_DESCRI,
_cSQL += "   0,
_cSQL += "   D1_QUANT,
_cSQL += "   0,
_cSQL += "   D1_VUNIT,
_cSQL += "   D1_TOTAL
_cSQL += " FROM SD1000 SD1SE,
_cSQL += "   " + RetSqlName("SB1") + " SB1
_cSQL += " INNER JOIN " + RetSqlName("SZ4") + " SZ4
_cSQL += " ON SB1.B1_XSITOBR   = SZ4.Z4_COD
_cSQL += " AND SZ4.Z4_MSBLQL   = '2'
_cSQL += " AND SZ4.Z4_FILIAL   = '"+xFilial("SZ4")+"'
_cSQL += " AND SZ4.D_E_L_E_T_  = ' '
_cSQL += " LEFT JOIN " + RetSqlName("SX5") + " SX5_1 
_cSQL += " ON SX5_1.X5_FILIAL = '"+xFilial("SX5")+"'
_cSQL += " AND SX5_1.X5_TABELA = 'Z4'
_cSQL += " AND SX5_1.X5_CHAVE = SB1.B1_XIDTPPU
_cSQL += " WHERE SD1SE.D1_TES IN ('" + _cTesPr + "')
_cSQL += " AND SD1SE.D1_COD    = SB1.B1_COD
_cSQL += " AND SD1SE.D1_FILIAL = '"+xFilial("SD1")+"'
_cSQL += " AND SD1SE.D1_EMISSAO BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "'
_cSQL += " AND SD1SE.D_E_L_E_T_ = ' '
_cSQL += " AND SB1.B1_FILIAL    = '"+xFilial("SB1")+"'
_cSQL += " AND SB1.D_E_L_E_T_   = ' '
_cSQL += " AND SB1.B1_ISBN     <> ' '
_cSQL += " AND SB1.B1_PROC      = '"+MV_PAR02+"'
_cSQL += " AND SB1.B1_LOJPROC   = '"+MV_PAR03+"'
_cSQL += " UNION ALL
_cSQL += " SELECT 'CANCELAMENTO',
_cSQL += "   D2_SERIE,
_cSQL += "   D2_DOC,
_cSQL += "   D2_ITEM,
_cSQL += "   D2_COD,
_cSQL += "   B1_ISBN,
_cSQL += "   B1_DESC,
_cSQL += "   X5_DESCRI,
_cSQL += "   0,0,
_cSQL += "   D2_QUANT,
_cSQL += "   D2_PRCVEN,
_cSQL += "   D2_TOTAL
_cSQL += " FROM " + RetSqlName("SD2") + " SD2CA,
_cSQL += "   " + RetSqlName("SB1") + " SB1
_cSQL += " INNER JOIN " + RetSqlName("SZ4") + " SZ4
_cSQL += " ON SB1.B1_XSITOBR    = SZ4.Z4_COD
_cSQL += " AND SZ4.Z4_MSBLQL    = '2'
_cSQL += " AND SZ4.Z4_FILIAL    = '"+xFilial("SZ4")+"'
_cSQL += " AND SZ4.D_E_L_E_T_   = ' '   
_cSQL += " LEFT JOIN " + RetSqlName("SX5") + " SX5_1 
_cSQL += " ON SX5_1.X5_FILIAL = '"+xFilial("SX5")+"'
_cSQL += " AND SX5_1.X5_TABELA = 'Z4'
_cSQL += " AND SX5_1.X5_CHAVE = SB1.B1_XIDTPPU
_cSQL += " WHERE SD2CA.D2_COD   = SB1.B1_COD
_cSQL += " AND SD2CA.D2_TES    IN ('" + _cTesPr + "')
_cSQL += " AND SD2CA.D2_FILIAL  = '"+xFilial("SD2")+"'
_cSQL += " AND SD2CA.D_E_L_E_T_ = '*'
_cSQL += " AND SB1.B1_FILIAL    = '"+xFilial("SB1")+"'
_cSQL += " AND SB1.D_E_L_E_T_   = ' '
_cSQL += " AND SB1.B1_ISBN     <> ' '
_cSQL += " AND SB1.B1_PROC      = '"+MV_PAR02+"'
_cSQL += " AND SB1.B1_LOJPROC   = '"+MV_PAR03+"'

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)

If MV_PAR04 == "1"
	_cPrest := "Oferta"
Else            
	_cPrest := "Venda"
Endif  

If MV_PAR02 == "031811 "
	_cEmpProc := "AC"

ElseIf MV_PAR02 == "0380794"
	_cEmpProc := "FORENCE"

ElseIf MV_PAR02 == "0380795"
	_cEmpProc := "EGK"

ElseIf MV_PAR02 == "0380796"
	_cEmpProc := "LTC"
Endif

While (_cAlias2)->(!EOF())

oReport:IncMeter()

	oSection1:Init()  
	
	oSection1:Cell("PRES"):SetValue(_cPrest) 
	oSection1:Cell("EMP"):SetValue(_cEmpProc) 
	oSection1:Cell("TIPO"):SetValue((_cAlias2)->TIPO) 
	oSection1:Cell("SERIE"):SetValue((_cAlias2)->SERIE) 
	oSection1:Cell("DOC"):SetValue((_cAlias2)->DOC) 
	oSection1:Cell("ITEM"):SetValue((_cAlias2)->ITEM) 
	oSection1:Cell("PROD"):SetValue((_cAlias2)->PROD) 
	oSection1:Cell("DSCR"):SetValue((_cAlias2)->DSCR) 
	oSection1:Cell("ISBN"):SetValue((_cAlias2)->ISBN) 
	oSection1:Cell("PUBI"):SetValue((_cAlias2)->PUBI) 
	oSection1:Cell("VQTD"):SetValue((_cAlias2)->VQTD) 
	oSection1:Cell("DQTD"):SetValue((_cAlias2)->DQTD) 
	oSection1:Cell("CQTD"):SetValue((_cAlias2)->CQTD) 
	oSection1:Cell("PRECO"):SetValue((_cAlias2)->PRECO) 
	oSection1:Cell("TOTAL"):SetValue((_cAlias2)->TOTAL) 
	
	oSection1:PrintLine()

	(_cAlias2)->(DbSkip())
EndDo

Return(.t.)