#include "protheus.ch"
#include "rwmake.ch"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³funcion   ³ _EnvEmail ³ autor ³  Ivan de Oliveira  ³ data ³ 11/07/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³descrip.  ³ Função para envio de E-mail				   	     		  ³±±
±±³          ³  											    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±              
±±³ uso      ³ Exclusivo RadioWay -                           			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³parametros³                             								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/                                                                            
User Function _EnvEmail ( _cSmtpServer, _cCtaSmtp, _cSenSmtp, _nSmtpPort, _lUsaSSL  , _lUsaTLS, _lAuten , _CtaPara, _cCtaCC,;
						  _cCtaCCo	  , _cAssunto, _aAnexo	, _cMensagem, _lExibMens, _cIdenEnvio )  

Local _oServer
Local _oMessage
Local _lRet        := .f.   
Local _nItens      := 0 

Default _lExibMens := .f.  
Default _cIdenEnvio:= FunName()  
Default _nSmtpPort := 25   
Default _lUsaSSL   := .f.  
Default _lUsaTLS   := .f.
 
//Cria a conexão com o server STMP ( Envio de e-mail )numérico 
// Init( < cMailServer >, < cSmtpServer >, < cAccount >, < cPassword >, [ nMailPort ], [ nSmtpPort ] )
_oServer := TMailManager():New()
_oServer:Init( "", _cSmtpServer, _cCtaSmtp, _cSenSmtp, 0, _nSmtpPort )
   
//seta um tempo de time out com servidor de 1min
_nTimeout := _oServer:SetSmtpTimeOut( 60 )
If _nTimeout == 0  

	//realiza a conexão SMTP
	_nRetConex := _oServer:SmtpConnect() 
	If _nRetConex == 0 
	
		_nErrAut := 0   
		_oServer:SetUseSSL( _lUsaSSL )
   		_oServer:SetUseTLS( _lUsaTLS )
	
		// Servidor com autenticação?
		if _lAuten  
	
	   		_nErrAut := _oServer:SmtpAuth( _cCtaSmtp, _cSenSmtp )  
	   		
		Endif       
		       
		// Autenticado
		if _nErrAut == 0
	
			//Apos a conexão, cria o objeto da mensagem
			_oMessage := TMailMessage():New()
	 
			//Limpa o objeto
			_oMessage:Clear()
			   
			//Popula com os dados de envio
			_oMessage:cFrom    := _cCtaSmtp
			_oMessage:cTo      := _CtaPara
			_oMessage:cCc      := _cCtaCC
			_oMessage:cBcc     := _cCtaCCo
			_oMessage:cSubject := _cAssunto
			_oMessage:cBody    := _cMensagem      
	    
	 		//Adiciona um attach   
			for _nItens := 1 to len(_aAnexo) 
			
				_nAtch := _oMessage:AttachFile( _aAnexo[_nItens] ) 
				
				if _nAtch == 0 
		
					//adiciona uma tag informando que é um attach e o nome do arq
					_oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=' + _aAnexo[_nItens] ) 
					
				Else 
					_cTxtErr := _oServer:GetErrorString( _nAtch )
			   		_MostaErr ( "Falha na tentativa de atachar arquivo, comunique ao administrador do sistema. Erro: " + _cTxtErr,;
			   					 _cIdenEnvio,  _lExibMens )
				
				Endif     
				
			Next
			
			//Envia o e-mail  
			_nEnvMens := _oMessage:Send( _oServer ) 
			 
			if _nEnvMens != 0 
			
				_cTxtErr := _oServer:GetErrorString( _nEnvMens )
			 	_MostaErr ( "Falha na tentativa de enviar mensagens, comunique ao administrador do sistema. Erro: " + _cTxtErr,;
			 			 _cIdenEnvio,  _lExibMens )
		   			
			Else
			
				_lRet := .t.
				
			EndIf 
			
		Else   
			
			_cTxtErr := _oServer:GetErrorString( _nErrAut )
			_MostaErr ( "Falha na tentativa de conectar o servidor de mensagens, comunique ao administrador do sistema. Erro: " + _cTxtErr,;
						 _cIdenEnvio,  _lExibMens )
		
		Endif
	
		_oServer:smtpDisconnect() 
	
	Else
	
		_cTxtErr := _oServer:GetErrorString( _nRetConex )
	 	_MostaErr ( "Falha na tentativa de conectar o servidor de mensagens, comunique ao administrador do sistema. Erro: " + _cTxtErr;
					, _cIdenEnvio,  _lExibMens )
		
 	Endif
 
Else 

	_cTxtErr := _oServer:GetErrorString(_nTimeout)
	_MostaErr ( "Falha na tentativa de conectar o servidor de mensagens, comunique ao administrador do sistema. Erro: " + _cTxtErr;
			    ,_cIdenEnvio,  _lExibMens )

EndIf
  
Return _lRet           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³funcion   ³ _MostaErr ³ autor ³  Ivan de Oliveira  ³ data ³ 11/07/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³descrip.  ³ Envia notificação de erro de e-mail	   	     		  	  ³±±
±±³          ³  											    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±              
±±³ uso      ³ Exclusivo RadioWay				                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³parametros³                             								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/                                                                            
Static Function _MostaErr ( _cTexto, _cIdenEnvio,  _lExibMens )
                                                   

// Se solicitado exibição de mensagens
if _lExibMens 
	
	MsgStop ( _cTexto, _cIdenEnvio )
	
Else
	
	Conout( _cTexto + _cIdenEnvio )
	
Endif


Return

