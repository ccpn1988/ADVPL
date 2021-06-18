#include 'protheus.ch'
#include 'parmtype.ch'
#define FUNCT_NOME 1
#define FUNCT_IDADE 2
#define FUNCT_CASADO 3


/*
AADD() 	 - PERMITE A INSER��O DE UM ITEM EM UM ARRAY JA EXISTENTE.
AINS() 	 - PERMITE A INSER��O DE UM ELEMENTO EM QUALQUER POSI��O DO ARRAY
ACLONE() - REALIZA A COPIA DE UM ARRAY
ADEL() 	 - PERMITE A EXCLUSAO DE UM ELEMENTO DO ARRAY
ASIZE()  - REDEFINE A ESTRUTURA DE UM ARRAY
LEN()    - RETORNA A QUANTIDADE DE ELEMENTOS DO ARRAY.
*/
//INSER��O DE UM ITEM EM UM ARRAY JA EXISTENTE.
User Function zArADD()
Local aVetor := {10,20,30}

	Alert(Len(aVetor))
//AADD(ARRAY,CONTEUDO)
	AADD(aVetor,40) //aVetor := {10,20,30,40}
	Alert(Len(aVetor))
	Alert(aVetor[4])	

Return

//INSERINDO DADOS NO ARRAY EM DETERMINADA POSI��O
User Function zArINS()
Local aVetor := {10,20,30}
	
// AINS(ARRAY,POSI��O)
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
		
//EXCLUS�O ELEMENTO ARRAY
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
/*Arrays ou matrizes, s�o cole��es de valores, semelhantes a uma lista. Uma matriz pode ser
criada atrav�s de diferentes maneiras.
Cada item em um array � referenciado pela indica��o de sua posi��o num�rica na lista,
iniciando pelo n�mero 1.
O exemplo a seguir declara uma vari�vel, atribui um array de tr�s elementos a ela, e ent�o
exibe um dos elementos e o tamanho do array:*/


user function zArray()
	Local aLetras			  		   // Declara��o da vari�vel
	aletras := {"A","B", "C"}		  // Atribui��o do array a vari�vel
	Alert(aLetras[2])				 // Exibe o segundo elemento do array
	Alert(cValToChar(Len(aLetras))) // Exibe o tamanho do array
return

/*O ADVPL permite a manipula��o de arrays facilmente. Enquanto que em outras linguagens
como C ou Pascal � necess�rio alocar mem�ria para cada elemento de um array (o que
tornaria a utiliza��o de "ponteiros" necess�ria), o ADVPL se encarrega de gerenciar a mem�ria
e torna simples adicionar elementos a um array, utilizando a fun��o AADD():*/

user function zArray2()
	Local aLetras			  		   // Declara��o da vari�vel
	aletras := {"A","B", "C"}		  // Atribui��o do array a vari�vel
	Alert(aLetras[2])				 // Exibe o segundo elemento do array
	Alert(cValToChar(Len(aLetras))) // Exibe o tamanho do array

	AADD(aLetras,"D") 			  // Adiciona o quarto elemento ao final do array
	Alert(aLetras[4]) 			 // Exibe o quarto elemento
	Alert(aLetras[5]) 			// Erro! N�o h� um quinto elemento no array
Return

/*Arrays como Estruturas

Uma caracter�stica interessante do ADVPL � que um array pode conter qualquer tipo de dado:
n�meros, datas, l�gicos, caracteres, objetos, etc., e ao mesmo tempo. Em outras palavras, os
elementos de um array n�o precisam ser necessariamente do mesmo tipo de dado, em
contraste com outras linguagens como C e Pascal.

Este array contem uma string, um n�mero e um valor l�gico. Em outras linguagens como C ou
Pascal, este "pacote" de informa��es pode ser chamado como um "struct" (estrutura em C, por
exemplo) ou um "record" (registro em Pascal, por exemplo). Como se fosse na verdade um
registro de um banco de dados, um pacote de informa��es constru�do com diversos campos.
Cada campo tendo um peda�o diferente de dado.*/

User Function zArrayS()
	Local aFunct1 
	aFunct1 := {"Pedro",32,.T.}
	Alert(cValToChar(Len(aFunct1)))
	Alert(aFunct1[1])
	Alert(aFunct1[2])
	Alert(aFunct1[3])
	
Return
	
/*Suponha que no exemplo anterior, o array aFunct1 contenha informa��es sobre o nome de
uma pessoa, sua idade e sua situa��o matrimonial. Os seguintes #defines podem ser criados
para indicar cada posi��o dos valores dentro de um array:	*/
	
User Function zArrayX()
	Local aFunct1 
	Local nCount
	aFunct1 := {"Pedro"		,32,.T.}
	aFunct2 := {"Maria" 	,22, .T.}
	aFunct3 := {"Ant�nio"	,42, .F.}
	
//aFuncts � um array com 3 linhas por 3 colunas. Uma vez que as vari�veis separadas foram
//combinadas em um array, os nomes podem ser exibidos assim:
	
	aFuncts := {aFunct1, aFunct2, aFunct3}
	
/*//Que � equivalente a isso:
	aFuncts := { 	{"Pedro" , 32, .T.}, ;
					{"Maria" , 22, .T.}, ;
					{"Ant�nio", 42, .F.} }*/
	
   /*//IMPRESS�O
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
	
	//A vari�vel nCount seleciona que funcion�rio (ou que linha) � de interesse. Ent�o a constante
	//FUNCT_NOME seleciona a primeira coluna daquela linha.
	
	For nCount := 1 To Len(aFuncts)
	Alert(aFuncts[nCount, FUNCT_NOME])
		// aFuncts[nCount][FUNCT_NOME]	
	Next nCount
	
Return	

//Se o tamanho do array � conhecido
//Se o tamanho do array � conhecido no momento que o programa � escrito, h� diversas
//maneiras de implementar o c�digo:

//Este c�digo preenche o array com uma tabela de quadrados. Os valores ser�o 1, 4, 9, 16 ...
//81, 100. Note que a linha 137 se refere � vari�vel aX, mas poderia tamb�m trabalhar com aY ou
//aZ.

//O objetivo deste exemplo � demonstrar tr�s modos de criar um array de tamanho conhecidoUser Function zArrayMD()
//no momento da cria��o do c�digo. Local nCnt

//1. Na linha 138 o array � criada usando aX[10]. Isto indica ao ADVPL para alocar espa�o Local aX[10]
//para 10 elementos no array. Os colchetes [ e ] s�o utilizados para indicar o tamanho Local aY := Array(10)
//necess�rio. Local aZ := {0,0,0,0,0,0,0,0,0,0}

//2. Na linha 139 � utilizada a fun��o array com o par�metro 10 para criar o array, e o
//retorno desta fun��o � atribu�do � vari�vel aY. Na linha 142 � efetuado o que se chama For nCnt := 1 To 10
//"desenhar a imagen do array". Como se pode notar, existem dez 0�s na lista encerrada entre aX[nCnt] := nCnt * nCnt
//chaves ({}). Claramente, este m�todo n�o � o utilizado para criar uma matriz de 1000 Next nCnt
//elementos.

//3. O terceiro m�todo difere dos anteriores porque inicializa a matriz com os valores
//definitivos. Nos dois primeiros m�todos, cada posi��o da matriz cont�m um valor nulo (Nil) e
//deve ser inicializado posteriormente.

//4. A linha 143 demonstra como um valor pode ser atribu�do para uma posi��o existente em
//uma matriz especificando o �ndice entre colchetes.


User Function zArrayMD()
 Local nCnt
 Local aX[10]
 Local aY := Array(10)
 Local aZ := {0,0,0,0,0,0,0,0,0,0}

 For nCnt := 1 To 10
 aX[nCnt] := nCnt * nCnt
 	Alert(aX[nCnt])//IMPRIME TODOS OS ITENS DO ARRAY aX
 	
 Next nCnt
 
//Se o tamanho do array n�o � conhecido
//Se o tamanho do array n�o � conhecido at� o momento da execu��o do programa, h� algumas
//maneiras de criar um array e adicionar elementos a ele. O exemplo a seguir ilustra a id�ia de
//cria��o de um array vazio (sem nenhum elemento) e adi��o de elementos dinamicamente.

//1. A linha 169 utiliza os colchetes para criar um array vazio. Apesar de n�o ter nenhum
//elemento, seu tipo de dado � array.

//2. Na linha 170 a chamada da fun��o array cria uma matriz sem nenhum elemento.

//3. Na linha 171 est� declarada a representa��o de um array vazio em ADVPL. Mais uma
//vez, est�o sendo utilizadas as chaves para indicar que o tipo de dados da vari�vel � array.
//Note que {} � um array vazio (tem o tamanho 0), enquanto {Nil} � um array com um �nico
//elemento nulo (tem tamanho 1).

//Porque cada uma destes arrays n�o cont�m elementos, a linha 174 utiliza a fun��o AADD() para
//adicionar elementos sucessivamente at� o tamanho necess�rio (especificado por exemplo na
//vari�vel nSize).

/*User Function zArrayM2()
Local nCnt
Local aX[0] 			//criar um array vazio
Local aY := Array(0) 	// a chamada da fun��o array cria uma matriz sem nenhum elemento.
Local aZ := {}			//declarada a representa��o de um array vazio em ADVPL.
Local nSize := 10

	For nCnt := 1 TO nSize
	AADD(aX, nCnt*nCnt)
	Next nCnt
		Alert(aX[nCnt])//IMPRIME TODOS OS ITENS DO ARRAY aX
		
	
Return*/

//6.1.3. C�pia de arrays
//Para �copiar� o conte�do de uma vari�vel, utiliza-se o operador de atribui��o �:=�, conforme abaixo:

/*nPessoas := 10 
nAlunos := nPessoas*/

//Ao executar a atribui��o de nAlunos com o conte�do de nPessoas, o conte�do de nPessoas �
//atribu�do a vari�vel nAlunos, causando o efeito de c�pia do conte�do de uma vari�vel para outra.

//Como foi copiado o �mapa� e n�o as informa��es, qualquer a��o utilizando o r�tulo aAlunos ir�
//afetar as informa��es do r�tulo aPessoas. Com isso ao inv�s de se obter dois arrays distintos,
//tem-se o mesmo array com duas formas de acesso (r�tulos) diferentes.

User Function zArrcop()
	Local aPessoas := {"Ricardo","Cristiane","Andr�","Camila"}
	
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


