/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/07/25/funcao-sobe-um-arquivo-em-um-ftp-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zFTPEnv
Fun��o que envia um arquivo para um servidor FTP
@author Atilio
@since 28/03/2017
@version 1.0
	@param cEndereco, Caracter, Endere�o do FTP
	@param nPorta, Numerico, Porta de Conex�o
	@param cUsr, Caracter, Usu�rio
	@param cPass, Caracter, Senha
	@param cArq, Caracter, Arquivo a ser enviado (deve estar dentro da \System\)
	@return lRet, Retorno l�gico se deu certo ou n�o o envio
/*/

User Function zFTPEnv(cEndereco, nPorta, cUsr, cPass, cArq)
	Local aArea   := GetArea()
	Local lRet    := .T.
	Local cDirAbs := GetSrvProfString("STARTPATH","")  
	cDirAbs       += "\" + cArq
	
	//Se conseguir conectar
	If FTPConnect(cEndereco ,nPorta ,cUsr , cPass )
		
		//Desativa o firewall
		FTPSetPasv(.F.)		
		
		//Se n�o conseguir dar o upload
		If !FTPUpload(cDirAbs, cArq)
			//Realiza mais uma tentativa
			If !FTPUpload(cDirAbs, cArq)
				lRet:=.F.
			EndIf
		EndIf
		
		//Desconecta do FTP
		FTPDisconnect()
	EndIf

	RestArea(aArea)
Return lRet