#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xData Description "Data Atual"

	WsMethod GetData Description "Data Atual"
	WsData cRetData	as Date
	WsData x		as String
	
	WsMethod GetData WsReceive x WsSend cRetData WsService xData
		
		Self:cRetData := Date()
	
	Return .T. //Sempre retornar True .T.
	
//	SetSoapFault("Metodo não Disponível", "Senha Invalida.")	//Tratamento de erros no WebService.
//	Return .F.
