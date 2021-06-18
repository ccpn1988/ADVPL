#Include 'Protheus.ch'

User Function Dolardodia()

Local oWs := WSFachadaWSSGSService():New()
if oWs:getUltimoValorXML(1)

MsgInfo(oWs:cgetUltimoValorXMLReturn)

Endif

Return (NIL)

