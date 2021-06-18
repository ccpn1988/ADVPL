#include 'protheus.ch'
#include 'parmtype.ch'

/*
FOR NEXT
*/
user function fFOR()
	
	Local nCount 
	Local nNum := 0
	
	FOR nCount := 0 TO 10
		nNum += nCount
	NEXT
	Alert("VALOR :" + cValToChar(nNum))
	
return

//-----------------------------------------------------------------------------

user function fSTEP()
	
	Local nCount 
	Local nNum := 0
	
	FOR nCount := 0 TO 10 STEP 2 //PULA DE 2 EM 2
		nNum += nCount
	NEXT
	Alert("VALOR :" + cValToChar(nNum))
	
return

//------------------------------------------------------------------------------

User Function xLacos()
	Local nValor := 1
	Local cNome := ""
	
	//FOR de 1 ATE 10
	For nValor := 1 TO 10
	NEXT
	ALERT("For (++): "+cValToChar(nValor))
	
	//EXEMPLO DE FOR INVERSO 10 ATE 1
	FOR nValor := 10 TO 1 STEP -1
	NEXT
	ALERT("For (--): "+cValToChar(nValor))
		
	//EXEMPLO DE QUEBRA DE LAÇO(1 ATE 10 DE 2 EM 2)
	FOR nValor := 1 TO 10 STEP 2
	//SE O VALOR FOR 6 DIMINIU UM VALOR (5) E PULA O LAÇO PARA (7)
		IF nValor == 6
			nValor--
			LOOP //PULA O LAÇO
		ENDIF
		//SE O VALOR FOR IGUAL 7 ENCERRA O WHILE
		IF nValor ==7
			Exit //ENCERRA O LAÇO
		ENDIF
	NEXT
	Alert("For (QUEBRA)" +cValToChar(nValor))
Return
	
	