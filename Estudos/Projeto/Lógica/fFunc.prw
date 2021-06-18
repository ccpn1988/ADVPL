#INCLUDE "PROTHEUS.CH"

/*
FUNCTION - SAO RESTRITAS AO DESENVOLVIMENTO ADVPL TOTVS - NOME COM LIMITE DE 10 CARACTERES - MATA100()
    FUNCTION MATA100()
    RETURN

USER FUNCTION - FUNÇÕES DE USUÁRIO  - DESENVOLVIMENTO ESTERNO PARA SUPRIR NECESSIDADE - NOME COM LIMITE DE 10 CARACTERES - U_NOMEFUNCAO()
    USER FUNCTION NOMEFUNCAO()
    RETURN

STATIC FUNCTION - VISIVEL APENAS NO MESMO CÓDIGO FONTE - NOME COM LIMITE DE 10 CARACTERES
    FUNCTION MATACLI001()
        CRIASX1("MATACLI001")
    RETURN

    STATIC FUNCTION CRIASX1()
    RETURN

MAIN FUNCTION - FUNÇÃO RESTRITA TOTVS - NOME COM LIMITE DE 10 CARACTERES - SIGAADV()
    USADA NA TELA INICIAL DO SMARTCLIENT

*/


User Function fFunc()
    Local aArea := GetArea()

    MsgInfo("Estou na User Function TFunç","Atenção")

    //Chamando Função A
    fFuncA()

    //Chamando Função B
    fFuncB()

    //Chamando Função Teste
    fFuncTst()

    RestArea(aArea)

Return

Static Function fFuncA()
    MsgInfo("Estou na Static Function fFuncA! ", "Atenção")
Return

static Function fFuncB()
    MsgInfo("Estou na Static Function fFuncB! ", "Atenção")
Return

static Function fFuncTst()
    MsgInfo("Estou na Static Function fFuncTst! ", "Atenção")
Return
