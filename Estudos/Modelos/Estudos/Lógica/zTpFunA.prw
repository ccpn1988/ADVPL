#INCLUDE 'Protheus.ch'

USER FUNCTION zTpFunA()
    Local aArea := GetArea()

    //CHAMANDO FUNÇÂO PADRÂO
    Mata010()

    //CHAMANDO USER FUNCTION DE OUTRO FONTE
    u_zTpFunB()

    //CHAMANDO STATIC FUNCTION DO MESMO FONTE
    fTesteA()

    //CHAMANDO FUNÇÂO STATIC DE OUTRO PRW
    StaticCall(zTpFunB, fTesteB, "CAIO NEVES")


    RestArea(aArea)
RETURN

STATIC FUNCTION fTesteA()

    Local aArea := GetArea()

    MsgInfo("Estou na STATIC FUNCTION fTesteA", "Atenção")

    RestArea(aArea)
RETURN