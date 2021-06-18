#include "protheus.ch"
#include "topconn.ch"

/*/

DESCRICAO: RELATORIO CUSTO TRANSPORTADORA

ALTERACOES:
03/03/2017 - Desenvolvimento do fonte

/*/

User Function GER064

Local oReport
Local cPerg := "GER064"

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
AADD(aHelpPor,"")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:" ,"Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "A4_COD"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Transportadora ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SA4"	//Posicione("SX3",2,cCpoPer,'X3_F3')
nTamPer := TamSx3(cCpoPer)[1]    
cTpoPer := "G"	//G-get;C-combo  

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

Putsx1(cPerg, cItPerg, "Nº Fatura:", "Nº Fatura:", "Nº Fatura:", cMVCH, "C",9,0,0,"G","","","","",cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

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
oReport := TReport():New("GER064","GER064 - CUSTO TRANSPORTADORA",cPerg,{|oReport| PrintReport(oReport)},"GER064 - CUSTO TRANSPORTADORA")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    
//oReport:SetPortrait()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Transportadora","")

//Celulas da secao
TRCell():New(oSection1,"A4_NOME"	,"","Transportadora",,40)
TRCell():New(oSection1,"DATAINI"   	,"","Dt. Inicial",,10)
TRCell():New(oSection1,"DATAFIM"   	,"","Dt. Final",,10)
TRCell():New(oSection1,"FATURA"		,"","Fatura",,10)
TRCell():New(oSection1,"OBS"		,"","",,70)

//Secao do relatorio
oSection2 := TRSection():New(oSection1,"","")
	
//Celulas da secao
TRCell():New(oSection2,"OPERACAO"		,"",CRLF+"Operação",,25)
TRCell():New(oSection2,"FAT_LIQ"      	,"",CRLF+"Fatº Líquido",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"FRETE_COB"     	,"","Frete Cobrado"+CRLF+"Ao Cliente",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"CST_FRETE" 		,"",CRLF+"Custo Frete",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"PERC_FRETE"		,"","% Frete"+CRLF+"(Custo GEN)","@E 999,999.99",6,,,,,"RIGHT")
                      
//Totalizadores
TRFunction():New(oSection2:Cell("FAT_LIQ")		,NIL,"SUM",,,,,.F.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("FRETE_COB")	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection2)
TRFunction():New(oSection2:Cell("CST_FRETE")   	,NIL,"SUM",,,,,.F.,.T.,.F.,oSection2)


//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.f.)
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oSection1:Section(1)
Local _cQuery   := ""
Local _cAlias1	:= GetNextAlias()            
Local xTransp   := ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

If !Empty(MV_PAR01) .and. !Empty(MV_PAR04)
	MsgInfo('Ao preencher período e número da fatura, o período não será considerado na seleção das informações!')
EndIf
_cQuery := " SELECT '" + DTOC(MV_PAR01) + "' DATAINI
_cQuery += "      , '" + DTOC(MV_PAR02) + "' DATAFIM
_cQuery += "      , '" + MV_PAR04 + "' FATURA
If !Empty(MV_PAR01) .and. !Empty(MV_PAR04)
	_cQuery += "      ,	'Período e fatura preenchidos, o período não será considerado' OBS
Else
	_cQuery += "      ,	' ' OBS
EndIf
_cQuery += "      , G64.G64_TRANSP
_cQuery += "      , SA4.A4_NOME
_cQuery += "      , SD2.D2_TES+0 TES
_cQuery += "      , CASE WHEN SD2.D2_TES IN (516,517,518,519) THEN TRIM(SF4.F4_TEXTO)||' (Valor Nota)' ELSE TRIM(SF4.F4_TEXTO) END OPERACAO
_cQuery += "      , SUM(SD2.D2_VALBRUT) FAT_LIQ
_cQuery += "      , SUM(SD2.D2_VALFRE) FRETE_COB
_cQuery += "      , CASE WHEN SD2.D2_TES IN (516,517,518,519) THEN 0 ELSE SUM(G64.G64_TOTSERV) END CST_FRETE
_cQuery += "      , CASE WHEN SD2.D2_TES IN (516,517,518,519) THEN 0 ELSE ((SUM(G64.G64_TOTSERV)-SUM(SD2.D2_VALFRE))/(SUM(SD2.D2_VALBRUT)-SUM(SD2.D2_VALFRE)))*100 END PERC_FRETE
_cQuery += "   FROM GER064_FATURA_FRETE G64
_cQuery += "  INNER JOIN (SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI D2_TES, SUM(D2_VALBRUT) D2_VALBRUT, SUM(D2_VALFRE) D2_VALFRE, SD2.D_E_L_E_T_
_cQuery += "                FROM " + RetSqlName("SD2") + " SD2
_cQuery += "               INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ' ' 
_cQuery += "               GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI, SD2.D_E_L_E_T_) SD2 ON G64.G64_NOTA = SD2.D2_DOC AND G64.G64_SERIENF = SD2.D2_SERIE
_cQuery += "  LEFT JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO
_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " SA4 ON G64.G64_TRANSP = SA4.A4_COD
_cQuery += "  WHERE G64.G64_TIPOSERV <> 'DEV'
If !Empty(MV_PAR01) .and. Empty(MV_PAR04)
	_cQuery += "    AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
EndIf
If !Empty(MV_PAR03)
	_cQuery += "    AND G64.G64_TRANSP = '"+MV_PAR03+"'
EndIf
If !Empty(MV_PAR04)
	_cQuery += "    AND G64.G64_FATURA = '"+MV_PAR04+"'
EndIf
_cQuery += "    AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "    AND SD2.D_E_L_E_T_ = ' '
_cQuery += "    AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "    AND SF4.D_E_L_E_T_ = ' '
_cQuery += "    AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'"
_cQuery += "    AND SA4.D_E_L_E_T_ = ' '
_cQuery += "   GROUP BY G64.G64_TRANSP, SA4.A4_NOME, SD2.D2_TES, SF4.F4_TEXTO
_cQuery += " UNION
_cQuery += " SELECT '" + DTOC(MV_PAR01) + "' DATAINI
_cQuery += "      , '" + DTOC(MV_PAR02) + "' DATAFIM
_cQuery += "      , '" + MV_PAR04 + "' FATURA
If !Empty(MV_PAR01) .and. !Empty(MV_PAR04)
	_cQuery += "      ,	'Período e fatura preenchidos, o período não será considerado' OBS
Else
	_cQuery += "      ,	' ' OBS
EndIf
_cQuery += "      , G64.G64_TRANSP
_cQuery += "      , SA4.A4_NOME
_cQuery += "      , SD2.D2_TES+0 TES
_cQuery += "      , TRIM(SF4.F4_TEXTO)||' (Valor Capa)' OPERACAO
_cQuery += "      , SUM(SD2.D2_VALBRUT) FAT_LIQ
_cQuery += "      , SUM(SD2.D2_VALFRE) FRETE_COB
_cQuery += "      , SUM(G64.G64_TOTSERV) CST_FRETE
_cQuery += "      , ((SUM(G64.G64_TOTSERV)-SUM(SD2.D2_VALFRE))/(SUM(SD2.D2_VALBRUT)-SUM(SD2.D2_VALFRE)))*100 PERC_FRETE
_cQuery += "   FROM GER064_FATURA_FRETE G64
_cQuery += "  INNER JOIN (SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI D2_TES, SUM(D2_VALBRUT) D2_VALBRUT, SUM(D2_VALFRE) D2_VALFRE, SD2.D_E_L_E_T_
_cQuery += "                FROM " + RetSqlName("SD2") + " SD2
_cQuery += "               INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ' ' 
_cQuery += "               GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI, SD2.D_E_L_E_T_) SD2 ON G64.G64_NOTA = SD2.D2_DOC AND G64.G64_SERIENF = SD2.D2_SERIE
_cQuery += "  LEFT JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO
_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " SA4 ON G64.G64_TRANSP = SA4.A4_COD
_cQuery += "  WHERE G64.G64_TIPOSERV <> 'DEV'
If !Empty(MV_PAR01) .and. Empty(MV_PAR04)
	_cQuery += "    AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
EndIf
If !Empty(MV_PAR03)
	_cQuery += "    AND G64.G64_TRANSP = '"+MV_PAR03+"'
EndIf
If !Empty(MV_PAR04)
	_cQuery += "    AND G64.G64_FATURA = '"+MV_PAR04+"'
EndIf
_cQuery += "    AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "    AND SD2.D2_TES IN ('516','517','518','519')
_cQuery += "    AND SD2.D_E_L_E_T_ = ' '
_cQuery += "    AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "    AND SF4.D_E_L_E_T_ = ' '
_cQuery += "    AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'"
_cQuery += "    AND SA4.D_E_L_E_T_ = ' '
_cQuery += "   GROUP BY G64.G64_TRANSP, SA4.A4_NOME, SD2.D2_TES, SF4.F4_TEXTO
_cQuery += " UNION
_cQuery += " SELECT '" + DTOC(MV_PAR01) + "' DATAINI
_cQuery += "      , '" + DTOC(MV_PAR02) + "' DATAFIM
_cQuery += "      , '" + MV_PAR04 + "' FATURA
If !Empty(MV_PAR01) .and. !Empty(MV_PAR04)
	_cQuery += "      ,	'Período e fatura preenchidos, o período não será considerado' OBS
Else
	_cQuery += "      ,	' ' OBS
EndIf
_cQuery += "      , G64.G64_TRANSP
_cQuery += "      , SA4.A4_NOME
_cQuery += "      , SD2.D2_TES+300 TES
_cQuery += "      , TRIM(SF4.F4_TEXTO)||' (DEVOLUCAO)' OPERACAO
_cQuery += "      , SUM(SD2.D2_VALBRUT) FAT_LIQ
_cQuery += "      , SUM(SD2.D2_VALFRE) FRETE_COB
_cQuery += "      , SUM(G64.G64_TOTSERV) CST_FRETE
_cQuery += "      , ((SUM(G64.G64_TOTSERV)-SUM(SD2.D2_VALFRE))/(SUM(SD2.D2_VALBRUT)-SUM(SD2.D2_VALFRE)))*100 PERC_FRETE
_cQuery += "   FROM GER064_FATURA_FRETE G64
_cQuery += "  INNER JOIN (SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI D2_TES, SUM(D2_VALBRUT) D2_VALBRUT, SUM(D2_VALFRE) D2_VALFRE, SD2.D_E_L_E_T_
_cQuery += "                FROM " + RetSqlName("SD2") + " SD2
_cQuery += "               INNER JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.D_E_L_E_T_ = ' ' 
_cQuery += "               GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, F4_XTESPAI, SD2.D_E_L_E_T_) SD2 ON G64.G64_NOTA = SD2.D2_DOC AND G64.G64_SERIENF = SD2.D2_SERIE
_cQuery += "  LEFT JOIN " + RetSqlName("SF4") + " SF4 ON SD2.D2_TES = SF4.F4_CODIGO
_cQuery += "  LEFT JOIN " + RetSqlName("SA4") + " SA4 ON G64.G64_TRANSP = SA4.A4_COD
_cQuery += "  WHERE G64.G64_TIPOSERV = 'DEV'
If !Empty(MV_PAR01) .and. Empty(MV_PAR04)
	_cQuery += "    AND SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'"
EndIf
If !Empty(MV_PAR03)
	_cQuery += "    AND G64.G64_TRANSP = '"+MV_PAR03+"'
EndIf
If !Empty(MV_PAR04)
	_cQuery += "    AND G64.G64_FATURA = '"+MV_PAR04+"'
EndIf
_cQuery += "    AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery += "    AND SD2.D_E_L_E_T_ = ' '
_cQuery += "    AND SF4.F4_FILIAL = '" + xFilial("SF4") + "'"
_cQuery += "    AND SF4.D_E_L_E_T_ = ' '
_cQuery += "    AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'"
_cQuery += "    AND SA4.D_E_L_E_T_ = ' '
_cQuery += "   GROUP BY G64.G64_TRANSP, SA4.A4_NOME, SD2.D2_TES, SF4.F4_TEXTO
_cQuery += "   ORDER BY TES, CST_FRETE DESC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	xTransp := (_cAlias1)->G64_TRANSP

	oSection1:Init()     
	
	oSection1:Cell("A4_NOME"):SetValue((_cAlias1)->A4_NOME)
	oSection1:Cell("DATAINI"):SetValue((_cAlias1)->DATAINI)
	oSection1:Cell("DATAFIM"):SetValue((_cAlias1)->DATAFIM)
	oSection1:Cell("FATURA"):SetValue((_cAlias1)->FATURA)
	oSection1:Cell("OBS"):SetValue((_cAlias1)->OBS)

	oSection1:PrintLine()
	oReport:SkipLine()   

	Do While !(_cAlias1)->(eof()) .And. (_cAlias1)->G64_TRANSP = xTransp .And. !oReport:Cancel()
 		oReport:IncMeter()
	
		oSection2:Init()
      	
		oSection2:Cell("OPERACAO"):SetValue((_cAlias1)->OPERACAO)
		oSection2:Cell("FAT_LIQ"):SetValue((_cAlias1)->FAT_LIQ)
		oSection2:Cell("FRETE_COB"):SetValue((_cAlias1)->FRETE_COB)
		oSection2:Cell("CST_FRETE"):SetValue((_cAlias1)->CST_FRETE)
		oSection2:Cell("PERC_FRETE"):SetValue((_cAlias1)->PERC_FRETE)
		
		oSection2:PrintLine()
	
		(_cAlias1)->(dbSkip())
		
	EndDo             
	oSection2:Finish()
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)