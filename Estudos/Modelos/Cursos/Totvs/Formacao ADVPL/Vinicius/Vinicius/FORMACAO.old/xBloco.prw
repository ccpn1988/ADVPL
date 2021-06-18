#Include 'Protheus.ch'

User Function xBloco()
//Local bVar := {|| MsgInfo("Exemplo Bloco")}

Local bVar := {|x,cTitulo| MsgInfo(x,cTitulo)}
Local bVar2:= {|X,Y| MsgInfo("Hola","Teste"),U_Escopo(),X + Y}

//eVal (bVar,"Exemplo Bloco", "Atenção!!!")

MsgInfo(eVal(bVar2,10,50))
Return

