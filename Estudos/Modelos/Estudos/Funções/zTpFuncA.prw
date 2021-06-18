#include 'protheus.ch'
#include 'parmtype.ch'

user function zTpFuncA()
	Local aArea := GetArea()
	
	
		
	//CHAMADA FUN��O DE USU�RIO
	u_zTpFuncB()
	
	//CHAMADA DE FUN��O ESTATICA NO MESMO PRW
	fTesteA()
	
	//CHAMADA DE FUN��O ESTATICA DE OUTRO PRW
	StaticCall(zTpFuncB, fTesteB, "Daniel")
	
	RestArea(aArea)
Return

Static Function fTesteA()
	Local aArea := GetArea()
		
	//MOSTRANDO MENSAGEM
	MsgInfo("Estou em uma fun��o estatica <b>(A)</b>!", "ATEN��O")
	
	RestArea(aArea)
Return