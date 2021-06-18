#Include 'Protheus.ch'
//CONSULTA EXTERNA
//RETORNA DE UMA PAGINA QUALQUER
User Function ConCEP()
Local cUrl     := "http://cep.republicavirtual.com.br/web_cep.php?cep=02912000&formato=xml"
Local cHTML    := HTTPGET(cUrl) //Permite emular um client HTTP
Local cError   := ""
Local cWarning := ""
Local oXml 	   := NIL
 
//Gera o Objeto XML

oXml := XmlParser( cHTML , "_", @cError, @cWarning )

//EXERCICIO RETORNAR O LOGRADOURO NA MENSAGEM
//MsgInfo(cHTML)

MsgInfo(oXML:_WEBSERVICECEP:_LOGRADOURO:TEXT)
//UMA VARIAVEL OU ARRAY PODERIA RETORNAR... EXEMPLO : ADADOS := oXML:_WEBSERVICECEP:_LOGRADOURO:TEXT

Return

//CONSULTAR 
//WEBSERVICE CORREIOS WSDL
/// >>>> RESULTADO>>> https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl

//CONSULTAR DOLAR BANCO CENTRAL WEBSERVICE
