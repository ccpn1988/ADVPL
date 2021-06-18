#include "protheus.ch"
#include "topconn.ch"

/*/
FUNCAO: FAT002N

DESCRICAO: RELATORIO DE FATURAMENTO POR CLIENTE

ALTERACOES:
11/02/2015 - Desenvolvimento do fonte

/*/

User Function FAT002            

Local oReport
Local cPerg := "FAT002"

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

Parametros:
- cPar1 - codigo do grupo de perguntas
------------------------------------------------------------------------------------------------
Alteracoes:
11/02/2015 - Rafael Leite - Criacao do fonte
*/
Static Function f001(cPerg)

PutSx1(cPerg, "01", "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt Emissão até:", "Dt Emissão até","Dt Emissão até", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
//Putsx1(cPerg, "03", "Gerar em Excel?", "Gerar em Excel?" , "Gerar em Excel?" , "mv_ch3" , "N" , 01 , 0 , 1 , "C" , "" , "   ", "" , "" , "mv_par03" ,"Sim","Si","Yes","","Nao","No","No","","","","")

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
oReport := TReport():New("FAT005","FAT005 - Faturamento por Cliente",cPerg,{|oReport| PrintReport(oReport)},"FAT005 - Faturamento por Cliente")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  
oReport:lDisableOrientation := .T.  
oReport:SetLandscape()    

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","")
	
//Celulas da secao
TRCell():New(oSection1,"F2_CLIENTE"		,"SF2",,,10)
TRCell():New(oSection1,"F2_LOJA"		,"SF2",,,5)
TRCell():New(oSection1,"A1_NOME"		,"SA1",,,40) 
TRCell():New(oSection1,"QUANT"			,"","Qtde","@E 9,999,999",12,,,,,"RIGHT")
TRCell():New(oSection1,"D2_VALBRUT"		,"SD2","Liquido",,20,,,,,"RIGHT") 
TRCell():New(oSection1,"QTDE"			,"","Qtde Dev.","@E 9,999,999",17,,,,,"RIGHT")
TRCell():New(oSection1,"D2_TOTAL"		,"SD2","Liquido Dev.",,20,,,,,"RIGHT")
TRCell():New(oSection1,"A1_EST"			,"SA1",,,5) 
TRCell():New(oSection1,"CC2_MUN"		,"CC2",,,20) 
TRCell():New(oSection1,"A1_XTIPCLI"		,"SA1",,,20)
TRCell():New(oSection1,"A1_XCANALV"		,"SA1",,,20)
TRCell():New(oSection1,"A3_NOME"		,"SA3","Vendedor",,20)

//Totalizadores
TRFunction():New(oSection1:Cell("QUANT")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")
TRFunction():New(oSection1:Cell("QTDE")	    	,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_TOTAL")   	,NIL,"SUM")

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)

Return oReport

/*
Funcao: PrintReport()

Descricao: Gera dados para o relatorio

------------------------------------------------------------------------------------------------
Alteracoes:
29/01/2015 - Rafael Leite - Criacao do fonte
*/
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias()
Local _cSQL		:= ""   					//Filtros variáveis da query

//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1 

select decode(trim(sa1.a1_xcanalv), '3', '9999999', fat.cliente) as f2_cliente,
       decode(trim(sa1.a1_xcanalv), '3', '99', fat.loja) as f2_loja,
       decode(trim(sa1.a1_xcanalv), '3', '  ', sa1.a1_est) as a1_est,
       decode(trim(sa1.a1_xcanalv), '3', '  ', cc2.cc2_mun) as cc2_mun,
       decode(trim(sa1.a1_xcanalv), '3', 'CONSUMIDOR FINAL', sa1.a1_nome) as a1_nome,
       sx52.x5_descri as a1_xtipcli,
       sx5.x5_descri as a1_xcanalv,
       sa3.a3_nome,
       sum(fat.qtde) as quant,
       sum(fat.liquido) as d2_valbrut,
       nvl(sum(dev.qtde),0) as qtde,
       nvl(sum(dev.liq),0) as d2_total
   from (select cliente, loja, sum(qtde) qtde, sum(liquido) liquido
           from (select sd2.d2_cliente cliente, sd2.d2_loja loja, nvl(sum(case when sb1.b1_xidtppu in ('11','15') then 0 else sd2.d2_quant end), 0) qtde, nvl(sum(sd2.d2_valbrut), 0) liquido
                   from %table:SD2% sd2, %table:SB1% sb1
                  where sd2.d2_cod = sb1.b1_cod
                    and sd2.d2_tes in (select f4_codigo from %table:SF4% where f4_duplic = 'S' and f4_tipo = 'S' and %notDel% )
                    and sd2.d2_filial  = %xFilial:SD2%
                    and sb1.b1_filial  = %xFilial:SB1%
                    and sd2.d2_tipo not in ('D','B')
                    and sb1.b1_xidtppu <> ' '
                    and sd2.d2_emissao between %Exp:dtos(mv_par01)% and %Exp:dtos(mv_par02)%
                    and sd2.%notDel%  
                    and sb1.%notDel%  
                  group by sd2.d2_cliente, sd2.d2_loja
                 union all
                 select sd1.d1_fornece, sd1.d1_loja, nvl(sum(sd1.d1_quant),0)*(-1), nvl(sum(sd1.d1_total - sd1.d1_valdesc), 0)*(-1)
                   from %table:SD1% sd1, %table:SB1% sb1
                  where sd1.d1_cod = sb1.b1_cod
                    and sd1.d1_tes in (select f4_codigo from %table:SF4% where f4_duplic = 'S' and f4_tipo = 'E' and %notDel% )
                    and sd1.d1_filial  = %xFilial:SD1%
                    and sb1.b1_filial  = %xFilial:SB1%
                    and sd1.d1_tipo = 'D'
                    and sb1.b1_xidtppu <> ' '
                    and sd1.D1_DTDIGIT between %Exp:dtos(mv_par01)% and %Exp:dtos(mv_par02)%
                    and sb1.%notDel%  
                    and sd1.%notDel% 
                  group by sd1.d1_fornece, sd1.d1_loja)
          group by cliente, loja) fat,
           (select sd1.d1_fornece cliente, sd1.d1_loja loja, nvl(sum(sd1.d1_quant),0) qtde, nvl(sum(sd1.d1_total - sd1.d1_valdesc), 0) liq
                   from %table:SD1% sd1, %table:SB1% sb1
                  where sd1.d1_cod = sb1.b1_cod
                    and sd1.d1_tes in (select f4_codigo from %table:SF4% where f4_duplic = 'S' and f4_tipo = 'E' and %notDel% )
                    and sd1.d1_filial  = %xFilial:SD1%
                    and sb1.b1_filial  = %xFilial:SB1%
                    and sd1.d1_tipo = 'D'
                    and sb1.b1_xidtppu <> ' '
                    and sd1.D1_DTDIGIT between %Exp:dtos(mv_par01)% and %Exp:dtos(mv_par02)%
                    and sb1.%notDel%  
                    and sd1.%notDel% 
                  group by sd1.d1_fornece, sd1.d1_loja)DEV,
        %table:SA1% sa1,
        %table:SX5% sx5,
        %table:SX5% sx52,
        %table:SA3% sa3,
        %table:CC2% cc2
   
  where sa1.a1_filial  = %xFilial:SA1%
    and fat.cliente = sa1.a1_cod
    and fat.loja = sa1.a1_loja
    and dev.cliente (+) = sa1.a1_cod 
    and dev.loja (+) = sa1.a1_loja
    and sa1.%notDel% 
    
    and SA3.A3_FILIAL  = %xFilial:SA3%
    and sa1.A1_VEND = sa3.A3_COD (+)
    and sa3.%notDel% 
    
    and sa1.a1_xcanalv = sx5.x5_chave
    and sa1.a1_xtipcli = sx52.x5_chave
    
    and sx5.x5_filial  = %xFilial:SX5%
    and sx5.x5_tabela = 'Z2'
    and sx5.%notDel% 
    
    and sx52.x5_filial  = %xFilial:SX5%
    and sx52.x5_tabela = 'TP'
    and sx52.%notDel% 
                       
    and cc2.cc2_filial = %xFilial:CC2%
    and sa1.a1_est     = cc2.cc2_est
    and sa1.a1_cod_mun = cc2.cc2_codmun
    and cc2.%notDel%
    
  group by decode(trim(sa1.a1_xcanalv), '3', '9999999', fat.cliente),
           decode(trim(sa1.a1_xcanalv), '3', '99', fat.loja),
		   decode(trim(sa1.a1_xcanalv), '3', '  ', sa1.a1_est),
           decode(trim(sa1.a1_xcanalv), '3', '  ', cc2.cc2_mun),
           decode(trim(sa1.a1_xcanalv), '3', 'CONSUMIDOR FINAL', sa1.a1_nome),
           sx52.x5_descri, sx5.x5_descri, sa3.a3_nome
  order by d2_valbrut desc
  
   	
	EndSql			
End Report Query oSection1

//Efetua impressão
oSection1:Print()

Return(.t.)