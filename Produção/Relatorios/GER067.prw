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
oReport := TReport():New("GER067","AGGING NFS/FRETE MB",cPerg,{|oReport| PrintReport(oReport)},"AGGING NFS/FRETE MB")


oReport:NDEVICE := 4


//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"AGGING NFS/FRETE MB","SD2")

//Celulas da secao
TRCell():New(oSection1,"ID_EMPRESA"	   	        ," ","ID Empresa",'@E999',25)
TRCell():New(oSection1,"NF"         	   	    ," ","Nota Fiscal",,20)
TRCell():New(oSection1,"CD_OBRA"	   	        ," ","ID Obra",,10)     
TRCell():New(oSection1,"OBRA"	   	            ," ","Obra",,15)  
TRCell():New(oSection1,"SIT_OBRA"	   	        ," ","Sit.Obra",,20) 
TRCell():New(oSection1,"D2_EMISSAO"	   	        ,"SD2","Data Emissใo",,20)  
TRCell():New(oSection1,"ID_TES" 	   	        ," ","ID TES",,10) 
TRCell():New(oSection1,"TES"	   	            ," ","TES",,20)
TRCell():New(oSection1,"CENTRO_LUCRO"	   	    ," ","Centro Lucro",,15) 
TRCell():New(oSection1,"QTDE"	   	            ," ","Qtde",,20) 
TRCell():New(oSection1,"VL_BRUTO"	         	," ","Pre็o Bruto",,20)
TRCell():New(oSection1,"VL_CAPA"	         	," ","Pre็o Capa",,20)       
TRCell():New(oSection1,"VL_LIQUIDO"	        	," ","Pre็o Unitแrio",,15) 
TRCell():New(oSection1,"FRETE"    	          ," ","Frete",'',10)   
TRCell():New(oSection1,"TOTAL_LIQ_NF"    	     ," ","Total Lํq. NF",'',20) 
TRCell():New(oSection1,"STATUS_CONTRATO"       ," ","status Contrato",'',10) 
TRCell():New(oSection1,"F2_EMISSAO"    	       ,"SF2","Data Contrato",'',10) 
TRCell():New(oSection1,"APURADA"    	         ," ","Apurada",'',10)

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

 _cTab   := GETMV("GEN_FAT064") 
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
 
  	
SELECT DISTINCT V02.V01_ID_EMPRESA  ID_EMPRESA,
        TO_NUMBER(TRIM(SD2.D2_COD)) CD_OBRA,
        UPPER(V02.V02_TX_TITULO_VENDA) OBRA,
        V02.V02_TX_SITUACAO_OBRA SIT_OBRA,
        TO_NUMBER(TRIM(SF2.F2_DOC)) NF,
        SD2.D2_TES ID_TES,
        SF4.F4_TEXTO TES,
        DA1.DA1_PRCVEN VL_BRUTO,
        SD2.D2_TOTAL/SD2.D2_QUANT VL_LIQUIDO,
        DA1.DA1_PRCVEN VL_CAPA,
        SD2.D2_QUANT QTDE,
        V02.V02_TX_CENTRO_LUCRO CENTRO_LUCRO,  
        SF2.F2_FRETE FRETE,
        ((SD2.D2_TOTAL/SD2.D2_QUANT)*SD2.D2_QUANT) TOTAL_LIQ_NF,
        UPPER(D22.D22_TX_DESCRICAO) STATUS_CONTRATO,
        TO_DATE(SD2.D2_EMISSAO,'YYYYMMDD') D2_EMISSAO,
        D233.D23_DT_INCLUSAO F2_EMISSAO,
        CASE WHEN D32.V02_CD_OBRA IS NOT NULL THEN 'SIM' ELSE 'NรO' END APURADA
FROM %table:SF2% SF2
INNER JOIN %table:SD2% SD2
 ON SD2.D2_DOC = SF2.F2_DOC
AND SD2.D2_FILIAL = SF2.F2_FILIAL
AND SD2.D2_SERIE = SF2.F2_SERIE
AND SD2.%notDel%
INNER JOIN %table:SB1% SB1
  ON SB1.B1_COD = SD2.D2_COD 
 AND SB1.B1_XIDTPPU = '15'
 AND SB1.%notDel%
INNER JOIN %table:SF4% SF4
   ON SF4.F4_CODIGO = SD2.D2_TES
  AND SF4.F4_CODIGO = '504'
  AND SF4.%notDel%
LEFT JOIN GUA_DA.DAU_V02_OBRAS V02
   ON V02.V02_CD_OBRA = TO_NUMBER(TRIM(SD2.D2_COD))
LEFT JOIN %table:DA1% DA1
   ON DA1.DA1_CODPRO     = SD2.D2_COD
  AND DA1.DA1_CODTAB =  %Exp:_cTab%
  AND DA1.%notDel%
LEFT JOIN
  (SELECT MAX(D23_ID_CONTRATO) ID_CONTRATO,
    V02_CD_OBRA
  FROM GUA_DA.DAU_D23_CONTRATOS
  GROUP BY V02_CD_OBRA
  ) D23   
  ON D23.V02_CD_OBRA = TO_NUMBER(TRIM(SD2.D2_COD))
LEFT JOIN GUA_DA.DAU_D23_CONTRATOS D233
  ON D233.D23_ID_CONTRATO = D23.ID_CONTRATO
LEFT JOIN GUA_DA.DAU_D22_STATUS_CONTRATO D22
  ON D233.D22_ID_STATUS_CONTRATO = D22.D22_ID_STATUS_CONTRATO
LEFT JOIN GUA_DA.DAU_D32_NOTAS_FISCAIS D32
  ON D32.V02_CD_OBRA = TO_NUMBER(TRIM(SD2.D2_COD))
 AND D32.D32_ID_NOTA_FISCAL_ERP = SF2.R_E_C_N_O_
 AND D32.V03_ID_NATUREZA_OPERACAO = TO_NUMBER(TRIM(SF4.F4_CODIGO))+1000
WHERE SF2.%notDel%
  AND TO_DATE(SF2.F2_EMISSAO,'YYYYMMDD') BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%




	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)
