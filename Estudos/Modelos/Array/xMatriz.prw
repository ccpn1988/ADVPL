#Include 'Protheus.ch'

User Function xMatriz()
local aMatriz := {} 
local aMatriz2 := Array(2,3) //ARRAY(COLUNA,LINHAS)
local x
<<<<<<< Updated upstream
aMatriz2[1,1] := "MARIA"
aMatriz2[1,2] := 50
aMatriz2[1,3] := "M"
=======
aMatriz2[1,1] := "CAIO NEVES"
aMatriz2[1,2] := 30
aMatriz2[1,3] := "F"
>>>>>>> Stashed changes

aMatriz2[2,1] := "JULIA"
aMatriz2[2,2] := 42
aMatriz2[2,3] := "F"

// INCLUIR REGISTRO
AADD(aMatriz2,{"BRUNO"	 ,25, "M"})
AADD(aMatriz2,{"ANTONIO" ,30, "M"})
AADD(aMatriz2,{"JOAO"	 ,48, "M"})
AADD(aMatriz2,{"JOSÉ"	 ,26, "M"})
// BUSCA NOME AO QUAL CONTEUDO 2 DO ARRAY 48
nPos:= ASCAN(aMatriz2,{|x| X[2] == 48})
	MSGINFO(aMatriz2[nPos,1]) //PEGA CONTEUDO 1 ARMAZENADO EM FOR
	

// TRAZ TODOS OS DADOS
/*FOR x := 1 TO LEN(aMatriz2)//x seria coluna
	MSGINFO("Nome: " + aMatriz2[x,1] + CRLF +;
			"Idade: " + cValToChar(aMatriz2[x,2]) + CRLF +;
			"Sexo: " + IIF(aMatriz2[x,3] =="M","MASCULINO","FEMININO"))
NEXT x*/

// TRAZ TODOS OS DADOS
/*FOR X := 1 TO LEN(aMatriz2)
FOR Y := 1 TO LEN(aMatriz2[X])
	MSGINFO(aMatriz2[X,Y])
NEXT Y
NEXT X*/


//IMPRIME A COLUNA E A LINHA ESPECIFICA
/*FOR x := 1 TO LEN(aMatriz2[1,1])
	MSGINFO(aMatriz2[1,1])
	exit
NEXT
*/

Return

