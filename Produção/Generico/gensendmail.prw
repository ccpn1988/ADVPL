#include "TOTVS.CH"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �GENSENDMAIL�Autor  �Microsiga           � Data �  09/27/17   ���
��������������������������������������������������������������������������͹��
���Desc.     �fun��o para envio de e-mail em substitui��o a fun��o         ���
���          �sendmail que descontinuada pela totvs no protheus 12         ���
��������������������������������������������������������������������������͹��
���Uso       � Gen                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function GenSendMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach,lMsg,cLog)

Local oServer
Local oMessage
Local aAnexos	:= {} 
Local nAuxAnex	:= 0
Local lRet		:= .T.
Local nRelTime	:= SuperGetMv("MV_RELTIME",.f.,60)
Local cTexto	:= ""

Default cAccount	:= SuperGetMv("MV_RELFROM",.f.,"noreply@grupogen.com.br")
Default cPassword	:= SuperGetMv("MV_RELPSW",.f.,"genrj$1311")
Default cServer		:= SuperGetMv("MV_RELSERV",.f.,"smtp.grupogen.com.br")

Default cFrom		:= SuperGetMv("MV_RELFROM",.f.,"noreply@grupogen.com.br")
Default cEmail		:= "TI@grupoge.com.br"
Default cAssunto	:= "N�o informado"
Default cMensagem	:= " "
Default cAttach		:= " "
Default lMsg		:= .F.
Default cLog		:= ""  
//Default cCopMail	:= ""
//Default cBCopMail	:= ""

//���������������������������Ŀ
//�Traduz a mensagem para HTML�
//�����������������������������
//cMensagem := iif(GetNewPar("MV_ACEMLAC","1") $ "12",ACTxt2Htm(cMensagem),cMensagem)

aFormatTxt := STRTOKARR(cMensagem,Chr(10)+Chr(13)) 
	
For nX = 1 to Len(aFormatTxt)    
	cTexto += aFormatTxt[nX] + "<br>" 
Next nX

cMensagem := cTexto

IF AllTrim(getServerIP()) $ "10.3.0.72/10.220.97.218"
	cEmail := "cleuto.lima@grupogen.com.br" 
ENDIF

aAnexos	:= StrTokArr(cAttach,IIF( ";" $ cAttach , ";" , "," ))

//Cria a conex�o com o server STMP ( Envio de e-mail )
oServer := TMailManager():New()
oServer:Init( "", cServer, cAccount, cPassword, 0, 25 )
   
//seta um tempo de time out com servidor de 1min
If oServer:SetSmtpTimeOut( nRelTime ) != 0
	Conout( "Falha ao setar o time out" )
	Return .F.
EndIf
   
//realiza a conex�o SMTP
If oServer:SmtpConnect() != 0
	Conout( "Falha ao conectar" )
	Return .F.
EndIf
   
//Apos a conex�o, cria o objeto da mensagem
oMessage := TMailMessage():New()
   
//Limpa o objeto
oMessage:Clear()
   
//Popula com os dados de envio
oMessage:cFrom              := cFrom
oMessage:cTo                := cEmail
//oMessage:cCc                := cCopMail
//oMessage:cBcc               := cBCopMail
oMessage:cSubject           := cAssunto
oMessage:cBody              := cMensagem
oMessage:MsgBodyType( "text/html" )

//Adiciona um attach
If Len(aAnexos) > 0 .AND. !Empty(aAnexos[1])
	
	For nAuxAnex := 1 To Len(aAnexos)
		If oMessage:AttachFile( aAnexos[nAuxAnex] ) < 0
			Conout( "Erro ao atachar o arquivo" )
			Return .F.
		Else			
			IF Rat("\",aAnexos[nAuxAnex]) > 0
				cNameAux := SubStr(aAnexos[nAuxAnex], Rat("\",aAnexos[nAuxAnex])+1, Len(aAnexos[nAuxAnex]))
			ELSE	
				cNameAux := aAnexos[nAuxAnex]
			ENDIF	
			//adiciona uma tag informando que � um attach e o nome do arq
			oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cNameAux)
		EndIf
	Next nAuxAnex	
EndIf

  //Envia o e-mail
If oMessage:Send( oServer ) != 0
	Conout( "Erro ao enviar o e-mail" )
	Return .F.
EndIf
   
  //Desconecta do servidor
If oServer:SmtpDisconnect() != 0
	Conout( "Erro ao disconectar do servidor SMTP" )
	Return .F.
EndIf

Return lRet
