#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT012    บAutor  ณErica Vieites       บ Data ณ  02/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Controle Oferta DA                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT012()             

Local oReport
Local cPerg := "FAT012"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Emissใo de:", "Dt Emissใo de:" ,"Dt Emissใo de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissใo at้:", "Dt Emissใo at้","Dt Emissใo at้", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")


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
oReport := TReport():New("DA020","CONTROLE DE OFERTAS DA",cPerg,{|oReport| PrintReport(oReport)},"CONTROLE DE OFERTAS DA")

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
TRCell():New(oSection1,"C5_XPEDWEB"    ," ","Pedido"+CRLF+"Web",,8,,,,,"RIGHT")
TRCell():New(oSection1,"C5_EMISSAO"		," ","Data"+CRLF+"Pedido",,15,,,,,"RIGHT" )
TRCell():New(oSection1,"C5_NUM"		    ," ","Pedido",,15)
TRCell():New(oSection1,"C5_NOTA"		," ","Doc."+CRLF+"Saํda",,15,,,,,"RIGHT")
TRCell():New(oSection1,"C5_CLIENTE"		,"SC5","IDcliente",,12)
TRCell():New(oSection1,"A1_CGC"	    	,"SA1") 
TRCell():New(oSection1,"A1_NOME"    	,"SA1",,,20) 
TRCell():New(oSection1,"IDOBRA"     	," ","IDobra",,13) 
TRCell():New(oSection1,"ISBN"       	," ","ISBN",,15) 
TRCell():New(oSection1,"PRODUTO"    	," ","Produto",,20) 
TRCell():New(oSection1,"F2_XEBKNOT"    	,"SF2","Notificado",,12,,,,,"RIGHT")   
TRCell():New(oSection1,"F2_XDTEXPD"    	,"SF2","Data"+CRLF+"Exp.",,13,,,,,"RIGHT")
TRCell():New(oSection1,"EXPEDICAO"	    ," ","Expedi็ใo",,20)  
TRCell():New(oSection1,"ESTADO"	        ," ","UF",,8) 
TRCell():New(oSection1,"C5_ENDENT"    	," ","Endere็o"+CRLF+"Entrega",,40,,,,,"RIGHT") 

//Totalizadores
                            
TRFunction():New(oSection1:Cell("C5_EMISSAO")  ,NIL,"COUNT")                                

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.F.)
oReport:SetTotalInLine(.F.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
	
SELECT DISTINCT P.P46_CD_PEDIDO C5_XPEDWEB,
  TO_DATE(TO_CHAR(P.P46_DT_DATA_PEDIDO, 'DD/MM/YYYY'), 'DD/MM/YYYY') C5_EMISSAO,
  TO_CHAR(NVL(SC5.C5_NUM,'0')) C5_NUM,
  TO_CHAR(NVL(SC5.C5_NOTA,'0'))C5_NOTA,
  SC5.C5_CLIENTE C5_CLIENTE,
  SA1.A1_CGC A1_CGC,
  CASE WHEN SA1.A1_NOME IS NOT NULL THEN  SA1.A1_NOME ELSE P.P46_TX_DESCRICAO END A1_NOME, 
  SC6.C6_PRODUTO IDOBRA,
  SB1.B1_ISBN ISBN,
  SB1.B1_DESC PRODUTO,
  NVL(SF2.F2_XEBKNOT,'0') F2_XEBKNOT,
  F2_XDTEXPD, 
  CASE
    WHEN SF2.F2_XDTEXPD <> ' '
    THEN TRIM(SF2.F2_XMOTORI)
      ||'/'
      ||SF2.F2_XPLACA
    ELSE '0'
  END EXPEDICAO,
  SA1.A1_EST ESTADO,
  CASE
    WHEN SA1.A1_ENDENT <> ' '
    THEN SA1.A1_ENDENT
    ELSE SA1.A1_END
  END C5_ENDENT
FROM GUA_PEDIDOS.PED_P46_OFERTA P
LEFT JOIN %table:SC5% SC5
ON P.P46_CD_PEDIDO = TO_NUMBER(TRIM(SC5.C5_XPEDWEB))
AND SC5.R_E_C_N_O_ > 0
AND SC5.C5_FILIAL   = '1022'
AND SC5.%notDel%
LEFT JOIN %table:SC6% SC6
ON SC5.C5_NUM     = SC6.C6_NUM
AND SC6.%notDel%
AND SC6.C6_FILIAL  = SC5.C5_FILIAL
LEFT JOIN %table:SF2% SF2
ON SF2.F2_FILIAL   = '1022'
AND SC6.C6_NOTA    = SF2.F2_DOC
AND SC6.C6_SERIE   = SF2.F2_SERIE
AND SF2.%notDel%
LEFT JOIN %table:SA1% SA1
ON SA1.R_E_C_N_O_  > 0
AND SC5.C5_CLIENTE  = SA1.A1_COD
AND SC5.C5_LOJACLI = SA1.A1_LOJA
AND SA1.%notDel%     
LEFT JOIN %table:SB1% SB1
ON SB1.B1_COD = SC6.C6_PRODUTO
WHERE  P45_CD_TIPO_OFERTA IN (3,4,5)   
 AND SC5.C5_EMISSAO between  %Exp:_cParm1%  AND %Exp:_cParm2%
ORDER BY P.P46_CD_PEDIDO;
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)