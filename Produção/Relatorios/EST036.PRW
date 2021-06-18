#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
Programa: EST036

Descrição: Relatório Kardex GEN

Data: 19/11/2015
/*/

User Function EST036()             

Local oReport
Local cPerg := "EST036"

Private _cAlias1	:= ""

//Cria grupo de perguntas

AjusteSX1(cPerg) 

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

If Empty(MV_PAR04) .OR. Empty(MV_PAR05)
	MsgInfo("Caso não seja informada a filial ou o armazém o saldo inicial não será impresso!")
	
ElseIf MV_PAR04 <> xFilial("SD2")
	Alert("Para emitir o relatório na filial " + MV_PAR04 + " o sistema deve estar logado nesta filial.")
    Return
EndIF

_cAlias1	:= GetNextAlias()

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: AjusteSX1
Descricao: Cria grupo de perguntas
*/   

Static Function AjusteSX1(cPerg)

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     

//-----------------------------------------------------------------------------------------
cCpoPer := "D2_EMISSAO"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "Data Inicial:" //Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-----------------------------------------------------------------------------------------
cCpoPer := "D2_EMISSAO"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "Data Final:" //Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-----------------------------------------------------------------------------------------
cCpoPer := "D3_COD"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-----------------------------------------------------------------------------------------
cCpoPer := "D2_FILIAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SM0EMP" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opcional. ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//-----------------------------------------------------------------------------------------
cCpoPer := "D2_LOCAL"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opicional.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)   

//------------------------------------------------------------------------------------------------------------Vivaz 32555

cCpoPer := "D2_CLIENTE"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "De Cliente:"
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opicional.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)   

//--------------------------------------------------------------------------------------------------------------------------- 


cCpoPer := "D2_LOJA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "De Loja:"
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opicional.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 

//----------------------------------------------------------------------------------------------------------------------------------


cCpoPer := "D2_CLIENTE"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "Até Cliente:"
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opicional.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)   

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


cCpoPer := "D2_LOJA"
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')
cTitPer := "Até Loja:"
cF3Perg := "" //Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]
cTpoPer := "G"	//G-get;C-combo
cOpc1	:= ""
cOpc2	:= ""

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Parâmetro opicional.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa) 



Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2 

Local aOrdem	:= {"Sequencia","Sequencia+Filial","Emissao+Filial+TES","Filial+Emissao+TES"}

//Declaracao do relatorio
oReport := TReport():New("EST036","EST036 - Kardex GEN",cPerg,{|oReport| PrintReport(oReport)},"EST012 - Kardex GEN")
oReport:PrintHeader(.F.,.F.)
//Ajuste nas definicoes
oReport:nLineHeight := 55
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7		&& 10
oReport:lHeaderVisible := .F. 
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Estoque",{_cAlias1,"NAOUSADO"},aOrdem)

//Celulas da secao
TRCell():New(oSection1,"Tabela"			,"  "	,"TABELA"	,,20)
TRCell():New(oSection1,"D2_NUMSEQ"		,"SD2"	,"SEQUENCIA"	)
TRCell():New(oSection1,"D2_EMISSAO"		,"SD2"	,"EMISSAO"	) 
TRCell():New(oSection1,"D1_DTDIGIT"		,"SD1"	,"CLASSIFICACAO"	) 
TRCell():New(oSection1,"D2_FILIAL"		,"SD2"	,"FILIAL"	)
TRCell():New(oSection1,"D2_DOC"			,"SD2"	,"DOCUMENTO"	)
TRCell():New(oSection1,"D2_SERIE"		,"SD2"	,"SERIE"	)
TRCell():New(oSection1,"D2_PEDIDO"		,"SD2"	,"PEDIDO"	)
TRCell():New(oSection1,"D2_COD"			,"SD2"	,"PRODUTO"	)
TRCell():New(oSection1,"B1_DESC"		,"SB1"	,"DESCRICAO"	)
TRCell():New(oSection1,"D2_QUANT"		,"SD2"	,"QUANTIDADE"	)
TRCell():New(oSection1,"D2_PRCVEN"		,"SD2"	,"VALOR_UNITARIO"	)
TRCell():New(oSection1,"D2_TOTAL"		,"SD2"	,"VALOR_TOTAL"	)
TRCell():New(oSection1,"D2_CUSTO1"		,"SD2"	,"CUSTO"	)
TRCell():New(oSection1,"D2_LOCAL"		,"SD2"	,"ARMAZEM"	)
TRCell():New(oSection1,"D2_TES"			,"SD2"	,"TES_TIPO_MOVIMENTO"	)
TRCell():New(oSection1,"D2_CF"			,"SD2"	,"CFOP"	)
TRCell():New(oSection1,"F4_TEXTO"		,"SF4"	,"DESCRICAO_MOVIMENTO"	)
TRCell():New(oSection1,"F4_ESTOQUE"		,"SF4"	,"ATUALIZA_ESTOQUE"	)
TRCell():New(oSection1,"F4_PODER3"		,"SF4"	,"PODER_TERCEIRO"	)
TRCell():New(oSection1,"F5_VAL"			,"SF5"	,"VALORIZADO"	)
TRCell():New(oSection1,"D2_TIPO"		,"SD2"	,"TIPO_NOTA"	)
TRCell():New(oSection1,"D2_CLIENTE"		,"SD2"	,"CLIENTE_FORNECEDOR"	)
TRCell():New(oSection1,"D2_LOJA"		,"SD2"	,"LOJA"	)
TRCell():New(oSection1,"A1_NOME"		,"SA1"	,"NOME"	)

//Totalizadores
oBreak := TRBreak():New(oSection1, {|| AllTrim((_cAlias1)->PRODUTO) } , {|| "Saldo final "+AllTrim((_cAlias1)->PRODUTO)+" --> " })

TRFunction():New(oSection1:Cell("D2_QUANT")	    ,"QTD"	,"SUM",oBreak)

//Faz a impressao do totalizador em linha
oSection1:SetHeaderPage(.F.)
oSection1:SetLeftMargin(2)
oSection1:lPrintHeader := .F.

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cQuery   := ""

If oreport:OREPORT:NDEVICE <> 4
	MsgInfo("Atenção: este relatório foi formatado para Excel. Os demais formatos podem não apresentar o layout correto.")
Endif

_cQuery := ""
_cQuery += " SELECT 'DOC. SAÍDA' TABELA,
_cQuery += "   D2_NUMSEQ SEQUENCIA,
_cQuery += "   D2_EMISSAO EMISSAO,
_cQuery += "   D2_FILIAL FILIAL,
_cQuery += "   D2_DOC DOCUMENTO,
_cQuery += "   D2_SERIE SERIE,
_cQuery += "   D2_PEDIDO PEDIDO,
_cQuery += "   D2_COD PRODUTO,
_cQuery += "   B1_DESC DESCRICAO,
_cQuery += "   D2_QUANT*-1 QUANTIDADE,
_cQuery += "   D2_PRCVEN VALOR_UNITARIO,
_cQuery += "   D2_TOTAL VALOR_TOTAL,
_cQuery += "   D2_CUSTO1 CUSTO,
_cQuery += "   D2_LOCAL ARMAZEM,
_cQuery += "   D2_TES TES_TIPO_MOVIMENTO,
_cQuery += "   D2_CF CFOP,
_cQuery += "   F4_TEXTO DESCRICAO_MOVIMENTO,
_cQuery += "   F4_ESTOQUE ATUALIZA_ESTOQUE,
_cQuery += "   F4_PODER3 PODER_TERCEIRO,
_cQuery += "   ' ' VALORIZADO,
_cQuery += "   D2_TIPO TIPO_NOTA,
_cQuery += "   D2_CLIENTE CLIENTE_FORNECEDOR,
_cQuery += "   D2_LOJA LOJA,
_cQuery += "   CASE
_cQuery += "     WHEN D2_TIPO IN ('B','D')
_cQuery += "     THEN
_cQuery += "       (SELECT A2_NOME
_cQuery += "       FROM SA2000 SA2
_cQuery += "       WHERE SA2.D_E_L_E_T_ = ' '
_cQuery += "       AND SA2.A2_COD       = SD2.D2_CLIENTE
_cQuery += "       AND SA2.A2_LOJA      = SD2.D2_LOJA
_cQuery += "       AND ROWNUM           = 1
_cQuery += "       )
_cQuery += "     ELSE
_cQuery += "       (SELECT A1_NOME
_cQuery += "       FROM SA1000 SA1
_cQuery += "       WHERE SA1.D_E_L_E_T_ = ' '
_cQuery += "       AND SA1.A1_COD       = SD2.D2_CLIENTE
_cQuery += "       AND SA1.A1_LOJA      = SD2.D2_LOJA
_cQuery += "       AND ROWNUM           = 1
_cQuery += "       )
_cQuery += "   END NOME,
_cQuery += "   ' ' CLASSIFICACAO
_cQuery += " FROM "+RetSqlName("SD2")+" SD2 ,
_cQuery += "   "+RetSqlName("SB1")+" SB1 ,
_cQuery += "   "+RetSqlName("SF4")+" SF4
_cQuery += " WHERE SD2.D_E_L_E_T_ = ' '
_cQuery += " AND SD2.D2_EMISSAO   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' 
_cQuery += " AND SD2.D2_COD       = '"+MV_PAR03+"'

If !Empty(MV_PAR04)
	_cQuery += " AND SD2.D2_FILIAL = '"+MV_PAR04+"'
Endif

If !Empty(MV_PAR05)
	_cQuery += " AND SD2.D2_LOCAL = '"+MV_PAR05+"'
Endif

_cQuery += " AND SB1.D_E_L_E_T_   = ' ' 
If !Empty(MV_PAR08)
	_cQuery += " AND SD2.D2_CLIENTE BETWEEN '"+MV_PAR06+"'  AND '"+MV_PAR08+"'
Endif     

If !Empty(MV_PAR08)
	_cQuery += " AND SD2.D2_LOJA BETWEEN '"+MV_PAR07+"'  AND '"+MV_PAR09+"'
Endif   

_cQuery += " AND SB1.B1_COD       = SD2.D2_COD
_cQuery += " AND SF4.D_E_L_E_T_   = ' '
_cQuery += " AND SF4.F4_CODIGO    = SD2.D2_TES
_cQuery += " UNION ALL
_cQuery += " SELECT 'DOC. ENTRADA' TABELA,
_cQuery += "   D1_NUMSEQ SEQUENCIA,
_cQuery += "   D1_EMISSAO EMISSAO,
_cQuery += "   D1_FILIAL FILIAL,
_cQuery += "   D1_DOC,
_cQuery += "   D1_SERIE,
_cQuery += "   ' ',
_cQuery += "   D1_COD,
_cQuery += "   B1_DESC,
_cQuery += "   D1_QUANT,
_cQuery += "   D1_VUNIT,
_cQuery += "   D1_TOTAL,
_cQuery += "   D1_CUSTO,
_cQuery += "   D1_LOCAL,
_cQuery += "   D1_TES TES_TIPO_MOVIMENTO,
_cQuery += "   D1_CF,
_cQuery += "   F4_TEXTO,
_cQuery += "   F4_ESTOQUE,
_cQuery += "   F4_PODER3,
_cQuery += "   ' ',
_cQuery += "   D1_TIPO,
_cQuery += "   D1_FORNECE,
_cQuery += "   D1_LOJA,
_cQuery += "   CASE
_cQuery += "     WHEN D1_TIPO IN ('D','B')
_cQuery += "     THEN
_cQuery += "       (SELECT A1_NOME
_cQuery += "       FROM SA1000 SA1
_cQuery += "       WHERE SA1.D_E_L_E_T_ = ' '
_cQuery += "       AND SA1.A1_COD       = SD1.D1_FORNECE
_cQuery += "       AND SA1.A1_LOJA      = SD1.D1_LOJA
_cQuery += "       AND ROWNUM           = 1
_cQuery += "       )
_cQuery += "     ELSE
_cQuery += "       (SELECT A2_NOME
_cQuery += "       FROM SA2000 SA2
_cQuery += "       WHERE SA2.D_E_L_E_T_ = ' '
_cQuery += "       AND SA2.A2_COD       = SD1.D1_FORNECE
_cQuery += "       AND SA2.A2_LOJA      = SD1.D1_LOJA
_cQuery += "       AND ROWNUM           = 1
_cQuery += "       )
_cQuery += "   END CLIENTE,
_cQuery += "   CASE WHEN D1_TES <> ' ' AND D1_DTDIGIT <> ' ' AND D1_CLASFIS <> ' ' THEN D1_DTDIGIT END CLASSIFICACAO
_cQuery += " FROM "+RetSqlName("SD1")+" SD1 ,
_cQuery += "   "+RetSqlName("SB1")+" SB1 ,
_cQuery += "   "+RetSqlName("SF4")+" SF4
_cQuery += " WHERE SD1.D_E_L_E_T_   = ' '
If !Empty(MV_PAR08)
	_cQuery += " AND SD1.D1_FORNECE BETWEEN '"+MV_PAR06+"'  AND '"+MV_PAR08+"'
Endif     

If !Empty(MV_PAR08)
	_cQuery += " AND SD1.D1_LOJA BETWEEN '"+MV_PAR07+"'  AND '"+MV_PAR09+"'
Endif   


_cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' 
_cQuery += " AND SD1.D1_COD       = '"+MV_PAR03+"'

If !Empty(MV_PAR04)
	_cQuery += " AND SD1.D1_FILIAL = '"+MV_PAR04+"'
Endif

If !Empty(MV_PAR05)
	_cQuery += " AND SD1.D1_LOCAL = '"+MV_PAR05+"'
Endif

_cQuery += " AND SB1.D_E_L_E_T_   = ' '
_cQuery += " AND SB1.B1_COD       = SD1.D1_COD 
_cQuery += " AND SF4.D_E_L_E_T_   = ' '
_cQuery += " AND SF4.F4_CODIGO    = SD1.D1_TES
_cQuery += " UNION ALL
_cQuery += " SELECT 'MOV. INTERNO' TABELA,
_cQuery += "   D3_NUMSEQ SEQUENCIA,
_cQuery += "   D3_EMISSAO EMISSAO,
_cQuery += "   D3_FILIAL FILIAL,
_cQuery += "   D3_DOC,
_cQuery += "   ' ',
_cQuery += "   ' ',
_cQuery += "   D3_COD,
_cQuery += "   B1_DESC,
_cQuery += "   CASE
_cQuery += "     WHEN D3_TM > '499'
_cQuery += "     THEN D3_QUANT*-1
_cQuery += "     ELSE D3_QUANT
_cQuery += "   END QUANTIDADE,
_cQuery += "   0,
_cQuery += "   0,
_cQuery += "   D3_CUSTO1,
_cQuery += "   D3_LOCAL,
_cQuery += "   D3_TM TES_TIPO_MOVIMENTO,
_cQuery += "   ' ',
_cQuery += "   CASE 
_cQuery += "       WHEN D3_TM = '499' THEN 'RESERVADO SISTEMA'
_cQuery += "       WHEN D3_TM = '999' THEN 'RESERVADO SISTEMA' 
_cQuery += "       ELSE F5_TEXTO
_cQuery += "     END,
_cQuery += "   ' ',
_cQuery += "   ' ',
_cQuery += "   F5_VAL,
_cQuery += "   ' ',
_cQuery += "   ' ',
_cQuery += "   ' ',
_cQuery += "   ' ',
_cQuery += "   ' '
_cQuery += " FROM "+RetSqlName("SD3")+" SD3
_cQuery += " LEFT JOIN "+RetSqlName("SF5")+" SF5
_cQuery += " ON SF5.F5_CODIGO  = SD3.D3_TM 
_cQuery += " AND SF5.D_E_L_E_T_ = ' ' , 
_cQuery += "   "+RetSqlName("SB1")+" SB1 
_cQuery += " WHERE SD3.D_E_L_E_T_ = ' '
_cQuery += " AND SD3.D3_EMISSAO   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' 
_cQuery += " AND SD3.D3_COD       = '"+MV_PAR03+"'

If !Empty(MV_PAR04)
	_cQuery += " AND SD3.D3_FILIAL = '"+MV_PAR04+"'
Endif

If !Empty(MV_PAR05)
	_cQuery += " AND SD3.D3_LOCAL = '"+MV_PAR05+"'
Endif

_cQuery += " AND SB1.D_E_L_E_T_ = ' '
_cQuery += " AND SB1.B1_COD     = SD3.D3_COD

_cQuery += " ORDER BY "

Do Case 
	Case oSection1:nOrder == 1
		_cQuery += " SEQUENCIA "
	Case oSection1:nOrder == 2
		_cQuery += " SEQUENCIA,FILIAL "
	Case oSection1:nOrder == 3
		_cQuery += " EMISSAO,FILIAL,TES_TIPO_MOVIMENTO "
	Case oSection1:nOrder == 4
		_cQuery += " FILIAL,EMISSAO,TES_TIPO_MOVIMENTO "
		
End Case
  
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)
TCSetFiEld(_cAlias1,"EMISSAO","D",8,0)  





oSection1:Init()   

If !Empty(MV_PAR04) .AND. !Empty(MV_PAR05)
	
	_aEstoque := CalcEst((_cAlias1)->PRODUTO,MV_PAR05,MV_PAR01-1) 
			
	oSection1:Cell("TABELA"):SetValue( 'SALDO INICIAL' )     
	oSection1:Cell("SEQUENCIA"):SetValue( ' ' )     
	oSection1:Cell("EMISSAO"):SetValue( MV_PAR01-1 )     
	oSection1:Cell("CLASSIFICACAO"):SetValue( ' ' )
	oSection1:Cell("FILIAL"):SetValue( MV_PAR04 )     
	oSection1:Cell("DOCUMENTO"):SetValue( ' ' )     
	oSection1:Cell("SERIE"):SetValue( ' ' )     
	oSection1:Cell("PEDIDO"):SetValue( ' ' )     
	oSection1:Cell("PRODUTO"):SetValue( (_cAlias1)->PRODUTO )     
	oSection1:Cell("DESCRICAO"):SetValue( (_cAlias1)->DESCRICAO )     
	oSection1:Cell("QUANTIDADE"):SetValue( _aEstoque[1] )     
	oSection1:Cell("VALOR_UNITARIO"):SetValue( 0 )     
	oSection1:Cell("VALOR_TOTAL"):SetValue( 0 )     
	oSection1:Cell("CUSTO"):SetValue( _aEstoque[2] )     
	oSection1:Cell("ARMAZEM"):SetValue( ' ' )     
	oSection1:Cell("TES_TIPO_MOVIMENTO"):SetValue( ' ' )     
	oSection1:Cell("CFOP"):SetValue(' ' )     
	oSection1:Cell("DESCRICAO_MOVIMENTO"):SetValue( ' ' )     
	oSection1:Cell("ATUALIZA_ESTOQUE"):SetValue( ' ' )     
	oSection1:Cell("PODER_TERCEIRO"):SetValue( ' ' )     
	oSection1:Cell("VALORIZADO"):SetValue( ' ' )     
	oSection1:Cell("TIPO_NOTA"):SetValue( ' ' )
	oSection1:Cell("CLIENTE_FORNECEDOR"):SetValue( ' ' )
	oSection1:Cell("LOJA"):SetValue( ' ' )
	oSection1:Cell("NOME"):SetValue( ' ' )
	
	oSection1:PrintLine()
Endif
	
While !(_cAlias1)->(Eof())
   
   	
   	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	
	//oSection1:Init()  
    xclassificacao :=STOD((_cAlias1)->CLASSIFICACAO)
	
	oSection1:Cell("TABELA"):SetValue( (_cAlias1)->TABELA )     
	oSection1:Cell("SEQUENCIA"):SetValue( (_cAlias1)->SEQUENCIA )     
	oSection1:Cell("EMISSAO"):SetValue( (_cAlias1)->EMISSAO )
	oSection1:Cell("CLASSIFICACAO"):SetValue( xclassificacao )    
	oSection1:Cell("FILIAL"):SetValue( (_cAlias1)->FILIAL )     
	oSection1:Cell("DOCUMENTO"):SetValue( (_cAlias1)->DOCUMENTO )     
	oSection1:Cell("SERIE"):SetValue( (_cAlias1)->SERIE )     
	oSection1:Cell("PEDIDO"):SetValue( (_cAlias1)->PEDIDO )     
	oSection1:Cell("PRODUTO"):SetValue( (_cAlias1)->PRODUTO )     
	oSection1:Cell("DESCRICAO"):SetValue( (_cAlias1)->DESCRICAO )     
	oSection1:Cell("QUANTIDADE"):SetValue( (_cAlias1)->QUANTIDADE )     
	oSection1:Cell("VALOR_UNITARIO"):SetValue( (_cAlias1)->VALOR_UNITARIO )     
	oSection1:Cell("VALOR_TOTAL"):SetValue( (_cAlias1)->VALOR_TOTAL )     
	oSection1:Cell("CUSTO"):SetValue( (_cAlias1)->CUSTO )     
	oSection1:Cell("ARMAZEM"):SetValue( (_cAlias1)->ARMAZEM )     
	oSection1:Cell("TES_TIPO_MOVIMENTO"):SetValue( (_cAlias1)->TES_TIPO_MOVIMENTO )     
	oSection1:Cell("CFOP"):SetValue( (_cAlias1)->CFOP )     
	oSection1:Cell("DESCRICAO_MOVIMENTO"):SetValue( (_cAlias1)->DESCRICAO_MOVIMENTO )     
	oSection1:Cell("ATUALIZA_ESTOQUE"):SetValue( (_cAlias1)->ATUALIZA_ESTOQUE )     
	oSection1:Cell("PODER_TERCEIRO"):SetValue( (_cAlias1)->PODER_TERCEIRO )     
	oSection1:Cell("VALORIZADO"):SetValue( (_cAlias1)->VALORIZADO )     
	oSection1:Cell("TIPO_NOTA"):SetValue( (_cAlias1)->TIPO_NOTA )     
	oSection1:Cell("CLIENTE_FORNECEDOR"):SetValue( (_cAlias1)->CLIENTE_FORNECEDOR )     
	oSection1:Cell("LOJA"):SetValue( (_cAlias1)->LOJA )     
	oSection1:Cell("NOME"):SetValue( (_cAlias1)->NOME )     
			
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

Return(.t.)