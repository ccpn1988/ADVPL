#Include 'Protheus.ch'

User Function xMatriz()
Local aNome    := Array(3,1) // Define a forma da matriz, com 3 linhas e 1 coluna
Local aMatriz  := {} // Define a matriz vazia
Local aExemplo := {{"Teste"  , Time(), Date()},;
	               {"Teste02", Date(), Time()}}

aAdd ( aMatriz, {"Maria"   , 63, "F"} ) // Adiciona os dados a matriz
aAdd ( aMatriz, {"Ana"     , 23, "F"} )
aAdd ( aMatriz, {"Antonio" , 24, "M"} )
aAdd ( aMatriz, {"Marcio"  , 29, "M"} )
aAdd ( aMatriz, {"Fernando", 20, "M"} )
aAdd ( aMatriz, {"Felipe"  , 19, "M"} )
aAdd ( aMatriz, {"Eduardo" , 32, "M"} )

// Exercicio fazer um FOR para listar os dados da variavel aMatriz

For x:=1 To Len(aMatriz) // Conta quantas linhas tem a matriz com o Len (7 linhas)
	For y:=1 To Len(aMatriz[x]) // Conta quantas colunas tem a matriz com o Len, e necessita informar a variavel que conta as linhas aMatriz[x]
	MsgInfo(aMatriz[x,y]) // Exibe os dados da aMatriz
	Next y // Pula para a proxima coluna
Next x // Pula para a proxima linha

// ou fazer da seguindo maneira

For x:=1 To Len(aMatriz) 
	
	MsgInfo("Nome: " + aMatriz[x,1] + CRLF + ; //CRLF - Pula a linha da matriz (ou funciona como o ENTER)
	        "Idade: " + cValToChar(aMatriz[x,2]) + CRLF + ;
	        "Sexo: " + IIF(aMatriz[x,3]=="M","Masculino","Feminino") ) 
Next x

// Informa o nome da pessoa que tem 20 anos

For x:=1 To Len(aMatriz)
	IF aMatriz[x,2]==20
		MsgInfo("Nome: " + aMatriz[x,1] + CRLF + ; //CRLF - Pula a linha da matriz (ou funciona como o ENTER)
	        	"Idade: " + cValToChar(aMatriz[x,2]) + CRLF + ;
	        	"Sexo: " + IIF(aMatriz[x,3]=="M","Masculino","Feminino") )
	EndIf
Next

// ou fazer como o exemplo abaixo

nPos := aScan(aMatriz, {|X| x[2] == 20}) //aScan faz um for dentro do array e o comando {|X| x[2] == 20} faz o IF no array
	MsgInfo(aMatriz[nPos,1])

// Nessa caso as duas matrizes tem o mesmo endereço, por isso foram exibidos os valores abaixo na matriz aMatriz
aNome := aClone(aMatriz) // aClone - recria os dados da matriz em um outro endereço
aAdd ( aNome, {"Anderson", 19, "M"})
aAdd ( aNome, {"Fernanda", 32, "M"})

For x:=1 To Len(aMatriz) 
	
	MsgInfo("Nome: " + aMatriz[x,1] + CRLF + ; //CRLF - Pula a linha da matriz (ou funciona como o ENTER)
	        "Idade: " + cValToChar(aMatriz[x,2]) + CRLF + ;
	        "Sexo: " + IIF(aMatriz[x,3]=="M","Masculino","Feminino") ) 
Next x

// aSort - Ordena a matriz. Nesse caso podemos ordenar pela idade {|x,y| x[2] < y[2]} ou pelo nome {|x,y| x[1] < y[1]}

//aSort(aNome,,,{|x,y| x[2] < y[2]}) // Ordena apenas pela idade
aSort(aNome,,,{|x,y| cValToChar(x[2])+x[1] < cValToChar(y[2]) +y[1]}) // Ordena pela idade e depois pelo nome
For x:=1 To Len(aNome) 
	
	MsgInfo("Nome: " + aNome[x,1] + CRLF + ; //CRLF - Pula a linha da matriz (ou funciona como o ENTER)
	        "Idade: " + cValToChar(aNome[x,2]) + CRLF + ;
	        "Sexo: " + IIF(aNome[x,3]=="M","Masculino","Feminino") ) 
Next x

//MsgInfo("X")


Return

