#include "protheus.ch"
#include "topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥EST040    ∫Autor  ≥Helimar Tavares     ∫ Data ≥  04/05/17   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Relatorio Mapa de MovimentaÁıes                             ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥GEN - Estoque/Custos                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ

Alteraoes:

/*/

User Function EST040()

Local oReport
Local cPerg := "EST040"

//Cria grupo de perguntas
f001(cPerg)

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: f001
Descricao: Cria grupo de perguntas
*/

Static Function f001(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""


//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emiss„o de:", "Dt Emiss„o de:", "Dt Emiss„o de:", cMVCH, "D", 8, 0, 0, "G", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emiss„o atÈ:", "Dt Emiss„o atÈ:", "Dt Emiss„o atÈ:", cMVCH , "D", 8, 0, 0, "G", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "B1_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Produto de:"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------  
cCpoPer := "B1_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Produto atÈ:"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "ArmazÈm:", "ArmazÈm:", "ArmazÈm:", cMVCH, "C", 2, 0, 2, "C", "", "", "", "", cMVPAR, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
cCpoPer := "B1_TIPO"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo, nTamPer, 0, 0, cTpoPer, "", cF3Perg, "", "", cMVPAR, cOpc1, "", "", "", cOpc2, "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Tipo de RelatÛrio.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSX1(cPerg, cItPerg, "RelatÛrio:", "RelatÛrio:", "RelatÛrio:", cMVCH, "C", 1, 0, 1, "C", "", "", "", "", cMVPAR, "SintÈtico", "SintÈtico", "SintÈtico", "", "AnalÌtico", "AnalÌtico", "AnalÌtico", "", "", "", "", "","", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio
*/

Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio

oReport := TReport():New("EST040","EST040 - MAPA DE MOVIMENTA«’ES",cPerg,{|oReport| PrintReport(oReport)},"EST040 - MAPA DE MOVIMENTA«’ES",.T.)

oReport:NDEVICE := 4

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T.
oReport:lDisableOrientation := .T.

//Secao do relatorio
oSection1 := TRSection():New(oReport,"EST040 - MAPA DE MOVIMENTA«’ES","")

//Celulas da secao
If (MV_PAR07 == 2)
	TRCell():New(oSection1,"CODIGO"				,"   ","CÛdigo Produto"	,,10)
	TRCell():New(oSection1,"ISBN"				,"   ","ISBN"			,,15)
EndIf
TRCell():New(oSection1,"AREA"				,"   ","¡rea"			,,15)
If (MV_PAR07 == 2)
	TRCell():New(oSection1,"DESCRICAO"			,"   ","DescriÁ„o"		,,20)
EndIf
TRCell():New(oSection1,"QTDCOMPRA"		,"   ","Compras"+CRLF+"Quantidade"							,, 8)
TRCell():New(oSection1,"CSTCOMPRA"		,"   ","Compras"+CRLF+"Valor"								,,18)
TRCell():New(oSection1,"QTDDEVVND"		,"   ","DevoluÁ„o"+CRLF+"Vendas"+CRLF+"Quantidade"			,, 8)
TRCell():New(oSection1,"CSTDEVVND"		,"   ","DevoluÁ„o"+CRLF+"Vendas"+CRLF+"Valor"				,,18)
TRCell():New(oSection1,"QTDMOVINT"		,"   ","Movimentos Internos"+CRLF+"Quantidade"				,, 8)
TRCell():New(oSection1,"CSTMOVINT"		,"   ","Movimentos Internos"+CRLF+"Valor"	  				,,18)
TRCell():New(oSection1,"QTDSAIKIT"		,"   ","SaÌdas Kits e Conserto Internas"+CRLF+"Quantidade"	,, 8)
TRCell():New(oSection1,"CSTSAIKIT"		,"   ","SaÌdas Kits e conserto Internas"+CRLF+"Valor"		,,18)
TRCell():New(oSection1,"QTDENTKIT"		,"   ","Entradas Kits e Conserto Internas"+CRLF+"Quantidade",, 8)
TRCell():New(oSection1,"CSTENTKIT"		,"   ","Entradas Kits e conserto Internas"+CRLF+"Valor"		,,18)
TRCell():New(oSection1,"QTDVENDA"		,"   ","Vendas"+CRLF+"Quantidade"		 					,, 8)
TRCell():New(oSection1,"CSTVENDA"		,"   ","Vendas"+CRLF+"Valor"								,,18)
TRCell():New(oSection1,"QTDOFRTDA"		,"   ","Ofertas DA"+CRLF+"Quantidade"						,, 8)
TRCell():New(oSection1,"CSTOFRTDA"		,"   ","Ofertas DA"+CRLF+"Valor"							,,18)
TRCell():New(oSection1,"QTDOFTCRM"		,"   ","Ofertas CRM"+CRLF+"Quantidade"						,, 8)
TRCell():New(oSection1,"CSTOFTCRM"		,"   ","Ofertas CRM"+CRLF+"Valor"							,,18)
TRCell():New(oSection1,"QTDDEVOFRTDA"	,"   ","DevoluÁ„o Oferta DA"+CRLF+"Quantidade"				,, 8)
TRCell():New(oSection1,"CSTDEVOFRTDA"	,"   ","DevoluÁ„o Oferta DA"+CRLF+"Valor"					,,18)
TRCell():New(oSection1,"QTDDEVOFTCRM"	,"   ","DevoluÁ„o Oferta CRM"+CRLF+"Quantidade"				,, 8)
TRCell():New(oSection1,"CSTDEVOFTCRM"	,"   ","DevoluÁ„o Oferta CRM"+CRLF+"Valor"					,,18)
TRCell():New(oSection1,"QTDSAICSG"		,"   ","SaÌdas ConsignaÁ„o"+CRLF+"Quantidade"				,, 8)
TRCell():New(oSection1,"CSTSAICSG"		,"   ","SaÌdas ConsignaÁ„o"+CRLF+"Valor"					,,18)
TRCell():New(oSection1,"QTDRETCSG"		,"   ","Retornos ConsignaÁ„o"+CRLF+"Quantidade"				,, 8)
TRCell():New(oSection1,"CSTRETCSG"		,"   ","Retornos ConsignaÁ„o"+CRLF+"Valor"					,,18)
TRCell():New(oSection1,"QTDDEVCSG"		,"   ","DevoluÁ„o ConsignaÁ„o"+CRLF+"Quantidade"			,, 8)
TRCell():New(oSection1,"CSTDEVCSG"		,"   ","DevoluÁ„o ConsignaÁ„o"+CRLF+"Valor"					,,18)
TRCell():New(oSection1,"QTDOUTSAI"		,"   ","Outras SaÌdas"+CRLF+"Quantidade"					,, 8)
TRCell():New(oSection1,"CSTOUTSAI"		,"   ","Outras SaÌdas"+CRLF+"Valor"							,,18)
TRCell():New(oSection1,"QTDOUTENT"		,"   ","Outras Entradas"+CRLF+"Quantidade"					,, 8)
TRCell():New(oSection1,"CSTOUTENT"		,"   ","Outras Entradas"+CRLF+"Valor"						,,18)

//Totalizadores
TRFunction():New(oSection1:Cell("QTDCOMPRA")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTCOMPRA")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDDEVVND")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTDEVVND")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDMOVINT")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTMOVINT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDSAIKIT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTSAIKIT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDENTKIT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTENTKIT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDVENDA")	   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTVENDA")		,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDOFRTDA")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTOFRTDA")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDOFTCRM")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTOFTCRM")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDDEVOFRTDA")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTDEVOFRTDA")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDDEVOFTCRM")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTDEVOFTCRM")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDSAICSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTSAICSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDRETCSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTRETCSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDDEVCSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTDEVCSG")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDOUTSAI")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTOUTSAI")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("QTDOUTENT") 	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("CSTOUTENT")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection1)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio
*/

Static Function PrintReport(oReport)

Local oSection1	:= oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cQuery	:= ""

If oReport:NDEVICE <> 4
	MsgInfo("Este relatÛrio somente poder· ser impresso em Excel.")
	Return(.t.)
Endif

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

oReport:SetLandScape()

//Cria query
_cQuery := " SELECT NVL(SZ7.Z7_DESC,'*** SEM ¡REA ***') AREA,
If (MV_PAR07 == 2)
	_cQuery += "        SB1.B1_COD, SB1.B1_ISBN, SB1.B1_DESC,
EndIf	
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_004','F4_104') THEN QUANT ELSE 0 END) QTDCOMPRA, SUM(CASE WHEN M.TES IN ('F4_004','F4_104') THEN CUSTO ELSE 0 END) CSTCOMPRA,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_052','F4_053','F4_055','F4_452') THEN QUANT ELSE 0 END) QTDDEVVND, SUM(CASE WHEN M.TES IN ('F4_052','F4_053','F4_055','F4_452') THEN CUSTO ELSE 0 END) CSTDEVVND,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F5_002','F5_502') THEN QUANT ELSE 0 END) QTDMOVINT, SUM(CASE WHEN M.TES IN ('F5_002','F5_502') THEN CUSTO ELSE 0 END) CSTMOVINT,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_526','F4_531') THEN QUANT ELSE 0 END) QTDSAIKIT, SUM(CASE WHEN M.TES IN ('F4_526','F4_531') THEN CUSTO ELSE 0 END) CSTSAIKIT,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_002','F4_005','F4_065') THEN QUANT ELSE 0 END) QTDENTKIT, SUM(CASE WHEN M.TES IN ('F4_002','F4_005','F4_065') THEN CUSTO ELSE 0 END) CSTENTKIT,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_501','F4_502','F4_503','F4_505','F4_506','F4_515','F4_524','F4_525','F4_536','F4_545','F4_801') THEN QUANT ELSE 0 END) QTDVENDA, SUM(CASE WHEN M.TES IN ('F4_501','F4_502','F4_503','F4_505','F4_506','F4_515','F4_524','F4_525','F4_536','F4_545','F4_801') THEN CUSTO ELSE 0 END) CSTVENDA,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_517','F4_818') THEN QUANT ELSE 0 END) QTDOFRTDA, SUM(CASE WHEN M.TES IN ('F4_517','F4_818') THEN CUSTO ELSE 0 END) CSTOFRTDA,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_516') THEN QUANT ELSE 0 END) QTDOFTCRM, SUM(CASE WHEN M.TES IN ('F4_516') THEN CUSTO ELSE 0 END) CSTOFTCRM,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_062') THEN QUANT ELSE 0 END) QTDDEVOFRTDA, SUM(CASE WHEN M.TES IN ('F4_062') THEN CUSTO ELSE 0 END) CSTDEVOFRTDA,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_061') THEN QUANT ELSE 0 END) QTDDEVOFTCRM, SUM(CASE WHEN M.TES IN ('F4_061') THEN CUSTO ELSE 0 END) CSTDEVOFTCRM,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_520','F4_820') THEN QUANT ELSE 0 END) QTDSAICSG, SUM(CASE WHEN M.TES IN ('F4_520','F4_820') THEN CUSTO ELSE 0 END) CSTSAICSG,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_521','F4_821') THEN QUANT ELSE 0 END) QTDRETCSG, SUM(CASE WHEN M.TES IN ('F4_521','F4_821') THEN CUSTO ELSE 0 END) CSTRETCSG,
_cQuery += "        SUM(CASE WHEN M.TES IN ('F4_013','F4_014','F4_038','F4_413') THEN QUANT ELSE 0 END) QTDDEVCSG, SUM(CASE WHEN M.TES IN ('F4_013','F4_014','F4_038','F4_413') THEN CUSTO ELSE 0 END) CSTDEVCSG,
_cQuery += "        SUM(CASE WHEN M.TES NOT IN ('F5_501','F5_502','F5_999','F4_526','F4_531','F4_501','F4_502','F4_503','F4_505','F4_506','F4_515','F4_524','F4_525','F4_536','F4_545','F4_801','F4_517','F4_818','F4_516','F4_520','F4_820','F4_521','F4_821') AND M.TIPO = 'S' THEN QUANT ELSE 0 END) QTDOUTSAI,
_cQuery += "        SUM(CASE WHEN M.TES NOT IN ('F5_501','F5_502','F5_999','F4_526','F4_531','F4_501','F4_502','F4_503','F4_505','F4_506','F4_515','F4_524','F4_525','F4_536','F4_545','F4_801','F4_517','F4_818','F4_516','F4_520','F4_820','F4_521','F4_821') AND M.TIPO = 'S' THEN CUSTO ELSE 0 END) CSTOUTSAI,
_cQuery += "        SUM(CASE WHEN M.TES NOT IN ('F4_004','F4_104','F4_052','F4_053','F4_055','F4_452','F5_001','F5_002','F5_100','F5_499','F4_002','F4_005','F4_065','F4_062','F4_061','F4_013','F4_014','F4_038','F4_413') AND M.TIPO = 'E' THEN QUANT ELSE 0 END) QTDOUTENT,
_cQuery += "        SUM(CASE WHEN M.TES NOT IN ('F4_004','F4_104','F4_052','F4_053','F4_055','F4_452','F5_001','F5_002','F5_100','F5_499','F4_002','F4_005','F4_065','F4_062','F4_061','F4_013','F4_014','F4_038','F4_413') AND M.TIPO = 'E' THEN CUSTO ELSE 0 END) CSTOUTENT
_cQuery += "   FROM (SELECT SD1.D1_COD CODIGO, 'F4_'||SD1.D1_TES TES, SD1.D1_LOCAL LOCAL, SF4.F4_TIPO TIPO, SUM(SD1.D1_QUANT) QUANT, SUM(SD1.D1_CUSTO) CUSTO
_cQuery += "           FROM " + RetSqlName("SD1") + " SD1
_cQuery += "           INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD1.D1_TES = SF4.F4_CODIGO
_cQuery += "          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "            AND SD1.D1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
If !Empty(MV_PAR05)
	_cQuery += "            AND SD1.D1_LOCAL = '" + MV_PAR05 + "'"
EndIf
_cQuery += "            AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery += "            AND SD1.D_E_L_E_T_ = ' '
_cQuery += "            AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "            AND SF4.D_E_L_E_T_ = ' '
_cQuery += "          GROUP BY SD1.D1_COD, 'F4_'||SD1.D1_TES, SD1.D1_LOCAL, SF4.F4_TIPO
_cQuery += "          UNION ALL
_cQuery += "         SELECT SD2.D2_COD, 'F4_'||SD2.D2_TES, SD2.D2_LOCAL, SF4.F4_TIPO, SUM(SD2.D2_QUANT) QUANT, SUM(SD2.D2_CUSTO1) CUSTO
_cQuery += "           FROM " + RetSqlName("SD2") + " SD2
_cQuery += "           INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO
_cQuery += "          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "            AND SD2.D2_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
If !Empty(MV_PAR05)
	_cQuery += "            AND SD2.D2_LOCAL = '" + MV_PAR05 + "'"
EndIf
_cQuery += "            AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "            AND SD2.D_E_L_E_T_ = ' '
_cQuery += "            AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "            AND SF4.D_E_L_E_T_ = ' '
_cQuery += "          GROUP BY SD2.D2_COD, 'F4_'||SD2.D2_TES, SD2.D2_LOCAL, SF4.F4_TIPO
_cQuery += "          UNION ALL
_cQuery += "         SELECT SD3.D3_COD, 'F5_'||SD3.D3_TM TES, SD3.D3_LOCAL, CASE WHEN SD3.D3_TM = '499' THEN 'E' WHEN SD3.D3_TM = '999' THEN 'S' WHEN F5_TIPO = 'D' THEN 'E' WHEN F5_TIPO = 'R' THEN 'S' END,
_cQuery += "                CASE WHEN SD3.D3_TM < 500 THEN SUM(SD3.D3_QUANT) ELSE SUM(SD3.D3_QUANT)*(-1) END QUANT,
_cQuery += "                CASE WHEN SD3.D3_TM < 500 THEN SUM(SD3.D3_CUSTO1) ELSE SUM(SD3.D3_CUSTO1)*(-1) END CUSTO
_cQuery += "           FROM " + RetSqlName("SD3") + " SD3
_cQuery += "           LEFT JOIN " + RetSqlName("SF5") + " SF5 ON SD3.D3_TM = SF5.F5_CODIGO AND SF5.F5_FILIAL = '    ' AND SF5.D_E_L_E_T_ = ' '
_cQuery += "          WHERE SD3.D3_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "            AND SD3.D3_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"
If !Empty(MV_PAR05)
	_cQuery += "            AND SD3.D3_LOCAL = '" + MV_PAR05 + "'"
EndIf
_cQuery += "            AND SD3.D3_FILIAL = '" + xFilial("SD3") + "'"
_cQuery += "            AND SD3.D_E_L_E_T_ = ' '
_cQuery += "          GROUP BY SD3.D3_COD, SD3.D3_TM, SD3.D3_LOCAL, CASE WHEN SD3.D3_TM = '499' THEN 'E' WHEN SD3.D3_TM = '999' THEN 'S' WHEN F5_TIPO = 'D' THEN 'E' WHEN F5_TIPO = 'R' THEN 'S' END
_cQuery += "          ORDER BY 1) M
_cQuery += "   INNER JOIN " + RetSqlName("SB1") + " SB1 ON M.CODIGO = SB1.B1_COD AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR06)
	_cQuery += "            AND SB1.B1_TIPO = '" + MV_PAR06 + "'"
EndIf
_cQuery += "   INNER JOIN " + RetSqlName("SB5") + " SB5 ON M.CODIGO = SB5.B5_COD AND SB5.B5_FILIAL = '" + xFilial("SB5") + "' AND SB5.D_E_L_E_T_ = ' '
_cQuery += "   LEFT JOIN " + RetSqlName("SZ7") + " SZ7 ON SB5.B5_XAREA = SZ7.Z7_AREA AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "' AND SZ7.D_E_L_E_T_ = ' '
_cQuery += "  GROUP BY SZ7.Z7_DESC
If (MV_PAR07 == 2)
	_cQuery += "         , SB1.B1_COD, SB1.B1_ISBN, SB1.B1_DESC	
	_cQuery += "  ORDER BY SB1.B1_COD
Else
	_cQuery += "  ORDER BY SZ7.Z7_DESC
EndIf	

If Select(cAlias1) > 0
	dbSelectArea(cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), cAlias1, .F., .T.)

(cAlias1)->(dbGoTop())

Do While !(cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection1:Init()
	
	If (MV_PAR07 == 2)
		oSection1:Cell("CODIGO"):SetValue((cAlias1)->B1_COD)
		oSection1:Cell("ISBN"):SetValue((cAlias1)->B1_ISBN)
		oSection1:Cell("DESCRICAO"):SetValue((cAlias1)->B1_DESC)
	EndIf
	oSection1:Cell("AREA"):SetValue((cAlias1)->AREA)
	oSection1:Cell("QTDCOMPRA"):SetValue((cAlias1)->QTDCOMPRA)
	oSection1:Cell("CSTCOMPRA"):SetValue((cAlias1)->CSTCOMPRA)
	oSection1:Cell("QTDDEVVND"):SetValue((cAlias1)->QTDDEVVND)
	oSection1:Cell("CSTDEVVND"):SetValue((cAlias1)->CSTDEVVND)
	oSection1:Cell("QTDMOVINT"):SetValue((cAlias1)->QTDMOVINT)
	oSection1:Cell("CSTMOVINT"):SetValue((cAlias1)->CSTMOVINT)
	oSection1:Cell("QTDSAIKIT"):SetValue((cAlias1)->QTDSAIKIT)
	oSection1:Cell("CSTSAIKIT"):SetValue((cAlias1)->CSTSAIKIT)
	oSection1:Cell("QTDENTKIT"):SetValue((cAlias1)->QTDENTKIT)
	oSection1:Cell("CSTENTKIT"):SetValue((cAlias1)->CSTENTKIT)
	oSection1:Cell("QTDVENDA"):SetValue((cAlias1)->QTDVENDA)
	oSection1:Cell("CSTVENDA"):SetValue((cAlias1)->CSTVENDA)
	oSection1:Cell("QTDOFRTDA"):SetValue((cAlias1)->QTDOFRTDA)
	oSection1:Cell("CSTOFRTDA"):SetValue((cAlias1)->CSTOFRTDA)
	oSection1:Cell("QTDOFTCRM"):SetValue((cAlias1)->QTDOFTCRM)
	oSection1:Cell("CSTOFTCRM"):SetValue((cAlias1)->CSTOFTCRM)
	oSection1:Cell("QTDDEVOFRTDA"):SetValue((cAlias1)->QTDDEVOFRTDA)
	oSection1:Cell("CSTDEVOFRTDA"):SetValue((cAlias1)->CSTDEVOFRTDA)
	oSection1:Cell("QTDDEVOFTCRM"):SetValue((cAlias1)->QTDDEVOFTCRM)
	oSection1:Cell("CSTDEVOFTCRM"):SetValue((cAlias1)->CSTDEVOFTCRM)
	oSection1:Cell("QTDSAICSG"):SetValue((cAlias1)->QTDSAICSG)
	oSection1:Cell("CSTSAICSG"):SetValue((cAlias1)->CSTSAICSG)
	oSection1:Cell("QTDRETCSG"):SetValue((cAlias1)->QTDRETCSG)
	oSection1:Cell("CSTRETCSG"):SetValue((cAlias1)->CSTRETCSG)
	oSection1:Cell("QTDDEVCSG"):SetValue((cAlias1)->QTDDEVCSG)
	oSection1:Cell("CSTDEVCSG"):SetValue((cAlias1)->CSTDEVCSG)
	oSection1:Cell("QTDOUTSAI"):SetValue((cAlias1)->QTDOUTSAI)
	oSection1:Cell("CSTOUTSAI"):SetValue((cAlias1)->CSTOUTSAI)
	oSection1:Cell("QTDOUTENT"):SetValue((cAlias1)->QTDOUTENT)
	oSection1:Cell("CSTOUTENT"):SetValue((cAlias1)->CSTOUTENT)

	oSection1:PrintLine()
	
	(cAlias1)->(dbSkip())
EndDo                    

DbSelectArea(cAlias1)
DbCloseArea()

Return(.t.)
