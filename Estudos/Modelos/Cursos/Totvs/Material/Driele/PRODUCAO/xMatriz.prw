#Include 'Protheus.ch'

User Function xMatriz()
Local aMatriz := {}
Local aMatriz2 := Array (2,3)
Local x
Local nPos := ""

//aMatriz2 [1,1] = "Maria"
//aMatriz2 [1,2] = "30"
//aMatriz2 [1,3] = "F"
//aMatriz2 [2,1] = "Ana"
//aMatriz2 [2,2] = 42
//aMatriz2 [2,3] = "F"

aAdd (aMatriz2, {"Bruno",25, "M" } )
aAdd (aMatriz2, {"Antonio" ,32, "M" } )
aAdd (aMatriz2, {"João",48, "M" } )
aAdd (aMatriz2, {"Jose",26, "M" } )

//For Listando os dados do Array

nPos:= aScan(aMatriz2,{|x| x[2]==48})
MsgInfo(aMatriz2[nPos,1])

//aSort (aMatriz2,,,{|x,y| x[2] , y[1]})
aSort (aMatriz2,,,{|x,y| cValtochar( x[2])+ x[1] < cValtochar(y[2])+y[1]})

For x :=  1 To len(aMatriz2)
     if cValtochar (aMatriz2 [x,2]) = "48"
      MsgInfo("Nome:" + aMatriz2[x,1] + CRLF+;
      "Idade: " + cValtochar ( aMatriz2 [x,2]) + CRLF+;  
      "Sexo: " + iif(aMatriz2[x,3] == "M","Masculino", "Feminino") )
      Endif      
Next x

//

///--------------------------------------------------------------------

//For x :=  1 To len(aMatriz2)
//   For Y :=  1 To len(aMatriz2[x])
//   Msginfo (aMatriz2[x,y]) 
//   NExt  y
//Next x
//---------------------------------------------------------------------
Return

//MsgInfo (aMatriz2)
//Return

