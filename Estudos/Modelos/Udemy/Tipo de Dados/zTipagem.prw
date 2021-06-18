#INCLUDE "Totvs.ch"

//CRLF = QUEBRA DE LINHAS CAIO + CRLF + NEVES
//DaySum() - SOMA DIA - dData := DaySum(dData,2)
//MonthSum() - SOMA DIA - dData := MonthSum(dData,2)
//YearSum() - SOMA DIA - dData := YearSum(dData,2)
//DaySub() - SUBTRAI DIA = dData := DaySub(dData,2)
//MonthSub() - SUBTRAI DIA = dData := MonthSub(dData,2)
//YearSub() - SUBTRAI DIA = dData := YearSub(dData,2)

/*/{Protheus.doc} User Function zTipagem
    Tipagem de Dados em ADVPL
    @type  Function
    @author user
    @since 28/07/2020
    @version 1.0
    @see https://tdn.totvs.com/display/tec/Tipagem+de+Dados
    @see https://tdn.totvs.com/display/tec/Tipos+de+Dados
 /*/
User Function zTipagem()
    Local aArea := GetArea()

    //Declarando da forma antiga
    fFormatAnt()
    //Declarando da forma nova
    fFormatNov()

    RestArea(aArea)

Return 

/*/{Protheus.doc} fFotmatAnt
    Função que demonstra tipagem de dados no formato antigo
    @type  Static Function
    @author user
    @since 28/07/2020
    @version 1.0
    @see (links_or_references)
    /*/
Static Function fFotmatAnt()
    Local cNome     := "CAIO"
    Local cSobren   := "NEVES"
    Local nIdade    := 0
    Local lCurso    := .T.
    Local dDataNasc := sToD("") 
    Local xVariavel := Nil
    Local oFont     := TFont():New()
    Local bBloco    := {|| Alert("TESTE")}
    Local aDados    := {}

Return 

/*/{Protheus.doc} fFormatNov
    (long_description)
    @type  Static Function
    @author user
    @since 28/07/2020
    @see (links_or_references)
    /*/
Static Function fFormatNov()
    
Return 
