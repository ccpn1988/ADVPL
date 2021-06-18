#include "protheus.ch"
#include "topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GER058    ∫Autor  ≥Helimar Tavares     ∫ Data ≥  29/05/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Relatorio de Saldo Consignado por Cliente                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥GEN - Gerencial                                             ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GER024()             

Local oReport
Local cPerg := "GER024"

//Private MV_PAR08 := 2
Private _nCli    := 1

//Cria grupo de perguntas

f001(cPerg) 

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

If (Empty(MV_PAR04)) .and. (Empty(MV_PAR06))
	MsgInfo("… necess·rio informar o cliente ou grupo de vendas.")
	If !Pergunte(cPerg,.T.)
		Return
	Endif
Endif

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
cCpoPer := "B1_PROC"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')     
cF3Perg := "SA2_B" //Posicione("SX3",2,cCpoPer,'X3_F3')          
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Fornecedor.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR03--------------------------------------------------
cCpoPer := "B1_XSITOBR"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "Z5" //Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR04--------------------------------------------------
cCpoPer := "B6_CLIFOR"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA1"  //Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Cliente.       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR06--------------------------------------------------
cCpoPer := "A1_GRPVEN"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "ACY"  //Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
cCpoPer := "B1_COD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := 90 //TamSx3(cCpoPer)[1]
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR08--------------------------------------------------
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
Local oSection1
Local oSection2
Local lEndSection
Local lEndReport

//Declaracao do relatorio
 oReport := TReport():New("GER024","GER024 - SALDO CONSIGNADO POR CLIENTE",cPerg,{|oReport| PrintReport(oReport)},"GER024 - SALDO CONSIGNADO POR CLIENTE",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Cliente","SB6")  

//Celulas da secao
TRCell():New(oSection1,"CLILOJA"	,"","")
TRCell():New(oSection1,"CODCLI"		,"","Cliente"		,,8)
TRCell():New(oSection1,"LOJA"		,"","Loja"			,,5)
TRCell():New(oSection1,"NOME"		,"","Nome"			,,50)
TRCell():New(oSection1,"A1_EST"		,"","UF"			,,4)
TRCell():New(oSection1,"MUNICIPIO"  ,"","MunicÌpio"		,,20)
TRCell():New(oSection1,"TIPOCLIENTE","","Tipo Cliente"	,,20)
TRCell():New(oSection1,"CANALVENDA"	,"","Canal Venda"	,,20)
TRCell():New(oSection1,"VENDEDOR"	,"","Vendedor"		,,20)
TRCell():New(oSection1,"SALDO"		,"","Saldo"			,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection1,"VALOR"		,"","Valor"			,'@E 999,999,999.99',12,,,,,"RIGHT")
TRCell():New(oSection1,"SPACE1"		,"","",,10)
TRCell():New(oSection1,"QTDEU6M"	,"","⁄lt.6 Meses"	,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection1,"VALORU6M"	,"","⁄lt.6 Meses R$",'@E 999,999,999.99',12,,,,,"RIGHT")


//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produtos","")     

//Celulas da secao
TRCell():New(oSection2,"CODPROD"		,"",CRLF+"CÛdigo"				,,10)
TRCell():New(oSection2,"ISBN"			,"",CRLF+"ISBN"					,,18)
TRCell():New(oSection2,"DESCRICAO"		,"",CRLF+"DescriÁ„o"			,,30)
TRCell():New(oSection2,"SELO"			,"",CRLF+"Selo"					,,8)
TRCell():New(oSection2,"DATAPUBLICA"	,"","Data"+CRLF+"PublicaÁ„o"	,,15)
TRCell():New(oSection2,"TIPOPUBLICA"	,"","Tipo"+CRLF+"PublicaÁ„o"	,,20)
TRCell():New(oSection2,"SITUACAOVENDA"	,"","SituaÁ„o"+CRLF+"Venda"		,,22)
TRCell():New(oSection2,"CATEGORIA"		,"",CRLF+"Categoria"			,,17)
TRCell():New(oSection2,"AREA"			,"",CRLF+"¡rea"					,,15)
TRCell():New(oSection2,"PRECO"			,"",CRLF+"PreÁo"				,'@E 99,999.99'		,8,,,,,"RIGHT")
TRCell():New(oSection2,"PERCDES"	    ,"",CRLF+"% Desc"				,,8,,,,,"RIGHT")
TRCell():New(oSection2,"SALDO"			,"",CRLF+"Saldo"				,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection2,"VALOR"			,"",CRLF+"Valor"				,'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"ULTIMOACERTO"	,"","⁄ltimo"+CRLF+"Acerto"		,,15)
TRCell():New(oSection2,"QTDEU6M"		,"","⁄ltimos"+CRLF+"6 Meses"	,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection2,"VALORU6M"		,"","⁄ltimos"+CRLF+"6 Meses R$"	,'@E 999,999,999.99',15,,,,,"RIGHT")
                             
oBreak := TRBreak():New(oSection1,oSection1:Cell("CLILOJA"),"Total do Cliente",.f.)

If MV_PAR08 == 1
	lEndSection := .T.
	lEndReport  := .F.
Else
	If _nCli = 1
		lEndSection := .F.
		lEndReport  := .T.
	Else
		lEndSection := .T.
		lEndReport  := .T.
	EndIf
EndIf
	
//Totalizadores
TRFunction():New(oSection2:Cell("ISBN"    ),NIL,"COUNT",,,'@E 999,999',,lEndSection,lEndReport,.F.)
TRFunction():New(oSection2:Cell("SALDO"   ),NIL,"SUM",,,,,lEndSection,lEndReport,.F.)
TRFunction():New(oSection2:Cell("VALOR"   ),NIL,"SUM",,,,,lEndSection,lEndReport,.F.)
TRFunction():New(oSection2:Cell("QTDEU6M" ),NIL,"SUM",,,,,lEndSection,lEndReport,.F.)
TRFunction():New(oSection2:Cell("VALORU6M"),NIL,"SUM",,,,,lEndSection,lEndReport,.F.)

//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery1  := ""
Local _cQuery2  := ""
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cAlias3	:= GetNextAlias()
Local _cAlias4	:= GetNextAlias()
Local _cCliLoj  := ""
Local _cCliFor  := ""
Local _cLoja    := ""
Local _cProduto := MntStrPsq(MV_PAR07)
Local _nLin     := 0
Local xUltimoAcerto:= ""

_cParm1 := DTOS(MONTHSUB(DATE(),6))
_cParm2 := DTOS(DATE())

_cQuery1 := "SELECT SB6.B6_CLIFOR||SB6.B6_LOJA CLILOJA, SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_NOME, SA3.A3_NOME, SA1.A1_MUN, SA1.A1_EST, XTP.X5_DESCRI TIPOCLIENTE, XZ2.X5_DESCRI CANALVENDA,
_cQuery1 += "       SUM(SB6.B6_SALDO) B6_SALDO, SUM(SB6.B6_SALDO * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100))) VALOR,
_cQuery1 += "       NVL(SUM(F.QTDE),0) QTDEU6M, NVL(SUM(F.VALOR),0) VALORU6M
_cQuery1 += "  FROM (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
_cQuery1 += "          FROM " + RetSqlName("SB6")
_cQuery1 += "         WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
_cQuery1 += "           AND B6_TIPO    = 'E'
_cQuery1 += "           AND B6_PODER3  = 'R'
_cQuery1 += "           AND B6_TPCF    = 'C'
If !Empty(MV_PAR04)
	_cQuery1 += "           AND B6_CLIFOR  = '"+MV_PAR04+"'"
Endif 
If !Empty(MV_PAR05)
	_cQuery1 += "           AND B6_LOJA    = '"+MV_PAR05+"'"
Endif 
_cQuery1 += "           AND D_E_L_E_T_ = ' '
_cQuery1 += "         GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) SB6
_cQuery1 += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SB6.B6_CLIFOR AND SA1.A1_LOJA = SB6.B6_LOJA
_cQuery1 += "  LEFT JOIN " + RetSqlName("SA3") + " SA3 ON SA1.A1_VEND = SA3.A3_COD
_cQuery1 += "   AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'"
_cQuery1 += "   AND SA3.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XTP ON XTP.X5_CHAVE = SA1.A1_XTIPCLI 
_cQuery1 += "   AND XTP.X5_TABELA = 'TP'
_cQuery1 += "   AND XTP.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XTP.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ2 ON XZ2.X5_CHAVE = SA1.A1_XCANALV 
_cQuery1 += "   AND XZ2.X5_TABELA = 'Z2'
_cQuery1 += "   AND XZ2.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XZ2.D_E_L_E_T_ = ' '
_cQuery1 += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SB6.B6_PRODUTO
_cQuery1 += " INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB5.B5_COD = SB1.B1_COD
_cQuery1 += "  LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1.DA1_CODPRO = SB1.B1_COD
_cQuery1 += "   AND DA1.DA1_CODTAB = '"+GETMV("GEN_FAT064")+"'"
_cQuery1 += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
_cQuery1 += "   AND DA1.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SZ2") + " SZ2 ON SZ2.Z2_CLASSE = SB1.B1_GRUPO AND SZ2.Z2_TIPO = SA1.A1_XTPDES
_cQuery1 += "   AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
_cQuery1 += "   AND SZ2.D_E_L_E_T_ = ' '
_cQuery1 += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SB1.B1_PROC AND SA2.A2_LOJA = SB1.B1_LOJPROC
_cQuery1 += "  LEFT JOIN (SELECT CLIENTE, LOJA, COD, MAX(EMISSAO) EMISSAO, SUM(QTDE) QTDE, SUM(VALOR) VALOR
_cQuery1 += "               FROM (SELECT D2_CLIENTE CLIENTE, D2_LOJA LOJA, D2_COD COD, MAX(D2_EMISSAO) EMISSAO, 0 QTDE, 0 VALOR
_cQuery1 += "                       FROM GER_SD2
_cQuery1 += "                      WHERE D2_FILIAL  = '"+xFilial("SD2")+"'"
_cQuery1 += "                        AND D2_TES     = '524'
If !Empty(MV_PAR04)
	_cQuery1 += "                        AND D2_CLIENTE = '"+MV_PAR04+"'"
Endif 
If !Empty(MV_PAR05)
	_cQuery1 += "                        AND D2_LOJA    = '"+MV_PAR05+"'"
Endif 
_cQuery1 += "                      GROUP BY D2_CLIENTE, D2_LOJA, D2_COD
_cQuery1 += "                      UNION ALL
_cQuery1 += "                     SELECT D2_CLIENTE, D2_LOJA, D2_COD, ' ', NVL(D2_QUANT,0) QTDE, NVL(D2_VALBRUT,0) VALOR
_cQuery1 += "                       FROM GER_SD2
_cQuery1 += "                      WHERE D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
If !Empty(MV_PAR04)
	_cQuery1 += "                        AND D2_CLIENTE = '"+MV_PAR04+"'"
Endif 
If !Empty(MV_PAR05)
	_cQuery1 += "                        AND D2_LOJA    = '"+MV_PAR05+"'"
Endif 
_cQuery1 += "                        AND D2_FILIAL  = '" + xFilial("SD2") + "'"
_cQuery1 += "                      UNION ALL
_cQuery1 += "                     SELECT D1_FORNECE, D1_LOJA, D1_COD, ' ', NVL(D1_QUANT,0)*(-1), NVL((D1_TOTAL - D1_VALDESC),0)*(-1)
_cQuery1 += "                       FROM GER_SD1
_cQuery1 += "                      WHERE D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
If !Empty(MV_PAR04)
	_cQuery1 += "                        AND D1_FORNECE = '"+MV_PAR04+"'"
Endif 
If !Empty(MV_PAR05)
	_cQuery1 += "                        AND D1_LOJA    = '"+MV_PAR05+"'"
Endif 
_cQuery1 += "                        AND D1_FILIAL  = '" + xFilial("SD1") + "')"
_cQuery1 += "              GROUP BY CLIENTE, LOJA, COD) F
_cQuery1 += "    ON F.CLIENTE = SB6.B6_CLIFOR 
_cQuery1 += "   AND F.LOJA = SB6.B6_LOJA
_cQuery1 += "   AND F.COD = SB6.B6_PRODUTO
_cQuery1 += " WHERE SB6.B6_SALDO  <> 0
_cQuery1 += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
If !Empty(MV_PAR04)
	_cQuery1 += "   AND SA1.A1_COD = '"+MV_PAR04+"'
Endif 
If !Empty(MV_PAR05)
	_cQuery1 += "   AND SA1.A1_LOJA = '"+MV_PAR05+"'
Endif                                           
If !Empty(MV_PAR06)
	_cQuery1 += "   AND SA1.A1_GRPVEN = '"+MV_PAR06+"'
Endif 
_cQuery1 += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
If !Empty(MV_PAR03)
	_cQuery1 += "   AND SB1.B1_XSITOBR = '"+MV_PAR03+"'
Endif 
If !Empty(MV_PAR07)
	_cQuery1 += "   AND SB1.B1_ISBN IN ("+_cProduto+")"
Endif
_cQuery1 += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "   AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_cQuery1 += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery1 += "   AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
If !Empty(MV_PAR01)
	_cQuery1 += "   AND SA2.A2_COD = '"+MV_PAR01+"'
Endif 
If !Empty(MV_PAR02)
	_cQuery1 += "   AND SA2.A2_LOJA = '"+MV_PAR02+"'
Endif                                           
_cQuery1 += "   AND SA2.D_E_L_E_T_ = ' '
_cQuery1 += " GROUP BY SB6.B6_CLIFOR, SB6.B6_LOJA, SA1.A1_NOME, SA3.A3_NOME, SA1.A1_MUN, SA1.A1_EST, XTP.X5_DESCRI, XZ2.X5_DESCRI
_cQuery1 += " ORDER BY VALOR DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	_cCliLoja:= (_cAlias1)->CLILOJA
	_cClifor := (_cAlias1)->B6_CLIFOR
	_cLoja   := (_cAlias1)->B6_LOJA
	_nLin    := 0
	
	oReport:IncMeter()

	If ((_nCli > 1) .and. (_nLin < 30)) .or. ((_nCli > 1) .and. (MV_PAR08==2))
		oReport:EndPage()
		oReport:StartPage()
	EndIf
	
	oSection1:Init()  

	oSection1:Cell("CLILOJA"    ):SetValue((_cAlias1)->CLILOJA)
	oSection1:Cell("CODCLI"     ):SetValue((_cAlias1)->B6_CLIFOR)
	oSection1:Cell("LOJA"       ):SetValue((_cAlias1)->B6_LOJA)
	oSection1:Cell("NOME"       ):SetValue((_cAlias1)->A1_NOME)
	oSection1:Cell("A1_EST"     ):SetValue((_cAlias1)->A1_EST)
	oSection1:Cell("MUNICIPIO"  ):SetValue((_cAlias1)->A1_MUN)
	oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
	oSection1:Cell("CANALVENDA" ):SetValue((_cAlias1)->CANALVENDA)
	oSection1:Cell("VENDEDOR"   ):SetValue((_cAlias1)->A3_NOME)
	oSection1:Cell("SALDO"      ):SetValue((_cAlias1)->B6_SALDO)
	oSection1:Cell("VALOR"      ):SetValue((_cAlias1)->VALOR)
	oSection1:Cell("QTDEU6M"    ):SetValue((_cAlias1)->QTDEU6M)
	oSection1:Cell("VALORU6M"   ):SetValue((_cAlias1)->VALORU6M)
	
	oSection1:PrintLine()

	_cQuery2 := Consulta(1,_cCliFor,_cLoja,_cProduto)
		
	If Select(_cAlias2) > 0
		dbSelectArea(_cAlias2)
		dbCloseArea()
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias2, .F., .T.)

	Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
        If ((MV_PAR08 == 1) .and. (_nLin >= 30)) .or. ((_cAlias2)->(eof())) .or. (oReport:Cancel())
        	Exit
        EndIf
        
		_dDataPublica := STOD((_cAlias2)->B5_XDTPUBL)
	        
        If (_cAlias2)->EMISSAO = ' '
			_dUltimoAcerto:= (_cAlias2)->EMISSAO
        Else
			_dUltimoAcerto:= STOD((_cAlias2)->EMISSAO)
		EndIf
	
 		oReport:IncMeter()
	
		oSection2:Init()

		oSection2:Cell("CODPROD"	  ):SetValue((_cAlias2)->B6_PRODUTO)
		oSection2:Cell("ISBN"		  ):SetValue((_cAlias2)->B1_ISBN)
		oSection2:Cell("DESCRICAO"	  ):SetValue((_cAlias2)->B1_DESC)
		oSection2:Cell("SELO"		  ):SetValue((_cAlias2)->SELO)
		oSection2:Cell("DATAPUBLICA"  ):SetValue(_dDataPublica)
		oSection2:Cell("TIPOPUBLICA"  ):SetValue((_cAlias2)->TIPOPUBLICACAO)
		oSection2:Cell("SITUACAOVENDA"):SetValue((_cAlias2)->SITUACAOOBRA)
		oSection2:Cell("CATEGORIA"	  ):SetValue((_cAlias2)->CATEGORIA)
		oSection2:Cell("AREA"		  ):SetValue((_cAlias2)->AREA)
		oSection2:Cell("PRECO"		  ):SetValue((_cAlias2)->DA1_PRCVEN)
		oSection2:Cell("PERCDES"	  ):SetValue((_cAlias2)->Z2_PERCDES)
		oSection2:Cell("SALDO"		  ):SetValue((_cAlias2)->B6_SALDO)
		oSection2:Cell("VALOR"		  ):SetValue((_cAlias2)->VALOR)
		oSection2:Cell("ULTIMOACERTO" ):SetValue(_dUltimoAcerto)
		oSection2:Cell("QTDEU6M"	  ):SetValue((_cAlias2)->QTDEU6M)
		oSection2:Cell("VALORU6M"	  ):SetValue((_cAlias2)->VALORU6M)

		oSection2:PrintLine()

        _nLin++    

		(_cAlias2)->(dbSkip())		
	EndDo
	oSection2:Finish()

	DbSelectArea(_cAlias2)
	DbCloseArea()

	If MV_PAR08 == 1
		oReport:EndPage()
		oReport:StartPage()
		oSection1:Init()  
	
		_nLin := 0
	
		oSection1:Cell("CLILOJA"    ):SetValue((_cAlias1)->CLILOJA)
		oSection1:Cell("CODCLI"     ):SetValue((_cAlias1)->B6_CLIFOR)
		oSection1:Cell("LOJA"       ):SetValue((_cAlias1)->B6_LOJA)
		oSection1:Cell("NOME"       ):SetValue((_cAlias1)->A1_NOME)
		oSection1:Cell("A1_EST"     ):SetValue((_cAlias1)->A1_EST)
		oSection1:Cell("MUNICIPIO"  ):SetValue((_cAlias1)->A1_MUN)
		oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
		oSection1:Cell("CANALVENDA" ):SetValue((_cAlias1)->CANALVENDA)
		oSection1:Cell("VENDEDOR"   ):SetValue((_cAlias1)->A3_NOME)
		oSection1:Cell("SALDO"      ):SetValue((_cAlias1)->B6_SALDO)
		oSection1:Cell("VALOR"      ):SetValue((_cAlias1)->VALOR)
		oSection1:Cell("QTDEU6M"    ):SetValue((_cAlias1)->QTDEU6M)
		oSection1:Cell("VALORU6M"   ):SetValue((_cAlias1)->VALORU6M)
		
		oSection1:PrintLine()

		_cQuery2 := Consulta(2,_cCliFor,_cLoja,_cProduto)

		If Select(_cAlias3) > 0
			dbSelectArea(_cAlias3)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias3, .F., .T.)
		
		Do While !(_cAlias3)->(eof()) .And. !oReport:Cancel()
	        If (_nLin >= 30) .or. ((_cAlias3)->(eof())) .or. (oReport:Cancel())
	        	Exit
	        EndIf

			oReport:IncMeter()
		        
			_dDataPublica := STOD((_cAlias3)->B5_XDTPUBL)

	        If (_cAlias3)->EMISSAO = ' '
				_dUltimoAcerto:= (_cAlias3)->EMISSAO
	        Else
				_dUltimoAcerto:= STOD((_cAlias3)->EMISSAO)
			EndIf
	
	 		oReport:IncMeter()
		
			oSection2:Init()
	
			oSection2:Cell("CODPROD"      ):SetValue((_cAlias3)->B6_PRODUTO)
			oSection2:Cell("ISBN"         ):SetValue((_cAlias3)->B1_ISBN)
			oSection2:Cell("DESCRICAO"    ):SetValue((_cAlias3)->B1_DESC)
			oSection2:Cell("SELO"         ):SetValue((_cAlias3)->SELO)
			oSection2:Cell("DATAPUBLICA"  ):SetValue(_dDataPublica)
			oSection2:Cell("TIPOPUBLICA"  ):SetValue((_cAlias3)->TIPOPUBLICACAO)
			oSection2:Cell("SITUACAOVENDA"):SetValue((_cAlias3)->SITUACAOOBRA)
			oSection2:Cell("CATEGORIA"    ):SetValue((_cAlias3)->CATEGORIA)
			oSection2:Cell("AREA"         ):SetValue((_cAlias3)->AREA)
			oSection2:Cell("PRECO"        ):SetValue((_cAlias3)->DA1_PRCVEN)
			oSection2:Cell("PERCDES"      ):SetValue((_cAlias3)->Z2_PERCDES)
			oSection2:Cell("SALDO"        ):SetValue((_cAlias3)->B6_SALDO)
			oSection2:Cell("VALOR"        ):SetValue((_cAlias3)->VALOR)
			oSection2:Cell("ULTIMOACERTO" ):SetValue(_dUltimoAcerto)
			oSection2:Cell("QTDEU6M"      ):SetValue((_cAlias3)->QTDEU6M)
			oSection2:Cell("VALORU6M"     ):SetValue((_cAlias3)->VALORU6M)

			oSection2:PrintLine()
	
	        _nLin++    
	
			(_cAlias3)->(dbSkip())		
		EndDo             
		oSection2:Finish()

		DbSelectArea(_cAlias3)
		DbCloseArea()

		_cQuery2 := Consulta(3,_cClifor,_cLoja,_cProduto)

		If Select(_cAlias4) > 0
			dbSelectArea(_cAlias4)
			dbCloseArea()
		EndIf
		
		DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias4, .F., .T.)

		If (Empty(MV_PAR03)) .and. !(_cAlias4)->(eof())
			oReport:EndPage()
			oReport:StartPage()
			oSection1:Init()  
		
			_nLin := 0
		
			oSection1:Cell("CLILOJA"    ):SetValue((_cAlias1)->CLILOJA)
			oSection1:Cell("CODCLI"     ):SetValue((_cAlias1)->B6_CLIFOR)
			oSection1:Cell("LOJA"       ):SetValue((_cAlias1)->B6_LOJA)
			oSection1:Cell("NOME"       ):SetValue((_cAlias1)->A1_NOME)
			oSection1:Cell("A1_EST"     ):SetValue((_cAlias1)->A1_EST)
			oSection1:Cell("MUNICIPIO"  ):SetValue((_cAlias1)->A1_MUN)
			oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
			oSection1:Cell("CANALVENDA" ):SetValue((_cAlias1)->CANALVENDA)
			oSection1:Cell("VENDEDOR"   ):SetValue((_cAlias1)->A3_NOME)
			oSection1:Cell("SALDO"      ):SetValue((_cAlias1)->B6_SALDO)
			oSection1:Cell("VALOR"      ):SetValue((_cAlias1)->VALOR)
			oSection1:Cell("QTDEU6M"    ):SetValue((_cAlias1)->QTDEU6M)
			oSection1:Cell("VALORU6M"   ):SetValue((_cAlias1)->VALORU6M)
			
			oSection1:PrintLine()
/*	
			_cQuery2 := Consulta(3,_cClifor,_cLoja,_cProduto)
			
			If Select(_cAlias4) > 0
				dbSelectArea(_cAlias4)
				dbCloseArea()
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery2), _cAlias4, .F., .T.)
*/			
			Do While !oReport:Cancel()
		        If (_nLin >= 30) .or. ((_cAlias4)->(eof())) .or. (oReport:Cancel())
		        	Exit
		        EndIf
				
				oReport:IncMeter()
			        
				_dDataPublica := STOD((_cAlias4)->B5_XDTPUBL)
	
		        If (_cAlias4)->EMISSAO = ' '
					_dUltimoAcerto:= (_cAlias4)->EMISSAO
		        Else
					_dUltimoAcerto:= STOD((_cAlias4)->EMISSAO)
				EndIf
		
		 		oReport:IncMeter()
			
				oSection2:Init()
		
				oSection2:Cell("CODPROD"      ):SetValue((_cAlias4)->B6_PRODUTO)
				oSection2:Cell("ISBN"         ):SetValue((_cAlias4)->B1_ISBN)
				oSection2:Cell("DESCRICAO"    ):SetValue((_cAlias4)->B1_DESC)
				oSection2:Cell("SELO"         ):SetValue((_cAlias4)->SELO)
				oSection2:Cell("DATAPUBLICA"  ):SetValue(_dDataPublica)
				oSection2:Cell("TIPOPUBLICA"  ):SetValue((_cAlias4)->TIPOPUBLICACAO)
				oSection2:Cell("SITUACAOVENDA"):SetValue((_cAlias4)->SITUACAOOBRA)
				oSection2:Cell("CATEGORIA"    ):SetValue((_cAlias4)->CATEGORIA)
				oSection2:Cell("AREA"         ):SetValue((_cAlias4)->AREA)
				oSection2:Cell("PRECO"        ):SetValue((_cAlias4)->DA1_PRCVEN)
				oSection2:Cell("PERCDES"      ):SetValue((_cAlias4)->Z2_PERCDES)
				oSection2:Cell("SALDO"        ):SetValue((_cAlias4)->B6_SALDO)
				oSection2:Cell("VALOR"        ):SetValue((_cAlias4)->VALOR)
				oSection2:Cell("ULTIMOACERTO" ):SetValue(_dUltimoAcerto)
				oSection2:Cell("QTDEU6M"      ):SetValue((_cAlias4)->QTDEU6M)
				oSection2:Cell("VALORU6M"     ):SetValue((_cAlias4)->VALORU6M)
	
				oSection2:PrintLine()
		
		        _nLin++    
		
				(_cAlias4)->(dbSkip())
			EndDo             
	
			oSection2:Finish()
		
			DbSelectArea(_cAlias4)
			DbCloseArea()
		EndIf
	EndIf

	_nCli++

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)


/**********************************************************************************************************************/
Static Function MntStrPsq(_cParametros)
/**********************************************************************************************************************/

Local _cTipos := ""
Local _aTipos := {}
Local _nLen   := 0

_aTipos := Separa(_cParametros,";")
_nLen   := Len(_aTipos)

If _nLen > 500
	_nLen := 500 
End

For nX := 1 To _nLen
	If nX == 1
		_cTipos := "'" + ALLTRIM(_aTipos[nX]) + "'"
	Else
		_cTipos := _cTipos + ",'" + ALLTRIM(_aTipos[nX]) + "'"
	EndIf
Next

Return (_cTipos)

/**********************************************************************************************************************/
Static Function Consulta(_xOrdem,_xCliFor,_xLoja,_xProduto)
/**********************************************************************************************************************/

Local _xQuery := ""

_cParm1 := DTOS(MONTHSUB(DATE(),6))
_cParm2 := DTOS(DATE())
                                                                          
_xQuery := "SELECT SB6.B6_PRODUTO, SB1.B1_ISBN, SB1.B1_DESC, TRIM(XZ1.X5_DESCRI) SELO, SB5.B5_XDTPUBL, XZ4.X5_DESCRI TIPOPUBLICACAO, XZ5.X5_DESCRI SITUACAOOBRA,
_xQuery += "       DECODE(SBM.BM_XCATEG, 'D', 'DID - ', 'P', 'PROF - ', 'I', 'INT.GER - ') || DECODE(TO_NUMBER(TRIM(SB5.B5_XTIPINC)), '1', 'ON', '2', 'NE') CATEGORIA,
_xQuery += "       Z7_DESC AREA, DA1.DA1_PRCVEN, SZ2.Z2_PERCDES, SB6.B6_SALDO, SB6.B6_SALDO * DA1.DA1_PRCVEN * (1 - (SZ2.Z2_PERCDES / 100)) VALOR,
_xQuery += "       NVL(F.EMISSAO,' ') EMISSAO, NVL(F.QTDE,0) QTDEU6M, NVL(F.VALOR,0) VALORU6M
_xQuery += "  FROM (SELECT B6_CLIFOR, B6_LOJA, B6_PRODUTO, SUM(B6_SALDO) B6_SALDO
_xQuery += "          FROM " + RetSqlName("SB6")
_xQuery += "         WHERE B6_FILIAL  = '" + xFilial("SB6") + "'"
_xQuery += "           AND B6_TIPO    = 'E'
_xQuery += "           AND B6_PODER3  = 'R'
_xQuery += "           AND B6_TPCF    = 'C'
_xQuery += "           AND B6_CLIFOR  = '" + _xCliFor + "'"
_xQuery += "           AND B6_LOJA    = '" + _xLoja + "'"
_xQuery += "           AND D_E_L_E_T_ = ' '
_xQuery += "         GROUP BY B6_CLIFOR, B6_LOJA, B6_PRODUTO) SB6
_xQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SB6.B6_CLIFOR AND SA1.A1_LOJA = SB6.B6_LOJA
_xQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SB6.B6_PRODUTO
_xQuery += " INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB5.B5_COD = SB1.B1_COD
_xQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4 ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
_xQuery += "   AND XZ4.X5_TABELA = 'Z4'
_xQuery += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_xQuery += "   AND XZ4.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ5 ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
_xQuery += "   AND XZ5.X5_TABELA = 'Z5'
_xQuery += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
_xQuery += "   AND XZ5.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("SBM") + " SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO
_xQuery += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
_xQuery += "   AND SBM.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1 ON XZ1.X5_CHAVE = SB5.B5_XSELO
_xQuery += "   AND XZ1.X5_TABELA = 'Z1'
_xQuery += "   AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "'"
_xQuery += "   AND XZ1.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7 ON SZ7.Z7_AREA = SB5.B5_XAREA
_xQuery += "   AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "'"
_xQuery += "   AND SZ7.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1.DA1_CODPRO = SB1.B1_COD
_xQuery += "   AND DA1.DA1_CODTAB = '" + GETMV("GEN_FAT064") + "'"
_xQuery += "   AND DA1.DA1_FILIAL = '" + xFilial("DA1") + "'"
_xQuery += "   AND DA1.D_E_L_E_T_ = ' '
_xQuery += "  LEFT JOIN " + RetSqlName("SZ2") + " SZ2 ON SZ2.Z2_CLASSE = SB1.B1_GRUPO AND SZ2.Z2_TIPO = SA1.A1_XTPDES
_xQuery += "   AND SZ2.Z2_FILIAL  = '" + xFilial("SZ2") + "'"
_xQuery += "   AND SZ2.D_E_L_E_T_ = ' '
_xQuery += " INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SB1.B1_PROC AND SA2.A2_LOJA = SB1.B1_LOJPROC
_xQuery += "  LEFT JOIN (SELECT CLIENTE, LOJA, COD, MAX(EMISSAO) EMISSAO, SUM(QTDE) QTDE, SUM(VALOR) VALOR
_xQuery += "               FROM (SELECT D2_CLIENTE CLIENTE, D2_LOJA LOJA, D2_COD COD, MAX(D2_EMISSAO) EMISSAO, 0 QTDE, 0 VALOR
_xQuery += "                       FROM GER_SD2
_xQuery += "                      WHERE D2_FILIAL  = '"+xFilial("SD2")+"'"
_xQuery += "                        AND D2_TES     = '524'
_xQuery += "                        AND D2_CLIENTE = '" + _xCliFor + "'"
_xQuery += "                        AND D2_LOJA    = '" + _xLoja + "'"
_xQuery += "                      GROUP BY D2_CLIENTE, D2_LOJA, D2_COD
_xQuery += "                      UNION ALL
_xQuery += "                     SELECT D2_CLIENTE, D2_LOJA, D2_COD, ' ', NVL(D2_QUANT,0) QTDE, NVL(D2_VALBRUT,0) VALOR
_xQuery += "                       FROM GER_SD2
_xQuery += "                      WHERE D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_xQuery += "                        AND D2_FILIAL  = '" + xFilial("SD2") + "'"
_xQuery += "                        AND D2_CLIENTE = '" + _xCliFor + "'"
_xQuery += "                        AND D2_LOJA    = '" + _xLoja + "'"
_xQuery += "                      UNION ALL
_xQuery += "                     SELECT D1_FORNECE, D1_LOJA, D1_COD, ' ', NVL(D1_QUANT,0)*(-1), NVL((D1_TOTAL - D1_VALDESC),0)*(-1)
_xQuery += "                       FROM GER_SD1
_xQuery += "                      WHERE D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
_xQuery += "                        AND D1_FILIAL  = '" + xFilial("SD1") + "'"
_xQuery += "                        AND D1_FORNECE = '" + _xCliFor + "'"
_xQuery += "                        AND D1_LOJA    = '" + _xLoja + "')"
_xQuery += "              GROUP BY CLIENTE, LOJA, COD) F
_xQuery += "    ON F.CLIENTE = SB6.B6_CLIFOR 
_xQuery += "   AND F.LOJA = SB6.B6_LOJA
_xQuery += "   AND F.COD = SB6.B6_PRODUTO
_xQuery += " WHERE SB6.B6_SALDO  <> 0
_xQuery += "   AND SA1.A1_FILIAL  = '" + xFilial("SA1") + "'"
If !Empty(MV_PAR06)
	_xQuery += "   AND SA1.A1_GRPVEN = '"+MV_PAR06+"'
Endif 
_xQuery += "   AND SA1.D_E_L_E_T_ = ' '
_xQuery += "   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'"
If (!Empty(MV_PAR03)) .and. (_xOrdem <> 3)
	_xQuery += "   AND SB1.B1_XSITOBR = '"+MV_PAR03+"'
Endif 
If _xOrdem == 3
	_xQuery += "   AND SB1.B1_XSITOBR IN ('105','111')
Endif 
If !Empty(MV_PAR07)
	_xQuery += "   AND SB1.B1_ISBN IN ("+_xProduto+")"
Endif
_xQuery += "   AND SB1.D_E_L_E_T_ = ' '
_xQuery += "   AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'"
_xQuery += "   AND SB5.D_E_L_E_T_ = ' '
_xQuery += "   AND SA2.A2_FILIAL  = '" + xFilial("SA2") + "'"
If !Empty(MV_PAR01)
	_xQuery += "   AND SA2.A2_COD = '"+MV_PAR01+"'
Endif 
If !Empty(MV_PAR02)
	_xQuery += "   AND SA2.A2_LOJA = '"+MV_PAR02+"'
Endif                                           
_xQuery += "   AND SA2.D_E_L_E_T_ = ' '
If (_xOrdem == 1) .or. (_xOrdem == 3)
	_xQuery += " ORDER BY VALOR DESC
ElseIf _xOrdem == 2
	_xQuery += " ORDER BY EMISSAO, VALOR DESC
EndIf

Return (_xQuery)