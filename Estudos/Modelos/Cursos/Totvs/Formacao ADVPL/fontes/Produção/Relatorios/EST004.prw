#include "protheus.ch"
#include "topconn.ch"  
#Include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEST004    บAutor  ณErica Vieites       บ Data ณ  12/12/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio RASTREAMENTO DAS ENTREGAS TOTAL EXPRESS           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGEN - Faturamento                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EST004()             
                                           

Local oReport                           
Local cPerg := "EST004"    
//Private cUsers := GetMV("GEN_REL001") 	

                       
//If !RetCodUsr() $ cUsers //Usuarios sem premissao
//	MsgBox("Voc๊ nใo tem permissใo para emitir este relat๓rio.","Aten็ใo",)
//	Return()
//EndIf

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



PutSx1(cPerg, "01", "Dt Inicial de:", "Dt Inicial de:" ,"Dt Inicial de:", "mv_ch1" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt FInal at้:", "Dt Final at้","Dt Final at้", "mv_ch2" , "D", 8, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","") 
PutSx1(cPerg, "03", "Pedido Protheus:", "Pedido Protheus","Pedido Protheus", "mv_ch3" , "C", 6, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Nota Fiscal:", "Nota Fiscal","Nota Fiscal", "mv_ch4" , "C", 9, 0, 0, "G","", "", "", "", "MV_PAR04","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "05", "S้rie:", "S้rie","S้rie", "mv_ch5" , "C", 1, 0, 0, "G","", "", "", "", "MV_PAR05","","","","","","","","","","","","","","","","")




/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

//Declaracao do relatorio
oReport := TReport():New("EST004","EST004 - RASTREAMENTO DAS ENTREGAS TOTAL EXPRESS",cPerg,{|oReport| PrintReport(oReport)},"EST004 - RASTREAMENTO DAS ENTREGAS TOTAL EXPRESS")

//Ajuste nas definicoes
oReport:nLineHeight := 50
oReport:cFontBody 	:= "Courier New"
oReport:nFontBody 	:= 9    		&& 10
oReport:lHeaderVisible := .T.  

//Secao do relatorio
oSection1 := TRSection():New(oReport,"Faturamento","SD2")

//Celulas da secao
TRCell():New(oSection1,"AWB"	     	,"","AWB",,15)
TRCell():New(oSection1,"D2_DOC"	     	,"SD2","Nota Fiscal",,20)
TRCell():New(oSection1,"D2_SERIE"	    ,"SD2","S้rie",,10)               
TRCell():New(oSection1,"C6_NUM"	        ,"SC6","Pedido Protheus",,25)
TRCell():New(oSection1,"D2_PRCVEN"  	,"SD2","Valor Notas",,20)
TRCell():New(oSection1,"D2_EMISSAO" 	,"SD2","Data",,20)     
TRCell():New(oSection1,"HORA_STATUS"	,"","Hora",,15)         
TRCell():New(oSection1,"DESCRICAO"  	,"","Descri็ใo",,60)

//Totalizadores
//TRFunction():New(oSection1:Cell("D1_TOTAL")		,NIL,"SUM")
//TRFunction():New(oSection1:Cell("D2_VALBRUT")	,NIL,"SUM")                                         

//Faz a impressao do totalizador em linha
//oSection1:SetTotalInLine(.f.)
//oReport:SetTotalInLine(.f.)


Return oReport


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cSQL		:= ""   					//Filtros variแveis da query

_cParm1 := DTOS(MV_PAR01)
_cParm2 := DTOS(MV_PAR02)


//Monta filtros da query

If !Empty(MV_PAR01)  
	//_cSQL += " AND TO_CHAR(I32.DATA_STATUS,'YYYYMMDD') BETWEEN '"+_cParm1+"' AND '"+_cParm2+"'
	_cSQL += " AND I32.DATA_STATUS BETWEEN TO_DATE('"+_cParm1+"', 'yyyymmdd') AND TO_DATE('"+_cParm2+"', 'yyyymmdd')"
Endif  

If !Empty(MV_PAR03) 
	_cSQL += " AND I32.PEDIDO = '"+MV_PAR03+"'
Endif  

If !Empty(MV_PAR04) 
	_cSQL += " AND I32.NOTA_FISCAL = '"+MV_PAR04+"'
Endif  

If !Empty(MV_PAR05) 
	_cSQL += " AND I32.SERIE = '"+MV_PAR05+"'
Endif 


_cSQL := "%" + _cSQL + "%" 

  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1  


	SELECT I32.AWB,
    	   I32.NOTA_FISCAL D2_DOC,
	       I32.SERIE D2_SERIE,
    	   I32.PEDIDO C6_NUM,
    	   I32.VALOR_NOTA D2_PRCVEN,
    	   I32.DATA_STATUS D2_EMISSAO,
    	   I32.HORA_STATUS,
    	   I32.DESCRICAO
	 FROM DBA_EGK.TT_I32_TRACKING I32
	 WHERE I32.STATUS = I32.STATUS
    
    %exp:_cSQL%
    
	ORDER BY I32.DATA_STATUS, I32.HORA_STATUS
	
	
	
	EndSql			
End Report Query oSection1

//Efetua impressใo
oSection1:Print()

Return(.t.)