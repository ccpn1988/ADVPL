#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


#DEFINE nR4_MAT		01
#DEFINE nA2_TIPO   02
#DEFINE nA2_NOME   03
#DEFINE nA2_COD    04
#DEFINE nA2_LOJA   05
#DEFINE nA2_CGC    06
#DEFINE nR4_ANO    07
#DEFINE nTP_REND   08
#DEFINE nR4_CODRET 09
#DEFINE nJANE      10
#DEFINE nFEVE      11
#DEFINE nMARC      12
#DEFINE nABRI      13
#DEFINE nMAIO      14
#DEFINE nJUNH      15
#DEFINE nJULH      16
#DEFINE nAGOS      17
#DEFINE nSETE      18
#DEFINE nOUTU      19
#DEFINE nNOVE      20
#DEFINE nDEZE      21
#DEFINE nANO       22
#DEFINE nSITU      23
		
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR067   บAutor  ณCleuto Lima         บ Data ณ  31/07/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ relatorio de conferencia e Inconsist๊ncia da dirf          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENR067()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local oGFiDirf	:= nil
Local oGFiSE2	:= nil
Local oGAno		:= nil 
Local oDlg		:= nil
Local oOk		:= nil
Local oCodRet	:= nil
Local nOpca		:= 0
Local oFont		:= TFont():New("Arial",,10,,.T.)

Local cFilDirf	:= Space(Len(cFilant))
Local cFilSE2	:= Space(150)
Local cAnoDirf	:= Space(004)
Local nModel	:=  Aviso("Modelo", "Qual modelo deseja executar?", {"Inconsist.", "Conferencia"},3)
Local cTipo		:=  "0" //Aviso("Cod.Reten็ใo", "Qual Cod.Reten็ใo?", {"5952", "1708","0588"},3)


DEFINE MSDIALOG oDlg TITLE "Parametros" FROM 000,000 TO 200,540 PIXEL

oGFiDirf:= TGet():New(15,010,{|u| if( Pcount()>0, cFilDirf	:= u,cFilDirf ) },oDlg,020,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cFilDirf",,,,,,,"Filial Centralizadora.: ",1,oFont,CLR_RED )
oGAno	:= TGet():New(15,100,{|u| if( Pcount()>0, cAnoDirf	:= u,cAnoDirf ) },oDlg,020,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cAnoDirf",,,,,,,"Ano.: ",1,oFont,CLR_RED )

IF nModel == 2
	oCodRet := TComboBox():New(16, 135,{|u|if(PCount()>0,cTipo:=u,cTipo)},{" ","1=5952", "2=1708","3=0588"},30,30,oDlg,,{|| },,,,.T.,,,,,,,,,'cTipo','C๓d.Ret.: ',1,oFont,CLR_RED)
	oGFiSE2	:= TGet():New(45,10,{|u| if( Pcount()>0, cFilSE2	:= u,cFilSE2 ) },oDlg,200,010,"",,0,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F.,,"cFilSE2",,,,,,,"Filiais Mov.Financeiro.: ",1,oFont,CLR_RED )
	@ 51.5, 215 BUTTON oOk PROMPT "?" 	SIZE 015, 016 OF oDlg PIXEL  ACTION (cFilSE2 := xGetFil(),oGFiSE2:Refresh())
EndIf

DEFINE SBUTTON FROM 80, 190 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 230 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	
	Do Case
		Case nModel == 2 .AND. Val(cTipo) == 0
			MsgStop("C๓digo de reten็ใo nใo niformado!")
			Return nil
		Case Empty(cFilDirf)
			MsgStop("Filial Centralizadora nใo informada!")
			Return nil			
		Case Empty(cAnoDirf)
			MsgStop("Ano nใo niformado!")
			Return nil
		Case nModel == 2 .AND. Empty(cFilSE2)
			MsgStop("filiais do relatorio nใo informadas!")
			Return nil		
	EndCase
	
	IF nModel == 1
		Processa({|| ProcBase(cAnoDirf,Val(cTipo)) },"Analisando base, aguarde...")
	Else	
		Processa({|| ProcConf(cFilDirf,cAnoDirf,cFilSE2,Val(cTipo)) },"Analisando base, aguarde...")
	EndIf	
		
EndIf

Return nil   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR066   บAutor  ณMicrosiga           บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ProcBase(cAnoDirf)

Local cArquivo	:= "ANALISE_DIRF_"+cAnoDirf+"_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= GetTempPath()
Local lMail		:= .F.
Local cSheet	:= ""
Local cTable	:= ""

ProcRegua(0)

/**************************************************************************************/	
/* Cleuto - 11/09/2017 - desativado pois faz a mesma coisa que a query 3
cSheet	:= "COM TX - Nat. NรO Calc. PCC"
cTable	:= "Titulos COM TX mas natureza NรO calcula PCC"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
*/
/**************************************************************************************/	
/* Cleuto - 06/09/2017 - desativado pois agora para PCC vamos enviar apenas quem teve TX de PCC
cSheet	:= "S/TX-Nat.PCC-Campos DIRF Branco"
cTable	:= "Titulos SEM TX Natureza Calcula PCC e Campos DIRF em Branco/Nใo"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp2(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
*/
/**************************************************************************************/	
cSheet	:= "Com TX PCC-Nat.Nใo PCC"
cTable	:= "Titulos com DIRF = Nใo - Tem TX com DIRF = Sim - Natureza nใo calcula PCC"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp3(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/	
cSheet	:= "Nat.IRF - E2_BASEIRF = Branco (NF)"
cTable	:= "Titulos (NF) com calculo de IR e campo E2_BASEIRF em branco"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp4(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/

/*
QUANDO O TITULO NรO TEM TX E FOI BAIXADO OS CAMPOS E2_PRETPIS, E2_PRETCOF, E2_PRETCSL DEVEM ESTAR PREENCHIDOS
BUSCA TITULOS COM BAIXA MAS SEM TX DE IMPOSTOS E VERIFICA SE OS CAMPOS DE RETENวรO ESTรO COM STATUS DE PENDENTE DE RETENวAO
*/
/*
/* Cleuto - 06/09/2017 - desativado pois agora para PCC vamos enviar apenas quem teve TX de PCC
cSheet	:= "Corre็ใo Campos PRET"
cTable	:= "Corre็ใo dos campos E2_PRETPIS, E2_PRETCOF, E2_PRETCSL"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp5(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1,.T.,StrTran(cPath+cArquivo,"xls","sql"))
*/
/**************************************************************************************/
cSheet	:= "Nat.IRF-PJ-Sem TX-0588"
cTable	:= "Nat.Calcula IR ้ Pessoa Jur. Nใo tem TX e Tit.Com 0588"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp6(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1,.T.,StrTran(cPath+cArquivo+"_0588","xls","sql"))
/**************************************************************************************/
cSheet	:= "Tit.TX PF.DIRF = Nใo"
cTable	:= "Tit. de TX PF com DIRF = Nใo ou Cod.Ret. em Branco"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp7(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/
cSheet	:= "Tit.PF. com NAt.PJ 40101"
cTable	:= "Tit.PF. com Natureza PJ 40101"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp8(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/
cSheet	:= "Tit.PF.DIRF = Nใo Nat.IR"
cTable	:= "Tit.PF com DIRF = Nใo ou Cod.Ret. em Branco e Nat.Calc.IR"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp9(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/
cSheet	:= "Tit.PF.Nat.IR. DIF 0588"
cTable	:= "Tit.PF.Nat.Calc.IR e Cod.Ret <> 0588"

IncProc("Analisando "+cSheet)
cAliTmp1	:= xSqlTemp10(cAnoDirf)

xAddSheet(cSheet,cTable,oExcel,cAliTmp1)
/**************************************************************************************/


oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)
FreeObj(oExcel)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
oExcelApp:SetVisible(.T.)
FreeObj(oExcelApp)
		
Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp  บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ consulta titulos com TX mas natureza nใo calcula PCC       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script para titulos COM TX mas natureza NรO calcula PCC*/
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
	ED_PERCPIS /*"Nat.Percentual de PIS"*/,
	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
	ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
	ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
	SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
	/* campos dirf */
	E2_DIRF,E2_CODRET,
	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
	DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND (( SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% ) OR (SE2.E2_EMIS1 BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% AND SE2.E2_BAIXA = ' ' ))
	/* ANALISE DO CALCULO DE PCC */
	/*AND ( ( SED.ED_CALCCOF = 'S' AND SED.ED_CALCCSL = 'S' AND SED.ED_CALCPIS = 'S')   OR SED.ED_CALCIRF = 'S' )*/
	AND ( SED.ED_CALCCOF = 'N' AND SED.ED_CALCCSL = 'N' AND SED.ED_CALCPIS = 'N' )
	/*AND ( SE2.E2_DIRF <> '1' OR SE2.E2_CODRET = ' ' )*/
	AND EXISTS(
	  SELECT * FROM %Table:SE2% TX
	  WHERE TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	  AND TX.E2_TIPO = 'TX'
	  AND TX.%NotDel%
	  AND TX.E2_NATUREZ = 'PCC'
	)
	ORDER BY E2_FILIAL
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR066   บAutor  ณMicrosiga           บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xGetFil()

Local cRetFil		:= ""
//Local cTmpSE2Fil	:= ""
Local aSelFil		:= {}

//Selecao de filiais
aSelFil := AdmGetFil(.F.,.T.,"SE2")

aEval(aSelFil, {|x| cRetFil+=x+";" } )

//cFilSel := GetRngFil( aSelFil, "SE2", .T. )

Return cRetFil	         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp2 บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta titulos sem TX mas natureza calcula PCC e campos   บฑฑ
ฑฑบ          ณE2_DIRF e E2_CODRET estใo em branco                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp2(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script para titulos sem TX mas natureza calcula PCC e IR e campos E2_DIRF = Nใo ou E2_CODRET = Branco*/
	SELECT DISTINCT
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
		CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
		CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
		CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
		CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
		CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
		ED_PERCPIS /*"Nat.Percentual de PIS"*/,
		CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
		ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
		CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
		ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
		SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
		CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
		/* campos dirf */
		E2_DIRF,E2_CODRET,
		E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
		E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
		DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND (( SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% ) OR (SE2.E2_EMIS1 BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% AND SE2.E2_BAIXA = ' ' ))
	/* ANALISE DO CALCULO DE PCC */
	AND ( SED.ED_CALCCOF = 'S' AND SED.ED_CALCCSL = 'S' AND SED.ED_CALCPIS = 'S')
	AND ( SE2.E2_DIRF <> '1' OR SE2.E2_CODRET = ' ' )
	AND NOT EXISTS(
	  SELECT * FROM %Table:SE2% TX
	  WHERE TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	  AND TX.E2_TIPO = 'TX'
	  AND TX.%NotDel%
	  AND TX.E2_NATUREZ = 'PCC'
	)
	ORDER BY E2_FILIAL
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp3 บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de titulos com DIRF = Nใo mas tem TX com DIRF = Sim บฑฑ
ฑฑบ          ณe natureza nใo calcula PCC  	                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp3(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script  analise de titulos com DIRF = Nใo mas tem TX com DIRF = Sim e natureza nใo calcula PCC */
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
		CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
		CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
		CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
		CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
		CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
		ED_PERCPIS /*"Nat.Percentual de PIS"*/,
		CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
		ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
		CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
		ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
		SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
		CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
		/* campos dirf */
		E2_DIRF,E2_CODRET,
		E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
		E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
		DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND SA2.%NotDel%
	WHERE (( SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% ) OR (SE2.E2_EMIS1 BETWEEN %Exp:cDtIni% AND %Exp:cDtFim% AND SE2.E2_BAIXA = ' ' ))
	/* ANALISE DO CALCULO DE PCC */
	AND ( ( SED.ED_CALCCOF = 'N' AND SED.ED_CALCCSL = 'N' AND SED.ED_CALCPIS = 'N')   )
	AND EXISTS(
	  SELECT * FROM %Table:SE2% TX
	  WHERE TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	  AND TX.E2_TIPO = 'TX'
	  AND TX.%NotDel%
	  AND TX.E2_DIRF = '1'
	  AND TX.E2_CODRET <> ' '
	  and TX.E2_NATUREZ = 'PCC'
	)
	AND SE2.%NotDel%
	ORDER BY E2_FILIAL
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp3 บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de titulos com DIRF = Nใo mas tem TX com DIRF = Sim บฑฑ
ฑฑบ          ณe natureza nใo calcula PCC  	                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp4(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* script para mapeamento de titulos com natureza que calcula IR e campo E2_BASEIR em branco */
	SELECT
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
			CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
			CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
			CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
			CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
			/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
			CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
			ED_PERCPIS /*"Nat.Percentual de PIS"*/,
			CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
			ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
			CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
			ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
			SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
			CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
			/* campos dirf */
			E2_DIRF,E2_CODRET,
			E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
			E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
			DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SF1% SF1
	JOIN %Table:SE2% SE2
	ON E2_FILIAL = F1_FILIAL
	AND E2_NUM = SF1.F1_DUPL
	AND SE2.E2_PREFIXO = SF1.F1_PREFIXO
	AND SE2.E2_FORNECE = SF1.F1_FORNECE
	AND SE2.E2_LOJA = F1_LOJA
	AND SE2.%NotDel%
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SD1% SD1
	ON D1_DOC = F1_DOC
	AND D1_SERIE = F1_SERIE
	AND SD1.D1_FORNECE = SF1.F1_FORNECE
	AND D1_LOJA = F1_LOJA
	AND D1_FILIAL = F1_FILIAL
	AND SD1.%NotDel%
	JOIN %Table:SF4% SF4
	ON F4_CODIGO = D1_TES
	AND SF4.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = F1_FORNECE
	AND A2_LOJA = F1_LOJA
	AND SA2.%NotDel%
	WHERE SF1.%NotDel%
	AND SF1.F1_DTDIGIT BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%
	/* ANALISE DO CALCULO DE IR */
	AND SED.ED_CALCIRF = 'S'
	AND SE2.E2_BASEIRF = 0
	AND SE2.E2_DIRF = '1'
	AND SE2.E2_CODRET <> ' '
	ORDER BY F1_FILIAL,F1_DTDIGIT
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp3 บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de titulos com DIRF = Nใo mas tem TX com DIRF = Sim บฑฑ
ฑฑบ          ณe natureza nใo calcula PCC  	                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp5(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* script para mapeamento de titulos com natureza que calcula IR e campo E2_BASEIR em branco */
	SELECT
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
			CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
			CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
			CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
			CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
			/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
			CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
			ED_PERCPIS /*"Nat.Percentual de PIS"*/,
			CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
			ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
			CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
			ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
			SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
			CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
			/* campos dirf */
			E2_DIRF,E2_CODRET,
			E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
			E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
			/*'UPDATE TOTVS.SE2000 SET E2_PRETPIS = '||''''||'1'||''''||',E2_PRETCOF = '||''''||'1'||''''||',E2_PRETCSL = '||''''||'1'||''''||' WHERE R_E_C_N_O_ = '||SE2.R_E_C_N_O_||';' SCRIPT*/
			SE2.R_E_C_N_O_ RECSE2,'5' ORISCRI,
			DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2   
	  JOIN %Table:SA2% SA2     
	  ON SE2.E2_FORNECE = SA2.A2_COD   
	  AND SE2.E2_LOJA  = SA2.A2_LOJA    
	  AND SA2.%NotDel%  
	  LEFT JOIN %Table:SED% SED    
	  ON SE2.E2_NATUREZ = SED.ED_CODIGO   
	  AND SED.%NotDel%    
	WHERE SE2.%NotDel%     
	AND SA2.A2_TIPO = 'J'   
	AND SA2.A2_EST <> 'EX'   
	AND A2_CGC <> ' '
	AND SE2.E2_DIRF = '1'
	AND E2_TIPO NOT IN ('TX')
	AND E2_PREFIXO NOT IN ('FGT')
	
	/* FILTRO PARA ANALISE */
	AND SE2.E2_EMISSAO BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%  
	/* NATUREZA CALCULA PCC */
	AND ED_CALCPIS = 'S' AND ED_CALCCOF = 'S' AND ED_CALCCSL = 'S'
	/* CAMPOS DE CONTROLE DE RETENวรO DIFERENTE DE PENDENTE DE RETENวรO */
	AND NOT (SE2.E2_PRETPIS IN ('1') AND SE2.E2_PRETCOF IN ('1') AND SE2.E2_PRETCSL IN ('1') )
	/* NรO TEVE TX PARA O TITULO */
	AND NOT EXISTS(
	  SELECT 1 FROM %Table:SE2% TX
	  WHERE TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	  AND TX.E2_TIPO  = 'TX'
	  AND TX.E2_NATUREZ IN ('PIS       ','COFINS    ','CSLL      ','PCC       ')
	  AND TX.%NotDel% 
	)
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp6 บAutor  ณCleuto              บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAnalise de titulos com natureza de IRF de passoa Juridica   บฑฑ
ฑฑบ          ณe titulos sem TX de IR mas cmo codigo 0588 no titulo PAI    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp6(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 

BeginSql Alias cAliTmp 
	/* Script para titulos COM TX mas natureza NรO calcula PCC*/
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
	ED_PERCPIS /*"Nat.Percentual de PIS"*/,
	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
	ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
	ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
	SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
	/* campos dirf */
	E2_DIRF,E2_CODRET,
	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
	SE2.R_E_C_N_O_ RECSE2,'6' ORISCRI,
	DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND A2_TIPO = 'J'
	AND E2_TIPO <> 'TX'
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND SE2.E2_EMISSAO BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%
	/*AND SED.ED_CALCIRF = 'S'*/
	AND E2_CODRET = '0588'
	AND NOT EXISTS(
	  SELECT * FROM %Table:SE2% TX
	  WHERE TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	  AND TX.E2_TIPO = 'TX'
	  AND TX.%NotDel%
	)
	ORDER BY E2_FILIAL
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp7 บAutor  ณMicrosiga           บ Data ณ  09/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ titulos de TX 0588 cim dirf = nใo                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xSqlTemp7(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script  analise de titulos com DIRF = Nใo mas tem TX com DIRF = Sim e natureza nใo calcula PCC */
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
		CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
		CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
		CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
		CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
		/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
		CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
		ED_PERCPIS /*"Nat.Percentual de PIS"*/,
		CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
		ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
		CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
		ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
		SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
		CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
		/* campos dirf */
		TX.E2_DIRF,TX.E2_CODRET,
		TX.E2_BASEIRF,TX.E2_VALOR,TX.E2_NATUREZ,	
		TX.E2_NUM,TX.E2_PREFIXO,TX.E2_PARCELA,TX.E2_FILIAL,SA2.A2_COD E2_FORNECE,SA2.A2_LOJA E2_LOJA,SA2.A2_NOME E2_NOMFOR,TX.E2_EMISSAO,TX.E2_EMIS1,TX.E2_BAIXA,TX.E2_VENCREA,SED.ED_DESCRIC,
		DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND A2_TIPO = 'F'
	AND SA2.%NotDel%
	JOIN %Table:SE2% TX
	ON TX.E2_TITPAI = SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA
	AND TX.E2_TIPO = 'TX'
	AND TX.%NotDel%
	AND ( TX.E2_DIRF <> '1' OR TX.E2_CODRET = ' ' )
	AND TX.E2_NATUREZ = 'IRF'		
	WHERE SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%
	AND ED_CALCIRF = 'S'
	AND SE2.%NotDel%
	ORDER BY E2_FILIAL
EndSql

(cAliTmp)->(DbgoTop())

Return cAliTmp     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSqlTemp8 บAutor  ณMicrosiga           บ Data ณ  09/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ titulo PF com natureza PJ                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xSqlTemp8(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script para titulos COM TX mas natureza NรO calcula PCC*/
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
	ED_PERCPIS /*"Nat.Percentual de PIS"*/,
	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
	ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
	ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
	SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
	/* campos dirf */
	E2_DIRF,E2_CODRET,
	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
	SE2.R_E_C_N_O_ RECSE2,'6' ORISCRI,
	DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND A2_TIPO = 'F'
	AND E2_TIPO <> 'TX'
	AND E2_NATUREZ = '40101'
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%
	/*AND SED.ED_CALCIRF = 'S'*/
	/*AND E2_CODRET = '0588'*/
	ORDER BY E2_FILIAL
EndSql


(cAliTmp)->(DbgoTop())

Return cAliTmp 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR067   บAutor  ณMicrosiga           บ Data ณ  09/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp9(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script para titulos COM TX mas natureza NรO calcula PCC*/
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
	ED_PERCPIS /*"Nat.Percentual de PIS"*/,
	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
	ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
	ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
	SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
	/* campos dirf */
	E2_DIRF,E2_CODRET,
	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
	SE2.R_E_C_N_O_ RECSE2,'6' ORISCRI,
	DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND A2_TIPO = 'F'
	AND E2_TIPO <> 'TX'
	AND E2_CODRET <> '0422'
	AND SED.ED_CALCIRF = 'S'
	AND ( E2_DIRF <> '1' OR E2_CODRET = ' ' )
	AND F_GET_TX_IR_PF(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,2) = 0
	AND E2_PRETIRF NOT IN ('2','3','4')	
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%	
	ORDER BY E2_FILIAL
EndSql


(cAliTmp)->(DbgoTop())

Return cAliTmp 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR067   บAutor  ณMicrosiga           บ Data ณ  09/11/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xSqlTemp10(cAno)

Local cAliTmp	:= GetNextAlias()
Local cDtIni	:= cAno+"0101"
Local cDtFim	:= cAno+"1231"
//Local cFilIn	:= FormatIn(MV_PAR07,";") 
 
BeginSql Alias cAliTmp 
	/* Script para titulos COM TX mas natureza NรO calcula PCC*/
	SELECT DISTINCT
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NO FORNECEDOR */
	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI /*"For.Recolhe COFINS"*/,
	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS /*"For.Recolhe PIS"*/,
	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL /*"For.Recolhe CSLL"*/,
	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF /*"For.Calcula IR"*/,
	/* CONFIGURAวรO DE CALCULO DO PCC/IR NA NATUREZA */
	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS /*"Nat.Calcula PIS"*/,
	ED_PERCPIS /*"Nat.Percentual de PIS"*/,
	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF /*"Nat.Calcula COFINS"*/,
	ED_PERCCOF /*"Nat.Percentual de COFINS"*/,
	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL /*"Nat.Calcula CSLL"*/,
	ED_PERCCSL /*"Nat.Percentual de CSLL"*/,
	SED.ED_PERCIRF /*"Nat.Percentual de  IR"*/,
	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF /*"Nat.Calcula IR"*/,
	/* campos dirf */
	E2_DIRF,E2_CODRET,
	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	
	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,SED.ED_DESCRIC,
	SE2.R_E_C_N_O_ RECSE2,'6' ORISCRI,
	DECODE(A2_TIPO, 'J', 'JURIDICO', 'F','FISICO' , 'X' , 'OUTROS' , A2_TIPO) A2_TIPO
	FROM %Table:SE2% SE2
	JOIN %Table:SED% SED
	ON ED_CODIGO = E2_NATUREZ
	AND SED.%NotDel%
	JOIN %Table:SA2% SA2
	ON A2_COD = E2_FORNECE
	AND A2_LOJA = E2_LOJA
	AND A2_TIPO = 'F'
	AND E2_TIPO <> 'TX'
	AND E2_CODRET <> '0588'
	AND SED.ED_CALCIRF = 'S'
	/*AND ( E2_DIRF <> '1' OR E2_CODRET = ' ' )*/
	AND F_GET_TX_IR_PF(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,2) = 0
	AND E2_PRETIRF NOT IN ('2','3','4')	
	AND SA2.%NotDel%
	WHERE SE2.%NotDel%
	AND SE2.E2_BAIXA BETWEEN %Exp:cDtIni% AND %Exp:cDtFim%	
	ORDER BY E2_FILIAL
EndSql


(cAliTmp)->(DbgoTop())

Return cAliTmp 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR066   บAutor  ณMicrosiga           บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xAddSheet(cSheet,cTable,oExcel,cAliAux,lScript,cFileScript)

Local cScript	:= ""

Default lScript	:= .F.

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)                                                                                         

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheet,cTable,"For.Recolhe COFINS"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"For.Recolhe PIS"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"For.Recolhe CSLL"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"For.Calcula IR"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Nat.Calcula PIS"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Nat.Percentual de PIS"		,3,2)
oExcel:AddColumn(cSheet,cTable,"Nat.Calcula COFINS"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Nat.Percentual de COFINS"	,3,2)
oExcel:AddColumn(cSheet,cTable,"Nat.Calcula CSLL"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Nat.Percentual de CSLL"	   	,3,2)
oExcel:AddColumn(cSheet,cTable,"Nat.Percentual de  IR"	   	,3,2)
oExcel:AddColumn(cSheet,cTable,"Nat.Calcula IR"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"DIRF"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Cod.Reten็ใo"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Valor Titulo"	   			,3,2)
oExcel:AddColumn(cSheet,cTable,"Base IRF"	   				,3,2)
oExcel:AddColumn(cSheet,cTable,"Natureza"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Descri็ใo"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Titulo"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Prefixo"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Parcela"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Filial"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Fornecedor"	   				,1,1)
oExcel:AddColumn(cSheet,cTable,"Loja"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Nome"	   					,1,1)
oExcel:AddColumn(cSheet,cTable,"Tipo Pessoa"	   			,1,1)
oExcel:AddColumn(cSheet,cTable,"Emissใo Real"	   			,2,1)
oExcel:AddColumn(cSheet,cTable,"Emissao Digitada"	   		,2,1)
oExcel:AddColumn(cSheet,cTable,"Baixa"	   					,2,1)
oExcel:AddColumn(cSheet,cTable,"Venc.Real"	   				,2,1)

(cAliAux)->(DbGotop())

While (cAliAux)->(!EOF())
	
	oExcel:AddRow(cSheet,cTable,{;
	(cAliAux)->A2_RECCOFI,;
	(cAliAux)->A2_RECPIS,;
	(cAliAux)->A2_RECCSLL,;
	(cAliAux)->A2_CALCIRF,;
	(cAliAux)->ED_CALCPIS,;
	(cAliAux)->ED_PERCPIS,;
	(cAliAux)->ED_CALCCOF,;
	(cAliAux)->ED_PERCCOF,;
	(cAliAux)->ED_CALCCSL,;
	(cAliAux)->ED_PERCCSL,;
	(cAliAux)->ED_PERCIRF,;
	(cAliAux)->ED_CALCIRF,;
	(cAliAux)->E2_DIRF,;
	(cAliAux)->E2_CODRET,;
	(cAliAux)->E2_BASEIRF,;
	(cAliAux)->E2_VALOR,;
	(cAliAux)->E2_NATUREZ,;
	(cAliAux)->ED_DESCRIC,;
	(cAliAux)->E2_NUM,;
	(cAliAux)->E2_PREFIXO,;
	(cAliAux)->E2_PARCELA,;
	(cAliAux)->E2_FILIAL,;
	(cAliAux)->E2_FORNECE,;
	(cAliAux)->E2_LOJA,;
	(cAliAux)->E2_NOMFOR,;
	(cAliAux)->A2_TIPO,;
	StoD((cAliAux)->E2_EMISSAO),;
	StoD((cAliAux)->E2_EMIS1),;
	StoD((cAliAux)->E2_BAIXA),;
	StoD((cAliAux)->E2_VENCREA);
	})
	
	If lScript
		If (cAliAux)->ORISCRI == '6'
			cScript+=	"UPDATE SE2000 SET E2_CODRET = ' ',E2_DIRF = '2' WHERE R_E_C_N_O_ = "+AllTrim(Str((cAliAux)->RECSE2))+";"+Chr(13)+Chr(10)
		EndIf
	EndIf
	
	(cAliAux)->(DbSkip())
EndDo

(cAliAux)->(DbCloseArea())

If !Empty(cScript) 
	MemoWrite(cFileScript,cScript)
EndIf

Return nil    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENR066   บAutor  ณMicrosiga           บ Data ณ  07/31/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcConf(cFilDirf,cAnoDirf,cFilSE2,nTipo)

Local cInCilf	:= ""
Local cDtIni	:= cAnoDirf+"0101"
Local cDtFim	:= cAnoDirf+"1231"
Local cAliTmp	:= GetNextAlias()
Local cRaizFil	:= Left(cFilDirf,2)

Local cArquivo	:= "ANALISE_DIRF_"+cAnoDirf+"_"+DtoS(DDataBase)+StrTran(Time(),":","")+".xls"
Local oExcel 	:= FWMSEXCEL():New()
Local cPath		:= GetTempPath()
Local lMail		:= .F.
Local cSheet	:= "DIRF x SE2"
Local cTable	:= " Dados DIRF (SR4) x Financeiro (SE2) "

Local cQuery	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local aDados	:= {} 
Local cCodRet	:= ""//IIF( nTipo == 1, "5952" , "1708" )

Default nTipo	:= 1


Do Case
	Case nTipo == 1
		cCodRet	:= "5952"
	Case  nTipo == 2
		cCodRet	:= "1708"
	Case  nTipo == 3
		cCodRet	:= "0588"
EndCase

If Right(cFilSE2,1) == ";"
	cInCilf := FormatIn(Left(cFilSE2,Len(cFilSE2)-1),";")
Else
	cInCilf := FormatIn(cFilSE2,";")
EndIf

ProcRegua(0)

Do Case
	Case nTipo == 1
		cE2field	:= "E2_BAIXA"
	Case  nTipo == 2
		cE2field	:= "E2_EMISSAO"
	Case  nTipo == 3
		cE2field	:= "E2_BAIXA"
EndCase

IncProc("Anlisando base, aguarde...")

cQuery+=" SELECT TMP.* " 
cQuery+=" FROM ("
cQuery+=" SELECT "
cQuery+="  R4_MAT,"
cQuery+="  CASE   "
cQuery+="    WHEN A2_TIPO = 'J' THEN 'JURIDICO'  "
cQuery+="    WHEN A2_TIPO = 'F' THEN 'FISICO'  "
cQuery+="    WHEN A2_TIPO = 'X' THEN 'OUTROS'  "
cQuery+="    ELSE A2_TIPO  "
cQuery+="  END A2_TIPO"
cQuery+="  ,A2_NOME,A2_COD,A2_LOJA,A2_CGC,R4_ANO,"
cQuery+="  CASE   "
cQuery+="    WHEN R4_TIPOREN = 'A' THEN '1 Rendimento Tributแvel'  "
cQuery+="    WHEN R4_TIPOREN = 'D' THEN '5 Imposto retido na fonte'  "
cQuery+="    WHEN R4_TIPOREN = 'T' THEN 'Dependentes'  "
cQuery+="    ELSE 'NรO CLASSIFICADO VERIFICAR COM TI'"
cQuery+="  END TP_REND /*Tipo de Rendimento*/,"
cQuery+="  R4_CODRET,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '01' THEN SR4.R4_VALOR ELSE 0 END) AS JANE,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '02' THEN SR4.R4_VALOR ELSE 0 END) AS FEVE,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '03' THEN SR4.R4_VALOR ELSE 0 END) AS MARC,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '04' THEN SR4.R4_VALOR ELSE 0 END) AS ABRI,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '05' THEN SR4.R4_VALOR ELSE 0 END) AS MAIO,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '06' THEN SR4.R4_VALOR ELSE 0 END) AS JUNH,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '07' THEN SR4.R4_VALOR ELSE 0 END) AS JULH,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '08' THEN SR4.R4_VALOR ELSE 0 END) AS AGOS,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '09' THEN SR4.R4_VALOR ELSE 0 END) AS SETE,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '10' THEN SR4.R4_VALOR ELSE 0 END) AS OUTU,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '11' THEN SR4.R4_VALOR ELSE 0 END) AS NOVE,"
cQuery+="  SUM(CASE WHEN SR4.R4_MES = '12' THEN SR4.R4_VALOR ELSE 0 END) AS DEZE,"
cQuery+="  SUM(SR4.R4_VALOR) ANO"
cQuery+=" FROM "+RetSqlName("SR4")+" SR4"
cQuery+=" JOIN "+RetSqlName("SRL")+" SRL"
cQuery+=" ON RL_FILIAL = R4_FILIAL"
cQuery+=" AND RL_MAT = R4_MAT"
cQuery+=" AND RL_CODRET = R4_CODRET"
cQuery+=" AND RL_CPFCGC = R4_CPFCGC"
cQuery+=" AND R4_TIPOREN NOT IN ('T')" 

If nTipo == 3
	cQuery+=" AND RL_TIPOFJ = '1'"
Else
	cQuery+=" AND RL_TIPOFJ = '2'"
EndIf

cQuery+=" AND SRL.D_E_L_E_T_ <> '*'"
cQuery+=" JOIN "+RetSqlName("SA2")+" SA2"
cQuery+=" ON A2_FILIAL = '"+xFilial("SA2")+"'"
cQuery+=" AND A2_CGC = SR4.R4_CPFCGC"
cQuery+=" AND SA2.D_E_L_E_T_ <> '*'"
cQuery+=" WHERE R4_FILIAL LIKE '"+cRaizFil+"%'"
cQuery+=" AND R4_ANO = '"+cAnoDirf+"'"
cQuery+=" AND R4_ORIGEM = '2'"
/* FILTRA O SA2 COM MOVIMENTO POIS EXISTEM FORNECEDORES DUPLICADOS NO CADASTRO SA2 */
cQuery+=" AND ( SELECT COUNT(*) FROM "+RetSqlName("SE2")+" SE2 WHERE E2_FILIAL LIKE SUBSTR(R4_FILIAL,1,2)||'%' AND E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA AND "+cE2field+" BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' AND SE2.D_E_L_E_T_ <> '*') > 0 "

If nTipo == 3
	cQuery+=" AND A2_TIPO = 'F'"
Else
	cQuery+=" AND A2_TIPO = 'J'"
EndIf	

cQuery+=" AND SR4.R4_CPFCGC <> ' '"
cQuery+=" and SR4.R4_CODRET = '"+cCodRet+"'"

cQuery+=" AND SR4.D_E_L_E_T_ <> '*'"
cQuery+=" GROUP BY R4_MAT,A2_TIPO,A2_NOME,A2_COD,A2_LOJA,A2_CGC,R4_ANO,R4_TIPOREN,R4_CODRET"
cQuery+=" UNION ALL" 
Do Case
	Case nTipo == 1
		cCampos	:= " /*E2_MULTA+*/ E2_DESCONT+E2_VRETPIS+ E2_VRETCOF+ E2_VRETCSL+ E2_INSS+ E2_IRRF+ E2_ISS+ E2_VALLIQ- CASE WHEN E2_PRETPIS = '3' AND E2_PRETCOF = '3' AND E2_PRETCSL = '3' THEN E2_MULTA ELSE E2_ACRESC END"
	Case  nTipo == 2
		cCampos	:= 'E2_BASEIRF'
	Case  nTipo == 3
		cCampos	:= 'E2_BASEIRF'//" /*E2_MULTA+*/ E2_DESCONT+E2_VRETPIS+ E2_VRETCOF+ E2_VRETCSL+ E2_INSS+ E2_IRRF+ E2_ISS+ E2_VALLIQ- CASE WHEN E2_PRETPIS = '3' AND E2_PRETCOF = '3' AND E2_PRETCSL = '3' THEN E2_MULTA ELSE E2_ACRESC END"
EndCase

cQuery+=" SELECT R4_MAT, A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, R4_ANO, TP_REND, R4_CODRET, SUM(JANE), SUM(FEVE), SUM(MARC), SUM(ABRI), SUM(MAIO), SUM(JUNH), SUM(JULH), SUM(AGOS), SUM(SETE), SUM(OUTU), SUM(NOVE), SUM(DEZE), SUM(ANO) FROM (" 
cQuery+=" SELECT 'SE2' R4_MAT, A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR("+cE2field+",1,4) R4_ANO, '1 Rendimento Tributแvel' TP_REND, '"+cCodRet+"' R4_CODRET, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN  "+cCampos+" ELSE 0 END) JANE, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN  "+cCampos+" ELSE 0 END) FEVE, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN  "+cCampos+" ELSE 0 END) MARC, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN  "+cCampos+" ELSE 0 END) ABRI, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN  "+cCampos+" ELSE 0 END) MAIO, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN  "+cCampos+" ELSE 0 END) JUNH, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN  "+cCampos+" ELSE 0 END) JULH, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN  "+cCampos+" ELSE 0 END) AGOS, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN  "+cCampos+" ELSE 0 END) SETE, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN  "+cCampos+" ELSE 0 END) OUTU, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN  "+cCampos+" ELSE 0 END) NOVE, " 
cQuery+=" SUM(CASE WHEN "+cE2field+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN  "+cCampos+" ELSE 0 END) DEZE, " 
cQuery+=" SUM( "+cCampos+") ANO" 
cQuery+=" FROM "+RetSqlName("SE2")+" SE2" 
cQuery+=" JOIN "+RetSqlName("SED")+" SED  " 
cQuery+=" ON SED.ED_FILIAL = '"+xFilial("SED")+"'" 
cQuery+=" AND E2_NATUREZ = SED.ED_CODIGO " 
cQuery+=" AND SED.D_E_L_E_T_ <> '*'" 
cQuery+=" JOIN "+RetSqlName("SA2")+" SA2 " 
cQuery+=" ON A2_FILIAL = '"+xFilial("SA2")+"'" 
cQuery+=" AND E2_FORNECE = A2_COD " 
cQuery+=" AND E2_LOJA  = A2_LOJA  " 
cQuery+=" AND SA2.D_E_L_E_T_ <> '*'" 
cQuery+=" WHERE E2_FILIAL IN "+cInCilf 

cQuery+=" AND "+cE2field+" BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	
If nTipo == 1 
	cQuery+=" AND ( SED.ED_CALCCOF = 'S' AND SED.ED_CALCCSL = 'S' AND SED.ED_CALCPIS = 'S') " 
	cQuery+=" AND ( F_GET_TX(E2_FILIAL,E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA,1) > 0 OR ( E2_PRETPIS IN ('2','3','4') AND E2_PRETCSL IN ('2','3','4') AND E2_PRETCOF IN ('2','3','4') ) )"
Else
	cQuery+=" AND SE2.E2_CODRET  NOT IN ('0422') "
	cQuery+=" AND SED.ED_CALCIRF = 'S' " 
	
	If nTipo == 2
		cQuery+=" AND ( F_GET_TX_IR(E2_FILIAL,E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA,1) > 0 OR E2_PRETIRF IN ('2','3','4') )"
	Else
		cQuery+=" AND ( F_GET_TX_IR_PF(E2_FILIAL,E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA,1) > 0 OR E2_PRETIRF IN ('2','3','4') OR ( "
			
		// incluido filtro 
		
	//	cQuery+="  	SE2.E2_PRETIRF IN ('6') AND EXISTS ("	
		cQuery+=" EXISTS ("	
		cQuery+=" SELECT 1 FROM "+RetSqlName("SE2")+" TXANO "
		cQuery+=" WHERE TXANO.E2_FILIAL IN "+cInCilf
		cQuery+=" AND TXANO.E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
		cQuery+=" AND TXANO.E2_TIPO = 'TX' "
		cQuery+=" AND TXANO.E2_TITPAI LIKE '%'||SE2.E2_FORNECE||SE2.E2_LOJA||'%' "
		cQuery+=" AND TXANO.E2_NATUREZ = 'IRF' " 
		cQuery+=" AND TXANO.E2_CODRET = '"+cCodRet+"' " 
		cQuery+=" AND TXANO.D_E_L_E_T_ <> '*' ) "
		cQuery+=" ) )" 
	EndIf
	      	
EndIf

cQuery+=" AND SE2.D_E_L_E_T_ <> '*'" 

Do Case
	Case nTipo == 1
		cQuery+=" AND A2_TIPO = 'J' " 
	Case  nTipo == 2
		cQuery+=" AND A2_TIPO = 'J' " 
	Case  nTipo == 3
		cQuery+=" AND A2_TIPO = 'F' " 
EndCase         

//cQuery+="	AND A2_EST <> 'EX' "  REMOVIDA VALIDAวรO DE EX POIS TEM CASOS ONDE O CPF/CNPJ FOI INFORMADO E COM ISSO ESTม INDO PARA DIRF
cQuery+=" AND SE2.D_E_L_E_T_ <> '*'" 
cQuery+=" AND E2_TIPO <> 'TX'" 
cQuery+=" GROUP BY A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR(E2_FILIAL,1,2), SUBSTR("+cE2field+",1,4) " 

/* TITULOS SEM TX */
If nTipo == 3 
	cQuery+=" UNION ALL" 
	If nTipo == 3 
		cE2IRFfield	:= "E2_BAIXA"
	Else	
		cE2IRFfield	:= "E2_EMISSAO"
	EndIf		
	cQuery+=" SELECT 'SE2' R4_MAT, A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR("+cE2IRFfield+",1,4) R4_ANO, '1 Rendimento Tributแvel' TP_REND, '"+cCodRet+"' R4_CODRET, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN E2_BASEIRF ELSE 0 END) JANE, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN E2_BASEIRF ELSE 0 END) FEVE, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN E2_BASEIRF ELSE 0 END) MARC, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN E2_BASEIRF ELSE 0 END) ABRI, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN E2_BASEIRF ELSE 0 END) MAIO, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN E2_BASEIRF ELSE 0 END) JUNH, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN E2_BASEIRF ELSE 0 END) JULH, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN E2_BASEIRF ELSE 0 END) AGOS, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN E2_BASEIRF ELSE 0 END) SETE, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN E2_BASEIRF ELSE 0 END) OUTU, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN E2_BASEIRF ELSE 0 END) NOVE, " 
	cQuery+=" SUM(CASE WHEN "+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN E2_BASEIRF ELSE 0 END) DEZE, " 
	cQuery+=" SUM(E2_BASEIRF) ANO" 
	cQuery+=" FROM "+RetSqlName("SE2")+" SE2" 
	cQuery+=" JOIN "+RetSqlName("SED")+" SED  " 
	cQuery+=" ON ED_FILIAL = '"+xFilial("SED")+"'" 
	cQuery+=" AND E2_NATUREZ = ED_CODIGO " 
	cQuery+=" AND SED.D_E_L_E_T_ <> '*'" 
	cQuery+=" JOIN "+RetSqlName("SA2")+" SA2 " 
	cQuery+=" ON A2_FILIAL = '"+xFilial("SA2")+"'" 
	cQuery+=" AND E2_FORNECE = A2_COD " 
	cQuery+=" AND E2_LOJA  = A2_LOJA  " 
	cQuery+=" AND SA2.D_E_L_E_T_ <> '*'" 
	cQuery+=" WHERE E2_FILIAL IN "+cInCilf 
	//cQuery+=" AND ( E2_BAIXA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' OR ( E2_BAIXA = ' ' AND E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' )  )  " 	
	cQuery+=" AND E2_BAIXA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	
	If nTipo == 1 
		cQuery+=" AND F_GET_TX(E2_FILIAL,E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA,1) = 0 " 
		cQuery+=" AND ( ED_CALCCOF = 'S' AND ED_CALCCSL = 'S' AND ED_CALCPIS = 'S') "  	
	Else                
		cQuery+=" AND SE2.E2_CODRET  NOT IN ('0422') "
		cQuery+=" AND ED_CALCIRF = 'S' AND SE2.E2_PRETIRF NOT IN ('2','3','4') " 
		cQuery+=" AND F_GET_TX_IR_PF(E2_FILIAL,E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA,1) = 0" 	
	EndIf
	cQuery+=" AND SE2.D_E_L_E_T_ <> '*'" 
	
	Do Case
		Case nTipo == 1
			cQuery+=" AND A2_TIPO = 'J' " 
		Case  nTipo == 2
			cQuery+=" AND A2_TIPO = 'J' " 
		Case  nTipo == 3
			cQuery+=" AND A2_TIPO = 'F' " 
	EndCase     
	
	//cQuery+="	AND A2_EST <> 'EX' "  REMOVIDA VALIDAวรO DE EX POIS TEM CASOS ONDE O CPF/CNPJ FOI INFORMADO E COM ISSO ESTม INDO PARA DIRF
	cQuery+=" AND E2_TIPO <> 'TX'" 
	
	If nTipo == 1
		cQuery+=" AND E2_BAIXA <> ' '" // pegas apenas titulos baixados pois segundo o alexandre deve ir apenas para 5952 na baixa e com isso gera a divergencia com a DIRF
	EndIf

	cQuery+="  	AND NOT EXISTS ("	
	cQuery+="	SELECT 1 FROM "+RetSqlName("SE2")+" TXANO "
	cQuery+="	WHERE TXANO.E2_FILIAL IN "+cInCilf
	cQuery+="	AND TXANO.E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	cQuery+="	AND TXANO.E2_TIPO = 'TX' "
	cQuery+="	AND TXANO.E2_TITPAI LIKE '%'||SE2.E2_FORNECE||SE2.E2_LOJA||'%' "
	cQuery+="	AND TXANO.E2_NATUREZ = 'IRF' " 
	cQuery+="	AND TXANO.E2_CODRET = '"+cCodRet+"' " 
	cQuery+="	AND TXANO.D_E_L_E_T_ <> '*' ) "
		
	cQuery+=" GROUP BY A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR("+cE2IRFfield+",1,4)" 

EndIf


/* consulta tx */
cQuery+=" UNION ALL" 
cQuery+="" 
cQuery+=" SELECT 'SE2' R4_MAT, A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR(PAI."+cE2field+",1,4) R4_ANO, '5 Imposto retido na fonte' TP_REND, '"+cCodRet+"' R4_CODRET, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) JANE, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) FEVE, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) MARC, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) ABRI, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) MAIO, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) JUNH, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) JULH, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) AGOS, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) SETE, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) OUTU, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) NOVE, " 
cQuery+=" SUM(CASE WHEN PAI."+cE2field+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END) DEZE, " 
cQuery+=" SUM(SE2.E2_VALOR+SE2.E2_INSS+SE2.E2_IRRF+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2."+cE2field+" <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END) ANO" 
cQuery+=" FROM "+RetSqlName("SE2")+" SE2" 
cQuery+=" JOIN "+RetSqlName("SE2")+" PAI " 
cQuery+=" ON SE2.E2_TITPAI = PAI.E2_PREFIXO||PAI.E2_NUM||PAI.E2_PARCELA||PAI.E2_TIPO||PAI.E2_FORNECE||PAI.E2_LOJA" 
cQuery+=" AND PAI.D_E_L_E_T_ <> '*'"   
cQuery+=" JOIN "+RetSqlName("SED")+" SED  "
cQuery+=" ON SED.ED_FILIAL = '"+xFilial("SED")+"'" 
cQuery+=" AND SE2.E2_NATUREZ = SED.ED_CODIGO " 
cQuery+=" AND SED.D_E_L_E_T_ <> '*'" 
cQuery+=" JOIN "+RetSqlName("SA2")+" SA2 " 
cQuery+=" ON A2_FILIAL = '"+xFilial("SA2")+"'" 
cQuery+=" AND PAI.E2_FORNECE = A2_COD " 
cQuery+=" AND PAI.E2_LOJA  = A2_LOJA  " 
cQuery+=" AND SA2.D_E_L_E_T_ <> '*'" 
cQuery+=" WHERE SE2.E2_FILIAL IN "+cInCilf 
cQuery+=" AND PAI."+cE2field+" BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'" 
//cQuery+="	AND F_GET_TX(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,2) = 0 "
//cQuery+="	AND ( SED.ED_CALCCOF = 'S' AND SED.ED_CALCCSL = 'S' AND SED.ED_CALCPIS = 'S') " 
cQuery+=" AND SE2.D_E_L_E_T_ <> '*'" 

Do Case
	Case nTipo == 1
		cQuery+=" AND A2_TIPO = 'J' " 
	Case  nTipo == 2
		cQuery+=" AND A2_TIPO = 'J' " 
	Case  nTipo == 3
		cQuery+=" AND A2_TIPO = 'F' " 
EndCase     

//cQuery+="	AND SA2.A2_EST <> 'EX' " REMOVIDA VALIDAวรO DE EX POIS TEM CASOS ONDE O CPF/CNPJ FOI INFORMADO E COM ISSO ESTม INDO PARA DIRF
cQuery+=" AND SE2.D_E_L_E_T_ <> '*'" 
cQuery+=" AND SE2.E2_TIPO = 'TX'" 
cQuery+=" AND SE2.E2_CODRET = '"+cCodRet+"'" 
//cQuery+="	AND SE2."+cE2field+" <> ' '" 
cQuery+=" GROUP BY A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, SUBSTR(PAI."+cE2field+",1,4)" 

cQuery+="	) TMP_SE2 GROUP  BY R4_MAT, A2_TIPO, A2_NOME, A2_COD, A2_LOJA, A2_CGC, R4_ANO, TP_REND, R4_CODRET" 
cQuery+="	" 
cQuery+="	) TMP" 
//cQuery+="	WHERE TP_REND  = '1 Rendimento Tributแvel'" 
//cQuery+="	ORDER BY A2_CGC,R4_ANO,A2_TIPO DESC,TP_REND" 
cQuery+=" ORDER BY A2_CGC,R4_ANO,TP_REND,A2_TIPO DESC" 


WfForceDir("\dirf_2017\"+cRaizFil+"\")
MemoWrite("\dirf_2017\"+cRaizFil+"\"+DtoS(DDataBase)+"_GENR067_"+StrTran(Time(),":","")+".sql",cQuery)

dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery), "TMP_PCC" ,.T.,.T.)

TMP_PCC->(DbGotop())

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable)                                                                                         

//Alinhamento da coluna ( 1-Left,2-Center,3-Right )  //Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )
oExcel:AddColumn(cSheet,cTable,"Origem"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Tipo"		   	,1,1)
oExcel:AddColumn(cSheet,cTable,"Nome"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"C๓digo"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Loja"		   	,1,1)
oExcel:AddColumn(cSheet,cTable,"CGC"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Ano"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"Tipo Info"	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"C๓d.Ret."	   	,1,1)
oExcel:AddColumn(cSheet,cTable,"Janeiro"  		,3,3)
oExcel:AddColumn(cSheet,cTable,"Fevereiro"		,3,3)
oExcel:AddColumn(cSheet,cTable,"Mar็o"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Abril"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Maio"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Junho"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Julho"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Agosto"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Setembro"  		,3,3)
oExcel:AddColumn(cSheet,cTable,"Outubro"  		,3,3)
oExcel:AddColumn(cSheet,cTable,"Novembro"  		,3,3)
oExcel:AddColumn(cSheet,cTable,"Dezembro"  		,3,3)
oExcel:AddColumn(cSheet,cTable,"Ano"	   		,3,3)
oExcel:AddColumn(cSheet,cTable,"Situa็ใo"	   	,3,3)

While TMP_PCC->(!EOF())
	
	//oExcel:AddRow(cSheet,cTable,{;
	
	If aScan( aDados, {|x| x[1] == IIF( AllTrim(TMP_PCC->R4_MAT) == "SE2" , "SE2" , "DIRF" ) .AND.;
					x[2] == TMP_PCC->A2_TIPO .AND. ;
					x[6] == TMP_PCC->A2_CGC .AND. ;					
					x[8] == TMP_PCC->TP_REND .AND. ;										
					x[9] == TMP_PCC->R4_CODRET .AND. ;					
					x[22] == TMP_PCC->ANO;
				 } ) <> 0 
		TMP_PCC->(DbSkip())
		Loop
	EndIf
	
	Aadd(aDados,{;
		IIF( AllTrim(TMP_PCC->R4_MAT) == "SE2" , "SE2" , "DIRF" ),;
		TMP_PCC->A2_TIPO,;
		TMP_PCC->A2_NOME,;
		TMP_PCC->A2_COD,;
		TMP_PCC->A2_LOJA,;
		TMP_PCC->A2_CGC,;
		TMP_PCC->R4_ANO,;
		TMP_PCC->TP_REND,;
		TMP_PCC->R4_CODRET,;
		TMP_PCC->JANE,;
		TMP_PCC->FEVE,;
		TMP_PCC->MARC,;
		TMP_PCC->ABRI,;
		TMP_PCC->MAIO,;
		TMP_PCC->JUNH,;
		TMP_PCC->JULH,;
		TMP_PCC->AGOS,;
		TMP_PCC->SETE,;
		TMP_PCC->OUTU,;
		TMP_PCC->NOVE,;
		TMP_PCC->DEZE,;
		TMP_PCC->ANO,;
		"";
	})                            
	
	TMP_PCC->(DbSkip())
EndDo

TMP_PCC->(DbClosearea())

For nAux := 1 To Len(aDados)
	
	cTp		:= IIF( AllTrim(aDados[nAux][nR4_MAT]) == "SE2", "DIRF", "SE2" )
	nPos	:= aScan( aDados, {|x| AllTrim(x[nR4_MAT]) == cTp .AND. AllTrim(x[nA2_CGC]) == AllTrim(aDados[nAux][nA2_CGC]) .AND. AllTrim(x[nTP_REND]) == AllTrim(aDados[nAux][nTP_REND]) } )
	
	If nPos == 0		
		aDados[nAux][nSITU]	:= "Diverg๊ncia"		
	Else
		
		Do Case
			Case aDados[nAux][nANO] <> aDados[nPos][nANO]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nJANE] <> aDados[nPos][nJANE]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nFEVE] <> aDados[nPos][nFEVE]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nMARC] <> aDados[nPos][nMARC]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nABRI] <> aDados[nPos][nABRI]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nMAIO] <> aDados[nPos][nMAIO]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nJUNH] <> aDados[nPos][nJUNH]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nJULH] <> aDados[nPos][nJULH]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nAGOS] <> aDados[nPos][nAGOS]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nSETE] <> aDados[nPos][nSETE]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nOUTU] <> aDados[nPos][nOUTU]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nNOVE] <> aDados[nPos][nNOVE]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"		
			Case aDados[nAux][nDEZE] <> aDados[nPos][nDEZE]
				aDados[nAux][nSITU]	:= "Diverg๊ncia"
			OtherWise	
				aDados[nAux][nSITU]	:= "Consistente"			
		EndCase		
		
	EndIf
	
	oExcel:AddRow(cSheet,cTable,aClone(aDados[nAux]))
	
Next

If nTipo == 1
	cQuery:="	SELECT 'BAIXA' ORIGEM,"+cQuebra
Else
	cQuery:="	SELECT 'PELO TX' ORIGEM,"+cQuebra
EndIf

cQuery+="	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI,"+cQuebra
cQuery+="	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS ,"+cQuebra
cQuery+="	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL ,"+cQuebra
cQuery+="	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF ,"+cQuebra

cQuery+="	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS ,"+cQuebra
cQuery+="	ED_PERCPIS ,"+cQuebra
cQuery+="	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF ,"+cQuebra
cQuery+="	ED_PERCCOF ,"+cQuebra
cQuery+="	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL ,"+cQuebra
cQuery+="	ED_PERCCSL ,"+cQuebra
cQuery+="	SED.ED_PERCIRF ,"+cQuebra
cQuery+="	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF ,"+cQuebra

cQuery+="	E2_DIRF,E2_CODRET,"+cQuebra
cQuery+="	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	"+cQuebra
cQuery+="	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,  "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN  "+cCampos+" ELSE 0 END JANE, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN  "+cCampos+" ELSE 0 END FEVE, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN  "+cCampos+" ELSE 0 END MARC, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN  "+cCampos+" ELSE 0 END ABRI, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN  "+cCampos+" ELSE 0 END MAIO, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN  "+cCampos+" ELSE 0 END JUNH, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN  "+cCampos+" ELSE 0 END JULH, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN  "+cCampos+" ELSE 0 END AGOS, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN  "+cCampos+" ELSE 0 END SETE, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN  "+cCampos+" ELSE 0 END OUTU, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN  "+cCampos+" ELSE 0 END NOVE, "+cQuebra
cQuery+="	CASE WHEN SE2."+cE2field+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN  "+cCampos+" ELSE 0 END DEZE, "+cQuebra
cQuery+="	 "+cCampos+" ANO"+cQuebra
cQuery+="	FROM "+RetSqlName("SE2")+" SE2"+cQuebra
cQuery+="	JOIN "+RetSqlName("SED")+" SED  "+cQuebra
cQuery+="	ON SED.ED_FILIAL = '"+xFilial("SED")+"'"+cQuebra
cQuery+="	AND SE2.E2_NATUREZ = SED.ED_CODIGO "+cQuebra
cQuery+="	AND SED.D_E_L_E_T_ <> '*'"+cQuebra
cQuery+="	JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
cQuery+="	ON A2_FILIAL = '"+xFilial("SA2")+"'"+cQuebra
cQuery+="	AND SE2.E2_FORNECE = A2_COD "+cQuebra
cQuery+="	AND SE2.E2_LOJA  = A2_LOJA  "+cQuebra
cQuery+="	AND SA2.D_E_L_E_T_ <> '*'"+cQuebra
cQuery+="	WHERE E2_FILIAL IN "+cInCilf+cQuebra
cQuery+="	AND SE2."+cE2field+" BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "+cQuebra

If nTipo == 1
	cQuery+="	AND F_GET_TX(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0"+cQuebra
	cQuery+="	AND ( F_GET_TX(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0 OR ( SE2.E2_PRETPIS IN ('2','3','4') AND SE2.E2_PRETCSL IN ('2','3','4') AND SE2.E2_PRETCOF IN ('2','3','4') ) )"
ElseIf nTipo == 2
	//cQuery+="	AND F_GET_TX_IR(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0"+cQuebra
	cQuery+="   AND SE2.E2_CODRET  NOT IN ('0422') "
	cQuery+="	AND SED.ED_CALCIRF = 'S' "+cQuebra	 
	
	cQuery+="	AND ( F_GET_TX_IR(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0 OR SE2.E2_PRETIRF IN ('2','3','4') ) "
Else
	//cQuery+="	AND F_GET_TX_IR(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0"+cQuebra
	cQuery+="   AND SE2.E2_CODRET  NOT IN ('0422') "
	cQuery+="	AND SED.ED_CALCIRF = 'S' "+cQuebra	 
	
	cQuery+="	AND ( F_GET_TX_IR_PF(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,1) > 0 OR SE2.E2_PRETIRF IN ('2','3','4') OR ( "
		
	// incluido filtro 	
//	cQuery+="  	SE2.E2_PRETIRF IN ('6') AND EXISTS ("	
	cQuery+="  	EXISTS ("	
	cQuery+="	SELECT 1 FROM "+RetSqlName("SE2")+" TXANO "
	cQuery+="	WHERE TXANO.E2_FILIAL IN "+cInCilf
	cQuery+="	AND TXANO.E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	cQuery+="	AND TXANO.E2_TIPO = 'TX' "
	cQuery+="	AND TXANO.E2_TITPAI LIKE '%'||SE2.E2_FORNECE||SE2.E2_LOJA||'%' "
	cQuery+="	AND TXANO.E2_NATUREZ = 'IRF' " 
	cQuery+="	AND TXANO.E2_CODRET = '"+cCodRet+"' " 
	cQuery+="	AND TXANO.D_E_L_E_T_ <> '*' ) "

	cQuery+="	) )" 
		
EndIf

cQuery+="	AND SE2.D_E_L_E_T_ <> '*'"+cQuebra

If nTipo == 3
	cQuery+="	AND A2_TIPO = 'F' "+cQuebra
Else
	cQuery+="	AND A2_TIPO = 'J' "+cQuebra
EndIf

//cQuery+="	AND SA2.A2_EST <> 'EX' "+cQuebra REMOVIDA VALIDAวรO DE EX POIS TEM CASOS ONDE O CPF/CNPJ FOI INFORMADO E COM ISSO ESTม INDO PARA DIRF
cQuery+="	AND SE2.D_E_L_E_T_ <> '*'"+cQuebra
cQuery+="	AND SE2.E2_TIPO <> 'TX'"+cQuebra
cQuery+="	"+cQuebra

If nTipo == 3

	cQuery+="	UNION ALL"+cQuebra
	cQuery+="	"+cQuebra
	
	
	If nTipo == 3
		cQuery+="	SELECT 'BAIXA' ORIGEM,"+cQuebra
	Else
		cQuery+="	SELECT 'EMISSAO' ORIGEM,"+cQuebra
	EndIf
	
	cQuery+="	CASE WHEN A2_RECCOFI = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCOFI,"+cQuebra
	cQuery+="	CASE WHEN A2_RECPIS = '1' THEN 'SIM' ELSE 'NรO' END A2_RECPIS ,"+cQuebra
	cQuery+="	CASE WHEN A2_RECCSLL = '1' THEN 'SIM' ELSE 'NรO' END A2_RECCSLL ,"+cQuebra
	cQuery+="	CASE WHEN A2_CALCIRF = '1' THEN 'SIM' ELSE 'NรO' END A2_CALCIRF ,"+cQuebra
	
	cQuery+="	CASE WHEN ED_CALCPIS = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCPIS ,"+cQuebra
	cQuery+="	ED_PERCPIS ,"+cQuebra
	cQuery+="	CASE WHEN ED_CALCCOF = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCOF ,"+cQuebra
	cQuery+="	ED_PERCCOF ,"+cQuebra
	cQuery+="	CASE WHEN ED_CALCCSL = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCCSL ,"+cQuebra
	cQuery+="	ED_PERCCSL ,"+cQuebra
	cQuery+="	SED.ED_PERCIRF ,"+cQuebra
	cQuery+="	CASE WHEN SED.ED_CALCIRF  = 'S' THEN 'SIM' ELSE 'NรO' END ED_CALCIRF ,"+cQuebra
	
	cQuery+="	E2_DIRF,E2_CODRET,"+cQuebra
	cQuery+="	E2_BASEIRF,E2_VALOR,E2_NATUREZ,	"+cQuebra
	cQuery+="	E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FILIAL,E2_FORNECE,E2_LOJA,SE2.E2_NOMFOR,E2_EMISSAO,SE2.E2_EMIS1,E2_BAIXA,SE2.E2_VENCREA,  "+cQuebra
	/*
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END JANE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END FEVE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END MARC, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END ABRI, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END MAIO, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END JUNH, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END JULH, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END AGOS, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END SETE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END OUTU, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END NOVE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN SE2.E2_VALOR+SE2.E2_INSS+"+IIF( nTipo == 3 ,"0" , "SE2.E2_IRRF" )+"+SE2.E2_ISS+CASE WHEN SE2.E2_PRETPIS = '1' AND SE2.E2_PRETCOF = '1' AND SE2.E2_PRETCSL = '1' AND SE2.E2_SALDO = 0 AND SE2.E2_BAIXA <> ' ' THEN SE2.E2_VRETPIS + SE2.E2_VRETCOF + SE2.E2_VRETCSL ELSE 0 END ELSE 0 END DEZE, "+cQuebra
	cQuery+="	E2_BASEIRF ANO"+cQuebra
	*/
	
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0101' AND '"+cAnoDirf+"0131' THEN E2_BASEIRF ELSE 0 END JANE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0201' AND '"+cAnoDirf+"0231' THEN E2_BASEIRF ELSE 0 END FEVE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0301' AND '"+cAnoDirf+"0331' THEN E2_BASEIRF ELSE 0 END MARC, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0401' AND '"+cAnoDirf+"0431' THEN E2_BASEIRF ELSE 0 END ABRI, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0501' AND '"+cAnoDirf+"0531' THEN E2_BASEIRF ELSE 0 END MAIO, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0601' AND '"+cAnoDirf+"0631' THEN E2_BASEIRF ELSE 0 END JUNH, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0701' AND '"+cAnoDirf+"0731' THEN E2_BASEIRF ELSE 0 END JULH, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0801' AND '"+cAnoDirf+"0831' THEN E2_BASEIRF ELSE 0 END AGOS, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"0901' AND '"+cAnoDirf+"0931' THEN E2_BASEIRF ELSE 0 END SETE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1001' AND '"+cAnoDirf+"1031' THEN E2_BASEIRF ELSE 0 END OUTU, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1101' AND '"+cAnoDirf+"1131' THEN E2_BASEIRF ELSE 0 END NOVE, "+cQuebra
	cQuery+="	CASE WHEN SE2."+cE2IRFfield+" BETWEEN '"+cAnoDirf+"1201' AND '"+cAnoDirf+"1231' THEN E2_BASEIRF ELSE 0 END DEZE, "+cQuebra
	cQuery+="	E2_BASEIRF ANO"+cQuebra
		
	cQuery+="	FROM "+RetSqlName("SE2")+" SE2"+cQuebra
	cQuery+="	JOIN "+RetSqlName("SED")+" SED  "+cQuebra
	cQuery+="	ON SED.ED_FILIAL = '"+xFilial("SED")+"'"+cQuebra
	cQuery+="	AND SE2.E2_NATUREZ = SED.ED_CODIGO "+cQuebra
	cQuery+="	AND SED.D_E_L_E_T_ <> '*'"+cQuebra
	cQuery+="	JOIN "+RetSqlName("SA2")+" SA2 "+cQuebra
	cQuery+="	ON SA2.A2_FILIAL = '"+xFilial("SA2")+"'"+cQuebra
	cQuery+="	AND SE2.E2_FORNECE = SA2.A2_COD "+cQuebra
	cQuery+="	AND SE2.E2_LOJA  = SA2.A2_LOJA  "+cQuebra
	cQuery+="	AND SA2.D_E_L_E_T_ <> '*'"+cQuebra
	cQuery+="	WHERE E2_FILIAL IN "+cInCilf+cQuebra
	//cQuery+="	AND SE2."+cE2IRFfield+" BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'"+cQuebra
	//cQuery+="	AND ( E2_BAIXA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' OR ( E2_BAIXA = ' ' AND E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' )  )  " 	
	cQuery+="	AND SE2.E2_BAIXA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'"+cQuebra
	
	If nTipo == 1
		cQuery+="	AND F_GET_TX(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,2) = 0 "+cQuebra
		cQuery+="	AND ( SED.ED_CALCCOF = 'S' AND SED.ED_CALCCSL = 'S' AND SED.ED_CALCPIS = 'S') "+cQuebra
	Else
		cQuery+="   AND SE2.E2_CODRET  NOT IN ('0422') "
		cQuery+="	AND F_GET_TX_IR_PF(SE2.E2_FILIAL,SE2.E2_PREFIXO||SE2.E2_NUM||SE2.E2_PARCELA||SE2.E2_TIPO||SE2.E2_FORNECE||SE2.E2_LOJA,2) = 0"+cQuebra
		cQuery+="	AND SED.ED_CALCIRF = 'S' AND SE2.E2_PRETIRF NOT IN ('2','3','4') "+cQuebra
	EndIf
		
	cQuery+="	AND SE2.D_E_L_E_T_ <> '*'"+cQuebra
	
	If nTipo == 3
		cQuery+="	AND SA2.A2_TIPO = 'F' "+cQuebra
	Else
		cQuery+="	AND SA2.A2_TIPO = 'J' "+cQuebra
	EndIf
	
	//cQuery+="	AND SA2.A2_EST <> 'EX' "+cQuebra REMOVIDA VALIDAวรO DE EX POIS TEM CASOS ONDE O CPF/CNPJ FOI INFORMADO E COM ISSO ESTม INDO PARA DIRF
	cQuery+="	AND SE2.D_E_L_E_T_ <> '*'"+cQuebra
	cQuery+="	AND SE2.E2_TIPO <> 'TX'"+cQuebra
	If nTipo == 1
		cQuery+="	AND SE2.E2_BAIXA <> ' '"+cQuebra //a dirf considera o titulo mesmo nใo baixado, mas vamos pegar apenas os baixados para gerar inconsistencia no relatorio
	EndIf

	cQuery+="  	AND NOT EXISTS ("	
	cQuery+="	SELECT 1 FROM "+RetSqlName("SE2")+" TXANO "
	cQuery+="	WHERE TXANO.E2_FILIAL IN "+cInCilf
	cQuery+="	AND TXANO.E2_EMISSAO BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' "
	cQuery+="	AND TXANO.E2_TIPO = 'TX' "
	cQuery+="	AND TXANO.E2_TITPAI LIKE '%'||SE2.E2_FORNECE||SE2.E2_LOJA||'%' "
	cQuery+="	AND TXANO.E2_NATUREZ = 'IRF' " 
	cQuery+="	AND TXANO.E2_CODRET = '"+cCodRet+"' " 
	cQuery+="	AND TXANO.D_E_L_E_T_ <> '*' ) "
		

EndIf
MemoWrite("\dirf_2017\"+cFilAnt+"\"+DtoS(DDataBase)+"_GENR067_ITEM_"+StrTran(Time(),":","")+".sql",cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery), "TMP_PCC" ,.T.,.T.)

TMP_PCC->(DbGotop())
aDados	:= {}

cSheet	:= "SE2 Analitico"
cTable	:= "Titulos Base SE2"

oExcel:AddworkSheet(cSheet)
oExcel:AddTable (cSheet,cTable) 

oExcel:AddColumn(cSheet,cTable,"ORIGEM"				,1,1) 
oExcel:AddColumn(cSheet,cTable,"A2_RECCOFI"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"A2_RECPIS"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"A2_RECCSLL"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"A2_CALCIRF"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"ED_CALCPIS"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_PERCPIS"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_CALCCOF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_PERCCOF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_CALCCSL"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_PERCCSL"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_PERCIRF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"ED_CALCIRF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_DIRF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_CODRET"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_BASEIRF"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_VALOR"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_NATUREZ"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_NUM"	   	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_PREFIXO"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_PARCELA"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_FILIAL"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_FORNECE"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_LOJA"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_NOMFOR"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_EMISSAO"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_EMIS1"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_BAIXA"	   		,1,1) 
oExcel:AddColumn(cSheet,cTable,"E2_VENCREA"	   		,1,1)
oExcel:AddColumn(cSheet,cTable,"JANE"		   		,3,3)
oExcel:AddColumn(cSheet,cTable,"FEVE"		   		,3,3)
oExcel:AddColumn(cSheet,cTable,"MARC"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"ABRI"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"MAIO"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"JUNH"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"JULH"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"AGOS"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"SETE"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"OUTU"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"NOVE"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"DEZE"	   			,3,3)
oExcel:AddColumn(cSheet,cTable,"ANO"	   			,3,3)
		
While TMP_PCC->(!EOF())
	
	//oExcel:AddRow(cSheet,cTable,{;
	Aadd(aDados,{;
		TMP_PCC->ORIGEM,; 
		TMP_PCC->A2_RECCOFI,; 
		TMP_PCC->A2_RECPIS,; 
		TMP_PCC->A2_RECCSLL,; 
		TMP_PCC->A2_CALCIRF,;
		TMP_PCC->ED_CALCPIS,; 
		TMP_PCC->ED_PERCPIS,; 
		TMP_PCC->ED_CALCCOF,; 
		TMP_PCC->ED_PERCCOF,; 
		TMP_PCC->ED_CALCCSL,; 
		TMP_PCC->ED_PERCCSL,; 
		TMP_PCC->ED_PERCIRF,; 
		TMP_PCC->ED_CALCIRF,; 
		TMP_PCC->E2_DIRF,; 
		TMP_PCC->E2_CODRET,; 
		TMP_PCC->E2_BASEIRF,; 
		TMP_PCC->E2_VALOR,; 
		TMP_PCC->E2_NATUREZ,; 
		TMP_PCC->E2_NUM,; 
		TMP_PCC->E2_PREFIXO,; 
		TMP_PCC->E2_PARCELA,; 
		TMP_PCC->E2_FILIAL,; 
		TMP_PCC->E2_FORNECE,; 
		TMP_PCC->E2_LOJA,; 
		TMP_PCC->E2_NOMFOR,; 
		StoD(TMP_PCC->E2_EMISSAO),; 
		StoD(TMP_PCC->E2_EMIS1),; 
		StoD(TMP_PCC->E2_BAIXA),; 
		StoD(TMP_PCC->E2_VENCREA),;
		TMP_PCC->JANE,;
		TMP_PCC->FEVE,;
		TMP_PCC->MARC,;
		TMP_PCC->ABRI,;
		TMP_PCC->MAIO,;
		TMP_PCC->JUNH,;
		TMP_PCC->JULH,;
		TMP_PCC->AGOS,;
		TMP_PCC->SETE,;
		TMP_PCC->OUTU,;
		TMP_PCC->NOVE,;
		TMP_PCC->DEZE,;
		TMP_PCC->ANO;
	})                            
	
	TMP_PCC->(DbSkip())
EndDo

TMP_PCC->(DbClosearea())

For nAux := 1 To Len(aDados)		
	oExcel:AddRow(cSheet,cTable,aClone(aDados[nAux]))	
Next

oExcel:Activate()
oExcel:GetXMLFile(cPath+cArquivo)
FreeObj(oExcel)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
oExcelApp:SetVisible(.T.)
FreeObj(oExcelApp)

Return nil