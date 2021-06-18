#Include 'Protheus.ch'

User Function XFor()
	Local x := 0


//For x := 1 To 10 Step 2
////	msgInfo("Contador: " + cValTochar(x)  )
// msgInfo("Contador: " + LTrim( Str(x) )  )
//NExt 



//For x := 10 To 1 Step -1
// msgInfo("Contador: " + LTrim( Str(x) )  )
//NExt 
//

	For x := 1 To 10
//		If x == 5
//			Exit //Loop
//		EndIf
	//	msgInfo("Contador: " + LTrim( Str(x) )  )
	Next

Return
//-------------------------------------------


User Function xWhile
Local nCount := 1

While .T.

	If MsgYesNo("Deseja sair do While ?","Atenção !")
		If MsgNoYes(" 'Realmente' deseja sair do While ?","Atenção !")
			Exit
		EndIf	
	EndIf		

EndDo


/*Do While  nCount <= 10 //++nCount <= 10
	If nCount == 5
		nCount++
		Exit //Loop
	EndIf

	MsgInfo("Contador: " + cValtochar( nCount ) )
	// nCount := nCount + 1
	   //nCount +=  1
	   ++nCount
EndDo
*/




Return( NIL )
//--------------------------------------------------------------------------------

User function xTabWhile()

dbSelectArea("SA1")
dbSelectArea("SB1")
SA1->( dbSetOrder(1) )
SA1->( dbGotop() ) // Inicio da tabela


// EOF() Fim tabela
// BOF() Inicio tabela

While .Not. SA1->( EOF() )

	Msginfo("Codigo: " + SA1->A1_COD + CHR(13) +" Nome: " + SA1->A1_NOME )

	SA1->( dbSkip() )// Proximo registro
EndDo  

SA1->( dbCloseArea() )
SB1->( dbCloseArea() )


Return( NIL )
//--------------------------------------------------------------------------------






















