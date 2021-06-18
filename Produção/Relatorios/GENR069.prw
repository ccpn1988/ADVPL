#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "Report.ch"
#INCLUDE "RPTDEF.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR069 บAutor  ณMicrosiga           	บ Data ณ  07/01/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GENR069()

Local oReport
Local cPerg		:= "GENR069"    
Local cTempDir	:= GetTempPath()+"totvsprinter\" 
Local cFilename	:= ""
Local cMailBody	:= ""
Local cQuebra		:= "" 
Local lFileOk		:= .F.
Local lPerg		:= .T.

/*
U_xGPutSx1(cPerg, "01", "Cliente"		, ".", ".", "MV_CH1" , "C", TamSx3("A1_COD")[1], 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "02", "Loja"			, ".", ".", "MV_CH2" , "C", TamSx3("A1_LOJA")[1], 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "03", "De Emissใo"	, ".", ".", "MV_CH3" , "D", TamSx3("C5_EMISSAO")[1], 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "04", "Ate Emissใo"	, ".", ".", "MV_CH4" , "D", TamSx3("C5_EMISSAO")[1], 0, 0, "G","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg, "05", "Obra"			, ".", ".", "MV_CH5" , "C", TamSx3("B1_COD")[1], 0, 0, "G","", "", "", "", "MV_PAR05","","","","","","","","","","","","","","","","")
*/
//U_xGPutSx1(_cPerg, "04", "Tipo"      	, ".", ".", "mv_ch4" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR04","Oferta","Oferta","Oferta","","Venda","Venda","Venda","","","","","","","","","")

If !Pergunte(cPerg,lPerg)
	Return nil
EndIf

oReport := ReportDef(cPerg)
oReport:PrintDialog()
	
Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

oReport := TReport():New("GENR069","Espelho do pedido",cPerg,{|oReport| PrintReport(oReport)},"Espelho do pedido")
oReport:SetLandscape()    

oSection1 := TRSection():New(oReport,"Dados do cliente",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

//Celulas da secao
TRCell():New(oSection1,"A1_COD"			,"TMP_ESP","Cod.Cliente",,20)
TRCell():New(oSection1,"A1_NREDUZ"		,"TMP_ESP","Nome",,100)
oSection1:SetLineStyle(.T.)

oSection2 := TRSection():New(oReport,"Obras",,,,,,,,,,,,,,,,,,,)//,,,,,,,,,.T.,,,,,,,,,,80)

TRCell():New(oSection2,"DESC_SIT"	,"TMP_ESP","Situa็ใo",,30)

TRCell():New(oSection2,"A1_COD"			,"TMP_ESP","Cod.Cliente",,20)
TRCell():New(oSection2,"A1_LOJA"		,"TMP_ESP","Loja Cliente",,20)
TRCell():New(oSection2,"A1_NREDUZ"		,"TMP_ESP","Nome",,80)
//Celulas da secao
TRCell():New(oSection2,"C6_PRODUTO"	,"TMP_ESP","Produto",,20)
TRCell():New(oSection2,"C6_DESCRI"		,"TMP_ESP","Descri็ใo",,80)
TRCell():New(oSection2,"B1_ISBN"		,"TMP_ESP","ISBN",,20)
TRCell():New(oSection2,"Z4_DESC"		,"TMP_ESP","Sit.Obra",,20)
TRCell():New(oSection2,"ZZB_QTDVEN"	,"TMP_ESP","Qtd.Solic.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_QTDVEN"		,"TMP_ESP","Qtd.atend.",'@E 9,999,999',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_PRCVEN"		,"TMP_ESP","Prc.Venda",'@E 999,999,999.99',15,,,,,"RIGHT")
//TRCell():New(oSection2,"C6_VALOR"		,"TMP_ESP","Valor Total",'@E 999,999,999.99',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_PRUNIT"		,"TMP_ESP","Prc.Unit.",'@E 999,999,999.99',17,,,,,"RIGHT")
TRCell():New(oSection2,"C6_DESCONT"	,"TMP_ESP","% Desc."		,'@E 99.99',12,,,,,"RIGHT")
//TRCell():New(oSection2,"C6_VALDESC"	,"TMP_ESP","Val.Tot.Desc."	,'@E 999,999,999.99',20,,,,,"RIGHT")
TRCell():New(oSection2,"C6_NUM"			,"TMP_ESP","Nr.Pedido",,20)
TRCell():New(oSection2,"C5_EMISSAO"	,"TMP_ESP","Emissใo",,20)
TRCell():New(oSection2,"ZZB_MSIDEN"	,"TMP_ESP","Nr.Espelho",,30)
TRCell():New(oSection2,"C6_ITEM"		,"TMP_ESP","It.Pedido",,20)
TRCell():New(oSection2,"C5_XPEDCLI"	,"TMP_ESP","Ped.Cliente",,20)
TRCell():New(oSection2,"A3_NOME"		,"TMP_ESP","Vendedor",,20)
TRCell():New(oSection2,"TES"			,"TMP_ESP","TES",,80)

//oSection1:SetPercentage(80)

Return oReport

Static Function PrintReport(oReport,cPedido,cEspelho,cFilPed)

Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
Local cAlias1		:= GetNextAlias()
Local cWhere		:= ""
Local nTotAte		:= 0
Local nTotPar		:= 0
Local nTotNao		:= 0
Local cQuery		:= ""

cQuery += " SELECT A3_NOME,TRIM(F4_TEXTO)||' - '||TRIM(F4_FINALID) TES,Z4_DESC,C5_XPEDCLI,B1_ISBN,ZZB_EMISSA,A1_COD,A1_LOJA,A1_NREDUZ,ZZB_QTDVEN,"+chr(13)+chr(10) 
cQuery += "	CASE  "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) = ZZB_QTDVEN THEN 0 "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) < ZZB_QTDVEN AND ZZB_QTDENT > 0 THEN 1 "+chr(13)+chr(10)
cQuery += "	  WHEN ZZB_QTDENT = 0 THEN 2 "+chr(13)+chr(10)
cQuery += "	END SIT, "+chr(13)+chr(10)
cQuery += "	CASE  "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) = ZZB_QTDVEN THEN 'ATENDIDO TOTALMENTE' "+chr(13)+chr(10)
cQuery += "	  WHEN NVL(C6_QTDVEN,ZZB_QTDENT) < ZZB_QTDVEN AND ZZB_QTDENT > 0 THEN 'ATENDIDO PARCIALMENTE' "+chr(13)+chr(10)
cQuery += "	  WHEN ZZB_QTDENT = 0 THEN 'NรO ATENDIDO' "+chr(13)+chr(10)
cQuery += "	END DESC_SIT, "+chr(13)+chr(10)
cQuery += "	C5_NUM C6_NUM, "+chr(13)+chr(10)
cQuery += "	ZZB_MSIDEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_ITEM,ZZB_ITEM) C6_ITEM, "+chr(13)+chr(10)
cQuery += "	ZZB_PRODUT C6_PRODUTO, "+chr(13)+chr(10)
cQuery += "	ZZB_DESCRI C6_DESCRI, "+chr(13)+chr(10)
cQuery += "	NVL(C5_VEND1, ZZB_VEND1) C5_VEND1, "+chr(13)+chr(10)
cQuery += "	NVL(C6_QTDVEN,ZZB_QTDENT) C6_QTDVEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_PRCVEN,ZZB_PRCVEN) C6_PRCVEN, "+chr(13)+chr(10)
cQuery += "	NVL(C6_PRUNIT,0) C6_PRUNIT, "+chr(13)+chr(10)
cQuery += "	NVL(C6_DESCONT,0) C6_DESCONT, "+chr(13)+chr(10)
cQuery += "	NVL(C6_VALDESC,0) C6_VALDESC, "+chr(13)+chr(10)
cQuery += "	NVL(C6_VALOR, ZZB_QTDVEN*ZZB_PRCVEN ) C6_VALOR "+chr(13)+chr(10)
cQuery += "	FROM "+RetsqlName("ZZB")+" ZZB "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SF4")+" SF4 "+chr(13)+chr(10)
cQuery += "	ON F4_FILIAL = '"+xFilial("SF4")+"' "+chr(13)+chr(10)
cQuery += "	AND F4_CODIGO = ZZB_TES "+chr(13)+chr(10)
cQuery += "	AND SF4.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SB1")+" SB1 "+chr(13)+chr(10)
cQuery += "	ON B1_FILIAL = '"+xFilial("SB1")+"' "+chr(13)+chr(10)
cQuery += "	AND B1_COD = ZZB_PRODUT "+chr(13)+chr(10)
cQuery += "	AND SB1.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)

cQuery += "	JOIN "+RetsqlName("SZ4")+" SZ4 "+chr(13)+chr(10)
cQuery += "	ON Z4_FILIAL = '"+xFilial("SZ4")+"' "+chr(13)+chr(10)
cQuery += "	AND Z4_COD = B1_XSITOBR "+chr(13)+chr(10)
cQuery += "	AND SZ4.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10) 

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

cQuery += "	LEFT JOIN "+RetsqlName("SC6")+" SC6 "+chr(13)+chr(10)
cQuery += "	ON C6_FILIAL = C5_FILIAL "+chr(13)+chr(10)
cQuery += "	AND C6_NUM = C5_NUM "+chr(13)+chr(10)
cQuery += "	AND C6_PRODUTO = ZZB_PRODUT "+chr(13)+chr(10)
cQuery += "	AND SC6.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)


cQuery += "	LEFT JOIN "+RetsqlName("SA3")+" SA3 "+chr(13)+chr(10)
cQuery += "	ON A3_FILIAL = '"+xFilial("SA3")+"' "+chr(13)+chr(10)
cQuery += "	AND A3_COD = ZZB_VEND1 "+chr(13)+chr(10)
cQuery += "	AND SA3.D_E_L_E_T_ <> '*'  "+chr(13)+chr(10)


cQuery += "	WHERE ZZB.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)

cQuery += "	AND ZZB.ZZB_EMISSA BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "+chr(13)+chr(10)

If !Empty(MV_PAR05)
	cQuery += "	AND TRIM(ZZB.ZZB_PRODUT) = '"+AllTrim(MV_PAR05)+"' "+chr(13)+chr(10)	
EndIf
If !Empty(MV_PAR01)
	cQuery += "	AND ZZB.ZZB_CLIENT = '"+AllTrim(MV_PAR01)+"' "+chr(13)+chr(10)
	If !Empty(MV_PAR02)
		cQuery += "	AND ZZB.ZZB_LOJA = '"+AllTrim(MV_PAR02)+"' "+chr(13)+chr(10)		
	EndIf		
EndIf

cQuery += "	ORDER BY A1_COD,A1_LOJA,SIT,C6_PRODUTO,C6_NUM "+chr(13)+chr(10)

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias1, .F., .T.)
(cAlias1)->(DbgoTop())

cCliAux	:= ""

If oReport:NDEVICE <> 4
	oSection2:Cell("A1_COD"):lVisible	:= .F.
	oSection2:Cell("A1_COD"):lEnabled	:= .F.
	oSection2:Cell("A1_NREDUZ"):lVisible	:= .F.
	oSection2:Cell("A1_NREDUZ"):lEnabled	:= .F.
Else			
	oSection1:Hide()	
EndIf
	
While (cAlias1)->(!EOF())
	
	If cCliAux <> AllTrim((cAlias1)->A1_COD) + AllTrim((cAlias1)->A1_LOJA)
		
		If !Empty(cCliAux)
			oReport:SkipLine()
			oReport:SkipLine()
			oReport:ThinLine()			
		EndIf
		
		cCliAux	:= AllTrim((cAlias1)->A1_COD) + AllTrim((cAlias1)->A1_LOJA)
		oSection1:Init()		
		oSection1:Cell("A1_COD"):SetValue((cAlias1)->A1_COD) 
		oSection1:Cell("A1_NREDUZ"):SetValue((cAlias1)->A1_NREDUZ)
		oSection1:PrintLine()
		
		oSection2:Init()
	EndIf

	oSection2:Cell("DESC_SIT"):SetValue((cAlias1)->DESC_SIT)	
	oSection2:Cell("A1_COD"):SetValue((cAlias1)->A1_COD) 
	oSection2:Cell("A1_LOJA"):SetValue((cAlias1)->A1_LOJA)
	oSection2:Cell("A1_NREDUZ"):SetValue((cAlias1)->A1_NREDUZ)	
	oSection2:Cell("C6_PRODUTO"):SetValue((cAlias1)->C6_PRODUTO) 
	oSection2:Cell("C6_DESCRI"):SetValue((cAlias1)->C6_DESCRI)
	oSection2:Cell("B1_ISBN"):SetValue((cAlias1)->B1_ISBN)
	oSection2:Cell("Z4_DESC"):SetValue((cAlias1)->Z4_DESC) 
	oSection2:Cell("ZZB_QTDVEN"):SetValue((cAlias1)->ZZB_QTDVEN) 
	oSection2:Cell("C6_QTDVEN"):SetValue((cAlias1)->C6_QTDVEN) 
	oSection2:Cell("C6_PRCVEN"):SetValue((cAlias1)->C6_PRCVEN) 
	//oSection2:Cell("C6_VALOR"):SetValue((cAlias1)->C6_VALOR) 
	oSection2:Cell("C6_PRUNIT"):SetValue((cAlias1)->C6_PRUNIT) 
	oSection2:Cell("C6_DESCONT"):SetValue((cAlias1)->C6_DESCONT) 
	//oSection2:Cell("C6_VALDESC"):SetValue((cAlias1)->C6_VALDESC) 
	oSection2:Cell("C6_NUM"):SetValue((cAlias1)->C6_NUM) 
	oSection2:Cell("C5_EMISSAO"):SetValue(StoD((cAlias1)->ZZB_EMISSA)) 
	oSection2:Cell("ZZB_MSIDEN"):SetValue((cAlias1)->ZZB_MSIDEN) 
	oSection2:Cell("C6_ITEM"):SetValue((cAlias1)->C6_ITEM)
	oSection2:Cell("C5_XPEDCLI"):SetValue((cAlias1)->C5_XPEDCLI)
	oSection2:Cell("TES"):SetValue((cAlias1)->TES)
	oSection2:Cell("A3_NOME"):SetValue((cAlias1)->A3_NOME)  	
	oSection2:PrintLine()
		
	(cAlias1)->(DbSkip())		
EndDo

Return(.t.)