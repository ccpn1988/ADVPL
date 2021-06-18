#include "protheus.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGER052    บAutor  ณEricaVieites        บ Data ณ  24/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Vendas de E-books na Vital Source              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Gerencial                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GER052()             

Local oReport
Local cPerg := "GER052"


//Cria grupo de perguntas
PutSx1(cPerg, "01", "Data de:", "Data de:" ,"Data de:",  "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Data at้:", "Data at้:","Data at้:", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "03", "D๓lar:", "D๓lar:","D๓lar:", "mv_ch3" , "N", 4, 2, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
//f001(cPerg) 

//Carrega grupo de perguntas
Pergunte(cPerg,.T.)

oReport := ReportDef(cPerg)
oReport:PrintDialog()

Return

     

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
29/01/2015 - Rafael Leite - Criacao do fonte
*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("GER052","Vendas E-books na Vital Source",cPerg,{|oReport| PrintReport(oReport)},"Vendas E-books na Vital Source",.T.)

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T. 
oReport:lDisableOrientation := .T.   

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"B1_ISBN"		,"SB1",,,15)
TRCell():New(oSection1,"B1_DESC"		,"SB1",,,30)
TRCell():New(oSection1,"D2_PRUNIT"     	,"SD2","Pre็o",,20)
TRCell():New(oSection1,"QTDE"	     	,"","Qtde",,10)  
TRCell():New(oSection1,"D2_TOTAL"	    ,"SD2","Total")
TRCell():New(oSection1,"F2_VALBRUT"	    ,"SF2","Total US$ a 50%")
TRCell():New(oSection1,"D2_DESCON"	    ,"SD2","Comission 6% US$")
TRCell():New(oSection1,"F2_DESCONT"	    ,"SF2","Comission Adjusted")

//Totalizadores
TRFunction():New(oSection1:Cell("QTDE")	,NIL,"SUM") 
TRFunction():New(oSection1:Cell("D2_TOTAL")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("F2_VALBRUT")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_DESCON")	,NIL,"SUM")  
TRFunction():New(oSection1:Cell("F2_DESCONT")	,NIL,"SUM")


//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()

oReport:SetLandScape()

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)  
_cParm3 := "%" + CVALTOCHAR(MV_PAR03) +"%"
_cTab   := GETMV("GEN_FAT064")
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  
	
select ISBN AS B1_ISBN
      , DESCRICAO AS B1_DESC
      , PRECO AS D2_PRUNIT
      , SUM(QTDE) QTDE
      , SUM(TOTAL) AS D2_TOTAL
      , SUM(ROUND(TDP,2)) AS F2_VALBRUT
      , SUM(ROUND(DLP,2)) AS D2_DESCON
      , SUM(ROUND(CONDICAO,2)) AS F2_DESCONT
  from (SELECT SB1.B1_ISBN ISBN, 
               SB1.B1_DESC DESCRICAO,
               nvl(DA1.DA1_PRCVEN, 0) preco,
               SC6.C6_QTDVEN QTDE,
               nvl(DA1.DA1_PRCVEN, 0)*SC6.C6_QTDVEN total,
              ((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)/ %Exp:_cParm3% AS TDP,
              ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% AS DLP,
              CASE WHEN ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% < 2
                   THEN (SC6.C6_QTDVEN) * 2
                   ELSE (((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)*6/100) / %Exp:_cParm3%
              END CONDICAO
        from %table:SC6% SC6, 
             %table:SF2% SF2,
             %table:SD2% SD2,
             %table:SB1% SB1,
             %table:DA1% DA1,
             %table:SC5% SC5,
             GENESB.PEDIDO P,
             GENESB.ITEM I
        WHERE P.NUMERO = TO_NUMBER(TRIM(SC5.C5_XPEDWEB))
          AND SC5.C5_NUM  = SC6.C6_NUM
          AND SC5.C5_FILIAL = SC6.C6_FILIAL
          AND P.ENTITY_ID = I.PEDIDO_ENTITY_ID
          AND LPAD(TRIM(I.SKU), 8, '0') = TRIM(SC6.C6_PRODUTO)
          AND SC6.C6_NOTA   = SF2.F2_DOC
          AND SC6.C6_FILIAL = %xFilial:SC6%
          AND SC6.C6_SERIE  = SF2.F2_SERIE
          AND SD2.D2_DOC    = SF2.F2_DOC
          AND TRIM(DA1.DA1_CODPRO) = TRIM(SB1.B1_COD)
          AND DA1.DA1_CODTAB = %Exp:_cTab%
          AND SD2.D2_FILIAL = %xFilial:SD2%
          AND SF2.F2_FILIAL =%xFilial:SF2%
          AND SD2.D2_TES IN ('503','506')
          AND SD2.D2_COD = SC6.C6_PRODUTO
          AND I.BOOKSHELF IS NOT NULL
          AND SC5.C5_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
         // AND SF2.F2_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
          AND SB1.B1_COD = SD2.D2_COD
          AND SB1.B1_XIDTPPU IN ('14','17','24','27')
          AND SC5.%notDel%
          AND SF2.%notDel%
          AND SC6.%notDel%
          AND SD2.%notDel%
          AND DA1.%notDel%     
          AND NOT EXISTS (SELECT 1 FROM OBRACOMBO OC WHERE I.SKU = TO_CHAR(OC.IDOBRAVIRTUAL))
        UNION ALL
        SELECT SB1.B1_ISBN ISBN, 
               SB1.B1_DESC DESCRICAO,
               nvl(DA1.DA1_PRCVEN, 0) preco,
               SC6.C6_QTDVEN QTDE,
               nvl(DA1.DA1_PRCVEN, 0)*SC6.C6_QTDVEN total,
              ((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)/ %Exp:_cParm3% AS TDP,
              ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% AS DLP,
              CASE WHEN ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% < 2
                   THEN (SC6.C6_QTDVEN) * 2
                   ELSE (((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)*6/100) / %Exp:_cParm3%
              END CONDICAO
        from %table:SC6% SC6, 
             %table:SF2% SF2,
             %table:SD2% SD2,
             %table:SB1% SB1,
             %table:DA1% DA1,
             %table:SC5% SC5,
             GENESB.PEDIDO P,
             GENESB.ITEM I,
             DBA_EGK.OBRACOMBO OC
        WHERE P.NUMERO = TO_NUMBER(TRIM(SC5.C5_XPEDWEB))
          AND SC5.C5_NUM  = SC6.C6_NUM
          AND SC5.C5_FILIAL = SC6.C6_FILIAL
          AND P.ENTITY_ID = I.PEDIDO_ENTITY_ID
          AND SC6.C6_NOTA   = SF2.F2_DOC
          AND SC6.C6_FILIAL = %xFilial:SC6%
          AND SC6.C6_SERIE  = SF2.F2_SERIE
          AND SD2.D2_DOC    = SF2.F2_DOC
          AND TRIM(DA1.DA1_CODPRO) = TRIM(SB1.B1_COD)
          AND DA1.DA1_CODTAB = %Exp:_cTab%
          AND SD2.D2_FILIAL = %xFilial:SD2%
          AND SF2.F2_FILIAL =%xFilial:SF2%
          AND SD2.D2_TES IN ('503','506')
          AND SD2.D2_COD = SC6.C6_PRODUTO               
          AND OC.IDOBRA  = TRIM(SC6.C6_PRODUTO)
          AND I.SKU      = TO_CHAR(OC.IDOBRAVIRTUAL)
          AND I.BOOKSHELF IS NOT NULL
          AND SC5.C5_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
          AND SB1.B1_COD = SD2.D2_COD
          AND SB1.B1_XIDTPPU IN ('14','17','24','27')
          AND SC5.%notDel%
          AND SF2.%notDel%
          AND SC6.%notDel%
          AND SD2.%notDel%
          AND DA1.%notDel%
          
          UNION ALL
          SELECT SB1.B1_ISBN ISBN, 
               SB1.B1_DESC DESCRICAO,
               nvl(DA1.DA1_PRCVEN, 0) preco,
               SC6.C6_QTDVEN QTDE,
               nvl(DA1.DA1_PRCVEN, 0)*SC6.C6_QTDVEN total,
              ((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)/ %Exp:_cParm3% AS TDP,
              ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% AS DLP,
              CASE WHEN ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% < 2
                   THEN (SC6.C6_QTDVEN) * 2
                   ELSE (((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)*6/100) / %Exp:_cParm3%
              END CONDICAO
        from %table:SC6% SC6, 
             %table:SF2% SF2,
             %table:SD2% SD2,
             %table:SB1% SB1,
             %table:DA1% DA1,
             %table:SC5% SC5,
             GENESB.PEDIDO_NOVO P,
             GENESB.ITEM_NOVO I
        WHERE P.NUMERO = TO_NUMBER(TRIM(SC5.C5_XPEDWEB))
          AND SC5.C5_NUM  = SC6.C6_NUM
          AND SC5.C5_FILIAL = SC6.C6_FILIAL
          AND P.ENTITY_ID = I.PEDIDO_ENTITY_ID
          AND LPAD(TRIM(I.SKU), 8, '0') = TRIM(SC6.C6_PRODUTO)
          AND SC6.C6_NOTA   = SF2.F2_DOC
          AND SC6.C6_FILIAL = %xFilial:SC6%
          AND SC6.C6_SERIE  = SF2.F2_SERIE
          AND SD2.D2_DOC    = SF2.F2_DOC
          AND TRIM(DA1.DA1_CODPRO) = TRIM(SB1.B1_COD)
          AND DA1.DA1_CODTAB = %Exp:_cTab%
          AND SD2.D2_FILIAL = %xFilial:SD2%
          AND SF2.F2_FILIAL =%xFilial:SF2%
          AND SD2.D2_TES IN ('503','506')
          AND SD2.D2_COD = SC6.C6_PRODUTO
          AND I.BOOKSHELF IS NOT NULL
          AND SC5.C5_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
         // AND SF2.F2_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
          AND SB1.B1_COD = SD2.D2_COD
          AND SB1.B1_XIDTPPU IN ('14','17','24','27')
          AND SC5.%notDel%
          AND SF2.%notDel%
          AND SC6.%notDel%
          AND SD2.%notDel%
          AND DA1.%notDel%     
          AND NOT EXISTS (SELECT 1 FROM OBRACOMBO OC WHERE I.SKU = TO_CHAR(OC.IDOBRAVIRTUAL))
        UNION ALL
        SELECT SB1.B1_ISBN ISBN, 
               SB1.B1_DESC DESCRICAO,
               nvl(DA1.DA1_PRCVEN, 0) preco,
               SC6.C6_QTDVEN QTDE,
               nvl(DA1.DA1_PRCVEN, 0)*SC6.C6_QTDVEN total,
              ((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)/ %Exp:_cParm3% AS TDP,
              ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% AS DLP,
              CASE WHEN ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3% < 2
                   THEN (SC6.C6_QTDVEN) * 2
                   ELSE (((SC6.C6_QTDVEN*nvl(DA1.DA1_PRCVEN, 0))*50/100)*6/100) / %Exp:_cParm3%
              END CONDICAO
        from %table:SC6% SC6, 
             %table:SF2% SF2,
             %table:SD2% SD2,
             %table:SB1% SB1,
             %table:DA1% DA1,
             %table:SC5% SC5,
             GENESB.PEDIDO_NOVO P,
             GENESB.ITEM_NOVO I,
             DBA_EGK.OBRACOMBO OC
        WHERE P.NUMERO = TO_NUMBER(TRIM(SC5.C5_XPEDWEB))
          AND SC5.C5_NUM  = SC6.C6_NUM
          AND SC5.C5_FILIAL = SC6.C6_FILIAL
          AND P.ENTITY_ID = I.PEDIDO_ENTITY_ID
          AND SC6.C6_NOTA   = SF2.F2_DOC
          AND SC6.C6_FILIAL = %xFilial:SC6%
          AND SC6.C6_SERIE  = SF2.F2_SERIE
          AND SD2.D2_DOC    = SF2.F2_DOC
          AND TRIM(DA1.DA1_CODPRO) = TRIM(SB1.B1_COD)
          AND DA1.DA1_CODTAB = %Exp:_cTab%
          AND SD2.D2_FILIAL = %xFilial:SD2%
          AND SF2.F2_FILIAL =%xFilial:SF2%
          AND SD2.D2_TES IN ('503','506')
          AND SD2.D2_COD = SC6.C6_PRODUTO               
          AND OC.IDOBRA  = TRIM(SC6.C6_PRODUTO)
          AND I.SKU      = TO_CHAR(OC.IDOBRAVIRTUAL)
          AND I.BOOKSHELF IS NOT NULL
          AND SC5.C5_EMISSAO BETWEEN %Exp:_cParm1% AND %Exp:_cParm2%
          AND SB1.B1_COD = SD2.D2_COD
          AND SB1.B1_XIDTPPU IN ('14','17','24','27')
          AND SC5.%notDel%
          AND SF2.%notDel%
          AND SC6.%notDel%
          AND SD2.%notDel%
          AND DA1.%notDel%)
       //GROUP BY SD2.D2_XBSHELF, SB1.B1_ISBN, SB1.B1_DESC, nvl(DA1.DA1_PRCVEN, 0), ((nvl(DA1.DA1_PRCVEN, 0)*0.50)*0.06) / %Exp:_cParm3%)
GROUP BY ISBN, DESCRICAO, PRECO 
ORDER BY D2_TOTAL DESC

	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)