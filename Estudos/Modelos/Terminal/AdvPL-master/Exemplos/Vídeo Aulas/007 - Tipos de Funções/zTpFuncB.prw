//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTpFuncB
Teste de Fun��o de Usu�rio
@type function
@author Atilio
@since 13/11/2015
@version 1.0
	@example
	u_zTpFuncB()
/*/

User Function zTpFuncB()
	Local aArea := GetArea()
	
	//Mostra mensagem e chama fun��o est�tica
	MsgInfo("Estou na fun��o u_zTpFuncB()", "Aten��o")
	fTesteB()
	
	RestArea(aArea)
Return

/*-------------------------------------------------*
 | Fun��o: fTesteB                                 |
 | Autor:  Daniel Atilio                           |
 | Data:   13/11/2015                              |
 | Descr.: Fun��o est�tica de teste                |
 *-------------------------------------------------*/

Static Function fTesteB(cPar1)
	Local aArea := GetArea()
	Default cPar1 := ""
	
	//Mostrando mensagem
	MsgInfo("Estou em uma fun��o est�tica <b>(B)</b>, "+cPar1+"!", "Aten��o")
	
	RestArea(aArea)
Return

/*
Abaixo uma fun��o de usu�rio com o nome similar com a fun��o acima, por�m ultrapassa 8 caracteres

User Function zTpFuncB2()

Return
*/

/*
Abaixo uma fun��o padr�o, por�m somente � poss�vel compilar se tiver chave de compila��o

Function zTpFunPad()

Return
*/