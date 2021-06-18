// ------------------------------------------------ ------------------
// Corpo de um programa AdvPL:
// ------------------------------------------------ ------------------

/*
{Bibliotecas utilizadas - Inclui}
{Constantes declaradas - Define}
{Vari�veis ??Est�ticas - Est�tico}
{Documenta��o da Fun��o}
Fun��o {Tipo Fun��o} {Nome Fun��o}

	{Declara��o de vari�veis}

	{L�gica do Programa}

	{Encerramento de vari�veis ??/ �reas}

Retorno {Vari�vel Retorno}
*/

// ------------------------------------------------ ------------------
// Exemplo abaixo:
// ------------------------------------------------ ------------------

// Bibliotecas
#INCLUDE 'Totvs.ch'

//Constantes
#Define STR_PULA CHR(13)+CHR(10)

/*/{Protheus.doc} User Function yConceit
    (long_description)
    @type  Function
    @author CAIO NEVES
    @since 18/08/2020
    /*/
User Function yConceit()
    Local aArea := GetArea()
    Local cHora  := Time()

    MsgInfo("Hora Atual "+ STR_PULA + cHora, "Caution")

    RestArea(aArea)
Return 
