#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMyFa376GerบAutor  ณ Renato Calabro     บ Data ณ  07/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para incluir variaveis PRIVATE e executar rotina    บฑฑ
ฑฑบ          ณ padrao Fa376Gera.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nil                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA048()

Local aTits			:= {}

Private lImpRelat	:= .F.

Private aMyRegs		:= {}

//&(cRotPadr+"()")]
Fa376Gera()

If lImpRelat
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Armazeno numero do processo para referencia de titulos gerados               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cProcess := SE5->E5_AGLIMP
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Restauro parametro que imprime relatorio para 1 - SIM pois usuario solicitou ณ
	//ณ imprimir relatorio no pergunte padrao                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MV_PAR04 := 1
	aTits := GetTitGer(SE5->E5_CLIFOR, SE5->E5_LOJA, cProcess)
	//MyFr376Rel(aMyRegs,aTits,cProcess,.F.)
	U_GENA048R(aMyRegs,aTits,cProcess,.F.)
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetTitGerบ Autor ณ Renato Calabro     บ Data ณ  07/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio analitico para conferencia. Este    ณฑฑ
ฑฑบ          ณ relatorio se baseia no relatorio padrao F376Rel, localiza- บฑฑ
ฑฑบ          ณ do na funcao padrao FINA376 - aglutinacao de impostos      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณParametrosณ oExp1 = Objeto TReport instanciado                      	  ณฑฑ
ฑฑณ          ณ aExp2 = Array contendo dados dos titulos baixados       	  ณฑฑ
ฑฑณ          ณ aExp3 = Array contendo dados dos titulos gerados        	  ณฑฑ
ฑฑณ          ณ cExp4 = Codigo do processo de aglutinacao de impostos   	  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetTitGer(cFornece, cLoja, cProcess)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

Local aTits		:= {}

cQuery := "SELECT R_E_C_N_O_ RECNOSE2 " + CRLF
cQuery += "  FROM " + RetSqlTab("SE2")
cQuery += " WHERE E2_NUM = '" + cProcess + "' " + CRLF
cQuery += "   AND E2_FORNECE = '" + cFornece + "' " + CRLF
cQuery += "   AND E2_LOJA = '" + cLoja + "' " + CRLF
cQuery += "   AND D_E_L_E_T_ <> '*'" + CRLF

cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .F., .T. )

(cAlias)->( DbGoTop() )

While (cAlias)->(!EOF())
	aAdd(aTits, (cAlias)->RECNOSE2 )
	(cAlias)->( DbSkip() )
EndDo

If Select(cAlias) > 0
	(cAlias)->( DbCloseArea() )
EndIf

Return aTits

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMyFr376Relบ Autor ณ Renato Calabro     บ Data ณ  07/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio analitico para conferencia          ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณParametrosณ aExp1 = Array contendo dados dos titulos baixados       	  ณฑฑ
ฑฑณ          ณ aExp2 = Array contendo dados dos titulos gerados        	  ณฑฑ
ฑฑณ          ณ cExp3 = Codigo do processo de aglutinacao de impostos   	  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA048R(aRegs,aTits,cProcess)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oReport	:= Nil

oReport := ReportDef(aRegs, aTits, cProcess)
oReport:PrintDialog()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ReportDefบ Autor ณ Renato Calabro     บ Data ณ  07/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio analitico para conferencia - defi-  ณฑฑ
ฑฑบ          ณ nicao de layout                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณParametrosณ aExp1 = Array contendo dados dos titulos baixados       	  ณฑฑ
ฑฑณ          ณ aExp2 = Array contendo dados dos titulos gerados        	  ณฑฑ
ฑฑณ          ณ cExp3 = Codigo do processo de aglutinacao de impostos   	  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef(aRegs, aTits, cProcess)

Local cTitulo	:= "GEN Relatorio de Aglutinacao de Impostos - Processo Nr. " + cProcess

Local oReport	:= Nil
Local oSection1	:= Nil

Local aOrdem	:= {}

//Declaracao do relatorio
oReport := TReport():New("MyFr376Rel",cTitulo	,/*cPerg*/, {|oReport| PrintReport(oReport, aRegs, aTits, cProcess)}, cTitulo) 
oReport:PrintHeader(.F.,.F.)

//Secao do relatorio
oSection1 := TRSection():New(oReport, cTitulo,/*{"SF1", cQryAlias, "NAOUSADO"}*/,/*aOrdem*/)

//Celulas da secao
TRCell():New(oSection1,"E2_FILIAL"	,, GetSX3Cache("E2_FILIAL", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_PREFIXO"	,, GetSX3Cache("E2_PREFIXO", "X3_TITULO")	  	,,)
TRCell():New(oSection1,"E2_NUM"		,, GetSX3Cache("E2_NUM", "X3_TITULO")		  	,,)
TRCell():New(oSection1,"E2_PARCELA"	,, GetSX3Cache("E2_PARCELA", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_FORNECE"	,, "Forn. Orig."		,,)
TRCell():New(oSection1,"E2_LOJA"	,, "Lj.For.Orig"			,,)
TRCell():New(oSection1,"E2_NOMFOR"	,, GetSX3Cache("E2_NOMFOR", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_TIPO"	,, GetSX3Cache("E2_TIPO", "X3_TITULO")			,,)
TRCell():New(oSection1,"E2_EMIS1"	,, GetSX3Cache("E2_EMIS1", "X3_TITULO")			,,)
TRCell():New(oSection1,"E2_VENCTO"	,, GetSX3Cache("E2_VENCTO", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_VENCREA"	,, GetSX3Cache("E2_VENCREA", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_NATUREZ"	,, GetSX3Cache("E2_NATUREZ", "X3_TITULO")		,,)
TRCell():New(oSection1,"E2_VALOR"	,, GetSX3Cache("E2_VALOR", "X3_TITULO")			,"@E 99,999,999.99",)

//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintReporบ Autor ณ Renato Calabro     บ Data ณ  07/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio analitico para conferencia - im-    ณฑฑ
ฑฑบ          ณ pressao do relatorio                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณParametrosณ oExp1 = Objeto TReport instanciado                      	  ณฑฑ
ฑฑณ          ณ aExp2 = Array contendo dados dos titulos baixados       	  ณฑฑ
ฑฑณ          ณ aExp3 = Array contendo dados dos titulos gerados        	  ณฑฑ
ฑฑณ          ณ cExp4 = Codigo do processo de aglutinacao de impostos   	  ณฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport( oReport, aRegs, aTits, cProcess )

Local lForOri	:= ""										//Codigo do fornecedor
Local lLjForOri	:= ""										//Codigo da loja fornecedor

Local nI		:= 0										//Variavel de controle do loop
Local nSubTot	:= 0

Local aAreaAtu	:= {SA2->(GetArea()), GetArea()}			//Armazena a area atual

Local oSection1	:= oReport:Section(1)						//objeto da Secao 1

Default aRegs	:= {}
Default aTits	:= {}

oReport:SetMeter(Len(aRegs) + Len(aTits))

If Len(aRegs) > 0
	aSort( aRegs,,, {|a,b| a[2] < b[2] })	
	nSubTot := 0

	oSection1:Init()

	For nI := 1 To Len(aRegs)

		oReport:IncMeter(nI)

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbGoTo(aRegs[nI,1])

		If !oReport:Cancel()

			oSection1:Cell("E2_FILIAL")		:SetValue( SE2->E2_FILIAL )
			oSection1:Cell("E2_PREFIXO")	:SetValue( SE2->E2_PREFIXO )
			oSection1:Cell("E2_NUM")		:SetValue( SE2->E2_NUM )
			oSection1:Cell("E2_PARCELA")	:SetValue( SE2->E2_PARCELA )
			oSection1:Cell("E2_TIPO")		:SetValue( SE2->E2_TIPO )
			oSection1:Cell("E2_EMIS1")		:SetValue( SE2->E2_EMIS1 )
			oSection1:Cell("E2_VENCTO")		:SetValue( SE2->E2_VENCTO )
			oSection1:Cell("E2_VENCREA")	:SetValue( SE2->E2_VENCREA )
			oSection1:Cell("E2_NATUREZ")	:SetValue( SE2->E2_NATUREZ )
	 		If SE2->E2_TIPO $ MVTXA
				oSection1:Cell("E2_VALOR")	:SetValue( SE2->E2_VALLIQ*-1 )
				nSubTot -= SE2->E2_VALLIQ
			Else
				oSection1:Cell("E2_VALOR")	:SetValue( SE2->E2_VALLIQ )
				nSubTot += SE2->E2_VALLIQ
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Posiciono no titulo pai para inserir dados do fornecedor que gerou tit.imposto  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			_cChave := SE2->E2_FILIAL + Rtrim(SE2->E2_TITPAI)
			 
			//If SE2->(DbSeek(xFilial("SE2") + Substr(SE2->E2_TITPAI, 1, Len(SE2->E2_PREFIXO + SE2->E2_NUM  + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)) ))
			If !Empty(SE2->E2_TITPAI)
				SE2->(DbSeek(_cChave))
			EndIf
			
			oSection1:Cell("E2_FORNECE")	:SetValue( SE2->E2_FORNECE )
			oSection1:Cell("E2_LOJA")		:SetValue( SE2->E2_LOJA )
			oSection1:Cell("E2_NOMFOR")		:SetValue( SE2->E2_NOMFOR )

			oSection1:PrintLine()
		EndIf
	Next nI


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Oculto colunas para gerar o subtotal dos titulos aglutinados                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1:Cell("E2_FILIAL")	:Hide()
	oSection1:Cell("E2_PREFIXO"):Hide()
	oSection1:Cell("E2_NUM")	:Hide()
	oSection1:Cell("E2_PARCELA"):Hide()
	oSection1:Cell("E2_FORNECE"):Hide()
	oSection1:Cell("E2_LOJA")	:Hide()
	oSection1:Cell("E2_NOMFOR")	:Hide()
	oSection1:Cell("E2_TIPO")	:Hide()
	oSection1:Cell("E2_EMIS1")	:Hide()
	oSection1:Cell("E2_VENCTO")	:Hide()
	oSection1:Cell("E2_VENCREA"):Hide()
	oSection1:Cell("E2_NATUREZ"):Hide()

	oReport:Say(oReport:Row(), 010, "Total de Titulos Baixados -->> ")
	oSection1:Cell("E2_VALOR")	:SetValue( nSubTot ) 
	oSection1:PrintLine()

	oReport:SkipLine()
	oReport:SkipLine()
	oReport:FatLine()
	oReport:SkipLine()

	nSubTot := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Desoculto colunas para gerar o subtotal dos titulos gerados                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1:Cell("E2_FILIAL")	:Show()
	oSection1:Cell("E2_PREFIXO"):Show()
	oSection1:Cell("E2_NUM")	:Show()
	oSection1:Cell("E2_PARCELA"):Show()
	oSection1:Cell("E2_FORNECE"):Show()
	oSection1:Cell("E2_LOJA")	:Show()
	oSection1:Cell("E2_NOMFOR")	:Show()
	oSection1:Cell("E2_TIPO")	:Show()
	oSection1:Cell("E2_EMIS1")	:Show()
	oSection1:Cell("E2_VENCTO")	:Show()
	oSection1:Cell("E2_VENCREA"):Show()
	oSection1:Cell("E2_NATUREZ"):Show()

	For nI := 1 to Len(aTits)

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbGoTo(aTits[nI])

		oSection1:Cell("E2_FILIAL")		:SetValue( SE2->E2_FILIAL )
		oSection1:Cell("E2_PREFIXO")	:SetValue( SE2->E2_PREFIXO )
		oSection1:Cell("E2_NUM")		:SetValue( SE2->E2_NUM )
		oSection1:Cell("E2_PARCELA")	:SetValue( SE2->E2_PARCELA )
		oSection1:Cell("E2_FORNECE")	:SetValue( SE2->E2_FORNECE )
		oSection1:Cell("E2_LOJA")		:SetValue( SE2->E2_LOJA )
		oSection1:Cell("E2_NOMFOR")		:SetValue( SE2->E2_NOMFOR )
		oSection1:Cell("E2_TIPO")		:SetValue( SE2->E2_TIPO )
		oSection1:Cell("E2_EMIS1")		:SetValue( DToC(SE2->E2_EMIS1) )
		oSection1:Cell("E2_VENCTO")		:SetValue( DToC(SE2->E2_VENCTO) )
		oSection1:Cell("E2_VENCREA")	:SetValue( DToC(SE2->E2_VENCREA) )
		oSection1:Cell("E2_NATUREZ")	:SetValue( SE2->E2_NATUREZ )
 		If SE2->E2_TIPO $ MVTXA
			oSection1:Cell("E2_VALOR")	:SetValue( SE2->E2_SALDO*-1 )
			nSubTot -= SE2->E2_SALDO
		Else
			oSection1:Cell("E2_VALOR")	:SetValue( SE2->E2_SALDO )
			nSubTot += SE2->E2_SALDO
		EndIf

		oSection1:PrintLine()
	Next nI

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Oculto colunas para gerar o subtotal dos titulos aglutinados                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oSection1:Cell("E2_FILIAL")	:Hide()
	oSection1:Cell("E2_PREFIXO"):Hide()
	oSection1:Cell("E2_NUM")	:Hide()
	oSection1:Cell("E2_PARCELA"):Hide()
	oSection1:Cell("E2_FORNECE"):Hide()
	oSection1:Cell("E2_LOJA")	:Hide()
	oSection1:Cell("E2_NOMFOR")	:Hide()
	oSection1:Cell("E2_TIPO")	:Hide()
	oSection1:Cell("E2_EMIS1")	:Hide()
	oSection1:Cell("E2_VENCTO")	:Hide()
	oSection1:Cell("E2_VENCREA"):Hide()
	oSection1:Cell("E2_NATUREZ"):Hide()

	oReport:Say(oReport:Row(), 010, "Total de Titulos a Gerar -->> ")
	oSection1:Cell("E2_VALOR")	:SetValue( nSubTot ) 

	oSection1:PrintLine()
EndIf

oSection1:Finish()

aEval(aAreaAtu, {|x| RestArea(x) })

Return Nil
