#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} User Function zVariaveis
    Escopo de Variaveis
    @type  Function
    @author user
    @since 03/08/2020
    @version 2.0

    /*/
User Function zVariaveis()
    Local aArea     := GetArea()

    //Declara��o de Variaveis
    Local nValor    := 0
    Local dData     := Date()
    Local lTeste    := .T.
    Local cTexto    := "Terminal de Informa��o"
    Local oObjeto   := TFont():New('Tahoma')
    Local xInfo     := 0
    Local aDados    := {"Daniel", "Caio", dData}
    Local bBloco1   := {||  nValor := 1,;
                            Alert("Valor � igual a : "+cValToChar(nValor))}
    Local bBloco2   := {|nValor| nValor += 2,;
                                 Alert("Valor � igual a "+cValToChar(nValor))}

    //Executando bloco de c�digo
    Eval(bBloco1)
    Eval(bBloco2,5)

    //ALterando valor
    xInfo   := "Teste"

    RestArea(aArea)

        
Return 
