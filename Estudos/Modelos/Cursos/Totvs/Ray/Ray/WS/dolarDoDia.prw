#Include 'Protheus.ch'

User Function dolarDoDia()
	
	Local oWs := WSFachadaWSSGSService():New()
	
	If oWs:getUltimoValorXML(1)
		msgInfo(oWs:cGetUltimoValorXMLReturn)
	Endif
	
Return

