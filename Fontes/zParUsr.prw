/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/09/20/funcao-para-editar-usuarios-contidos-em-um-parametro-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define POS_CODIGO  001 //Linha 1
#Define POS_NOME    002 //Linha 1
#Define POS_NOMCOM  004 //Linha 1
#Define POS_FILIAL  006 //Linha 2

/*/{Protheus.doc} zMVUsers
Fun��o para editar o MV_USERS
@author Atilio
@since 16/05/2016
@version 1.0
	@example
	u_zMVUsers()
/*/

User Function zMVUsers()
	u_zParUsr("MV_X_USERS", ";", .T.)
Return

/*/{Protheus.doc} zParUsr
Usu�rios contidos em um parâmetro
@author Atilio
@since 16/05/2016
@version 1.0
	@param cParam, Caracter, C�digos dos usu�rios contidos no parâmetro
	@param cCarSep, Caracter, Caracter de separa��o
	@param lUsrFil, L�gico, Define se trar� apenas os usu�rios que tem acesso a filial logada
	@example
	u_zParUsr("MV_X_USERS", ";", .T.)
/*/

User Function zParUsr(cParam, cCarSep, lUsrFil)
	Local aArea       := GetArea()
	Local nTamBtn     := 50
	Local lEditM      := .F.
	Default cCarSep   := ";"
	Default lUsrFil   := .F.
	Private lUsrFilM  := lUsrFil
	Private nTamFim   := 0
	Private cParamPvt := ""
	Private aUsers    := {}
	//MsSelect
	Private oMAux
	Private cArqs
	Private cMarca    := "OK"
	Private aStrut    := {}
	Private aHeadRegs := {}
	Private cAliasTmp := "USR_"+RetCodUsr()
	//Tamanho da janela
	Private nJanLarg  := 0800
	Private nJanAltu  := 0500
	//Gets e Dialog
	Private oDlgMark
	Private oGetPesq, cGetPesq := Space(100)
	Private oGetReto, cGetReto := ""
	
	//Se o parâmetro estiver em branco, finaliza a rotina
	If Empty(cParam)
		MsgStop("Parâmetro em branco!", "Aten��o")
		Return
	EndIf
	
	//Pegando o tamanho final
	DbSelectArea("SX6")
	nTamFim := Len(SX6->X6_CONTEUD)
	
	//Pegando o conte�do
	cGetReto  := GetMV(cParam)
	cParamPvt := cParam
	
	//Pegando os usu�rios
	aUsers    := AllUsers()
	
	//Criando a estrutura para a MsSelect
	fCriaMsSel()
	
	//Criando a janela
	DEFINE MSDIALOG oDlgMark TITLE "Consulta de Usu�rios ("+cParam+")" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
		//Pesquisar
		@ 003, 003 GROUP oGrpPesqui TO 025, (nJanLarg/2)-3 PROMPT "Pesquisar: "	OF oDlgMark COLOR 0, 16777215 PIXEL
			@ 010, 006 MSGET oGetPesq VAR cGetPesq SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215  VALID (fVldPesq())      PIXEL
		
		//Dados
		@ 028, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "	OF oDlgMark COLOR 0, 16777215 PIXEL
			oMAux := MsSelect():New( cAliasTmp, "XX_OK",, aHeadRegs,, cMarca, { 035, 006, (nJanAltu/2)-28-028, (nJanLarg/2)-6 } ,,, )
			oMAux:bAval := { || ( fGetMkA( cMarca ), oMAux:oBrowse:Refresh() ) }
			oMAux:oBrowse:lHasMark := .T.
			oMAux:oBrowse:lCanAllMark := .F.
			@ (nJanAltu/2)-28-025, 006 SAY oSayReto PROMPT "Usu�rios:"     SIZE 040, 007 OF oDlgMark COLORS RGB(0,0,0) PIXEL
			@ (nJanAltu/2)-28-015, 006 MSGET oGetReto VAR cGetReto SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215      PIXEL
		
			//Populando os dados da MsSelect
			fPopula()
		
		//A�ões
		@ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "A�ões: "	OF oDlgMark COLOR 0, 16777215 PIXEL
			@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fConfirm())     PIXEL
			@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fLimpar())     PIXEL
			@ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Cancelar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fCancela())     PIXEL
			
		//Se n�o for edit�vel, desabilita o get de retorno
		If ! lEditM
			oGetReto:lReadOnly := .T.
		EndIf
		
		oMAux:oBrowse:SetFocus()
	//Ativando a janela
	ACTIVATE MSDIALOG oDlgMark CENTERED
	
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fCriaMsSel                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o para criar a estrutura da MsSelect                    |
 *---------------------------------------------------------------------*/

Static Function fCriaMsSel()
	Local aAreaX3 := SX3->(GetArea())

	//Zerando o cabe�alho e a estrutura
	aHeadRegs := {}
	aStrut := {}
	
	//Adicionando coluna de OK
	//					Campo				Titulo				Mascara
	aAdd( aHeadRegs, {	"XX_OK",		,	" ",				"" } )
	aAdd( aHeadRegs, {	"XX_CODIGO", 	,	"C�digo",			"@!" } )
	aAdd( aHeadRegs, {	"XX_NOME", 		,	"Nome",				"@!" } )
	aAdd( aHeadRegs, {	"XX_NOMCOM", 	,	"Nome Completo",	"@!" } )
	
	//				Campo			Tipo	Tamanho								Decimal
	aAdd( aStrut, {	"XX_OK",		"C",	002,								0} )
	aAdd( aStrut, {	"XX_CODIGO",	"C",	Len(aUsers[1][1][POS_CODIGO]),		0} )
	aAdd( aStrut, {	"XX_NOME",		"C",	Len(aUsers[1][1][POS_NOME]),		0} )
	aAdd( aStrut, {	"XX_NOMCOM",	"C",	Len(aUsers[1][1][POS_NOMCOM]),		0} )

	//Excluindo dados da tabela tempor�ria, se tiver aberta, fecha a tabela
	If Select(cAliasTmp)>0
		(cAliasTmp)->(DbCloseArea())
	EndIf
	fErase(cAliasTmp+".DBF")
	
	//Criando tabela tempor�ria
	cArqs:= CriaTrab( aStrut, .T. )             
	dbUseArea( .T.,"DBFCDX", cArqs, cAliasTmp, .T., .F. )
	
	RestArea(aAreaX3)
Return

/*---------------------------------------------------------------------*
 | Func:  fPopula                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o que popula a tabela auxiliar da MsSelect              |
 *---------------------------------------------------------------------*/

Static Function fPopula()
	Local nAtu
	Local nFilAux
	Local aFilAux
	Local lContinua
	
	//Excluindo dados da tabela tempor�ria, se tiver aberta, fecha a tabela
	If Select(cAliasTmp)>0
		(cAliasTmp)->(DbCloseArea())
	EndIf
	fErase(cAliasTmp+".DBF")
	
	//Criando tabela tempor�ria
	cArqs:= CriaTrab( aStrut, .T. )             
	dbUseArea( .T.,"DBFCDX", cArqs, cAliasTmp, .T., .F. )
	
	//Percorrendo as filiais listadas
	For nAtu := 1 To Len(aUsers)
		//Se filtrar filial e o usu�rio n�o for o Administrador
		If lUsrFilM .And. aUsers[nAtu][1][POS_CODIGO] != "000000"
			aFilAux   := aUsers[nAtu][2][POS_FILIAL]
			lContinua := .F.
			
			//Percorrendo as filiais
			For nFilAux := 1 To Len(aFilAux)
				//Se tiver acesso a filial atual
				If aFilAux[nFilAux] == cEmpAnt+cFilAnt
					lContinua := .T.
				EndIf
			Next
			
			//Caso n�o tenha acesso a filial
			If !lContinua
				Loop
			EndIf
		EndIf
	
		//Se tiver pesquisa
		If !Empty(cGetPesq)
			//Se n�o bater a pesquisa, pula o registro
			If !( 	Alltrim(Upper(cGetPesq)) $ Upper(aUsers[nAtu][1][POS_CODIGO]) .Or.;
					Alltrim(Upper(cGetPesq)) $ Upper(aUsers[nAtu][1][POS_NOME]) .Or.;
					Alltrim(Upper(cGetPesq)) $ Upper(aUsers[nAtu][1][POS_NOMCOM]))
				Loop
			EndIf
		EndIf
		
		cOk := Space(Len(cMarca))
		//Se j� existir no retorno, ser� Ok
		If Alltrim(aUsers[nAtu][1][POS_CODIGO]) $ cGetReto
			cOk := cMarca
		EndIf
	
		//Gravando registro
		RecLock(cAliasTmp, .T.)
			XX_OK		:= cOK
			XX_CODIGO   := aUsers[nAtu][1][POS_CODIGO]
			XX_NOME     := aUsers[nAtu][1][POS_NOME]
			XX_NOMCOM   := aUsers[nAtu][1][POS_NOMCOM]
		(cAliasTmp)->(MsUnlock())
	Next
	
	//Posiciona no topo e atualiza grid
	(cAliasTmp)->(DbGoTop())
	oMAux:oBrowse:Refresh()
Return

/*---------------------------------------------------------------------*
 | Func:  fConfirm                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o de confirma��o da rotina                              |
 *---------------------------------------------------------------------*/

Static Function fConfirm()
	PutMv(cParamPvt, cGetReto)
	oDlgMark:End()
Return

/*---------------------------------------------------------------------*
 | Func:  fLimpar                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o que limpa os dados da rotina                          |
 *---------------------------------------------------------------------*/

Static Function fLimpar()
	//Zerando gets
	cGetPesq := Space(100)
	cGetReto := Space(nTamFim)
	oGetPesq:Refresh()
	oGetReto:Refresh()

	//Atualiza grid
	fPopula()
	
	//Setando o foco na pesquisa
	oGetPesq:SetFocus()
Return

/*---------------------------------------------------------------------*
 | Func:  fCancela                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o de cancelamento da rotina                             |
 *---------------------------------------------------------------------*/

Static Function fCancela()
	oDlgMark:End()
Return

/*---------------------------------------------------------------------*
 | Func:  fVldPesq                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o que valida o campo digitado                           |
 *---------------------------------------------------------------------*/

Static Function fVldPesq()
	Local lRet := .T.
	
	//Se tiver ap�strofo ou porcentagem, a pesquisa n�o pode prosseguir
	If "'" $ cGetPesq .Or. "%" $ cGetPesq
		lRet := .F.
		MsgAlert("<b>Pesquisa inv�lida!</b><br>A pesquisa n�o pode ter <b>'</b> ou <b>%</b>.", "Aten��o")
	EndIf
	
	//Se houver retorno, atualiza grid
	If lRet
		fPopula()
	EndIf
Return lRet

/*---------------------------------------------------------------------*
 | Func:  fGetMkA                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  16/05/2016                                                   |
 | Desc:  Fun��o que marca o registro                                  |
 *---------------------------------------------------------------------*/

Static Function fGetMkA(cMarca)
	Local lChecado:= .F.
	Local lFalhou := .F.
	
	//Verificando se o registro foi checado
	DbSelectArea(cAliasTmp)
	lChecado:=XX_OK <> cMarca
	cChave := Alltrim(&(cAliasTmp+"->XX_CODIGO"))+";"
	
	//Se for checado
	If lChecado
		//Se o tamanho do retorno +chave for maior que o retorno
		If Len(Alltrim(cGetReto) + cChave) > nTamFim
			MsgAlert("Tamanho do Parâmetro Excedido!", "Aten��o")
			lFalhou := .T.
		
		//Atualiza chave
		Else
			cGetReto := Alltrim(cGetReto)+cChave
		EndIf
	
	//Sen�o retira do retorno
	Else
		cGetReto := StrTran(cGetReto, cChave, '')
	EndIf
	cGetReto := cGetReto + Space(nTamFim - Len(cGetReto))
	
	//Se n�o houve falhas
	If !lFalhou
		//Gravando a marca
		RecLock( cAliasTmp, .F. )
			XX_OK := IIF( lChecado, cMarca, "" )
		&(cAliasTmp)->(MsUnlock())
	EndIf
	
	oGetReto:Refresh()
	oMAux:oBrowse:Refresh()
Return