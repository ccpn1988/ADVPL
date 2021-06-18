//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zChooseFile
Fun��o que abre a tela padr�o do Windows Explorer para escolher um arquivo
@author Atilio
@since 03/08/2017
@version undefined
@param cMascara, characters, M�scara para escolha de arquivos (Descri��o *.extens�o | *.extens�o)
@type function
@example Exemplos abaixo:
	//Escolher qualquer arquivo ( *.* ):
	u_zChooseFile()
	
	//Escolher somente arquivos texto ( *.txt )
	u_zChooseFile("Arquivos Texto (*.txt)|*.txt")
	
	//Escolher arquivos texto ou todos (*.txt ou *.*)
	u_zChooseFile("Arquivos Texto (*.txt)|*.txt|Todos Arquivos (*.*)|*.*")
	
	//Escolher imagens png ou jpg (*.png ou *.jpg)
	u_zChooseFile("Arquivos Texto (*.png)|*.png|Arquivos Texto (*.jpg)|*.jpg")
/*/

User Function zChooseFile(cMascara)
	Local cResultado := ""
	Local cComando   := ""
	Local cDir       := GetTempPath()
	Local cNomBat    := "zChooseFile.bat"
	Local cArquivo   := "resultado.txt"
	Local cMac       := ""
	Default cMascara := "Todos Arquivos (*.*)|*.*"
	
	//Se o resultado j� existir, exclui
	If File(cDir + cArquivo)
		FErase(cDir + cArquivo)
	EndIf
	
	//Monta o comando para abrir a tela de sele��o do windows
	cComando += '@echo off' + CRLF
	cComando += 'setlocal' + CRLF
	cComando += 'set ps_cmd=powershell "Add-Type -AssemblyName System.windows.forms|Out-Null;$f=New-Object System.Windows.Forms.OpenFileDialog;$f.Filter=' + "'"+cMascara+"'" + ';$f.showHelp=$true;$f.ShowDialog()|Out-Null;$f.FileName"' + CRLF
	cComando += '' + CRLF
	cComando += 'for /f "delims=" %%I in (' + "'%ps_cmd%'" + ') do set "filename=%%I"' + CRLF
	cComando += '' + CRLF
	cComando += 'if defined filename (' + CRLF
	cComando += '    echo %filename% > '+cArquivo + CRLF
	cComando += ')' + CRLF
	
	//Gravando em um .bat o comando
	MemoWrite(cDir + cNomBat, cComando)
	
	//Executando o comando atrav�s do .bat
	WaitRun(cDir+cNomBat, 2)
	
	//Se existe o arquivo
	If File(cDir + cArquivo)
	
		//Pegando o resultado que o usu�rio escolheu
		cResultado := MemoRead(cDir + cArquivo)
	EndIf
Return cResultado