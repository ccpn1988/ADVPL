#include 'protheus.ch'
#include 'parmtype.ch'

user function zForYTB()
Local aArea := GetArea()
Local nValor := 1
Local cNome := ""

	For nValor := 1 TO 10
		Alert("For (++) " + cValToChar(nValor)) //INCREMENTANDO
	Next
	
	
	For nValor := 10 TO 1 STEP -1
	Next
		Alert("For (--) " + cValToChar(nValor))//APRESENTANDO RESULTADO FINAL 0 
	
return