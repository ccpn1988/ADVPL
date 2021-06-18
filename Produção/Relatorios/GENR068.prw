#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "Report.ch"
#INCLUDE "RPTDEF.CH" 
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENR068   ∫Autor  ≥Microsiga        	 ∫ Data ≥  07/01/18   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User function GENR068(cPedido,cEspelho,cFilPed,cVend,cPedCli,cCondPag,cTransp,cTpFrete)

Local oReport
Local cPerg		:= "GENR068"    
Local cTempDir	:= GetTempPath()+"totvsprinter\" 
Local cFilename	:= ""
Local cMailBody	:= ""
Local cQuebra		:= "" 
Local lFileOk		:= .F.
Local lPerg		:= !( !Empty(cPedido) .OR. !Empty(cEspelho) )

Default cCondPag	:= ""
Default cTransp	:= ""
Default cTpFrete	:= ""

//U_xGPutSx1(cPerg, "01", "Nr.Pedido"	, ".", ".", "MV_CH1" , "C", TamSx3("C5_NUM")[1], 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
//U_xGPutSx1(cPerg, "02", "Nr.Espelho"	, ".", ".", "MV_CH2" , "C", TamSx3("ZZB_MSIDEN")[1], 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
//U_xGPutSx1(cPerg, "03", "Filial"		, ".", ".", "MV_CH3" , "C", TamSx3("C5_FILIAL")[1], 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
//U_xGPutSx1(_cPerg, "04", "Tipo"      	, ".", ".", "mv_ch4" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR04","Oferta","Oferta","Oferta","","Venda","Venda","Venda","","","","","","","","","")
//U_xGPutSx1(_cPerg, "05", "Tipo Oferta" , ".", ".", "mv_ch5" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR05","Oferta CRM","Oferta CRM","Oferta CRM","","Oferta DA","Oferta DA","Oferta DA","","","","","","","","","")

If lPerg
	If !Pergunte(cPerg,lPerg)
		Return nil
	Else
		cPedido	:= AllTrim(MV_PAR01)
		cEspelho	:= AllTrim(MV_PAR02)
		cFilPed	:= AllTrim(MV_PAR03)
	EndIf
EndIF	

If !Empty(cEspelho)
	cEspelho := PadL(cEspelho,TamSx3("ZZB_MSIDEN")[1],"0")
EndIf

cFilename	:= IIF(Empty(cEspelho)  , "Pedido_"+cPedido , "Esp_"+cEspelho )

oReport := ReportDef("",cPedido,cEspelho,cFilPed,cVend,cPedCli,cCondPag,cTransp,cTpFrete)

If File(cTempDir+cFilename+".PDF")
	FErase(cTempDir+cFilename+".PDF")
EndIf

If File(cTempDir+cFilename+".PDF")
	FErase(cFilename+AllTrim(CriaTrab(nil,.f.)))
EndIf

oReport:SetDevice(6) 
oReport:SetEnvironment(1)
oReport:SetFile(cFilename)
oReport:NDEVICE		:= 6
oReport:CDIR			:= cTempDir
oReport:CFILE			:= cFilename
oReport:CPATHPDF		:= cTempDir
oReport:nEnvironment	:= 1
oReport:LPREVIEW		:= .t.          
oReport:LVIEWPDF		:= .F.
oReport:Print(.T.)

ShellExecute("Open", cTempDir+cFilename+".pdf", "", cTempDir, 1 )
	
Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg,cPedido,cEspelho,cFilPed,cVend,cPedCli,cCondPag,cTransp,cTpFrete)

Local oReport

oReport := TReport():New("GENR068","Espelho do pedido",cPerg,{|oReport| PrintReport(oReport,cPedido,cEspelho,cFilPed,cVend,cPedCli,cCondPag,cTransp,cTpFrete)},"Espelho do pedido")
/*
//Ajuste nas definicoes
oReport:nLineHeight		:= 50
oReport:cFontBody 		:= "Courier New"
oReport:nFontBody 		:= 9    		&& 10
oReport:lHeaderVisible	:= .T.  
oReport:lDisableOrientation := .T.
*/  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Obra Atendidas Integralmente",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSection1,"C6_ITEM"		,"TMP_ESP","Item",,20)
TRCell():New(oSection1,"C6_PRODUTO"	,"TMP_ESP","Produto",,20)
TRCell():New(oSection1,"B1_ISBN"		,"TMP_ESP","Isbn",,30)
TRCell():New(oSection1,"C6_DESCRI"		,"TMP_ESP","DescriÁ„o - Atendidos Totalmente",,80)
TRCell():New(oSection1,"ZZB_QTDVEN"	,"TMP_ESP","Qtd.Solic.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"C6_QTDVEN"		,"TMP_ESP","Qtd.atend.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection1,"C6_PRCVEN"		,"TMP_ESP","Prc.Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection1,"C6_VALOR"		,"TMP_ESP","Valor Total",'@E 999,999,999.99',20,,,,,"RIGHT")
TRCell():New(oSection1,"C6_PRUNIT"		,"TMP_ESP","Prc.Unit.",'@E 999,999,999.99',17,,,,,"RIGHT")
TRCell():New(oSection1,"C6_DESCONT"	,"TMP_ESP","% Desc."		,'@E 99.99',12,,,,,"RIGHT")
TRCell():New(oSection1,"C6_VALDESC"	,"TMP_ESP","Val.Tot.Desc."	,'@E 999,999,999.99',20,,,,,"RIGHT")
//oSection1:SetPercentage(80)

oSection2 := TRSection():New(oReport,"Obra Atendidas Parcialmente",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSection2,"C6_ITEM"		,"TMP_ESP","Item",,20)
TRCell():New(oSection2,"C6_PRODUTO"	,"TMP_ESP","Produto",,20)
TRCell():New(oSection2,"B1_ISBN"		,"TMP_ESP","Isbn",,30)
TRCell():New(oSection2,"C6_DESCRI"		,"TMP_ESP","DescriÁ„o - Atendidos Parcialmente",,80)
TRCell():New(oSection2,"ZZB_QTDVEN"	,"TMP_ESP","Qtd.Solic.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_QTDVEN"		,"TMP_ESP","Qtd.atend.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_PRCVEN"		,"TMP_ESP","Prc.Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"C6_VALOR"		,"TMP_ESP","Valor Total",'@E 999,999,999.99',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_PRUNIT"		,"TMP_ESP","Prc.Unit.",'@E 999,999,999.99',17,,,,,"RIGHT")
TRCell():New(oSection2,"C6_DESCONT"	,"TMP_ESP","% Desc."		,'@E 99.99',12,,,,,"RIGHT")
TRCell():New(oSection2,"C6_VALDESC"	,"TMP_ESP","Val.Tot.Desc."	,'@E 999,999,999.99',20,,,,,"RIGHT")
//oSection2:SetPercentage(80)

oSection3 := TRSection():New(oReport,"Obra N„o Atendidas",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSection3,"C6_ITEM"		,"TMP_ESP","Item",,20)
TRCell():New(oSection3,"C6_PRODUTO"	,"TMP_ESP","Produto",,20)
TRCell():New(oSection3,"B1_ISBN"		,"TMP_ESP","Isbn",,30)
TRCell():New(oSection3,"C6_DESCRI"		,"TMP_ESP","DescriÁ„o - N„o Atendidos",,80)
TRCell():New(oSection3,"ZZB_QTDVEN"	,"TMP_ESP","Qtd.Solic.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection3,"C6_QTDVEN"		,"TMP_ESP","Qtd.atend.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection3,"C6_PRCVEN"		,"TMP_ESP","Prc.Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection3,"C6_VALOR"		,"TMP_ESP","Valor Total",'@E 999,999,999.99',20,,,,,"RIGHT")
TRCell():New(oSection3,"C6_PRUNIT"		,"TMP_ESP","Prc.Unit.",'@E 999,999,999.99',17,,,,,"RIGHT")
TRCell():New(oSection3,"C6_DESCONT"	,"TMP_ESP","% Desc."		,'@E 99.99',12,,,,,"RIGHT")
TRCell():New(oSection3,"C6_VALDESC"	,"TMP_ESP","Val.Tot.Desc."	,'@E 999,999,999.99',20,,,,,"RIGHT")
//oSection3:SetPercentage(80)

oSecCabec := TRSection():New(oReport,"Dados Espelho do pedido",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSecCabec,"C6_NUM"			,"TMP_ESP","Nr.Pedido",,20)
TRCell():New(oSecCabec,"ZZB_MSIDEN"	,"TMP_ESP","Nr.Espelho",,20)
TRCell():New(oSecCabec,"A1_COD"			,"TMP_ESP","Cod.Cliente",,20)
TRCell():New(oSecCabec,"A1_NREDUZ"		,"TMP_ESP","Nome",,50)
TRCell():New(oSecCabec,"C5_EMISSAO"	,"TMP_ESP","Emiss„o",,20)
TRCell():New(oSecCabec,"C5_XPEDCLI"	,"TMP_ESP","Nr.Ped.Cliente",,20)
TRCell():New(oSecCabec,"TES"			,"TMP_ESP","Tipo Saida",,100)
TRCell():New(oSecCabec,"A3_NOME"		,"TMP_ESP","Vendedor",,20)
TRCell():New(oSecCabec,"CODPAG"		,"TMP_ESP","Cond.Pagt.",,50)

TRCell():New(oSecCabec,"TRANSP"		,"TMP_ESP","Transportadora",,60)
TRCell():New(oSecCabec,"TPFRETE"	,"TMP_ESP","Tipo Frete",,20)
TRCell():New(oSecCabec,"C5_FRETE"	,"TMP_ESP","Val.Frete"	,'@E 999,999.99',20,,,,,"RIGHT")

oSecCabec:SetLineStyle(.T.)
//TRCell():New(oSection1,"ZZB_QTDVEN"	,"TMP_ESP","Qtd.Solic.",'@E 9,999,999',20,,,,,"RIGHT")

oSecLog := TRSection():New(oReport,"OcorrÍncia",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)
//Celulas da secao
TRCell():New(oSecLog,"MSG"			,"","OcorrÍncias",,200)		

/*
//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oSection2:SetTotalInLine(.f.)
oSection3:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)
*/
/*

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")	    	,NIL,"SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("D1_TOTAL")		,NIL,"SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("QUANT")		,NIL,"SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("QTDEDEV")	    ,NIL,"SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("D1_VALDESC")  	,NIL,"SUM",oBreak,,,,.T.,.F.)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)
*/

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport,cPedido,cEspelho,cFilPed,cVend,cPedCli,cCondPag,cTransp,cTpFrete)

Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local oSection3	:= oReport:Section(3)
Local oSecCabec	:= oReport:Section(4)
Local oSecLog		:= nil
Local cAlias1		:= GetNextAlias()
Local cWhere		:= ""
Local nTotAte		:= 0
Local nTotPar		:= 0
Local nTotNao		:= 0
Local cQuery		:= ""
Local lImpLog		:= .T.
Local cDesFre		:= ""
Local aSitAux		:= {.f.,.f.,.f.}

//BeginSQL Alias cAlias1  

cQuery += " SELECT ZZB_FILIAL,C5_TPFRETE,A4_COD||'-'||TRIM(A4_NOME) TRANSP,E4_DESCRI CODPAG,C5_FRETE,TRIM(A3_NOME) A3_NOME,TRIM(F4_TEXTO)||' - '||TRIM(F4_FINALID) TES,B1_ISBN,C5_XPEDCLI,ZZB_EMISSA,A1_COD||A1_LOJA A1_COD,A1_NREDUZ,ZZB_QTDVEN,"+chr(13)+chr(10) 
cQuery += "	CASE  "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) = ZZB_QTDVEN THEN 0 "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) < ZZB_QTDVEN AND ZZB_QTDENT > 0 THEN 1 "+chr(13)+chr(10)
cQuery += "	  WHEN ZZB_QTDENT = 0 THEN 2 "+chr(13)+chr(10)
cQuery += "	END SIT, "+chr(13)+chr(10)
cQuery += "	C5_NUM C6_NUM, "+chr(13)+chr(10)
cQuery += "	ZZB_MSIDEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_ITEM,ZZB_ITEM) C6_ITEM, "+chr(13)+chr(10)
cQuery += "	ZZB_PRODUT C6_PRODUTO, "+chr(13)+chr(10)
cQuery += "	ZZB_DESCRI C6_DESCRI, "+chr(13)+chr(10)
cQuery += "	NVL(C6_QTDVEN,ZZB_QTDENT) C6_QTDVEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_PRCVEN,ZZB_PRCVEN) C6_PRCVEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_PRUNIT,ZZB_PRUNIT) C6_PRUNIT, "+chr(13)+chr(10)
cQuery += "	NVL(C6_DESCONT,ZZB_DESCON) C6_DESCONT, "+chr(13)+chr(10)
cQuery += "	NVL(C6_VALDESC,0) C6_VALDESC, "+chr(13)+chr(10)
//cQuery += "	NVL(C6_VALOR, ZZB_QTDVEN*ZZB_PRCVEN ) C6_VALOR "+chr(13)+chr(10)
cQuery += "	NVL(C6_VALOR, ZZB_QTDENT*ZZB_PRCVEN ) C6_VALOR "+chr(13)+chr(10)
cQuery += "	FROM "+RetsqlName("ZZB")+" ZZB "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SF4")+" SF4 "+chr(13)+chr(10)
cQuery += "	ON F4_FILIAL = '"+xFilial("SF4")+"' "+chr(13)+chr(10)
cQuery += "	AND F4_CODIGO = ZZB_TES "+chr(13)+chr(10)
cQuery += "	AND SF4.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SB1")+" SB1 "+chr(13)+chr(10)
cQuery += "	ON B1_FILIAL = '"+xFilial("SB1")+"' "+chr(13)+chr(10)
cQuery += "	AND B1_COD = ZZB_PRODUT "+chr(13)+chr(10)
cQuery += "	AND SB1.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SA1")+" SA1 "+chr(13)+chr(10)
cQuery += "	ON A1_FILIAL = '"+xFilial("SA1")+"' "+chr(13)+chr(10)
cQuery += "	AND A1_COD = ZZB_CLIENT "+chr(13)+chr(10)
cQuery += "	AND A1_LOJA = ZZB_LOJA "+chr(13)+chr(10)
cQuery += "	AND SA1.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	LEFT JOIN "+RetsqlName("SC5")+" SC5 "+chr(13)+chr(10)
cQuery += "	ON C5_FILIAL = ZZB_FILIAL "+chr(13)+chr(10)
//cQuery += "	AND C5_NUM = ZZB_NUM "+chr(13)+chr(10)
cQuery += "	AND C5_XNUMESP = ZZB_MSIDEN "+chr(13)+chr(10)
cQuery += "	AND SC5.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)

cQuery += "	LEFT JOIN "+RetsqlName("SE4")+" SE4 "+chr(13)+chr(10)
cQuery += "	ON E4_FILIAL = '"+xFilial("SF4")+"' "+chr(13)+chr(10)

If !Empty(cCondPag)
	cQuery += "	AND E4_CODIGO = '"+cCondPag+"' "+chr(13)+chr(10)
else
	cQuery += "	AND E4_CODIGO = C5_CONDPAG "+chr(13)+chr(10)	
EndIf
	
cQuery += "	AND SE4.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	LEFT JOIN "+RetsqlName("SA4")+" SA4 "+chr(13)+chr(10)
cQuery += "	ON A4_FILIAL = '"+xFilial("SA4")+"' "+chr(13)+chr(10)

If !Empty(cTransp)
	cQuery += "	AND A4_COD = '"+cTransp+"' "+chr(13)+chr(10)
Else
	cQuery += "	AND A4_COD = C5_TRANSP "+chr(13)+chr(10)	
EndIf
cQuery += "	AND SA4.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	LEFT JOIN "+RetsqlName("SA3")+" SA3 "+chr(13)+chr(10)
cQuery += "	ON A3_FILIAL = '"+xFilial("SA3")+"' "+chr(13)+chr(10)

If !Empty(cVend)
	cQuery += "	AND A3_COD = '"+cVend+"' "+chr(13)+chr(10)
Else
	cQuery += "	AND A3_COD = ZZB_VEND1 "+chr(13)+chr(10)
EndIf	

cQuery += "	AND SA3.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)


cQuery += "	LEFT JOIN "+RetsqlName("SC6")+" SC6 "+chr(13)+chr(10)
cQuery += "	ON C6_FILIAL = C5_FILIAL "+chr(13)+chr(10)
cQuery += "	AND C6_NUM = C5_NUM "+chr(13)+chr(10)
cQuery += "	AND C6_PRODUTO = ZZB_PRODUT "+chr(13)+chr(10)
cQuery += "	AND SC6.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)
cQuery += "	WHERE ZZB_FILIAL = '"+cFilPed+"' "+chr(13)+chr(10)
If !Empty(cPedido)
	//cQuery	+= " AND ZZB_NUM = '"+cPedido+"' "+chr(13)+chr(10)
	cQuery	+= " AND C5_NUM = '"+cPedido+"' "+chr(13)+chr(10)
Else
	cQuery	+= " AND ZZB_MSIDEN = '"+cEspelho+"' "+chr(13)+chr(10)	
EndIf
cQuery += "	AND ZZB.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)
cQuery += "	ORDER BY SIT,C6_ITEM "+chr(13)+chr(10)
 
//EndSQL
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias1, .F., .T.)
(cAlias1)->(DbgoTop())

SC5->(DbSetOrder(1))
SC5->(DbSeek( (cAlias1)->ZZB_FILIAL+(cAlias1)->C6_NUM ))

oSecCabec:Init()
oSecCabec:Cell("C6_NUM"):SetValue((cAlias1)->C6_NUM)
oSecCabec:Cell("ZZB_MSIDEN"):SetValue((cAlias1)->ZZB_MSIDEN)
oSecCabec:Cell("A1_COD"):SetValue((cAlias1)->A1_COD)
oSecCabec:Cell("A1_NREDUZ"):SetValue((cAlias1)->A1_NREDUZ)
oSecCabec:Cell("C5_EMISSAO"):SetValue( StoD( (cAlias1)->ZZB_EMISSA) )
oSecCabec:Cell("C5_XPEDCLI"):SetValue(  IIF( Empty(cPedCli) , (cAlias1)->C5_XPEDCLI , cPedCli )  )
oSecCabec:Cell("TES"):SetValue(  (cAlias1)->TES )
oSecCabec:Cell("A3_NOME"):SetValue(  (cAlias1)->A3_NOME )

oSecCabec:Cell("TRANSP"):SetValue(  AllTrim((cAlias1)->TRANSP) )
oSecCabec:Cell("C5_FRETE"):SetValue(  (cAlias1)->C5_FRETE )

If Empty(cTpFrete)
	cTpFrete := (cAlias1)->C5_TPFRETE
EndIf

Do Case
	Case cTpFrete == "C"
		cDesFre := "CIF"
	Case cTpFrete == "F"
		cDesFre := "FOB"
	Case cTpFrete == "T"
		cDesFre := "Por conta terceiros"
	Case cTpFrete == "S"
		cDesFre := "Sem frete"
	OtherWise
		cDesFre := "N„o informado"							
EndCase

oSecCabec:Cell("TPFRETE"):SetValue(  cDesFre )
oSecCabec:Cell("CODPAG"):SetValue(  Alltrim((cAlias1)->CODPAG) )

oSecCabec:PrintLine()

nSitAut = 9

While (cAlias1)->(!EOF())
	Do Case
		Case (cAlias1)->SIT == 0
			aSitAux[1]	:= .T.
			
		Case (cAlias1)->SIT == 1
			aSitAux[2]	:= .T.
			
		Case (cAlias1)->SIT == 2
			aSitAux[3]	:= .T.
	EndCase
	(cAlias1)->(DbSkip())
EndDo

(cAlias1)->(DbGoTop())

While (cAlias1)->(!EOF())
	
	If nSitAut <> (cAlias1)->SIT
		Do Case
			Case (cAlias1)->SIT == 0
				nSitAut	:= (cAlias1)->SIT
				//oReport:PrintText("Obras atendidas totalmente")
				oSection1:Init()
				
			Case (cAlias1)->SIT == 1
				nSitAut	:= (cAlias1)->SIT
				oReport:SkipLine()
				//oReport:PrintText("Obras atendidas Parcialmente")
				oSection2:Init()	
				
			Case (cAlias1)->SIT == 2
				nSitAut	:= (cAlias1)->SIT
				oReport:SkipLine()
				oReport:SkipLine()
				oReport:ThinLine()
				//oReport:PrintText("Obras n„o atendidas")
				oSection3:Init()
		EndCase
	EndIf
	
	nValDesc	:= A410Arred( ((cAlias1)->C6_PRUNIT*(cAlias1)->C6_QTDVEN)-(cAlias1)->C6_VALOR , "C6_VALOR" )
	
	Do Case
		Case (cAlias1)->SIT == 0
			oSection1:Cell("C6_ITEM"):SetValue((cAlias1)->C6_ITEM) 
			oSection1:Cell("C6_PRODUTO"):SetValue((cAlias1)->C6_PRODUTO)
			oSection1:Cell("B1_ISBN"):SetValue((cAlias1)->B1_ISBN) 
			oSection1:Cell("C6_DESCRI"):SetValue((cAlias1)->C6_DESCRI)
			oSection1:Cell("ZZB_QTDVEN"):SetValue((cAlias1)->ZZB_QTDVEN) 
			oSection1:Cell("C6_QTDVEN"):SetValue((cAlias1)->C6_QTDVEN) 
			oSection1:Cell("C6_PRCVEN"):SetValue((cAlias1)->C6_PRCVEN) 
			oSection1:Cell("C6_VALOR"):SetValue((cAlias1)->C6_VALOR) 
			oSection1:Cell("C6_PRUNIT"):SetValue((cAlias1)->C6_PRUNIT) 
			oSection1:Cell("C6_DESCONT"):SetValue((cAlias1)->C6_DESCONT) 
			oSection1:Cell("C6_VALDESC"):SetValue(nValDesc) 
			
			oSection1:PrintLine()			
			nTotAte+=(cAlias1)->C6_VALOR
			
		Case (cAlias1)->SIT == 1		
			oSection2:Cell("C6_ITEM"):SetValue((cAlias1)->C6_ITEM) 
			oSection2:Cell("C6_PRODUTO"):SetValue((cAlias1)->C6_PRODUTO)
			oSection2:Cell("B1_ISBN"):SetValue((cAlias1)->B1_ISBN) 
			oSection2:Cell("C6_DESCRI"):SetValue((cAlias1)->C6_DESCRI)
			oSection2:Cell("ZZB_QTDVEN"):SetValue((cAlias1)->ZZB_QTDVEN) 
			oSection2:Cell("C6_QTDVEN"):SetValue((cAlias1)->C6_QTDVEN) 
			oSection2:Cell("C6_PRCVEN"):SetValue((cAlias1)->C6_PRCVEN) 
			oSection2:Cell("C6_VALOR"):SetValue((cAlias1)->C6_VALOR) 
			oSection2:Cell("C6_PRUNIT"):SetValue((cAlias1)->C6_PRUNIT) 
			oSection2:Cell("C6_DESCONT"):SetValue((cAlias1)->C6_DESCONT) 
			oSection2:Cell("C6_VALDESC"):SetValue(nValDesc) 
			
			oSection2:PrintLine()
			nTotPar+=(cAlias1)->C6_VALOR
			
		Case (cAlias1)->SIT == 2
			oSection3:Cell("C6_ITEM"):SetValue((cAlias1)->C6_ITEM) 
			oSection3:Cell("C6_PRODUTO"):SetValue((cAlias1)->C6_PRODUTO) 
			oSection3:Cell("B1_ISBN"):SetValue((cAlias1)->B1_ISBN)
			oSection3:Cell("C6_DESCRI"):SetValue((cAlias1)->C6_DESCRI) 
			oSection3:Cell("ZZB_QTDVEN"):SetValue((cAlias1)->ZZB_QTDVEN)
			oSection3:Cell("C6_QTDVEN"):SetValue((cAlias1)->C6_QTDVEN) 
			oSection3:Cell("C6_PRCVEN"):SetValue((cAlias1)->C6_PRCVEN) 
			oSection3:Cell("C6_VALOR"):SetValue((cAlias1)->C6_VALOR) 
			oSection3:Cell("C6_PRUNIT"):SetValue((cAlias1)->C6_PRUNIT) 
			oSection3:Cell("C6_DESCONT"):SetValue((cAlias1)->C6_DESCONT) 
			oSection3:Cell("C6_VALDESC"):SetValue(0) 
			
			oSection3:PrintLine()			
			nTotNao+=(cAlias1)->C6_VALOR
	EndCase
		
	(cAlias1)->(DbSkip())
	
	If nSitAut <> (cAlias1)->SIT .OR. (cAlias1)->(EOF())
			
		Do Case
			Case nSitAut == 0 .OR. nSitAut == 1
				
				If (cAlias1)->SIT == 2 .OR. (cAlias1)->(EOF())
					If nSitAut == 0
						oSection1:Cell("C6_ITEM"):SetValue(" ") 
						oSection1:Cell("C6_PRODUTO"):SetValue(" ")
						oSection1:Cell("B1_ISBN"):SetValue(" ") 
						oSection1:Cell("C6_DESCRI"):SetValue("Total Pedido")
						oSection1:Cell("ZZB_QTDVEN"):SetValue(nil) 
						oSection1:Cell("C6_QTDVEN"):SetValue(nil) 
						oSection1:Cell("C6_PRCVEN"):SetValue(nil) 
						oSection1:Cell("C6_VALOR"):SetValue(nTotAte+nTotPar) 
						oSection1:Cell("C6_PRUNIT"):SetValue(nil) 
						oSection1:Cell("C6_DESCONT"):SetValue(nil) 
						oSection1:Cell("C6_VALDESC"):SetValue(nil) 			
						oSection1:PrintLine()
					Else
						oSection2:Cell("C6_ITEM"):SetValue(" ") 
						oSection2:Cell("C6_PRODUTO"):SetValue(" ")
						oSection2:Cell("B1_ISBN"):SetValue(" ") 
						oSection2:Cell("C6_DESCRI"):SetValue("Total Pedido")
						oSection2:Cell("ZZB_QTDVEN"):SetValue(nil) 
						oSection2:Cell("C6_QTDVEN"):SetValue(nil) 
						oSection2:Cell("C6_PRCVEN"):SetValue(nil) 
						oSection2:Cell("C6_VALOR"):SetValue(nTotAte+nTotPar) 
						oSection2:Cell("C6_PRUNIT"):SetValue(nil) 
						oSection2:Cell("C6_DESCONT"):SetValue(nil) 
						oSection2:Cell("C6_VALDESC"):SetValue(nil) 			
						oSection2:PrintLine()						
					EndIf	
				EndIf
				
				cChaveLog := SC5->C5_FILIAL+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI+DTOS(SC5->C5_EMISSAO)

				If File("\spool\GENA084_"+cChaveLog+".log")
					oSecLog := oReport:Section(5)
					oSecLog:Init()
					FT_FUSE("\spool\GENA084_"+cChaveLog+".log")
					FT_FGOTOP()
					While ( !FT_FEOF() )
						oSecLog:Cell("MSG"):SetValue( FT_FREADLN() )
						oSecLog:PrintLine()
						FT_FSKIP()	
					EndDo	
				EndIf
				lImpLog	:= .F.
				oReport:Finish()
				
			Case nSitAut == 2

				oSection3:Cell("C6_ITEM"):SetValue(" ") 
				oSection3:Cell("C6_PRODUTO"):SetValue(" ")
				oSection3:Cell("B1_ISBN"):SetValue(" ")  
				oSection3:Cell("C6_DESCRI"):SetValue("Total N„o atendido")
				oSection3:Cell("ZZB_QTDVEN"):SetValue(nil) 
				oSection3:Cell("C6_QTDVEN"):SetValue(nil) 
				oSection3:Cell("C6_PRCVEN"):SetValue(nil) 
				oSection3:Cell("C6_VALOR"):SetValue(nTotNao) 
				oSection3:Cell("C6_PRUNIT"):SetValue(nil) 
				oSection3:Cell("C6_DESCONT"):SetValue(nil) 
				oSection3:Cell("C6_VALDESC"):SetValue(nil) 			
				oSection3:PrintLine()
								
		EndCase
	EndIf	
	
EndDo

If lImpLog
	cChaveLog := SC5->C5_FILIAL+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI+DTOS(SC5->C5_EMISSAO)	
	IF File("\spool\GENA084_"+cChaveLog+".log")
		oSecLog := oReport:Section(5)
		oSecLog:Init()
		FT_FUSE("\spool\GENA084_"+cChaveLog+".log")
		FT_FGOTOP()
		While ( !FT_FEOF() )
			oSecLog:Cell("MSG"):SetValue( FT_FREADLN() )
			oSecLog:PrintLine()
			FT_FSKIP()	
		EndDo	
	ENDIF	
EndIf

Return(.T.)