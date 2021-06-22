/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/10/04/funcao-tira-caracteres-especiais-dos-campos-protheus/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLimpaEsp
Fun��o que limpa os caracteres especiais dentro de um campo
@type function
@author Atilio / Achoa
@since 25/04/2016
@version 1.0
@param lEndereco, L�gico, Define se o campo � endere�o (caso sim, o tra�o e vírgula ser�o ignorados)
	@example
	u_zLimpaEsp()
/*/

User Function zLimpaEsp(lEndereco)
	Local aArea       := GetArea()
	Local cCampo      := ReadVar()
	Local cConteudo   := &(cCampo)
	Local nTamOrig    := Len(cConteudo)
	Default lEndereco := .F.
	
	//Retirando caracteres
	cConteudo := StrTran(cConteudo, "'", "")
	cConteudo := StrTran(cConteudo, "#", "")
	cConteudo := StrTran(cConteudo, "%", "")
	cConteudo := StrTran(cConteudo, "*", "")
	cConteudo := StrTran(cConteudo, "&", "E")
	cConteudo := StrTran(cConteudo, ">", "")
	cConteudo := StrTran(cConteudo, "<", "")
	cConteudo := StrTran(cConteudo, "!", "")
	cConteudo := StrTran(cConteudo, "@", "")
	cConteudo := StrTran(cConteudo, "$", "")
	cConteudo := StrTran(cConteudo, "(", "")
	cConteudo := StrTran(cConteudo, ")", "")
	cConteudo := StrTran(cConteudo, "_", "")
	cConteudo := StrTran(cConteudo, "=", "")
	cConteudo := StrTran(cConteudo, "+", "")
	cConteudo := StrTran(cConteudo, "{", "")
	cConteudo := StrTran(cConteudo, "}", "")
	cConteudo := StrTran(cConteudo, "[", "")
	cConteudo := StrTran(cConteudo, "]", "")
	cConteudo := StrTran(cConteudo, "/", "")
	cConteudo := StrTran(cConteudo, "?", "")
	cConteudo := StrTran(cConteudo, ".", "")
	cConteudo := StrTran(cConteudo, "\", "")
	cConteudo := StrTran(cConteudo, "|", "")
	cConteudo := StrTran(cConteudo, ":", "")
	cConteudo := StrTran(cConteudo, ";", "")
	cConteudo := StrTran(cConteudo, '"', '')
	cConteudo := StrTran(cConteudo, '°', '')
	cConteudo := StrTran(cConteudo, 'ª', '')
	
	//Se n�o for endere�o, retira tamb�m o - e a ,
	If !lEndereco
		cConteudo := StrTran(cConteudo, ",", "")
		cConteudo := StrTran(cConteudo, "-", "")
	EndIf
	
	//Adicionando os espa�os a direita
	cConteudo := Alltrim(cConteudo)
	cConteudo += Space(nTamOrig - Len(cConteudo))
	
	//Definindo o conte�do do campo
	&(cCampo+" := '"+cConteudo+"' ")
	
	RestArea(aArea)
Return .T.

/*/{Protheus.doc} zCarEspec
Script para atualiza��o de campos que ter�o sua valida��o de usu�rio alterada
@type function
@author Atilio
@since 25/04/2016
@version 1.0
/*/

User Function zCarEspec()
	Local aArea     := GetArea()
	Local aTexto    := {}
	Local aBotoes   := {}
	Local lContinua := .F.
	
	//Adicionando textos da rotina
	aAdd(aTexto, 'Esta rotina tem por objetivo atualizar campos para ')
	aAdd(aTexto, 'n�o aceitar caracteres especiais em cadastros.')
	aAdd(aTexto, '')
	aAdd(aTexto, 'Ser� atualizado:')
	aAdd(aTexto, 'Parâmetro MV_ACENTO')
	aAdd(aTexto, 'Tabelas SA1, SA2, SA4 e SB1')

	//Adicionando os botões da rotina
	aAdd(aBotoes, {1, .T., {|| lContinua := .T., FechaBatch()}})
	aAdd(aBotoes, {2, .T., {|| lContinua := .F., FechaBatch()}})

	//Mostra o batch esperando intera��o do usu�rio
	FormBatch("Atualiza��o de campos", aTexto, aBotoes) 
		
	//Se for para continuar o processamento
	If lContinua
		Processa({|| fAtualiza()}, "Processando...")
	EndIf
	
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fAtualiza                                                    |
 | Autor: Daniel Atilio                                                |
 | Data:  25/04/2016                                                   |
 | Desc:  Fun��o que atualiza os dados                                 |
 *---------------------------------------------------------------------*/

Static Function fAtualiza()
	Local aAreaX3    := SX3->(GetArea())
	Local aCampos    := {}
	Local aCamposEnd := {}
	Local cValidUsr  := ""
	Local nAtual     := 0
	
	DbSelectArea('SX3')
	SX3->(dbSetOrder(2)) // X3_CAMPO
	ProcRegua(3)
	
	//Campos normais
	aAdd(aCampos, 'A1_NOME')
	aAdd(aCampos, 'A1_NREDUZ')
	aAdd(aCampos, 'A1_BAIRRO')
	aAdd(aCampos, 'A1_MUN')
	aAdd(aCampos, 'A2_NOME')
	aAdd(aCampos, 'A2_NREDUZ')
	aAdd(aCampos, 'A2_BAIRRO')
	aAdd(aCampos, 'A2_MUN')
	aAdd(aCampos, 'A4_NOME')
	aAdd(aCampos, 'A4_NREDUZ')
	aAdd(aCampos, 'A4_BAIRRO')
	aAdd(aCampos, 'B1_DESC')
	
	//Campos de endere�o
	aAdd(aCamposEnd, 'A1_END')
	aAdd(aCamposEnd, 'A2_END')
	aAdd(aCamposEnd, 'A4_END')
	
	//Atualiza o MV_ACENTO para n�o aceitar acentua��o no sistema
	IncProc("Atualizando parâmetro...")
	PutMV('MV_ACENTO', 'N')
	
	//Percorrendo os campos normais
	IncProc("Atualizando campos normais...")
	SX3->(DbGoTop())
	For nAtual := 1 To Len(aCampos)
		//Se conseguir posicionar
		If SX3->(DbSeek(aCampos[nAtual]))
			cValidUsr := Alltrim(SX3->X3_VLDUSER)
			
			//Se j� tiver, pula o campo
			If "U_ZLIMPAESP" $ Upper(cValidUsr)
				nAtual++
				Loop
			EndIf
			
			//Se tiver conte�do, adiciona .And. no valid
			If !Empty(cValidUsr)
				cValidUsr += ".And."
			Endif
			
			//Definindo a express�o
			cValidUsr += "u_zLimpaEsp()"
			
			//Atualiza no banco
			RecLock('SX3', .F.)
				X3_VLDUSER := cValidUsr
			SX3->(MsUnlock())
		EndIf
	Next
	
	//Percorrendo os campos de endere�o
	IncProc("Atualizando campos de endere�o...")
	SX3->(DbGoTop())
	For nAtual := 1 To Len(aCamposEnd)
		//Se conseguir posicionar
		If SX3->(DbSeek(aCamposEnd[nAtual]))
			cValidUsr := Alltrim(SX3->X3_VLDUSER)
			
			//Se j� tiver, pula o campo
			If "U_ZLIMPAESP" $ Upper(cValidUsr)
				nAtual++
				Loop
			EndIf
			
			//Se tiver conte�do, adiciona .And. no valid
			If !Empty(cValidUsr)
				cValidUsr += ".And."
			Endif
			
			//Definindo a express�o
			cValidUsr += "u_zLimpaEsp(.T.)"
			
			//Atualiza no banco
			RecLock('SX3', .F.)
				X3_VLDUSER := cValidUsr
			SX3->(MsUnlock())
		EndIf
	Next
	
	RestArea(aAreaX3)
Return