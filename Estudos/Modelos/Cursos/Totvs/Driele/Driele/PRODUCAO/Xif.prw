#Include 'Protheus.ch'

User Function Xif()
Local dMes := Month ( Date() )
Local nTres := 3

If dMes <= nTres 
   MsgInfo ("1º Trimestre")  
ElseIf dMes <=6
   MsgInfo ("2º Trimestre")
ElseIf dMes <=9
   MsgInfo ("3º Trimestre")  
ElseIf dMes <=12
   MsgInfo ("4º Trimestre")
EndIf
Return ( NIL )


User Function XCase()
Local dMes := Month ( Date() )
Local nTres := 3

Do Case

Case dMes <= nTres 
   MsgInfo ("1º Trimestre")  
Case  dMes <=6
   MsgInfo ("2º Trimestre")
Case dMes <=9
   MsgInfo ("3º Trimestre")  
OtherWise 
   MsgInfo ("4º Trimestre")
EndCase

Return ( NIL )


