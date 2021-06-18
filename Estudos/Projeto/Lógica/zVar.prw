#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

//CONSTANTES
#DEFINE STR_NOME "TERMINAL DE INFORMA��O"

//VARIAVEL STATICA
STATIC dDataHoje := Date()
STATIC cHoraHoje := Time()

/*
LOCAL = S�O VISIVEIS EM QUALQUER LOCAL DO FONTE AONDE FORAM DECLARADAS.

STATIC = SE FOREM DECLARADAS DENTRO DE UMA FUN��O O ESCOPO SER A LIMITADO, SE DECLARADO FORA DO CORPO DA FUN��O
         QUALQUER UN��O PODERA UTILIZAR.

PRIVATE = VISIVEL EM TODO O PROGRAMA, ACESSADA POR OUTRAS FUN��ES DECLARADAS AONDE A VARIAVEL FOI CRIADA.

PUBLIC = VISIVEL EM TODO PROGRAMA, SENDO ESCONDIDA POR UMA VARIAVEL PRIVATE COM MESMO NOME.

OBS: VARIAVEL SEM ESCOPO POR PADRAO � PRIVATE.
*/

User Function zVar()
    Local aArea         := GetArea()
    Local cNome         := "Caio"
    Private cSobreNome  := "Neves"
    Public __cCidade    := "S�o Paulo" 

    //Nesta condi��o a vari�vel cNome tem o conte�do "Caio"
    MsgInfo(cNome + " " + cSobreNome + " esta em " + __cCidade + " no dia " + dToC(dDataHoje), "Aten��o")

    //Fun��o fFuncTst tem acesso a variavel Private cSobreNome
    fFuncTst()

    RestArea(aArea)

Return

Static Function fFuncTst()
    Local aArea := GetArea()
    Local cNome := "Gabi"

    //Nesta condi��o a vari�vel cNome tem o conte�do 'Gabi', por ser local
    //e seu conteudo foi alterado em rela��o a User Function zVar.
    MsgInfo(cNome + " " + cSobreNome, "Aten��o")

    RestArea(aArea)
Return
