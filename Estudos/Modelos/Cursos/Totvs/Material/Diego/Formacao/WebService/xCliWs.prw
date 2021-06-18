#Include 'Protheus.ch'

User Function xCliWs()
	Local oWs := WSXWSDATAATUAL():new()
	
	If oWs:GETDATAATUAL('12')
		MsgInfo(oWs:dGETDATAATUALRESULT)
	else
		MsgInfo(getWscError())	
		MsgInfo(getWscError(2))	
		MsgInfo(getWscError(3))	
	Endif
	
	If oWs:GETHORARIO('')
		MsgInfo(oWs:cGETHORARIORESULT)
	Endif	
Return

