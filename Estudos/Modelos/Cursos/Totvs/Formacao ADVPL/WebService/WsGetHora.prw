#Include 'Protheus.ch'
#Include 'APWEBSRV.ch'

//Não utiliza os campos Function

WsService HORARIO_DF Description "Informar o horario de Brasilia" //WsService - substitui o User Function

	WsMethod GetHorario Description "Hora Atual" //Cria o metodo GetHorario

		WsData cID     as String //Cria a variavel cID como string
		WsData RetTime as String //Cria a variavel RetTime como string

EndWsService //EndWsService - substitui o Return

  //WsMethod - Recebe GetHorario
                      //WsReceive - adiciona o cID ao GetHorario
                                    //WsSend - recebe a resposta do horario para o cID o e GetHorario
                                                   //WsService - Puxa as informações do web service HORARIO_DF
	WsMethod GetHorario WsReceive cID WsSend RetTime WsService HORARIO_DF
	Local lRet := .F.
	
		If cID == "123456" 
		::RetTime := TIME() //:: - Retorna o objeto
		lRet := .T.
		
		Else
		    
		    //Trata a mensagem de erro ao informa um valor invalido
		                //Titulo - Mensagem
			SetSoapFault("Token","Informar um token valido") //Define os valores default do soap
			
		EndIf
		
	Return .T.