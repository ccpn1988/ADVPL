#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'


WsService XWsData Description "Data Atual"
  
  WsMethod GetData Description "Retornar a Data e o ano Atual"
    WsData cRetData as Date 
    WsData x        as Date
     
    WsMethod GetData WsReceive x WsSend cRetdata WsService XWsData 
    
If x == '123'
    
    Self:cRetData  := Data()
    
Else
    SetSoapFault ("Metodo n?o dispon?vel", "Senha invalida")
    Return .F.    
Endif
      
Return .T.