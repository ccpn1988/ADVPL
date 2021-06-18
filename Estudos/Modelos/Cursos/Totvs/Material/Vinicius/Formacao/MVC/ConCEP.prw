#Include 'Protheus.ch'

User Function ConCEP()
Local cUrl := "http://cep.republicavirtual.com.br/web_cep.php?cep=13451084&formato=xml"
Local cHTML := HTTPGET(cUrl) //permite emular um client HTTP
Local cError   := ""
Local cWarning := ""
Local oXml := NIL
 
//Gera o Objeto XML						//parametro por referencia
oXml := XmlParser( cHTML, "_", @cError, @cWarning )



MsgInfo(oXml:_WEBSERVICECEP:_LOGRADOURO:TEXT)
Return

