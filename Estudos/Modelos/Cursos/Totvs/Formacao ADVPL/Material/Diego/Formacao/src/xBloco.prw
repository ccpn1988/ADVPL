#Include 'Protheus.ch'

User Function xBloco()

Local yVar := {|x,cTitulo|MsgInfo(x, cTitulo)}
Local bVar := {||MsgInfo("Exembro de Bloco")}
Local xVar := {|x|MsgInfo(x)}

eVal(bVar)
eVal(xVar,"Exemplo Bloco")
eVal(yVar,"Exemplo Bloco","Atenção!!")

Return


User Function xBloco2()

Local yVar := {|x,cTitulo|MsgInfo(x, cTitulo)}
Local bVar2 := {|X,Y|X+Y}
Local bVar3 := {|X,Y,Z| aVar := Array(X), aVar[Y] := Z, MsgInfo(aVar[Y])}

eval(bVar3,3,2,"Texto")
MsgInfo(eval(bVar2,10,50))

Return

/*SERIA IGUAL A UMA FUNÇÂO*/
User Function bVar2(X,Y)
MsgInfo("Hola ", "Teste")
U_escopo()
Return X+Y
