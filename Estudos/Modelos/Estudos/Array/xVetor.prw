#Include 'Protheus.ch'

User Function xVetor()
local aVar := {}
local aSemana := Array(3)
local aVar2 := {"A","B","C","D","E","F","G"}
	
	aSemana[1] := "Domingo"
	aSemana[2] := "Segunda"
	aSemana[3] := "Ter�a"
	
Return
/////ARRAY COM FOR///////////////////////////////////////////////////////////////////////////////[


User Function xVetor1()
local aVar := {}
local aSemana := Array(3)
local aVar2 := {"A","B","C","D","E","F","G"}
local x	
	aSemana[1] := "Domingo"
	aSemana[2] := "Segunda"
	aSemana[3] := "Ter�a"
	
FOR x := 1 TO LEN(aSemana)//LEN TAMANHO DO CAMPO
	MSGINFO(aSemana[x])//[X] POSICAO DO ARRAY
Next
Return

//INCREMENTANDO ARRAYS/////////////////////////////////////////////////////////////////////////////////[

USER FUNCTION XVETOR2()
LOCAL aVar := {}
LOCAL aSemana := Array(3)
LOCAL aVar2 := {"A","B","C","D","E","F","G"}
LOCAL X
aSemana[1] := "Domingo"
aSemana[2] := "Segunda"
aSemana[3] := "Ter�a"

AADD(aSemana,"Quarta")
AADD(aSemana, "Quinta")
AADD(aSemana,"Sexta")
//PESQUISA DENTRO ARRAY
FOR x := 1 TO LEN(aSemana)//LEN TAMANHO DO CAMPO
	MSGINFO(aSemana[x])//[X] POSICAO DO ARRAY
Next
Return

//PEGANDO POSI��O DO ARRAY ESPECIFICADO////////////////////////////////////////////////////////////////

USER FUNCTION XVETOR3()
LOCAL aVar := {}
LOCAL aSemana := Array(3)
LOCAL aVar2 := {"A","B","C","D","E","F","G"}
LOCAL X
aSemana[1] := "Domingo"
aSemana[2] := "Segunda"
aSemana[3] := "Ter�a"

AADD(aSemana,"Quarta")
AADD(aSemana, "Quinta")
AADD(aSemana,"Sexta")
//PESQUISA DENTRO DO ARRAY CONDI��O ESPECIFICA
nLinha := ASCAN(aSemana,"Quinta")
//BUSCA QUANDO NAO SABE O FORMATO
//nLinha := ASCAN(aSemana,{|x| ALLTRIM(UPPER(x)) == "QUINTA"))
IF nLinha > 0
	MSGINFO(cValToChar(nLinha) + " => " + aSemana[nLinha])
ENDIF

/*FOR X := 1 TO LEN(aSemana)
	IF ALLTRIM(UPPER(aSemana[x])) == "Quinta"
		MSGINFO(cValToChar(x) + " => " + aSemana[x])
	ENDIF
NEXT*/

RETURN
///////////////////////////////////////////////////////////////////////////////////////////////////

USER FUNCTION XVETOR4()
LOCAL aVar := {}
LOCAL aSemana := Array(3)
LOCAL aVar2 := {"A","C","B","D","G","F","E"}
LOCAL X
aSemana[1] := "Domingo"
aSemana[2] := "Segunda"
aSemana[3] := "Ter�a"

AADD(aSemana,"Quarta")
AADD(aSemana, "Quinta")
AADD(aSemana,"Sexta")
//ORDENA O array
/*ASORT(aVar2) 
FOR X := 1 TO LEN(aVar2)
	msginfo(aVar2[X])
NEXT*/
//ORDENA ATRAV�S DE POSI��O,X,QUANT
ASORT(aVar2,2,4)
FOR X := 1 TO LEN(aSemana)
	MSGINFO(aVar2[x])
NEXT
RETURN



	