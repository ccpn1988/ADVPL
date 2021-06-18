//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zPegaMac
Pegando o MAC Address de m�quinas hospedeiras com Windows
@author Atilio
@since 23/09/2014
@version 1.0
	@example
	u_zPegaMac()
	@see http://terminaldeinformacao.com/advpl/
/*/

User Function zPegaMac()
	Local cComando	:= "getmac > "
	Local cDir			:= GetTempPath()
	Local cNomBat		:= "comando_mac.bat"
	Local cArquivo	:= "mac_address.txt"
	Local cMac			:= ""
	
	//Gravando em um .bat o comando
	MemoWrite(cDir + cNomBat, cComando + cDir + cArquivo)
	
	//Executando o comando atrav�s do .bat
	ShellExecute("OPEN", cDir+cNomBat, "", cDir, 0 )
	
	//Se existe o arquivo
	If File(cDir+cArquivo)
		ConOut("[zPegaMac] > Arquivo gerado.")
		
		//Gerando o MacAddress
		cMac := MemoRead(cDir + cArquivo)
		cMac := SubStr(cMac, RAt("=", cMac)+1, Len(cMac)) //Pegando a partir do ultimo igual
		cMac := SubStr(cMac, 1, At(" ", cMac)-1) //Pegando at� o primeiro espa�o
		cMac := StrTran(cMac, Chr(13)+Chr(10), "") //retirando os -enters-
	EndIf
	//Alert("|"+cMac+"|")
Return cMac