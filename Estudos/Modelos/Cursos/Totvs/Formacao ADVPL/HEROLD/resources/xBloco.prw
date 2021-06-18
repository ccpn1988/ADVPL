#Include 'Protheus.ch'

User Function xBloco()
//Local bVar := {|| MsgInfo("Exemplo bloco") }
//Local bVar  := {|x,cTitulo| MsgInfo(x,cTitulo) }
//Local bVar2 := {|X,Y| msginfo("Hola","Teste" ), U_Espoco() ,  X + Y }  
Local bVar  := {|X,Y,Z|aVar := Array(x),aVar[Y] := Z , MsgInfo(aVar[Y])  }


eVal(bVar,3,2,"Texto") 






//eVal(bVar,"Exemplo bloco","Atenção!!!")


//MsgInfo( eVal(bVar2,10,50) )

Return
//----------------------------------------------------------------------------
User Function bVar2(X,Y)
Local aVar := Array(3)
aVar[2] := "Teste"

Msginfo(aVar[2])





Return  X + Y