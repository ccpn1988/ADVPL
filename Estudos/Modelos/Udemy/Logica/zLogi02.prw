/*01 . Bibliotecas e Constantes */

//Bibliotecas
#Include "Totvs.ch"

/* Documentação = SHIFT + ALT + D */
/*/{Protheus.doc} zLogi02 
Demosntrando a Estrutura de um prgrama 
@type function
@version 1.0
@type function
@author Caio Neves
@since 16/07/2020
@see https://tdn.totvs.com/display/tec/ProtheusDOC
/*/

User Function zLogi02()
    Local aArea := GetArea()
    Local dDataAtu := Date()
    Local cHoraAtu := Time()
    Local cNome := "Curso de Logica em ADVPL"

    /*Corpo do Programa*/
    MsgInfo("Estamos no [" + cNome + "], hoje é " + dToC(dDataAtu)+ ", às " + cHoraAtu, "Atenção")
    MsgInfo("Ontem seria " + dToC(DaySub(dDataAtu,1)), "Atenção")
    MsgInfo("Mês passado seria " + dToC(MonthSub(dDataAtu,1)), "Atenção")

    /*Encerramento do Programa*/
    RestArea(aArea)
Return

/*/{Protheus.doc} User Function zLogi03
    (long_description)
    @type  Function
    @author user
    @since 16/07/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see https://tdn.totvs.com/display/tec/ProtheusDOC
    /*/
User Function zLogi03()
    
Return return_var
