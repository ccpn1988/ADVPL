#include 'protheus.ch'
#include 'parmtype.ch'

user function zReck()//RECLOCK = GRAVA DADOS
	Local aArea := GetArea()
	
	//ABRINDO TABELA DE PRODUTOS E SETANDO O INDICE
	dbSelectArea('SB1')
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	//INICIANDO A TRANSAÇÃO, TUDO DENTRO DA TRANSAÇÂO PODE SER CANCELADO
	Begin Transaction
		MsgInfo("Antes da Alteração", "Atenção!!!")
		
		IF SB1->(DbSeek(FWxFilial('SB1')+ '0000001'))
		//QUANDO FALSO O REGISTRO É BLOQUEADO PARA ALTERAÇÃO
		Reclock('SB1', .F.)
		B1_TIPO := 'MP'
		//REPLACE B1_POSIPI WITH '72071110  '
		SB1->(MsUnlock())
		ENDIF
	
	//QUANDO VERDADEIRO O REGISTRO É BLOQUEADO PARA INCLUSÃO
	RecLock('SB1', .T.)
	B1_FILIAL := FWxFilial('SB1')
	SB1->(MsUnlock())
	
		MsgInfo("Depois da Alteração", "Atenção!!!")

		//AO DESARMAR A TRANSAÇÃO TODA A MANIPULAÇÂO DE DADOS É CANCELADA
		DisarmTransaction()
	End Transaction
return


