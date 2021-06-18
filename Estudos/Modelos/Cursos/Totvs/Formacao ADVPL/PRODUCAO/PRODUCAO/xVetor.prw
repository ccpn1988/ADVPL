#Include 'Protheus.ch'

User Function xVetor()
//Local aSemana := Array(7)
Local aSemana := {}
Local x

//aSemana[1] := "Domingo"
//aSemana[2] := "Segunda"
//aSemana[3] := "Terça"
//aSemana[4] := "Quarta"
//aSemana[5] := "Quinta"
//aSemana[6] := "Sexta"
//aSemana[7] := "Sabado"

aAdd (aSemana, "Domingo")
aAdd (aSemana, "Segunda")
aAdd (aSemana, "Terça")
aAdd (aSemana, "Quarta")
aAdd (aSemana, "Quinta")
aAdd (aSemana, "Sexta")
aAdd (aSemana, "Sabado")


//------------------------------------------------------

x := aScan (aSemana, "Quinta")
x := aScan (aSemana, {|x| Alltrim(Upper(x)) == "QUINTA"} )
If x > 0
   Msginfo (cValtochar( x ) + " => " + aSemana[x] )
Endif
Return
//------------------------------------------------------

//For X :=  1 To Len(aSemana)
//                   
//            If Alltrim(Upper(aSemana[x])) == "QUINTA"
//               Msginfo ( "Posição é igual 5")
//            Endif    
//      Msginfo ( aSemana [x] )       
//NExt
//Return




