#Include 'Protheus.ch'


User Function ConCEP()
	Local cURL := "http://cep.republicavirtual.com.br/web_cep.php?cep=91010000&formato=xml"
	Local cHTML := HTTPGET(cURL) //Permite emular um client HTTP
	Local cError   := ""
	Local cWarning := ""
	Local oXml := NIL
	
	//Gera o Objeto XML
	oXml := XmlParser( cHTML, "_", @cError, @cWarning )
	MsgInfo (oXml:_WEBSERVICECEP:_LOGRADOURO:TEXT)
Return

