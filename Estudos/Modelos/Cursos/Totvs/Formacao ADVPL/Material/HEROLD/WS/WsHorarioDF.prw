#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xWsHorarioDF Description "Horario de Brasilia"
	WsData X        as String

	WsMethod GetHora Description "Retornar o hor�rio de Brasilia"
		WsData cRetTime as String
	
	WsMethod GetData Description "Retornar o Data de Brasilia"
		WsData cRetData as Date
		
				 
WsMethod GetHora WsReceive x WsSend  cRetTime WsService xWsHorarioDF 

 Self:cRetTime := Time()
	 
Return .T. 
				 
WsMethod GetData WsReceive x WsSend  cRetData WsService xWsHorarioDF 

If  x == '123' 

 Self:cRetData := Date()
 
Else
 SetSoapFault( "Metodo n�o dispon�vel", "Senha invalida." )
 Return .F. 
Endif

	 
Return .T. 

