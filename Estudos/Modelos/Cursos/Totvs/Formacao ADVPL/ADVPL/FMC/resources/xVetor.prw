#Include 'Protheus.ch'

User Function xVetor()
	Local aVar		:= {}
	Local aSemana	:= Array(3)
	Local aVar2		:= {"A","C","B","D","F","E","H","G"}
	Local cMsg		:= ""
	
	aSemana[1] := "Domingo"
	aSemana[2] := "Segunda"
	aSemana[3] := "Terça"
	
	aAdd(aSemana,"Quarta")
	aAdd(aSemana,"Quinta")
	aAdd(aSemana,"Sexta ")
	aAdd(aSemana,"Sabado")
	
	//Exercicio // Fazer um FOR na variavel aSemana trazendo os dados da semana
	/*
	For X := 1 to Len(aSemana)
		If ALLTRIM(UPPER(aSemana[X])) == "QUINTA"
			cMsg += cValToChar(X) + " - " + aSemana[X] + CHR(13)
			Break
		EndIf
	Next
	*/

	/*
	X := aScan(aSemana,"Quinta")
	If X > 0
		cMsg += cValToChar(X) + " - " + aSemana[X] + CHR(13)
	EndIf
	*/

	/*
	nPos := aScan(aSemana,{|X| AllTrim(Upper(X)) == "QUINTA" } )
	If nPos > 0
		cMsg += cValToChar(nPos) + " - " + aSemana[nPos] + CHR(13)
	EndIf
	*/
	
  //aSort( <aDados>, <nInicio>, <nCont>  , <bOrdem>        )
	aSort(   aVar2 ,     4    ,Len(aVar2),{ |X,Y| X <  Y } )
	For x:= 1 To Len( aVar2 )
		cMsg += cValToChar(x) + " - " + aVar2[x] + CHR(13)
	Next
	
	MsgInfo(cMsg)

Return

