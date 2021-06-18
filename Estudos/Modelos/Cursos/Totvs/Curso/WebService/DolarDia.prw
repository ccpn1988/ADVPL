#Include 'Protheus.ch'

User Function DolarDia()
Local Ows:= WSFachadaWSSGSService():NEW() //WSFachadaWSSGSService - M�todo do webservice | New - Construtor
Local cError   := ""
Local cWarning := ""
Local oXml := NIL

oWs:getUltimoValorXML(10813) // M�todo utilizado do webservice | 10813 - Retorna o valor de compra do dolar
 
//Gera o Objeto XML
oXml := XmlParser( oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning )
MsgInfo(oXml:_RESPOSTA:_SERIE:_datA:_DIA:TEXT +"/"+oXml:_RESPOSTA:_SERIE:_datA:_MES:TEXT+"/"+oXml:_RESPOSTA:_SERIE:_datA:_ANO:TEXT)

MsgInfo(oXml:_RESPOSTA:_SERIE:_VALOR:TEXT)


Return

