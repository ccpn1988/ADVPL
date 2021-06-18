#Include 'Protheus.ch'

User Function zDolardoDia()

Local oWS := WSFachadaWSSGSService():New()
IF oWS:getUltimoValorXML(1)
	
	MsgInfo(oWS:cgetUltimoValorXMLReturn)

EndIF

Return( NIL )

