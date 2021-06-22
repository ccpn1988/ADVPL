/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/09/12/funcao-para-alterar-um-parametro-logico-sx6/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zAltPar
Fun��o que altera parâmetros do tipo L�gico (deve ser um parâmetro com conte�do l�gico na SX6, por exemplo, "MV_CHVNFE")
@author Atilio
@since 25/04/2017
@version 1.0
@type function
	@param cParametro, Character, C�digo do parâmetro que ser� atualizado
/*/

User Function zAltPar(cParametro)
	Local aArea    := GetArea()
	Local lConsAtu := Nil
	Local lConsNov := Nil
	Local nOpcao   := 0
	Local aBotoes  := {}
	Local cMensag  := ""
	Default cParametro := ""
	
	//Se tiver parâmetro
	If !Empty(cParametro)
		lConsAtu := GetNewPar(cParametro, .F.)
		
		//Adiciona os botões
		aAdd(aBotoes, Iif(lConsAtu,  "Manter Habilitado",   "Habilitar"))   //Op��o 1
		aAdd(aBotoes, Iif(!lConsAtu, "Manter Desabilitado", "Desabilitar")) //Op��o 2
		aAdd(aBotoes, "Cancelar")                                           //Op��o 3
		
		//Mostra o aviso e pega o bot�o
		cMensag := "Atualmente o parâmetro esta " + Iif(lConsAtu, "HABILITADO", "DESABILITADO") + "." + CRLF
		cMensag += "Deseja alterar?"
		nOpcao := Aviso("Aten��o", cMensag, aBotoes, 2)
		
		//Definindo a op��o nova
		If nOpcao == 1
			lConsNov := .T.
		ElseIf nOpcao == 2
			lConsNov := .F.
		EndIf
		
		//Se n�o for nulo
		If lConsNov != Nil
			//Se o conte�do novo for diferente do atual
			If lConsNov != lConsAtu
				PutMV(cParametro, lConsNov)
				
				Final("Aten��o", "A tela ser� fechada e deve ser aberta novamente!")
			EndIf
		EndIf
	EndIf
	
	RestArea(aArea)
Return