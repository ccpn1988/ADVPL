#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
Programa: EST037

Descrição: Relatório Análise de Estoque GEN 

Data: 15/12/2015
/*/

User Function EST037()             

Local oReport
Local cPerg := "EST037"

Private _cAlias1	:= ""

//Cria grupo de perguntas

AjusteSX1(cPerg) 

//Carrega grupo de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

If Empty(MV_PAR02)
	Alert("É obrigatório informar a filial.")
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

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2
//Local _cProduto := MntStrPsq(MV_PAR02)

Local aOrdem	:= {"Produto"}


//Declaracao do relatorio
oReport := TReport():New("EST037","EST037 - Analise de Estoque GEN",cPerg,{|oReport| PrintReport(oReport)},"EST037 - Analise de Estoque GEN")
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
TRCell():New(oSection1,"CODIGO"			,"  "	,"CODIGO"							   ,,20)
TRCell():New(oSection1,"DESCRICAO"		,"  "	,"DESCRICAO"						   ,,20)
TRCell():New(oSection1,"ISBN"			,"  "	,"ISBN"							 	,,20)
TRCell():New(oSection1,"PUBLICACAO"	,"  "	,"PUBLICACAO"						   ,,20)
TRCell():New(oSection1,"SITUACAO"		,"  "	,"SITUACAO"							,,20)
TRCell():New(oSection1,"ORIGEM01"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_01"		,,20)
TRCell():New(oSection1,"ORIGEM02"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_02"		,,20)
TRCell():New(oSection1,"ORIGEM03"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_03"		,,20)
TRCell():New(oSection1,"ORIGEM04"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_04"		,,20)
TRCell():New(oSection1,"ORIGEM05"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_05"		,,20)
TRCell():New(oSection1,"ORIGEM06"		,"  "	,"SALDO_ESTOQUE_ORIGEM_ARM_06"		,,20)
TRCell():New(oSection1,"ORIGEMT"		,"  "	,"SALDO_ESTOQUE_ORIGEM_TODOS_ARM"	,,20)
TRCell():New(oSection1,"GEN01"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_01"			,,20)
TRCell():New(oSection1,"GEN02"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_02"			,,20)
TRCell():New(oSection1,"GEN03"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_03"			,,20)
TRCell():New(oSection1,"GEN04"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_04"			,,20)
TRCell():New(oSection1,"GEN05"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_05"			,,20)
TRCell():New(oSection1,"GEN06"			,"  "	,"SALDO_ESTOQUE_GEN_ARM_06"			,,20)
TRCell():New(oSection1,"GENT"			,"  "	,"SALDO_ESTOQUE_GEN_TODOS_ARM"		,,20)
TRCell():New(oSection1,"QCONORI"		,"  "	,"QUANTIDADE_CONSIG_ORIGEM"			,,20)
TRCell():New(oSection1,"QCONGEN"		,"  "	,"QUANTIDADE_CONSIG_GEN"			    ,,20)
TRCell():New(oSection1,"SCONORI"		,"  "	,"SALDO_CONSIG_ORIGEM"				,,20)
TRCell():New(oSection1,"SCONGEN"   	,"  "	,"SALDO_CONSIG_GEN"					,,20)
TRCell():New(oSection1,"CONOUT"			,"  "	,"SALDO_CONGIG_ORIGEM_OUTROS"		,,20)
TRCell():New(oSection1,"CONMER"			,"  "	,"SALDO_CONSIG_GEN_MERCADO"			,,20)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cQuery   := ""
Local _cProduto := MntStrPsq(MV_PAR01)

If oreport:OREPORT:NDEVICE <> 4
	MsgInfo("Atenção: este relatório foi formatado para Excel. Os demais formatos podem não apresentar o layout correto.")
Endif

_cQuery := " "
_cQuery += " SELECT * FROM (
_cQuery += " SELECT B1_COD CODIGO
_cQuery += " ,B1_DESC DESCRICAO
_cQuery += " ,B1_ISBN ISBN
_cQuery += " ,B1_XIDTPPU PUBLICACAO
_cQuery += " ,B1_XSITOBR SITUACAO
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '01' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM01
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '01' AND S1.D_E_L_E_T_ = ' '),0) GEN01

_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '02' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM02
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '02' AND S1.D_E_L_E_T_ = ' '),0) GEN02

_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '03' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM03
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '03' AND S1.D_E_L_E_T_ = ' '),0) GEN03

_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '04' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM04
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '04' AND S1.D_E_L_E_T_ = ' '),0) GEN04

_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '05' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM05
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '05' AND S1.D_E_L_E_T_ = ' '),0) GEN05 

_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '06' AND S1.D_E_L_E_T_ = ' '),0) ORIGEM06
_cQuery += " ,NVL((SELECT B2_QATU FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.B2_LOCAL = '06' AND S1.D_E_L_E_T_ = ' '),0) GEN06

_cQuery += " ,NVL((SELECT SUM(B2_QATU) FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '"+MV_PAR02+"' AND S1.B2_COD = SB1.B1_COD AND S1.D_E_L_E_T_ = ' '),0) ORIGEMT
_cQuery += " ,NVL((SELECT SUM(B2_QATU) FROM " + RETSQLNAME('SB2') + " S1 WHERE S1.B2_FILIAL = '1022' AND S1.B2_COD = SB1.B1_COD AND S1.D_E_L_E_T_ = ' '),0) GENT

_cQuery += " ,NVL((SELECT SUM(B61.B6_QUANT) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '"+MV_PAR02+"' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR = '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_TPCF = 'C' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) QCONORI
_cQuery += " ,NVL((SELECT SUM(B61.B6_QUANT) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'D' AND B61.B6_TPCF = 'F' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) QCONGEN

_cQuery += " ,NVL((SELECT SUM(B61.B6_SALDO) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '"+MV_PAR02+"' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR = '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_TPCF = 'C' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) SCONORI
_cQuery += " ,NVL((SELECT SUM(B61.B6_SALDO) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'D' AND B61.B6_TPCF = 'F' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) SCONGEN

_cQuery += " ,NVL((SELECT SUM(B61.B6_SALDO) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '"+MV_PAR02+"' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_CLIFOR <> '0005065' AND B61.B6_TIPO = 'E' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) CONOUT
_cQuery += " ,NVL((SELECT SUM(B61.B6_SALDO) FROM " + RETSQLNAME('SB6') + " B61 WHERE B61.B6_FILIAL = '1022' AND SB1.B1_COD = B61.B6_PRODUTO AND B61.B6_TIPO = 'E' AND B61.B6_PODER3 = 'R' AND B61.D_E_L_E_T_ = ' '),0) CONMER

_cQuery += " FROM " + RETSQLNAME('SB1') + " SB1
_cQuery += " WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"'

If Left(MV_PAR02,2) == "10" //GEN
	_cQuery += " AND SB1.B1_PROC = '378803 '
		
ElseIf Left(MV_PAR02,2) == "20" //EGK       
	_cQuery += " AND SB1.B1_PROC = '0380795'
	
ElseIf Left(MV_PAR02,2) == "30" //LTC
	_cQuery += " AND SB1.B1_PROC = '0380796'
	
ElseIf Left(MV_PAR02,2) == "40"	//FOR
	_cQuery += " AND SB1.B1_PROC = '0380794'
	
ElseIf Left(MV_PAR02,2) == "60" //ACF
	_cQuery += " AND SB1.B1_PROC = '031811 '
	
ElseIf Left(MV_PAR02,2) == "90" //ATL
	_cQuery += " AND SB1.B1_PROC = '0378128'
	
Endif


If !Empty(MV_PAR01)
	_cQuery += " AND SB1.B1_ISBN IN ("+_cProduto+")
Endif

_cQuery += " AND SB1.D_E_L_E_T_ = ' ')

If MV_PAR03 == 2
	_cQuery += " WHERE ORIGEMT > 0
Endif

_cQuery += " ORDER BY 

Do Case 
	Case oSection1:nOrder == 1
		_cQuery += " CODIGO "
End
  
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

oSection1:Init()  
	
While !(_cAlias1)->(Eof())
	
	If oReport:Cancel()
		Return nil
	EndIF
	
	oReport:IncMeter()
	
	//oSection1:Init()  
	
	oSection1:Cell("CODIGO"):SetValue( (_cAlias1)->CODIGO )     
	oSection1:Cell("DESCRICAO"):SetValue( (_cAlias1)->DESCRICAO  )     
	oSection1:Cell("ISBN"):SetValue( (_cAlias1)->ISBN )     
	oSection1:Cell("SITUACAO"):SetValue( (_cAlias1)->SITUACAO )     
	oSection1:Cell("PUBLICACAO"):SetValue( (_cAlias1)->PUBLICACAO )     
	oSection1:Cell("ORIGEM01"):SetValue( (_cAlias1)->ORIGEM01 )     
	oSection1:Cell("GEN01"):SetValue( (_cAlias1)->GEN01 )     
	oSection1:Cell("ORIGEM02"):SetValue( (_cAlias1)->ORIGEM02 )     
	oSection1:Cell("GEN02"):SetValue( (_cAlias1)->GEN02 )     
	oSection1:Cell("ORIGEM03"):SetValue( (_cAlias1)->ORIGEM03 )     
	oSection1:Cell("GEN03"):SetValue( (_cAlias1)->GEN03 )     
	oSection1:Cell("ORIGEM04"):SetValue( (_cAlias1)->ORIGEM04 )     
	oSection1:Cell("GEN04"):SetValue( (_cAlias1)->GEN04 )     
	oSection1:Cell("ORIGEM05"):SetValue( (_cAlias1)->ORIGEM05 )     
	oSection1:Cell("GEN05"):SetValue( (_cAlias1)->GEN05 )     
	oSection1:Cell("ORIGEM06"):SetValue( (_cAlias1)->ORIGEM06 )     
	oSection1:Cell("GEN06"):SetValue( (_cAlias1)->GEN06 )  
	oSection1:Cell("ORIGEMT"):SetValue( (_cAlias1)->ORIGEMT )     
	oSection1:Cell("GENT"):SetValue( (_cAlias1)->GENT )     
	oSection1:Cell("QCONORI"):SetValue( (_cAlias1)->QCONORI )     
	oSection1:Cell("QCONGEN"):SetValue( (_cAlias1)->QCONGEN )     
	oSection1:Cell("SCONORI"):SetValue( (_cAlias1)->SCONORI )     
	oSection1:Cell("SCONGEN"):SetValue( (_cAlias1)->SCONGEN )     
	oSection1:Cell("CONOUT"):SetValue( (_cAlias1)->CONOUT )     
	oSection1:Cell("CONMER"):SetValue( (_cAlias1)->CONMER )     
			
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
	
EndDo

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

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

Return _cTipos