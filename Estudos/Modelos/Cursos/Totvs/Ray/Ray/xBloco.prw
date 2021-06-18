#Include 'Protheus.ch'

User Function xBloco()

//	Local bVar := {|| MsgInfo("Exemplo bloco")}
	Local bVar := {|x,cTitulo| MsgInfo(x,cTitulo)}
	Local bVar2 := {|X,Y| X + Y }
	
//	eVal(bVar, "Exemplo Bloco","Atenção!!!")

	MsgInfo( eVal(bVar2, 10, 50))

Return

