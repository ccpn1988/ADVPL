#include 'protheus.ch'
#include 'parmtype.ch'

User Function zOperadores()
	Local aArea := GetArea()
	
	//Declaração de variáveis
	Local nValor1	:= 5
	Local nValor2	:= 3
	Local cTexto1	:= "Daniel Atilio"
	Local cTexto2	:= "Atilio"
	
	//Atribuição
	nValor1 := 6	//Existe também o replace, porém ele é utilizado para campos (RecLock)
	
	//Manipulação
	nValor1++		//Soma 1 na variável. Outro exemplo:		nValor1 := nValor1 + 1
	nValor1--		//Subtrai 1 na variável. Outro exemplo:	nValor1 := nValor1 - 1
	nValor1 *= 2	//Multiplica o valor. Outro exemplo:		nValor1 := nValor1 * 2
	nValor1 /= 2	//Divide o valor. Outro exemplo:			nValor1 := nValor1 / 2
	nValor1 += 7  //Soma o valor. Outro exemplo:				nValor1 := nValor1 + 7
	nValor1 -= 7	//Subtrai o valor. Outro exemplo:			nValor1 := nValor1 - 7
	
	//Testes
	ConOut("Testes: ")
	ConOut( nValor1 == nValor2 )		//Exatamente igual
	ConOut( !(nValor1 == nValor2) )		//Negação de teste
	ConOut( nValor1 != nValor2 )		//Diferente de (também pode ser usado <>)
	ConOut( cTexto2 $ cTexto1 )			//Está contido
	ConOut( nValor1 > nValor2 )			//É maior que (também pode ser >=, seria maior ou igual)
	ConOut( nValor1 < nValor2 )			//É menor que (também pode ser <=, seria menor ou igual)
	
	//Testes compostos
	ConOut("Testes Compostos: ")
	ConOut( (1==1) .And. (1!=1) )		//Teste com .And. só retorna verdadeiro, se todos os testes forem verdadeiro
	ConOut( (1==1) .Or.  (1!=1) )		//Teste com .Or.  retorna verdadeiro, se qualquer teste for verdadeiro
	
	//Macro Substituição
	&("nValor3 := 8")
	Alert(nValor3)
	
	RestArea(aArea)
Return


user function OPERMAT()
	Local nNum1 := 10
	Local nNum2 := 20
	
	
	/* MSGALERT(nNum1 + nNum2,"SOMA!!!") //ALTERA NOME JANELA
	MSGALERT("A subtração é: "+ cValToChar (nNum2 - nNum1))
	MSGALERT("A multiplicação é: "+ cValToChar (nNum1 * nNum2))
	MSGALERT("A divisão é: "+ cValToChar (nNum2 / nNum1))
	MSGALERT("O restante da divisão é: "+ cValToChar (nNum2 % nNum1)) */
	

	MSGALERT(nNum1 + nNum2,"SOMA!!!") //ALTERA NOME JANELA
	MSGALERT("A subtração é: "+ cValToChar (nNum2 += nNum1))
	MSGALERT("A multiplicação é: "+ cValToChar (nNum1 *= nNum2))
	MSGALERT("A divisão é: "+ cValToChar (nNum2 /= nNum1))
	MSGALERT("O restante da divisão é: "+ cValToChar (nNum2 -= nNum1))
return

//------------------------------------------------------------------------------

User Function OPERREL() //RETORNA .T. ou .F.
	Local nNum1 := 10
	Local nNum2 := 20
	
	Alert(nNum1 < nNum2)  //MENOR
	Alert(nNum2 > nNum1)  //MAIOR
	Alert(nNum1 <> nNum2) //DIFERENTE
	Alert(nNum1 == nNum2) //IGUALDADE
	Alert(nNum1 <= nNum2) //MENOR OU IGUAL
	Alert(nNum2 >= nNum1) //MAIOR OU IGUAL
	Alert(nNum1 != nNum2) //DIFERENTE
	
Return
//-------------------------------------------------------------------------------

User Function OPERATRIB()
	Local nNum1 := 10
	Local nNum2 := 20
	
	Alert(nNum1 := 10) // nNum1 := 10
	Alert(nNum1 += nNum2) // nNum1 := nNum1 + nNum2
	Alert(nNum2 -= nNum1) // nNum2 := nNum2 - nNum1
	Alert(nNum1 *= nNum2) // nNum1 := nNum1 * nNum2
	Alert(nNum2 /= nNum1) // nNum2 := nNum2 / nNum1
	//Alert(nNum2 %= nNum1) // nNum2 := nNum2 % nNum1
	&("nNum2 := 8") //MACRO SUBSTITUIÇÃO
	Alert(nNum2)
Return

//----------------------------------------------------------------------------------

