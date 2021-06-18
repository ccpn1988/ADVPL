//BIBLIOTECAS
#INCLUDE "TOTVS.CH"

// DOCUMENTA��O DA FUN��O

/*/{Protheus.doc} User Function BibConst
    (long_description)
    @type  Function
    @author user
    @since 06/04/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

 // Abertura do Programa   
User Function BibConst()
    Local aArea     := GetArea()
    Local dDataAtu  := Date()
    Local cHoraAtu  := Time()
    Local cNome     := 'Curso Logica em ADVPL'

// Corpo do Programa

    MsgInfo("Estamos no [" + cNome + "], hoje � " + dToC(dDataAtu) + ", as " + cHoraAtu, "Aten��o")
    MsgInfo("Ontem seria " + dToc(DaySub(dDataAtu, 1)), "Aten��o")
    MsgInfo("M�s passado seria " + dToC(MonthSub(dDataAtu, 1)), "Aten��o")

//ENCERRAMENTO DO PROGRAMA
    RestArea(aArea)
Return 
