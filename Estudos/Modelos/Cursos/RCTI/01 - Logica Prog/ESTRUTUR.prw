#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} ESTRUTUR
//TODO Descri��o auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function ESTRUTUR()
	
	Local nNum1 := 22
	Local nNum2 := 100
	
	If(nNum1 = nNum2)
	MsgInfo("A vari�vel nNum1 � igual a nNum2")
	
	ElseIf (nNum1 > nNum2)
	MsgAlert("A variavel � maior")
	
	ElseIf (nNum1 != nNum2)
	Alert ("A vari�vel nNum1 � diferente de nNum2")
	
	EndIf

return