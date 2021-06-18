#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER067    บAutor  ณErica Vieites       บ Data ณ  24/05/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de AGGING NFS/FRETE                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER067()             

Local oReport
Local cPerg := "GER067"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Data de:", "Data de:" ,"Data de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data at้:", "Data at้:","Data at้:", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")


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

//Declaracao do relatorio
oReport := TReport():New("GER067","AGGING NFS/FRETE",cPerg,{|oReport| PrintReport(oReport)},"AGGING NFS/FRETE")


oReport:NDEVICE := 4


//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"AGGING NFS/FRETE","SD2")

//Celulas da secao
TRCell():New(oSection1,"ID_EMPRESA"	   	        ," ","ID Empresa",'@E999',25)
TRCell():New(oSection1,"NF"         	   	    ," ","Nota Fiscal",,20)
TRCell():New(oSection1,"CD_OBRA"	   	        ," ","ID Obra",,10)     
TRCell():New(oSection1,"OBRA"	   	            ," ","Obra",,15)  
TRCell():New(oSection1,"SIT_OBRA"	   	        ," ","Sit.Obra",,20) 
TRCell():New(oSection1,"SIT_DA"	   	            ," ","Sit.DA",,20) 
TRCell():New(oSection1,"D2_EMISSAO"	   	        ,"SD2","Data Emissใo",,20)  
TRCell():New(oSection1,"ID_TES" 	   	        ," ","ID TES",,10) 
TRCell():New(oSection1,"TES"	   	            ," ","TES",,20)
TRCell():New(oSection1,"CENTRO_LUCRO"	   	    ," ","Centro Lucro",,15) 
TRCell():New(oSection1,"QTDE"	   	            ," ","Qtde",,20) 
TRCell():New(oSection1,"VL_BRUTO"	         	," ","Pre็o Bruto",,20)
TRCell():New(oSection1,"VL_CAPA"	         	," ","Pre็o Capa",,20)       
TRCell():New(oSection1,"VL_LIQUIDO"	        	," ","Pre็o Unitแrio",,15) 
TRCell():New(oSection1,"FRETE"    	            ," ","Frete",'',10)   
TRCell():New(oSection1,"TOTAL_LIQ_NF"    	    ," ","Total Lํq. NF",'',20) 
TRCell():New(oSection1,"STATUS_CONTRATO"       ," ","status Contrato",'',10) 
TRCell():New(oSection1,"F2_EMISSAO"    	       ,"SF2","Data Contrato",'',10) 

//Totalizadores
//TRFunction():New(oSection1:Cell("D81_VL_CAPA")        ,NIL,"SUM")
//TRFunction():New(oSection1:Cell("D81_VL_LIQUIDO")     ,NIL,"SUM")                            

//Faz a impressao do totalizador em linha
//oSection1:SetTotalInLine(.F.)
//oReport:SetTotalInLine(.F.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()     

If oReport:NDEVICE <> 4
	MsgInfo("Este relat๓rio somente poderแ ser impresso em Excel.")
	Return(.t.)
Endif

//_cParm1 := DTOS(MV_PAR01)
//_cParm2 := DTOS(MV_PAR02)   

_cParm1 := MV_PAR01
_cParm2 := MV_PAR02
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
 
  	
SELECT NF.ID_EMPRESA,
  NF.CD_OBRA,
  UPPER(V02.V02_TX_TITULO_COMPLETO) OBRA,
  V02.V02_TX_SITUACAO_OBRA SIT_OBRA,
  V02.V02_TX_STATUS_OBRA SIT_DA,
  NF.NR_NOTA_FISCAL NF,
  NF.DT_EMISSAO D2_EMISSAO,
  NF.TES ID_TES,
  SF4.F4_TEXTO TES,
  NF.VL_BRUTO,
  NF.VL_LIQUIDO,
  NF.VL_CAPA,
  NF.QTDE,
  V02.V02_TX_CENTRO_LUCRO CENTRO_LUCRO,  
  SF2.F2_FRETE FRETE,
  (NF.VL_LIQUIDO*NF.QTDE) TOTAL_LIQ_NF,
  UPPER(D22.D22_TX_DESCRICAO) STATUS_CONTRATO,
  D233.D23_DT_INCLUSAO F2_EMISSAO
FROM
  (SELECT V02_CD_OBRA CD_OBRA,
    V16_DT_DIGIT DT_EMISSAO,
    V03_ID_NATUREZA_OPERACAO TES,
    V16_NR_NOTA_FISCAL NR_NOTA_FISCAL,
    V16_ID_NOTA_FISCAL ID_NF,
    V16_VL_BRUTO VL_BRUTO,
    V16_NR_QTDE_LIVROS QTDE,
    V16_VL_LIQUIDO VL_LIQUIDO,
    V16_VL_CAPA VL_CAPA,
    V01_ID_EMPRESA ID_EMPRESA
  FROM DAU_V16_NOTAS_FISCAIS_ENTRADA
  WHERE V16_DT_DIGIT BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
  UNION ALL
  SELECT V02_CD_OBRA,
    V17_DT_EMISSAO,
    V03_ID_NATUREZA_OPERACAO,
    V17_NR_NOTA_FISCAL,
    V17_ID_NOTA_FISCAL,
    V17_VL_BRUTO,
    V17_NR_QTDE_LIVROS,
    V17_VL_LIQUIDO,
    V17_VL_CAPA VL_CAPA,
    V01_ID_EMPRESA
  FROM DAU_V17_NOTAS_FISCAIS_SAIDA
  WHERE V17_DT_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
  ) NF
INNER JOIN TOTVS.SF2000 SF2
ON SF2.R_E_C_N_O_ = NF.ID_NF
INNER JOIN TOTVS.SF4000 SF4
ON SF4.F4_CODIGO = NF.TES-1000
LEFT JOIN GUA_DA.DAU_V02_OBRAS V02
ON V02_CD_OBRA = NF.CD_OBRA
LEFT JOIN
  (SELECT MAX(D23_ID_CONTRATO) ID_CONTRATO,
    V02_CD_OBRA
  FROM GUA_DA.DAU_D23_CONTRATOS
  GROUP BY V02_CD_OBRA
  ) D23   
ON D23.V02_CD_OBRA = NF.CD_OBRA
LEFT JOIN GUA_DA.DAU_D23_CONTRATOS D233
ON D233.D23_ID_CONTRATO = D23.ID_CONTRATO
LEFT JOIN GUA_DA.DAU_D22_STATUS_CONTRATO D22
ON D233.D22_ID_STATUS_CONTRATO = D22.D22_ID_STATUS_CONTRATO
ORDER BY NF,CD_OBRA




	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)