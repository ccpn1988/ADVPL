#Include 'Protheus.ch'

User Function xBloco()
//Local bVar := {|| Msginfo ("Exemplo Bloco")}
Local bVar := {|x, cTitulo| Msginfo (x, cTitulo)}
Local bVar2 := {|x,y|MsgInfo ("Olá", "Teste"), U_xEscopo(), x+ y}

//eVal (bVar, "Exemplo Bloco", "Atenção!!!")

MsgInfo  (eval(bVar2, 10,50) )

Return

