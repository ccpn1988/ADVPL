#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} ESTRREP
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function ESTRREP()

	Local nCount
	Local nNum := 0
	
	For nCount := 0 To 10 Step 2
	
	nNum += nCount
	Alert("Valor: "+ cValToChar(nNum)) //PULANDO DE 2 EM 2
	Next
	//Alert("Valor: "+ cValToChar(nNum))//SOMA TODOS OS VALORES DO LOOP
	
	
	// EXEMPLO DO COMANDO WHILE ENDDO
	
	Local nNum1 := 1
	Local cNome := "RCTI"
	
	While nNum1 != 10 .AND. cNome != "PROTHEUS"
		nNum1++
			If nNum1 == 5
			cNome := "PROTHEUS"
			EndIf
	EndDo
		Alert("Numero: "+ cValToChar(nNum1))
		Alert("Nome: "+ cValToChar(cNome))*/
		
		Local nNum1 := 0
		Local nNum2 := 10
		
		While nNum1 < nNum2
			nNum1++
		//Alert(cValToChar(nNum1+nNum2))
		
		EndDo
		Alert(cValToChar(nNum1))
Return
		
return