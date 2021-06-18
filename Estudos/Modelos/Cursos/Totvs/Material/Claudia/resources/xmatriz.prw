#Include 'Protheus.ch'

User Function xmatriz()

Local aMatriz := {}
Local aMatriz2:= Array(2,3)

	aMatriz2[1,1] := "Maria"
	aMatriz2[1,2] := 30
	aMatriz2[1,3] := "F"
	
	aMatriz2[2,1] := "Ana"
	aMatriz2[2,2] := 42
	aMatriz2[2,3] := "F"
	
	aAdd(aMatriz2,{"Bruno",25,"M"})
	aAdd(aMatriz2,{"Antonio",32,"M"})
	aAdd(aMatriz2,{"João",48,"M"})
	aAdd(aMatriz2,{"José",35,"M"})		

	/*For x:=1 to len(aMatriz2)	//listar os dados do array
	    MsgInfo(aMatriz2[x][1]+" "+str(aMatriz2[x][2])+" "+aMatriz2[x][3])
	Next*/
	/*
	For x:=1 to len(aMatriz2)	//listar os dados do array
	    For :=1 to len(aMatriz2[x])
	        MsgInfo(aMatriz2[x,y])
	    Next y
	Next x
	*/
	
	/*nPos:= aScan(aMatriz2,{|x| x[2] == 48}) //se tiver 2 o scan traz somente o primeiro.
	MsgInfo(aMatriz2[nPos,1])*/
	
	//aSort(aMatriz2,,,{|x,y| cValtoChar(x[2])+x[1] < cValtoChar(y[2])+y[1]}) //ordernar idade/nome // decrescente x>y // crescente x<y
	aSort(aMatriz2,,,{|x,y| x[1] < y[1]}) //ordernar pelo nome // decrescente x>y // crescente x<y	
	For x:=1 to len(aMatriz2)	//listar os dados do array
	    MsgInfo("Nome: "+aMatriz2[x,1] + CRLF+;
	            "Idade: "+cValtoChar(aMatriz2[x,2]) + CRLF+;
	            "Sexo: "+ iif(aMatriz2[x,3] =='M',"Masculino","Feminino"))
	    /*if aMatriz2[x,2] = 48
	   		MsgInfo(">>"+str(aMatriz2[x,2])+" anos >> "+(aMatriz2[x,1]) ) 
	    endif         */
	    
	Next x

Return

