#Include 'Protheus.ch'

// Ponto de entrada que verifica se o usu�rio pode excluir o registro ou n�o

User Function M030DEL()
Local lRet := .T.
Local aAreaSA1 := SA1->(GetArea()) // Guarda a area do registro "Alias,Recno,Ordem"

	dbGoto(20) // Posiciona no registro com recno 20
	MsgAlert("Aten��o, voc� n�o pode excluir o cadatro")
	
RestArea(aAreaSA1) // Restaura a area do registro

Return(lRet)
