#include 'protheus.ch'
#include 'parmtype.ch'

user function zTpFuncA()
	Local aArea := GetArea()
	
	
		
	//CHAMADA FUNçÂO DE USUÁRIO
	u_zTpFuncB()
	
	//CHAMADA DE FUNÇÃO ESTATICA NO MESMO PRW
	fTesteA()
	
	//CHAMADA DE FUNÇÃO ESTATICA DE OUTRO PRW
	StaticCall(zTpFuncB, fTesteB, "Daniel")
	
	RestArea(aArea)
Return

Static Function fTesteA()
	Local aArea := GetArea()
		
	//MOSTRANDO MENSAGEM
	MsgInfo("Estou em uma função estatica <b>(A)</b>!", "ATENÇÃO")
	
	RestArea(aArea)
Return