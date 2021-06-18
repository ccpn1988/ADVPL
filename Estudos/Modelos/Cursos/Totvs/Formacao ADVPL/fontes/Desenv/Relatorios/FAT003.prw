#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FAT001    ºAutor  ³Erica Vieites       º Data ³  05/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Vendas Dia                                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³GEN - Faturamento                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FAT003()             

Local oReport
Local cPerg := "FAT003"

Local cItPerg	:= "00"
Local cMVCH 	:= "MV_CH0"
Local cMVPAR 	:= 'MV_PAR00"
Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= ""     

Private _cParm1
Private _cParm2
Private _cParm3
Private _cParm4
Private _cParm5
Private _cParm6
Private _cParm7
Private _cParm8
Private _cParm9
Private _cParm10
Private _cParm11
Private _cParm12
Private _cParm13
Private _cParm14
Private _cParm15
Private _cParm16
Private _cParm17

//Cria grupo de perguntas
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

//---------------------------------------MV_PAR03--------------------------------------------------  
cCpoPer := "Z7_AREA"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := "Área ?"	//Posicione("SX3",2,cCpoPer,'X3_TITULO')
cF3Perg := "SZ7"	//Posicione("SX3",2,cCpoPer,'X3_F3')
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SZ7')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return
   
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport          

xMes  := MESEXTENSO(MONTHSUB(MV_PAR01,1))
If  MONTH(MV_PAR01) = 1
	xAno1 := YEAR2STR(YEARSUB(MV_PAR01,1))
	xAno2 := YEAR2STR(YEARSUB(MV_PAR01,2))
Else
	xAno1 := YEAR2STR(MV_PAR01)
	xAno2 := YEAR2STR(YEARSUB(MV_PAR01,1))
EndIf
xAno3 := YEAR2STR(MV_PAR01)
xAno4 := YEAR2STR(YEARSUB(MV_PAR01,1))
xArea := ""

If !Empty(MV_PAR03)
	_cAlias := GetNextAlias()
	_cQuery := "SELECT Z7_DESC
	_cQuery += "  FROM " + RetSqlName("SZ7")
	_cQuery += " WHERE Z7_AREA = '"+MV_PAR03+"'
	_cQuery += "   AND Z7_FILIAL  = '" + xFilial("SZ7") + "'"
	_cQuery += "   AND D_E_L_E_T_ = ' '
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias, .F., .T.)
	dbSelectArea(_cAlias)
	dbGoTop()
	Do While !(_cAlias)->(Eof())
		xArea := " - "+UPPER((_cAlias)->Z7_DESC)
		(_cAlias)->(dbSkip())
	Enddo
	fErase(_cAlias)
Endif	

//Declaracao do relatorio
oReport := TReport():New("GER004","GER004 - Faturamento Líq. Diário - Total GEN sem Fórum"+xArea,cPerg,{|oReport| PrintReport(oReport)},"GER004 - Faturamento Líq. Diário - Total GEN sem Fórum"+xArea)

//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetPortrait()    
//oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,NIL,"SD2")
oSection2 := TRSection():New(oReport,"COMPARATIVOS DE PERFORMANCE MENSAL","SD2")
oSection3 := TRSection():New(oReport,"COMPARATIVOS DE PERFORMANCE ANUAL ATÉ O ÚLTIMO MÊS (FECHADO)","SD2")
oSection4 := TRSection():New(oReport,"COMPARATIVOS DE PERFORMANCE ANUAL ATÉ O ÚLTIMO DIA","SD2")
oSection5 := TRSection():New(oReport,"COMPARATIVOS DE PERFORMANCE MENSAL POR ÁREA","SD2")
oSection6 := TRSection():New(oReport,"COMPARATIVOS DE PERFORMANCE ANUAL ATÉ O ÚLTIMO DIA POR ÁREA","SD2")

//Celulas da secao 1
TRCell():New(oSection1,"EMISSAO"	,"",CRLF+"Emissão",,20)
TRCell():New(oSection1,"QTDEPROD"	,"","Qtde"+CRLF+"Produtos",'@E 9,999,999',10,,,,,"RIGHT")
TRCell():New(oSection1,"VALORPROD"	,"","Valor (R$)"+CRLF+"Produtos",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection1,"NOTASERV"	,"","#Notas"+CRLF+"Serviços",'@E 9,999,999',10,,,,,"RIGHT")
TRCell():New(oSection1,"VALORSERV"	,"","Valor (R$)"+CRLF+"Serviços",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection1,"VALORTOTAL"	,"","Valor (R$)"+CRLF+"Total",'@E 999,999,999.99',15,,,,,"RIGHT")

//Totalizadores
TRFunction():New(oSection1:Cell("EMISSAO")	 ,NIL,"COUNT",,,,,.T.,.F.,.F.)
TRFunction():New(oSection1:Cell("QTDEPROD")	 ,NIL,"SUM"  ,,,,,.T.,.F.,.F.)
TRFunction():New(oSection1:Cell("VALORPROD") ,NIL,"SUM"  ,,,,,.T.,.F.,.F.)
TRFunction():New(oSection1:Cell("NOTASERV")	 ,NIL,"SUM"  ,,,,,.T.,.F.,.F.)
TRFunction():New(oSection1:Cell("VALORSERV") ,NIL,"SUM"  ,,,,,.T.,.F.,.F.)                                
TRFunction():New(oSection1:Cell("VALORTOTAL"),NIL,"SUM"  ,,,,,.T.,.F.,.F.)

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.F.)       

//Celulas da secao 2
TRCell():New(oSection2,"DESCRICAO"	,"","",,20)
TRCell():New(oSection2,"PROJETADO"	,"",CRLF+"Projetado (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"MESANOANT"	,"","Mês/Ano"+CRLF+"Anterior (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection2,"PERC_AA"   	,"",CRLF+"%",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection2,"META"	 	,"",CRLF+"Meta (R$)",'@E 999,999,999.99',15,,,,,"RIGHT") 
TRCell():New(oSection2,"PERC_META"	,"",CRLF+"% Meta",'@E 9,999.99',10,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection2:Cell("PROJETADO"),"TPROJETADO2","SUM"    ,,,,,.T.,.F.,.T.)
TRFunction():New(oSection2:Cell("MESANOANT"),"TMESANOANT2","SUM"    ,,,,,.T.,.F.,.T.)
TRFunction():New(oSection2:Cell("PERC_AA")	,"TPERC_AA2"  ,"ONPRINT",,,,,.T.,.F.,.T.)
TRFunction():New(oSection2:Cell("META")		,"TMETA2"	  ,"SUM"    ,,,,,.T.,.F.,.T.)
TRFunction():New(oSection2:Cell("PERC_META"),"TPERC_META2","ONPRINT",,,,,.T.,.F.,.T.)

oReport:GetFunction("TPERC_AA2"  ):SetFormula({||(oReport:GetFunction("TPROJETADO2"):uLastValue/oReport:GetFunction("TMESANOANT2"):uLastValue)*100})
oReport:GetFunction("TPERC_META2"):SetFormula({||(oReport:GetFunction("TPROJETADO2"):uLastValue/oReport:GetFunction("TMETA2"):uLastValue)*100})

//Faz a impressao do totalizador em linha
oSection2:SetTotalInLine(.F.)       

//Celulas da secao 3
TRCell():New(oSection3,"DESCRICAO"	,"","",,20)
TRCell():New(oSection3,"PROJETADO"	,"","Até "+xMes+CRLF+xAno1+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection3,"MESANOANT"	,"","Até "+xMes+CRLF+xAno2+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection3,"PERC_AA"   	,"",CRLF+"%",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection3,"META"	 	,"",CRLF+"Meta (R$)",'@E 999,999,999.99',15,,,,,"RIGHT") 
TRCell():New(oSection3,"PERC_META"	,"",CRLF+"% Meta",'@E 9,999.99',10,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection3:Cell("PROJETADO"),"TPROJETADO3","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection3:Cell("MESANOANT"),"TMESANOANT3","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection3:Cell("PERC_AA")	,"TPERC_AA3"  ,"ONPRINT",,,,,.T.,.F.,.T.)
TRFunction():New(oSection3:Cell("META")		,"TMETA3"	  ,"SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection3:Cell("PERC_META"),"TPERC_META3","ONPRINT",,,,,.T.,.F.,.T.)

oReport:GetFunction("TPERC_AA3"  ):SetFormula({||(oReport:GetFunction("TPROJETADO3"):uLastValue/oReport:GetFunction("TMESANOANT3"):uLastValue)*100})
oReport:GetFunction("TPERC_META3"):SetFormula({||(oReport:GetFunction("TPROJETADO3"):uLastValue/oReport:GetFunction("TMETA3"):uLastValue)*100})

//Faz a impressao do totalizador em linha
oSection3:SetTotalInLine(.F.)       

//Celulas da secao 4
TRCell():New(oSection4,"DESCRICAO"	,"","",,20)
TRCell():New(oSection4,"PROJETADO"	,"","Até a Data"+CRLF+xAno3+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection4,"MESANOANT"	,"","Até a Data"+CRLF+xAno4+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection4,"PERC_AA"   	,"",CRLF+"%",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection4,"META"	 	,"",CRLF+"Meta (R$)",'@E 999,999,999.99',15,,,,,"RIGHT") 
TRCell():New(oSection4,"PERC_META"	,"",CRLF+"% Meta",'@E 9,999.99',10,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection4:Cell("PROJETADO"),"TPROJETADO4","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection4:Cell("MESANOANT"),"TMESANOANT4","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection4:Cell("PERC_AA")	,"TPERC_AA4"  ,"ONPRINT",,,,,.T.,.F.,.T.)
TRFunction():New(oSection4:Cell("META")		,"TMETA4"	  ,"SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection4:Cell("PERC_META"),"TPERC_META4","ONPRINT",,,,,.T.,.F.,.T.)

oReport:GetFunction("TPERC_AA4"  ):SetFormula({||(oReport:GetFunction("TPROJETADO4"):uLastValue/oReport:GetFunction("TMESANOANT4"):uLastValue)*100})
oReport:GetFunction("TPERC_META4"):SetFormula({||(oReport:GetFunction("TPROJETADO4"):uLastValue/oReport:GetFunction("TMETA4"):uLastValue)*100})

//Faz a impressao do totalizador em linha
oSection4:SetTotalInLine(.F.)       

//Celulas da secao 5
TRCell():New(oSection5,"DESCRICAO"	,"","",,20)
TRCell():New(oSection5,"PROJETADO"	,"","Mês/Ano"+CRLF+"Atual (R$)"   ,'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection5,"MESANOANT"	,"","Mês/Ano"+CRLF+"Anterior (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection5,"PERC_AA"   	,"",CRLF+"%",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection5,"META"	 	,"",CRLF+"Meta (R$)",'@E 999,999,999.99',15,,,,,"RIGHT") 
TRCell():New(oSection5,"PERC_META"	,"",CRLF+"% Meta",'@E 9,999.99',10,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection5:Cell("PROJETADO"),"TPROJETADO5","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection5:Cell("MESANOANT"),"TMESANOANT5","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection5:Cell("PERC_AA")	,"TPERC_AA5"  ,"ONPRINT",,,,,.T.,.F.,.T.)
TRFunction():New(oSection5:Cell("META")		,"TMETA5"	  ,"SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection5:Cell("PERC_META"),"TPERC_META5","ONPRINT",,,,,.T.,.F.,.T.)

oReport:GetFunction("TPERC_AA5"  ):SetFormula({||(oReport:GetFunction("TPROJETADO5"):uLastValue/oReport:GetFunction("TMESANOANT5"):uLastValue)*100})
oReport:GetFunction("TPERC_META5"):SetFormula({||(oReport:GetFunction("TPROJETADO5"):uLastValue/oReport:GetFunction("TMETA5"):uLastValue)*100})

//Faz a impressao do totalizador em linha
oSection5:SetTotalInLine(.F.)       

//Celulas da secao 6
TRCell():New(oSection6,"DESCRICAO"	,"","",,20)
TRCell():New(oSection6,"PROJETADO"	,"","Até a Data"+CRLF+xAno3+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection6,"MESANOANT"	,"","Até a Data"+CRLF+xAno4+" (R$)",'@E 999,999,999.99',15,,,,,"RIGHT")
TRCell():New(oSection6,"PERC_AA"   	,"",CRLF+"%",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection6,"META"	 	,"",CRLF+"Meta (R$)",'@E 999,999,999.99',15,,,,,"RIGHT") 
TRCell():New(oSection6,"PERC_META"	,"",CRLF+"% Meta",'@E 9,999.99',10,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection6:Cell("PROJETADO"),"TPROJETADO6","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection6:Cell("MESANOANT"),"TMESANOANT6","SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection6:Cell("PERC_AA")	,"TPERC_AA6"  ,"ONPRINT",,,,,.T.,.F.,.T.)
TRFunction():New(oSection6:Cell("META")		,"TMETA6"	  ,"SUM"	,,,,,.T.,.F.,.T.)
TRFunction():New(oSection6:Cell("PERC_META"),"TPERC_META6","ONPRINT",,,,,.T.,.F.,.T.)

oReport:GetFunction("TPERC_AA6"  ):SetFormula({||(oReport:GetFunction("TPROJETADO6"):uLastValue/oReport:GetFunction("TMESANOANT6"):uLastValue)*100})
oReport:GetFunction("TPERC_META6"):SetFormula({||(oReport:GetFunction("TPROJETADO6"):uLastValue/oReport:GetFunction("TMETA6"):uLastValue)*100})

//Faz a impressao do totalizador em linha
oSection6:SetTotalInLine(.F.)       

oReport:SetTotalInLine(.F.)

Return oReport

/*---------------------------------------------------------------------------------------------------*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local oSection4 := oReport:Section(4)
Local oSection5 := oReport:Section(5)
Local oSection6 := oReport:Section(6)
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cAlias3	:= GetNextAlias()
Local _cAlias4	:= GetNextAlias()
Local _cAlias5	:= GetNextAlias()
Local _cAlias6	:= GetNextAlias()
Local _cQuery	:= ""

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(YEARSUB(MV_PAR01,1))
_cParm4 := DTOS(LASTDATE(YEARSUB(MV_PAR02,1)))
_cParm5 := DTOS(LASTDATE(MV_PAR02))
_cParm6 := SUBSTR(DTOS(FIRSTYDATE(MV_PAR01)),1,6)
_cParm7 := SUBSTR(DTOS(LASTDATE(MONTHSUB(MV_PAR02,1))),1,6)
_cParm8 := SUBSTR(DTOS(FIRSTYDATE(YEARSUB(MV_PAR01,1))),1,6)
_cParm9 := SUBSTR(DTOS(LASTDATE(MONTHSUB(MV_PAR02,13))),1,6)
_cParm10:= DTOS(YEARSUB(MV_PAR02,1))
_cParm11:= SUBSTR(DTOS(YEARSUB(MV_PAR01,1)),1,6)
_cParm12:= DTOS(FIRSTYDATE(MV_PAR01))
_cParm13:= DTOS(LASTDATE(MONTHSUB(MV_PAR02,1)))
_cParm14:= SUBSTR(DTOS(FIRSTYDATE(YEARSUB(MV_PAR01,2))),1,6)
_cParm15:= DTOS(FIRSTYDATE(YEARSUB(MV_PAR01,1)))
_cParm16:= DTOS(FIRSTYDATE(YEARSUB(MV_PAR01,2)))
_cParm17:= DTOS(LASTDATE(MONTHSUB(MV_PAR02,13)))

//Alert(FWArrFilAtu()[03]) -- Empresa logada
 
_cQuery := "SELECT EMISSAO,
_cQuery += "       SUM(DECODE(TIPO,'SV',0,QTDE)) AS QTDEPROD, SUM(DECODE(TIPO,'SV',0,VALOR)) AS VALORPROD,
_cQuery += "       SUM(DECODE(TIPO,'SV',NOTAS,0)) AS NOTASERV, SUM(DECODE(TIPO,'SV',VALOR,0)) AS VALORSERV,
_cQuery += "       NVL(SUM(VALOR),0) AS VALORTOTAL
_cQuery += "  FROM (SELECT SD2.D2_FILIAL FILIAL, SD2.D2_EMISSAO EMISSAO, SB1.B1_TIPO TIPO, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, NVL(SUM(SD2.D2_VALBRUT), 0) VALOR, COUNT(SD2.D2_DOC||SD2.D2_SERIE) NOTAS
_cQuery += "	      FROM GER_SD2 SD2
_cQuery += "          INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "		    ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		   AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "		   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		   AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "          INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "            ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "		   AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "           AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		 WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		   AND SUBSTR(SD2.D2_FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		 GROUP BY SD2.D2_FILIAL, SD2.D2_EMISSAO, SB1.B1_TIPO
_cQuery += "		UNION ALL
_cQuery += "		SELECT SD1.D1_FILIAL FILIAL, SD1.D1_DTDIGIT EMISSAO, SB1.B1_TIPO, NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1), NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1), 0
_cQuery += "		  FROM GER_SD1 SD1
_cQuery += "          INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "		    ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		   AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "		   AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		   AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "          INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "            ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "		   AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "           AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		 WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		   AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'
_cQuery += "		 GROUP BY SD1.D1_FILIAL, SD1.D1_DTDIGIT, SB1.B1_TIPO
_cQuery += "		UNION ALL
_cQuery += "		SELECT MB.FILIAL, MB.EMISSAO, MB.TIPO, 0, SUM(MB.LIQUIDO), MB.NOTAS
_cQuery += "		  FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "          INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "            ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		   AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "           AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "           AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		 WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		   AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		 GROUP BY MB.FILIAL, MB.EMISSAO, MB.TIPO, MB.NOTAS)
_cQuery += " GROUP BY EMISSAO
_cQuery += " ORDER BY EMISSAO
	
If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias1, .F., .T.)

Do While !(_cAlias1)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection1:Init()  

	xEmissao := STOD((_cAlias1)->EMISSAO)

	oSection1:Cell("EMISSAO"   ):SetValue(xEmissao)
	oSection1:Cell("QTDEPROD"  ):SetValue((_cAlias1)->QTDEPROD)
	oSection1:Cell("VALORPROD" ):SetValue((_cAlias1)->VALORPROD)
	oSection1:Cell("NOTASERV"  ):SetValue((_cAlias1)->NOTASERV)
	oSection1:Cell("VALORSERV" ):SetValue((_cAlias1)->VALORSERV)
	oSection1:Cell("VALORTOTAL"):SetValue((_cAlias1)->VALORTOTAL)

	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())		
EndDo
oSection1:Finish()
         
DbSelectArea(_cAlias1)
DbCloseArea()

_cQuery := ""

//Cria query
_cQuery := " SELECT DECODE(F.TIPO,'PA','PRODUTOS','SV','SERVIÇOS') AS DESCRICAO,
_cQuery += "  	    NVL(ROUND((F.LIQUIDO/D.DIATRABALHADO)*D.DIAUTIL,2),0) AS PROJETADO,
_cQuery += "   	    NVL(FAA.LIQUIDO,0) AS MESANOANT,
_cQuery += "  	    NVL(DECODE(FAA.LIQUIDO,0,0,(ROUND((F.LIQUIDO/D.DIATRABALHADO)*D.DIAUTIL,2))/FAA.LIQUIDO*100),0) AS PERC_AA,
_cQuery += "   	    NVL(MD.META,0) AS META,
_cQuery += "   	    NVL(DECODE(MD.META,0,0,(ROUND((F.LIQUIDO/D.DIATRABALHADO)*D.DIAUTIL,2))/MD.META*100),0) AS PERC_META
_cQuery += "   FROM (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "        		    AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) F
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "        		    AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf

_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) FAA
_cQuery += "  	 ON F.TIPO = FAA.TIPO
_cQuery += "  CROSS
_cQuery += "   JOIN (SELECT SUM(DIAUTIL) DIAUTIL, SUM(DIATRABALHADO) DIATRABALHADO
_cQuery += "           FROM (SELECT COUNT(DATA) DIAUTIL, 0 DIATRABALHADO
_cQuery += "                   FROM DBA_EGK.DIAUTIL
_cQuery += "	              WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm1 + "' AND '" + _cParm5 + "'
_cQuery += "                 UNION ALL
_cQuery += "                 SELECT 0, MAX(SEQ)
_cQuery += "                   FROM DBA_EGK.DIAUTIL
_cQuery += "                  WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "' )) D
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPOPRODUTO, SUM(VALOR) META
_cQuery += "           FROM DBA_EGK.GER_TB001_META_AREACRM
_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') = '" + _cParm5 + "'
If !Empty(MV_PAR03)
	_cQuery += "            AND LPAD(IDAREACRM,6,'0') = '"+MV_PAR03+"'
EndIf
_cQuery += "          GROUP BY TIPOPRODUTO) MD ON F.TIPO = MD.TIPOPRODUTO
_cQuery += "  ORDER BY F.TIPO

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias2, .F., .T.)

oReport:SkipLine(2)
oReport:PrintText(Upper(oSection2:CTITLE))
oReport:FatLine()

oSection2:Init()
	
Do While !(_cAlias2)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection2:Cell("DESCRICAO"):SetValue((_cAlias2)->DESCRICAO)
	oSection2:Cell("PROJETADO"):SetValue((_cAlias2)->PROJETADO)
	oSection2:Cell("MESANOANT"):SetValue((_cAlias2)->MESANOANT)
	oSection2:Cell("PERC_AA"):SetValue((_cAlias2)->PERC_AA)
	oSection2:Cell("META"):SetValue((_cAlias2)->META)
	oSection2:Cell("PERC_META"):SetValue((_cAlias2)->PERC_META)

	oSection2:PrintLine()

	(_cAlias2)->(dbSkip())		
EndDo
oSection2:Finish()
         
DbSelectArea(_cAlias2)
DbCloseArea()

_cQuery := ""

//Cria query
_cQuery := " SELECT DECODE(F.TIPO,'PA','PRODUTOS','SV','SERVIÇOS') AS DESCRICAO,
_cQuery += "  	    NVL(F.LIQUIDO,0) AS PROJETADO, NVL(FAA.LIQUIDO,0) AS MESANOANT,
_cQuery += "  	    NVL(DECODE(FAA.LIQUIDO,0,0,F.LIQUIDO/FAA.LIQUIDO*100),0) AS PERC_AA,
_cQuery += "   	    NVL(MD.META,0) AS META,
_cQuery += "   	    NVL(DECODE(MD.META,0,0,F.LIQUIDO/MD.META*100),0) AS PERC_META
_cQuery += "   FROM (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm13 + "'
Else
	_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm13 + "'
EndIf
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm15 + "' AND '" + _cParm13 + "'
Else
	_cQuery += "		          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm12 + "' AND '" + _cParm13 + "'
EndIf
//_cQuery += "        		    AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm13 + "'
Else
	_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm13 + "'
EndIf
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) F
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm16 + "' AND '" + _cParm17 + "'
Else
	_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm17 + "'
EndIf
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm16 + "' AND '" + _cParm17 + "'
Else
	_cQuery += "		          WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm15 + "' AND '" + _cParm17 + "'
EndIf
//_cQuery += "        		    AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm16 + "' AND '" + _cParm17 + "'
Else
	_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm17 + "'
EndIf
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) FAA
_cQuery += "     ON F.TIPO = FAA.TIPO
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPOPRODUTO, SUM(VALOR) META
_cQuery += "           FROM DBA_EGK.GER_TB001_META_AREACRM
If SUBSTR(_cParm1,5,2) = '01'
	_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm15 + "' AND '" + _cParm13 + "'
Else
	_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm12 + "' AND '" + _cParm13 + "'
EndIf
If !Empty(MV_PAR03)
	_cQuery += "            AND LPAD(IDAREACRM,6,'0') = '"+MV_PAR03+"'
EndIf
_cQuery += "          GROUP BY TIPOPRODUTO) MD ON F.TIPO = MD.TIPOPRODUTO
_cQuery += "  ORDER BY F.TIPO

If Select(_cAlias3) > 0
	dbSelectArea(_cAlias3)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias3, .F., .T.)

oReport:SkipLine(2)
oReport:PrintText(Upper(oSection3:cTitle))
oReport:FatLine()

oSection3:Init()
	
Do While !(_cAlias3)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection3:Cell("DESCRICAO"):SetValue((_cAlias3)->DESCRICAO)
	oSection3:Cell("PROJETADO"):SetValue((_cAlias3)->PROJETADO)
	oSection3:Cell("MESANOANT"):SetValue((_cAlias3)->MESANOANT)
	oSection3:Cell("PERC_AA"):SetValue((_cAlias3)->PERC_AA)
	oSection3:Cell("META"):SetValue((_cAlias3)->META)
	oSection3:Cell("PERC_META"):SetValue((_cAlias3)->PERC_META)

	oSection3:PrintLine()

	(_cAlias3)->(dbSkip())		
EndDo
oSection3:Finish()
         
DbSelectArea(_cAlias3)
DbCloseArea()

_cQuery := ""

//Cria query
_cQuery := " SELECT DECODE(F.TIPO,'PA','PRODUTOS','SV','SERVIÇOS') AS DESCRICAO,
_cQuery += "  	    NVL(F.LIQUIDO,0) AS PROJETADO, NVL(FAA.LIQUIDO,0) AS MESANOANT,
_cQuery += "  	    NVL(DECODE(FAA.LIQUIDO,0,0,F.LIQUIDO/FAA.LIQUIDO*100),0) AS PERC_AA,
_cQuery += "   	    NVL(MD.META,0) AS META,
_cQuery += "   	    NVL(DECODE(MD.META,0,0,F.LIQUIDO/MD.META*100),0) AS PERC_META
_cQuery += "   FROM (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) F
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPO, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU <> ' '
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT SB1.B1_TIPO TIPO, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1
_cQuery += "                  	 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON SB1.B1_COD = SB5.B5_COD
	_cQuery += "	        	    AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2) = '" + LEFT(xFilial("SD1"),2) +"'
_cQuery += "  		          GROUP BY SB1.B1_TIPO
_cQuery += "		          UNION ALL
_cQuery += "		         SELECT MB.TIPO, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
If !Empty(MV_PAR03)
	_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5
	_cQuery += "                     ON MB.PRODUTO = SB5.B5_COD
	_cQuery += "		            AND SB5.B5_XAREA = '"+MV_PAR03+"'
	_cQuery += "                    AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
	_cQuery += "                    AND SB5.D_E_L_E_T_ = ' '
EndIf
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		          GROUP BY MB.TIPO)
_cQuery += "  		  GROUP BY TIPO) FAA
_cQuery += "  	 ON F.TIPO = FAA.TIPO
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT TIPOPRODUTO, SUM(VALOR) META
_cQuery += "           FROM DBA_EGK.GER_TB001_META_AREACRM
_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm12 + "' AND '" + _cParm5 + "'
If !Empty(MV_PAR03)
	_cQuery += "            AND LPAD(IDAREACRM,6,'0') = '"+MV_PAR03+"'
EndIf
_cQuery += "          GROUP BY TIPOPRODUTO) MD ON F.TIPO = MD.TIPOPRODUTO
_cQuery += "  ORDER BY F.TIPO
	
If Select(_cAlias4) > 0
	dbSelectArea(_cAlias4)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias4, .F., .T.)

oReport:SkipLine(2)
oReport:PrintText(Upper(oSection4:cTitle))
oReport:FatLine()                                                           

oSection4:Init()
	
Do While !(_cAlias4)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection4:Cell("DESCRICAO"):SetValue((_cAlias4)->DESCRICAO)
	oSection4:Cell("PROJETADO"):SetValue((_cAlias4)->PROJETADO)
	oSection4:Cell("MESANOANT"):SetValue((_cAlias4)->MESANOANT)
	oSection4:Cell("PERC_AA"):SetValue((_cAlias4)->PERC_AA)
	oSection4:Cell("META"):SetValue((_cAlias4)->META)
	oSection4:Cell("PERC_META"):SetValue((_cAlias4)->PERC_META)

	oSection4:PrintLine()

	(_cAlias4)->(dbSkip())		
EndDo
oSection4:Finish()
         
DbSelectArea(_cAlias4)
DbCloseArea()

_cQuery := ""

//Cria query
_cQuery := " SELECT NVL(SZ7.Z7_DESC,'*** Sem Área ***') AS DESCRICAO, NVL(F.LIQUIDO,0) AS PROJETADO, NVL(FAA.LIQUIDO,0) AS MESANOANT,
_cQuery += "  	    NVL(DECODE(FAA.LIQUIDO,0,0,F.LIQUIDO/FAA.LIQUIDO*100),0) AS PERC_AA,
_cQuery += "   	    NVL(MD.META,0) AS META,
_cQuery += "   	    NVL(DECODE(MD.META,0,0,F.LIQUIDO/MD.META*100),0) AS PERC_META
_cQuery += "   FROM (SELECT AREA, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB5.B5_XAREA AREA, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "		         UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'
_cQuery += "        		    AND SB1.B1_FILIAL  = '" + LEFT(xFilial("SB1"),2) + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "        		    AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "                 UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm1 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "		          GROUP BY SB5.B5_XAREA)
_cQuery += "         GROUP BY AREA) F
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT AREA, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB5.B5_XAREA AREA, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "		         UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'
_cQuery += "        		    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "        		    AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "                 UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm3 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "		          GROUP BY SB5.B5_XAREA)
_cQuery += "         GROUP BY AREA) FAA ON F.AREA = FAA.AREA
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT LPAD(IDAREACRM,6,'0') AREA, SUM(VALOR) META
_cQuery += "           FROM DBA_EGK.GER_TB001_META_AREACRM
_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') = '" + _cParm5 + "'
_cQuery += "          GROUP BY IDAREACRM) MD ON F.AREA = MD.AREA
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT Z7_AREA, Z7_DESC
_cQuery += "           FROM " + RetSqlName("SZ7")
_cQuery += "          WHERE Z7_FILIAL = '" + xFilial("SZ7") + "'
_cQuery += "            AND D_E_L_E_T_ = ' ') SZ7 ON F.AREA = SZ7.Z7_AREA
_cQuery += "  ORDER BY F.LIQUIDO DESC

If Select(_cAlias5) > 0
	dbSelectArea(_cAlias5)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias5, .F., .T.)

oReport:SkipLine(2)
oReport:PrintText(Upper(oSection5:cTitle))
oReport:FatLine()

oSection5:Init()

Do While !(_cAlias5)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection5:Cell("DESCRICAO"):SetValue((_cAlias5)->DESCRICAO)
	oSection5:Cell("PROJETADO"):SetValue((_cAlias5)->PROJETADO)
	oSection5:Cell("MESANOANT"):SetValue((_cAlias5)->MESANOANT)
	oSection5:Cell("PERC_AA"):SetValue((_cAlias5)->PERC_AA)
	oSection5:Cell("META"):SetValue((_cAlias5)->META)
	oSection5:Cell("PERC_META"):SetValue((_cAlias5)->PERC_META)

	oSection5:PrintLine()

	(_cAlias5)->(dbSkip())
EndDo
oSection5:Finish()
         
DbSelectArea(_cAlias5)
DbCloseArea()

_cQuery := ""

//Cria query
_cQuery := " SELECT NVL(SZ7.Z7_DESC,'*** Sem Área ***') AS DESCRICAO, NVL(F.LIQUIDO,0) AS PROJETADO, NVL(FAA.LIQUIDO,0) AS MESANOANT,
_cQuery += "  	    NVL(DECODE(FAA.LIQUIDO,0,0,F.LIQUIDO/FAA.LIQUIDO*100),0) AS PERC_AA,
_cQuery += "   	    NVL(MD.META,0) AS META,
_cQuery += "   	    NVL(DECODE(MD.META,0,0,F.LIQUIDO/MD.META*100),0) AS PERC_META
_cQuery += "   FROM (SELECT AREA, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB5.B5_XAREA AREA, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "		         UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'
_cQuery += "        		    AND SB1.B1_FILIAL  = '" + LEFT(xFilial("SB1"),2) + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "        		    AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "                 UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm12 + "' AND '" + _cParm2 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "		          GROUP BY SB5.B5_XAREA)
_cQuery += "         GROUP BY AREA) F
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT AREA, SUM(LIQUIDO) LIQUIDO
_cQuery += "           FROM (SELECT SB5.B5_XAREA AREA, NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
_cQuery += "                   FROM GER_SD2 SD2
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD2.D2_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "		          WHERE SD2.D2_EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD2.D2_FILIAL,1,2) = '" + LEFT(xFilial("SD2"),2) +"'
_cQuery += "	   	            AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "  		            AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "		         UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1)
_cQuery += "		           FROM GER_SD1 SD1
_cQuery += "                  INNER JOIN " + RetSqlName("SB1") + " SB1 ON SD1.D1_COD = SB1.B1_COD
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD
_cQuery += "        		  WHERE SD1.D1_DTDIGIT BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(SD1.D1_FILIAL,1,2)  = '" + LEFT(xFilial("SD1"),2) + "'
_cQuery += "        		    AND SB1.B1_FILIAL  = '" + xFilial("SB1") + "'
_cQuery += "		            AND SB1.B1_XIDTPPU NOT IN (' ','15')
_cQuery += "        		    AND SB1.D_E_L_E_T_ = ' '
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "  		          GROUP BY SB5.B5_XAREA
_cQuery += "                 UNION ALL
_cQuery += "		         SELECT SB5.B5_XAREA, NVL(SUM(MB.LIQUIDO),0)
_cQuery += "		           FROM GER_MB MB
_cQuery += "                  INNER JOIN " + RetSqlName("SB5") + " SB5 ON MB.PRODUTO = SB5.B5_COD
_cQuery += "		          WHERE MB.EMISSAO BETWEEN '" + _cParm15 + "' AND '" + _cParm4 + "'
//_cQuery += "		            AND SUBSTR(MB.FILIAL,1,2)  = '" + LEFT(xFilial("SD2"),2) + "'
_cQuery += "		            AND SB5.B5_FILIAL  = '" + xFilial("SB5") + "'
_cQuery += "   		            AND SB5.D_E_L_E_T_ = ' '
_cQuery += "		          GROUP BY SB5.B5_XAREA)
_cQuery += "         GROUP BY AREA) FAA ON F.AREA = FAA.AREA
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT LPAD(IDAREACRM,6,'0') AREA, SUM(VALOR) META
_cQuery += "           FROM DBA_EGK.GER_TB001_META_AREACRM
_cQuery += "          WHERE TO_CHAR(DATA, 'YYYYMMDD') BETWEEN '" + _cParm12 + "' AND '" + _cParm5 + "'
_cQuery += "          GROUP BY IDAREACRM) MD ON F.AREA = MD.AREA
_cQuery += "   LEFT
_cQuery += "   JOIN (SELECT Z7_AREA, Z7_DESC
_cQuery += "           FROM " + RetSqlName("SZ7")
_cQuery += "          WHERE Z7_FILIAL = '" + xFilial("SZ7") + "'
_cQuery += "            AND D_E_L_E_T_ = ' ') SZ7 ON F.AREA = SZ7.Z7_AREA
_cQuery += "  ORDER BY F.LIQUIDO DESC

If Select(_cAlias6) > 0
	dbSelectArea(_cAlias6)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias6, .F., .T.)

oReport:SkipLine(2)
oReport:PrintText(Upper(oSection6:cTitle))
oReport:FatLine()

oSection6:Init()

Do While !(_cAlias6)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection6:Cell("DESCRICAO"):SetValue((_cAlias6)->DESCRICAO)
	oSection6:Cell("PROJETADO"):SetValue((_cAlias6)->PROJETADO)
	oSection6:Cell("MESANOANT"):SetValue((_cAlias6)->MESANOANT)
	oSection6:Cell("PERC_AA"):SetValue((_cAlias6)->PERC_AA)
	oSection6:Cell("META"):SetValue((_cAlias6)->META)
	oSection6:Cell("PERC_META"):SetValue((_cAlias6)->PERC_META)

	oSection6:PrintLine()

	(_cAlias6)->(dbSkip())
EndDo
oSection6:Finish()
         
DbSelectArea(_cAlias6)
DbCloseArea()

Return(.t.)