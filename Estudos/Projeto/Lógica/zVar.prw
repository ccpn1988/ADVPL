#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

//CONSTANTES
#DEFINE STR_NOME "TERMINAL DE INFORMAÇÂO"

//VARIAVEL STATICA
STATIC dDataHoje := Date()
STATIC cHoraHoje := Time()

/*
LOCAL = SÃO VISIVEIS EM QUALQUER LOCAL DO FONTE AONDE FORAM DECLARADAS.

STATIC = SE FOREM DECLARADAS DENTRO DE UMA FUNÇÃO O ESCOPO SER A LIMITADO, SE DECLARADO FORA DO CORPO DA FUNÇÃO
         QUALQUER UNÇÃO PODERA UTILIZAR.

PRIVATE = VISIVEL EM TODO O PROGRAMA, ACESSADA POR OUTRAS FUNÇÔES DECLARADAS AONDE A VARIAVEL FOI CRIADA.

PUBLIC = VISIVEL EM TODO PROGRAMA, SENDO ESCONDIDA POR UMA VARIAVEL PRIVATE COM MESMO NOME.

OBS: VARIAVEL SEM ESCOPO POR PADRAO É PRIVATE.
*/

User Function zVar()
    Local aArea         := GetArea()
    Local cNome         := "Caio"
    Private cSobreNome  := "Neves"
    Public __cCidade    := "São Paulo" 

    //Nesta condição a variável cNome tem o conteúdo "Caio"
    MsgInfo(cNome + " " + cSobreNome + " esta em " + __cCidade + " no dia " + dToC(dDataHoje), "Atenção")

    //Função fFuncTst tem acesso a variavel Private cSobreNome
    fFuncTst()

    RestArea(aArea)

Return

Static Function fFuncTst()
    Local aArea := GetArea()
    Local cNome := "Gabi"

    //Nesta condição a variável cNome tem o conteúdo 'Gabi', por ser local
    //e seu conteudo foi alterado em relação a User Function zVar.
    MsgInfo(cNome + " " + cSobreNome, "Atenção")

    RestArea(aArea)
Return
