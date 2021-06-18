#Include 'Protheus.ch'

User Function ConCEP()
Local cUrl     := "http://cep.republicavirtual.com.br/web_cep.php?cep=02912000&formato=xml"
Local cHTML    := HTTPGET(cUrl) // Permite emular um client HTTP
Local cError   := ""
Local cWarning := ""
Local oXml     := NIL
 
//Gera o Objeto XML

oXml := XmlParser( cHTML, "_", @cError, @cWarning )

//Exercicio retornar o logradouro na mensagem
 aDados := oXml:_WEBSERVICECEP
 
Msginfo(oXml:_WEBSERVICECEP:_LOGRADOURO:TEXT)
 
Return

