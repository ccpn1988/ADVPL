//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME "Terminal de Informa��o"

//Variaveis Static
Static dDataH   := Date()
static dHoraA   := Time()

/*/{Protheus.doc} User Function zLogi08
    Variavel Static
    @type  Function
    @author user
    @since 22/07/2020
    @version 1.0
    @obs STATIC existe no PRW como um todo, todas as fun��es enxergam, exclusivo do PRW.
    /*/
User Function zLogi08()
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
