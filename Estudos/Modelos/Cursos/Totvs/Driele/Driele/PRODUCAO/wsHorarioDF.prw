#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'


WsService XwsHorarioDF Description "Hoario de Brasilia"
  
  WsMethod Gethora Description "Retornar o Horario de Brasilia"
    WsData cRetime as String 
    WsData x       as String
     
    WsMethod GetHora WsReceive x WsSend cRetime WsService XwsHorarioDF
    
    Self:cRetime := Time()
      
Return .T.

