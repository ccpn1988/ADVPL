#Include 'Protheus.ch'
#include 'APWEBSRV.ch'

WsService xWSHorarioDF Description "Hor�rio de Brasilia"

	WsMethod GetHora Description "Retornar o Hor�rio de Brasilia"
		WsData x 		as String

		WsData cRetTime as String	
		
	WsMethod GetData Description "Retornar a Data de Hoje"
		WsData cRetDate as Date

WsMethod GetHora WsReceive x WsSend cRetTime WsService xWSHorarioDF	
	
	Self:cRetTime := Time()

Return .T. 
//OUTRO SERVI�O COM MESMO WEBSERVICE
WsMethod GetData WsReceive x WsSend cRetDate WsService xWSHorarioDF	

 Self:cRetDate := Date()

Return .T.