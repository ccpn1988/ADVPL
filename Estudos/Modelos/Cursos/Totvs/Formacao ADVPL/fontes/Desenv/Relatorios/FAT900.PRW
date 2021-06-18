#include "protheus.ch"
#include "topconn.ch"

/*/
FUNÇÃO: FAT900

DESCRIÇÃO: RELATÓRIO DE CONFERÊNCIA DA PRESTAÇÃO DE CONTAS

DATA: 14/05/2015

MANUTEÇÕES:                                                                                     

------------------------------------------------------------------------------------------------
/*/

User Function FAT900             

Local oReport
Local cPerg := "FAT900"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Dt Referencia", "Dt Referencia", "Dt Referencia",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Filial Origem", "Filial Origem", "Filial Origem",  "mv_ch2" , "C", 4, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("FAT900","Prestação de Contas",cPerg,{|oReport| PrintReport(oReport)},"Prestação de Contas - Análise de execução")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"PRO_COD"		,"",,,20)	//CODIGO DO PRODUTO
TRCell():New(oSection1,"PRO_ISB"		,"",,,20)	//ISBN DO PRODUTO
TRCell():New(oSection1,"PRO_DES"		,"",,,20)	//DESCRIÇAO DO PRODUTO

TRCell():New(oSection1,"ORI_COD"		,"",,,6) 	//CODIGO FORNECEDOR EMPRESA ORIGEM
TRCell():New(oSection1,"ORI_LOJ"		,"",,,2) 	//LOJA FORNECEDOR EMPRESA ORIGEM

TRCell():New(oSection1,"DAT_REF"		,"",,,8) 	//DATA REFERENCIA

TRCell():New(oSection1,"VALOR_ORI_VND"	,"",,,15) 	//TOTAL DE VENDA DO GEN A MERCADO
TRCell():New(oSection1,"VALOR_DEV_VND"	,"",,,15) 	//TOTAL DE DEVOLUÇÕES DE VENDA DO GEN A MERCADO
TRCell():New(oSection1,"VALOR_CAN_VND"	,"",,,15) 	//TOTAL DE CANCELAMENTOS DE VENDA DO GEN A MERCADO
TRCell():New(oSection1,"SALDO_VENDA"	,"",,,15) 	//SALDO APURADO PARA VENDA DO GEN A MERCADO

TRCell():New(oSection1,"VALOR_ORI_OFT"	,"",,,15) 	//TOTAL DE OFERTA DO GEN A MERCADO
TRCell():New(oSection1,"VALOR_DEV_OFT"	,"",,,15) 	//TOTAL DE DEVOLUÇÕES DE OFERTA DO GEN A MERCADO
TRCell():New(oSection1,"VALOR_CAN_OFT"	,"",,,15) 	//TOTAL DE CANCELAMENTOS DE OFERTA DO GEN A MERCADO
TRCell():New(oSection1,"SALDO_OFERTA"	,"",,,15) 	//SALDO APURADO PARA OFERTA DO GEN A MERCADO

TRCell():New(oSection1,"VALOR_SAIDA_1"		,"",,,15) 	//TOTAL DEVOLVIDO DO GEN PARA EMPRESA ORIGEM NOTA DE SAIDA
TRCell():New(oSection1,"VALOR_ENTRADA_1"	,"",,,15) 	//TOTAL DEVOLVIDO DO GEN PARA EMPRESA ORIGEM NOTA DE ENTRADA

TRCell():New(oSection1,"VALOR_SAIDA_2"		,"",,,15) 	//TOTAL VENDA/OFERTA DA EMPRESA ORIGEM PARA O GEM NOTA DE SAIDA
TRCell():New(oSection1,"VALOR_ENTRADA_2"	,"",,,15) 	//TOTAL VENDA/OFERTA DA EMPRESA ORIGEM PARA O GEM NOTA DE ENTRADA

TRCell():New(oSection1,"SALDO_PODER3_GEN"	,"",,,15) 	//SALDO PODER DE TERCEIROS NO GEN
TRCell():New(oSection1,"SALDO_PODER3_ORIGEM","",,,15) 	//SALDO PODER EM TERCEIROS NA ORIGEM

TRCell():New(oSection1,"STATUS","",,,50) 			//STATUS DA PRESTAÇÃO
TRCell():New(oSection1,"SITUACAO_PODER3","",,,50)	//SITUACAO DO SALDO PODER 3

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local _cAlias1	:= GetNextAlias()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := MV_PAR02
  
_cSQL := " 		SELECT B1_COD AS PRO_COD"
_cSQL += " 			,B1_PROC AS ORI_COD"
_cSQL += " 			,B1_LOJPROC AS ORI_LOJ"
_cSQL += " 			,B1_ISBN AS PRO_ISB"
_cSQL += " 			,B1_DESC AS PRO_DES"
_cSQL += " 			,'20150430' AS DAT_REF"
_cSQL += " 			,VALOR_ORI_VND"
_cSQL += " 			,VALOR_DEV_VND"
_cSQL += " 			,VALOR_CAN_VND"
_cSQL += " 			,(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) AS SALDO_VENDA"
_cSQL += " 			,VALOR_ORI_OFT"
_cSQL += " 			,VALOR_DEV_OFT"
_cSQL += " 			,VALOR_CAN_OFT"
_cSQL += " 			,(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) AS SALDO_OFERTA"
_cSQL += " 			,VALOR_SAIDA_1"
_cSQL += " 			,VALOR_ENTRADA_1"
_cSQL += " 			,VALOR_SAIDA_2"
_cSQL += " 			,VALOR_ENTRADA_2"
_cSQL += " 			,SALDO_PODER3_GEN "
_cSQL += " 			,SALDO_PODER3_ORIGEM"
_cSQL += " 			, CASE"
_cSQL += " 		    WHEN Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = 0"
_cSQL += " 		      AND 0 = VALOR_SAIDA_1 "
_cSQL += " 		      AND VALOR_SAIDA_1 = VALOR_ENTRADA_1"
_cSQL += " 		      AND VALOR_ENTRADA_1 = VALOR_SAIDA_2"
_cSQL += " 		      AND VALOR_SAIDA_2 = VALOR_ENTRADA_2 "
_cSQL += " 		      THEN 'OK'"
_cSQL += " 		    WHEN Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) > 0"
_cSQL += " 		      AND Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = VALOR_SAIDA_1 "
_cSQL += " 		      AND VALOR_SAIDA_1 = VALOR_ENTRADA_1"
_cSQL += " 		      AND VALOR_ENTRADA_1 = VALOR_SAIDA_2"
_cSQL += " 		      AND VALOR_SAIDA_2 = VALOR_ENTRADA_2 "
_cSQL += " 		      THEN 'OK'"
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) > 0 "
_cSQL += " 		      AND (VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) < 0"
_cSQL += " 		      AND Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = VALOR_SAIDA_1 "
_cSQL += " 		      AND VALOR_SAIDA_1 = VALOR_ENTRADA_1"
_cSQL += " 		      AND VALOR_SAIDA_2 = (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)"
_cSQL += " 		      AND VALOR_SAIDA_2 = VALOR_ENTRADA_2 "
_cSQL += " 		      THEN 'OK'"
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) < 0 "
_cSQL += " 		      AND (VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) > 0"
_cSQL += " 		      AND Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = VALOR_SAIDA_1 "
_cSQL += " 		      AND VALOR_SAIDA_1 = VALOR_ENTRADA_1"
_cSQL += " 		      AND VALOR_SAIDA_2 = (VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT)"
_cSQL += " 		      AND VALOR_SAIDA_2 = VALOR_ENTRADA_2 "
_cSQL += " 		      THEN 'OK'"
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) < 0 "
_cSQL += " 		      AND (VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) < 0"
_cSQL += " 		      AND Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = VALOR_SAIDA_1 "
_cSQL += " 		      AND VALOR_SAIDA_1 = VALOR_ENTRADA_1"
_cSQL += " 		      AND VALOR_SAIDA_2 = 0"
_cSQL += " 		      AND VALOR_SAIDA_2 = VALOR_ENTRADA_2 "
_cSQL += " 		      THEN 'OK'"
_cSQL += " 		    WHEN Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) <> 0"
_cSQL += " 		      AND VALOR_SAIDA_1 = 0 "
_cSQL += " 		      AND VALOR_ENTRADA_1 = 0"
_cSQL += " 		      AND VALOR_SAIDA_2 = 0 "
_cSQL += " 		      AND VALOR_ENTRADA_2 = 0 "
_cSQL += " 		      THEN 'NAO PRESTOU CONTAS VENDA E OFERTA'"
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) <> VALOR_SAIDA_1"
_cSQL += " 	     	  AND Abs(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) = VALOR_SAIDA_1 "
_cSQL += " 	          THEN 'NAO PRESTOU CONTAS OFERTA'"
_cSQL += " 		  	WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) <> VALOR_SAIDA_1"
_cSQL += " 		      AND Abs(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) = VALOR_SAIDA_1 "
_cSQL += " 		      THEN 'NAO PRESTOU CONTAS VENDA'"
_cSQL += " 	      	WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) <> VALOR_SAIDA_1  "
_cSQL += " 	          THEN 'ERRO SAIDA 1 (GEN -> ORIGEM)'"
_cSQL += " 	    	WHEN VALOR_SAIDA_1 <> VALOR_ENTRADA_1  "
_cSQL += " 	          THEN 'ERRO ENTRADA 1 (GEN -> ORIGEM)'"
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) >= 0 "
_cSQL += " 		      AND VALOR_SAIDA_1 <> VALOR_SAIDA_2  "
_cSQL += " 		      THEN 'ERRO SAIDA 2 (ORIGEM -> GEN)'  "
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) >= 0 "
_cSQL += " 		      AND VALOR_SAIDA_2 <> VALOR_ENTRADA_2  "
_cSQL += " 		      THEN 'ERRO ENTRADA 2 (ORIGEM -> GEN)'  "
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) < 0 "
_cSQL += " 		      AND VALOR_SAIDA_2 <> 0"
_cSQL += " 		      THEN 'ERRO SAIDA 2 (ORIGEM -> GEN)'  "
_cSQL += " 		    WHEN (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND)+(VALOR_ORI_OFT-VALOR_DEV_OFT-VALOR_CAN_OFT) < 0 "
_cSQL += " 		      AND VALOR_ENTRADA_2 <> 0 "
_cSQL += " 		      THEN 'ERRO ENTRADA 2 (ORIGEM -> GEN)'  "
_cSQL += " 	    	ELSE 'INVALIDO'"
_cSQL += "   		END STATUS,"
_cSQL += " 		  CASE "
_cSQL += " 		    WHEN SALDO_PODER3_GEN = SALDO_PODER3_ORIGEM"
_cSQL += " 		    AND SALDO_PODER3_GEN = 0"
_cSQL += " 		    AND SALDO_PODER3_ORIGEM = 0"
_cSQL += " 		    THEN 'SALDO PODER 3 ZERADO'"
_cSQL += " 		    WHEN SALDO_PODER3_GEN = SALDO_PODER3_ORIGEM "
_cSQL += " 		    THEN 'SALDO PODER 3 IGUAL ENTRE EMPRESAS'"
_cSQL += " 		    ELSE 'SALDO PODER 3 DIFERENTE ENTRE EMPRESAS'"
_cSQL += " 		  END SITUACAO_PODER3"
_cSQL += " 		FROM"
_cSQL += " 		  ( SELECT DISTINCT SB1.B1_COD,"
_cSQL += " 		    SB1.B1_PROC,"
_cSQL += " 		    SB1.B1_LOJPROC,"
_cSQL += " 		    SB1.B1_ISBN,"
_cSQL += " 		    SB1.B1_DESC,"
_cSQL += " 		    SB1.B1_UM,"
_cSQL += " 		    SB1.B1_LOCPAD,"
_cSQL += " 		    SB1.B1_MSBLQL,"
_cSQL += " 		    (SELECT NVL(SUM(SD2PR.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2PR"
_cSQL += " 		    WHERE SD2PR.D2_TES IN ('506','501','052','053','050','503','524','534','502','504','505','507')"
_cSQL += " 		    AND SD2PR.D2_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD2PR.D2_FILIAL = '1022'"
_cSQL += " 		    AND SD2PR.D2_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD2PR.D2_XCONSIG = ' '"
_cSQL += " 		    AND SD2PR.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_ORI_VND,"
_cSQL += " 		    (SELECT NVL(SUM(SD1SE.D1_QUANT),0)"
_cSQL += " 		    FROM SD1000 SD1SE"
_cSQL += " 		    WHERE SD1SE.D1_TES IN ('506','501','052','053','050','503','524','534','502','504','505','507')"
_cSQL += " 		    AND SD1SE.D1_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD1SE.D1_FILIAL = '1022'"
_cSQL += " 		    AND SD1SE.D1_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD1SE.D1_XCONSIG = ' '"
_cSQL += " 		    AND SD1SE.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_DEV_VND,"
_cSQL += " 		    (SELECT NVL(SUM(SD2CA.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2CA"
_cSQL += " 		    WHERE SD2CA.D2_COD   = SB1.B1_COD"
_cSQL += " 		    AND SD2CA.D2_TES    IN ('506','501','052','053','050','503','524','534','502','504','505','507')"
_cSQL += " 		    AND SD2CA.D2_FILIAL  = '1022'"
_cSQL += " 		    AND SD2CA.D_E_L_E_T_ = '*'"
_cSQL += " 		    AND SD2CA.D2_XCONSIG = 'S'"
_cSQL += " 		    ) AS VALOR_CAN_VND,"
_cSQL += " 		    (SELECT NVL(SUM(SD2PR.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2PR"
_cSQL += " 		    WHERE SD2PR.D2_TES IN ('039','037','063','518','519')"
_cSQL += " 		    AND SD2PR.D2_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD2PR.D2_FILIAL = '1022'"
_cSQL += " 		    AND SD2PR.D2_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD2PR.D2_XCONSIG = ' '"
_cSQL += " 		    AND SD2PR.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_ORI_OFT,"
_cSQL += " 		    (SELECT NVL(SUM(SD1SE.D1_QUANT),0)"
_cSQL += " 		    FROM SD1000 SD1SE"
_cSQL += " 		    WHERE SD1SE.D1_TES IN ('039','037','063','518','519')"
_cSQL += " 		    AND SD1SE.D1_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD1SE.D1_FILIAL = '1022'"
_cSQL += " 		    AND SD1SE.D1_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD1SE.D1_XCONSIG = ' '"
_cSQL += " 		    AND SD1SE.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_DEV_OFT,"
_cSQL += " 		    (SELECT NVL(SUM(SD2CA.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2CA"
_cSQL += " 		    WHERE SD2CA.D2_COD   = SB1.B1_COD"
_cSQL += " 		    AND SD2CA.D2_TES    IN ('039','037','063','518','519')"
_cSQL += " 		    AND SD2CA.D2_FILIAL  = '1022'"
_cSQL += " 		    AND SD2CA.D_E_L_E_T_ = '*'"
_cSQL += " 		    AND SD2CA.D2_XCONSIG = 'S'"
_cSQL += " 		    ) AS VALOR_CAN_OFT,"
_cSQL += " 		    (SELECT NVL(SUM(SD2S1.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2S1"
_cSQL += " 		    WHERE SD2S1.D2_TES IN ('821','809','839') "
_cSQL += " 		    AND SD2S1.D2_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD2S1.D2_FILIAL = '1022'"
_cSQL += " 		    AND SD2S1.D2_CLIENTE = '0380795' "
_cSQL += " 		    AND SD2S1.D2_LOJA = '01' "
_cSQL += " 		    AND SD2S1.D2_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD2PR.D2_XCONSIG = ' '"
_cSQL += " 		    AND SD2S1.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_SAIDA_1,"
_cSQL += " 		    (SELECT NVL(SUM(SD1E1.D1_QUANT),0)"
_cSQL += " 		    FROM SD1000 SD1E1"
_cSQL += " 		    WHERE SD1E1.D1_TES IN ('438','452','463') "
_cSQL += " 		    AND SD1E1.D1_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD1E1.D1_FILIAL = '2022' "
_cSQL += " 		    AND SD1E1.D1_FORNECE = '0005065'"
_cSQL += " 		    AND SD1E1.D1_LOJA = '01'"
_cSQL += " 		    AND SD1E1.D1_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD1SE.D1_XCONSIG = ' '"
_cSQL += " 		    AND SD1E1.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_ENTRADA_1,"
_cSQL += " 		    (SELECT NVL(SUM(SD2S2.D2_QUANT),0)"
_cSQL += " 		    FROM SD2000 SD2S2"
_cSQL += " 		    WHERE SD2S2.D2_TES IN ('801','818') "
_cSQL += " 		    AND SD2S2.D2_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD2S2.D2_FILIAL = '2022' "
_cSQL += " 		    AND SD2S2.D2_CLIENTE = '0005065'"
_cSQL += " 		    AND SD2S2.D2_LOJA = '01'"
_cSQL += " 		    AND SD2S2.D2_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD2PR.D2_XCONSIG = ' '"
_cSQL += " 		    AND SD2S2.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_SAIDA_2,"
_cSQL += " 		    (SELECT NVL(SUM(SD1E2.D1_QUANT),0)"
_cSQL += " 		    FROM SD1000 SD1E2"
_cSQL += " 		    WHERE SD1E2.D1_TES IN ('404','437') "
_cSQL += " 		    AND SD1E2.D1_COD    = SB1.B1_COD"
_cSQL += " 		    AND SD1E2.D1_FILIAL = '1022'"
_cSQL += " 		    AND SD1E2.D1_FORNECE = '0380795' "
_cSQL += " 		    AND SD1E2.D1_LOJA = '01' "
_cSQL += " 		    AND SD1E2.D1_EMISSAO BETWEEN '20150401' AND '20150430' "
_cSQL += " 		    --AND SD1SE.D1_XCONSIG = ' '"
_cSQL += " 		    AND SD1E2.D_E_L_E_T_ = ' '"
_cSQL += " 		    ) AS VALOR_ENTRADA_2,"
_cSQL += " 		    (SELECT NVL(Sum(B6_SALDO),0) B6_SALDO"
_cSQL += " 		    FROM SB6000 SB6"
_cSQL += " 		    WHERE SB6.D_E_L_E_T_ = ' '"
_cSQL += " 		    AND SB6.B6_FILIAL = '1022'"
_cSQL += " 		    AND SB6.B6_TIPO = 'D'"
_cSQL += " 		    AND SB6.B6_TPCF = 'F'"
_cSQL += " 		    AND SB6.B6_PODER3 = 'R'"
_cSQL += " 		    AND SB6.B6_SALDO > 0"
_cSQL += " 		    AND SB6.B6_PRODUTO = SB1.B1_COD"
_cSQL += " 		    AND SB6.B6_CLIFOR = '0380795' "
_cSQL += " 		    AND SB6.B6_LOJA = '01' "
_cSQL += " 		  ) SALDO_PODER3_GEN,"
_cSQL += " 		  (SELECT NVL(Sum(B6_SALDO),0) B6_SALDO"
_cSQL += " 		    FROM SB6000 SB6"
_cSQL += " 		    WHERE SB6.D_E_L_E_T_ = ' '"
_cSQL += " 		    AND SB6.B6_FILIAL = '2022' "
_cSQL += " 		    AND SB6.B6_TIPO = 'E'"
_cSQL += " 		    AND SB6.B6_TPCF = 'C'"
_cSQL += " 		    AND SB6.B6_PODER3 = 'R'"
_cSQL += " 		    AND SB6.B6_SALDO > 0"
_cSQL += " 		    AND SB6.B6_PRODUTO = SB1.B1_COD"
_cSQL += " 		    AND SB6.B6_CLIFOR = '0005065'"
_cSQL += " 		    AND SB6.B6_LOJA = '01' "
_cSQL += " 		  ) SALDO_PODER3_ORIGEM"
_cSQL += " 		  FROM SB1000 SB1"
_cSQL += " 		  INNER JOIN SZ4000 SZ4"
_cSQL += " 		  ON SB1.B1_XSITOBR   = SZ4.Z4_COD"
_cSQL += " 		  AND SZ4.Z4_MSBLQL   = '2'"
_cSQL += " 		  AND SZ4.Z4_FILIAL   = '    '"
_cSQL += " 		  AND SZ4.D_E_L_E_T_  = ' '"
_cSQL += " 		  WHERE SB1.B1_FILIAL = '    '"
_cSQL += " 		  AND SB1.D_E_L_E_T_  = ' '"
_cSQL += " 		  AND SB1.B1_ISBN    <> ' '"
_cSQL += " 		  AND SB1.B1_PROC     = '0380795' "
_cSQL += " 		  AND SB1.B1_COD     = '01812106                      ' "
_cSQL += " 		  AND SB1.B1_LOJPROC  = '01' "
_cSQL += " 		  )"
_cSQL += " 		WHERE VALOR_ORI_VND <> 0"
_cSQL += " 		OR VALOR_DEV_VND    <> 0"
_cSQL += " 		OR VALOR_CAN_VND    <> 0"
_cSQL += " 		OR VALOR_ORI_OFT    <> 0"
_cSQL += " 		OR VALOR_DEV_OFT    <> 0"
_cSQL += " 		OR VALOR_CAN_OFT    <> 0"
_cSQL += " 		ORDER BY STATUS, "
_cSQL += " 		  B1_PROC,"
_cSQL += " 		  B1_LOJPROC, "
_cSQL += " 		  B1_COD"

If Select(_cAlias1) > 0
	(_cAlias1)-(dbCloseArea())
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,_cSQL), _cAlias1, .F., .T.)

While !(_cAlias1)->(eof()) .And. !oReport:Cancel()

	oSection1:Init()  
	
	oSection1:Cell("PRO_COD"):SetValue((_cAlias1)->PRO_COD) 
	oSection1:Cell("PRO_ISB"):SetValue((_cAlias1)->PRO_ISB) 
	oSection1:Cell("PRO_DES"):SetValue((_cAlias1)->PRO_DES) 
	oSection1:Cell("ORI_COD"):SetValue((_cAlias1)->ORI_COD) 
	oSection1:Cell("ORI_LOJ"):SetValue((_cAlias1)->ORI_LOJ) 
	oSection1:Cell("ORI_LOJ"):SetValue((_cAlias1)->ORI_LOJ) 
	oSection1:Cell("DAT_REF"):SetValue((_cAlias1)->DAT_REF) 
	oSection1:Cell("VALOR_ORI_VND"):SetValue((_cAlias1)->VALOR_ORI_VND) 
	oSection1:Cell("VALOR_DEV_VND"):SetValue((_cAlias1)->VALOR_DEV_VND) 
	oSection1:Cell("VALOR_CAN_VND"):SetValue((_cAlias1)->VALOR_CAN_VND) 
	oSection1:Cell("SALDO_VENDA"):SetValue((_cAlias1)->SALDO_VENDA) 
	oSection1:Cell("VALOR_ORI_OFT"):SetValue((_cAlias1)->VALOR_ORI_OFT) 
	oSection1:Cell("VALOR_DEV_OFT"):SetValue((_cAlias1)->VALOR_DEV_OFT) 
	oSection1:Cell("VALOR_CAN_OFT"):SetValue((_cAlias1)->VALOR_CAN_OFT) 
	oSection1:Cell("SALDO_OFERTA"):SetValue((_cAlias1)->SALDO_OFERTA) 
	oSection1:Cell("VALOR_SAIDA_1"):SetValue((_cAlias1)->VALOR_SAIDA_1) 
	oSection1:Cell("VALOR_ENTRADA_1"):SetValue((_cAlias1)->VALOR_ENTRADA_1) 
	oSection1:Cell("VALOR_ENTRADA_1"):SetValue((_cAlias1)->VALOR_ENTRADA_1) 
	oSection1:Cell("VALOR_SAIDA_2"):SetValue((_cAlias1)->VALOR_SAIDA_2) 
	oSection1:Cell("VALOR_ENTRADA_2"):SetValue((_cAlias1)->VALOR_ENTRADA_2) 
	oSection1:Cell("SALDO_PODER3_GEN"):SetValue((_cAlias1)->SALDO_PODER3_GEN) 
	oSection1:Cell("SALDO_PODER3_ORIGEM"):SetValue((_cAlias1)->SALDO_PODER3_ORIGEM) 
	oSection1:Cell("STATUS"):SetValue((_cAlias1)->STATUS) 
	oSection1:Cell("SITUACAO_PODER3"):SetValue((_cAlias1)->SITUACAO_PODER3) 
	
	oSection1:PrintLine()

	(_cAlias1)->(dbSkip())
		
End

Return(.t.)