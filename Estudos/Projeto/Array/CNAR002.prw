#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
AADD() - PERMITE A INSERÇÃO DE UM ITEM EM UM ARRAY JA EXISTENTE.
AINS() - PERMITE A INSERÇÃO DE UM ELEMENTO EM QUALQUER POSIÇÃO DO ARRAY.
ACLONE() - REALIZA A COPIA DE UM ARRAY PARA OUTRO.
ADEL() - PERMITE A EXCLUSÃO DE UM ELEMENTO DO ARRAY, TORNANDO O ULTIMO VALOR.
ASIZE() - REDEFINE A ESTRUTURA DE UM ARRAY PRE-EXISTENTE, ADICIONANDO OU REMOVENDO
LEN() - REATONA A QUANTIDADE DE ELEMENTOS DE UM ARRAY.
*/

User Function CNAR002()
Local aVetor := {10,20,30}

Alert("O tamanho do Array é:" + cValToChar(Len(aVetor)))
MsgAlert("Posição 1 do Array é: " + cValToChar(aVetor[1]))
MsgAlert("Posição 2 do Array é: " + cValToChar(aVetor[2]))
MsgAlert("Posição 3 do Array é: " + cValToChar(aVetor[3]))

//ADICIONANDO VALOR JUNTO AO ARRAY aVetor
AADD(aVetor, 40)

Alert("O tamanho do Array após inclusão de novo valor é: " + cValToChar(Len(aVetor)))
MsgAlert("Posição 1 do Array é: "+ cValToChar(aVetor[1]))
MsgAlert("Posição 1 do Array é: "+ cValToChar(aVetor[2]))
MsgAlert("Posição 1 do Array é: "+ cValToChar(aVetor[3]))
MsgAlert("Posição 1 do Array é: "+ cValToChar(aVetor[4]))

/*ADICIONANDO ELEMENTO EM QUALQUER POSIÇÂO DO ARRAY
SE APENAS USAR A FUNÇÃO AINS COM A POSIÇÃO SERA
CRIADO UM DADO EM BRANCO.
*/
AINS(aVetor, 2)
aVetor[2] := 200
MsgAlert('Adicionado o valor ' + cValToChar(aVetor[2]) + 'junto a posição 2 do Array.')
Alert("O tamanho do Array após inclusão de novo valor é: " + cValToChar(Len(aVetor)))

//CLONANDO UM ARRAY
aVetor2 := ACLONE(aVetor)
    for nCount := 1 To Len (aVetor2)
        MsgAlert('Clonando valor do Array: '+ cValToChar(aVetor2[nCount]))
    Next nCount

Return
