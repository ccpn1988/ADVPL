#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xWsHorarioDf Description "Horario de Brasilia"
	
	WsMethod GetHora Description "Retornar o hor�rio de Bras�lia"
	
		WsData cRetTime as String
		WsData X		as String
	
	WsMethod GetHora WsReceive x WsSend cRetTime WsService xWsHorarioDf		
		self:cRetTime := Time()
		
	Return .T. //S
