#Include 'Protheus.ch'
/*
Cláudia Balestri - 06/04/2019
*/

User Function xBloco()

//Local bVar := {|| MsgInfo("Exemplo Bloco")}
//Local bVar := {|x,cTitulo| MsgInfo(x,cTitulo)}
Local bVar2  := {|x,y| msgInfo("Ola","Teste"), U_Escopo(), x+y}

	//eVal(bVar,"Exemplo Bloco","Atenção!!!!")  //eVal ativa o bloco
	MsgInfo(eval(bVar2,10,50)) 

Return

//---------------------------------------------------------
/*or
User Function bVar2(x,y)
 MsgInfo("Ola","Teste")
 U_Escopo()
 Return x+Y
*/