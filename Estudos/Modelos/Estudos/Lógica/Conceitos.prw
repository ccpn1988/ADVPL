/*ADVPL REFERÊNCIAS
BIBLIOTECAS - #INCLUDES - PROTHEUS.CH - TOPCONN.CH - RWMAKE.CH
CONSTANTES DECLARADAS - #DEFINES (VALORES NÃO SE ALTERAM)
DOCUMENTAÇÃO DA FUNÇÃO - CTRL + ALT + D (ANTES DA USER FUNCTION)

{TIPO DE FUNÇÃO} - FUNCTION - {NOME FUNÇÃO}
	{DECLARAÇÃO DE VARIAVEIS}
	GETAREA := aArea
    LOCAL
    PRIVATE
    PUBLIC
    
	{LOGICA DE PROGRAMAÇÃO}
	
    IF/ELSE
    WHILE/ENDDO
    CASE/OTHERWISE
    FOR/NEXT


	{ENCERRAMENTO DE VARIAVEIS / AREAS }
	
    RestArea(aArea)

RETURN {VARIAVEL DE RETORNO}
*/
	
//------------------------------------------------
//          MODELO DE EXEMPLO
//------------------------------------------------

//BIBLIOTECAS
#INCLUDE "Protheus.ch"

//CONSTANTES
#DEFINE STR_PULA CHR(13) + CHR(10)


USER FUNCTION yCONCEI()
    Local aArea := GetArea()
    Local cHora := Time()

    // MOSTRANDO HORA ATUAL
    MsgInfo("Hora Atual" + STR_PULA + cHora, "Atenção")

    RestArea(aArea)

RETURN
