//------------------------------------------------------------------
//    Corpo de um programa AdvPL:
//------------------------------------------------------------------

/*
{Bibliotecas utilizadas - Includes}

{Constantes declaradas - Defines}

{Vari�veis Est�ticas - Static}

{Documenta��o da Fun��o}

{Tipo Fun��o} Function {Nome Fun��o}
	{Declara��o de vari�veis}

	{L�gica do Programa}

	{Encerramento de vari�veis / �reas}
Return {Vari�vel Retorno}
*/

//------------------------------------------------------------------
//    Exemplo abaixo:
//------------------------------------------------------------------

//Bibliotecas
#Include "Protheus.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} zCorpo
Exemplo de corpo de programa em AdvPL
@author Atilio
@since 11/10/2015
@version 1.0
	@example
	u_zCorpo()
/*/

User Function zCorpo()
	Local aArea := GetArea()
	Local cHora := Time()
	
	//Mostrando uma mensagem da hora atual
	MsgInfo("Hora Atual: " + STR_PULA + cHora, "Aten��o")
	
	RestArea(aArea)
Return