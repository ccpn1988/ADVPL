#Include 'Protheus.ch'

User Function Xif()
Local dMes := Month ( Date() )
Local nTres := 3

If dMes <= nTres 
   MsgInfo ("1� Trimestre")  
ElseIf dMes <=6
   MsgInfo ("2� Trimestre")
ElseIf dMes <=9
   MsgInfo ("3� Trimestre")  
ElseIf dMes <=12
   MsgInfo ("4� Trimestre")
EndIf
Return ( NIL )


User Function XCase()
Local dMes := Month ( Date() )
Local nTres := 3

Do Case

Case dMes <= nTres 
   MsgInfo ("1� Trimestre")  
Case  dMes <=6
   MsgInfo ("2� Trimestre")
Case dMes <=9
   MsgInfo ("3� Trimestre")  
OtherWise 
   MsgInfo ("4� Trimestre")
EndCase

Return ( NIL )


