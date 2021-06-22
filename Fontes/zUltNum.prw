/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2018/03/27/funcao-advpl-retorna-ultimo-codigo-de-uma-tabela-sql/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/{Protheus.doc} zUltNum
Fun��o que retorna o ultimo campo c�digo
@type function
@author Atilio
@since 01/11/2017
@version 1.0
    @param cTab, Caracter, Tabela que ser� consultada
    @param cCampo, Caracter, Campo utilizado de c�digo
    @param [lSoma1], L�gico, Define se al�m de trazer o �ltimo, j� ir� somar 1 no valor
    @example
    u_zUltNum("SC5", "C5_X_CAMPO", .T.)
/*/
 
User Function zUltNum(cTab, cCampo, lSoma1)
    Local aArea       := GetArea()
    Local cCodFull    := ""
    Local cCodAux     := ""
    Local cQuery      := ""
    Local nTamCampo   := 0
    Default lSoma1    := .T.
     
    //Definindo o c�digo atual
    nTamCampo := TamSX3(cCampo)[01]
    cCodAux   := StrTran(cCodAux, ' ', '0')
     
    //Fa�o a consulta para pegar as informa�ões
    cQuery := " SELECT "
    cQuery += "   ISNULL(MAX("+cCampo+"), '"+cCodAux+"') AS MAXIMO "
    cQuery += " FROM "
    cQuery += "   "+RetSQLName(cTab)+" TAB "
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "QRY_TAB"
     
    //Se n�o tiver em branco
    If !Empty(QRY_TAB->MAXIMO)
        cCodAux := QRY_TAB->MAXIMO
    EndIf
     
    //Se for para atualizar, soma 1 na vari�vel
    If lSoma1
        cCodAux := Soma1(cCodAux)
    EndIf
     
    //Definindo o c�digo de retorno
    cCodFull := cCodAux
     
    QRY_TAB->(DbCloseArea())
    RestArea(aArea)
Return cCodFull