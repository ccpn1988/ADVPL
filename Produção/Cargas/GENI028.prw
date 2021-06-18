#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI028   บAutor  ณCleuto Lima         บ Data ณ  28/06/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera os documentos de entrada para os pedidos cusro forum   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GENI028()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENI028 - Iniciando Job - Importa็ใo de Documento de entrda forum - "+Time()+".")

IF !("SCHEDULE" $ Upper(alltrim(GetEnvServer())))
	Conout("GENI028 - deve executar apenas no SCHEDULE - "+Time()+".")
	Return nil
EndIf

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "7001")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))                                 '
	   	ConOut(Padc("GENI028 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENI028 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENI028",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENI028 - Nใo foi possํvel executar a Importa็ใo de Documento de entrda forum neste momento pois a fun็ใo GENI028 jแ esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

ProcNotas()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENI028 - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENI028",.T.,.T.,.T.)

Conout("GENI028 - Finalizando Job - Importa็ใo de Documento de entrda forum - "+Time()+".")

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  06/28/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ProcNotas()

Local cCodCli		:= GetMv("GEN_FAT158")
Local cLojaCli		:= ""
Local cTesSF2		:= GetMv("GEN_FAT159")
Local cCodPag		:= GetMv("GEN_FAT165")
Local cForGen		:= GetMv("GEN_FAT166")
Local cTesForum		:= GetMv("GEN_FAT167")
Local cLojGen		:= ""
Local cChaveLp		:= ""
Local cSerNota		:= "10"  
Local aCabDcOr		:= {}
Local _aErro		:= {}
Local _cErroLg		:= ""
Local _ni			:= 0
Local _cLogPd		:= SUPERGETMV("GEN_FAT154",.T.,"\logsiga\ped_forum\")+"entrada_Forum\"
Local _aDir			:= {}

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.

cLojGen	:= SubStr(AllTrim(cForGen), At("-",cForGen)+1,2 )
cForGen	:= PadR(Left(AllTrim(cForGen), At("-",cForGen)-1 ),TamSX3("A2_COD")[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecutar limpeza dos logsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aDir:=directory(Alltrim(_cLogPd)+"*")
aEval(_aDir, {|x| fErase(Alltrim(_cLogPd)+x[1]) } )

cLojaCli	:= Substr(cCodCli,At("/",cCodCli)+1,2)
cCodCli		:= Substr(cCodCli,1,At("/",cCodCli)-1)

If Select("TMP_CURSOS") > 0
	TMP_CURSOS->(DbCloseArea())
EndIf

BeginSql Alias "TMP_CURSOS"
	
	SELECT 
	C5_MENNOTA,F2_CHVNFE,D2_EMISSAO,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,D2_QUANT,D2_PRCVEN,D2_PRUNIT,D2_DESC,D2_DESCON,D2_TOTAL 
	FROM %Table:SF2% SF2
	JOIN %Table:SD2% SD2
	ON D2_FILIAL = F2_FILIAL
	AND D2_DOC = F2_DOC
	AND D2_SERIE = F2_SERIE
	AND SD2.%NotDel%
	JOIN %Table:SC5% SC5
	ON C5_FILIAL = F2_FILIAL
	AND C5_NOTA = F2_DOC
	AND C5_SERIE = F2_SERIE
	AND C5_NUM = D2_PEDIDO
	AND SC5.%NotDel%
	WHERE F2_FILIAL = '1022'
	AND F2_CLIENTE = %Exp:cCodCli%
	AND F2_LOJA = %Exp:cLojaCli%
	AND D2_TES = %Exp:cTesSF2%
	AND C5_XPEDWEB <> ' '
	AND C5_XPEDOLD <> ' '
	AND SF2.%NotDel%
	AND NOT EXISTS(
	    SELECT 1 FROM %Table:SF1% SF1
	    WHERE F1_FILIAL = %xFilial:SF1%
	    AND F1_TIPO = 'N'
	    AND F1_DOC = F2_DOC
	    AND F1_SERIE = F2_SERIE
	    AND F1_FORNECE = %Exp:cForGen%
	    AND SF1.%NotDel%
	) ORDER BY D2_DOC,D2_SERIE,D2_COD,D2_ITEM
	
EndSql
       
TMP_CURSOS->(DbGotop())

SA2->(DbSetORder(1))
If !SA2->(Dbseek( xFilial("SA2")+cForGen+cLojGen ))
	Conout("GENI028-Fornecedor nใo localizado, verificar parametro GEN_FAT166")
	Return nil
EndIf

While TMP_CURSOS->(!EOF())
	
	cChaveLp	:= TMP_CURSOS->D2_DOC+TMP_CURSOS->D2_SERIE

	lMsErroAuto		:= .F.
	lMsHelpAuto		:= .T.
	aCabDcOr		:= {}
	aItmDcOr		:= {}
	_aErro			:= {}
	_cErroLg		:= ""
		
	aadd(aCabDcOr , {"F1_TIPO"   	,"N"							, Nil} )
	aadd(aCabDcOr , {"F1_FORMUL" 	,"N"							, Nil} )
	aadd(aCabDcOr , {"F1_DOC"		,TMP_CURSOS->D2_DOC				, Nil} )
	aadd(aCabDcOr , {"F1_SERIE"  	,TMP_CURSOS->D2_SERIE			, Nil} )		
	aadd(aCabDcOr , {"F1_EMISSAO"	,StoD(TMP_CURSOS->D2_EMISSAO)	, Nil} )
	aadd(aCabDcOr , {"F1_FORNECE"	,SA2->A2_COD					, Nil} )
	aadd(aCabDcOr , {"F1_LOJA"   	,SA2->A2_LOJA					, Nil} )
	aadd(aCabDcOr , {"F1_ESPECIE"	,"SPED"							, Nil} )
	aadd(aCabDcOr , {"F1_DTDIGIT"	,DDataBase						, Nil} )	
	aadd(aCabDcOr , {"F1_COND"		,cCodPag						, Nil} )
	aAdd(aCabDcOr , {"F1_CHVNFE"	,TMP_CURSOS->F2_CHVNFE			, NIL} )
	aAdd(aCabDcOr , {"F1_MENNOTA"	,TMP_CURSOS->C5_MENNOTA			, NIL} )
		
	While cChaveLp	== TMP_CURSOS->D2_DOC+TMP_CURSOS->D2_SERIE
		
		alinhaOr	:= {}		
		
		// CONVERTE PARA ITEM DO SD1
		// Nใo tem problema usar o val aqui pois estas notas nunca terใo mais de 99 itens
		cD1Item	:= StrZero(Val(TMP_CURSOS->D2_ITEM),TamSX3("D1_ITEM")[1])
		aAdd(alinhaOr	,	{"D1_ITEM"		, cD1Item				, Nil})
		aAdd(alinhaOr	,	{"D1_COD"  		, TMP_CURSOS->D2_COD	, Nil})
		aAdd(alinhaOr	,	{"D1_QUANT"		, TMP_CURSOS->D2_QUANT	, Nil})
		aAdd(alinhaOr	,	{"D1_VUNIT"		, TMP_CURSOS->D2_PRUNIT	, Nil})
		aAdd(alinhaOr	,	{"D1_TOTAL"		, TMP_CURSOS->(D2_DESCON+D2_TOTAL)	, Nil})
		aAdd(alinhaOr	,	{"D1_DESC"		, TMP_CURSOS->D2_DESC	, Nil})
		aAdd(alinhaOr	,	{"D1_VALDESC"	, TMP_CURSOS->D2_DESCON	, Nil})
		aAdd(alinhaOr	,	{"D1_TES"		, cTesForum				, Nil})
		aAdd(alinhaOr	,	{"D1_LOCAL"		, "01"					, Nil})			

		Aadd(aItmDcOr, aClone(alinhaOr) )
		TMP_CURSOS->(Dbskip())
	EndDo
	
	MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabDcOr, aItmDcOr,3)
	
	If lMsErroAuto
		MostraErro(_cLogPd,  "GENI028 - "+cChaveLp+" - "+DtoS(DDataBase)+" - GeraDocEntrada.log" )
	Else	
		Conout("GENI028 - Nota "+SF1->F1_DOC+" impotada com sucesso!")
	EndIf
				
EndDo

TMP_CURSOS->(DbCloseArea())

Return nil