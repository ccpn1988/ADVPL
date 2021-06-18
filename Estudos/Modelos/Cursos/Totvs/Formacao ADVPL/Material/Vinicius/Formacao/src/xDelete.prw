#Include 'Protheus.ch'

User Function xDelete()
	dbSelectArea("SB1")
	dbsetorder(1)
	if MsSeek(xFilial("SB1") + 'TERCEIROS000002')
		RecLock("SB1",.F.) //ALTERAR
			dbdelete()
		MsUnlock() //LIBERA O REGISTRO
	EndIF
Return

