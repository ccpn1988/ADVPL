#include "protheus.ch"
#include "topconn.ch"

User Function GER068()             

Local oReport
Local cPerg := "GER068"

/*
U_xGPutSx1(cPerg, "01", "Cliente"		,	"", "","mv_ch1","C", TamSx3("A1_COD")[1], 0, 0, "G","", "SA1", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "02", "Loja"			,	"", "","mv_ch2","C", TamSx3("A1_LOJA")[1], 0, 0, "G","", ""	, "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "03", "Data inicial"	,	"", "","mv_ch3","D", 08,0,0,"G","","","","","mv_par03" , ""    ,""     ,""       ,"","","","","","","" )
U_xGPutSx1(cPerg, "04", "Data final"	,	"", "","mv_ch4","D", 08,0,0,"G","","","","","mv_par04" , ""    ,""     ,""       ,"","","","","","","" )
U_xGPutSx1(cPerg, "05", "De Orçamento"	,	"", "","mv_ch5","C", TamSx3("C7_NUM")[1], 0, 0, "G","", "SCJ", "", "", "MV_PAR05","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "06", "Até Orçamento",	"", "","mv_ch6","C", TamSx3("C7_NUM")[1], 0, 0, "G","", "SCJ", "", "", "MV_PAR06","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "07", "Situação"		,	"", "","mv_ch7","N", 1, 0, 2,"C","", "", "", "", "MV_PAR07","Todas","Todos","Todos","","Aberto","Aberto","Aberto","Baixado","Baixado","Baixado","Cancelado","Cancelado","Cancelado","","","")     
U_xGPutSx1(cPerg, "08", "Usr.Inclusão"	,	"", "","mv_ch8","C", TamSx3("CJ_XINCUSR")[1], 0, 0,"C","", "", "", "", "MV_PAR08","","","","","","","","","","","","","","","","")

*/
//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return nil
EndIf

oReport:= ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection2
Local oSection3
Local aOrd		:= {"Numero","Cliente"} //,STR0029}	//"Numero"###"Cliente"###"Produto"

//Declaracao do relatorio
oReport := TReport():New("GER068","GER068 - RELAÇÃO DE ORÇAMENTOS DE VENDA",cPerg,{|oReport| PrintReport(oReport)},"GER068 - RELAÇÃO DE ORÇAMENTOS DE VENDA",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    
oReport:SetLandScape()

oSection2 := TRSection():New(oReport,"Cliente","SCJ")

//Celulas da secao
TRCell():New(oSection2,"CJ_NUM"		, "SCJ", "Orçamento"	)
TRCell():New(oSection2,"CJ_CLIENTE", "SCJ", "Cliente"	)
TRCell():New(oSection2,"CJ_LOJA", "SCJ", "Loja"	)
TRCell():New(oSection2,"A1_NOME", "SA1", "Nome"	)
TRCell():New(oSection2,"E4_DESCRI"	,"SE4","Cond.Pgto.")
TRCell():New(oSection2,"CK_VALOR"	,"SCK","Valor Total")
TRCell():New(oSection2,"CK_VALDESC","SCK","Total Desconto")
TRCell():New(oSection2,"BRUTO"		,"SCK","Total Bruto")
TRCell():New(oSection2,"A1_TPFRET"	, "SA'", "Tp.Frete")
TRCell():New(oSection2,"A3_NOME"	,"SA3","Vendedor")
TRCell():New(oSection2,"CJ_XINCUSR","SCJ","Usuário Inclusão")
TRCell():New(oSection2,"CJ_XAPROVA","SCJ","Usuário Aprovador")
TRCell():New(oSection2,"CJ_XEFETIV","SCJ","Usuário Efetivação")
TRCell():New(oSection2,"CJ_EMISSAO","SCJ","Emissão Orçamento")
TRCell():New(oSection2,"CJ_STATUS","SCJ","Situação")                                                                                     

Return oReport


Static Function PrintReport(oReport)

Local oSection2 	:= nil    
Local _cQuery   	:= ""
Local _cAlias1  	:= GetNextAlias()
Local xCliente  	:= ""
Local cStatus		:= ""

oSection2 := oReport:Section(1)

_cQuery := "SELECT CJ_FILIAL, CJ_NUM, CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, A1_NOME, A3_NOME, CJ_STATUS,
_cQuery += "       E4_DESCRI, DECODE(A1_TPFRET, 'C', 'CIF', 'F', 'FOB') A1_TPFRET,
_cQuery += "       CJ_XINCUSR,CJ_XAPROVA,CJ_XEFETIV,CJ_EMISSAO
_cQuery += " ,SUM(CK_VALOR) TOTAL "
_cQuery += ' ,SUM(CK_VALDESC) "DESC"'

_cQuery += "  FROM " + RetSqlName("SCJ") + " SCJ, " + RetSqlName("SCK") + " SCK,
_cQuery += "       " + RetSqlName("SA1") + " SA1, 
_cQuery += "       " + RetSqlName("SA3") + " SA3, " + RetSqlName("SE4") + " SE4
_cQuery += " WHERE SCJ.CJ_FILIAL  = SCK.CK_FILIAL
_cQuery += "   AND SCJ.CJ_NUM     = SCK.CK_NUM
_cQuery += "   AND SCJ.CJ_CLIENTE = SA1.A1_COD
_cQuery += "   AND SCJ.CJ_LOJA    = SA1.A1_LOJA
_cQuery += "   AND SA1.A1_VEND    = SA3.A3_COD
_cQuery += "   AND SA1.A1_COND    = SE4.E4_CODIGO
_cQuery += "   AND SCJ.CJ_FILIAL  = '" + xFilial("SCJ") + "'"
_cQuery += "   AND SCK.CK_FILIAL  = '" + xFilial("SCK") + "'"
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery += "   AND SE4.E4_FILIAL  = '" + xFilial("SE4") + "'"
_cQuery += "   AND SCJ.D_E_L_E_T_ = ' '
_cQuery += "   AND SCK.D_E_L_E_T_ = ' '

If !Empty(MV_PAR01)
	_cQuery += "   AND SCJ.CJ_CLIENTE	= '"+MV_PAR01+"'"
EndIf
If !Empty(MV_PAR02)
	_cQuery += "   AND SCJ.CJ_LOJA		= '"+MV_PAR02+"'"
EndIf

_cQuery += "   AND SCJ.CJ_EMISSAO >= '"+DtoS(MV_PAR03)+"' AND SCJ.CJ_EMISSAO <= '"+ DtoS(MV_PAR04)+"'"
_cQuery += "   AND SCJ.CJ_NUM     >= '"+MV_PAR05+"' AND SCJ.CJ_NUM     <= '"+MV_PAR06+"'"

If !Empty(MV_PAR08)
	_cQuery += "   AND Upper(SCJ.CJ_XINCUSR) LIKE '%"+Upper(AllTrim(MV_PAR08))+"%'"
EndIf

If MV_PAR07 <> 1
	//A=Aberto;B=Aprovado;C=Cancelado;D=Noo Orþado
	Do Case
		Case MV_PAR07 == 2
			_cQuery += "   AND SCJ.CJ_STATUS = 'A' "
		Case MV_PAR07 == 3
			_cQuery += "   AND SCJ.CJ_STATUS = 'B' "
		Case MV_PAR07 == 4	
			_cQuery += "   AND SCJ.CJ_STATUS = 'C' "
	EndCase
EndIf	  

_cQuery += " GROUP BY CJ_FILIAL, CJ_NUM, CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, A1_NOME, A3_NOME, CJ_STATUS,
_cQuery += "       E4_DESCRI, A1_TPFRET,
_cQuery += "       CJ_USERLGI,CJ_XAPROVA,CJ_XEFETIV,CJ_XINCUSR

_cQuery += " ORDER BY CJ_CLIENTE, CJ_LOJA, CJ_NUM,CJ_XINCUSR

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	cStatus	:= ""
	xCliente	:= (_cAlias1)->CJ_CLIENTE+(_cAlias1)->CJ_LOJA

	oReport:IncMeter()

	oSection2:Init()  
	oSection2:SetHeaderSection(.T.)

	oSection2:Cell("CJ_NUM"):SetValue((_cAlias1)->CJ_NUM)
	oSection2:Cell("CJ_CLIENTE"):SetValue((_cAlias1)->CJ_CLIENTE)
	oSection2:Cell("CJ_LOJA"):SetValue((_cAlias1)->CJ_LOJA)
	oSection2:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	oSection2:Cell("E4_DESCRI"):SetValue((_cAlias1)->E4_DESCRI)
	oSection2:Cell("A1_TPFRET"):SetValue((_cAlias1)->A1_TPFRET)
	oSection2:Cell("A3_NOME"):SetValue((_cAlias1)->A3_NOME)	
	oSection2:Cell("CK_VALOR"):SetValue((_cAlias1)->TOTAL)
	oSection2:Cell("CK_VALDESC"):SetValue((_cAlias1)->DESC)
	oSection2:Cell("BRUTO"):SetValue((_cAlias1)->TOTAL+(_cAlias1)->DESC)

	oSection2:Cell("CJ_XINCUSR"):SetValue((_cAlias1)->CJ_XINCUSR)
	oSection2:Cell("CJ_XAPROVA"):SetValue((_cAlias1)->CJ_XAPROVA)
	oSection2:Cell("CJ_XEFETIV"):SetValue((_cAlias1)->CJ_XEFETIV)
	oSection2:Cell("CJ_EMISSAO"):SetValue(StoD((_cAlias1)->CJ_EMISSAO))
	
	Do Case
		Case (_cAlias1)->CJ_STATUS == "A"
			cStatus := "Aberto"
		Case (_cAlias1)->CJ_STATUS == "B"
			cStatus := "Aprovado"
		Case (_cAlias1)->CJ_STATUS == "C"
			cStatus := "Cancelado"
		Case (_cAlias1)->CJ_STATUS == "D"
			cStatus := "Não Orçado"
		Case (_cAlias1)->CJ_STATUS == "F"
			cStatus := "Bloqueado"		 
	EndCase
		
	oSection2:Cell("CJ_STATUS"):SetValue(cStatus)
	
	oSection2:PrintLine()
	(_cAlias1)->(dbSkip())	
			
EndDo

oSection2:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

	
Return(.t.)