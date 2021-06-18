#Include 'Protheus.ch'

User Function xFor()

Local x:=0

//For x:= 1 To 10 Step 2
//	MsgInfo("Contador:" + cValtoChar(x))
	
//NExt


//For x:= 10 To 1 Step -1
//MsgInfo("Contador:" + cValtoChar(x))
//NExt

For x:= 1 To 10 
	If x==5
		exit
	EndIf
	
	MsgInfo("Contador:" + cValtoChar(x))
	
NExt


Return


User Function xWhile
Local nCount :=1

While .T.
	If MsgYesNo("Deseja sair do while?", "Atenção!")
		if MsgNoYes("'Realmente' deseja sair do While?","Atenção!")
			Exit
		Endif
	Endif
	
EndDo
	

/*Do While ++nCount <=10 //nCount <=10

		if nCount==5
		nCount++
		Exit //loop
		
	EndIf	
	
	MsgInfo("Contador:"+ cValtoChar(nCount))


	//nCount := nCount + 1
	//nCount += 1
	++nCount
	//nCount ++
EndDo*/

Return(nil)
//---------------------------------------------------------------------

User function xTabwhile()

dbSelectArea("SA1")
dbSelectArea("SB1")
SA1->(dbSetOrder(1))
SA1->(dbGotop()) //Inicio da tabela

//EOF() Fim tabela
//BOF() Inicio tabela

While .not. SA1-> (EOF())
	MsgInfo("Codigo: "+ SA1->A1_COD + CHR(13) + "Nome: " + SA1->A1_NOME)
	SA1->(dbSkip()) //Proximo registro
	
	
	
EndDo
SA1->(dbCloseArea())
SB1->(dbCloseArea())

Return (NIL)

//-----------------------------------------------------------

