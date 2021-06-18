
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

User function UPDCARGA()

RecargaObra()
//CompDici()

Return nil

Static Function RecargaObra()

Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

DbSelectarea("ZZL")
ZZL->(DbSetOrder(1))

IF select("TMP_CARGA") > 0
    TMP_CARGA->(DbcloseArea())
EndIf

BEGINSQL ALIAS "TMP_CARGA"
    SELECT ZZL_COD FROM ZZL000
    WHERE ZZL_DTALTE >= '20200127'
    AND D_E_L_E_T_ <> '*'
ENDSQL

while TMP_CARGA->(!EOF())

    IF ZZL->(DbSeek( xFilial("ZZL")+TMP_CARGA->ZZL_COD ))
        StaticCall(GENCAZZL,AtuSB1)
    ENDIF

    TMP_CARGA->(DbSkip())
end

TMP_CARGA->(DbCloseArea())

Reset Environment

Return nil

Static Function CompDici()
Local cMensagem := ""
Local nAux      := 0
Local aTab      := {}


//Aadd(aTab,"CTT")
//Aadd(aTab,"SZ1")
//Aadd(aTab,"SZ4")
//Aadd(aTab,'ZZC')
//Aadd(aTab,'ZZL')

Aadd(aTab,'ZZH')
/*
Aadd(aTab,'ZZJ')
Aadd(aTab,'ZZI')
Aadd(aTab,'ZZW')
Aadd(aTab,'ZZX')
Aadd(aTab,'ZZY')
Aadd(aTab,'ZZA')
Aadd(aTab,'ZZO')
Aadd(aTab,'ZZN')
Aadd(aTab,'ZZM')
Aadd(aTab,'ZZV')
Aadd(aTab,'ZZU')
Aadd(aTab,'ZZT')
Aadd(aTab,'ZZS')
Aadd(aTab,'ZZR')
Aadd(aTab,'ZZQ')
Aadd(aTab,'ZZP')
*/

Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

//Bloqueia alterações no Dicionário
__SetX31Mode(.F.)

For nAux := 1 To Len(aTab)
    DbSelectArea(aTab[nAux])
    (aTab[nAux])->(DbCloseArea())
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