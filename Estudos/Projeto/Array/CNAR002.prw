#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
AADD() - PERMITE A INSER��O DE UM ITEM EM UM ARRAY JA EXISTENTE.
AINS() - PERMITE A INSER��O DE UM ELEMENTO EM QUALQUER POSI��O DO ARRAY.
ACLONE() - REALIZA A COPIA DE UM ARRAY PARA OUTRO.
ADEL() - PERMITE A EXCLUS�O DE UM ELEMENTO DO ARRAY, TORNANDO O ULTIMO VALOR.
ASIZE() - REDEFINE A ESTRUTURA DE UM ARRAY PRE-EXISTENTE, ADICIONANDO OU REMOVENDO
LEN() - REATONA A QUANTIDADE DE ELEMENTOS DE UM ARRAY.
*/

User Function CNAR002()
Local aVetor := {10,20,30}

Alert("O tamanho do Array �:" + cValToChar(Len(aVetor)))
MsgAlert("Posi��o 1 do Array �: " + cValToChar(aVetor[1]))
MsgAlert("Posi��o 2 do Array �: " + cValToChar(aVetor[2]))
MsgAlert("Posi��o 3 do Array �: " + cValToChar(aVetor[3]))

//ADICIONANDO VALOR JUNTO AO ARRAY aVetor
AADD(aVetor, 40)

Alert("O tamanho do Array ap�s inclus�o de novo valor �: " + cValToChar(Len(aVetor)))
MsgAlert("Posi��o 1 do Array �: "+ cValToChar(aVetor[1]))
MsgAlert("Posi��o 1 do Array �: "+ cValToChar(aVetor[2]))
MsgAlert("Posi��o 1 do Array �: "+ cValToChar(aVetor[3]))
MsgAlert("Posi��o 1 do Array �: "+ cValToChar(aVetor[4]))

/*ADICIONANDO ELEMENTO EM QUALQUER POSI��O DO ARRAY
SE APENAS USAR A FUN��O AINS COM A POSI��O SERA
CRIADO UM DADO EM BRANCO.
*/
AINS(aVetor, 2)
aVetor[2] := 200
MsgAlert('Adicionado o valor ' + cValToChar(aVetor[2]) + 'junto a posi��o 2 do Array.')
Alert("O tamanho do Array ap�s inclus�o de novo valor �: " + cValToChar(Len(aVetor)))

//CLONANDO UM ARRAY
aVetor2 := ACLONE(aVetor)
    for nCount := 1 To Len (aVetor2)
        MsgAlert('Clonando valor do Array: '+ cValToChar(aVetor2[nCount]))
    Next nCount

Return
