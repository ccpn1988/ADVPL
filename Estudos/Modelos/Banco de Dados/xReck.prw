#include 'protheus.ch'
#include 'parmtype.ch'

//RECLOCK - ALTERAÇÔES DIRETAMENTE NO BANCO DE DADOS

user function xReck()
	Local aArea := SB1->(GetArea())
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	
	//INICIAR A TRANSAÇÃO
	Begin Transaction
		MsgInfo("Começando a Transação de Alteração do Item", "Atenção")
		
	IF Sb1->(dbSeek(FWxFilial("SB1")+ 'VALE'))
		Reclock('SB1',.F.) //ALTERAÇÃO
		B1_DESC := "VALE ALTERADO"
		//REPLACE B1_DESC WITH "VALE ALTERADO"
		SB1->(msUnlock())
	ENDIF
		MsgAlert("Alteração Efetuada", "Atenção")
		
		//DisarmTransaction() - Cancela Operação do Reclock()		
	End Transaction
	
	RestArea(aArea)
return