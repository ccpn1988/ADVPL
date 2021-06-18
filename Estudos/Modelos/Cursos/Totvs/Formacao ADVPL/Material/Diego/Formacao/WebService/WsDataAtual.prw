#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

WsService xWsDataAtual Description "Data Atual"
	WsData cEnvio as String
	
	WsMethod GetHorario Description "Retorna o Hor�rio Atual do Servidor"
		WsData cRetTime as String
		
	WsMethod GetDataAtual Description "Retorna o Hor�rio Atual do Servidor"
		WsData cRetData as Date

WsMethod GetHorario WsReceive cEnvio WsSend cRetTime WsService xWsDataAtual
	self:cRetTime := Time()
Return .T.

WsMethod GetDataAtual WsReceive cEnvio WsSend cRetData WsService xWsDataAtual
	If cEnvio == '123'
		self:cRetData := Date()
	Else
		SetSoapFault("M�todo n�o Disponivel", "Senha Invalida.")	
		Return .F.
	EndIf	
Return .T.
	