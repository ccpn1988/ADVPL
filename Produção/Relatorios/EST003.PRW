#include "protheus.ch"
#include "topconn.ch"     



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EST003    ºAutor  ³Helimar Tavares     º Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de Movimentações no Depósito                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Estoque/Custos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EST003()             

Local oReport
Local cPerg := "EST003"

//Cria grupo de perguntas
f001(cPerg)

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport:= ReportDef(cPerg)
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
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatório ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emissão até:", "Dt Emissão até:","Dt Emissão até:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1

//Declaracao do relatorio
oReport := TReport():New("EST003","EST003 - MOVIMENTAÇÕES NO DEPÓSITO",cPerg,{|oReport| PrintReport(oReport)},"EST003 - MOVIMENTAÇÕES NO DEPÓSITO")//,.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 8    		&& 10
oReport:lHeaderVisible := .T. 
//oReport:lDisableOrientation := .T.    
oReport:SetLandScape()

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Movimentacoes","")
                                            
TRCell():New(oSection1,"TIPO"			,"","TIPO",,5)
TRCell():New(oSection1,"IDNATUREZAOP"	,"","ID TES",,15,,,,,"RIGHT")
TRCell():New(oSection1,"TXNATUREZAOP"	,"","TES",,30)
/*
IF oSection1:Cell("TIPO") = "E"
	TRCell():New(oSection1,"TXNATUREZAOP"	,"","TES (ENTRADAS)",,30)
ELSE
	TRCell():New(oSection1,"TXNATUREZAOP"	,"","TES (SAÍDAS)",,30)
END IF
*/
TRCell():New(oSection1,"QTDPED"			,"","QTDE NOTAS",'@E 9,999,999',15,,,,,"RIGHT")
TRCell():New(oSection1,"LIQUIDO"		,"","VLR LIQUIDO",'@E 999,999,999.99',18,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEXEMP"		,"","#EXEMPLARES",'@E 9,999,999',15,,,,,"RIGHT")
TRCell():New(oSection1,"QTDPED_AA"		,"","QTDE NOTAS AA",'@E 9,999,999',15,,,,,"RIGHT")
TRCell():New(oSection1,"LIQUIDO_AA"		,"","VLR LIQUIDO AA",'@E 999,999,999.99',18,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEXEMP_AA"	,"","#EXEMPLARES AA",'@E 9,999,999',15,,,,,"RIGHT")

oBreak := TRBreak():New(oSection1,oSection1:Cell("TIPO"),"Subtotal")

//Totalizadores
TRFunction():New(oSection1:Cell("QTDPED")		,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("LIQUIDO")		,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1) 
TRFunction():New(oSection1:Cell("QTDEXEMP")		,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1)     
TRFunction():New(oSection1:Cell("QTDPED_AA")	,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("LIQUIDO_AA")	,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1) 
TRFunction():New(oSection1:Cell("QTDEXEMP_AA")	,,"SUM",oBreak,,,,.F.,.T.,.F.,oSection1)     

//Faz a impressao do totalizador em linha

oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cQuery	:= ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(YEARSUB(MV_PAR01, 1))
_cParm4 := DTOS(YEARSUB(MV_PAR02, 1))

_cQuery := "	SELECT 'E' TIPO
_cQuery += "	     , IDNATUREZAOP
_cQuery += "	     , TXNATUREZAOP
_cQuery += "	     , SUM(QTDEPEDIDO) QTDPED
_cQuery += "	     , SUM(LIQUIDO) LIQUIDO
_cQuery += "	     , SUM(QTDEEXEMPLARES) QTDEXEMP
_cQuery += "	     , SUM(QTDEPEDIDO_AA) QTDPED_AA
_cQuery += "	     , SUM(LIQUIDO_AA) LIQUIDO_AA
_cQuery += "	     , SUM(QTDEEXEMPLARES_AA) QTDEXEMP_AA
_cQuery += "	  FROM (SELECT IDNATUREZAOP
_cQuery += "	             , TRIM(TXNATUREZAOP) TXNATUREZAOP
_cQuery += "	             , COUNT(*) QTDEPEDIDO
_cQuery += "	             , SUM(TOTALLIQUIDO) LIQUIDO
_cQuery += "	             , SUM(TOTALQTDE) QTDEEXEMPLARES
_cQuery += "	             , 0 QTDEPEDIDO_AA
_cQuery += "	             , 0 LIQUIDO_AA
_cQuery += "	             , 0 QTDEEXEMPLARES_AA
_cQuery += "	          FROM GEN_EST013_SITUACAO_EXPEDICAO
_cQuery += "	         WHERE TT_DATA BETWEEN '" +_cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "	         GROUP BY IDNATUREZAOP, TXNATUREZAOP
_cQuery += "	        UNION ALL
_cQuery += "	        SELECT IDNATUREZAOP
_cQuery += "	             , TRIM(TXNATUREZAOP)
_cQuery += "	             , 0
_cQuery += "	             , 0
_cQuery += "	             , 0
_cQuery += "	             , COUNT(*)
_cQuery += "	             , SUM(TOTALLIQUIDO)
_cQuery += "	             , SUM(TOTALQTDE)
_cQuery += "	          FROM GEN_EST013_SITUACAO_EXPEDICAO
_cQuery += "	         WHERE TT_DATA BETWEEN '" +_cParm3 + "' AND '" + _cParm4 + "'"
_cQuery += "	         GROUP BY IDNATUREZAOP, TXNATUREZAOP)
_cQuery += "	 WHERE IDNATUREZAOP NOT IN (14)
_cQuery += "	 GROUP BY IDNATUREZAOP, TXNATUREZAOP
_cQuery += "	UNION ALL
_cQuery += "	SELECT 'S' TIPO
_cQuery += "	     , IDNATUREZAOP
_cQuery += "	     , TXNATUREZAOP
_cQuery += "	     , SUM(QTDEPEDIDO) QTDPED
_cQuery += "	     , SUM(LIQUIDO) LIQUIDO
_cQuery += "	     , SUM(QTDEEXEMPLARES) QTDEXEMP
_cQuery += "	     , SUM(QTDEPEDIDO_AA) QTDPED_AA
_cQuery += "	     , SUM(LIQUIDO_AA) LIQUIDO_AA
_cQuery += "	     , SUM(QTDEEXEMPLARES_AA) QTDEXEMP_AA
_cQuery += "	  FROM (SELECT IDNATUREZAOP
_cQuery += "	             , TRIM(TXNATUREZAOP) TXNATUREZAOP
_cQuery += "	             , COUNT(IDPEDIDO) QTDEPEDIDO
_cQuery += "	             , SUM(TOTALPEDIDO) LIQUIDO
_cQuery += "	             , SUM(TOTALQTDE) QTDEEXEMPLARES
_cQuery += "	             , 0 QTDEPEDIDO_AA
_cQuery += "	             , 0 LIQUIDO_AA
_cQuery += "	             , 0 QTDEEXEMPLARES_AA
_cQuery += "	          FROM TT_R01_SITUACAO_EXPEDICAO2
_cQuery += "	         WHERE TT_DATA BETWEEN '" +_cParm1 + "' AND '" + _cParm2 + "'"
_cQuery += "	           AND EXPEDIDA = 1
_cQuery += "	         GROUP BY IDNATUREZAOP, TXNATUREZAOP
_cQuery += "	        UNION ALL
_cQuery += "	        SELECT IDNATUREZAOP
_cQuery += "	             , TRIM(TXNATUREZAOP)
_cQuery += "	             , 0
_cQuery += "	             , 0
_cQuery += "	             , 0
_cQuery += "	             , COUNT(IDPEDIDO)
_cQuery += "	             , SUM(TOTALPEDIDO)
_cQuery += "	             , SUM(TOTALQTDE)
_cQuery += "	          FROM TT_R01_SITUACAO_EXPEDICAO2
_cQuery += "	         WHERE TT_DATA BETWEEN '" +_cParm3 + "' AND '" + _cParm4 + "'"
_cQuery += "	           AND EXPEDIDA = 1
_cQuery += "	         GROUP BY IDNATUREZAOP, TXNATUREZAOP)
_cQuery += "	 GROUP BY IDNATUREZAOP, TXNATUREZAOP
_cQuery += "	 ORDER BY TIPO, IDNATUREZAOP

If Select(cAlias1) > 0
	dbSelectArea(cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), cAlias1, .F., .T.)

(cAlias1)->(dbGoTop())

Do While !(cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection1:Init()
	
	oSection1:Cell("TIPO"):SetValue((cAlias1)->TIPO)
	oSection1:Cell("IDNATUREZAOP"):SetValue((cAlias1)->IDNATUREZAOP)
	oSection1:Cell("TXNATUREZAOP"):SetValue((cAlias1)->TXNATUREZAOP)
	oSection1:Cell("QTDPED"):SetValue((cAlias1)->QTDPED)
	oSection1:Cell("LIQUIDO"):SetValue((cAlias1)->LIQUIDO)
	oSection1:Cell("QTDEXEMP"):SetValue((cAlias1)->QTDEXEMP)
	oSection1:Cell("QTDPED_AA"):SetValue((cAlias1)->QTDPED_AA)
	oSection1:Cell("LIQUIDO_AA"):SetValue((cAlias1)->LIQUIDO_AA)
	oSection1:Cell("QTDEXEMP_AA"):SetValue((cAlias1)->QTDEXEMP_AA)

	oSection1:PrintLine()
	
	(cAlias1)->(dbSkip())
	
EndDo

oSection1:Finish()
oReport:Finish()                    

DbSelectArea(cAlias1)
DbCloseArea()

Return(.t.)