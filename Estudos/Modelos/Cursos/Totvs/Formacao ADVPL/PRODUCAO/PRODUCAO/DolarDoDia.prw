#Include 'Protheus.ch'

User Function DolarDoDia()
	
	Local oWs := WSFachadaWSSGSService():New()
	
	If oWs:getUltimoValorXML(1)
		
		MsgInfo (oWs:cgetUltimoValorXMLReturn)
		
	Endif
	
Return (NIL)

