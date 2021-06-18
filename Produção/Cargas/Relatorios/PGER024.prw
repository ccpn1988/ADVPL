#INCLUDE "PGER024.CH" 
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PGER024  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 16.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio de Controle de Materiais de Terceiros em nosso po-³±±
±±³          ³der e nosso Material em poder de Terceiros.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ PGER024(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function PGER024()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³16.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef(nReg)

Local oReport 
Local oSection1
Local oSection2 
Local oSection3 
Local oCell         
Local aOrdem := {}
Local cTamVal:= TamSX3('B6_CUSTO1' )[1]
Local cTamQtd:= TamSX3('B6_QUANT' )[1]

AjustaSX1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("PGER024",STR0009,"PGER024", {|oReport| ReportPrint(oReport)},STR0001+" "+STR0002+" "+STR0003) //"Relacao de materiais de Terceiros e em Terceiros"##"Este programa ira emitir o Relatorio de Materiais"##"de Terceiros em nosso poder e/ou nosso Material em"##"poder de Terceiros."

oReport:lDisableOrientation := .T.  

oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)

Pergunte("PGER024",.F.)

Aadd( aOrdem, STR0004 ) //" Produto/Local " 
Aadd( aOrdem, STR0005 ) //" Cliente/Fornecedor " 
Aadd( aOrdem, STR0006 ) //" Dt. Mov/Produto " 

oSection1 := TRSection():New(oReport,STR0052,{"SB6"},aOrdem) //"Relacao de materiais de Terceiros e em Terceiros"
oSection1 :SetTotalInLine(.F.)

TRCell():New(oSection1,"B1_ISBN"	,"SB1"	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC"	,"SB1"	,/*Titulo*/	,/*Picture*/,120        	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B6_LOCAL"	,"SB6"	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cCliFor"	,"   "	,/*Titulo*/	,/*Picture*/,6				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cLoja"		,"   "	,/*Titulo*/	,/*Picture*/,2				,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"cNome"		,"   "	,/*Titulo*/	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cNome"):GetFieldInfo("A2_NOME")
TRCell():New(oSection1,"B6_EMISSAO"	,"SB6"	,STR0038	,/*Picture*/,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/) //"DATA DE MOVIMENTACAO : "

oSection2 := TRSection():New(oSection1,STR0053,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros"
oSection2 :SetTotalInLine(.F.)
oSection2 :SetHeaderPage()

TRCell():New(oSection2,"B6_PRODUTO"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_TPCF"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",STR0018,STR0019) })
TRCell():New(oSection2,"B6_CLIFOR"	,"SB6",/*Titulo*/			,/*Picture*/				,TamSX3('B6_CLIFOR' )[1]+5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_LOJA"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_DOC"		,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection2,"B6_SERIE"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_EMISSAO"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_UM"		,"SB6",STR0061				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
TRCell():New(oSection2,"B6_QUANT"	,"SB6",STR0042+CRLF+STR0043	,'@E 9,999' 				,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
TRCell():New(oSection2,"nQuJe"		,"   ",STR0042+CRLF+STR0044	,'@E 9,999' 				,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
TRCell():New(oSection2,"nSaldo"		,"   ","|"+space(cTamQtd-len(STR0045)-2)+STR0045+CRLF+"|"+space(cTamQtd)										,'@E 9,999'					,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
TRCell():New(oSection2,"nPreco"		,"   ","|"+space(cTamVal-len(STR0070)-2)+STR0070+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047				,'@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Preço"
TRCell():New(oSection2,"nPDesc"		,"   ","|"+space(cTamVal-len(STR0071)-2)+STR0071+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047				,'@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"% Desc."##"N.Fiscal"
TRCell():New(oSection2,"nTotNF"		,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047				,'@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
TRCell():New(oSection2,"nTotDev"	,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0048)-2)+STR0048				,'@E 99,999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
TRCell():New(oSection2,"nCusto"		,"   ","|"+space(cTamVal-len(STR0049)-2)+STR0049+"  |"+CRLF+"|"+space(cTamVal-len(STR0050)-2)+STR0050+"  |"	,'@E 999,999,999.99'		,cTamVal	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
TRCell():New(oSection2,"B6_TIPO"	,"SB6",STR0051				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
TRCell():New(oSection2,"B6_SEGUM"	,"SB6",STR0062				,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_QTSEGUM"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B6_DTDIGIT"	,"SB6",/*Titulo*/			,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)				
TRCell():New(oSection2,"B6_UENT"	,"SB6",space(cTamVal-len(STR0072)-2)+STR0072+CRLF+STR0073														,/*Picture*/				,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

TRFunction():New(oSection2:Cell("B6_QUANT")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 9,999'  				,/*uFormula*/,.T.,.T.,,oSection1) 
TRFunction():New(oSection2:Cell("nQuJe")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 9,999'                	,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nSaldo")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 9,999'                	,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nTotNF")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nTotDev")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 99,999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)
TRFunction():New(oSection2:Cell("nCusto")	,NIL,"SUM",/*oBreak*/,/*Titulo*/,'@E 999,999,999.99'		,/*uFormula*/,.T.,.T.,,oSection1)

oSection3 := TRSection():New(oSection2,STR0054,{"SB6"}) //"Relacao de materiais de Terceiros e em Terceiros"
oSection3 :SetTotalInLine(.F.)

TRCell():New(oSection3,"B6_PRODUTO"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_TPCF"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{|| IIf(SB6->B6_TPCF == "C",STR0018,STR0019) })
TRCell():New(oSection3,"B6_CLIFOR"	,"SB6",/*Titulo*/			,/*Picture*/					,15			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_LOJA"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_DOC"		,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,,,,.F.)
TRCell():New(oSection3,"B6_SERIE"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_EMISSAO"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_UM"		,"SB6",STR0061				,/*Picture*/					,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,SB6->B6_SEGUM,SB6->B6_UM) })
TRCell():New(oSection3,"B6_QUANT"	,"SB6",STR0042+CRLF+STR0043	,'@E 9,999' 					,/*Tamanho*/,/*lPixel*/,{|| If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,SB6->B6_QUANT,0,2),SB6->B6_QUANT) }) //"Quantidade"##"Original"
TRCell():New(oSection3,"nQuJe"		,"   ",STR0042+CRLF+STR0044	,'@E 9,999'                 	,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/) //"Quantidade"##"Ja entregue"				
TRCell():New(oSection3,"nSaldo"		,"   ","|"+space(cTamQtd-len(STR0045)-2)+STR0045+CRLF+"|"+space(ctamqtd)									,'@E 9,999'                 	,cTamQtd		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo"
TRCell():New(oSection3,"nTotNF"		,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0047)-2)+STR0047,			'@E 99,999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"N.Fiscal"
TRCell():New(oSection3,"nTotDev"	,"   ","|"+space(cTamVal-len(STR0046)-2)+STR0046+CRLF+"|"+space(cTamVal-len(STR0048)-2)+STR0048,			'@E 99,999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total"##"Devolvido"
TRCell():New(oSection3,"nCusto"		,"   ","|"+space(cTamVal-len(STR0049)-2)+STR0049+"  |"+CRLF+"|"+space(cTamVal-len(STR0050)-2)+STR0050+"  |"	,'@E 999,999,999.99'			,cTamVal		,/*lPixel*/,/*{|| code-block de impressao }*/) //"Custo"##"Prod."
TRCell():New(oSection3,"B6_TIPO"	,"SB6",STR0051				,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,{|| IIF(SB6->B6_TIPO=="D","D","E") }) //"TM"
TRCell():New(oSection3,"B6_SEGUM"	,"SB6",STR0062				,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_QTSEGUM"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection3,"B6_DTDIGIT"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)				
TRCell():New(oSection3,"B6_UENT"	,"SB6",/*Titulo*/			,/*Picture*/					,/*Tamanho*/	,/*lPixel*/,/*{|| code-block de impressao }*/)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³Nereu Humberto Junior  ³ Data ³16.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
//Local nOrdem    := oReport:Section(1):GetOrder()  
Local nOrdem    := oReport:GetOrder() 
Local lListCustM:= .T.
Local lCusFIFO  := GetMV('MV_CUSFIFO')
Local cProdLOCAL:= ""
Local cCliFor   := ""
Local cCliForAnt:= ""
Local lImprime  := .F.
Local lFirstRec := .T.
Local lPlanilha := oReport:nDevice == 4
lListCustM := (mv_par16==1)

dbSelectArea("SB6")
dbSetOrder(nOrdem)

If nOrdem == 1
	oSection1 :SetTotalText(STR0020) //"TOTAL DESTE PRODUTO / LOCAL ------ >"
	If mv_par10 == 1
		oReport:SetTitle(STR0010) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - PRODUTO / ARMAZEM"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0011) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - PRODUTO / ARMAZEM"
	Else
		oReport:SetTitle(STR0012) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - PRODUTO / ARMAZEM"
	EndIf
ElseIf nOrdem == 2
	oSection1 :SetTotalText(STR0032) //"TOTAL DO PRODUTO NO "
	If mv_par10 == 1
		oReport:SetTitle(STR0023) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - CLIENTE / FORNECEDOR"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0024) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - CLIENTE / FORNECEDOR"
	Else
		oReport:SetTitle(STR0025) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - CLIENTE / FORNECEDOR"
	EndIf
ElseIf nOrdem == 3
	oSection2:Cell("B6_DOC"):SetSize(12)
	oSection3:Cell("B6_DOC"):SetSize(12)
	oSection2:Cell("B6_DOC"):SetLineBreak() 
	oSection3:Cell("B6_DOC"):SetLineBreak() 
	oSection1 :SetTotalText(STR0040) //"TOTAL DO PRODUTO NA DATA --------- >"
	If mv_par10 == 1
		oReport:SetTitle(STR0033) //"RELACAO DE MATERIAIS DE TERCEIROS EM NOSSO PODER - DATA DO MOVIMENTO"
	ElseIf mv_par10 == 2
		oReport:SetTitle(STR0034) //"RELACAO DE MATERIAIS NOSSOS EM PODER DE TERCEIROS - DATA DO MOVIMENTO"
	Else
		oReport:SetTitle(STR0035) //"RELACAO DE MATERIAIS DE TERCEIROS E EM TERCEIROS - DATA DO MOVIMENTO"
	EndIf
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatorio                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter(SB6->(LastRec()))

Do Case
		Case nOrdem == 1
			dbSelectArea("SB6")
			dbSeek(xFilial("SB6")+mv_par05,.T.)		    
			cCond := 'SB6->B6_FILIAL == xFilial("SB6") .And. SB6->B6_PRODUTO >= mv_par05 .And. SB6->B6_PRODUTO <= mv_par06'
			oSection1:SetFilter(cCond,SB6->(IndexKey()))

			oSection1:Cell("cCliFor"):Disable()
			oSection1:Cell("cLoja"):Disable()
			oSection1:Cell("cNome"):Disable()
			oSection1:Cell("B6_EMISSAO"):Disable()

			oSection2:Cell("B6_PRODUTO"):Disable()

			oSection3:Cell("B6_PRODUTO"):Disable()
		Case nOrdem == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria arquivo de trabalho usando indice condicional.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB6")
			cIndex  := CriaTrab(NIL,.F.)
			cKey    := 'B6_FILIAL+B6_TPCF+B6_CLIFOR+B6_LOJA+B6_PRODUTO'
			cFilter := SB6->(DbFilter())
			If Empty( cFilter )
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
			Else
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
			EndIf
			
			IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
			nIndex := RetIndex("SB6")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
			cCond := '.T.'
			
			If !lPlanilha
				// Helimar - troquei B1_COD por B1_ISBN
		    	oSection1:Cell("B1_ISBN"):Disable()
		    	oSection1:Cell("B1_DESC"):Disable()
		    EndIf
		    oSection1:Cell("B6_LOCAL"):Disable()
		    oSection1:Cell("B6_EMISSAO"):Disable()
		    
			oSection2:Cell("B6_TPCF"):Disable()
			oSection2:Cell("B6_CLIFOR"):Disable()
			oSection2:Cell("B6_LOJA"):Disable()		    
			
			oSection3:Cell("B6_TPCF"):Disable()
			oSection3:Cell("B6_CLIFOR"):Disable()
			oSection3:Cell("B6_LOJA"):Disable()

		Case nOrdem == 3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria arquivo de trabalho usando indice condicional.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SB6")
			cIndex  := CriaTrab(NIL,.F.)
			cKey    := "B6_FILIAL+DTOS(B6_DTDIGIT)+B6_PRODUTO+B6_CLIFOR+B6_LOJA"
			cFilter := SB6->(DbFilter())
			If Empty( cFilter )
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'"'
			Else
				cFilter := 'B6_FILIAL == "'+xFilial('SB6')+'" .And. ' + cFilter
			EndIf
			IndRegua("SB6",cIndex,cKey,,cFilter,STR0022)		//" Criando Indice ...    "
			nIndex := RetIndex("SB6")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSetOrder(nIndex+1)
			dbGoTop()
			cCond := '.T.'

		    If !lPlanilha
				// Helimar - troquei B1_COD por B1_ISBN
		    	oSection1:Cell("B1_ISBN"):Disable()
		    	oSection1:Cell("B1_DESC"):Disable()
		    EndIf
		    oSection1:Cell("B6_LOCAL"):Disable()
			oSection1:Cell("cCliFor"):Disable()
			oSection1:Cell("cLoja"):Disable()
			oSection1:Cell("cNome"):Disable()
EndCase			

While !oReport:Cancel() .And. !SB6->(Eof()) .And. &(cCond)

	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
	
	SF4->(MsSeek(xFilial("SF4")+SB6->B6_TES))
	If SF4->F4_PODER3 == "D"
		SB6->(dbSkip())
		Loop
	EndIf
	
	If SB6->B6_TPCF == "C"
		If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
			SB6->(dbSkip())
			Loop
		EndIf
	Else
		If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
			SB6->(dbSkip())
			Loop
		EndIf
	Endif	
	
	If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
	    SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
		SB6->B6_QUANT == 0 
		SB6->(dbSkip())
		Loop
	Endif	

	aSaldo  := CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
	nSaldo  := aSaldo[1]
	nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])
	
	If mv_par09 == 2 .And. nSaldo <= 0
		SB6->(dbSkip())
		Loop
	EndIf
	
	If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
		SB6->(dbSkip())
		Loop
	ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
		SB6->(dbSkip())
		Loop
	EndIf

	If nOrdem == 1
		cQuebra := SB6->B6_PRODUTO+SB6->B6_LOCAL
	ElseIf nOrdem == 2
		cQuebra := SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO+SB6->B6_TPCF
	ElseIf nOrdem == 3
		cQuebra := Dtos(SB6->B6_EMISSAO)+SB6->B6_PRODUTO
		lImprime := .T.
	Endif
	
	While !oReport:Cancel() .And. !SB6->(Eof()) .And. xFilial("SB6") == SB6->B6_FILIAL ;
	      .And. Iif(nOrdem==1,cQuebra == SB6->B6_PRODUTO+SB6->B6_LOCAL,If(nOrdem==2,cQuebra == SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO+SB6->B6_TPCF,cQuebra == dTos(SB6->B6_EMISSAO)+SB6->B6_PRODUTO))

		If oReport:Cancel()
			Exit
		EndIf
		
		oReport:IncMeter()
		
		SF4->(MsSeek(xFilial("SF4")+SB6->B6_TES))
		If SF4->F4_PODER3 == "D"
			SB6->(dbSkip())
			Loop
		EndIf
		
		If SB6->B6_TPCF == "C"
			If SB6->B6_CLIFOR   < mv_par01 .Or. SB6->B6_CLIFOR  > mv_par02
				SB6->(dbSkip())
				Loop
			EndIf
		Else
			If SB6->B6_CLIFOR   < mv_par03 .Or. SB6->B6_CLIFOR  > mv_par04
				SB6->(dbSkip())
				Loop
			EndIf
		Endif	
		
		If	SB6->B6_PRODUTO < mv_par05 .Or. SB6->B6_PRODUTO > mv_par06 .Or.;
		    SB6->B6_DTDIGIT < mv_par07 .Or. SB6->B6_DTDIGIT > mv_par08 .Or.;
			SB6->B6_QUANT == 0 
			SB6->(dbSkip())
			Loop
		Endif	

		aSaldo  := CalcTerc(SB6->B6_PRODUTO,SB6->B6_CLIFOR,SB6->B6_LOJA,SB6->B6_IDENT,SB6->B6_TES,,mv_par07,mv_par08)
		nSaldo  := aSaldo[1]
		nPrUnit := IIF(aSaldo[3]==0,SB6->B6_PRUNIT,aSaldo[3])

		// Preco praticado na nota e % de desconto
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		MsSeek(xFilial("SD2")+SB6->B6_DOC+SB6->B6_SERIE+SB6->B6_CLIFOR+SB6->B6_LOJA+SB6->B6_PRODUTO)
		If Found()
			nPreco := SD2->D2_PRUNIT
			nPDesc := (1 - (nPrUnit/nPreco)) * 100
		Else
			nPreco := 0.00                      
			nPDesc := 0
		EndIf
		
		dbSelectArea("SB6")
		
		If mv_par09 == 2 .And. nSaldo <= 0
			SB6->(dbSkip())
			Loop
		EndIf
		
		If mv_par10 == 1 .And. SB6->B6_TIPO != "D"
			SB6->(dbSkip())
			Loop
		ElseIf mv_par10 == 2 .And. SB6->B6_TIPO != "E"
			SB6->(dbSkip())
			Loop
		EndIf

		oSection1:Init()
		If nOrdem == 1
			If cProdLOCAL != SB6->B6_PRODUTO+SB6->B6_LOCAL
				If SB1->(MsSeek(xFilial("SB1")+SB6->B6_PRODUTO))
					oSection1:PrintLine()			
					cProdLOCAL := SB6->B6_PRODUTO+SB6->B6_LOCAL
				Else
					Help(" ",1,"R480PRODUT")
					dbSelectArea("SB6")
					Return .F.
				EndIf
			EndIf
			If !Empty(cProdLocal)
				oSection2:Init()
				
				oSection2:Cell("nPreco"):SetValue(nPreco)
				oSection2:Cell("nPDesc"):SetValue(nPDesc)
				oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
				oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
				oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
				oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
				// Custo na Moeda
				nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
				oSection2:Cell("nCusto"):SetValue(nCusto)
			
				oSection2:PrintLine()
			Endif	
		ElseIf nOrdem == 2
			If cCliForAnt != SB6->B6_TPCF .Or. cNomeCliFor != SB6->B6_CLIFOR+SB6->B6_LOJA
				lFirstRec := .T.
				If SB6->B6_TPCF == "C" 
					dbSelectArea("SA1")
					MsSeek(xFilial("SA1")+SB6->B6_CLIFOR+SB6->B6_LOJA)
					oSection1 :SetTotalText(STR0032+STR0030) //"TOTAL DO PRODUTO NO "##"CLIENTE ---->"###"FORNECEDOR --->"
				Else
					dbSelectArea("SA2")
					MsSeek(xFilial("SA2")+SB6->B6_CLIFOR+SB6->B6_LOJA)
					oSection1 :SetTotalText(STR0032+STR0031) //"TOTAL DO PRODUTO NO "##"FORNECEDOR --->"
				Endif	
				If Found()
					dbSelectArea("SB6")
				  
					oSection1:Cell("cCliFor"):SetTitle(IIf(SB6->B6_TPCF == "C",STR0028,STR0029)) //"CLIENTE / LOJA: "###"FORNECEDOR / LOJA: "
					oSection1:Cell("cCliFor"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_COD,SA2->A2_COD))
					
					oSection1:Cell("cLoja"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_LOJA,SA2->A2_LOJA))
					oSection1:Cell("cNome"):SetValue(Iif(SB6->B6_TPCF == "C",SA1->A1_NOME,SA2->A2_NOME))
				
					If lPlanilha .And. lFirstRec
						SB1->(DbSetOrder(1))
						SB1->(MsSeek(xFilial("SB1")+SB6->B6_PRODUTO))
						// Helimar - troquei B1_COD por B1_ISBN
						oSection1:Cell("B1_ISBN"):SetValue(SB1->B1_ISBN)
						oSection1:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
					EndIf
					oSection1:PrintLine()			

					cNomeCliFor := SB6->B6_CLIFOR+SB6->B6_LOJA
					cCliForAnt 	:= SB6->B6_TPCF
				Else
					Help(" ",1,"R480CLIFOR")
					RetIndex("SB6")
					dbSelectArea("SB6")
					dbSetOrder(1)
					cIndex += OrdBagExt()
					Ferase(cIndex)
					Return .F.
				EndIf
			EndIf
			If Len(cNomeCliFor) != 0
				oSection2:Init()

				oSection2:Cell("nPreco"):SetValue(nPreco)
				oSection2:Cell("nPDesc"):SetValue(nPDesc)
				oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
				oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
				oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
				oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
				// Custo na Moeda
				nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
				oSection2:Cell("nCusto"):SetValue(nCusto)
			
				If lPlanilha .And. !lFirstRec
					SB1->(DbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1")+SB6->B6_PRODUTO))
					// Helimar - troquei B1_COD por B1_ISBN
					oSection1:Cell("B1_ISBN"):SetValue(SB1->B1_ISBN)
					oSection1:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
					oSection1:Cell("B6_LOCAL"):Disable()
					oSection1:Cell("cCliFor"):Disable()
					oSection1:Cell("cLoja"):Disable()
					oSection1:Cell("cNome"):Disable()
					oSection1:Cell("B6_EMISSAO"):Disable()
					oSection1:PrintLine()
				EndIf
				lFirstRec := .F.
				oSection2:PrintLine()
			Endif
		ElseIf nOrdem == 3
			If lImprime
				If lPlanilha
					SB1->(DbSetOrder(1))
					SB1->(MsSeek(xFilial("SB1")+SB6->B6_PRODUTO))
					// Helimar - troquei B1_COD por B1_ISBN
					oSection1:Cell("B1_ISBN"):SetValue(SB1->B1_ISBN)
					oSection1:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
					oSection1:PrintLine()
				Else
					oSection1:PrintLine()
				EndIf				
				lImprime := .F.
			Endif	

			oSection2:Init()
			oSection2:Cell("nPreco"):SetValue(nPreco)
    		oSection2:Cell("nPDesc"):SetValue(nPDesc)
			oSection2:Cell("nQuJe"):SetValue(If(mv_par15==1,ConvUM(SB6->B6_PRODUTO,(SB6->B6_QUANT - nSaldo),0,2),(SB6->B6_QUANT - nSaldo)))
			oSection2:Cell("nSaldo"):SetValue(If(mv_par15==1,ConvUm(SB6->B6_PRODUTO,nSaldo,0,2),nSaldo))
			oSection2:Cell("nTotNF"):SetValue(aSaldo[5])
			oSection2:Cell("nTotDev"):SetValue((B6_QUANT - nSaldo) * nPrUnit)
			// Custo na Moeda
			nCusto := (&(If(lListCustM.Or.(!lListCustM.And.!lCusFIFO), 'B6_CUSTO', 'B6_CUSFF')+Str(mv_par11,1,0)) / SB6->B6_QUANT) * nSaldo	
			oSection2:Cell("nCusto"):SetValue(nCusto)
		
			oSection2:PrintLine()				
		Endif	
		// Lista as devolucoes da remessa
		If mv_par12 == 1 .And. ((SB6->B6_QUANT - nSaldo) > 0)
			aAreaSB6 := SB6->(GetArea())
			SB6->(dbSetOrder(3))
			cSeek:=xFilial("SB6")+SB6->B6_IDENT+SB6->B6_PRODUTO+"D"
			If dbSeek(cSeek)
				oReport:PrintText(STR0041) //"Notas Fiscais de Retorno"
				Do While !Eof() .And. SB6->B6_FILIAL+SB6->B6_IDENT+SB6->B6_PRODUTO+SB6->B6_PODER3 == cSeek
					If SB6->B6_DTDIGIT < mv_par13 .Or. SB6->B6_DTDIGIT > mv_par14
						SB6->(dbSkip())
						Loop
					Endif
					oSection3:Init(.F.)
					If nOrdem == 2
						oSection3:Cell("B6_PRODUTO"):Hide()
					Endif	
					oSection3:Cell("nQuJe"):Hide()
					oSection3:Cell("nSaldo"):Hide()
					oSection3:Cell("nTotDev"):Hide()
					oSection3:Cell("nCusto"):Hide()
					
					oSection3:Cell("nTotNF"):SetValue(SB6->B6_QUANT * nPrUnit)
					oSection3:PrintLine()
					dbSkip()
				EndDo
				oSection3:Finish()
			EndIf
			RestArea(aAreaSB6)
		EndIf					
        dbSelectArea("SB6")    
		dbSkip()
	EndDo
	oSection2:Finish()
	oSection1:Finish()
EndDo
		
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³AjustaSX1 ºAutor³Nereu Humberto Junior º Data ³ 16/06/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PGER024                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

PutSx1("PGER024","15","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chf", "N", 1, 0, 2,"C", "", "", "", "","mv_par15","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
PutSX1Help("P.PGER02415.",{'Imprime as Quantidades na 2a UM?        ', 'Sim=Utiliza a 2aUM na impressao         ', 'Nao=Utiliza a 1aUM na impressao(padrao) '}, {'Print the quantities at 2nd MU?         ', 'Yes=Uses 2nd MU at the print            ',  'No=Uses 1st MU at the print (defaut)    '}, {'¿Imprime las cantidades en la 2a UM?    ', 'Si=Utiliza la 2aUM en la impresion      ', 'No=Utiliza la 1aUM en la impresion(est.)'})

PutSx1('PGER024','16','Lista Custo        ?','¿Lista Costo       ?','List Cost          ?','mv_chg','N',01,0,1,'C','','','','','mv_par16','Medio','Promedio','Average','','FIFO/PEPS','FIFO/PEPS','FIFO','','','','','','','','','', {'Informe o tipo de custo a ser listado:  ', '1. Custo Medio                          ', '2. Custo FIFO/PEPS(p/"MV_CUSFIFO" ativo)'}, {'Inform the kind of cost to be listed:   ', '1. Average Cost                         ', '2. FIFO Cost (with "MV_CUSFIFO" active) '}, {'Informe el tipo de costo a ser listado: ', '1. Costo Promedio                       ', '2. Costo FIFO/PEPS(p/"MV_CUSFIFO"activo)'})

Return Nil
