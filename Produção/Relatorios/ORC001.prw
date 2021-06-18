#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ORC001    ºAutor  ³Helimar Tavares     º Data ³  14/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de Orçamentos de Venda                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³SIGAFAT                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ORC001()             

Local oReport
Local cPerg := "ORC001"

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport:= ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local aOrd		:= {"Número","Cliente"} //,STR0029}	//"Numero"###"Cliente"###"Produto"

//Declaracao do relatorio
oReport := TReport():New("ORC001","ORC001 - RELAÇÃO DE ORÇAMENTOS DE VENDA",cPerg,{|oReport| PrintReport(oReport)},"ORC001 - RELAÇÃO DE ORÇAMENTOS DE VENDA",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Filial","SM0",aOrd)
                                            
TRCell():New(oSection1,"M0_NOMECOM"	,"SM0","Razão Social"	,,40)
TRCell():New(oSection1,"M0_ENDCOB"	,"SM0","Endereço"		,,25)
TRCell():New(oSection1,"M0_COMPCOB"	,"SM0","Complemento"	,,10)
TRCell():New(oSection1,"M0_BAIRCOB"	,"SM0","Bairro"			,,15)
TRCell():New(oSection1,"M0_CIDCOB"	,"SM0","Município"		,,15)
TRCell():New(oSection1,"M0_ESTCOB"	,"SM0","UF"				,,5)
TRCell():New(oSection1,"M0_CEPCOB"	,"SM0","CEP"			,PesqPict("SA1","A1_CEP")	,10)
TRCell():New(oSection1,"M0_CGC"		,"SM0","CNPJ"			,PesqPict("SA1","A1_CGC")	,20)
TRCell():New(oSection1,"M0_INSC"	,"SM0","Insc.Est."		,PesqPict("SA1","A1_INSC")	,15)

oSection2 := TRSection():New(oReport,"Cliente","SCJ")

//Celulas da secao
TRCell():New(oSection2,"CJ_NUM"		)
TRCell():New(oSection2,"CJ_CLIENTE"	)
TRCell():New(oSection2,"CJ_LOJA"	)
TRCell():New(oSection2,"A1_NOME"	)
TRCell():New(oSection2,"E4_DESCRI"	,"SE4","Cond.Pgto.")
TRCell():New(oSection2,"A1_TPFRET"	)
TRCell():New(oSection2,"A3_NOME"	,"SA3","Vendedor")

//Secao do relatorio
oSection3 := TRSection():New(oSection2,"Produtos","SCK")

//Celulas da secao
TRCell():New(oSection3,"CK_ITEM"	,"SCK")
TRCell():New(oSection3,"B1_ISBN"	,"SB1","ISBN","",15)
TRCell():New(oSection3,"B1_DESC"	,"SB1","Descrição","",60)
TRCell():New(oSection3,"CK_QTDVEN"	,"SCK")
TRCell():New(oSection3,"CK_PRUNIT"	,"SCK")
TRCell():New(oSection3,"CK_DESCONT"	,"SCK")
TRCell():New(oSection3,"CK_VALOR"	,"SCK")                  
                            
oBreak := TRBreak():New(oSection2,oSection2:Cell("CJ_CLIENTE"),"Total do Cliente",.f.)

//Totalizadores
TRFunction():New(oSection3:Cell("CK_QTDVEN"),NIL,"SUM")  //,,,,,.T.,.F.,.F., oSection2)
TRFunction():New(oSection3:Cell("CK_VALOR") ,NIL,"SUM")  //,,,,,.T.,.F.,.F., oSection2)

//Faz a impressao do totalizador em linha
oSection3:SetTotalInLine(.f.)
oSection2:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)  
Local oSection3 := oSection2:Section(1)  
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()
Local xCliente  := ""

_cParm3 := DTOS(MV_PAR03)
_cParm4 := DTOS(MV_PAR04) 
_cParm9 := CVALTOCHAR(MV_PAR09)

_cQuery := "SELECT CJ_FILIAL, CJ_NUM, CJ_EMISSAO, CJ_CLIENTE, CJ_LOJA, A1_NOME, A3_NOME, CJ_STATUS,
_cQuery += "       E4_DESCRI, DECODE(A1_TPFRET, 'C', 'CIF', 'F', 'FOB') A1_TPFRET,
_cQuery += "       CK_ITEM, CK_PRODUTO, B1_ISBN, B1_DESC, CK_QTDVEN, CK_PRUNIT, CK_PRCVEN,
_cQuery += "       CK_DESCONT, CK_VALDESC, CK_VALOR
_cQuery += "  FROM " + RetSqlName("SCJ") + " SCJ, " + RetSqlName("SCK") + " SCK,
_cQuery += "       " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA1") + " SA1, 
_cQuery += "       " + RetSqlName("SA3") + " SA3, " + RetSqlName("SE4") + " SE4
_cQuery += " WHERE SCJ.CJ_FILIAL  = SCK.CK_FILIAL
_cQuery += "   AND SCJ.CJ_NUM     = SCK.CK_NUM
_cQuery += "   AND SCK.CK_PRODUTO = SB1.B1_COD
_cQuery += "   AND SCJ.CJ_CLIENTE = SA1.A1_COD
_cQuery += "   AND SCJ.CJ_LOJA    = SA1.A1_LOJA
_cQuery += "   AND SA1.A1_VEND    = SA3.A3_COD
_cQuery += "   AND SA1.A1_COND    = SE4.E4_CODIGO
_cQuery += "   AND SCJ.CJ_FILIAL  = '" + xFilial("SCJ") + "'"
_cQuery += "   AND SCK.CK_FILIAL  = '" + xFilial("SCK") + "'"
_cQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
_cQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
_cQuery += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery += "   AND SE4.E4_FILIAL  = '" + xFilial("SE4") + "'"
_cQuery += "   AND SCJ.D_E_L_E_T_ = ' '
_cQuery += "   AND SCK.D_E_L_E_T_ = ' '

_cQuery += "   AND SCJ.CJ_CLIENTE >= '"+MV_PAR01+"' AND SCJ.CJ_CLIENTE <= '"+MV_PAR02+"'"
_cQuery += "   AND SCJ.CJ_EMISSAO >= '"+ _cParm3+"' AND SCJ.CJ_EMISSAO <= '"+ _cParm4+"'"
_cQuery += "   AND SCJ.CJ_NUM     >= '"+MV_PAR05+"' AND SCJ.CJ_NUM     <= '"+MV_PAR06+"'"
_cQuery += "   AND SCK.CK_PRODUTO >= '"+MV_PAR07+"' AND SCK.CK_PRODUTO <= '"+MV_PAR08+"'"
_cQuery += "   AND SCJ.CJ_STATUS LIKE DECODE("+_cParm9+", 1, '%', 2, 'A', 3, 'B', 4, 'C')"
                                                                          
If oSection1:GetOrder() == 1
	_cQuery += " ORDER BY CK_NUM, CK_ITEM
Else
	_cQuery += " ORDER BY CK_CLIENTE, CK_LOJA, CK_NUM, CK_ITEM
Endif

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

oSection1:Init()
	
oSection1:Cell("M0_NOMECOM"):SetValue(SM0->M0_NOMECOM)
oSection1:Cell("M0_ENDCOB"):SetValue(SM0->M0_ENDCOB)
oSection1:Cell("M0_COMPCOB"):SetValue(SM0->M0_COMPCOB)
oSection1:Cell("M0_BAIRCOB"):SetValue(SM0->M0_BAIRCOB)
oSection1:Cell("M0_CIDCOB"):SetValue(SM0->M0_CIDCOB)
oSection1:Cell("M0_ESTCOB"):SetValue(SM0->M0_ESTCOB)
oSection1:Cell("M0_CEPCOB"):SetValue(SM0->M0_CEPCOB)	
oSection1:Cell("M0_CGC"):SetValue(SM0->M0_CGC)	
oSection1:Cell("M0_INSC"):SetValue(SM0->M0_INSC)	
	                                                      
oSection1:PrintLine()

oSection1:Finish()

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xCliente := (_cAlias1)->CJ_CLIENTE+(_cAlias1)->CJ_LOJA

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
	
	oSection2:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->CJ_CLIENTE+(_cAlias1)->CJ_LOJA = xCliente .And. !oReport:Cancel()
		oSection3:Init()

		oSection3:Cell("CK_ITEM"):SetValue((_cAlias1)->CK_ITEM)
		oSection3:Cell("B1_ISBN"):SetValue((_cAlias1)->B1_ISBN)
		oSection3:Cell("B1_DESC"):SetValue((_cAlias1)->B1_DESC)
		oSection3:Cell("CK_QTDVEN"):SetValue((_cAlias1)->CK_QTDVEN)
		oSection3:Cell("CK_PRUNIT"):SetValue((_cAlias1)->CK_PRUNIT)
		oSection3:Cell("CK_DESCONT"):SetValue((_cAlias1)->CK_DESCONT)
		oSection3:Cell("CK_VALOR"):SetValue((_cAlias1)->CK_VALOR)

		oSection3:PrintLine()

		(_cAlias1)->(dbSkip())		
	EndDo             
	oSection3:Finish()
	oSection2:Finish()
EndDo
oSection2:Finish()
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

	
Return(.t.)