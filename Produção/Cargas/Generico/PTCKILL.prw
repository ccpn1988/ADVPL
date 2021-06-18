#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPTCKILL   บAutor  ณCLEUTO CIMA         บ Data ณ  11/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PTCKILL()

Local nAuxKill	:= 0
Local aProAux	:= {}
Local nThrAtual	:= ThreadId()
Local aProAtu	:= GetUserInfoArray()
Local lEmExec	:= aScan(aProAtu,{|x| AllTrim(x[5]) == "U_PTCKILL" .AND. x[3] <> nThrAtual }) > 0

Local aSlaves	:= {}
Local nAuxPort	:= 0
Local oServer	:= nil

Aadd(aSlaves,{"10.3.0.85",1000} ) // Master
Aadd(aSlaves,{"10.3.0.85",1011} ) // Comercial
Aadd(aSlaves,{"10.3.0.85",1012} ) // Controladoria
Aadd(aSlaves,{"10.3.0.85",1013} ) // Deposito

/*
Aadd(aSlaves,{"10.3.0.85",1001} ) // Slave 1
Aadd(aSlaves,{"10.3.0.85",1002} ) // Slave 2
*/
//Aadd(aSlaves,{"10.3.0.84",1888} ) // Schedule
//Aadd(aSlaves,{"10.3.0.84",1021} ) // Deposito

IF lEmExec
	Conout("PTCKILL - rotina jแ em execu็ใo "+DtoC(Date())+" "+time())
	Return nil
ENDIF

Conout("PTCKILL - Executando Kill de Thread "+DtoC(Date())+" "+time())

For nAuxPort := 1 to Len(aSlaves)
	aProcess	:= {}

	oServer := Conect(aSlaves[nAuxPort][1],aSlaves[nAuxPort][2])

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealizando a nova conexใo para entrar na empresa e filial corretaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ValType(oServer) == "O"		
		oServer:CallProc("RPCSetType",3)
		
		aProcess := oServer:CallProc("U_GENKILL2")
		
		UnConect(@oServer)
	EndIF

	IF ValType(aProcess) == "A" .AND. Len(aProcess)
		aProcess := aSort(aProcess,,,{|x,y| x[16] > y[16]})
		For nAuxKill := 1 To Len(aProcess)
				//IF Val(Separa(aProcess[nAuxKill][8],":")[1]) > 0 .OR.;
				//	Val(Separa(aProcess[nAuxKill][8],":")[2]) >= 2

					//Sleep( 10 )
					//aProAux	:= GetUserInfoArray()
					//nPosThr := aScan(aProAux,{|x| x[3] == aProcess[nAuxKill][3] })
					//IF nPosThr > 0
						//IF aProcess[nAuxKill][9] == aProAux[nPosThr][9]
						If Val(Separa(aProcess[nAuxKill][8],":")[2]) > 30

							cUserName     := aProcess[nAuxKill][1]
							// Nome do usuแrio do Smart Client
							cComputerName := aProcess[nAuxKill][2]
							// Nome do computador do Smart Client
							nThreadId     := aProcess[nAuxKill][3]
							// ID de conexใo entre o TOTVS Application Server e o Smart Client
							cServerName   := aProcess[nAuxKill][4]
							// Nome do Servidor
							//KillUser( cUserName, cComputerName, nThreadId, cServerName )
							oServer := Conect(Left(cServerName,At(":",cServerName)-1),Val(SubStr(cServerName,At(":",cServerName)+1,4)))

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณRealizando a nova conexใo para entrar na empresa e filial corretaณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							If ValType(oServer) == "O"		
								oServer:CallProc("RPCSetType",3)
								
								oServer:CallProc("U_GENKILL3",cUserName, cComputerName, nThreadId, cServerName)
								
								UnConect(@oServer)
							EndIF

						ENDIF
					//ENDIF
				//ENDIF
		Next nAuxKill
	EndIf

Next nAuxPort

Conout("PTCKILL - Finalizando Kill de Thread "+DtoC(Date())+" "+time())

Return nil

User Function GENKILL2()

Local aProcess	:= GetUserInfoArray()

Return aProcess

User Function GENKILL3(cUserName, cComputerName, nThreadId, cServerName)

KillUser( cUserName, cComputerName, nThreadId, cServerName )

Return nil

Static Function Conect(cServidor,nPorta)

Local oConect	:= nil

	//Inicio do RPC para logar na empresa origem
	CREATE RPCCONN oConect ON  SERVER cServidor	;   //IP do servidor
	PORT  nPorta								;   //Porta de conexใo do servidor
	ENVIRONMENT "PRODUCAO"       							;   //Ambiente do servidor
	EMPRESA "00"          									;   //Empresa de conexใo
	FILIAL  "1001"          								;   //Filial de conexใo
	TABLES  ""												;   //Tabela que serใo abertas
	MODULO  "SIGAFAT"               					//M๓dulo de conexใo
	

Return oConect

Static Function UnConect(oConect)

	//Fecha a Conexao com o Servidor
	RESET ENVIRONMENT IN SERVER oConect
	CLOSE RPCCONN oConect
	FreeObj(oConect)
	oConect := Nil

Return nil