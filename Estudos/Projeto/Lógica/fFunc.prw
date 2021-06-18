#INCLUDE "PROTHEUS.CH"

/*
FUNCTION - SAO RESTRITAS AO DESENVOLVIMENTO ADVPL TOTVS - NOME COM LIMITE DE 10 CARACTERES - MATA100()
    FUNCTION MATA100()
    RETURN

USER FUNCTION - FUN��ES DE USU�RIO  - DESENVOLVIMENTO ESTERNO PARA SUPRIR NECESSIDADE - NOME COM LIMITE DE 10 CARACTERES - U_NOMEFUNCAO()
    USER FUNCTION NOMEFUNCAO()
    RETURN

STATIC FUNCTION - VISIVEL APENAS NO MESMO C�DIGO FONTE - NOME COM LIMITE DE 10 CARACTERES
    FUNCTION MATACLI001()
        CRIASX1("MATACLI001")
    RETURN

    STATIC FUNCTION CRIASX1()
    RETURN

MAIN FUNCTION - FUN��O RESTRITA TOTVS - NOME COM LIMITE DE 10 CARACTERES - SIGAADV()
    USADA NA TELA INICIAL DO SMARTCLIENT

*/


User Function fFunc()
    Local aArea := GetArea()

    MsgInfo("Estou na User Function TFun�","Aten��o")

    //Chamando Fun��o A
    fFuncA()

    //Chamando Fun��o B
    fFuncB()

    //Chamando Fun��o Teste
    fFuncTst()

    RestArea(aArea)

Return

Static Function fFuncA()
    MsgInfo("Estou na Static Function fFuncA! ", "Aten��o")
Return

static Function fFuncB()
    MsgInfo("Estou na Static Function fFuncB! ", "Aten��o")
Return

static Function fFuncTst()
    MsgInfo("Estou na Static Function fFuncTst! ", "Aten��o")
Return
