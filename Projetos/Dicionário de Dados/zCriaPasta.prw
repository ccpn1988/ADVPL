/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/12/13/funcao-para-criar-pastas-abas-sxa-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCriaPasta
Fun��o que verifica se a pasta j� existe, se n�o existir, cria a pasta
@type function
@author Atilio
@since 02/12/2015
@version 1.0
	@param cTabela, character, (Descri��o do parâmetro)
	@param cDescPasta, character, (Descri��o do parâmetro)
	@return cPasta, C�digo da pasta criada / existente
	@example
	u_zCriaPasta("SB1", "TESTE")
/*/

User Function zCriaPasta(cTabela, cDescPasta)
	Local aArea := GetArea()
	Local cPasta := ''

	//Abrindo a tabela de pastas
	DbSelectArea('SXA')
	SXA->(DbSetOrder(1)) //XA_ALIAS+XA_ORDEM
	SXA->(DbGoTop())
	
	//Se conseguir posicionar na tabela
	If (SXA->(DbSeek(cTabela)))
		cPasta := ''
		
		//Enquanto houver registros na tabela de pastas / abas e for a mesma tabela
		While !SXA->(EOF()) .And. (SXA->XA_ALIAS == cTabela)
			//Se for a mesma descri��o de tabela, pega o c�digo da pasta atual e sai do la�o de repeti��o
			If Upper(AllTrim(SXA->XA_DESCRIC)) == Upper(AllTrim(cDescPasta))
				cPasta := SXA->XA_ORDEM
				Exit
			EndIf
			
			SXA->(DbSkip())
		EndDo
		
		//Se ele n�o encontrou a pasta
		If Empty(cPasta)
			//Enquanto houver registros na tabela de pastas / abas e for a mesma tabela
			SXA->(DbGoTop())
			SXA->(DbSeek(cTabela))
			While !SXA->(EOF()) .And. (SXA->XA_ALIAS == cTabela)
				cPasta := SXA->XA_ORDEM
				
				SXA->(DbSkip())
			EndDo
			
			//Somando a pasta
			cPasta := Soma1(cPasta)
		EndIf
	
	//Sen�o, ser� a primeira pasta
	Else
		cPasta := StrTran(Space(Len(SXA->XA_ORDEM)), ' ', '0')
		cPasta := Soma1(cPasta)
	EndIf

	//Se n�o conseguir posicionar na aba dessa tabela
	If !SXA->(DbSeek(cTabela + cPasta))
		RecLock('SXA',.T.)
			XA_ALIAS    := cTabela
			XA_ORDEM    := cPasta
			XA_DESCRIC  := cDescPasta
			XA_DESCSPA  := cDescPasta
			XA_DESCENG  := cDescPasta
			XA_PROPRI   := 'U'
		SXA->(MsUnlock())
	EndIf

	RestArea(aArea)
Return cPasta