//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zLacos
Exemplo de la?os de repeti??o em AdvPL
@author Atilio
@since 08/11/2015
@version 1.0
	@example
	u_zLacos()
/*/

User Function zLacos()
	Local aArea := GetArea()
	Local nValor:= 1
	Local cNome := ""
	
	//Exemplo de For (Fazer do Valor de 1 At? 10)
	For nValor := 1 To 10
	Next
	Alert("For (++): "+cValToChar(nValor))
	
	//Exemplo de For Inverso (Fazer do Valor de 10 At? 1)
	For nValor := 10 To 1 Step -1
	Next
	Alert("For (--): "+cValToChar(nValor))
	
	//Exemplo de While (Fa?a Enquanto o valor for diferente de 10)... Tamb?m pode ser utilizado o Do While
	nValor := 1
	While nValor != 10
		nValor++
	EndDo
	Alert("While: "+cValToChar(nValor))
	
	//Exemplo do While composto (mais de 1 teste no la?o de repeti??o)
	nValor := 1
	While nValor != 10 .And. cNome != "Daniel"
		//Se chegar no meio do la?o
		If nValor == 5
			cNome := "Daniel"
		EndIf
		
		nValor++
	EndDo
	Alert("While Composto: "+cValToChar(nValor))
	
	//Exemplo de quebra de la?o de repeti??o (Fazer do Valor de 1 At? 10 incrementando de 2 em 2)
	For nValor := 1 To 10 Step 2
		//Se o valor for igual a 6, diminui um valor (ser? 5), e pula o la?o
		If nValor == 6
			nValor--
			Loop
		EndIf
		
		//Se o valor for igual a 7, encerra o la?o de repeti??o
		If nValor == 7
			Exit
		EndIf
	Next
	Alert("For (Quebra): "+cValToChar(nValor))
	
	RestArea(aArea)
Return