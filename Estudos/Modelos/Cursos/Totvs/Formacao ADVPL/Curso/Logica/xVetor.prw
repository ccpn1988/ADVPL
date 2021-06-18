#Include 'Protheus.ch'

User Function xVetor()
Local aVetor  := {}
Local aVetor2 := {"A","S","D","F","G","H","J","K","L","Ç","P","O","I","U","Y","T","R","E","W","Q",;
				  "Z","X","C","V","B","N","M"}
Local aVetor3 := Array(3) // Cria 3 colunas no vetor com valor NIL

aVetor3[1] := "Segunda"
aVetor3[2] := "Terça"
aVetor3[3] := "Quarta"
aAdd(aVetor3, "Quinta")
aAdd(aVetor3, "Sexta" )
aAdd(aVetor3, "Sabado")

//Exercicio - fazer um for para listar todos os elementos da variavel aVetor3

For x:= 1 To Len(aVetor3) // Seta a variavel x para 1 e o contador Len no Vetor para contar as quantidades
	                      // de colunas presentes no vetor
	MSgInfo(aVetor3[x])
Next

MsgInfo("Fim do primeiro For")

// Exercicio - retorna indice do conteudo sexta
For x:=1 To Len(aVetor3)
	If aVetor3[x] == "Sexta"
	   Exit
	EndIf
Next

// Ou pode ser feito com a função nativa aScan

x:= aScan(aVetor3, "Sexta")
	
	MsgInfo("Conteudo do indice: " + cValToChar(x) + " = " + aVetor3[x])

MsgInfo("Fim do segundo For")

For x:= 1 To Len(aVetor2)
	MsgInfo(aVetor2[x])
Next


//----------------------------------------------------------------------------------------------------------------------------------------------------



aSort(aVetor2) // Ordena o array em ordem alfabetica

For x:=1 To Len(aVetor2)
	MsgInfo(aVetor2[x])
Next

aSort(aVetor2,,,{|y,z| y > z})// Ordena o array em ordem decrescente. Informar o vetor, depois informar
                              // 3 virgulas para chegar no campo e informar os parametros para comparação
                              // e quem vai informar para exibir a ordem decrescente é o sinal de >.

For x:=1 To Len(aVetor2)
	MsgInfo(aVetor2[x])
Next

MsgInfo("Fim do terceiro For")

Return


//------------------------------------------------------------------------------------------------------------------------------------------------------]

#Include 'Protheus.ch'

User Function aVetor()


Local dData := Date()
Local aValores :={"Joao", dData, 100}

Alert (aValores[2]) //Exibe a posição do Array 2 posição
Alert (aValores [3])

Return
//FUNÇÕES DE MANIPULAÇÂO-------------------------------------------------------------------------------------------------------------------------------------------------------


#Include 'Protheus.ch'

User Function aVetor1()

//AADD() - PERMITE A INSERÇÃO DE UM ITEM EM UM ARRAY JÁ EXISTENTE
//AINS() - PERMITE A INSERÇÃO DE UM ELEMENTO EM QUALQUER POSIÇÃO DO ARRAY
//ACLONE() - REALIZA A CÓPIA DE UM ARRAY PARA OUTRO
//ADEL() - PERMITE A EXCLUSÃO DE UM ELEMENTO DO ARRAY
//ASIZE() - REDEFINE A ESTRUTURA DE UM ARRAY PRE=EXISTENTE
//LEN() - RETORNA A QUANTIDADE D ELEMENTOS DE UM ARRAY

Local aVetor := {10,20,30}

AADD(aVetor, 40)
Alert (len (aVetor))

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
#Include 'Protheus.ch'

User Function aVetor2()

Local aVetor := {10,20,30}

AINS (aVetor, 2)

aVetor [2] := 200

Alert (aVetor[2])

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
#Include 'Protheus.ch' // EFETUA O CLONE DO ARRAY E EXIBE OS VALORES

User Function aVetor3()

Local aVetor := {10,20,30}

aVetor2 := AClone(aVetor)

for nCount := 1 To Len (aVetor2)

Alert (aVetor2[nCount])

Next nCount

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
#Include 'Protheus.ch' // EXCLUSAO DE ELEMENTO DO ARRAY TORNANDO NULO O ITEM DELETADO

User Function aVetor4()

Local aVetor := {10,20,30}

aDel (aVetor, 2)
Alert (aVetor[3])
Alert (len(aVetor))

Return

//------------------------------------------------------------------------------------------------------------------------------------------------------
#Include 'Protheus.ch' // REDEFINIÇÃO DO TAMANHO DO VETOR EXCLUINDO SEMPRE O ULTIMO BLOCO

User Function aVetor5()

Local aVetor := {10,20,30}

Asize (aVetor,2)
Alert (len(aVetor))

Return