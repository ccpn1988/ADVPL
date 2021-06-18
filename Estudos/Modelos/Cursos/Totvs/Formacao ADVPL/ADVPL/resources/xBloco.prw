#Include 'Protheus.ch'

User Function xBloco()
	//Local bVar := {||MsgInfo("Exemplo bloco") }
	//eVal(bVar)
	
	/*Local bVar := {|X,cTitulo|MsgInfo(X,cTitulo) }
	
  //eVal(variavel	,parametro1		,parametro2)
	eVal(bVar		,"Exemplo bloco","Atenção!!!")*/
	
	/*
	Local bVar 	:= {|X,cTitulo|MsgInfo(X,cTitulo) }
	Local bVar2	:= {|X,Y| MsgInfo("Hola","Teste"), U_Escopo(), X + Y} //Executa o bloco mas retorna somente o resultado da ultima operação enviada por parâmetro
	
	MsgInfo( eVal(bVar2,10,50 ) )
	*/

	Local bVar	:= {|X,Y,Z|aVar := Array(X),aVar(Y) := Z}
	
	MsgInfo( eVal(bVar2,10,50 ) )
	
Return



User Function bVar2(X,Y)
	MsgInfo("Hola","Teste")
	U_Escopo()
	MsgInfo(cValToChar(X+Y))
Return