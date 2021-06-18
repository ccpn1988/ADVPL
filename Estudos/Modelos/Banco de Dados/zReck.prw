#include 'protheus.ch'
#include 'parmtype.ch'

user function zReck()//RECLOCK = GRAVA DADOS
	Local aArea := GetArea()
	
	//ABRINDO TABELA DE PRODUTOS E SETANDO O INDICE
	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	//INICIANDO A TRANSA��O, TUDO DENTRO DA TRANSA��O PODE SER CANCELADO
	Begin Transaction
		MsgInfo("Antes da Altera��o", "Aten��o!!!")
		
		IF SB1->(DbSeek(FWxFilial('SB1')+ '0000001'))
		//QUANDO FALSO O REGISTRO � BLOQUEADO PARA ALTERA��O
		Reclock('SB1', .F.)
		B1_TIPO := 'MP'
		//REPLACE B1_POSIPI WITH '72071110  '
		SB1->(MsUnlock())
		ENDIF
	
	//QUANDO VERDADEIRO O REGISTRO � BLOQUEADO PARA INCLUS�O
	RecLock('SB1', .T.)
	B1_FILIAL := FWxFilial('SB1')
	SB1->(MsUnlock())
	
		MsgInfo("Depois da Altera��o", "Aten��o!!!")

		//AO DESARMAR A TRANSA��O TODA A MANIPULA��O DE DADOS � CANCELADA
		DisarmTransaction()
	End Transaction
return


