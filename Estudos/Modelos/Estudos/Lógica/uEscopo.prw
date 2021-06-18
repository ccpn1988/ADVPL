#INCLUDE 'Protheus.ch'

/*
ESCOPO DE VARIAVEIS
LOCAL  := VISIVEL EM QUALQUER LUGAR DO FONTE DECLARADO
STATIC := SE DECLARADA FORA DA FUNÇÃO PODE SER USADA EM QUALQUER PARTE DO FONTE
PRIVATE:= VISIVEL EM TODO O PROGRAMA AO QUAL FOI DECLARADO, PODENDO SER CHAMADO POR OUTRAS FUNÇÕES
PUBLIC :=  VISIVEL EM TODO O PROGRAMA/SISTEMA
*/

USER FUNCTION uEscopo()
    Local aArea := GetArea()
    
        //VARIAVEIS LOCAIS
        Local nVar01 := 5
        Local nVar02 := 8
        Local nVar03 := 10

        //VARIAVEIS PRIVATES
        Private cTst := 'Teste PVT'
        cTst2 := 'Teste Pvt2'

        //VARIAVEIS PUBLICAS
        Public __cTeste := 'CAIO'
        Public __cTeste2 := 'NEVES'

        //CHAMANDO OUTRA ROTINA PARA DEMONSTRAR ESCOPO DE VARIAVEIS
        fEscopo(nVar01,@nVar02)

        Alert(nVar02)
        Alert("Public: "+ __cTeste + " " + __cTeste2)
    RestArea(aArea)

RETURN

STATIC FUNCTION fEscopo(nValor1, nValor2, nValor3)
    Local aArea := GetArea()

    Local __cTeste2 := 'TESTE2'

    //VALORES DEFAULT
    Default nValor1 := 0
    Default nValor2 := 0
    Default nValor3 := 0

    //ALTERANDO nVALOR2
    nValor2 += 10

    //MOSTRANDO VARIAVEL PRIVATE
    Alert("Private: "+cTst2)

    //ALTERANDO CONTEUDO VARIAVEL PUBLICA
    __cTeste := 'Teste1'

    RestArea(aArea)

RETURN

STATIC cStat := ''

USER FUNCTION uVar()
    Local aArea := GetArea()
    Local nVar := 10
    Local nVar1 := 20
    Private cPri := 'Private'
    Public __cPublic := 'CNEVES'

    Alert(nVar1)

    uTSTESC(nVar, @nVar1)

    Alert(nVar1)
    Alert(__cPublic)
    Alert(cPri)

    RestArea(aArea)
RETURN

STATIC FUNCTION uTSTESC(nValor1, nValor2)
    Local aArea := GetArea()
    Local __cPublic := 'Alterei'
    
    Default nValor1 := 0

    nValor2 := 10

    Alert(nValor2)
    Alert(__cPublic)
    Alert(cPri)

    RestArea(aArea)

RETURN