#INCLUDE "PROTHEUS.CH"

/*
                TIPOS DE DADOS
NUMERICO = 3 / 21.00 / 0.4 / 2000000
LOGICO = .T. / .F.
CARACTERE = "D" / 'C'
DATA = DATE()
ARRAY = {"VALOR01", "VALOR 02", "VALOR03"}
BLOCO DE CODIGO = {||VALOR := 1, MsgAlert ("Valor é igual a " +cValToChar(Valor))}

*/

User Function TDados()
    Local nNum := 66
    Local lLogic := .T.
    Local cCarac := "String"
    Local dData := Date()
    Local aArray := {"Caio", "Cesar","Pereira", "Neves"}
    Local bBloco := {|| nValor:= 2, MsgAlert("O numero é :" +cValToChar(nValor))}

    //APRESENTA ALERTA X
    Alert(nNum)
    Alert(lLogic)
    Alert(cValToChar(cCarac))
    Alert(dData)
    Alert(aArray[1])
    Alert(aArray[2])
    Alert(aArray[3])
    Eval(bBloco)

    //APFESENTA ICONE DE ESCLAMAÇÃO !
    MsgAlert(nNum)
    MsgAlert(lLogic)
    MsgAlert(cValToChar(cCarac))
    MsgAlert(dData)
    MsgAlert(aArray[1])
    MsgAlert(aArray[2])
    MsgAlert(aArray[3])
    
    // APRESENTA ICONE DE INFORMAçÂO
    MsgInfo(nNum)
    MsgInfo(lLogic)
    MsgInfo(cValToChar(cCarac))
    MsgInfo(dData)
    MsgInfo(aArray[1])
    MsgInfo(aArray[2])
    MsgInfo(aArray[3])
    
Return
