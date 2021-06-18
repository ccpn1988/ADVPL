#Include 'Protheus.ch'
/*
Cláudia Balestri - 06/04/2019
*/

User Function xVetor()
Local aVar:= {}
Local aSemana:= Array(5)
Local aVar2 :={"A","B","C","D","E","F","H","G"}

//MsgInfo("X")

aSemana[1] := "Domingo"
aSemana[2] := "Segunda"
aSemana[3] := "Terça"
aSemana[4] := "Quarta"
aSemana[5] := "Quinta"

aAdd(aSemana,"Sexta")
aAdd(aSemana,"Sábado")

//Exercicio // Fazer um For na Variável aSemana trazendo os dados da semana

/*For x:=1 to len(aSemana) //or 3 que é o tamanho do vetor
    MsgInfo(aSemana[x])
Next*/



	/*For x:=1 to len(aSemana) //or 3 que é o tamanho do vetor
	    
	    if Alltrim(Upper(aSemana[x])) = "QUINTA"
	       Msginfo(aSemana[x] +" >>  Posição  >> " + str(x))
	    else
	       MsgInfo(aSemana[x])    
	    endif 
	Next*/

	//nPos:=aScan(aSemana, "Quinta")
	
    //nPos:=aScan(aSemana,{|x| Alltrim(Upper(x)) == "QUINTA"})
    //nPos:= aScan(aSemana,"QUINTA")
    	
	/*If nPos > 0
   		Msginfo(aSemana[nPos] +" >> S C A N  Posição  >> " + str(x)) 
	Endif    */
	
     //aSort(aVar2)
     //aSort(aVar2,2,4)
     
     aSort(aVar2,,,{|x,y| x > y }) // decrescente x>y // crescente x<y
     for x:=1 to Len(avar2)
         msginfo(avar2[x])
     Next
Return

