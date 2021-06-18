#include "protheus.ch"
#include "topconn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GER035    ∫Autor  ≥Helimar Tavares     ∫ Data ≥  13/06/19   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Extrato de Consignacao                                      ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥GEN - Gerencial                                             ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GER035()             

Local oReport
Local cPerg := "GER035"

//Cria grupo de perguntas

//f001(cPerg) 

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

If Empty(MV_PAR01)
	MsgInfo("… necess·rio informar o cliente.")
	Return    
Endif

If Empty(MV_PAR02)
	MsgInfo("… necess·rio informar a loja.")
	Return    
Endif

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: f001
Descricao: Cria grupo de perguntas
*/   

Static Function f001(cPerg)
/*
Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     


//---------------------------------------MV_PAR01--------------------------------------------------  
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
AADD(aHelpPor,"CÛdigo do Cliente.       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

//Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Cliente.       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

//PutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, "Loja", "Loja","Loja", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Produtos sem saldo consignado ")
AADD(aHelpPor,"no cliente (S/N).             ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

//PutSX1(cPerg, cItPerg, "Sem Saldo?", "Sem Saldo?", "Sem Saldo?", cMVCH, "C", 1, 0, 1, "C", "", "", "", "", cMVPAR, "S", "S", "S", "", "N", "N", "N", "", "", "", "", "","", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, "Sem Saldo?", "Sem Saldo?", "Sem Saldo?", cMVCH, "C", 1, 0, 1, "C", "", "", "", "", cMVPAR, "Sim", "Sim", "Sim", "", "N„o", "N„o", "N„o", "", "", "", "", "","", "", "", "", "", "", "", "", aHelpPor, aHelpEng, aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
cCpoPer := "B1_COD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SB1_A"  //Posicione("SX3",2,cCpoPer,'X3_F3')
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

//Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,,cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

//PutSx1(cPerg, cItPerg, "Dt Emiss„o de:", "Dt Emiss„o de:" ,"Dt Emiss„o de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, "Dt Emiss„o de:", "Dt Emiss„o de:" ,"Dt Emiss„o de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"ObrigatÛrio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

//PutSx1(cPerg, cItPerg, "Dt Emiss„o atÈ:", "Dt Emiss„o atÈ:","Dt Emiss„o atÈ:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
U_xGPutSx1(cPerg, cItPerg, "Dt Emiss„o atÈ:", "Dt Emiss„o atÈ:","Dt Emiss„o atÈ:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
*/
Return()
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local lEndSection
Local lEndReport

//Declaracao do relatorio
 oReport := TReport():New("GER035","GER035 - EXTRATO DE CONSIGNA«√O",cPerg,{|oReport| PrintReport(oReport)},"GER035 - EXTRATO DE CONSIGNA«√O",.T.)

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
TRCell():New(oSection1,"A1_COD"		,"","Cliente"		,,8)
TRCell():New(oSection1,"A1_LOJA"	,"","Loja"			,,5)
TRCell():New(oSection1,"A1_CGC"		,"","CNPJ"			,,20)
TRCell():New(oSection1,"A1_NOME"	,"","Nome"			,,70)
TRCell():New(oSection1,"A1_EST"		,"","UF"			,,10)
TRCell():New(oSection1,"CC2_MUN"	,"","MunicÌpio"		,,20)
TRCell():New(oSection1,"TIPOCLIENTE","","Tipo Cliente"	,,20)
TRCell():New(oSection1,"CANALVENDA"	,"","Canal Venda"	,,20)
TRCell():New(oSection1,"VENDEDOR"	,"","Vendedor"		,,20)


//Secao do relatorio
oSection2 := TRSection():New(oSection1,"Produto","")     

//Celulas da secao
TRCell():New(oSection2,"B1_COD"			,"","CÛdigo"			,,10)
TRCell():New(oSection2,"ISBN"			,"","ISBN"				,,18)
TRCell():New(oSection2,"PRODUTO"		,"","DescriÁ„o"			,,70)
TRCell():New(oSection2,"SELO"			,"","Selo"				,,10)
TRCell():New(oSection2,"DATAPUBLICA"	,"","Data PublicaÁ„o"	,,25)
TRCell():New(oSection2,"TIPOPUBLICA"	,"","Tipo PublicaÁ„o"	,,25)
TRCell():New(oSection2,"SITUACAOVENDA"	,"","SituaÁ„o Venda"	,,25)
TRCell():New(oSection2,"CATEGORIA"		,"","Categoria"			,,20)
TRCell():New(oSection2,"AREA"			,"","¡rea"				,,15)
TRCell():New(oSection2,"B6_SALDO"		,"","Saldo"				,'@E 9,999,999'	,10,,,,,"RIGHT")
                             
//Secao do relatorio
oSection3 := TRSection():New(oSection2,"Movimento","")     

//Celulas da secao
TRCell():New(oSection3,"DT_EMISSAO"	,"","Data Emiss„o"		,,20)
TRCell():New(oSection3,"DT_CLIENTE"	,"","Data NF Cliente"	,,20)
TRCell():New(oSection3,"NATOP"		,"","Natureza OperaÁ„o"	,,30)
TRCell():New(oSection3,"DOCUMENTO"	,"","Documento"			,,20)
TRCell():New(oSection3,"SERIE"		,"","SÈrie"				,,10)
TRCell():New(oSection3,"QTDE"		,"","Qtde"				,'@E 9,999,999'		,10,,,,,"RIGHT")
TRCell():New(oSection3,"PRECO"		,"","Prc.Unit"			,'@E 9,999,999.99'	,15,,,,,"RIGHT")
TRCell():New(oSection3,"PERCDES"	,"","% Desc."			,'@E 999.99'		,10,,,,,"RIGHT")
TRCell():New(oSection3,"VALOR"		,"","Valor"				,'@E 9,999,999.99'	,15,,,,,"RIGHT")
TRCell():New(oSection3,"SALDO"		,"","Saldo"				,'@E 9,999,999'		,10,,,,,"RIGHT")
                             
//oBreak := TRBreak():New(oSection2,oSection2:Cell("B1_COD"),"Total do Produto",.f.)

lEndSection := .T.
lEndReport  := .T.
	
//Totalizadores

//Faz a impressao do totalizador em linha
oSection3:SetTotalInLine(.f.)
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local oSection3 := oReport:Section(1):Section(1):Section(1)  
Local _cQuery1  := ""
Local _cAlias1	:= GetNextAlias()
Local _cProduto := MntStrPsq(MV_PAR04)
Local _nSaldo   := 0
Local _cTES     := GetMV("GEN_FAT250")

_dDtSld := DAYSUB(MV_PAR05,1)
_cParm5 := DTOS(MV_PAR05)
_cParm6 := DTOS(MV_PAR06)

_cQuery1 := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, TRIM(SA1.A1_NOME) A1_NOME, TRIM(SA1.A1_EST) A1_EST, TRIM(CC2.CC2_MUN) CC2_MUN, TRIM(XTP.X5_DESCRI) TIPOCLIENTE, TRIM(XZ2.X5_DESCRI) CANALVENDA, TRIM(SA3.A3_NOME) VENDEDOR,
_cQuery1 += "       TRIM(SB1.B1_COD) B1_COD, TRIM(SB1.B1_ISBN) ISBN, TRIM(SB1.B1_DESC) PRODUTO, TRIM(XZ1.X5_DESCRI) SELO, STOC(SB5.B5_XDTPUBL) DATAPUBLICA, TRIM(XZ4.X5_DESCRI) TIPOPUBLICA, TRIM(XZ5.X5_DESCRI) SITUACAOVENDA,
_cQuery1 += "       DECODE(SBM.BM_XCATEG, 'D', 'DID - ', 'P', 'PROF - ', 'I', 'INT.GER - ') || DECODE(TO_NUMBER(TRIM(SB5.B5_XTIPINC)), '1', 'ON', '2', 'NE') CATEGORIA, TRIM(SZ7.Z7_DESC) AREA,
_cQuery1 += "       STOC(NF.DT_EMISSAO)DT_EMISSAO, STOC(NF.DT_CLIENTE) DT_CLIENTE, NF.TES, NF.PODER3, NF.NATOP, NF.DOCUMENTO, NF.SERIE, NF.QTDE, NF.PRECO, NF.PERCDES, NF.VALOR, SB6.B6_SALDO
_cQuery1 += "  FROM (SELECT SB6.B6_FILIAL, SB6.B6_CLIFOR, SB6.B6_LOJA, SB6.B6_PRODUTO, SUM(SB6.B6_SALDO) B6_SALDO
_cQuery1 += "          FROM " + RetSqlName("SB6") + " SB6
_cQuery1 += "         INNER JOIN " + RetSqlName("SB1") + " SB1 
_cQuery1 += "            ON SB6.B6_PRODUTO = SB1.B1_COD
_cQuery1 += "         WHERE SB6.B6_FILIAL = '" + xFilial("SB6") + "'"
_cQuery1 += "           AND SB6.B6_TIPO = 'E'
_cQuery1 += "           AND SB6.B6_PODER3 = 'R'
_cQuery1 += "           AND SB6.B6_TPCF = 'C'
_cQuery1 += "           AND SB6.B6_CLIFOR = '"+MV_PAR01+"'"
_cQuery1 += "           AND SB6.B6_LOJA = '"+MV_PAR02+"'"
If !Empty(MV_PAR04)
	_cQuery1 += "           AND SB1.B1_ISBN IN ("+_cProduto+")"
Endif
If MV_PAR03 == 2
	_cQuery1 += "           AND SB6.B6_SALDO <> 0
Endif
_cQuery1 += "           AND SB6.D_E_L_E_T_ = ' '
_cQuery1 += "           AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "           AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "         GROUP BY B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO) SB6
_cQuery1 += "  LEFT JOIN (SELECT SD2.D2_FILIAL FILIAL, SD2.D2_COD PRODUTO, SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SD2.D2_EMISSAO DT_EMISSAO, SD2.D2_DTDIGIT DT_CLIENTE, SD2.D2_TES TES, SF4.F4_TEXTO NATOP, SF4.F4_PODER3 PODER3, SD2.D2_DOC DOCUMENTO, SD2.D2_SERIE SERIE, SD2.D2_QUANT QTDE, SD2.D2_PRUNIT PRECO, SD2.D2_DESC PERCDES, SD2.D2_VALBRUT VALOR, SD2.D2_NUMSEQ NUMSEQ
_cQuery1 += "               FROM " + RetSqlName("SD2") + " SD2
_cQuery1 += "              INNER JOIN " + RetSqlName("SF4") + " SF4 
_cQuery1 += "                 ON SD2.D2_TES = SF4.F4_CODIGO 
_cQuery1 += "              INNER JOIN " + RetSqlName("SB1") + " SB1 
_cQuery1 += "                 ON SD2.D2_COD = SB1.B1_COD
_cQuery1 += "              WHERE SD2.D2_TES IN ("+_cTES+")"
_cQuery1 += "                AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery1 += "                AND SD2.D2_CLIENTE = '"+MV_PAR01+"'"
_cQuery1 += "                AND SD2.D2_LOJA = '"+MV_PAR02+"'"
If !Empty(MV_PAR04)
	_cQuery1 += "                AND SB1.B1_ISBN IN ("+_cProduto+")"
Endif
_cQuery1 += "                AND SD2.D2_EMISSAO BETWEEN '" + _cParm5 + "' AND '" + _cParm6 + "'"
_cQuery1 += "                AND SD2.D_E_L_E_T_ = ' '
_cQuery1 += "                AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery1 += "                AND SF4.D_E_L_E_T_ = ' '
_cQuery1 += "                AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += "              UNION ALL
_cQuery1 += "             SELECT SD1.D1_FILIAL, SD1.D1_COD, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SD1.D1_EMISSAO, SD1.D1_TES, SF4.F4_TEXTO, SF4.F4_PODER3, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_QUANT, SD1.D1_VUNIT, SD1.D1_DESC, (SD1.D1_TOTAL-SD1.D1_VALDESC), SD1.D1_NUMSEQ
_cQuery1 += "               FROM " + RetSqlName("SD1") + " SD1
_cQuery1 += "              INNER JOIN " + RetSqlName("SF4") + " SF4 
_cQuery1 += "                 ON SD1.D1_TES = SF4.F4_CODIGO
_cQuery1 += "              INNER JOIN " + RetSqlName("SB1") + " SB1 
_cQuery1 += "                 ON SD1.D1_COD = SB1.B1_COD
_cQuery1 += "              WHERE SD1.D1_TES IN ("+_cTES+")"
_cQuery1 += "                AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
_cQuery1 += "                AND SD1.D1_FORNECE = '"+MV_PAR01+"'"
_cQuery1 += "                AND SD1.D1_LOJA = '"+MV_PAR02+"'"
If !Empty(MV_PAR04)
	_cQuery1 += "                AND SB1.B1_ISBN IN ("+_cProduto+")"
Endif
_cQuery1 += "                AND SD1.D1_EMISSAO between '" + _cParm5 + "' AND '" + _cParm6 + "'"
_cQuery1 += "                AND SD1.D_E_L_E_T_ = ' '
_cQuery1 += "                AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery1 += "                AND SF4.D_E_L_E_T_ = ' '
_cQuery1 += "                AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "                AND SB1.D_E_L_E_T_ = ' ') NF
_cQuery1 += "    ON SB6.B6_FILIAL = NF.FILIAL
_cQuery1 += "   AND SB6.B6_CLIFOR = NF.CLIENTE
_cQuery1 += "   AND SB6.B6_LOJA = NF.LOJA
_cQuery1 += "   AND SB6.B6_PRODUTO = NF.PRODUTO
_cQuery1 += " INNER JOIN " + RetSqlName("SA1") + " SA1
_cQuery1 += "    ON SB6.B6_CLIFOR = SA1.A1_COD
_cQuery1 += "   AND SB6.B6_LOJA = SA1.A1_LOJA
_cQuery1 += "   AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
_cQuery1 += "   AND SA1.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("CC2") + " CC2
_cQuery1 += "    ON CC2.CC2_CODMUN = SA1.A1_COD_MUN
_cQuery1 += "   AND CC2.CC2_EST = SA1.A1_EST
_cQuery1 += "   AND CC2.CC2_FILIAL = '" + xFilial("CC2") + "'"
_cQuery1 += "   AND CC2.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XTP
_cQuery1 += "    ON XTP.X5_CHAVE = SA1.A1_XTIPCLI
_cQuery1 += "   AND XTP.X5_TABELA = 'TP'
_cQuery1 += "   AND XTP.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XTP.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ2
_cQuery1 += "    ON XZ2.X5_CHAVE = SA1.A1_XCANALV
_cQuery1 += "   AND XZ2.X5_TABELA = 'Z2'
_cQuery1 += "   AND XZ2.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XZ2.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SA3") + " SA3
_cQuery1 += "    ON SA3.A3_COD = SA1.A1_VEND
_cQuery1 += "   AND SA3.A3_FILIAL  = '" + xFilial("SA3") + "'"
_cQuery1 += "   AND SA3.D_E_L_E_T_ = ' '
_cQuery1 += " INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery1 += "    ON SB1.B1_COD = SB6.B6_PRODUTO
_cQuery1 += "   AND SB1.B1_FILIAL = '" + xFilial("SB1") + "'"
_cQuery1 += "   AND SB1.D_E_L_E_T_ = ' '
_cQuery1 += " INNER JOIN " + RetSqlName("SB5") + " SB5
_cQuery1 += "    ON SB5.B5_COD = SB1.B1_COD
_cQuery1 += "   AND SB5.B5_FILIAL = '" + xFilial("SB5") + "'"
_cQuery1 += "   AND SB5.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SBM") + " SBM
_cQuery1 += "    ON SBM.BM_GRUPO = SB1.B1_GRUPO
_cQuery1 += "   AND SBM.BM_FILIAL = '" + xFilial("SBM") + "'"
_cQuery1 += "   AND SBM.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ1
_cQuery1 += "    ON XZ1.X5_CHAVE = SB5.B5_XSELO
_cQuery1 += "   AND XZ1.X5_TABELA = 'Z1'
_cQuery1 += "   AND XZ1.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XZ1.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5") + " XZ4
_cQuery1 += "    ON XZ4.X5_CHAVE = SB1.B1_XIDTPPU
_cQuery1 += "   AND XZ4.X5_TABELA = 'Z4'
_cQuery1 += "   AND XZ4.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XZ4.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SX5'") + " XZ5
_cQuery1 += "    ON XZ5.X5_CHAVE = SB1.B1_XSITOBR
_cQuery1 += "   AND XZ5.X5_TABELA = 'Z5'
_cQuery1 += "   AND XZ5.X5_FILIAL = '" + xFilial("SX5") + "'"
_cQuery1 += "   AND XZ5.D_E_L_E_T_ = ' '
_cQuery1 += "  LEFT JOIN " + RetSqlName("SZ7") + " SZ7
_cQuery1 += "    ON SB5.B5_XAREA = SZ7.Z7_AREA
_cQuery1 += "   AND SZ7.Z7_FILIAL = '" + xFilial("SZ7") + "'"
_cQuery1 += "   AND SZ7.D_E_L_E_T_= ' '
_cQuery1 += " WHERE NF.DT_EMISSAO IS NOT NULL
_cQuery1 += " ORDER BY NF.PRODUTO, NF.DT_EMISSAO, NF.NUMSEQ

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery1), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection1:Init()  

	oSection1:Cell("A1_COD"     ):SetValue((_cAlias1)->A1_COD)
	oSection1:Cell("A1_LOJA"	):SetValue((_cAlias1)->A1_LOJA)
	oSection1:Cell("A1_CGC"		):SetValue((_cAlias1)->A1_CGC)
	oSection1:Cell("A1_NOME"	):SetValue((_cAlias1)->A1_NOME)
	oSection1:Cell("A1_EST"		):SetValue((_cAlias1)->A1_EST)
	oSection1:Cell("CC2_MUN"	):SetValue((_cAlias1)->CC2_MUN)
	oSection1:Cell("TIPOCLIENTE"):SetValue((_cAlias1)->TIPOCLIENTE)
	oSection1:Cell("CANALVENDA" ):SetValue((_cAlias1)->CANALVENDA)
	oSection1:Cell("VENDEDOR"   ):SetValue((_cAlias1)->VENDEDOR)
	
	oSection1:PrintLine()

	Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
		_cISBN	:= (_cAlias1)->ISBN
        _nSaldo := U_GeRetPD3((_cAlias1)->A1_COD,(_cAlias1)->A1_LOJA,(_cAlias1)->B1_COD,_dDTSld)
 		
		oReport:IncMeter()
	
		oSection2:Init()

		oSection2:Cell("B1_COD"			):SetValue((_cAlias1)->B1_COD)
		oSection2:Cell("ISBN"			):SetValue((_cAlias1)->ISBN)
		oSection2:Cell("PRODUTO"		):SetValue((_cAlias1)->PRODUTO)
		oSection2:Cell("SELO"			):SetValue((_cAlias1)->SELO)
		oSection2:Cell("DATAPUBLICA"	):SetValue((_cAlias1)->DATAPUBLICA)
		oSection2:Cell("TIPOPUBLICA"	):SetValue((_cAlias1)->TIPOPUBLICA)
		oSection2:Cell("SITUACAOVENDA"	):SetValue((_cAlias1)->SITUACAOVENDA)
		oSection2:Cell("CATEGORIA"		):SetValue((_cAlias1)->CATEGORIA)
		oSection2:Cell("AREA"			):SetValue((_cAlias1)->AREA)
		oSection2:Cell("B6_SALDO"		):SetValue((_cAlias1)->B6_SALDO)

		oSection2:PrintLine()

		oSection3:Init()

		oSection3:Cell("DT_EMISSAO"	):SetValue(_dDtSld)
		oSection3:Cell("DT_CLIENTE"	):SetValue()
		oSection3:Cell("NATOP"		):SetValue()
		oSection3:Cell("DOCUMENTO"	):SetValue()
		oSection3:Cell("SERIE"		):SetValue()
		oSection3:Cell("QTDE"		):SetValue()
		oSection3:Cell("PRECO"		):SetValue()
		oSection3:Cell("PERCDES"	):SetValue()
		oSection3:Cell("VALOR"		):SetValue()
		oSection3:Cell("SALDO"		):SetValue(_nSaldo)

		oSection3:PrintLine()

		Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel() .And. (_cAlias1)->ISBN = _cISBN
//			oReport:IncMeter()
		
//			oSection3:Init()
			
			If (_cAlias1)->PODER3 = 'D'
				_nSaldo := _nSaldo - (_cAlias1)->QTDE
			ElseIf (_cAlias1)->PODER3 = 'R'
				_nSaldo := _nSaldo + (_cAlias1)->QTDE
            EndIf
            
			oSection3:Cell("DT_EMISSAO"	):SetValue((_cAlias1)->DT_EMISSAO)
			oSection3:Cell("DT_CLIENTE"	):SetValue((_cAlias1)->DT_CLIENTE)
			oSection3:Cell("NATOP"		):SetValue((_cAlias1)->NATOP)
			oSection3:Cell("DOCUMENTO"	):SetValue((_cAlias1)->DOCUMENTO)
			oSection3:Cell("SERIE"		):SetValue((_cAlias1)->SERIE)
			oSection3:Cell("QTDE"		):SetValue((_cAlias1)->QTDE)
			oSection3:Cell("PRECO"		):SetValue((_cAlias1)->PRECO)
			oSection3:Cell("PERCDES"	):SetValue((_cAlias1)->PERCDES)
			oSection3:Cell("VALOR"		):SetValue((_cAlias1)->VALOR)
			oSection3:Cell("SALDO"		):SetValue(_nSaldo)

			oSection3:PrintLine()

			(_cAlias1)->(dbSkip())
		EndDo
		oReport:ThinLine()
		oReport:SkipLine()
		oSection3:Finish()
	EndDo
	oSection2:Finish()
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
