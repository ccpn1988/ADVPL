//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME = "Terminal de Informação"

//Variavél Static
Static dDataAtu     := Date()
Static dHoraAtu    := Time()

/*/{Protheus.doc} User Function zLogi07
    Variaveis Private
    @type  Function
    @author user
    @since 22/07/2020
    @version 1.0
    @obs PRIVATE é enxergada dentro da função ao qual foi criada,
        podendo ser acessada por outras funções declaradas dentro da função
        ao qual a variável Private foi declarada.
        Variaveis sem escopo definido é criada como PRIVATE
    /*/
User Function zLogi07()
    Local aArea     := GetArea()
    Local cNome     := "Gabriela"
    Private cSobreN := "Almeida"
    Public __cCid   := "São Paulo"

    //Mostrando as váriaveis antes de serem alteradas
    MsgInfo("O nome do cabloco é: " + cNome + " e o sobrenome é: " + cSobreN + " e a dita  mora em: " + __cCid, "Cuidado") 

    MsgInfo(cNome + " nasceu em: " + __cCid + " no dia " + dToC(dDataAtu) + " as: " + dHoraAtu, "Atenção")

    //Acessando função Static, ao qual acessa a variavel Private cSobreN
    fFuncTes()

    RestArea(aArea)
    
Return 

/*/{Protheus.doc} fFuncA
    Variavel Private 
    @type  Static Function
    @author user
    @since 22/07/2020
    @version 2.0
    @obs Private sendo acessada pela variavel Static de forma externa
    /*/
Static Function fFuncTes()
    Local aArea := GetArea()
    Local cNome := "Caio"

    //Imprimindo variavel Private da rotina zLogi07
    MsgInfo("O nome é: " + cNome + " e o sobrenome é: " + cSobreN, "Alerta")

    RestArea(aArea)
    
Return 
