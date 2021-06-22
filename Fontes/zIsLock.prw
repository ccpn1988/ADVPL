/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/10/11/como-verificar-se-um-registro-esta-travado-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define POS_ALIAS 001
#Define POS_INDIC 002
#Define POS_RECNO 003

/*/{Protheus.doc} zIsLock
Fun��o que verifica se um registro esta travado na mem�ria (com RecLock por exemplo)
@type function
@author Atilio
@since 03/08/2016
@version 1.0
	@param cAliasLock, character, Alias da Tabela (se n�o for passado nada, ser� utilizado a �ltima em mem�ria)
	@param nRegLock, num�rico, RecNo pesquisado (se n�o for passado nada, ser� utilizado o �ltimo em mem�ria)
	@return lTravado, Retorna se o registro esta travado (.T.) ou n�o (.F.) na mem�ria
	@example
	DbSelectArea('SB1')
	lLock := u_zIsLock()
	
	//ou
	lLock := SB1->(u_zIsLock())
	
	//ou
	lLock := u_zIsLock('SB1', SB1->(RecNo()))
/*/

User Function zIsLock(cAliasLock, nRegLock)
	Local aArea        := GetArea()
	Local lTravado     := .F.
	Local aTravas      := {}
	Default cAliasLock := aArea[POS_ALIAS]
	Default nRegLock   := 0
	
	//Se tiver zerado o RecNo
	If nRegLock == 0
		//Se for o Mesmo Alias do GetArea()
		If cAliasLock == aArea[POS_ALIAS]
			nRegLock := aArea[POS_RECNO]
		
		//Sen�o, abre a tabela e pega o RecNo atual
		Else
			DbSelectArea(cAliasLock)
			nRegLock := (cAliasLock)->(RecNo())
		EndIf
	EndIf
	
	//Pegando os registros travados em mem�ria
	aTravas := (cAliasLock)->(DBRLockList())
	
	//Se encontrar o recno nos travados na mem�ria, o registro est� travado
	If aScan(aTravas,{|x| x == nRegLock }) > 0
		lTravado := .T.
	EndIf
	
	RestArea(aArea)
Return lTravado