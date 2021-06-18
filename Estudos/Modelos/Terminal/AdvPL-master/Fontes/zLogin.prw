//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLogin
Fun��o para montar a tela de login simplificada
@type function
@author Atilio
@since 17/09/2015
@version 1.0
	@param cUsrLog, Caracter, Usu�rio para o login (ex.: "admin")
	@param cPswLog, Caracter, Senha para o login (ex.: "123")
	@return lRet, Retorno l�gico se conseguiu encontrar o usu�rio digitado
	@example
	//Verificando se o login deu certo
	If u_zLogin(@cUsrAux, @cPswAux)
		//....
	EndIf
/*/

User Function zLogin(cUsrLog, cPswLog)
	Local aArea := GetArea()
	Local oGrpLog
	Local oBtnConf
	Private lRetorno := .F.
	Private oDlgPvt
	//Says e Gets
	Private oSayUsr
	Private oGetUsr, cGetUsr := Space(25)
	Private oSayPsw
	Private oGetPsw, cGetPsw := Space(20)
	Private oGetErr, cGetErr := ""
	//Dimens�es da janela
	Private nJanLarg := 200
	Private nJanAltu := 200
	
	//Criando a janela
	DEFINE MSDIALOG oDlgPvt TITLE "Login" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
		//Grupo de Login
		@ 003, 001 	GROUP oGrpLog TO (nJanAltu/2)-1, (nJanLarg/2)-3 		PROMPT "Login: " 	OF oDlgPvt COLOR 0, 16777215 PIXEL
			//Label e Get de Usu�rio
			@ 013, 006   SAY   oSayUsr PROMPT "Usu�rio:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
			@ 020, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL
		
			//Label e Get da Senha
			@ 033, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
			@ 040, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD
		
			//Get de Log, pois se for Say, n�o da para definir a cor
			@ 060, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
			oGetErr:lActive := .F.
			oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")
		
			//Bot�es
			@ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (fVldUsr()) PIXEL
			oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
	ACTIVATE MSDIALOG oDlgPvt CENTERED
	
	//Se a rotina foi confirmada e deu certo, atualiza o usu�rio e a senha
	If lRetorno
		cUsrLog := Alltrim(cGetUsr)
		cPswLog := Alltrim(cGetPsw)
	EndIf
	
	RestArea(aArea)
Return lRetorno

/*---------------------------------------------------------------------*
 | Func:  fVldUsr                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  17/09/2015                                                   |
 | Desc:  Fun��o para validar se o usu�rio existe                      |
 *---------------------------------------------------------------------*/

Static Function fVldUsr()
	Local cUsrAux := Alltrim(cGetUsr)
	Local cPswAux := Alltrim(cGetPsw)
	Local cCodAux := ""
	
	//Pega o c�digo do usu�rio
	PswOrder(2)
	If !Empty(cUsrAux) .And. PswSeek(cUsrAux)
 		cCodAux := PswRet(1)[1][1]
 	
 		//Agora verifica se a senha bate com o usu�rio
 		If !PswName(cPswAux)
 			cGetErr := "Senha inv�lida!"
 			oGetErr:Refresh()
			Return
		
		//Sen�o, atualiza o retorno como verdadeiro
		Else
			lRetorno := .T.
		endif
 	
 	//Sen�o atualiza o erro e retorna para a rotina
 	Else
 		cGetErr := "Usu�rio n�o encontrado!"
 		oGetErr:Refresh()
 		Return
	EndIf
	
	//Se o retorno for v�lido, fecha a janela
	If lRetorno
		oDlgPvt:End()
	EndIf
Return