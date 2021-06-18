#INCLUDE "Totvs.ch"

/*/{Protheus.doc} zLogi04
User Function
@type function
@version 
@author Caio Neves
@since 21/07/2020
@obs O tipo de User Function pode ser chamado em qualquer lugar do Protheus com
    o prefico U_, por exemplo U_zLogi04()
    MVC apenas 7 caracteres

    As nomenclaturas utilizadas geralmente são:
    AABBBXNN, onde
    AA - SIGLA DA EMPRESA
    BBB - MODULO DA FUNÇÃO
    X - TIPO(Atualização - Relatório - Miscelanea, JOB)
    NN - SEQUÊNCIA, por exemplo
    SPFATR07 -> Special Dog, FATuramento, Relatório, sequência 07

    Ou se for um fonte genérico de uma LIB por exemplo, iniciamos a função de usuário com a letra "z"

    Já as funções estáticas não tem limitação de tamanho(até 10)
    Para seguir um padrão, tentamos começar com elas utilizando a letra "f"
/*/
USER FUNCTION zLogi04()
    Local aArea := GetArea()

    //Mostrando mensagem de que está na USER FUNCTION
    MsgInfo("Estou na USER FUNCTION zLogi04", "Atenção")

    RestArea(aArea)
Return
