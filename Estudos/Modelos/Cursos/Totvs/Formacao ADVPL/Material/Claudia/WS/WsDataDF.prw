#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

User Function xWsDataDF()


WsService xWsDataDF Description "Data Atual"

	WsMetHod GetData Description "Retornar a Data Atual"
		WsData cRetData as Date
		WsData X        as Date
		
WsMethod GetData WsReceive x WsSend cRetData WsService xWsDataDF

IF X == '123'
	Self:cRetData := Date() //Usando a variavel do objeto
//ELSE
//    SetSoapFault("Método não disponível","Senha inválida")
//    Return .F.
ENDIF	
		
Return .T. 

//http://localhost:8099/ws/WSINDEX.apw?cOp=03&WSVCNAME=XWSDATADF&WSVCMETHOD=GETDATA

Return

