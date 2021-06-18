#Include 'Protheus.ch'

User Function xWhile()
	Local nCount := 1
	
	While .T.
		If MsgYesNo("Deseja sair do While?","Atenção!")
			If MsgNoYes("Realmente deseja sair do While?","Atenção!")
				Exit
			Endif
		Endif
		
	EndDo
	
/*	Do While ++nCount <= 10
		MsgInfo("Contador: " + cValToChar(nCount))
		
		//nCount++
	EndDo
*/



Return(NIL)

//----------------------------------------------------------------------------------------------------

User function xTabWhile()
	
	dbSelectArea("SA1")
	dbSelectArea("SB1")
	SA1->(dbSetOrder(1))
	SA1->(dbGoTop()) //Inicio da Tabela
	
	//EOF() Fim da tabela
	//BOF() Inicio tabela
	
	While .Not. EOF()
		MsgInfo("Codigo: " + SA1->A1_COD + CHR(13) + " Nome: " + SA1->A1_NOME )
		dbSkip() //proximo registro
	EndDo	
	
	SA1->(dbCloseArea())
	SB1->(dbCloseArea())
	
return( NIL )