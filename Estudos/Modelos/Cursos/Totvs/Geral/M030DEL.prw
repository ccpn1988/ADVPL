#Include 'Protheus.ch'

// Ponto de entrada que verifica se o usuário pode excluir o registro ou não

User Function M030DEL()
Local lRet := .T.
Local aAreaSA1 := SA1->(GetArea()) // Guarda a area do registro "Alias,Recno,Ordem"

	dbGoto(20) // Posiciona no registro com recno 20
	MsgAlert("Atenção, você não pode excluir o cadatro")
	
RestArea(aAreaSA1) // Restaura a area do registro

Return(lRet)
