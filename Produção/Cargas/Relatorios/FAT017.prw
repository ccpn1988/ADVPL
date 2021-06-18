#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "RPTDEF.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT017    บAutor  ณErica Vieites       บ Data ณ  03/09/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de Comiss๕es                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT017()             

Local oReport
Local cPerg := "FAT017"
Private _cAlias	:= GetNextAlias()

//Cria grupo de perguntas

//f001(cPerg) 

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

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
cCpoPer := "A1_VEND"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')     
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')          
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

u_xGPutSx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SA3')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

u_xGPutSx1(cPerg, cItPerg, "Dt Emissใo de:", "Dt Emissใo de:" ,"Dt Emissใo de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


u_xGPutSx1(cPerg, cItPerg, "Dt Emissใo at้:", "Dt Emissใo at้:","Dt Emissใo at้:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return()
/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport
Local oSection1


//Declaracao do relatorio
oReport := TReport():New("FAT017","FAT017 - Relat๓rio de Comiss๕es",cPerg,{|oReport| PrintReport(oReport)},"FAT017 - Relat๓rio de Comiss๕es")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape() 

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SF2")

//Celulas da secao
TRCell():New(oSection1,"C5_VEND2"		,"","C๓digo"+CRLF+"Vendedor"		,,15)
TRCell():New(oSection1,"A3_NOME"		,"","Vendedor"						,,25)
TRCell():New(oSection1,"TIPO"	   		,"","Tipo"			   					,,15)
TRCell():New(oSection1,"F2_DOC"	   		,"","Nota Fiscal"						,,20)
TRCell():New(oSection1,"F2_SERIE"		,"","S้rie"							,,10)
TRCell():New(oSection1,"F2_EMISSAO"	,"","Data"+CRLF+"Emissใo"			,,20)
TRCell():New(oSection1,"C5_CLIENTE"	,"","C๓digo"+CRLF+"Cliente" 	   	,,15)
TRCell():New(oSection1,"C5_LOJACLIE"	,"","Loja"+CRLF+"Cliente" 		 	,,15)
TRCell():New(oSection1,"A1_NOME"		,"","Cliente"							,,60)
TRCell():New(oSection1,"F2_VALBRUT"	,"","Valor "+CRLF+ "Total R$"	   ,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"C5_COMIS2"	   ,"","% "+CRLF+ "Comissใo"			,'@E 999,999.99'	 ,15,,,,,"RIGHT")
TRCell():New(oSection1,"F2_DESCONT"	,"","Valor "+CRLF+ "Comissใo R$" ,"@E 999,999,999.99",25,,,,,"RIGHT")


//Totalizadores
oBreak := TRBreak():New(oSection1,oSection1:Cell("C5_VEND2"),"Subtotal por Vendedor",.F.)

TRFunction():New(oSection1:Cell("F2_VALBRUT"  ),NIL, "SUM",oBreak,,,,.T.,.F.)
TRFunction():New(oSection1:Cell("F2_DESCONT"  ),NIL, "SUM",oBreak,,,,.T.,.F.)

//Faz a impressao do totalizador em linha

oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)



Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cQuery	:= ""
Local _cAlias   := GetNextAlias()

_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(MV_PAR03)

_cQuery := "select sa3.a3_nome "
_cQuery += "     , sc5.c5_vend2 "
_cQuery += "     , sc5.c5_comis2 "
_cQuery += "     , sf2.f2_doc "
_cQuery += "     , sf2.f2_serie "
_cQuery += "     , to_char(to_date(sf2.f2_emissao,'YYYYMMDD'),'DD/MM/YYYY') f2_emissao "
_cQuery += "     , sc5.c5_cliente "
_cQuery += "     , sc5.c5_lojacli "
_cQuery += "     , sa1.a1_nome "
_cQuery += "     , sf2.f2_valbrut "
_cQuery += "     , decode(TRIM(sf2.f2_especie),'RPS','Servi็o','Produto') tipo "
_cQuery += "     , NVL((sf2.f2_valbrut*sc5.c5_comis2)/100,0) F2_DESCONT "
_cQuery += "     from " + RetSqlName("SC5") + "  sc5 "
_cQuery += "     	 INNER JOIN " + RetSqlName("SF2") + " SF2 on sf2.f2_doc = sc5.c5_nota and sf2.f2_serie = sc5.c5_serie and sf2.f2_filial = sc5.c5_filial and sf2.d_e_l_e_t_ <> '*' "
_cQuery += "     	 INNER JOIN " + RetSqlName("SA1") + "  sa1 on sa1.a1_cod = sc5.c5_cliente and sa1.a1_loja = sc5.c5_lojacli and sa1.D_E_L_E_T_ <> '*' "
_cQuery += "     	 INNER JOIN " + RetSqlName("SA3") + " sa3 on sa3.a3_cod = sc5.c5_vend2 and sa3.D_E_L_E_T_ <> '*' "
_cQuery += "         WHERE sc5.c5_vend2 <> ' ' and sc5.d_e_l_e_t_ <> '*' "
_cQuery += "           and SF2.F2_EMISSAO BETWEEN '" + _cParm2 + "' AND '" + _cParm3 + "' "
If !Empty(MV_PAR01)
	_cQuery += " and A3_COD = '"+MV_PAR01+"' "
Endif 
_cQuery += " ORDER BY sa3.a3_nome, decode(TRIM(sf2.f2_especie),'RPS','Servi็o','Produto') "
	
If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cQuery), _cAlias, .F., .T.)
(_cAlias)->(dbGoTop())

Do While !(_cAlias)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()

	oSection1:Init()  

	oSection1:Cell("C5_VEND2"    ):SetValue((_cAlias)->C5_VEND2)
	oSection1:Cell("A3_NOME"     ):SetValue((_cAlias)->A3_NOME)
	oSection1:Cell("TIPO"        ):SetValue((_cAlias)->TIPO)
	oSection1:Cell("F2_DOC"      ):SetValue((_cAlias)->F2_DOC)
	oSection1:Cell("F2_SERIE"    ):SetValue((_cAlias)->F2_SERIE)
	oSection1:Cell("F2_EMISSAO"  ):SetValue((_cAlias)->F2_EMISSAO)
	oSection1:Cell("C5_CLIENTE"  ):SetValue((_cAlias)->C5_CLIENTE)
	oSection1:Cell("C5_LOJACLIE" ):SetValue((_cAlias)->C5_LOJACLIE)	
	oSection1:Cell("A1_NOME"     ):SetValue((_cAlias)->A1_NOME)
	oSection1:Cell("F2_VALBRUT"  ):SetValue((_cAlias)->F2_VALBRUT)
	oSection1:Cell("F2_DESCONT"  ):SetValue((_cAlias)->F2_DESCONT)
	oSection1:Cell("C5_COMIS2"   ):SetValue((_cAlias)->C5_COMIS2)
	
	oSection1:PrintLine()

	(_cAlias)->(dbSkip())		
EndDo

oSection1:Finish()

DbSelectArea(_cAlias)
DbCloseArea()

Return(.t.)
