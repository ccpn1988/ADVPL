#INCLUDE 'Protheus.ch'

USER FUNCTION zTpFunA()
    Local aArea := GetArea()

    //CHAMANDO FUN��O PADR�O
    Mata010()

    //CHAMANDO USER FUNCTION DE OUTRO FONTE
    u_zTpFunB()

    //CHAMANDO STATIC FUNCTION DO MESMO FONTE
    fTesteA()

    //CHAMANDO FUN��O STATIC DE OUTRO PRW
    StaticCall(zTpFunB, fTesteB, "CAIO NEVES")


    RestArea(aArea)
RETURN

STATIC FUNCTION fTesteA()

    Local aArea := GetArea()

    MsgInfo("Estou na STATIC FUNCTION fTesteA", "Aten��o")

    RestArea(aArea)
RETURN