#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

/*LISTA NA PAGINA*/
WsService xWsHorarioDF Description "Hor�rio de Bras�lia"
	
/*AO ABRIR ELES< MOSTRARA TODOS OS METODOS EXISTENTES*/	
WsMethod GetHora Description "Retornar o Hor�rio de Brasilia"
	
	WsData cRetTime as String
	WsData x 		as String
	
WsMethod GetHora WsReceive x WsSend cRetTime WsService xWsHorarioDF
	self:cRetTime := Time()
Return .T.

