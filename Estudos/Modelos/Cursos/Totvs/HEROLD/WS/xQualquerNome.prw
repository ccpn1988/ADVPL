#Include 'Protheus.ch'

User Function xQualquerNome()
Local oWs := WSXWSHORARIODF():New()

If oWs:GETDATA('12')
	Msginfo(oWs:dGETDATARESULT)
Else
	msginfo(GetWscError())
	msginfo(GetWscError(2))
	msginfo(GetWscError(3))	
EndIf

If oWs:GETHORA('')
	Msginfo(oWs:cGETHORARESULT)
	GetWscError()
EndIf

Return

