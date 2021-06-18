//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zExpPars
Fun��o que gera uma lista de par�metros em HTML
@author Atilio
@since 15/07/2017
@version 1.0
@type function
/*/

User Function zExpPars()
	MsAguarde({|| fRunProc()}, "Aguarde...", "Processando Par�metros", .T.)
Return

/*---------------------------------------------------*
 | Func: fRunProc                                    |
 | Desc: Fun��o que percorre os par�metros           |
 *---------------------------------------------------*/

Static Function fRunProc()
	Local aArea    := GetArea()
	Local cPasta   := GetTempPath()
	Local cArquivo := "pars_"+dToS(Date())+"_"+StrTran(Time(), ':', '-')+".html"
	Local nTotal   := 0
	Local nAtual   := 0
	Local nHdl     := 0
	
	//Abre a tabela de par�metros
	DbSelectArea('SX6')
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	Count To nTotal
	
	//Cabe�alho do html
	nHdl := fCreate(cPasta+cArquivo)
	fWrite(nHdl, FwNoAccent("<html>") + CRLF)
	fWrite(nHdl, FwNoAccent("<head>") + CRLF)
	fWrite(nHdl, FwNoAccent("<title>Par�metros Protheus</title>") + CRLF)
	fWrite(nHdl, FwNoAccent("</head>") + CRLF)
	fWrite(nHdl, FwNoAccent("<body>") + CRLF)
	fWrite(nHdl, FwNoAccent("<table>") + CRLF)
	fWrite(nHdl, FwNoAccent("<tr>") + CRLF)
	fWrite(nHdl, FwNoAccent("<td><b>Par�metro</b></td>") + CRLF)
	fWrite(nHdl, FwNoAccent("<td><b>Tipo</b></td>") + CRLF)
	fWrite(nHdl, FwNoAccent("<td><b>Conte�do</b></td>") + CRLF)
	fWrite(nHdl, FwNoAccent("</tr>") + CRLF)
	
	//Enquanto houver dados
	SX6->(DbGoTop())
	While ! SX6->(EoF())
		nAtual++
		MsProcTxt("Par�metro "+Alltrim(SX6->X6_VAR)+" ("+cValToChar(nAtual)+" de "+cValToChar(nTotal)+")...")
		
		//Se n�o conter o _X_ (par�metro customizado), incrementa a vari�vel
		If ! '_X_' $ Upper(SX6->X6_VAR)
			fWrite(nHdl, FwNoAccent("<tr>") + CRLF)
			fWrite(nHdl, FwNoAccent("<td>"+Alltrim(SX6->X6_VAR)+"</td>") + CRLF)
			fWrite(nHdl, FwNoAccent("<td>"+SX6->X6_TIPO+"</td>") + CRLF)
			fWrite(nHdl, FwNoAccent("<td>"+Alltrim(Alltrim(SX6->X6_DESCRIC)+" "+Alltrim(SX6->X6_DESC1)+" "+Alltrim(SX6->X6_DESC2))+"</td>") + CRLF)
			fWrite(nHdl, FwNoAccent("</tr>") + CRLF)
		EndIf 
		SX6->(DbSkip())
	EndDo
	
	fWrite(nHdl, FwNoAccent("</table>") + CRLF)
	fWrite(nHdl, FwNoAccent("</body>") + CRLF)
	fWrite(nHdl, FwNoAccent("</html>") + CRLF)
	fClose(nHdl)
	
	//Abre o arquivo
	If MsgYesNo("Arquivo '"+cPasta+cArquivo+"' gerado. Deseja abrir?", "Aten��o")
		ShellExecute("OPEN", cPasta+cArquivo, "", cPasta, 0 )
	EndIf
	RestArea(aArea)
Return