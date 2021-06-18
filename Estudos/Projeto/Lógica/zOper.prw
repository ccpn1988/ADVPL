#INCLUDE "TOTVS.CH"


User Function zOper()
    Local aArea := GetArea()
    Local cNome := ""

    //Operador :=  ATRIBUI��O
    cNome := 'Caio'
    cNome := cNome + " Neves "
    Alert(cNome)

    //Operador ; - Concatena Linha
    cNome := "Caio" +;
        " Neves"
    Alert(cNome)

    //Operador @ - Passagem de valor por referencia, alterando seu conteudo caso a variavel tenha altera��es.
    cNome := ""
    cNome2 := ""
    fFuncao(cNome,@cNome2)
    Alert("cNome: " + cNome + CRLF + "cNome2: " + cNome2)

    //Operador $ - Contido dentro do conte�do, case sensitive.
    If "A" $ 'CAIO'
        Alert("Letra A est� contida em CAIO")
    Endif

    //Operador & - Macro Substitui��o - Substitui conteudo de uma vari�vel.
    &("cNome := 'Terminal de Informa��o' ")
    Alert(cNome)

    /*//Operador : - Acessando uma classe
    //Ap�s : e com () � um M�todo
    //Ap�s : Sem ()  � um atributo

    oFont : TFont():New()
    oFOnt:Bold := .T.

    */

    //Operador == - Exatamente igual
    IF "DaNIEL" == "DANIEL"
        Alert("IGUAL")
    Else
        Alert("DIFERENTE")
    Endif
 
    //Operador ** ou ^ - Operador Matem�tico - Potencia��o
    nVar := 5 ** 3
    Alert("5 ** 3 = " + cValToChar(nVar))

    //Operador * e *= - Multiplica��o
    nVar := 2 * 5 
    Alert(nVar)
    nVar := 2
    nVar *= 5
    Alert(nVar)

    //Operador - e -= - SUBTRA��O
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

    //Operador % - RESTO DE DIVIS�O
    nVar := 10 % 2
    Alert("Resto da divis�o ( 10 / 2): " + cValToChar(nVar))
    nVar := 9 % 2 
    Alert("Resto da divis�o (9 / 2): " + cValToChar(nVar))

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
        Alert("O valor 10 � menor que 100")
    Endif
    If "AAA" >= "ZZZ"
        Alert('AAA menor ou igual a ZZZ')
    Endif

    //Operador > ou >= - Maior ou Maior ou igual.
    If 100 > 10
        Alert('100 � maior do que 10')
    Endif
    If 'ZZZ' >= 'AAA'
        Alert('ZZZ maior ou igual AAA')
    Endif

    //Operador <> # != - DIFERENTE
    IF 1 <> 0
        Alert('1 � diferente de 0')
    Endif
    If 'CAIO' != 'NEVES'
        Alert('CAIO � diferente de NEVES')
    Endif
    
    //Operador ! .NOT. - Nega��o
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

    //DEFAULT - DEFINE UM VALOR PADR�O CASO VARIAVEL NAO TENHA CONTEUDO
    fFuncao()

    RestArea(aArea)    
Return

Static Function fFuncao(cVar1,cVar2)
    Default cVar1 := 'Teste'
    Default cVar2 := 'Teste 2'

    Alert('cVar1: ' + cVar1 + "cVar2: " + cVar2)


Return
