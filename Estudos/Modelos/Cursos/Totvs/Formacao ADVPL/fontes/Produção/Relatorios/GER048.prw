#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER048    บAutor  ณErica Vieites       บ Data ณ  16/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas Site Por UF                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER048()             

Local oReport
Local cPerg := "GER048"

//Cria grupo de perguntas

f001(cPerg) 

 //Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return   

Static Function f001(cPerg)


Local aHelpPor 	:= {}
Local aHelpEng	:= {""}
Local aHelpSpa	:= {""}
Local cTitPer 	:= "" 

//Cria grupo de perguntas
PutSx1(cPerg, "01", "Data de:", "Data de:" ,"Data de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data at้:", "Data at้:","Data at้:", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Relat๓rio:"     , "Relat๓rio:"     ,"Relat๓rio:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Sint้tico", "Sint้tico", "Sint้tico", "", "Analํtico", "Analํtico", "Analํtico", "", "", "", "", "","", "", "", "", "", "", "", "" )

/*
//---------------------------------------MV_PAR04-------------------------------------------------- 
cCpoPer := "C5_CLIENTE"                	
cTpoCpo := Posicione("SX3",2,cCpoPer,'X3_TIPO')     
cTitPer := Posicione("SX3",2,cCpoPer,'X3_TITULO')     
cF3Perg := Posicione("SX3",2,cCpoPer,'X3_F3')          
nTamPer := TamSx3(cCpoPer)[1]   

aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Caso seja deixado em branco   ")
AADD(aHelpPor,"serao consideradas todas as   ")
AADD(aHelpPor,"opcoes.                       ")


Putsx1(cPerg, "04", cTitPer, cTitPer, cTitPer, "mv_ch4", cTpoCpo,nTamPer,0,0,"G","",cF3Perg,"","","MV_PAR04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Loja do Cliente.    ")


PutSx1(cPerg, "05", "Loja", "Loja","Loja", "mv_ch5" , "C", 2, 0, 0, "G","", "", "", "", "MV_PAR05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
*/
Return



/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("GER048","VENDA SITE POR UF",cPerg,{|oReport| PrintReport(oReport)},"VENDA SITE POR UF")

oReport:NDEVICE := 4

//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao


TRCell():New(oSection1,"A1_EST" 		,"SA1","UF",,5)

if (MV_PAR03 == 2)
TRCell():New(oSection1,"A1_COD"   		,"SA1","C๓digo",,10) 
TRCell():New(oSection1,"A1_LOJA"   		,"SA1","Loja",,6)  
TRCell():New(oSection1,"A1_NOME" 		,"SA1","Cliente",,40)   
TRCell():New(oSection1,"A1_EMAIL" 		,"SA1","E-mail",,30)
TRCell():New(oSection1,"A1_CGC" 		,"SA1","CPF/CNPJ",,30)
TRCell():New(oSection1,"TIPO  " 		," "  ,"Tipo",,8)
TRCell():New(oSection1,"A1_MUN" 		,"SA1","Municํpio",,20)   
TRCell():New(oSection1,"ULTIMA_DATA" 	," "  ,"ฺltima Data",,10)
endif   

TRCell():New(oSection1,"QTDE"	     	," "	,"Qtde"	,'@E 9,999,999'		        ,10,,,,,"RIGHT") 
TRCell():New(oSection1,"D2_VALBRUT"	 	,"SD2"	,"Valor Lํquido",'@E 999,999,999.99',25,,,,,"RIGHT") 

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")      	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")                             

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.F.)
oReport:SetTotalInLine(.F.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()  
Local _cSQL		:= "" 



If oReport:NDEVICE <> 4
	MsgInfo("Este relat๓rio somente poderแ ser impresso em Excel.")
	Return(.t.)
Endif

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
 
/*
If !Empty(MV_PAR04)
	_cSQL += " AND SA1.A1_COD = '"+MV_PAR04+"' 
	_cSQL += " AND SA1.A1_LOJA = '"+MV_PAR05+"'
Endif 

_cSQL := "%" + _cSQL + "%" 

*/
If (MV_PAR03 == 2)
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  
			SELECT SA1.A1_COD A1_COD,SA1.A1_LOJA A1_LOJA, SA1.A1_NOME A1_NOME, SA1.A1_EMAIL A1_EMAIL, SA1.A1_CGC A1_CGC, 
   				   SA1.A1_PESSOA TIPO, SA1.A1_EST A1_EST, SA1.A1_MUN A1_MUN,
       			   NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE,
       			   NVL(SUM(SD2.D2_VALBRUT), 0) D2_VALBRUT, TO_CHAR(TO_DATE(MAX(SD2.D2_EMISSAO),'YYYYMMDD'),'DD/MM/YYYY') ULTIMA_DATA
            FROM TOTVS.SD2000 SD2, TOTVS.SB1000 SB1, TOTVS.SF2000 SF2, TOTVS.SA1000 SA1
      		WHERE SD2.D2_COD = SB1.B1_COD
        		 AND SD2.D2_DOC = SF2.F2_DOC
        		 AND SD2.D2_SERIE = SF2.F2_SERIE
        		 AND SD2.D2_FILIAL = SF2.F2_FILIAL 
        		 AND SF2.F2_CLIENTE = SA1.A1_COD
        		 AND SF2.F2_LOJA    = SA1.A1_LOJA
        		 AND SD2.D2_TES IN ('503','506')
        		 AND SD2.D2_FILIAL  = %xFilial:SD2%
        		 AND SB1.B1_FILIAL  = %xFilial:SB1%
        		 AND SA1.A1_FILIAL  = %xFilial:SA1%
        		 AND SD2.D2_TIPO NOT IN ('D','B')
        		 AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
        		 AND SD2.%notDel%
        		 AND SF2.%notDel%
        		 AND SB1.%notDel%           		 	
      		 GROUP BY SA1.A1_COD,SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_CGC, SA1.A1_PESSOA,SA1.A1_EST, SA1.A1_MUN
		ORDER BY NVL(SUM(SD2.D2_VALBRUT), 0) desc, SA1.A1_NOME
		EndSql			
	End Report Query oSection1    
else
	//Cria query
	Begin Report Query oSection1
		BeginSQL Alias cAlias1  
	   		SELECT  SA1.A1_EST A1_EST, 
       			    NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE,
       			    NVL(SUM(SD2.D2_VALBRUT), 0)D2_VALBRUT
            FROM TOTVS.SD2000 SD2, TOTVS.SB1000 SB1, TOTVS.SF2000 SF2, TOTVS.SA1000 SA1
      		WHERE SD2.D2_COD = SB1.B1_COD
        		 AND SD2.D2_DOC = SF2.F2_DOC
        		 AND SD2.D2_SERIE = SF2.F2_SERIE
        		 AND SD2.D2_FILIAL = SF2.F2_FILIAL 
        		 AND SF2.F2_CLIENTE = SA1.A1_COD
        		 AND SF2.F2_LOJA    = SA1.A1_LOJA
        		 AND SD2.D2_TES IN ('503','506')
        		 AND SD2.D2_FILIAL  = %xFilial:SD2%
        		 AND SB1.B1_FILIAL  = %xFilial:SB1%
        		 AND SA1.A1_FILIAL  = %xFilial:SA1%
        		 AND SD2.D2_TIPO NOT IN ('D','B')
        		 AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
        		 AND SD2.%notDel%
        		 AND SF2.%notDel%
        		 AND SB1.%notDel%
      		 GROUP BY SA1.A1_EST
		ORDER BY NVL(SUM(SD2.D2_VALBRUT), 0) desc, SA1.A1_EST
		EndSql			
	End Report Query oSection1  
Endif

//Efetua impressใo
oSection1:Print()

Return(.t.)