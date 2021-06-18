#include "protheus.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GER058    �Autor  �Erica Vieites       � Data �  16/04/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio de Expedi��o Vendas Site e Ofertas                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GEN - Gerencial                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GER058()             

Local oReport
Local cPerg := "GER058"


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
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emiss�o de:", "Dt Emiss�o de:" ,"Dt Emiss�o de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))


PutSx1(cPerg, cItPerg, "Dt Emiss�o at�:", "Dt Emiss�o at�:","Dt Emiss�o at�:", cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------

PutSX1(cPerg, "03", "Relat�rio:"          , "Relat�rio:"     ,"Relat�rio:"    , "mv_ch3" , "C", 1, 0, 1, "C","", "", "", "", "MV_PAR03", "Anal�tico", "Anal�tico", "Anal�tico", "", "Sint�tico", "Sint�tico", "Sint�tico", "", "", "", "", "","", "", "", "", "", "", "", "" )

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"n�o obrigatorio.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Cod.Transportadora:"	, ".", ".",cMVCH,"C",TamSx3("A4_COD")[1]		, 0, 0, "G","", "SA4", 	"", "", cMVPAR,"","","","","","","","","","","","","","","","")

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
If (MV_PAR03 == 2)
	oReport := TReport():New("GER058","EXPEDI��O VENDAS SITE E OFERTAS(SINT�TICO)",cPerg,{|oReport| PrintReport(oReport)},"EXPEDI��O VENDAS SITE E OFERTAS(SINT�TICO)",.T.)
else
	oReport := TReport():New("GER058","EXPEDI��O VENDAS SITE E OFERTAS(ANAL�TICO)",cPerg,{|oReport| PrintReport(oReport)},"EXPEDI��O VENDAS SITE E OFERTAS(ANAL�TICO)",.T.)
Endif        

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 7    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")
If (MV_PAR03 == 1)
//Celulas da secao
TRCell():New(oSection1,"D04_NR_ROMANEIO"   ,"","ID" +CRLF+"ROMANEIO",,15,,,,,"RIGHT")  
TRCell():New(oSection1,"CODCLIENTE"	     	,"","CODIGO" +CRLF+"CLIENTE",,15) 
TRCell():New(oSection1,"LOJACLI"	     	,"","LOJA" +CRLF+"CLI",,5) 
TRCell():New(oSection1,"TXCLIENTE"	     	,"","CLIENTE",,20) 
TRCell():New(oSection1,"CIDADE"	        	,"","CIDADE",,15)
TRCell():New(oSection1,"TXUF"            	,"","UF",,8)  
TRCell():New(oSection1,"CEP"	           	,"","CEP",,10)
TRCell():New(oSection1,"IDPEDIDO"		    ,"","ID" +CRLF+"PEDIDO",,10,,,,,"RIGHT")
TRCell():New(oSection1,"IDPEDIDOWEB"		,"","PEDIDO" +CRLF+"WEB",,15,,,,,"RIGHT")
TRCell():New(oSection1,"DATAPEDIDO"	    	,"","DATA" +CRLF+"PEDIDO",,20)  
TRCell():New(oSection1,"VL_FRETE"	 	    ,"","FRETE",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection1,"D2_VALBRUT"	 	    ,"SD2","TOTAL",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection1,"QNTEXEMPLARES"	 	,"","#EXEMP.",'@E 9,999',7,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEVOLUME"	 	    ,"","QTDE" +CRLF+"VOLUME",,5,,,,,"RIGHT") 
TRCell():New(oSection1,"PESOBRUTO"	 	    ,"","PESO",'@E 9,999.99',10,,,,,"RIGHT") 
TRCell():New(oSection1,"TXNATUREZAOP"	 	,"","TES",,30) 
TRCell():New(oSection1,"NFFORMULARIO"	 	,"","NF",,25)
TRCell():New(oSection1,"EMISSAONOTA"	 	,"","EMISS�O"+CRLF+"NF",,25)
TRCell():New(oSection1,"CODIGORASTREAMENTO","","COD." +CRLF+"RASTR.",,30,,,,,"RIGHT") 
TRCell():New(oSection1,"PLACA"	     	    ,"","PLACA",,15)  
TRCell():New(oSection1,"MOTORISTA"	        ,"","MOTORISTA",,15)
TRCell():New(oSection1,"TXTRANSPORTADORA"  	,"","TRANSP.",,35) 


//Totalizadores
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("QNTEXEMPLARES"),NIL,"SUM") 
TRFunction():New(oSection1:Cell("QTDEVOLUME")   ,NIL,"SUM")                                   
TRFunction():New(oSection1:Cell("PESOBRUTO")    ,NIL,"SUM")                                   

else

TRCell():New(oSection1,"IDNATUREZAOP"	 	,"","ID TES",,15,,,,,"RIGHT")
TRCell():New(oSection1,"TXNATUREZAOP"	 	,"","TES",,30)
TRCell():New(oSection1,"QTDEPEDIDO"		    ,"","QTDE PEDIDO",'@E 9,999,999',15,,,,,"RIGHT")
TRCell():New(oSection1,"D2_VALBRUT"	 	    ,"SD2","TOTAL",,20) 
TRCell():New(oSection1,"QNTEXEMPLARES"	 	,"","#EXEMP.",'@E 9,999,999',15,,,,,"RIGHT")
TRCell():New(oSection1,"QTDEVOLUME"	 	    ,"","QTDE VOLUME",'@E 9,999,999',10,,,,,"RIGHT") 


//Totalizadores
TRFunction():New(oSection1:Cell("D2_VALBRUT")	  ,NIL,"SUM")
TRFunction():New(oSection1:Cell("QNTEXEMPLARES") ,NIL,"SUM") 
TRFunction():New(oSection1:Cell("QTDEVOLUME")    ,NIL,"SUM")     

Endif  


//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)


Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cSQL		:= ""   					//Filtros vari�veis da query
Local lPlanilha := oReport:nDevice == 4
Local cWhere  := "% %"
oReport:SetLandScape()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)

IF !Empty(MV_PAR04)
  cWhere  := "% AND IDTRANSPORTADORA = "+cValToChar(Val(MV_PAR04))+" %"
ENDIF

If (MV_PAR03 == 1) 
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1    
	

SELECT  TO_DATE(SE.DATANF,'YYYYMMDD') EMISSAONOTA
      , SE.DATAHORAEXPEDICAO DATAHORAEXPEDICAO
      , TO_CHAR(SE.DATAPEDIDO,'DD/MM/YYYY') DATAPEDIDO
      , SE.IDPEDIDO
      , SE.TOTALPEDIDO D2_VALBRUT
      , SE.CODCLIENTE
      , SE.LOJACLI
      , SE.TOTALQTDE QNTEXEMPLARES
      , SE.IDPEDIDOWEB
      , TRIM(SE.CODIGORASTREAMENTO) CODIGORASTREAMENTO
      , SE.NFFORMULARIO
      , SE.IDNATUREZAOP TES
      , TRIM(SE.TXNATUREZAOP) TXNATUREZAOP
      , TRIM(SE.TXCLIENTE) TXCLIENTE
      , TRIM(SE.TXTRANSPORTADORA) TXTRANSPORTADORA
      , SE.PLACA
      , TRIM(SE.MOTORISTA) MOTORISTA
      , SE.QTDEVOLUME
      , SE.PESOBRUTO
      , TRIM(SE.TXMUNICIPIO) CIDADE
      , TRIM(SE.TXUF) TXUF
      , SE.D04_NR_ROMANEIO 
      , SE.TOTALFRETE VL_FRETE
      , CASE WHEN SA1.A1_CEPE <> ' ' THEN SA1.A1_CEPE ELSE SA1.A1_CEP END CEP
  FROM TT_R01_SITUACAO_EXPEDICAO SE, %table:SA1% SA1
 WHERE SA1.A1_COD = SE.CODCLIENTE   
   AND SA1.A1_LOJA = SE.LOJACLI
   AND SA1.A1_FILIAL = %xFilial:SA1%  
   AND SA1.%notDel%
   AND SE.TT_DATA BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
   AND SE.EXPEDIDA = 1
   /*AND SE.CORREIO = 1*/
   %Exp:cWhere%
 ORDER BY QNTEXEMPLARES, DATANF;
 
 	EndSql			
End Report Query oSection1  

else 

//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
	
 SELECT TXTRANSPORTADORA
      , IDNATUREZAOP
      , TRIM(TXNATUREZAOP) TXNATUREZAOP
      , COUNT(DISTINCT IDPEDIDO) QTDEPEDIDO
      , SUM(TOTALPEDIDO) D2_VALBRUT
      , SUM(TOTALQTDE) QNTEXEMPLARES
      , SUM(QTDEVOLUME) QTDEVOLUME
  FROM TT_R01_SITUACAO_EXPEDICAO
 WHERE TT_DATA  BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
   AND EXPEDIDA = 1
   AND CORREIO = 1
 GROUP BY IDNATUREZAOP, TXNATUREZAOP,IDTRANSPORTADORA,TXTRANSPORTADORA
	
	EndSql			
End Report Query oSection1 

Endif
//Efetua impress�o
	If !lPlanilha
			oSection1:Cell("VL_FRETE"):Disable()
			oSection1:Cell("D2_VALBRUT"):Disable()  
			oSection1:Cell("QNTEXEMPLARES"):Disable() 
			oSection1:Cell("QTDEVOLUME"):Disable()
			oSection1:Cell("PESOBRUTO"):Disable()
			oSection1:Cell("TXNATUREZAOP"):Disable()
			oSection1:Cell("NFFORMULARIO"):Disable() 
			oSection1:Cell("EMISSAONOTA"):Disable()
			oSection1:Cell("CODIGORASTREAMENTO"):Disable()
			oSection1:Cell("PLACA"):Disable()
			oSection1:Cell("MOTORISTA"):Disable()
			oSection1:Cell("TXTRANSPORTADORA"):Disable()
	END IF
oSection1:Print()

Return(.t.)
