#Include 'Protheus.ch'

User Function xVetor()
Local aVar := {} 
Local aSemana := Array(3)
Local aVar2   := {"A","C","D","B","F","H","G"}
Local x

aSemana[1] := "Domingo"
aSemana[2] := "Segunda"
aSemana[3] := "Terça"

aAdd(aSemana,"Quarta")
aAdd(aSemana,"Quinta")
aAdd(aSemana,"Sexta")
aAdd(aSemana,"Sabado")


aSort(aVar2,,,{|X,Y| X < Y })
For x:= 1 To Len( aVar2 )
	Msginfo(aVar2[x] )
Next 








// Exercicio // Fazer um for na varivael aSemana trazendo os dados da semana


//nLinha := aScan(aSemana,{|x| Alltrim(Upper(x)) == "QUINTA" } )
//nLinha := aScan(aSemana,  "QUINTA"  )
//Alltrim(Upper(aSemana[x])) == "QUINTA"


//If nLinha > 0 
//	msginfo(cValtochar( nLinha ) + " => " + aSemana[nLinha])
//Endif
//

//For x := 1 To Len(aSemana)
//	If Alltrim(Upper(aSemana[x])) == "QUINTA"
//		msginfo(cValtochar( X ) + " => " + aSemana[x])
//	Endif	
//Next 
//


Return
//-----------------------------------------------------------------

User Function xmatriz 
Local aMatriz  := {}
Local aNome    := {} 
Local aMatriz2 := Array(2,3)

aMatriz2[1,1] := "Maria"
aMatriz2[1,2] := 30
aMatriz2[1,3] := "F"

aMatriz2[2,1] := "Ana"
aMatriz2[2,2] := 42
aMatriz2[2,3] := "F"

aAdd(aMatriz2, {"Bruno"  ,"48","M" } )
aAdd(aMatriz2, {"Antonio",32,"M" } ) 
aAdd(aMatriz2, {"João"   ,48,"M" } )
aAdd(aMatriz2, {"José"   ,26,"M" } ) 

// For listando os dados do array  




//nPos := aScan(aMatriz2,{|x| X[2] == 48 }) //????
//Msginfo(aMatriz2[nPos,1])
//
//For x := 1 To Len(aMatriz2)
//	For Y := 1 To Len(aMatriz2[x])
//		If cValTochar( aMatriz2[x,y] ) == "48" 
//			aAdd( aNome, x ) 
//		Endif
//	Next 
//Next 
//


//For x := 1 To Len( aNome )
//	Msginfo( aMatriz2[aNome[x],1] )
//Next 

aSort(aMatriz2,,,{|X,Y| cValtochar( X[2] )+X[1] < cValTochar(Y[2])+Y[1]}) 

For x := 1 To Len(aMatriz2)
	Msginfo("Nome: " + aMatriz2[x,1] + CRLF + ; 
	        "Idade: " + cValtochar( aMatriz2[x,2] ) + CRLF + ;   
	        "Sexo: " + iif(aMatriz2[x,3]=="M","Masculino","Feminino") )

Next x
//For x := 1 To Len(aMatriz2)
//	For y := 1 To Len(aMatriz2[x])
//		Msginfo(aMatriz2[x,y])
//	Next y	
//Next x


