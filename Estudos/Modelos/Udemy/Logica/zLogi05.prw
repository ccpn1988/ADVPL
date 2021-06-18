#INCLUDE "Totvs.ch"


/*/{Protheus.doc} User Function zLogi04
    Fun��o Static e sua utiliza��o
    @type  Function
    @author user
    @since 21/07/2020
    @version version
    /*/
User Function zLogi05()
    Local aArea := GetArea()

    MsgInfo("Estou na Ussr Function", "Aten��o")

    //Chamando a fun��o Static A
        fFuncA()
    //Chamando a fun��o Static B
        fFuncB()
    //Chamando a fun��o Static TESTE
        fFuncTST()

    RestArea(aArea)

Return
    
/*/{Protheus.doc} fFuncA
    Fun��o Static com acesso via fun��o de usu�rio
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0

    /*/
Static Function fFuncA(param_name)
    
    MsgInfo("Estou na Static Function fFuncA!!! ", "Aten��o")

Return 

/*/{Protheus.doc} fFuncB
    Fun��o Static com acesso via fun��o de usu�rio
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncB()
    
    MsgInfo(" Estou na Static Function fFuncB ", "Aten��o")
    
Return 

/*/{Protheus.doc} fFuncTST
    Fun��o Static com acesso via fun��o de usu�rio
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncTST()
    
    MsgInfo(" Estou na Static Function fFuncTST ", "Aten��o")
    
Return 
