#Include 'Protheus.ch'

User Function xVetor()
	
	/*TIPOS DE DECLARAÇÂO DE ARRAY*/
	Local aVar := {}
	Local var := 0
	Local aSemana := Array(5)
	Local aVar2 := {"A","C","D","B","F","H","G"}
	
	//aSort(aVar2,2,4) -- Define de onde até onde irá ordenar
	aSort(aVar2,,,{|X,Y| x > Y}) //Define de se será crescente ou Decrescente
	for var:= 1 to Len(aVar2)
		MsgInfo(aVar2[var],"Sequência") 
	next
	
	aSort(aVar2)
	for var:= 1 to Len(aVar2)
		MsgInfo(aVar2[var],"Sequência") 
	next
	
	aSemana[1] := "Domingo"
	aSemana[2] := "Segunda"
	aSemana[3] := "Terça"
	aSemana[4] := "Quarta"
	aSemana[5] := "Quinta"

	/*ADICIONANDO UM VALOR A ARRAY EXISTENTE*/
	aadd(aSemana,"Sexta")
	aadd(aSemana,"Sabado")
	
	for var:= 1 to Len(aSemana)
		MsgInfo(aSemana[var],"Dias da Semana") 
	next
	
	//x:=aScan(aSemana,"Quinta")
	nLinha := aScan(aSemana,{|x|,Alltrim(upper(x)) == "QUINTA"})
	
	if(nLinha > 0)
		MsgInfo(cValToChar(nLinha) + " = " + aSemana[nLinhax],"Buscando o Indice")
	EndIf	
	
	for var:= 1 to Len(aSemana)
		if(AllTrim(upper(aSemana[var])) == AllTrim(upper("Quinta")))
			MsgInfo("Posição é " + cValToChar(var)) 
		EndIf	
	next
	
Return

