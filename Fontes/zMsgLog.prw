/* ===
    Esse ? um exemplo disponibilizado no Terminal de Informa??o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/08/22/funcao-mostra-uma-mensagem-de-log-opcao-de-salvar-em-advpl/
    Caso queira ver outros conte?dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*/{Protheus.doc} zMsgLog
Fun??o que mostra uma mensagem de Log com a op??o de salvar em txt
@type function
@author Atilio
@since 14/04/2017
@version 1.0
@param cMsg, character, Mensagem de Log
@param cTitulo, character, Título da Janela
@param nTipo, num?rico, Tipo da Janela (1 = Ok; 2 = Confirmar e Cancelar)
@param lEdit, l?gico, Define se o Log pode ser editado pelo usu?rio
@return lRetMens, Define se a janela foi confirmada
@example
	u_zMsgLog("Daniel Teste 123", "Título", 1, .T.)
	u_zMsgLog("Daniel Teste 123", "Título", 2, .F.)
/*/

User Function zMsgLog(cMsg, cTitulo, nTipo, lEdit)
	Local lRetMens := .F.
	Local oDlgMens
	Local oBtnOk, cTxtConf := ""
	Local oBtnCnc, cTxtCancel := ""
	Local oBtnSlv
	Local oFntTxt := TFont():New("Lucida Console",,-015,,.F.,,,,,.F.,.F.)
	Local oMsg
	Local nIni:=1
	Local nFim:=50    
	Default cMsg    := "..."
	Default cTitulo := "zMsgLog"
	Default nTipo   := 1 // 1=Ok; 2= Confirmar e Cancelar
	Default lEdit   := .F.
	
	//Definindo os textos dos botões
	If(nTipo == 1)
		cTxtConf:='&Ok'
	Else
		cTxtConf:='&Confirmar'
		cTxtCancel:='C&ancelar'
	EndIf

	//Criando a janela centralizada com os botões
	DEFINE MSDIALOG oDlgMens TITLE cTitulo FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL
		//Get com o Log
		@ 002, 004 GET oMsg VAR cMsg OF oDlgMens MULTILINE SIZE 191, 121 FONT oFntTxt COLORS 0, 16777215 HSCROLL PIXEL
		If !lEdit
			oMsg:lReadOnly := .T.
		EndIf
		
		//Se for Tipo 1, cria somente o bot?o OK
		If (nTipo==1)
			@ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 019 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
		
		//Sen?o, cria os botões OK e Cancelar
		ElseIf(nTipo==2)
			@ 127, 144 BUTTON oBtnOk  PROMPT cTxtConf   SIZE 051, 009 ACTION (lRetMens:=.T., oDlgMens:End()) OF oDlgMens PIXEL
			@ 137, 144 BUTTON oBtnCnc PROMPT cTxtCancel SIZE 051, 009 ACTION (lRetMens:=.F., oDlgMens:End()) OF oDlgMens PIXEL
		EndIf
		
		//Bot?o de Salvar em Txt
		@ 127, 004 BUTTON oBtnSlv PROMPT "&Salvar em .txt" SIZE 051, 019 ACTION (fSalvArq(cMsg, cTitulo)) OF oDlgMens PIXEL
	ACTIVATE MSDIALOG oDlgMens CENTERED

Return lRetMens

/*-----------------------------------------------*
 | Fun??o: fSalvArq                              |
 | Descr.: Fun??o para gerar um arquivo texto    |
 *-----------------------------------------------*/

Static Function fSalvArq(cMsg, cTitulo)
	Local cFileNom :='\x_arq_'+dToS(Date())+StrTran(Time(),":")+".txt"
	Local cQuebra  := CRLF + "+=======================================================================+" + CRLF
	Local lOk      := .T.
	Local cTexto   := ""
	
	//Pegando o caminho do arquivo
	cFileNom := cGetFile( "Arquivo TXT *.txt | *.txt", "Arquivo .txt...",,'',.T., GETF_LOCALHARD)

	//Se o nome n?o estiver em branco	
	If !Empty(cFileNom)
		//Teste de existência do diret?rio
		If ! ExistDir(SubStr(cFileNom,1,RAt('\',cFileNom)))
			Alert("Diret?rio n?o existe:" + CRLF + SubStr(cFileNom, 1, RAt('\',cFileNom)) + "!")
			Return
		EndIf
		
		//Montando a mensagem
		cTexto := "Fun??o   - "+ FunName()       + CRLF
		cTexto += "Usu?rio  - "+ cUserName       + CRLF
		cTexto += "Data     - "+ dToC(dDataBase) + CRLF
		cTexto += "Hora     - "+ Time()          + CRLF
		cTexto += "Mensagem - "+ cTitulo + cQuebra  + cMsg + cQuebra
		
		//Testando se o arquivo j? existe
		If File(cFileNom)
			lOk := MsgYesNo("Arquivo j? existe, deseja substituir?", "Aten??o")
		EndIf
		
		If lOk
			MemoWrite(cFileNom, cTexto)
			MsgInfo("Arquivo Gerado com Sucesso:"+CRLF+cFileNom,"Aten??o")
		EndIf
	EndIf
Return