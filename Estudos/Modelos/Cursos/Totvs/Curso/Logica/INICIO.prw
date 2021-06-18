#Include 'Protheus.ch'
// Exexmplo de comentario por linha

/* Comentario 
em
bloco
*/

User Function INICIO() //User Function - função global

cVar  := ""                // ou '' - String                                   | C - Caractere
lVar  := .T.               // .F. - Booler/Logico                              | L - Logico
nVar  := 0                 // Numerico                                         | N -Numerico
dDate := Date()            // Data                                             | D - Data
oVar  := Nil               // Objeto - Nil = Nulo                              | O - Objeto
aVar  := {}                // Array | Matriz | Vetor | Variaveis compostas     | A - Array
bVar  := {|x| msginfo(x) } // Bloco de codigo | Variaveis compostas            | B - Bloco

//Conactacao hungara | Boas praticas de programacao

Private cVar1 as Character
Private nVar1 as Numeric
Private dVar1 as Data
Private bVar1 as Block
Private lVar1 as Logical

Return // Fim
//--------------------------------------------------------------------------------------------
User Function xVar

Local xVar := NIL // Atribui o valor nulo (NIL) a variave xVar

xVar := "Agora é Char" // Atribui o valor Agora é char para a variavel xVar

Msginfo(xVar) // Mensagem para o usuário

xVar := 50

MsgInfo(xVar + 100)

xVar := .T.

IF xVar // Nao e necessario comparar Ex: IF xVar == .T.
	msginfo("Verdadeiro")
ELSE
	msginfo("Falso")
ENDIF

xVar := {"Array",Date(),Time()}

Msginfo (xvar[1])
Msginfo (xvar[2])
Msginfo (xvar[3])

xVar := {|x| msginfo()}

eVal (xVar,"Exemplo Bloco")

xVar := NIL

Msginfo("Variavel nula novamente" + CVALTOCHAR(xVar)) // Erro type mismatch (concatenando uma variavel com nada)
													  // Msginfo("Variavel nula novamente" + xVar)


Return

//-----------------------------------------------------------------------------------------------

User Function VARIAVEL()

	Local nNum := 66
	Local lLogic := .T.
	Local cCarac := "STRING"
	Local dData := Date() //DATA ATUAL
	Local aArray := {"JOAO", "MARIA", "JOSE"}
	Local bBloco := {|| nValor := 2, MsgAlert("O numero é: "+ cValToChar(nValor))}
	
	Alert(nNum)
	Alert(lLogic)
	Alert(cValToChar(cCarac))
	Alert (dData)
	Alert(aArray[1])
	Eval(bBloco)//Imprime Bloco de Código
	
	
Return
//-----------------------------------------------------------------------------------------------



