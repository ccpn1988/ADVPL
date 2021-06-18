//Bibliotecas
#Include "Protheus.ch"

//Vari�veis Est�ticas
Static cTesteSta := ''

/*/{Protheus.doc} zEscopo
Fun��o exemplo de escopo de vari�veis
@author Atilio
@since 18/10/2015
@version 1.0
	@example
	u_zEscopo()
/*/

User Function zEscopo()
	Local aArea := GetArea()
	
	//Vari�veis Locais
	Local nVar01 := 5
	Local nVar02 := 8
	Local nVar03 := 10
	
	//Vari�veis Privadas
	Private cTst := "Teste Pvt"
	cTst2 := "Teste Pvt2"
	
	//Vari�veis p�blicas
	Public __cTeste  := "Daniel"
	Public __cTeste2 := "Atilio"
	
	//Chamando outra rotina para demonstrar o escopo de vari�veis
	fEscopo(nVar01, @nVar02)
	
	Alert(nVar02)
	Alert("Public: "+__cTeste + " " + __cTeste2)
	RestArea(aArea)
Return

/*-------------------------------------------------*
 | Fun��o: fEscopo                                 |
 | Autor:  Daniel Atilio                           |
 | Data:   18/10/2015                              |
 | Descr.: Fun��o que testa escopo de vari�veis    |
 *-------------------------------------------------*/

Static Function fEscopo(nValor1, nValor2, nValor3)
	Local aArea := GetArea()
	
	//Vari�veis locais
	Local __cTeste2 := "Teste2"
	
	//Valores Default
	Default nValor1 := 0
	Default nValor2 := 0
	Default nValor3 := 0
	
	//Alterando conte�do do nValor2
	nValor2 += 10
	
	//Mostrando conte�do da vari�vel private
	Alert("Private: "+cTst2)
	
	//Setando valor da vari�vel p�blica para demonstrar como pode ser perigoso a utiliza��o
	__cTeste := "Teste1"
	
	RestArea(aArea)
Return