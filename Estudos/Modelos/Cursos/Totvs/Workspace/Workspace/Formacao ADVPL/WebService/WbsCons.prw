#Include 'Protheus.ch'

User Function WbsCons()
Local oWms := WSXWSHORARIODF():New()

IF oWms:GetData('123')
	MsgInfo(oWms:dGETDATARESULT)
EndIF

IF oWms:GetHora()
	MsgInfo(oWms:dGETHORARESULT)
	GetWscError()
EndIF


Return

