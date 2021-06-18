
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

User function UPDRPA()

If MsgYesNo("Confirmar execução do compatibilizador?")
    Processa({|| CompDici() },"Compatibilizando dicionario","Aguarde.. estamos realizando a compatibilização do dicionario de dados!",.F.)
    MsgInfo("Processo finaliazado.. verifique o arquivo de log x31updtable.log")
EndIf    

Return nil

Static Function CompDici()
Local cMensagem := ""
Local nAux      := 0
Local aTab      := {}


 Aadd(aTab,'SC5')
// Aadd(aTab,'SZ4')
// Aadd(aTab,'ZZC')
// Aadd(aTab,'ZZF')
 //Aadd(aTab,'ZZJ')
// Aadd(aTab,'ZZL')
// Aadd(aTab,'ZZN')
// Aadd(aTab,'ZZR')
// Aadd(aTab,'ZZT')
// Aadd(aTab,'ZZF')
// Aadd(aTab,'ZZD')
// Aadd(aTab,'ZZP')
// Aadd(aTab,'ZZQ')
// Aadd(aTab,'ZZT')
// Aadd(aTab,'ZZL')
// Aadd(aTab,'CN9')

ProcRegua(Len(aTab)+1)

IncProc("Abrindo empresa")
Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

//Bloqueia alterações no Dicionário
__SetX31Mode(.F.)

For nAux := 1 To Len(aTab)

    IncProc("Processando tabela "+aTab[nAux]+"...")

    //DbSelectArea(aTab[nAux])
    //(aTab[nAux])->(DbCloseArea())
    X31UpdTable(aTab[nAux])

    //Se houve Erro na Rotina
    If __GetX31Error()
        cMensagem +=  " Houveram erros na atualização da tabela "+aTab[nAux]+"."+chr(13)+chr(10)
        COnout(" Houveram erros na atualização da tabela "+aTab[nAux] +".")
        cMensagem += __GetX31Trace() +chr(13)+chr(10)
    Else
        //Abrindo a tabela para criar dados no sql
        DbSelectArea(aTab[nAux])
/*
        IF !(aTab[nAux] $ "CTT$SZ1$SZ4")
            If !(aTab[nAux])->(Dbseek( xFilial(aTab[nAux]) ))
                IF (aTab[nAux])->(FieldPos(aTab[nAux]+"_FILIAL"))  > 0
                    Reclock(aTab[nAux],.T.)
                    (aTab[nAux])->(aTab[nAux]+"_FILIAL") := xFilial(aTab[nAux])
                    MsUnLock()
                EndIF
            EndIF        
        EndIF
*/
        cMensagem +=  " Realizada geração da tabela "+aTab[nAux] +"."+chr(13)+chr(10)
        COnout(" Realizada geração da tabela "+aTab[nAux]+".")
        (aTab[nAux])->(DbCloseArea())
    EndIf
Next

//Desbloqueando alterações no dicionário
__SetX31Mode(.T.)

MemoWrite('c:\temp\x31updtable.log', cMensagem )
ShellExecute("Open", 'c:\temp\x31updtable.log', "", 'c:\temp\', 1 )

Reset Environment

Return nil