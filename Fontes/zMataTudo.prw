/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2018/01/09/funcao-para-matar-conexoes-protheus/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zMataTudo
Fun��o que mata todas as conexões ativas do Protheus
@author Atilio
@since 21/09/2017
@version 1.0
@type function
@obs Documenta��o no TDN
	GetUserInfoArray - http://tdn.totvs.com/display/tec/GetUserInfoArray
	KillUser         - http://tdn.totvs.com/display/tec/KillUser
/*/

User Function zMataTudo()
	Local aArea      := GetArea()
	Local aThreads   := {}
	Local nConexAtu  := 1
	Local nTentativa := 1
	Local nMaxTenta  := 10
	
	//Se n�o tiver preparado o ambiente (Schedule)
	If Select("SX2") == 0
		RPCSetType(3)
		RPCSetEnv("01", "01", "", "", "")
	EndIf
	
	ConOut("[zMataTudo] Inicio - " + dToC(Date()) + " " + Time())
	
	//Pega todos os usu�rios conectados
	aThreads := GetUserInfoArray()
	
	//Enquanto houver tentativas para finalizar as threads
	While nTentativa <= nMaxTenta
		//Percorre todas as conexões
		For nConexAtu := 1 To Len(aThreads)
			
			//Se a thread da conex�o atual for diferente da thread atual (sen�o vai matar o processo que mata todos)
			If aThreads[nConexAtu][3] != ThreadId()
				KillUser( aThreads[nConexAtu][1],; //UserName
				          aThreads[nConexAtu][2],; //ComputerName
				          aThreads[nConexAtu][3],; //ThreadId
				          aThreads[nConexAtu][4])  //ServerName
				
				ConOut("[zMataTudo] "+;
				       "(Tentativa "+cValToChar(nTentativa)+") " + ;
				       "Usuario '"+Alltrim(aThreads[nConexAtu][1])+"', " + ;
				       "Server '"+aThreads[nConexAtu][4]+"', " + ;
				       "Thread '"+cValToChar(aThreads[nConexAtu][3])+"', " + ;
				       "Tempo Total de Conex�o '"+aThreads[nConexAtu][8]+"' ")
			EndIf
		Next
		
		//Pega novamente todos os usu�rios conectados
		aThreads := GetUserInfoArray()
		
		//Se ainda houver registros, aumenta a tentativa e espera 1 segundo
		If Len(aThreads) > 1
			nTentativa++
			Sleep(1000)
			
		//Sen�o finaliza o la�o de repeti��o
		Else
			Exit
		EndIf
	EndDo
	
	ConOut("[zMataTudo] Termino - " + dToC(Date()) + " " + Time())
	
	RestArea(aArea)
Return