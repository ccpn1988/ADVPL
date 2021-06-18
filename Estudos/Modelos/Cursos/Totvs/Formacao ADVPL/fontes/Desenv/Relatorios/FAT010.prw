#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT010    บAutor  ณErica Vieites       บ Data ณ  15/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Situa็ใo de Expedi็ใo                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT010()             

Local oReport
Local cPerg := "FAT010"


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
cCpoPer := "A1_XCODOLD" //"C5_CLIENTE"                	
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------  
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissใo de:", "Dt Emissใo de:" ,"Dt Emissใo de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emissใo at้:", "Dt Emissใo at้:","Dt Emissใo at้:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport


//Declaracao do relatorio
oReport := TReport():New("FAT010","SITUAวรO DE EXPEDIวรO",cPerg,{|oReport| PrintReport(oReport)},"SITUAวรO DE EXPEDIวรO",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"D04_NR_ROMANEIO"   ,"","ID" +CRLF+"ROMANEIO",,15)
TRCell():New(oSection1,"TXSTATUSROMANEIO"  ,"","STATUS" +CRLF+"ROMANEIO",,15)
TRCell():New(oSection1,"IDPEDIDO"		    ,"","PEDIDO" +CRLF+"PROTHEUS",,15)
TRCell():New(oSection1,"IDPEDIDOWEB"		,"","PEDIDO" +CRLF+"WEB",,13)
TRCell():New(oSection1,"IDPEDIDOCLI"		,"","PEDIDO" +CRLF+"CLIENTE",,13)// Erica Imolene Vivaz 29711      
TRCell():New(oSection1,"DATAPEDIDO"	    	,"","DATA" +CRLF+"PEDIDO",,23)  
TRCell():New(oSection1,"TXNATUREZAOP"	 	,"","TES",,35) 
TRCell():New(oSection1,"FRETE"	 	        ,"","FRETE",,10) 
TRCell():New(oSection1,"CODCLIENTE"	     	,"","CODIGO" +CRLF+"CLIENTE",,15) 
TRCell():New(oSection1,"LOJACLI"	     	,"","LOJA",,5) 
TRCell():New(oSection1,"TXCLIENTE"	     	,"","CLIENTE",,35) 
TRCell():New(oSection1,"QNTEXEMPLARES"	 	,"","QTDE",'@E 999,999',10,,,,,"RIGHT") 
TRCell():New(oSection1,"D2_VALBRUT"	 	    ,"SD2","TOTAL",'@E 999,999.99',22) 
TRCell():New(oSection1,"NFFORMULARIO"	 	,"","NF",,20)
TRCell():New(oSection1,"DATANF"	        	,"","DATA" +CRLF+"NF",,23) 
TRCell():New(oSection1,"DATAROMANEIO"      	,"","DATA" +CRLF+"ROMANEIO",,23) 
TRCell():New(oSection1,"CHAVENFE"	        ,"","DANFE",,35)
TRCell():New(oSection1,"TXTRANSPORTADORA"  	,"","TRANP.",,35) 
TRCell():New(oSection1,"QTDEVOLUME"	 	    ,"","QTDE" +CRLF+"VOLUME",,5,,,,,"RIGHT") 
TRCell():New(oSection1,"PESOBRUTO"	 	    ,"","PESO",'@E 9,999.99',15,,,,,"RIGHT") 


//Totalizadores
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("QNTEXEMPLARES"),NIL,"SUM")
TRFunction():New(oSection1:Cell("QTDEVOLUME")   ,NIL,"SUM")
TRFunction():New(oSection1:Cell("PESOBRUTO")    ,NIL,"SUM")

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)


Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cSQL		:= ""   					//Filtros variแveis da query

oReport:SetLandScape()

_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(MV_PAR03)


//Monta filtros da query
//mv_par01 - A1_VEND
If !Empty(MV_PAR01)
	_cSQL += " AND IDCLIENTE = "+MV_PAR01
Endif 

_cSQL := "%" + _cSQL + "%" 

  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
    %noparser%
    COLUMN DATANF AS DATE
    
	SELECT TXSTATUSROMANEIO
  	 	 , DATAPEDIDO
     	 , IDPEDIDO
     	 , IDPEDIDOCLI
     	 , CASE WHEN FRETE = 1 THEN 'CIF' ELSE 'FOB' END FRETE
     	 , TOTALPEDIDO D2_VALBRUT
         , TOTALQTDE QNTEXEMPLARES
     	 , IDPEDIDOWEB
     	 , NFFORMULARIO
     	 , DATANF        
     	 , DATAROMANEIO
     	 , TXNATUREZAOP  
     	 , CODCLIENTE
     	 , LOJACLI
     	 , TXCLIENTE 
     	 , TXTRANSPORTADORA
     	 , CHAVENFE
     	 , NVL((D04_NR_ROMANEIO),0) D04_NR_ROMANEIO   
     	 , QTDEVOLUME
     	 , PESOBRUTO 	 
  	FROM DBA_EGK.TT_R01_SITUACAO_EXPEDICAO
 	WHERE DATANF BETWEEN %Exp:_cParm2% AND %Exp:_cParm3%
   	  AND EXPEDIDA = 0 %exp:_cSQL%
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)
