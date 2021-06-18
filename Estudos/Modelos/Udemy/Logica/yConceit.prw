// ------------------------------------------------ ------------------
// Corpo de um programa AdvPL:
// ------------------------------------------------ ------------------

/*
{Bibliotecas utilizadas - Inclui}
{Constantes declaradas - Define}
{Variáveis ??Estáticas - Estático}
{Documentação da Função}
Função {Tipo Função} {Nome Função}

	{Declaração de variáveis}

	{Lógica do Programa}

	{Encerramento de variáveis ??/ áreas}

Retorno {Variável Retorno}
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
