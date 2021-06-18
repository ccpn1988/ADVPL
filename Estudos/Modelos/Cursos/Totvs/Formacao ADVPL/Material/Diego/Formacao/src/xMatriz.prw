#Include 'Protheus.ch'

User Function xMatriz()

Local aMatriz := {}
Local aMatriz2 := Array(2,3)
Local var := 0

aMatriz2[1,1] := "Maria"
aMatriz2[1,2] := 30
aMatriz2[1,3] := "F"

aMatriz2[2,1] := "Ana"
aMatriz2[2,2] := 42
aMatriz2[2,3] := "F"

aAdd(aMatriz2,{"Bruno",48,"M"})
aAdd(aMatriz2,{"Antonio",32,"M"})
aAdd(aMatriz2,{"João",48,"M"})
aAdd(aMatriz2,{"José",26,"M"})

nPos := aScan(aMatriz2,{|x|x[2] == 48})
MsgInfo(aMatriz2[nPos,1])

aSort(aMatriz2,,,{ | x,y | x[1] < y[1] })

/*FOR PARA VARRER ARRAY*/
for linha := 1 to Len(aMatriz2)
	for coluna := 1 to Len(aMatriz2[linha])
		MsgInfo(aMatriz2[linha,coluna])
	next
next


/*FOR PARA VARRER ARRAY*/
for linha := 1 to Len(aMatriz2)
	for coluna := 1 to Len(aMatriz2[linha])
		if(aMatriz2[linha,2] == 48)
				MsgInfo(aMatriz2[linha,1])
		EndIf
	next
next

for linha := 1 to Len(aMatriz2)
	MsgInfo("Nome: " + aMatriz2[linha,1] + CRLF + ;
	"Idade: " + cValToChar(aMatriz2[linha,2]) + CRLF + ;
	"Sexo: " + IIF(aMatriz2[linha,3]=="M","Masculino","Feminino"))
next

Return

