#INCLUDE 'Protheus.ch'


//-----------------------------------//
//          TIPOS DE FUN��ES         //
//-----------------------------------//


// FUNCTION() - RESTRITA AO DESENVOLVIMENTO TOTVS (10 CARACTERES) - MATA001CLI()
// USER FUNCTIO() - FUN��ES DE USUARIO - CUSTOMIZA��ES - U_NOMEFUNC
// STATIC FUNCTION() - FUNCOES CUJA VALIDADE ESTA RESTRITA A FUN��ES DO MESMO C�DIGP
// MAIN FUNCTION() - FUN��O ESPECIAL USADA VIA SMARTCLIENT - UPDDISTR - SIGAMDI

USER FUNCTION zTpFunB()
    Local aArea := GetArea()

    //MOSTRA A MENSAGEM E CHAMA A FUN��O STATIC

    MsgInfo("Estou na fun��o U_zTpFuncB", "Aten�ao")
    fTesteB()

    RestArea(aArea)
RETURN    

//-----------------------------------//
//          STATIC FUNCTION          //
//-----------------------------------//

STATIC FUNCTION fTesteB()
    Local aArea := GetArea()
    Local cPar1 := ""

    MsgInfo("Estou na fun��o STATIC","Aten��o")

    RestArea(aArea)

RETURN

