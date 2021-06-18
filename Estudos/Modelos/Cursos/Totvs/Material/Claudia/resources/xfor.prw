#Include 'Protheus.ch'

/*
Cláudia Balestri - 06/04/2019
*/


/*User Function xfor()

Local x:=0 //Usar variável sem declarar fica com escopo de private

	For x:= 1 to 10 //Step 2 // or For x:= 10 to 1 Step -2
	
	    if  x==5     
	       //Loop //if x:=5  sempre recebe 5 fica em loop
	       exit
	    Endif   
	 
	     msginfo("Contador: " + str(x)) 
	     //str(x) tem que usar o Ltrim ou cValToChar(x) = já tira o espaço 
	
	Next

Return
*/
//--------------------------------------------------------------------

/*User Function xWhile
Local nCount := 1

While .T.
	
	if MsgYesNo("Deseja sair do while?","Atenção!")
 		if msgNoYes("'Realmente' deseja sair do While? ","Atenção!")
 			Exit //Return sai fora da rotina
 		Endif
 	Endif
 			
Enddo
*/
/*
Do While nCount <=10

   if nCount == 5
      nCount++
      Exit //Loop
   Endif    

   //++nCount <=10  Incrementa e depois valida
   //nCount++ <= 10 primeiro valida e depois incrementa  
   //nCount <=10 
	  
  MsgInfo("Contador: "+ cValToChar(nCount))
  //nCount:=nCount+1
  //nCount +=1
  //++nCount
  //nCount++

Enddo
*/

//Return(nil)

//--------------------------------------------------------------------

User Function xTabWhile()

	dbSelectarea("SA1")
	dbSelectarea("SB1")
	
	SA1->(dbSetOrder(1))
	SA1->(dbGotop()) //Inicio Tabela
	
	//EOF() - Fim Tabela
	//BOF() - Inicio tabela

	While !SA1->(EOF())
	
	   Msginfo("Codigo: " + SA1->A1_COD+ CHR(13) + " Nome: " + SA1->A1_NOME)
	   SA1->(dbskip()) //Proximo registro
	   
	Enddo  
	
	SA1->(dbCloseArea())
	SB1->(dbCloseArea()) 

Return(nil)

//--------------------------------------------------------------------