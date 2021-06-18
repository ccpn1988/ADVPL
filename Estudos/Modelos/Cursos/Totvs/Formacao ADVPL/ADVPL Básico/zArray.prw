#include 'protheus.ch'
#include 'parmtype.ch'
#define FUNCT_NOME 1
#define FUNCT_IDADE 2
#define FUNCT_CASADO 3


/*
AADD() 	 - PERMITE A INSERÇÃO DE UM ITEM EM UM ARRAY JA EXISTENTE.
AINS() 	 - PERMITE A INSERÇÃO DE UM ELEMENTO EM QUALQUER POSIÇÃO DO ARRAY
ACLONE() - REALIZA A COPIA DE UM ARRAY
ADEL() 	 - PERMITE A EXCLUSAO DE UM ELEMENTO DO ARRAY
ASIZE()  - REDEFINE A ESTRUTURA DE UM ARRAY
LEN()    - RETORNA A QUANTIDADE DE ELEMENTOS DO ARRAY.
*/
//INSERÇÃO DE UM ITEM EM UM ARRAY JA EXISTENTE.
User Function zArADD()
Local aVetor := {10,20,30}

	Alert(Len(aVetor))
//AADD(ARRAY,CONTEUDO)
	AADD(aVetor,40) //aVetor := {10,20,30,40}
	Alert(Len(aVetor))
	Alert(aVetor[4])	

Return

//INSERINDO DADOS NO ARRAY EM DETERMINADA POSIÇÂO
User Function zArINS()
Local aVetor := {10,20,30}
	
// AINS(ARRAY,POSIÇÃO)
	AINS(aVetor,2) 
	aVetor[2] := 200 //aVetor := {10,200,30}
	Alert(aVetor[2])	

Return

//COPIA DE ARRAY
User Function zArCL()
Local aVetor := {10,20,30}
//Local nCount 

	aVetor2 := aClone(aVetor)
		For nCount := 1 To Len(aVetor2)
			Alert(aVetor2[nCount])
		Next
			AADD(aVetor2,40)
			Alert(aVetor2[4])
Return
		
//EXCLUSÃO ELEMENTO ARRAY
User Function zArDel()
Local aVetor := {10,20,30}

	ADEL(aVetor,3)
	Alert(aVetor[3]) 	 //DELETADO
		
	Alert(Len(aVetor)) //MOSTRANDO O TAMANHO
	
	AINS(aVetor,3)		//ALTERANDO CONTEUDO
	aVetor[3] := 35	
	
	AADD(aVetor,40) 	//INCLUINDO 
	
	Alert(Len(aVetor))
	Alert(aVetor[4])
	Alert(aVetor[3])
	Alert(aVetor[2])
	Alert(aVetor[1])
	
Return

//REDEFINIR ESTRUTURAS REMOVENDO OU ADICIONANDO
User Function zArSIZ()
Local aVetor := {10,20,30}

	ASIZE(aVetor,4) //INSERIDO OUTRA ESTRUTURA
	Alert(Len(aVetor))
	
	AINS(aVetor,4) //INSERINDO CONTEUDO 
	aVetor[4] := 400
	
	Alert(Len(aVetor))
	Alert(aVetor[4])
	Alert(aVetor[3])
	Alert(aVetor[2])
	Alert(aVetor[1])
	
Return
/*Arrays ou matrizes, são coleções de valores, semelhantes a uma lista. Uma matriz pode ser
criada através de diferentes maneiras.
Cada item em um array é referenciado pela indicação de sua posição numérica na lista,
iniciando pelo número 1.
O exemplo a seguir declara uma variável, atribui um array de três elementos a ela, e então
exibe um dos elementos e o tamanho do array:*/


user function zArray()
	Local aLetras			  		   // Declaração da variável
	aletras := {"A","B", "C"}		  // Atribuição do array a variável
	Alert(aLetras[2])				 // Exibe o segundo elemento do array
	Alert(cValToChar(Len(aLetras))) // Exibe o tamanho do array
return

/*O ADVPL permite a manipulação de arrays facilmente. Enquanto que em outras linguagens
como C ou Pascal é necessário alocar memória para cada elemento de um array (o que
tornaria a utilização de "ponteiros" necessária), o ADVPL se encarrega de gerenciar a memória
e torna simples adicionar elementos a um array, utilizando a função AADD():*/

user function zArray2()
	Local aLetras			  		   // Declaração da variável
	aletras := {"A","B", "C"}		  // Atribuição do array a variável
	Alert(aLetras[2])				 // Exibe o segundo elemento do array
	Alert(cValToChar(Len(aLetras))) // Exibe o tamanho do array

	AADD(aLetras,"D") 			  // Adiciona o quarto elemento ao final do array
	Alert(aLetras[4]) 			 // Exibe o quarto elemento
	Alert(aLetras[5]) 			// Erro! Não há um quinto elemento no array
Return

/*Arrays como Estruturas

Uma característica interessante do ADVPL é que um array pode conter qualquer tipo de dado:
números, datas, lógicos, caracteres, objetos, etc., e ao mesmo tempo. Em outras palavras, os
elementos de um array não precisam ser necessariamente do mesmo tipo de dado, em
contraste com outras linguagens como C e Pascal.

Este array contem uma string, um número e um valor lógico. Em outras linguagens como C ou
Pascal, este "pacote" de informações pode ser chamado como um "struct" (estrutura em C, por
exemplo) ou um "record" (registro em Pascal, por exemplo). Como se fosse na verdade um
registro de um banco de dados, um pacote de informações construído com diversos campos.
Cada campo tendo um pedaço diferente de dado.*/

User Function zArrayS()
	Local aFunct1 
	aFunct1 := {"Pedro",32,.T.}
	Alert(cValToChar(Len(aFunct1)))
	Alert(aFunct1[1])
	Alert(aFunct1[2])
	Alert(aFunct1[3])
	
Return
	
/*Suponha que no exemplo anterior, o array aFunct1 contenha informações sobre o nome de
uma pessoa, sua idade e sua situação matrimonial. Os seguintes #defines podem ser criados
para indicar cada posição dos valores dentro de um array:	*/
	
User Function zArrayX()
	Local aFunct1 
	Local nCount
	aFunct1 := {"Pedro"		,32,.T.}
	aFunct2 := {"Maria" 	,22, .T.}
	aFunct3 := {"Antônio"	,42, .F.}
	
//aFuncts é um array com 3 linhas por 3 colunas. Uma vez que as variáveis separadas foram
//combinadas em um array, os nomes podem ser exibidos assim:
	
	aFuncts := {aFunct1, aFunct2, aFunct3}
	
/*//Que é equivalente a isso:
	aFuncts := { 	{"Pedro" , 32, .T.}, ;
					{"Maria" , 22, .T.}, ;
					{"Antônio", 42, .F.} }*/
	
   /*//IMPRESSÃO
	Alert(aFunct1[FUNCT_NOME]) //IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct2[FUNCT_NOME]) //IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct3[FUNCT_NOME]) //IMPRIME DE ACORDO COM #DEFINE
	
	Alert(aFunct1[FUNCT_IDADE])//IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct2[FUNCT_IDADE])//IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct3[FUNCT_IDADE])//IMPRIME DE ACORDO COM #DEFINE

	Alert(aFunct1[FUNCT_CASADO])//IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct2[FUNCT_CASADO])//IMPRIME DE ACORDO COM #DEFINE
	Alert(aFunct3[FUNCT_CASADO])//IMPRIME DE ACORDO COM #DEFINE
	*/
	
	//A variável nCount seleciona que funcionário (ou que linha) é de interesse. Então a constante
	//FUNCT_NOME seleciona a primeira coluna daquela linha.
	
	For nCount := 1 To Len(aFuncts)
	Alert(aFuncts[nCount, FUNCT_NOME])
		// aFuncts[nCount][FUNCT_NOME]	
	Next nCount
	
Return	

//Se o tamanho do array é conhecido
//Se o tamanho do array é conhecido no momento que o programa é escrito, há diversas
//maneiras de implementar o código:

//Este código preenche o array com uma tabela de quadrados. Os valores serão 1, 4, 9, 16 ...
//81, 100. Note que a linha 137 se refere à variável aX, mas poderia também trabalhar com aY ou
//aZ.

//O objetivo deste exemplo é demonstrar três modos de criar um array de tamanho conhecidoUser Function zArrayMD()
//no momento da criação do código. Local nCnt

//1. Na linha 138 o array é criada usando aX[10]. Isto indica ao ADVPL para alocar espaço Local aX[10]
//para 10 elementos no array. Os colchetes [ e ] são utilizados para indicar o tamanho Local aY := Array(10)
//necessário. Local aZ := {0,0,0,0,0,0,0,0,0,0}

//2. Na linha 139 é utilizada a função array com o parâmetro 10 para criar o array, e o
//retorno desta função é atribuído à variável aY. Na linha 142 é efetuado o que se chama For nCnt := 1 To 10
//"desenhar a imagen do array". Como se pode notar, existem dez 0´s na lista encerrada entre aX[nCnt] := nCnt * nCnt
//chaves ({}). Claramente, este método não é o utilizado para criar uma matriz de 1000 Next nCnt
//elementos.

//3. O terceiro método difere dos anteriores porque inicializa a matriz com os valores
//definitivos. Nos dois primeiros métodos, cada posição da matriz contém um valor nulo (Nil) e
//deve ser inicializado posteriormente.

//4. A linha 143 demonstra como um valor pode ser atribuído para uma posição existente em
//uma matriz especificando o índice entre colchetes.


User Function zArrayMD()
 Local nCnt
 Local aX[10]
 Local aY := Array(10)
 Local aZ := {0,0,0,0,0,0,0,0,0,0}

 For nCnt := 1 To 10
 aX[nCnt] := nCnt * nCnt
 	Alert(aX[nCnt])//IMPRIME TODOS OS ITENS DO ARRAY aX
 	
 Next nCnt
 
//Se o tamanho do array não é conhecido
//Se o tamanho do array não é conhecido até o momento da execução do programa, há algumas
//maneiras de criar um array e adicionar elementos a ele. O exemplo a seguir ilustra a idéia de
//criação de um array vazio (sem nenhum elemento) e adição de elementos dinamicamente.

//1. A linha 169 utiliza os colchetes para criar um array vazio. Apesar de não ter nenhum
//elemento, seu tipo de dado é array.

//2. Na linha 170 a chamada da função array cria uma matriz sem nenhum elemento.

//3. Na linha 171 está declarada a representação de um array vazio em ADVPL. Mais uma
//vez, estão sendo utilizadas as chaves para indicar que o tipo de dados da variável é array.
//Note que {} é um array vazio (tem o tamanho 0), enquanto {Nil} é um array com um único
//elemento nulo (tem tamanho 1).

//Porque cada uma destes arrays não contém elementos, a linha 174 utiliza a função AADD() para
//adicionar elementos sucessivamente até o tamanho necessário (especificado por exemplo na
//variável nSize).

/*User Function zArrayM2()
Local nCnt
Local aX[0] 			//criar um array vazio
Local aY := Array(0) 	// a chamada da função array cria uma matriz sem nenhum elemento.
Local aZ := {}			//declarada a representação de um array vazio em ADVPL.
Local nSize := 10

	For nCnt := 1 TO nSize
	AADD(aX, nCnt*nCnt)
	Next nCnt
		Alert(aX[nCnt])//IMPRIME TODOS OS ITENS DO ARRAY aX
		
	
Return*/

//6.1.3. Cópia de arrays
//Para “copiar” o conteúdo de uma variável, utiliza-se o operador de atribuição “:=”, conforme abaixo:

/*nPessoas := 10 
nAlunos := nPessoas*/

//Ao executar a atribuição de nAlunos com o conteúdo de nPessoas, o conteúdo de nPessoas é
//atribuído a variável nAlunos, causando o efeito de cópia do conteúdo de uma variável para outra.

//Como foi copiado o “mapa” e não as informações, qualquer ação utilizando o rótulo aAlunos irá
//afetar as informações do rótulo aPessoas. Com isso ao invés de se obter dois arrays distintos,
//tem-se o mesmo array com duas formas de acesso (rótulos) diferentes.

User Function zArrcop()
	Local aPessoas := {"Ricardo","Cristiane","André","Camila"}
	
	aAlunos := aPessoas
	
	Alert(aAlunos[2])

Return

User Function zArRCTI()
	Local dData := Date()
	Local aValores := {"Caio",dData,100}
	
	Alert(aValores[2])
	Alert(aValores[1])
	Alert(aValores[3])
	
Return


