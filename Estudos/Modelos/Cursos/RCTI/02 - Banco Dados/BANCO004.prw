#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} BANCO004
//TODO Descri��o auto-gerada.
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
	
	// Iniciar a transa��o.
	Begin Transaction
	
		MsgInfo("A descri��o do produto ser� alterada!", "Aten��o")
		
	If SB1->(DbSeek(FWxFilial('SB1') + '000002'))
		RecLock('SB1', .F.) //Trava registro para altera��o
	Replace B1_DESC With "MONITOR DELL 42 PL"
	
		SB1->(MsUnlock())
	EndIf
		MsgAlert("Altera��o efetuada!", "Aten��o")
	//	DisarmTransaction()
	End Transaction
	RestArea(aArea)
	
return