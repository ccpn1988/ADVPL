#Include 'Protheus.ch'

User Function xQualquerNome()
Local oWs := WSXWSHORARIODF():New()

if oWs:GETDATA('123')
	MsgInfo(oWs:dGETDATARESULT)
Else
	MsgInfo(GetWscError())
	MsgInfo(GetWscError(2))
	MsgInfo(GetWscError(3))
EndIf

If oWs:GETHORA('')
	MsgInfo(oWs:cGETHORARESULT)
	GetWscError()

EndIf

Return

