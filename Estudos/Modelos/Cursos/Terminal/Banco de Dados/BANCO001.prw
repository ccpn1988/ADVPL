#include 'protheus.ch'
#include 'parmtype.ch'

user function BANCO001()

	Local aArea := SB1->(GetArea()) //INFORMA A TABELA A SER USADA
	//Local cMsg := ""
	
	DbSelectArea("SB1") //ACESSA A TABELA
	SB1->(DbSetOrder(1)) //POSICIONA NO INDICE 1
	SB1->(DbGoTop()) //POSICIONA NO 1 REGISTRO
	
	//POSICIONA O PRODUTO 02114210
	IF SB1->(dbSeek(FWXFILIAL('SB1') + "02114210")) //DBSEEK PESQUISA O ITEM DE ACORDO COM O INDICE (1) FILIAL + TABELA + CAMPO
													// FWXFILIAL VALIDA FILIAL
	Alert(SB1->B1_DESC)
	
	ENDIF
	
	//SAIR DA TABELA
	RestArea (aArea)
	
return