#Include 'Protheus.ch'

User Function conCep()

	Local cUrl	:= "http://cep.republicavirtual.com.br/web_cep.php?cep=02912000&formato=xml"
	Local cHTML :=	HTTPGET(cUrl) //Permite emular um client HTTP

	Local cError   := ""
	Local cWarning := ""
	Local oXml := NIL
 
	//Gera o Objeto XML
	oXml := XmlParser(cHtml, "_", @cError, @cWarning)
	
	MsgInfo(oXml:_WEBSERVICECEP:_Logradouro:Text, "teste")


Return

