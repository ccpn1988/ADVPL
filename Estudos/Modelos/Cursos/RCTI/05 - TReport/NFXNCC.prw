#include 'protheus.ch'
#include 'parmtype.ch'
#include "topconn.ch"
#Include "Report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NFXNCC    ºAutor  ³Caio Neves  - Loop  º Data ³  30/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de títulos NF e NCC				                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//DECLARAÇÃO DE VARIÁVEIS
User Function NFXNCC()
Local oReport
Local cPerg:= "NFXNCC"
Private _cAlias := GetNextAlias()

	
//CRIAÇÃO GRUPO DE PERGUNTAS
AjustaSX1(cPerg)	

//CARREGA GRUPO DE PERGUNTAS
IF !Pergunte(cPerg,.T.)
	Return Nil
EndIF

oReport := ReportDef(cPerg) //CARREGA A ESTRUTURA DO RELATÓRIO
oReport	:PrintDialog() //APRESENTA TELA DE IMPRESSÂO PADRÂO

Return

Static Function AjustaSX1(cPerg)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= Sx1->(GetArea())
Local cItPerg 	:= "00"		//Ordem da Pergunta
Local cMVCH 	:= "MV_CH0" 
Local CMVPAR	:= "MV_PAR00"
Local aHelpPor	:= {}
Local aHelEng	:= {""}
Local aHelSpa	:= {""}
Local cTitPer	:= ""

//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 0 - MV_PAR01-------------------------------------------------------

cCpoPer	:= "E1_FILIAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe o código da Filial")
AADD(aHelpPor,"De:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,cF3Perg	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )


//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 02 - MV_PAR02-------------------------------------------------------

cCpoPer	:= "E1_FILIAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe o código da Filial")
AADD(aHelpPor,"Até:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,cF3Perg	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""		,""				 )


//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 03 - MV_PAR03-------------------------------------------------------

cCpoPer	:= "E1_VENCREA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe data inicial")
AADD(aHelpPor,"do vencimento?:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,""	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )

//----------------------------------------------------------------------DEFINIÇÂO PERGUNTA 04 - MV_PAR04-------------------------------------------------------

cCpoPer	:= "E1_VENCREA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
nTamPer := TamSx3(cCpoPer)[1] //FILIAL TAMANHO
cTpoPer	:= "G" //G-get - C-combo
cOpc1	:= ""
cOpc2	:= ""

// CRIANDO TITULO E HELP DAS PERGUNTA
aHelpPor	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Informe data final")
AADD(aHelpPor,"do vencimento?:")

//DEFININDO SEQUENCIAL DO CADASTRO DE PERGUNTA

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVCH,2))

//		   cGrupo cOrde    cDesPor	cDesSpa	cDesEng	 cVar	 cTipo   cTamanho cDecimal	nPreSel	cGSC	cValid  cF3 		cGrpSXG	cPyme	cVar01			cDef1Por cDef1Spa	cDef1Eng	cCnt01	  	cDef2Por		cDef2Spa	cDef2Eng	cDef3Por cDef3Spa	cDef3Eng	cDef4Por cDef4Spa	cDef4Eng	cDef5Por	cDef5Spa	cDef5Eng	aHelpPor			aHelpEng			aHelpSpa			cHelp)
u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,	0,		0,       cTpoPer,""		,""	,""		,""		,cMVPAR			,cOpc1	,""			,""			,""			,cOpc2			,""			,""			,""		,""			,""			,""		 ,""		,""			,""			,""			,""			,aHelpPor			,""			,""				 )


//----------------------------------------------------------------------CRIANDO ESTRUTURA DO RELATÓRIO---------------------------------------------------------

/*Função ReportDef - Cria a estrutura do relatório*/

Static Function ReportDef(cPerg)

Local oReport 
Local oSection1


//DECLARANDO RELATÓRIO
oReport	:= TReport():New("NFXNCC","Títulos a Receber", cPerg,{|oReport| PrintReport(oReport)},"Títulos a Receber")

//AJUSTES NAS DEFINIÇÕES
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:cmsgPrint := "Gerando Títulos à Receber"
oReport:SetLandscape()  


//SEÇÃO DO RELATÒRIO
oSection1 := TRSection():New(oReport,"Tipos de NF","")

//CELULAS DO RELATÒRIO
//		 New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHead,erAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection1,"E1_FILIAL"	,_cAlias,"E1_FILIAL"	,,15)
TRCell():New(oSection1,"E1_TIPO"	,_cAlias,"E1_TIPO"		,,15)
TRCell():New(oSection1,"E1_PREFIXO"	,_cAlias,"E1_PREFIXO"	,,15)
TRCell():New(oSection1,"E1_NUM"		,_cAlias,"E1_NUM"		,,15)
TRCell():New(oSection1,"E1_PARCELA"	,_cAlias,"E1_PARCELA"	,,15)
TRCell():New(oSection1,"E1_CLIENTE"	,_cAlias,"E1_CLIENTE"	,,15)
TRCell():New(oSection1,"E1_LOJA"	,_cAlias,"E1_LOJA"		,,15)
TRCell():New(oSection1,"E1_NOMCLI"	,_cAlias,"E1_NOMCLI"	,,50)
TRCell():New(oSection1,"E1_EMISSAO"	,_cAlias,"E1_EMISSAO"	,,10)
TRCell():New(oSection1,"E1_VENCREA"	,_cAlias,"E1_VENCREA"	,,10)
TRCell():New(oSection1,"E1_VALOR"	,_cAlias,"E1_VALOR"		,,20)

//QUEBRA SEÇÃO
//					New(oParent,uBreak,uTitle,lTotalInLine,cName,lPageBreak)
oBreak := TRBreak():New(oSection1,oSection1:Cell("E1_TIPO"),"Tipo NF",.F.)

//TOTALIZADORES
//			 New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell("E1_VALOR"),NIL,"SUM",oBreak,,,,.T.,.T.)

oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

//----------------------------------------------------------------------GERANDO DADOS DO RELATÓRIO---------------------------------------------------------

/*Função PrintReport - Cria a estrutura do relatório*/

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cQuery	:= ""
Local _cAlias	:= GetNextAlias()

_cParm2	:= DTOS(MV_PAR03)
_cParm3	:= DTOS(MV_PAR04)

IF Empty(MV_PAR03) .AND.Empty(MV_PAR04)
	Alert("Obrigatório o preechimento dos vencimentos")
	Return Nil
EndIF

cQuery := " SELECT " + CRLF
cQuery += " SE1.E1_FILIAL, SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA," + CRLF
cQuery += " SE1.E1_TIPO,SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_NOMCLI,SE1.E1_EMISSAO, " + CRLF
cQuery += " SE1.E1_VENCREA,SE1.E1_VALOR " + CRLF
cQuery += " FROM " + RetSQLName("SE1")  + " SE1 " + CRLF
cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'" + CRLF
cQuery += " AND SE1.E1_VENCREA BETWEEN '" + _cParm2 + "' AND '" + _cParm3 + "'" + CRLF
cQuery += " AND SE1.E1_TIPO IN ('NF','NCC') " + CRLF
cQuery += " AND SE1.D_E_L_E_T_ = ' ' "

//VALIDANDO SE A TABE ESTA EM USO

IF Select(_cAlias) > 0
	dbSelectArea(_cAlias)
EndIF

//EXECUTANDO A QUERY
DbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),_cAlias,.F.,.T.)
(_cAlias)->(dbGoTop())

//INICIANDO A IMPRESSÃO
While !(_cAlias)->(EOF()) .AND. !oReport:Cancel()
	
	oReport:IncMeter() //Incrementa a régua de progressão do relatório.
	
	oSection1:Init() //Inicializa as configurações e define a primeira página do relatório.
	
	oSection1:Cell("E1_FILIAL"	):SetValue((_cAlias)->E1_FILIAL)
	oSection1:Cell("E1_TIPO"	):SetValue((_cAlias)->E1_TIPO )
	oSection1:Cell("E1_PREFIXO"	):SetValue((_cAlias)->E1_PREFIXO)
	oSection1:Cell("E1_NUM"		):SetValue((_cAlias)->E1_NUM)
	oSection1:Cell("E1_PARCELA"	):SetValue((_cAlias)->E1_PARCELA)
	oSection1:Cell("E1_CLIENTE"	):SetValue((_cAlias)->E1_CLIENTE)
	oSection1:Cell("E1_LOJA"	):SetValue((_cAlias)->E1_LOJA)
	oSection1:Cell("E1_NOMCLI"	):SetValue((_cAlias)->E1_NOMCLI)
	oSection1:Cell("E1_EMISSAO"	):SetValue((_cAlias)->E1_EMISSAO)
	oSection1:Cell("E1_VENCREA"	):SetValue((_cAlias)->E1_VENCREA)
	oSection1:Cell("E1_VALOR"	):SetValue((_cAlias)->E1_VALOR)
	         
	oSection1:PrintLine()
	
	(_cAlias)->(dbSkip())

EndDo

oSection1:Finish()

DbSelectArea(_cAlias)
DbCloseArea()

Return(.T.)