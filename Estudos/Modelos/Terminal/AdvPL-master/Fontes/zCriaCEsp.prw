//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zCriaCEsp
Fun��o para criar uma consulta espec�fica similar ao criar pelo Configurador, mas via c�digo fonte
@author Atilio
@since 04/01/2018
@version 1.0
@param cConsulta, characters, C�digo da Consulta na SXB
@param cDescricao, characters, Descri��o da consulta criada
@param cAliasCons, characters, Alias da consulta, se houver
@param cFuncao, characters, Fun��o que ser� chamada (Express�o)
@param cRetorno, characters, Retorno que ser� posicionado
@type function
@example
	cFuncao := 'u_zConsEsp("SB1", {"B1_COD","B1_DESC","B1_TIPO"}, " ", "B1_COD")'
	u_zCriaCEsp("X_SB1", "Produtos com Like", "SB1", cFuncao, "__cRetorn")
/*/

User Function zCriaCEsp(cConsulta, cDescricao, cAliasCons, cFuncao, cRetorno)
	Local aArea        := GetArea()
	Local aAreaXB      := SXB->(GetArea())
	Default cConsulta  := ""
	Default cDescricao := ""
	Default cAliasCons := ""
	Default cFuncao    := ""
	Default cRetorno   := ""
	
	//Se tiver consulta, fun��o e retorno
	If ! Empty(cConsulta) .And. ! Empty(cFuncao) .And. ! Empty(cRetorno)
		//Caso n�o encontre, ser� criado os dados
		DbSelectArea("SXB")
		If ! SXB->(DbSeek(cConsulta))
		
			//Descri��o
			RecLock("SXB",.T.)
				XB_ALIAS   := cConsulta
				XB_TIPO    := "1"
				XB_SEQ	   := "01"
				XB_COLUNA  := "RE"
				XB_DESCRI  := cDescricao
				XB_DESCSPA := cDescricao
				XB_DESCENG := cDescricao
				XB_CONTEM  := cAliasCons
				XB_WCONTEM := ""
			SXB->(MsUnlock())
			
			//Fun��o
			RecLock("SXB",.T.)
				XB_ALIAS   := cConsulta
				XB_TIPO    := "2"
				XB_SEQ	   := "01"
				XB_COLUNA  := "01"
				XB_DESCRI  := ""
				XB_DESCSPA := ""
				XB_DESCENG := ""
				XB_CONTEM  := cFuncao
				XB_WCONTEM := ""
			SXB->(MsUnlock())
			
			//Retorno
			RecLock("SXB",.T.)
				XB_ALIAS   := cConsulta
				XB_TIPO    := "5"
				XB_SEQ	   := "01"
				XB_COLUNA  := ""
				XB_DESCRI  := ""
				XB_DESCSPA := ""
				XB_DESCENG := ""
				XB_CONTEM  := cRetorno
				XB_WCONTEM := ""
			SXB->(MsUnlock())
		EndIf
	EndIf
	
	RestArea(aAreaXB)
	RestArea(aArea)
Return