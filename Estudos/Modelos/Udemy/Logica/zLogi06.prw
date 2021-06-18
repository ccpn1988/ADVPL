//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME "Terminal de Informa��o"

//Vari�veis estaticas
Static dDataHoje := Date()
Static cHoraHoje := Time()

/*/{Protheus.doc} User Function zLogi06
    Demonstrando tipos de dados em ADVPL
    @type  Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/


User Function zLogi06()
    Local aArea         := GetArea()
    Local cNome         := "Caio"
    Private cSobreNome  := "Neves"
    Public __cCidade    := "S�o Paulo"

    //Mostrando vari�veis
    MsgInfo(cNome + " " + cSobreNome + " esta em " + __cCidade + " no dia " + dToC(dDataHoje) + " " + cHoraHoje, "Aten��o")

    //Chamando fun��o est�tica para demonstrar local e private
    fFuncTst()

    RestArea(aArea)

Return 

/*/{Protheus.doc} fFuncTsT
    Fun��o Static
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncTsT()
   Local aArea := GetArea()
   Local cNome := "......" 

   MsgInfo( " A vari�vel foi alterado, ficando: " + cNome + " " +cSobreNome, "Aten��o" )
   
    RestArea(aArea)
Return 
