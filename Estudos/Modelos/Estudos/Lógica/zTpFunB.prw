#INCLUDE 'Protheus.ch'


//-----------------------------------//
//          TIPOS DE FUNÇÔES         //
//-----------------------------------//


// FUNCTION() - RESTRITA AO DESENVOLVIMENTO TOTVS (10 CARACTERES) - MATA001CLI()
// USER FUNCTIO() - FUNÇÔES DE USUARIO - CUSTOMIZAÇÔES - U_NOMEFUNC
// STATIC FUNCTION() - FUNCOES CUJA VALIDADE ESTA RESTRITA A FUNÇÕES DO MESMO CÓDIGP
// MAIN FUNCTION() - FUNÇÂO ESPECIAL USADA VIA SMARTCLIENT - UPDDISTR - SIGAMDI

USER FUNCTION zTpFunB()
    Local aArea := GetArea()

    //MOSTRA A MENSAGEM E CHAMA A FUNÇÂO STATIC

    MsgInfo("Estou na função U_zTpFuncB", "Atençao")
    fTesteB()

    RestArea(aArea)
RETURN    

//-----------------------------------//
//          STATIC FUNCTION          //
//-----------------------------------//

STATIC FUNCTION fTesteB()
    Local aArea := GetArea()
    Local cPar1 := ""

    MsgInfo("Estou na função STATIC","Atenção")

    RestArea(aArea)

RETURN

