#include "TOTVS.CH"
#INCLUDE "Protheus.ch" 
#include "tbiconn.ch"
#include "topconn.ch"
#include "Fileio.ch"


#DEFINE COL_DATA		1	
#DEFINE COL_HORA		2
#DEFINE COL_USER		3
#DEFINE COL_DTFE		4
#DEFINE COL_ACAO		5   
#DEFINE COL_LOG		6
#DEFINE COL_MSG		7
#DEFINE COL_BKP		8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณCleuto Lima         บ Data ณ  11/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para realizar exclusใo de fechamento de estoque.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Gen.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function GENA044()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local aSays		:= {}
Local cCadastro	:= "Exclusใo de Fechamento de Estoque"
Local aRet 		:= {}
Local aButtons	:= {}
Local cTabFre	:= ""
Local cDirLog	:= "\logsiga\Exc_Fechamento\"
Local lContinua	:= .F.
Local cTabBkp	:= AllTrim("BKP."+RetSqlName("SB9"))+"_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")

Private nOpcA	:= 0

WFForceDir(cDirLog)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta tela principal                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AADD(aSays,OemToAnsi("Esta rotina tem o objetivo realizar a exclusใo do fechamento de estoque."		))
	AADD(aSays,OemToAnsi("apenas serแ permitida a exclusใo de peridos onde nใo houve movimenta็ใo."		))
	AADD(aSays,OemToAnsi(""																				))
	AADD(aSays,OemToAnsi(""																				))
	AADD(aSays,OemToAnsi("Especifico Grupo Gen." 									   					))
	AADD(aButtons, { 5,.T.,{|o|	ParamBox({;
												{01,"Data do Fechamento"		,CriaVar("B9_DATA",.F.)	,"@D",".T.",""/*F3*/,"",45,.T.},;
												{11,"Observa็ใo	"		,Space(300),".T.",".T.",.T.};
							 				},cCadastro,@aRet,,,,,,,FunName(),.T.,.F.)}})

	AADD(aButtons, { 1,.T.,{|o| IIF( VldParam(aRet) , (nOpcA:= 1,o:oWnd:End(),FechaBatch()),nil)	}})
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End(),FechaBatch()				}})
	AADD(aButtons, { 15,.T.,{|o| nOpcA:= 0,ViewHistProc()				}})

	GrvLog(cDirLog,"",CtoD("  /  /  "),"Acionamento da Rotina","Usuแrio acionou a rotina no menu!")
	
	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA <> 1
		GrvLog(cDirLog,"",CtoD("  /  /  "),"Cancelou Execu็ใo","Usuแrio cancelou a opera็ใo na tela de parametros.")	
		Return
	EndIf

	If Len(aRet) <> 2
		Aviso("Parametros","Digite os paramentros antes de confirmar a Rotina",{"Abandonar"})
		GrvLog(cDirLog,"",CtoD("  /  /  "),"Parโmetros Incorretos","Inconsist๊ncia nos parโmetros informados!")				
		Return
	Else
		
		Processa({|| lContinua := VldExclu(aRet[1],aRet[2],cDirLog,cTabBkp) },"Processando...")
		
		If lContinua
			Processa({|| ProcExc(cDirLog,aRet[2],aRet[1],cTabBkp) },"Processando Exclusใo...")
		EndIf
		
	EndIf

Return nil   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณMicrosiga           บ Data ณ  03/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function VldParam(aRet)

Local lRet		:= .F.
Local dUltMes	:= GetMV("MV_ULMES")

If Len(aRet) <> 2 .OR. Empty(aRet[1]) .OR. Empty(aRet[2])
	Aviso("Parametros","Digite os paramentros antes de confirmar a Rotina",{"Abandonar"})
Else
	If dUltMes <> aRet[1]
		MsgStop("Apenas o ultimo fechamento pode ser excluido, data do ultimo fechamento: "+DtoC(dUltMes))
	Else
		lRet := MsgYesNo("Confirma a Exclusใo do fechamento de estoque para o perํodo "+DtoC(aRet[1]))
	EndIf	
EndIf
	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewHistProcบAutor  ณMicrosiga           บ Data ณ  11/20/15   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                              บฑฑ
ฑฑบ          ณ                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewHistProc()

Local oDlgT		:= nil
Local aDados	:= {}
Local cDirLog	:= "\logsiga\Exc_Fechamento\"
Local aFileLog	:= aFiles := Directory(cDirLog+AllTrim(cFilAnt)+"_??????????????_??????.xml")
Local nAuxLog	:= 0
Local oXmlAux	:= nil 
Local cError	:= ""
Local cWarning	:= ""
Local nPosAtu	:= 0
Local nOpcA		:= 0

Local dData		:= nil
Local cHora		:= nil
Local cUser		:= nil
Local cDtFec	:= nil
Local cAcao		:= nil
Local cMsgLog	:= ""
Local cMsgUsr	:= ""
Local cTabBkp	:= ""

Local aHList	:= {}

For nAuxLog := 1 To Len(aFileLog)

	cError		:= ""
	cWarning	:= ""
	
	//Gera o Objeto XML
	oXmlAux := XmlParserFile( cDirLog+aFileLog[nAuxLog][1], "_", @cError, @cWarning )	
	
	If !Empty(cError) .OR. !Empty(cWarning) 
	
		dData	:= CtoD("  /  /  ")
		cHora	:= "00:00"
		cUser	:= "XXXXXX" 
		cDtFec	:= CtoD("  /  /  ")
		cAcao	:= cError+", "+cWarning	
		cMsgLog	:= ""
		cMsgUsr	:= ""
		cTabBkp	:= ""
		
	Else
	
		dData	:= StoD(oXmlAux:_LOG:_DATA:TEXT)
		cHora	:= oXmlAux:_LOG:_HORA:TEXT
		cUser	:= oXmlAux:_LOG:_NAME:TEXT
		cDtFec	:= StoD(oXmlAux:_LOG:_DATA_FECHA:TEXT)
		cAcao	:= oXmlAux:_LOG:_ACAO:TEXT
		cMsgLog	:= oXmlAux:_LOG:_LOG:TEXT
		cMsgUsr	:= oXmlAux:_LOG:_MSG:TEXT 
		cTabBkp	:= oXmlAux:_LOG:_BACKUP:TEXT 
		
	EndIf
	
	Aadd(aDados, Array(8) )
	
	nPosAtu := Len(aDados)
	aDados[nPosAtu][COL_DATA]	:= dData
	aDados[nPosAtu][COL_HORA]	:= cHora
	aDados[nPosAtu][COL_USER]	:= cUser
	aDados[nPosAtu][COL_DTFE]	:= cDtFec	
	aDados[nPosAtu][COL_ACAO]	:= cAcao
	aDados[nPosAtu][COL_LOG]	:= cMsgLog
	aDados[nPosAtu][COL_MSG]	:= cMsgUsr
	aDados[nPosAtu][COL_BKP]	:= cTabBkp	
		
	// Libera o objeto da memoria
	FreeObj(oXmlAux)
		
Next nAuxLog

aDados := Asort(aDados,,, {|x,y| x[COL_DATA] < y[COL_DATA] .and. x[COL_HORA] < y[COL_HORA] /*Val(StrTran(x[4],":","")) < Val(StrTran(y[4],":",""))*/ } )

DEFINE MSDIALOG oDlgT TITLE "Historico de Processamento" From 009,000 To 500,1000 OF oMainWnd Style DS_MODALFRAME Pixel

oDlgT:lMaximized	:= .F.
	
@00,00 MSPANEL oPanel PROMPT "" SIZE 250,45 COLOR CLR_WHITE,CLR_WHITE OF oDlgT 
oPanel:Align := CONTROL_ALIGN_ALLCLIENT

oListBox := TWBrowse():New(15,10,(oPanel:NCLIENTWIDTH/2)-30,(oPanel:NCLIENTHEIGHT/2)-60,,aHList,,oPanel,,,,,,,,,,,,, "ARRAY", .T. )

oListBox:AddColumn(TCColumn():New("Data"		  		,{|| aDados[oListBox:nAT][COL_DATA]	},,,,'CENTER'		,45,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Hora"		  		,{|| aDados[oListBox:nAT][COL_HORA]	},,,,'CENTER'		,35,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Usuแrio"		  		,{|| aDados[oListBox:nAT][COL_USER]	},,,,'LEFT'			,50,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("Dt.Fechamento"		,{|| aDados[oListBox:nAT][COL_DTFE]	},,,,'CENTER'		,50,.F.,.F.,,,,.F.,))
oListBox:AddColumn(TCColumn():New("A็ใo"		  		,{|| aDados[oListBox:nAT][COL_ACAO]	},,,,'LEFT'			,100,.F.,.F.,,,,.F.,))

oListBox:SetArray( aDados )

oListBox:bLDblClick := {|| ViewLog(aDados,oListBox) }

ACTIVATE MSDIALOG oDlgT ON INIT EnchoiceBar(oDlgT,{|| nOpca := 1,oDlgT:End()},{|| oDlgT:End() }) CENTERED

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณMicrosiga           บ Data ณ  03/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewLog(aDados,oListBox)

Local cTextLog	:= ""
Local oDlgLog	:= nil 
Local oPnl1		:= nil

cTextLog += "Data do processamento: "+DtoC(aDados[oListBox:nAT][COL_DATA])+CRLF
cTextLog += "Hora do processamento: "+aDados[oListBox:nAT][COL_HORA]+CRLF
cTextLog += "Usuแrio: "+aDados[oListBox:nAT][COL_USER]+CRLF
cTextLog += "Perํodo de Fechamento: "+DtoC(aDados[oListBox:nAT][COL_DTFE])+CRLF
cTextLog += "A็ใo: "+aDados[oListBox:nAT][COL_ACAO]+CRLF
cTextLog += "Log da rotina: "+aDados[oListBox:nAT][COL_LOG]+CRLF
cTextLog += "Observa็ใo do usuแrio: "+aDados[oListBox:nAT][COL_MSG]+CRLF

If !Empty(aDados[oListBox:nAT][COL_BKP])
	cTextLog += "Tabela de Backup anterior a Exclusใo: "+aDados[oListBox:nAT][COL_BKP]+CRLF
EndIf

DEFINE DIALOG oDlgLog TITLE "Log" FROM 009,000 To 300,700 PIXEL

@00,00 MSPANEL oPnl1 PROMPT "" SIZE 250,45 COLOR CLR_WHITE,CLR_WHITE OF oDlgLog 
oPnl1:Align := CONTROL_ALIGN_ALLCLIENT

oMtGetLog := tMultiget():new( 01, 01, {| u | if( pCount() > 0, cTextLog := u, cTextLog ) },oDlgLog, (oPnl1:NCLIENTWIDTH/2)-10, (oPnl1:NCLIENTHEIGHT/2)-50, , , , , , .T. )

oButOk 	:= TButton():New( (oPnl1:NCLIENTHEIGHT/2)-30, 10, "OK"	  			, oPnl1,{|| oDlgLog:End() },40,010,,,,.T.)

ACTIVATE DIALOG oDlgLog CENTERED

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณMicrosiga           บ Data ณ  03/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvLog(cDirLog,cMsg,dDtFecha,cAcao,cLog,cTabBkp)

Local cXML		:= ""
Local cFiledest	:= AllTrim(cFilAnt)+"_"+DtoS(DDataBase)+StrTran(Time(),":","")+"_"+AllTrim(PswRet()[1][1])+".xml"

Default cTabBkp	:= ""

cXML += "<LOG>"+CRLF
cXML += "<FILIAL>"+cFilAnt+"</FILIAL>"+CRLF
cXML += "<DATA>"+DtoS(DDataBase)+"</DATA>"+CRLF
cXML += "<HORA>"+Time()+"</HORA>"+CRLF
cXML += "<USER>"+PswRet()[1][1]+"</USER>"+CRLF
cXML += "<NAME>"+PswRet()[1][2]+"</NAME>"+CRLF
cXML += "<ACAO>"+cAcao+"</ACAO>"+CRLF
cXML += "<DATA_FECHA>"+DtoS(dDtFecha)+"</DATA_FECHA>"+CRLF
cXML += "<MSG>"+cMsg+"</MSG>"+CRLF
cXML += "<LOG>"+cLog+"</LOG>"+CRLF
cXML += "<BACKUP>"+cTabBkp+"</BACKUP>"+CRLF
cXML += "</LOG>"+CRLF

MemoWrite(cDirLog+cFiledest,EncodeUtf8(cXML))

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณMicrosiga           บ Data ณ  03/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldExclu(dDtFecha,cObsFecha,cDirLog,cTabBkp)

Local lRet		:= .T.
Local cAliTmp	:= GetNextAlias() 
Local cMsgRet	:= ""
Local nSql		:= 0 
Local cAuxBkp 	:= '%'+AllTrim(cTabBkp)+'%'	

BeginSql Alias cAliTmp
	SELECT MAX(B9_DATA) B9_DATA FROM %Table:SB9% SB9
	WHERE B9_FILIAL = %xFilial:SB9%
	AND B9_DATA <> ' '
	AND SB9.%NotDel%
EndSql

(cAliTmp)->(DbGoTop())
If StoD((cAliTmp)->B9_DATA) <> dDtFecha
	lRet := .F.
	xMagHelpFis("Parametos","Data do ultimo fechamento ("+DtoC(StoD((cAliTmp)->B9_DATA))+") diferente do parโmetro informado ("+DtoC(dDtFecha)+"), o processo nใo pode ser realizado!","Verifique os parametos infomados!")
	GrvLog(cDirLog,cObsFecha,dDtFecha,"Parโmetros Incorretos","Data do ultimo fechamento ("+DtoC(StoD((cAliTmp)->B9_DATA))+") diferente do parโmetro informado ("+DtoC(dDtFecha)+"), o processo nใo pode ser realizado!")
EndIf

(cAliTmp)->(DbCloseArea())

If lRet
	//nao faz sentido validar as movimentacoes
	/*
	BeginSql Alias cAliTmp  
		SELECT MAX(DTMOV) DTMOV FROM (
		SELECT MAX(D1_DTDIGIT) DTMOV FROM %Table:SD1% SD1
		JOIN %Table:SF4% SF4
		ON F4_FILIAL = %xFilial:SF4%
		AND F4_CODIGO = D1_TES
		AND F4_ESTOQUE = 'S'
		AND SF4.%NotDel%
		WHERE D1_FILIAL = %xFilial:SD1%
		AND D1_DTDIGIT > %exp:DtoS(dDtFecha)%
		AND SD1.%NotDel%
		UNION ALL
		SELECT MAX(D2_EMISSAO) DTMOV FROM %Table:SD2% SD2
		JOIN %Table:SF4% SF4
		ON F4_FILIAL = %xFilial:SF4%
		AND F4_CODIGO = D2_TES
		AND F4_ESTOQUE = 'S'
		AND SF4.%NotDel%
		WHERE D2_FILIAL = %xFilial:SD2%
		AND D2_EMISSAO > %exp:DtoS(dDtFecha)%
		AND SD2.%NotDel%
		UNION ALL
		SELECT MAX(D3_EMISSAO) DTMOV FROM %Table:SD3% SD3
		WHERE D3_FILIAL = %xFilial:SD3%
		AND D3_EMISSAO > %exp:DtoS(dDtFecha)%
		AND SD3.%NotDel% 
		) TMP
	EndSql	
	
	(cAliTmp)->(DbGoTop())
	If (cAliTmp)->(!EOF()) .OR. StoD((cAliTmp)->DTMOV) > dDtFecha
		lRet := .F. 
		xMagHelpFis("Periodo com movimenta็ใo","Jแ houve movimenta็ใo posterior ao perํodo que voc๊ estแ tentando excluir o fechamento, nใo serแ possํvel prosseguir com a Exclusใo.","Verifique os parametos infomados!")
		
		cMsgRet+= " Jแ houve movimenta็ใo posterior ao perํodo que o usuแrio estแ tentando excluir o fechamento, nใo serแ possํvel prosseguir com a Exclusใo."+CRLF
		cMsgRet+= " , Perํodo selecionado:"+DtoC(dDtFecha)+CRLF
		
		GrvLog(cDirLog,cObsFecha,dDtFecha,"Bloqueio de Valida็ใo",cMsgRet)
		
	EndIf
	
	(cAliTmp)->(DbCloseArea())
	*/
	
	If lRet
		
		IncProc("Realizando Backup")
		
		nSql := TCSQLExec("CREATE TABLE "+cTabBkp+" AS SELECT * FROM "+RetSqlName("SB9"))
		
		If nSql < 0			
		
			MsgStop("Falha ao executar o Backup do ultimo fechamento, o processo nใo podera continuar!"+CRLF+"Informe o departamento de TI!")
			GrvLog(cDirLog,cObsFecha,dDtFecha,"Falha no Backup","Falha ao executar o Backup do ultimo fechamento, o processo nใo podera continuar!")
			lRet	:= .F.
			
		Else
			
			If Select(cAliTmp) <> 0
				(cAliTmp)->(DbCloseArea())	
			EndIf
			                      
			BeginSql Alias cAliTmp
				Select (Select Count(*) From %Exp:cAuxBkp%) QTD_BKP, (Select Count(*) From %Table:SB9%) QTD_SB9 from dual
			EndSql
			
			(cAliTmp)->(DbGoTop())
			
			If (cAliTmp)->(EOF()) .OR. (cAliTmp)->QTD_BKP <> (cAliTmp)->QTD_SB9 .OR. ((cAliTmp)->QTD_BKP + (cAliTmp)->QTD_SB9) == 0
				MsgStop("Falha ao executar o Backup do ultimo fechamento, o processo nใo podera continuar!"+CRLF+"Informe o departamento de TI!")
				GrvLog(cDirLog,cObsFecha,dDtFecha,"Falha no Backup","Falha ao executar o Backup do ultimo fechamento, o processo nใo podera continuar!")
				lRet	:= .F.				
			EndIf
			
			(cAliTmp)->(DbCloseArea())
			
		EndIf		
		
	EndIf
	
EndIF

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA044   บAutor  ณMicrosiga           บ Data ณ  03/22/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcExc(cDirLog,cObsFecha,dDtFecha,cTabBkp)

Local lRet		:= .T.
Local nSql		:= 0
Local cErro		:= ""
Local cAliTmp	:= GetNextAlias()
Local cOldFecha	:= ""

Begin Transaction 
	nSql := TCSQLExec("DELETE FROM "+RetSqlName("SB9")+" WHERE B9_FILIAL = '"+xFilial("SB9")+"' AND B9_DATA = '"+DtoS(dDtFecha)+"'" )		
	If nSql < 0				
		cErro	:= "Falha ao executar o Script de exclusใo do fechamento!"+CRLF+AllTrim(TCSQLError)+"Informe o departamento de TI!"
		lRet	:= .F.
	Else
		
		BeginSql Alias cAliTmp
			SELECT MAX(B9_DATA) B9_DATA FROM %Table:SB9% SB9
			WHERE B9_FILIAL = %xFilial:SB9%
			AND B9_DATA <> ' '
			AND SB9.%NotDel%
		EndSql		
		
		(cAliTmp)->(DbGoTop())
		cOldFecha := AllTrim((cAliTmp)->B9_DATA)
		
		If Empty(cOldFecha)
			cErro	:= "Falha ao tentar localizar a data de fechamento anterior a data "+DtoC(dDtFecha)
			MsgStop(cErro)
			GrvLog(cDirLog,cObsFecha,dDtFecha,"Falha execu็ใo",cErro,cTabBkp)
			lRet	:= .F.
			(cAliTmp)->(DbCloseArea())
			Disarmtransaction()
		Else
			PUTMV("MV_ULMES", StoD(cOldFecha) )	
		EndIf
		
		If Select(cAliTmp) > 0
			(cAliTmp)->(DbCloseArea())
		EndIf	
		
	EndIF
End Transaction

IF !Empty(cErro)
	MsgStop(cErro)
	GrvLog(cDirLog,cObsFecha,dDtFecha,"Falha execu็ใo",cErro,cTabBkp)
	lRet	:= .F.
Else		
	MsgAlert("Processo Finalizado com sucesso!"+CRLF+"Restaurado perํodo de fechamento "+DtoC(StoD(cOldFecha)))
	GrvLog(cDirLog,cObsFecha,dDtFecha,"Exclusใo realizada com sucesso!","Processo Finalizado com sucesso!"+CRLF+"Restaurado perํodo de fechamento "+DtoC(StoD(cOldFecha)),cTabBkp)
	lRet	:= .T.
EndIf	

Return lRet