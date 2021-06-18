#Include 'Protheus.ch'

User Function DolarDoDia()

Local oWs := WSFachadaWSSGSService():New()

if oWs:getValoresSeriesXML(1) // nin0 numerico inteiro se true está no ar
   msginfo(oWs:cgetUltimoValorXMLReturn)
Endif

Return(NIL)

