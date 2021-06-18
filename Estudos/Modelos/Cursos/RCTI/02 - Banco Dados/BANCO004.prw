#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO004
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BANCO004()
	
	Local aArea := SB1->(GetArea())
	
	DbSelectArea('SB1')
	Sb1->(DbSetOrder(1))
	Sb1->(DbGoTop())
	
	// Iniciar a transação.
	Begin Transaction
	
		MsgInfo("A descrição do produto será alterada!", "Atenção")
		
	If SB1->(DbSeek(FWxFilial('SB1') + '000002'))
		RecLock('SB1', .F.) //Trava registro para alteração
	Replace B1_DESC With "MONITOR DELL 42 PL"
	
		SB1->(MsUnlock())
	EndIf
		MsgAlert("Alteração efetuada!", "Atenção")
	//	DisarmTransaction()
	End Transaction
	RestArea(aArea)
	
return