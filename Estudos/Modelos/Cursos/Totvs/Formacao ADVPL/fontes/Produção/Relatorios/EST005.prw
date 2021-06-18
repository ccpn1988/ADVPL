#include "protheus.ch"
#include "topconn.ch"

/*/

DESCRICAO: RELATORIO DE LISTAGEM DE NOTAS FISCAIS

ALTERACOES:
29/12/2016 - Desenvolvimento do fonte

/*/

User Function EST005

Local oReport
Local cPerg := "EST005"

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
AADD(aHelpPor,"Caso seja deixado em branco    ") 
AADD(aHelpPor,"serao consideradas todas as    ")
AADD(aHelpPor,"opcoes.                        ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco    ") 
AADD(aHelpPor,"serao consideradas todas as    ")
AADD(aHelpPor,"opcoes.                        ")


cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:" ,"Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório preenchimento.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Série", "Série","Série", cMVCH , "C", 2, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

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
oReport := TReport():New("EST005","EST005 - LISTAGEM DE NOTAS FISCAIS",cPerg,{|oReport| PrintReport(oReport)},"EST005 - LISTAGEM DE NOTAS FISCAIS")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Notas","")
	
//Celulas da secao
TRCell():New(oSection1,"DOC"			,"SF2","Nota Fiscal",,10)
TRCell():New(oSection1,"SERIE"      	,"SF2","Série",,8)
TRCell():New(oSection1,"EMISSAO"     	,"SF2","Emissão",,20)
TRCell():New(oSection1,"DELETADO"		,"SB1","Deletado",,10)
TRCell():New(oSection1,"TIPO"   		,"   ","Tipo",,15)  
TRCell():New(oSection1,"STATUS"   		,"   ","Status",,45)
                      
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
_cParm3 := MV_PAR03 
_cParm4 := SM0->M0_CGC

_cQuery := "SELECT NOTA.DOC, NOTA.SERIE, NOTA.EMISSAO, NOTA.DELETADO, NOTA.TIPO,
_cQuery += "       DECODE(SPED.STATUS,'1','Nfe Recebida','2','NFe Assinada','3','NFe com falha no schema XML','4','NFe transmitida','5','NFe com problemas','6','NFe autorizada','7','Cancelamento',SPED.STATUS) STATUS
_cQuery += "  FROM (SELECT SF2.F2_DOC DOC, SF2.F2_SERIE SERIE, To_Date(SF2.F2_EMISSAO,'YYYYMMDD') EMISSAO,
_cQuery += "               DECODE(SF2.D_E_L_E_T_,' ','N','S') DELETADO, 'SAÍDA' TIPO
_cQuery += "         FROM TOTVS.SF2000 SF2 
_cQuery += "         UNION
_cQuery += "         SELECT SD1.D1_DOC, SD1.D1_SERIE, To_Date(SD1.D1_DTDIGIT,'YYYYMMDD'),
_cQuery += "                DECODE(SD1.D_E_L_E_T_,' ','N','S'), 'ENTRADA'
_cQuery += "          FROM TOTVS.SD1000 SD1 WHERE SD1.D1_FORMUL = 'S') NOTA 
_cQuery += "     INNER JOIN TOTVS.SPED001 SPED001 ON  SPED001.D_E_L_E_T_ = ' ' AND CNPJ = '" + _cParm4 + "'  
_cQuery += "     LEFT JOIN TOTVS.SPED050 SPED ON SPED001.ID_ENT = SPED.ID_ENT AND TRIM(NOTA.SERIE||NOTA.DOC) = TRIM(SPED.NFE_ID)
_cQuery += "  WHERE SERIE = '" + _cParm3 + "'

If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	_cQuery += "   AND EMISSAO BETWEEN  '" + _cParm1 + "' AND '" + _cParm2 + "'"
EndIf

_cQuery += " ORDER BY NOTA.DOC

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oSection1:Init()  

      	
	oSection1:Cell("DOC"):SetValue((_cAlias1)->DOC)
	oSection1:Cell("SERIE"):SetValue((_cAlias1)->SERIE)
	oSection1:Cell("EMISSAO"):SetValue((_cAlias1)->EMISSAO)
	oSection1:Cell("DELETADO"):SetValue((_cAlias1)->DELETADO)
	oSection1:Cell("TIPO"):SetValue((_cAlias1)->TIPO)
    oSection1:Cell("STATUS"):SetValue((_cAlias1)->STATUS)
	
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()

DbSelectArea(_cAlias1)
DbCloseArea()

Return(.t.)