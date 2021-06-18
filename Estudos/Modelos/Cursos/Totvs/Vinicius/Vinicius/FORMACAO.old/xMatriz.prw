#Include 'Protheus.ch'

User Function xMatriz()
Local aMatriz 	:= {}
Local aMatriz2	:= Array(2,3)


aMatriz2[1,1] := "Maria"
aMatriz2[1,2] := 30
aMatriz2[1,3] := "F"

aMatriz2[2,1] :="Ana"
aMatriz2[2,2] := 42
aMatriz2[2,3] := "F"

aAdd(aMatriz2, {"Bruno"		,25,"M"})
aAdd(aMatriz2, {"Antonio"	,32,"M"})
aAdd(aMatriz2, {"João"		,48,"M"})
aAdd(aMatriz2, {"Bruno"		,26,"M"})


//nPos := aScan(aMatriz2,{|x| x[2] ==48})
//MsgInfo(aMatriz2[nPos,1])

//asort(aMatriz2,,,{|X,Y| X[1] < Y[1]})//ordenar
asort(aMatriz2,,,{|X,Y| cValtochar(X[2])+X[1] < cValtochar(Y[2])+y[1]})//ordenar por  idade	
For x:=1 to len(aMatriz2)
 MsgInfo("Nome:" 	+ aMatriz2[x,1] + CRLF + ;
 			"Idade:" + cValtochar(aMatriz2[x,2]) + CRLF + ;
			"Sexo:" + iif(aMatriz2[x,3]=="M","Masculino","Feminino"))
Next x


//	For x:= 1 to len (aMatriz2)
//		for y:= 1 to lean (aMatriz2)
//		MsgInfo(aMatriz2[x,y])
//		Next y
//	Next x
Return

