#Include 'Protheus.ch'

User Function xVetor()
 Local aVar:={}
 Local aSemana:= Array(5)
 Local aVar2 :={"A","C","D","B","F","H","G"}
 Local x:=1
aSemana[1]:="Domingo"
aSemana[2]:="Segunda"
aSemana[3]:="Terça"
aSemana[4]:="Quarta"
aSemana[5]:="Quinta"

aadd(aSemana,"Sexta")
aadd(aSemana,"Sabado")


asort(aVar2,,,{|X,Y| X > Y})//ordenar
For x:= 1 to len (aVar2)
	MsgInfo(aVar2[x])
Next


//x := aScan(aSemana,"Quinta")
//	if x > 0
//		MsgInfo(cValtochar(x)+" => "+ aSemana[x])
//	endif
	
	
//-----------------------------------------	
//for x := 1 to Len(aSemana)
//	if Alltrim(Upper(aSemana[x]))== 'Quinta'
//		MsgInfo(cValtochar(x)+ " => " aSemana[x])
//	Endif	
//next


Return
//-----------------------------------------------



