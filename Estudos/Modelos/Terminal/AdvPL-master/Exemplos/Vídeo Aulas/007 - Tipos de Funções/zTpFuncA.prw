//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTpFuncA
Teste de Fun��o de Usu�rio
@type function
@author Atilio
@since 13/11/2015
@version 1.0
	@example
	u_zTpFuncA()
/*/

User Function zTpFuncA()
	Local aArea := GetArea()
	
	//Chamada de fun��o padr�o
	Mata010()

	//Chamada de fun��o de usu�rio
	u_zTpFuncB()
	
	//Chamada de fun��o est�tica no mesmo prw
	fTesteA()
	
	//Chamada de fun��o est�tica de outro prw
	StaticCall(zTpFuncB, fTesteB, "Daniel")
	
	RestArea(aArea)
Return


/*-------------------------------------------------*
 | Fun��o: fTesteA                                 |
 | Autor:  Daniel Atilio                           |
 | Data:   13/11/2015                              |
 | Descr.: Fun��o est�tica de teste                |
 *-------------------------------------------------*/

Static Function fTesteA()
	Local aArea := GetArea()
	
	//Mostrando mensagem
	MsgInfo("Estou em uma fun��o est�tica <b>(A)</b>!", "Aten��o")
	
	RestArea(aArea)
Return