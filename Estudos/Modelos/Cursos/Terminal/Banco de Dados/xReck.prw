#include 'protheus.ch'
#include 'parmtype.ch'

//RECLOCK - ALTERA��ES DIRETAMENTE NO BANCO DE DADOS

user function xReck()
	Local aArea := SB1->(GetArea())
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	//INICIAR A TRANSA��O
	Begin Transaction
		MsgInfo("Come�ando a Transa��o de Altera��o do Item", "Aten��o")
		
	IF Sb1->(dbSeek(FWxFilial("SB1")+ 'VALE'))
		Reclock('SB1',.F.) //ALTERA��O
		B1_DESC := "VALE ALTERADO"
		//REPLACE B1_DESC WITH "VALE ALTERADO"
		SB1->(msUnlock())
	ENDIF
		MsgAlert("Altera��o Efetuada", "Aten��o")
		
		//DisarmTransaction() - Cancela Opera��o do Reclock()		
	End Transaction
	
	RestArea(aArea)
return