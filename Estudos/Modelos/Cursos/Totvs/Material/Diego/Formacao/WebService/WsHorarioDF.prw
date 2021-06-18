#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

/*LISTA NA PAGINA*/
WsService xWsHorarioDF Description "Horário de Brasília"
	
/*AO ABRIR ELES< MOSTRARA TODOS OS METODOS EXISTENTES*/	
WsMethod GetHora Description "Retornar o Horário de Brasilia"
	
	WsData cRetTime as String
	WsData x 		as String
	
WsMethod GetHora WsReceive x WsSend cRetTime WsService xWsHorarioDF
	self:cRetTime := Time()
Return .T.

