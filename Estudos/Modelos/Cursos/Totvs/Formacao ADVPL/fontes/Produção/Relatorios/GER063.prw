#include "protheus.ch"
#include "topconn.ch"

/*/

DESCRICAO: RELATORIO DE CRITICAS DO PEDIDO

ALTERACOES:
29/12/2016 - Desenvolvimento do fonte

/*/

User Function GER063

Local oReport
Local cPerg := "GER063"

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

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------

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
AADD(aHelpPor,"Obrigatório preenchimento.    ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório preenchimento.    ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:" ,"Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)



Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1
Local oSection2

//Declaracao do relatorio
oReport := TReport():New("GER063","GER063 - CRITICAS DO PEDIDO",cPerg,{|oReport| PrintReport(oReport)},"GER063 - CRITICAS DO PEDIDO")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Pedidos","")
	
//Celulas da secao
TRCell():New(oSection1,"A1_COD"			,"SA1","Código",,10)
TRCell():New(oSection1,"A1_LOJA"      	,"SA1","Loja",,8)
TRCell():New(oSection1,"A1_NOME"     	,"SA1","Cliente",,20)
TRCell():New(oSection1,"C5_NUM"  		,"SC5","Pedido",,10)
TRCell():New(oSection1,"C5_EMISSAO"  	,"SC5","Emissão",,15)  
TRCell():New(oSection1,"C5_XMOTIVO"		,"SC5","Justificativa",,45)     
TRCell():New(oSection1,"C5_XUSRDIG"  	,"SC5","Usuário",,15)
TRCell():New(oSection1,"F2_DOC"  	    ,"SF2","Doc.Saída",,15)
TRCell():New(oSection1,"F2_SERIE"   	,"SF2","Série",,8)
TRCell():New(oSection1,"F2_FILIAL"  	,"SF2","Filial",,15)
                      
//Faz a impressao do totalizador em linha
//oSection1:SetTotalInLine(.f.)
//oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1)  
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()            
Local xCliente  := ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

_cQuery := "SELECT SA1.A1_COD A1_COD, SA1.A1_LOJA A1_LOJA, SA1.A1_NOME A1_NOME, SC5.C5_NUM C5_NUM, TO_DATE(SC5.C5_EMISSAO,'YYYYMMDD') C5_EMISSAO, UPPER(SC5.C5_XMOTIVO) C5_XMOTIVO, SC5.C5_XUSRDIG C5_XUSRDIG,
_cQuery += "       SF2.F2_DOC F2_DOC, SF2.F2_SERIE F2_SERIE, SF2.F2_FILIAL F2_FILIAL
_cQuery += "  FROM " + RetSqlName("SC5") + " SC5 INNER JOIN " + RetSqlName("SA1") + " SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND SC5.C5_LOJACLI = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' '
_cQuery += "    LEFT JOIN " + RetSqlName("SF2") + " SF2 ON SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_SERIE = SF2.F2_SERIE AND SC5.C5_FILIAL = SF2.F2_FILIAL AND SF2.D_E_L_E_T_ = ' ' 
_cQuery += "    LEFT JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL AND SD2.D_E_L_E_T_ = ' ' 
_cQuery += "        WHERE SC5.C5_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
_cQuery += "  AND SC5.C5_XMOTIVO <> ' '
_cQuery += " ORDER BY TO_DATE(SC5.C5_EMISSAO,'YYYYMMDD'), SA1.A1_NOME

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oSection1:Init()  

      	
	oSection1:Cell("A1_COD"):SetValue((_cAlias1)->A1_COD)
	oSection1:Cell("A1_LOJA"):SetValue((_cAlias1)->A1_LOJA)
	oSection1:Cell("A1_NOME"):SetValue((_cAlias1)->A1_NOME)
	oSection1:Cell("C5_NUM"):SetValue((_cAlias1)->C5_NUM)
	oSection1:Cell("C5_EMISSAO"):SetValue((_cAlias1)->C5_EMISSAO)
    oSection1:Cell("C5_XMOTIVO"):SetValue((_cAlias1)->C5_XMOTIVO)
    oSection1:Cell("C5_XUSRDIG"):SetValue((_cAlias1)->C5_XUSRDIG)
    oSection1:Cell("F2_DOC"):SetValue((_cAlias1)->F2_DOC) 
    oSection1:Cell("F2_SERIE"):SetValue((_cAlias1)->F2_SERIE)
    oSection1:Cell("F2_FILIAL"):SetValue((_cAlias1)->F2_FILIAL)
	
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)