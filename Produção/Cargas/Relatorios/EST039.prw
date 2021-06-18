#include "protheus.ch"
#include "topconn.ch"

/*/
Função: EST039

Descrição: Relatório de Romaneio x Pedido x Pedido Web x Nota fiscal

Alterações Realizadas:
02/08/2016 - Rafael Leite - Construção inicial

/*/

User Function EST039()             

Local oReport
Local cPerg := "EST039"

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
aHelpPor 	:= {}
AADD(aHelpPor,cTitPer)
AADD(aHelpPor,"Obrigatorio ser informado.    ")

cItPerg	:= Soma1(cItPerg)
cMVCH	:= "MV_CH" + Soma1(Right(cMVCH,1))
cMVPAR	:= "MV_PAR" + Soma1(Right(cMVPAR,2))

PutSx1(cPerg, cItPerg, "Dt Emissão de:", "Dt Emissão de:" ,"Dt Emissão de:",  cMVCH , "D", 8, 0, 0, "G","", "", "", "", cMVPAR,"","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return

/*
Funcao: ReportDef()

Descricao: Cria a estrutura do relatorio

*/
Static Function ReportDef(cPerg)

Local oReport

oReport := TReport():New("EST039","Listagem de Romaneios",cPerg,{|oReport| PrintReport(oReport)},"Listagem de Romaneios",.T.)

oSection1 := TRSection():New(oReport,"Romaneios","")

TRCell():New(oSection1,"ROMANEIO"	     	,"","Romaneio"        ,,15) 
TRCell():New(oSection1,"PEDPROTHEUS"	   	,"","Pedido Protheus" ,,15) 
TRCell():New(oSection1,"PEDWEB"	   			,"","Pedido Web"      ,,15) 
TRCell():New(oSection1,"PEDCLIENTE"	   		,"","Pedido Cliente"  ,,15) 
TRCell():New(oSection1,"NOTAFISCAL"	   		,"","Nota Fiscal"     ,,15) 
TRCell():New(oSection1,"EMISPEDIDO"	   		,"","Emissao Pedido"  ,,15) 
TRCell():New(oSection1,"EMISROMANEIO"	   	,"","Emissao Roma."   ,,15)  

Return oReport
                                                                          
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)
Local cAlias1	:= GetNextAlias() 
Local _cSQL		:= ""   					//Filtros variáveis da query
  
//Cria query
Begin Report Query oSection1
	BeginSQL Alias cAlias1 
		SELECT
		  D04_NR_ROMANEIO ROMANEIO,
		  C5_NUM PEDPROTHEUS,
		  SC5.C5_XPEDWEB PEDWEB,
		  C5_XPEDCLI PEDCLIENTE,
		  C5_NOTA NOTAFISCAL,
		  STOC(SC5.C5_EMISSAO) EMISPEDIDO,  
		  D04_DT_EMISSAO EMISROMANEIO
		FROM
		  GUA_PEDIDOS.DPS_D04_ROMANEIO ROMA
		JOIN TOTVS.SC5000 SC5
		ON
		  C5_FILIAL           = '1022'
		AND TO_NUMBER(C5_NUM) = D04_NR_PEDIDO
		AND TO_CHAR(D04_DT_EMISSAO,'YYYYMMDD') = %Exp:DtoS(MV_PAR01)%
		AND SC5.D_E_L_E_T_   <> '*'   
		ORDER BY ROMANEIO
 	EndSql			
End Report Query oSection1  

oSection1:Print()

Return(.t.)