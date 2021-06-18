//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME "Terminal de Informa��o"

//Variaveis Static
Static dDataH   := Date()
static dHoraA   := Time()

/*/{Protheus.doc} User Function zLogi08
    Constantes
    @type  Function
    @author user
    @since 22/07/2020
    @version 1.0
    @obs CONSTANTES declarado ap�s Biblioteca, n�o s�o alteraveis no fonte.
        STR_ - STRING
        COL_ - COLUNA
        POS_ - ARRAY POSICAO
        NUM_ - NUMERO

    /*/
User Function zLogi10()
    Local aArea         := GetArea()
    Local cNome         := "Fe Faber"
    Private cSbNome     := "Marques"
    Public  __cCidade   := "Santos"

    MsgInfo(cNome + " � meu amor e a Dona Marlene " + cSbNome + " � minha sogra e gosta da cidade de: " + __cCidade, "Cidade")

    fFuncTs()

    RestArea(aArea)
    
Return 

Static Function fFuncTs
    MsgInfo("Chupa Gambazada")
Return
