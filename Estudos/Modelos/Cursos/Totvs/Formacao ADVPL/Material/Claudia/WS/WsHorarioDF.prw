#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xWsHorarioDF Description "Hor�rio de Brasilia"

	WsMetHod GetHora Description "Retornar o hor�rio de Brasilia"
		WsData cRetTime as String
		WsData X        as String
		
WsMethod GetHora WsReceive x WsSend cRetTime WsService xWsHorarioDF

	Self:cRetTime := Time() //Usando a variavel do objeto
		
Return .T.	

//Exercicio criar um novo WS para retornar a Data atual

