#Include 'Protheus.ch'

User Function DolarDoDia()
	
	/*INSTANCIANDO UM OBEJTO RM ADVPL*/
	Local oWs := WSFachadaWSSGSService():New()
	/*PARAMETROS DEVEM SER SEPARADOS POR VIRGULAS*/
	oWs:getUltimoValorXML(1)
	
	/*Verifica o Retorno da Chamada*/
	IF oWs:getUltimoValorXML(1)
		MsgInfo(oWs:cgetUltimoValorXMLReturn)
	EndIf	
	
	/*COMO RETORNA UM XML DEVEMOS FAZER UM PARSE POIS O RETORNO È UMA STRING*/
	//oXml := XmlParser(oWs:cgetUltimoValorXMLReturn, "_", @cError, @cWarning )
	/* HTTPGET - Retorna uma STRING com o XML da página ou o erro */
	// PEGAR O PARAMETRO DENTRO DO MEU OBJETO - MsgInfo(oXml:_WEBSERVICECEP:_LOGRADOURO:TEXT,"Teste")
Return

