#Include 'Protheus.ch'

User Function WSHORARIO_DF() //Mesmo nome do wsclient
Local oWs     := WSHORARIO_DF():New() //Metodo WSHORARIO_DF como New
Local nResult := ""
Local cErro   := ""

	If oWs:GETHORARIO("123456") //Se o método GetHorario for igual a 123456  
	
		nResult := oWs:cGETHORARIORESULT //Retorna o Horario com o método oWs:cGETHORARIORESULT atribuido a variavel nResult
		MsgInfo(nResult)
		
	Else
		
		cErro := GetWSErro() //Exibe o erro caso ocorra
		MsgInfo("Erro: " +cErro)
		
	EndIf	
		
Return

