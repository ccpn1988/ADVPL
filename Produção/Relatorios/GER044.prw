#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER044    บAutor  ณErica Vieites       บ Data ณ  29/01/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Oferta Produtos Digitais CRM                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER044()             

Local oReport
Local cPerg := "GER044"


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
oReport := TReport():New("GER044","OFERTA PRODUTOS DIGITAIS CRM",cPerg,{|oReport| PrintReport(oReport)},"OFERTA PRODUTOS DIGITAIS CRM")


oReport:NDEVICE := 4


//Ajuste nas definicoes             
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Oferta Produtos Digitais","SD2")

//Celulas da secao
TRCell():New(oSection1,"CPF"	   		," ","CPF",,20)
TRCell():New(oSection1,"NOME"	   		," ","Cliente",,30)
TRCell():New(oSection1,"EMAIL"	    	," ","E-mail",,20)
TRCell():New(oSection1,"MUN"	    	," ","Municํpio",,25)
TRCell():New(oSection1,"ESTADO"	     	," ","Estado",,10) 
TRCell():New(oSection1,"ISBN"	    	," ","ISBN",,20)     
TRCell():New(oSection1,"EMPRESA"	   	," ","Empresa",,15) 
TRCell():New(oSection1,"TP"	        	," ","Tipo"+CRLF+"Publica็ใo",,17) 
TRCell():New(oSection1,"DESCRICAO"    	," ","Produto",,35)  
TRCell():New(oSection1,"AREA"        	," ","มrea",,10)
TRCell():New(oSection1,"CURSO"      	," ","Curso",,25)
TRCell():New(oSection1,"DISC"       	," ","Disciplina",,30) 
TRCell():New(oSection1,"CLASSE"       	," ","Classe",,20)
TRCell():New(oSection1,"BOOK"	    	," ","Bookshelf",,25) 
TRCell():New(oSection1,"QTDE"	    	,"","Exemplares",'@E 9,999,999',15)
TRCell():New(oSection1,"LIQ"	    	," ","Valor"+CRLF+"Lํquido",,15,,,,,"RIGHT")        
TRCell():New(oSection1,"RESP"	    	," ","Origem",,15) 
TRCell():New(oSection1,"PEDIDO"     	," ","Pedido",,15)
TRCell():New(oSection1,"PEDIDOWEB"   	," ","Pedido Web",,15)
TRCell():New(oSection1,"DATA_PEDIDO"   	," ","Data Pedido",,25)
TRCell():New(oSection1,"REPRESENTANTE" 	," ","Representante",,25)

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")   	,NIL,"SUM")
TRFunction():New(oSection1:Cell("LIQ")     ,NIL,"SUM")                            

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.F.)
oReport:SetTotalInLine(.F.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()     

If oReport:NDEVICE <> 4
	MsgInfo("Este relat๓rio somente poderแ ser impresso em Excel.")
	Return(.t.)
Endif

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
 
  	
	SELECT SA1.A1_CGC CPF,
	       SA1.A1_NOME NOME,
	 	   SA1.A1_EMAIL EMAIL, 
	 	   SA1.A1_EST ESTADO, 
	 	   SA1.A1_MUN MUN,
	       SX5.X5_DESCRI TP,
	       SB1.B1_ISBN ISBN, 
	 	   SB1.B1_DESC DESCRICAO,
	       CASE WHEN SC6.C6_XPEDWEB <> ' ' THEN DECODE(P46.P45_CD_TIPO_OFERTA,1,'CRM',3,'DIREITOS AUTORAIS','SIMP') ELSE 'BACKOFFICE' END RESP,
	       DECODE(SB1.B1_PROC,'0380795','EGK','0380796','LTC','0380794','FOR','031811 ','ACF', '0378128', 'ATLAS', '378803 ', 'GEN') EMPRESA,
	       SZ7.Z7_DESC AREA,
	       SZ5.Z5_DESC CURSO,
	       SZ6.Z6_DESC DISC,
	       SD2.D2_XBSHELF BOOK, 
	       O.QTDE,
	       O.LIQ,
	       SBM.BM_DESC CLASSE,
	       P46.P46_TX_NOME_NOTIFICACAO REPRES,
	       SC6.C6_XPEDWEB PEDIDOWEB,
	       TO_CHAR(TO_DATE(SC6.C6_ENTREG,'YYYYMMDD'),'DD/MM/YYYY') DATA_PEDIDO,
	       SC6.C6_NUM PEDIDO,
	       SC6.C6_XREPOFE REPRESENTANTE
	FROM (SELECT CLIENTE, LOJA, PROD, NOTA, SERIE, FILIAL, SUM(QTDE) QTDE, SUM(LIQUIDO) LIQ 
			FROM (SELECT SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SD2.D2_COD PROD, SD2.D2_DOC NOTA, SD2.D2_SERIE SERIE, 
	        		     SD2.D2_FILIAL FILIAL,
			             NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD2.D2_QUANT END), 0) QTDE, 
	        		     NVL(SUM(SD2.D2_VALBRUT), 0) LIQUIDO
	                FROM %table:SD2% SD2, %table:SB1% SB1
	               WHERE SD2.D2_COD = SB1.B1_COD
	                 AND SD2.D2_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_CODIGO IN ('516','518','519') AND F4_TIPO = 'S' AND %notDel% )
	                 AND SD2.D2_FILIAL  = %xFilial:SD2%
	                 AND SB1.B1_FILIAL  = %xFilial:SB1%
	                 AND SD2.D2_TIPO NOT IN ('D','B')
	                 AND SB1.B1_XIDTPPU <> ' '
	                 AND SD2.D2_EMISSAO BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
	                 AND SD2.%notDel%  
	                 AND SB1.%notDel% 
	               GROUP BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_FILIAL
	              UNION ALL
	              SELECT SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_COD, SD1.D1_NFORI, SD1.D1_SERIORI, SD1.D1_FILIAL,
	                     NVL(SUM(CASE WHEN SB1.B1_XIDTPPU IN ('11','15') THEN 0 ELSE SD1.D1_QUANT END),0)*(-1), 
	                     NVL(SUM(SD1.D1_TOTAL - SD1.D1_VALDESC), 0)*(-1) 
	                FROM %table:SD1% SD1, %table:SB1% SB1
	               WHERE SD1.D1_COD = SB1.B1_COD
	                 AND SD1.D1_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_CODIGO IN ('061','062','063') AND %notDel% )
	                 AND SD1.D1_FILIAL  = %xFilial:SD1% 
	                 AND SB1.B1_FILIAL  = %xFilial:SB1%
	                 AND SD1.D1_TIPO = 'D'
	                 AND SB1.B1_XIDTPPU <> ' '
	                 AND SD1.D1_DTDIGIT BETWEEN %Exp:_cParm1%  AND %Exp:_cParm2%
	                 AND SD1.%notDel% 
	                 AND SB1.%notDel% 
	               GROUP BY SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_COD,SD1.D1_NFORI, SD1.D1_SERIORI,SD1.D1_FILIAL)
	       GROUP BY CLIENTE, LOJA, PROD, NOTA, SERIE, FILIAL
	      HAVING SUM(QTDE) <> 0) O 
	JOIN %table:SA1% SA1
	ON O.CLIENTE = SA1.A1_COD
	AND O.LOJA = SA1.A1_LOJA
	AND SA1.A1_FILIAL = %xFilial:SA1%
	AND SA1.%notDel% 
	JOIN %table:SB1% SB1
	ON O.PROD = SB1.B1_COD
	AND SB1.B1_FILIAL = %xFilial:SB1%
	AND SB1.%notDel% 
	JOIN %table:SB5% SB5
	ON SB1.B1_COD = SB5.B5_COD
	AND SB5.B5_FILIAL = %xFilial:SB5%
	AND SB5.%notDel% 
	JOIN %table:SX5% SX5
	ON SX5.X5_CHAVE = SB1.B1_XIDTPPU
	AND SX5.X5_TABELA = 'Z4'
	AND TRIM(SX5.X5_DESCENG) = '1'
	AND SX5.X5_FILIAL =  %xFilial:SX5%
	AND SX5.%notDel% 
	JOIN (SELECT C6_FILIAL, C6_NOTA, C6_SERIE, C6_PRODUTO, C6_XPEDWEB, C6_ENTREG, C6_NUM, C6_XREPOFE, SUM(SC6000.C6_QTDVEN) 
	       FROM %table:SC6% WHERE %notDel%  
	      GROUP BY C6_FILIAL, C6_NOTA, C6_SERIE, C6_PRODUTO, C6_XPEDWEB, C6_ENTREG, C6_NUM, C6_XREPOFE) SC6 
	ON O.NOTA = SC6.C6_NOTA
	AND O.SERIE = SC6.C6_SERIE
	AND O.FILIAL = SC6.C6_FILIAL
	AND O.PROD = SC6.C6_PRODUTO
	JOIN (SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, D2_XBSHELF, SUM(SD2000.D2_QUANT) 
	       FROM %table:SD2% WHERE %notDel% 
	       GROUP BY D2_FILIAL, D2_DOC, D2_SERIE, D2_COD, D2_XBSHELF) SD2 
	ON O.NOTA = SD2.D2_DOC
	AND O.SERIE = SD2.D2_SERIE
	AND O.FILIAL = SD2.D2_FILIAL
	AND O.PROD = SD2.D2_COD
	LEFT JOIN GUA_PEDIDOS.PED_P46_OFERTA P46
	ON P46.P46_CD_PEDIDO = TO_NUMBER(TRIM(SC6.C6_XPEDWEB))
	LEFT JOIN %table:SZ7% SZ7
	ON SB5.B5_XAREA = SZ7.Z7_AREA
	AND SZ7.Z7_FILIAL  = %xFilial:SZ7%
	AND SZ7.%notDel% 
	LEFT JOIN %table:SZ6% SZ6
	ON SB5.B5_XDISCIP = SZ6.Z6_DISCIPL
	AND SZ6.Z6_FILIAL  = %xFilial:SZ6%
	AND SZ6.%notDel% 
	LEFT JOIN %table:SZ5% SZ5
	ON SB5.B5_XCURSO = SZ5.Z5_CURSO
	AND SZ5.Z5_FILIAL  = %xFilial:SZ5%
	AND SZ5.%notDel% 
	LEFT JOIN %table:SBM% SBM
	ON SBM.BM_GRUPO = SB1.B1_GRUPO
	AND SBM.BM_FILIAL = %xFilial:SBM%
	AND SBM.%notDel% 
	ORDER BY O.QTDE desc, DESCRICAO, NOME
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)