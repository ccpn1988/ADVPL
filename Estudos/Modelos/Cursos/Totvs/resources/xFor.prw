#Include 'Protheus.ch'

User Function xFor()
	Local x := 0
	
	//Incrementa 2
	/*For x:= 1 To 10 Step 2
		MsgInfo("Contador: " + cValtoChar(x))
	Next*/
	
	//Contagem regressiva
	/*For x:= 10 To 1 Step -1
		MsgInfo("Contador: " + cValtoChar(x))
	Next*/
	
	//Loop - Pula execução para o próximo registro dentro da estrutura de repetição
	/*For x:= 1 To 10
		If x == 5
			Loop
		EndIf
		MsgInfo("Contador: " + cValtoChar(x))
	Next*/
	
	//Exit - sai da execução da estrutura de repetição
	For x:= 1 To 10
		If x == 5
			Exit
		EndIf
		MsgInfo("Contador: " + cValtoChar(x))
	Next

Return

User Function xWhile

	//Local nCount := 0
	
	//Do While nCount++ <= 10 //valida primeiro e incrementa depois
	/*Do While ++nCount <= 10 //incrementa primeiro e valida depois
		MsgInfo("Contador: " + cValToChar(nCount))
		//nCount := nCount + 1
		//ncount += 1
		//++nCount
		//nCount++
	EndDo*/
	
	/*nCount := 1
	Do While nCount <= 10
		MsgInfo("Contador: " + cValToChar(nCount))
		//nCount := nCount + 1
		//ncount += 1
		++nCount
		//nCount++
	EndDo*/
	
	While .T.
		If MsgYesNo("Deseja sair do While ?","Atenção !")
			If MsgNoYes(" 'Realmente' deseja sair do While ?","Atenção !")
				Exit
			EndIf
		EndIf
	EndDo

Return

//-----------------------------------------------------------------------------------------------

User Function xTabWhile()
	DbSelectArea("SA1")
	DbSelectArea("SB1")
	SA1->( DbSetOrder(1) )
	SA1->( DbGoTop() ) //Inicio da tabela
	
	// EOF() Fim tabela
	// BOF() Inicio tabela
	
	While .Not. SA1->( EOF() )
		MsgInfo("Codigo: " + SA1->A1_COD + CHR(13) + " Nome: " + SA1->A1_NOME )
		SA1->(DbSkip()) // Proximo registro
	EndDo
	
	SA1->( DbCloseArea() )
	SB1->( DbCloseArea() )
	
Return
//-----------------------------------------------------------------------------------------------