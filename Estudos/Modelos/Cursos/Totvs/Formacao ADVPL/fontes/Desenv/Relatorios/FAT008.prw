#include "protheus.ch"
#include "topconn.ch"  
#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT008    บAutor  ณErica Vieites       บ Data ณ  23/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de Comissใo Por Vendedor                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FAT008()             
                                           

Local oReport                           
Local cPerg := "FAT008"    
Private cUsers := GetMV("GEN_REL001") 	

                       
If !RetCodUsr() $ cUsers //Usuarios sem premissao
	MsgBox("Voc๊ nใo tem permissใo para emitir este relat๓rio.","Aten็ใo",)
	Return()
EndIf

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
cCpoPer := "A1_VEND"                	
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

Putsx1(cPerg, cItPerg, cTitPer, cTitPer, cTitPer, cMVCH, cTpoCpo,nTamPer,0,0,cTpoPer,"vazio() .or. existcpo('SA3')",cF3Perg,"","",cMVPAR,cOpc1,"","","",cOpc2,"","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

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
oReport := TReport():New("GER032","GER032 - Comissใo + Descanso Semanal Remunerado (DSR)",cPerg,{|oReport| PrintReport(oReport)},"GER032 - Comissใo + Descanso Semanal Remunerado (DSR)")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"A3_COD"		    ,"SA3")
TRCell():New(oSection1,"A3_NOME"		,"SA3")
TRCell():New(oSection1,"D1_TOTAL"		,"SD1","Venda Liq. ((-) Dev.)",,15)
TRCell():New(oSection1,"A3_COMIS"	   	,"SA3")
TRCell():New(oSection1,"D2_VALBRUT"	 	,"SD2","Valor Comissใo",,15)

//Totalizadores
TRFunction():New(oSection1:Cell("D1_TOTAL")		,NIL,"SUM")
TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")                                         

//Faz a impressao do totalizador em linha
oSection1:SetTotalInLine(.f.)
oReport:SetTotalInLine(.f.)


Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cSQL		:= ""   					//Filtros variแveis da query

_cParm2 := DTOS(MV_PAR02)
_cParm3 := DTOS(MV_PAR03)


//Monta filtros da query
//mv_par01 - A1_VEND
If !Empty(MV_PAR01)
	_cSQL += " AND SA1.A1_VEND = '"+MV_PAR01+"'
Endif 

_cSQL := "%" + _cSQL + "%" 

  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  


SELECT SA3.A3_COD AS A3_COD
      , SA3.A3_NOME AS A3_NOME
	  , SUM(VALORVENDA-VALORDEV) AS D1_TOTAL
      , SA3.A3_COMIS AS A3_COMIS
	  , SUM(VALORVENDA-VALORDEV)*SA3.A3_COMIS/100 AS D2_VALBRUT
      FROM (SELECT D2_CLIENTE CLIENTE, D2_LOJA LOJA, NVL(SUM(D2_VALBRUT), 0) VALORVENDA, 0 VALORDEV
		      FROM  %table:SD2% SD2, %table:SB1% SB1
             WHERE SD2.D2_COD = SB1.B1_COD
               AND D2_TES IN (SELECT F4_CODIGO FROM  %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'S' AND %notDel%)
               AND D2_FILIAL  = %xFilial:SD2%  
			   AND B1_FILIAL  = %xFilial:SB1%
               AND D2_TIPO NOT IN ('D','B')
			   AND B1_XIDTPPU <> ' '
               AND SD2.%notDel%
			   AND SB1.%notDel%
               AND D2_EMISSAO BETWEEN %Exp:_cParm2%  AND %Exp:_cParm3%
             GROUP BY D2_CLIENTE, D2_LOJA
			UNION ALL
			SELECT D1_FORNECE, D1_LOJA,0, NVL(SUM(D1_TOTAL - D1_VALDESC), 0)
			  FROM %table:SD1% SD1, %table:SB1% SB1
             WHERE SD1.D1_COD = SB1.B1_COD
               AND D1_TES IN (SELECT F4_CODIGO FROM %table:SF4% WHERE F4_DUPLIC = 'S' AND F4_TIPO = 'E' AND %notDel%)
               AND D1_FILIAL  = %xFilial:SD1%  
			   AND B1_FILIAL  = %xFilial:SB1%
               AND D1_TIPO = 'D'
			   AND B1_XIDTPPU <> ' '
               AND SD1.%notDel%
               AND SB1.%notDel%
               AND D1_DTDIGIT BETWEEN %Exp:_cParm2%  AND %Exp:_cParm3%
             GROUP BY D1_FORNECE, D1_LOJA)D, %table:SA1% SA1, %table:SA3% SA3
  where SA1.A1_COD = D.CLIENTE
    AND SA1.A1_LOJA = D.LOJA
    and SA3.A3_COD = SA1.A1_VEND
    AND SA3.%notDel%
    AND SA1.%notDel%
    
    %exp:_cSQL%
    
	GROUP BY SA3.A3_COD, SA3.A3_NOME, SA3.A3_COMIS
	ORDER BY A3_NOME
	
	
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)