#Include 'Protheus.ch'

User Function ConCEP()

Local cURL     := "http://cep.republicavirtual.com.br/web_cep.php?cep=05778150&formato=xml"
Local cError   := ""
Local cWarning := ""
Local oXml     := NIL
 
//Gera o Objeto XML - @ Parametro por Referencia
oXml := XmlParser(HTTPGET(cURL), "_", @cError, @cWarning )
/* HTTPGET - Retorna uma STRING com o XML da p?gina ou o erro */
MsgInfo(oXml:_WEBSERVICECEP:_LOGRADOURO:TEXT,"Teste")
//MsgInfo(oXml:_PEDIDO:_NOMECLIENTE:Text,"Cliente")

Return

