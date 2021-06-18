#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} OPERADOR
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function OPERADOR()
	
	Local nNum1 := 10
	Local nNum2 := 20
	//OPERADORES MATEMATICOS
	//Alert(nNum1 + nNum2)
	//Alert(nNum2 - nNum1)
	//Alert(nNum1 * nNum2)
	//Alert(nNum2 / nNum1)
	//Alert(nNum2 % nNum1)
	
	//OPERADORES RELACIONAIS
	Alert(nNum1 < nNum2) //COMPARACAO MENOR
	Alert(nNum1 > nNum2) //COMPARACAO MAIOR
	Alert(nNum1 = nNum2) //COMPARACAO IGUAL
	Alert(nNum1 == nNum2)//EXATAMENTE IGUAL
	Alert(nNum1 <= nNum2)//MENOR OU IGUAL
	Alert(nNum1 >= nNum2)//MAIOR OU IGUAL
	Alert(nNum1 != nNum2)//DIFERENCA
	
	/*
	//OPERADORES DE ATRIBUIÇÃO
	nNum1 := 10 //ATRIBUIÇÃO SIMPLES
	nNum1 += nNum2 // nNum1 = nNum1 + nNum2
	nNum2 -= nNum1 // nNum2 = nNum2 - nNum1
	nNum1 *= nNum2 // nNum1 = nNum1 * nNum2
	nNum2 /= nNum1 // nNum2 = nNum2 / nNum1
	nNum2 %= nNum1 // nnum2 = nNum2 % nNum1
	*/
	
	
return