#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT013    ºAutor  ³Danilo Azevedo      º Data ³  25/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pre Autorizacao                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Compras/Estoque                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT013()

Local oReport
Local cPerg := "FAT013"

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return()

Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("FAT013","FAT013 - Pre Autorização",,{|oReport| PrintReport(oReport)},"FAT013 - Pre Autorização",.T.)

//Ajuste nas definicoes
oReport:nLineHeight 		:= 50
oReport:cFontBody 			:= "Courier New"
oReport:nFontBody 			:= 7
oReport:lHeaderVisible 		:= .T.
oReport:lDisableOrientation	:= .T.
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","")

//Celulas da secao
TRCell():New(oSection1,"ZB_COD"			,"SZC")
TRCell():New(oSection1,"ZB_TIPO"		,"SZC")
TRCell():New(oSection1,"ZB_CLIENTE"		,"SZC")
TRCell():New(oSection1,"ZB_LOJA"		,"SZC")
TRCell():New(oSection1,"A1_NOME"		,"SA1")
TRCell():New(oSection1,"A1_END"			,"SA1")
TRCell():New(oSection1,"A1_XENDNUM"		,"SA1")
TRCell():New(oSection1,"A1_BAIRRO"		,"SA1")
TRCell():New(oSection1,"A1_MUN"			,"SA1")
TRCell():New(oSection1,"A1_EST"			,"SA1")
//TRCell():New(oSection1,"A1_CEP"			,"SA1")

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Itens","")

TRCell():New(oSection2,"SPACE1"			,"","",,2)
TRCell():New(oSection2,"ZC_ITEM"		,"SZC",,,)
TRCell():New(oSection2,"ZC_PROD"		,"SZC",,,9)
TRCell():New(oSection2,"ZC_ISBN"	    ,"SZC",,,)
TRCell():New(oSection2,"ZC_DESCPRO"		,"SZC",,,)
TRCell():New(oSection2,"ZC_UM"	   		,"SZC",,,)
TRCell():New(oSection2,"ZC_NFORI"		,"SZC",,,)
TRCell():New(oSection2,"ZC_SERIORI"		,"SZC",,,)
TRCell():New(oSection2,"ZC_ITEMORI" 	,"SZC",,,)
TRCell():New(oSection2,"ZC_QUANT"		,"SZC",,,)
TRCell():New(oSection2,"ZC_VUNIT"		,"SZC",,,)
TRCell():New(oSection2,"ZC_DESC"		,"SZC",,,)
TRCell():New(oSection2,"ZC_VALDESC"		,"SZC",,,)
TRCell():New(oSection2,"ZC_TOTAL"		,"SZC",,,)

//Totalizadores
TRFunction():New(oSection2:Cell("ZC_ITEM")	,NIL,"COUNT")//,oBreak01)  //,,,,.f.)
TRFunction():New(oSection2:Cell("ZC_QUANT")	,NIL,"SUM")//,oBreak01)  //,,,,.f.)
TRFunction():New(oSection2:Cell("ZC_TOTAL")	,NIL,"SUM")//,oBreak01)  //,,,,.f.)

//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return(oReport)


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local _cAlias1	:= GetNextAlias()
Local _cQuery	:= ""

_cQuery := "SELECT ZB_COD,ZB_TIPO,ZB_CLIENTE,ZB_LOJA,ZC_ITEM,ZC_PROD,ZC_ISBN,ZC_DESCPRO,ZC_UM,ZC_NFORI,ZC_SERIORI,ZC_ITEMORI,
_cQuery += " ZC_QUANT,ZC_VUNIT,ZC_DESC,ZC_VALDESC,ZC_TOTAL,A1_NOME,A1_END,A1_XENDNUM,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP
_cQuery += " FROM "+RetSqlName("SZB")+" ZB
_cQuery += " JOIN "+RetSqlName("SZC")+" ZC ON ZB_FILIAL = ZC_FILIAL AND ZB_COD = ZC_COD
_cQuery += " JOIN "+RetSqlName("SA1")+" A1 ON ZB_CLIENTE = A1_COD AND ZB_LOJA = A1_LOJA
_cQuery += " WHERE ZB_FILIAL = '"+xFilial("SZB")+"'
_cQuery += " AND ZB_COD = '"+SZB->ZB_COD+"'
_cQuery += " AND ZB.D_E_L_E_T_ = ' '
_cQuery += " AND ZC.D_E_L_E_T_ = ' '
_cQuery += " AND A1.D_E_L_E_T_ = ' '
_cQuery += " ORDER BY ZB_COD, ZC_ITEM

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

oReport:IncMeter()
oSection1:Init()
oSection1:Cell("ZB_COD"):SetValue((_cAlias1)->ZB_COD)
oSection1:Cell("ZB_TIPO"):SetValue((_cAlias1)->ZB_TIPO)
oSection1:Cell("ZB_CLIENTE"):SetValue((_cAlias1)->ZB_CLIENTE)
oSection1:Cell("ZB_LOJA"):SetValue((_cAlias1)->ZB_LOJA)
oSection1:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
oSection1:Cell("A1_END"):SetValue((_cAlias1)->A1_END)
oSection1:Cell("A1_XENDNUM"):SetValue((_cAlias1)->A1_XENDNUM)
oSection1:Cell("A1_BAIRRO"):SetValue((_cAlias1)->A1_BAIRRO)
oSection1:Cell("A1_MUN"):SetValue((_cAlias1)->A1_MUN)
oSection1:Cell("A1_EST"):SetValue((_cAlias1)->A1_EST)
//oSection1:Cell("A1_CEP"):SetValue((_cAlias1)->A1_CEP)
oSection1:PrintLine()

oSection2:SetHeaderSection(.T.)
Do While !(_cAlias1)->(EOF()) .And. !oReport:Cancel()
	oReport:IncMeter()
	oSection2:Init()
	oSection2:Cell("ZC_ITEM")		:SetValue((_cAlias1)->ZC_ITEM)
	oSection2:Cell("ZC_PROD")		:SetValue((_cAlias1)->ZC_PROD)
	oSection2:Cell("ZC_ISBN")		:SetValue((_cAlias1)->ZC_ISBN)
	oSection2:Cell("ZC_DESCPRO")	:SetValue((_cAlias1)->ZC_DESCPRO)
	oSection2:Cell("ZC_UM")			:SetValue((_cAlias1)->ZC_UM)
	oSection2:Cell("ZC_NFORI")		:SetValue((_cAlias1)->ZC_NFORI)
	oSection2:Cell("ZC_SERIORI")	:SetValue((_cAlias1)->ZC_SERIORI)
	oSection2:Cell("ZC_ITEMORI")	:SetValue((_cAlias1)->ZC_ITEMORI)
	oSection2:Cell("ZC_QUANT")		:SetValue((_cAlias1)->ZC_QUANT)
	oSection2:Cell("ZC_VUNIT")		:SetValue((_cAlias1)->ZC_VUNIT)
	oSection2:Cell("ZC_DESC")		:SetValue((_cAlias1)->ZC_DESC)
	oSection2:Cell("ZC_VALDESC")	:SetValue((_cAlias1)->ZC_VALDESC)
	oSection2:Cell("ZC_TOTAL")		:SetValue((_cAlias1)->ZC_TOTAL)
	oSection2:PrintLine()
	(_cAlias1)->(dbSkip())
EndDo
oSection2:Finish()
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.T.)
