#INCLUDE "TOTVS.CH"


User Function zOper()
    Local aArea := GetArea()
    Local cNome := ""

    //Operador :=  ATRIBUIÇÃO
    cNome := 'Caio'
    cNome := cNome + " Neves "
    Alert(cNome)

    //Operador ; - Concatena Linha
    cNome := "Caio" +;
        " Neves"
    Alert(cNome)

    //Operador @ - Passagem de valor por referencia, alterando seu conteudo caso a variavel tenha alterações.
    cNome := ""
    cNome2 := ""
    fFuncao(cNome,@cNome2)
    Alert("cNome: " + cNome + CRLF + "cNome2: " + cNome2)

    //Operador $ - Contido dentro do conteúdo, case sensitive.
    If "A" $ 'CAIO'
        Alert("Letra A está contida em CAIO")
    Endif

    //Operador & - Macro Substituição - Substitui conteudo de uma variável.
    &("cNome := 'Terminal de Informação' ")
    Alert(cNome)

    /*//Operador : - Acessando uma classe
    //Após : e com () é um Método
    //Após : Sem ()  é um atributo

    oFont : TFont():New()
    oFOnt:Bold := .T.

    */

    //Operador == - Exatamente igual
    IF "DaNIEL" == "DANIEL"
        Alert("IGUAL")
    Else
        Alert("DIFERENTE")
    Endif
 
    //Operador ** ou ^ - Operador Matemático - Potenciação
    nVar := 5 ** 3
    Alert("5 ** 3 = " + cValToChar(nVar))

    //Operador * e *= - Multiplicação
    nVar := 2 * 5 
    Alert(nVar)
    nVar := 2
    nVar *= 5
    Alert(nVar)

    //Operador - e -= - SUBTRAÇÃO
    nVar := 2 - 5
    Alert(nVar)
    nVar := 2
    nVar -=5
    Alert(nVar)

    //Operador + e += - SOMA - Serve para textos
    nVar := 2 + 5
    Alert(nVar)
    nVar := 2
    nVar +=5
    Alert(nVar)

    cVar := 'CAIO' + " " + "NEVES"
    cVar := 'CAIO'
    cVar := 'NEVES'
    Alert(cVar)


    //Operador / e /= - DIVIDAO
    nVar := 10 / 5
    Alert(nVar)
    nVar := 10
    nVar /=5
    Alert(nVar)

    //Operador % - RESTO DE DIVISÃO
    nVar := 10 % 2
    Alert("Resto da divisão ( 10 / 2): " + cValToChar(nVar))
    nVar := 9 % 2 
    Alert("Resto da divisão (9 / 2): " + cValToChar(nVar))

    //Operador = - 
    If 5 = 10
        Alert('5 igual a 10')
    Endif
    If 'ZZZZ' = 'ZZZ'
        Alert('Valor Igual (Teste 1)')
    Endif
    If 'ZZZZ' == 'ZZZ'
        Alert('Valot igual (Teste 2)')
    Endif

    //Operador < e <= - Menor ou Menor igual a 
    If 10 < 100
        Alert("O valor 10 é menor que 100")
    Endif
    If "AAA" >= "ZZZ"
        Alert('AAA menor ou igual a ZZZ')
    Endif

    //Operador > ou >= - Maior ou Maior ou igual.
    If 100 > 10
        Alert('100 é maior do que 10')
    Endif
    If 'ZZZ' >= 'AAA'
        Alert('ZZZ maior ou igual AAA')
    Endif

    //Operador <> # != - DIFERENTE
    IF 1 <> 0
        Alert('1 é diferente de 0')
    Endif
    If 'CAIO' != 'NEVES'
        Alert('CAIO é diferente de NEVES')
    Endif
    
    //Operador ! .NOT. - Negação
    IF ! 1 == 1
        Alert('Caiu no IF')
    Else 
        Alert('Caiu no ELSE')
    Endif

    IF .NOT. 1 == 1
        Alert('Caiu no IF')
    Else 
        Alert('Caiu no ELSE')
    Endif

    //DEFAULT - DEFINE UM VALOR PADRÃO CASO VARIAVEL NAO TENHA CONTEUDO
    fFuncao()

    RestArea(aArea)    
Return

Static Function fFuncao(cVar1,cVar2)
    Default cVar1 := 'Teste'
    Default cVar2 := 'Teste 2'

    Alert('cVar1: ' + cVar1 + "cVar2: " + cVar2)


Return
