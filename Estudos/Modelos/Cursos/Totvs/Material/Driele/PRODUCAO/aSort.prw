#Include 'Protheus.ch'
#INCLUDE "TOTVS.CH"

User Function xaSort()

Local aVar2 := {"A","C","D","B","F","H","G"}
Local x


aSort(aVar2, , , {|x,y| x < y } )

For x:= 1 To Len ( aVar2)

   MsgInfo( aVar2[x])
    
Next    

Return( Nil )