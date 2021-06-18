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

    As nomenclaturas utilizadas geralmente s�o:
    AABBBXNN, onde
    AA - SIGLA DA EMPRESA
    BBB - MODULO DA FUN��O
    X - TIPO(Atualiza��o - Relat�rio - Miscelanea, JOB)
    NN - SEQU�NCIA, por exemplo
    SPFATR07 -> Special Dog, FATuramento, Relat�rio, sequ�ncia 07

    Ou se for um fonte gen�rico de uma LIB por exemplo, iniciamos a fun��o de usu�rio com a letra "z"

    J� as fun��es est�ticas n�o tem limita��o de tamanho(at� 10)
    Para seguir um padr�o, tentamos come�ar com elas utilizando a letra "f"
/*/
USER FUNCTION zLogi04()
    Local aArea := GetArea()

    //Mostrando mensagem de que est� na USER FUNCTION
    MsgInfo("Estou na USER FUNCTION zLogi04", "Aten��o")

    RestArea(aArea)
Return
