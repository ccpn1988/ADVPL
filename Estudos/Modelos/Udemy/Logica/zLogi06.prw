//Bibliotecas
#Include "Totvs.ch"

//Constantes
#Define STR_NOME "Terminal de Informação"

//Variáveis estaticas
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
    Public __cCidade    := "São Paulo"

    //Mostrando variáveis
    MsgInfo(cNome + " " + cSobreNome + " esta em " + __cCidade + " no dia " + dToC(dDataHoje) + " " + cHoraHoje, "Atenção")

    //Chamando função estática para demonstrar local e private
    fFuncTst()

    RestArea(aArea)

Return 

/*/{Protheus.doc} fFuncTsT
    Função Static
    @type  Static Function
    @author user
    @since 21/07/2020
    @version 1.0
    /*/
Static Function fFuncTsT()
   Local aArea := GetArea()
   Local cNome := "......" 

   MsgInfo( " A variável foi alterado, ficando: " + cNome + " " +cSobreNome, "Atenção" )
   
    RestArea(aArea)
Return 
