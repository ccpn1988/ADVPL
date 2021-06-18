#Include 'Protheus.ch'

User Function xDtAtual()

	Local oWs := WSXDATA():New()
	
	If oWs:GetData('x')
		MsgInfo(oWs:dGETDATARESULT)
	Else
		msgInfo(GetWscError())	//Exibir erro gerado - completo
		msgInfo(GetWscError(2))	//Exibir erro gerado - parcial
		msgInfo(GetWscError(3))	//Exibir erro gerado - parcial (mais indicado)
	Endif

Return

