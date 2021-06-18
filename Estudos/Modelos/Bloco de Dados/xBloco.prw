#Include 'Protheus.ch'

User Function xBloco()
//Local bVar := {|| MSGINFO("Exemplo Bloco")}
Local bVar := {|x| MSGINFO(x)}
	
eVal(bVar, "Exemplo de Bloco")
//eval imprime(variavel, texto)
Return

/////////////////////////////////////////////////////////////////////////////////////////////////

User Function xBloco1()
local bVar := {|x,cTitulo| MSGINFO(x,cTitulo)}

eVal(bVar, "Exemplo Bloco","Atenção")
//eval imprime(variavel, texto,muda nome tela)
Return
/////////////////////////////////////////////////////////////////////////////////////////////////
User Function xBloco2()
local bVar := {|x,cTitulo| MSGINFO(x,cTitulo)}
local bVar2 :={|x,y| x + y}

MsgInfo(eval(bvar2,10,50))

Return

