#INCLUDE "Totvs.ch"


/*/{Protheus.doc} User Function zLogi04
    Função Static e sua utilização
    @type  Function
    @author user
    @since 21/07/2020
    @version version
    /*/
User Function zLogi05()
    Local aArea := GetArea()

    MsgInfo("Estou na Ussr Function", "Atenção")

    //Chamando a função Static A
        fFuncA()
    //Chamando a função Static B
        fFuncB()
    //Chamando a função Static TESTE
        fFuncTST()

    RestArea(aArea)

Return
    
/*/{Protheus.doc} fFuncA
    Função Static com acesso via função de usuário
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0

    /*/
Static Function fFuncA(param_name)
    
    MsgInfo("Estou na Static Function fFuncA!!! ", "Atenção")

Return 

/*/{Protheus.doc} fFuncB
    Função Static com acesso via função de usuário
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncB()
    
    MsgInfo(" Estou na Static Function fFuncB ", "Atenção")
    
Return 

/*/{Protheus.doc} fFuncTST
    Função Static com acesso via função de usuário
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncTST()
    
    MsgInfo(" Estou na Static Function fFuncTST ", "Atenção")
    
Return 
