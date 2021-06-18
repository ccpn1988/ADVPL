#include 'protheus.ch'
#include 'parmtype.ch'

user function BANCO002()

	Local aArea := SB1->(GetArea()) //INFORMA A TABELA A SER USADA
	Local cMsg := ''
	
	DbSelectArea("SB1") //ACESSA A TABELA
	SB1->(dbSetOrder(1)) //POSICIONA NO INDICE 1
	SB1->(dbGoTop()) //POSICIONA NO 1 REGISTRO DA TABELA
	
	cMsg := Posicione( 'SB1',1,FWXfilial('SB1') + '02114210','B1_DESC') //POSICIONE = dbSeek
	
	Alert ("Descrição Produto" + cMsg, "AVISO")
	
	//SAIR DA TABELA
	RestArea (aArea)
	
return