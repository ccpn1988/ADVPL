//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME = "Terminal de Informa��o"

//Variav�l Static
Static dDataAtu     := Date()
Static dHoraAtu    := Time()

/*/{Protheus.doc} User Function zLogi07
    Variaveis Private
    @type  Function
    @author user
    @since 22/07/2020
    @version 1.0
    @obs PRIVATE � enxergada dentro da fun��o ao qual foi criada,
        podendo ser acessada por outras fun��es declaradas dentro da fun��o
        ao qual a vari�vel Private foi declarada.
        Variaveis sem escopo definido � criada como PRIVATE
    /*/
User Function zLogi07()
    Local aArea     := GetArea()
    Local cNome     := "Gabriela"
    Private cSobreN := "Almeida"
    Public __cCid   := "S�o Paulo"

    //Mostrando as v�riaveis antes de serem alteradas
    MsgInfo("O nome do cabloco �: " + cNome + " e o sobrenome �: " + cSobreN + " e a dita  mora em: " + __cCid, "Cuidado") 

    MsgInfo(cNome + " nasceu em: " + __cCid + " no dia " + dToC(dDataAtu) + " as: " + dHoraAtu, "Aten��o")

    //Acessando fun��o Static, ao qual acessa a variavel Private cSobreN
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
    MsgInfo("O nome �: " + cNome + " e o sobrenome �: " + cSobreN, "Alerta")

    RestArea(aArea)
    
Return 
