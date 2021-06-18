#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER066    บAutor  ณErica Vieites       บ Data ณ  24/05/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de NOTAS APURADAS NO SISTEMA DA                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER066()             

Local oReport
Local cPerg := "GER066"


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
oReport := TReport():New("GER066","NOTAS APURADAS NO SISTEMA DA",cPerg,{|oReport| PrintReport(oReport)},"NOTAS APURADAS NO SISTEMA DA")


oReport:NDEVICE := 4


//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"NOTAS APURADAS NO SISTEMA DA","SD2")

//Celulas da secao
TRCell():New(oSection1,"D2_QUANT"	    		,"SD2","ID Empresa",'@E999',10)
TRCell():New(oSection1,"DT_EMISSAO"	   	        ," ","Data Emissใo",,25)
TRCell():New(oSection1,"NR_NOTA_FISCAL"	   		," ","Nota Fiscal",,20)
TRCell():New(oSection1,"D2_TES"                ,"SD2","TES",,25)
TRCell():New(oSection1,"C6_CF"	  	            ,"SC6 ","CFOP",'',10) 
TRCell():New(oSection1,"D81_VL_CAPA"	    	," ","Vl. Capa",,20)     
TRCell():New(oSection1,"D81_VL_LIQUIDO"	    	," ","Vl.  Lํquido",,15)

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
 
  	
SELECT V02.V01_ID_EMPRESA ID_EMPRESA,
  D32_DT_EMISSAO DT_EMISSAO,
  D32_NR_NOTA_FISCAL NR_NOTA_FISCAL,
  D32.V03_ID_NATUREZA_OPERACAO D2_TES,
  D32_NR_CFOP C6_CF,
  SUM(NVL(
  CASE NVL(D30.D30_ST_INFLUENCIA_DAU ,'N')
    WHEN 'S'
    THEN NVL(
      CASE NVL(D30.D30_TP_INFLUENCIA_SINAL,'P')
        WHEN 'P'
        THEN (D32_VL_CAPA*D32_NR_QTDE_LIVROS) * 1
        WHEN 'N'
        THEN (D32_VL_CAPA*D32_NR_QTDE_LIVROS) * -1
        ELSE 0
      END,0)
    ELSE 0
  END,0)) AS D81_VL_CAPA,
  SUM(NVL(
  CASE NVL(D30.D30_ST_INFLUENCIA_DAU ,'N')
    WHEN 'S'
    THEN NVL(
      CASE NVL(D30.D30_TP_INFLUENCIA_SINAL,'P')
        WHEN 'P'
        THEN (D32_VL_LIQUIDO*D32_NR_QTDE_LIVROS) * 1
        WHEN 'N'
        THEN (D32_VL_LIQUIDO*D32_NR_QTDE_LIVROS) * -1
        ELSE 0
      END,0)
    ELSE 0
  END,0)) AS D81_VL_LIQUIDO
FROM GUA_DA.DAU_D32_NOTAS_FISCAIS D32
INNER JOIN GUA_DA.DAU_D31_GRUPO_DEMONST_NATUREZA D31
ON D31.V03_ID_NATUREZA_OPERACAO = D32.V03_ID_NATUREZA_OPERACAO
INNER JOIN GUA_DA.DAU_D30_GRUPOS_DEMONSTRATIVO D30
ON D30.D30_ID_GRUPO_DEMONSTRATIVO = D31.D30_ID_GRUPO_DEMONSTRATIVO
INNER JOIN GUA_DA.DAU_V02_OBRAS V02
ON V02.V02_CD_OBRA      = D32.V02_CD_OBRA
AND V02.V01_ID_EMPRESA IN(1,2,12,30,42,4)
WHERE D32_DT_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
GROUP BY V02.V01_ID_EMPRESA,
  D32_DT_EMISSAO,
  D32_NR_NOTA_FISCAL,
  D32.V03_ID_NATUREZA_OPERACAO,
  D32_NR_CFOP
ORDER BY 1,2


	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)