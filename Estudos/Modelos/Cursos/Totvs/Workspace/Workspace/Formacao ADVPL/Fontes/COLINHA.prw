User Function Trata()

Set Date To British  // Data no formato DD/MM/AA

Set Epoch To 1943    // DD/MM/43 a DD/MM/99 --> 1943 a 1999
                     // DD/MM/00 a DD/MM/42 --> 2000 a 2042

/////////////////////////////////////////////////////////////////////
// Tratamento de caracters                                         //
/////////////////////////////////////////////////////////////////////

// Trim(cString): retira espa�os da direita.
// Trim("   Jose   ") -> "   Jose"

// LTrim(cString): retira espa�os da esquerda.
// LTrim("   Maria   ") -> "Maria   "

// RTrim(cString): retira espa�os da direita.
// RTrim("   Maria   ") -> "   Maria"

// AllTrim(cString): retira espa�os da direita e da esquerda.
// AllTrim("   Sao Paulo   ") -> "Sao Paulo"

// Left(cString, nCaracteres): retorna N caracteres da esquerda.
// Left("Abcdef", 3) -> "Abc"

// Right(cString, nCaracteres): retorna N caracteres da direita.
// Right("Abcdef", 2) -> "ef"

// Substr(cString, nPosicao, nCaracteres): retorna N caracteres a partir de uma posi��o.
// Substr("Programa", 3, 2) -> "og"

// Stuff(cString, nPosicao, nSubstituir, cTexto): substitui e incrementa caracteres para
//                                                dentro de uma string.
// Stuff("ABCDE", 3, 2, "123") -> "AB123E"  substitui "CD" por "123"

// PadR(cString, nTamanho, cCaracter) -> Inclui o caracter na direita da string, ate o
//                                       tamanho especificado.
// PadL(cString, nTamanho, cCaracter) -> Inclui o caracter na esquerda da string, ate o
//                                       tamanho especificado.
// PadC(cString, nTamanho, cCaracter) -> Inclui o caracter na direita e na esquerda da string, ate o
//                                       tamanho especificado.
// PadR("ABC", 10, "*") -> "ABC*******"
// PadL("ABC", 10, "*") -> "*******ABC"
// PadC("ABC", 10, "*") -> "***ABC****"

// Replicate(cString, nVezes): replica a String.
// Replicate("*", 5) -> "*****"
// Replicate("Abc/", 5) -> "Abc/Abc/Abc/Abc/Abc/"

// At(cProcura, cString, nApos): retorna a posi��o da primeira ocorrencia de cProcura em cString,
//                               apos a posicao nApos. Se nApos for omitido, procura desde o inicio.
// At("a", "abcde")   -> 1
// At("cde", "abcde") -> 3
// At("a", "bcde")    -> 0
// At("A", "MARIANO") -> 2

// RAt(cProcura, cString): retorna a posi��o da ultima ocorrencia de cProcura em cString.
// RAt("A", "MARIANO") -> 5

//StrTran( cString , cSearch >) :esquisa e substitui um conjunto de caracteres de uma string.
//
//StrTran( "AAAAACD", "A", "B" ) ) -> BBBBBCD

//FwNoAccent( <cTexto> ) Retira caracteres especiais do texto Informado
// FwNoAccent('At� / Ol� / � / � / � / V� / �o / � ') ->'Ate / Ola / E / o / O / Vo / ao / c '

// $: pertence.
// "a" $ "Maria"     -> .T.
// "A" $ "Maria"     -> .F.
// "ana" $ "Mariana" -> .T.

// Upper(cString): retorna cString em mai�scula.
// Upper("Maria") -> "MARIA"

// Lower(cString): retorna cString em min�scula.
// Lower("AbCdE") -> "abcde"

// Len(cString): retorna a quantidade de caracteres em cString.
// Len( {"Jose", "Maria", "Joao"} ) -> 3 elementos
// Len("Maria")                     -> 5 caracteres
// Len(SA1->A1_NOME)                -> tamanho do campo.

// Space(n): retorna n espa�os. Utilizado para inicializar variaveis do tipo caracter.
// Space(10) -> "          "
// cNome := Space(30)

// Capital(cTexto): retorna o texto com a primeira letra de cada palavra em maiuscula.
// Capital("TEXTO") -> "Texto"
// Capital("jose da silva") -> "Jose Da Silva"

/////////////////////////////////////////////////////////////////////
// Tratamento de numeros                                           //
/////////////////////////////////////////////////////////////////////

// Str(nNumero, nTamanho, nDecimal): converte um n�mero para caracter.
// Str(500)       -> "              500"
// Str(500, 8, 2) -> "  500.00"



// StrZero(nNumero, nTamanho, nDecimal): converte um n�mero para caracter preenchendo com zeros � esquerda.
// StrZero(1528.35, 10, 2) -> "0001528.35"

// Val(cNumero): converte um caracter para n�mero.
// Val("123456") -> 123456

// Transform(nNumero, cPicture): converte um n�mero para caracter com m�scara de edi��o.
// Transform(1528.35, "999,999.99")    -> "  1,528.35"
// Transform(1528.35, "@E 999,999.99") -> "  1.528,35"

// Extenso(nValor[,lQuantid][,nMoeda][,cPrefixo][,cIdioma][,lCent][,lFrac])
// Retorna valor por extenso (s� funciona via Remote pois usa o arquivo SX6).

/////////////////////////////////////////////////////////////////////
// Tratamento de datas e hora                                      //
/////////////////////////////////////////////////////////////////////

// Date(): obtem a data da maquina.

// CtoD(cData): converte uma string em data.
// CtoD("01/01/2018")     -> 01/01/2018 (em formato Data)
// CtoD("01/01/2018") + 5 -> 05/01/2018

// DtoC(dData): converte uma data em string.
// DtoC(Date()) -> data da maquina em formato "DD/MM/AA" caracter.

// DtoS(dData): converte uma data em string, no formato "AAAAMMDD"
// DtoS(CtoD("01/01/2018")) -> "20180101"

// Stod(cData): Retorna a data, a partir de uma string de oito caracteres
// Stod('20180101') -> 01/01/2018

// DOW(dData): retorna o dia da semana de uma data (1-domingo, 2-segunda, ..., 7-sabado)
// DOW(CtoD("01/01/2018")) -> 2 (Segunda-feira)

// Day(dData): retorna o dia de uma data.
// Day(CtoD("01/01/2018")) -> 01

// Month(dData): retorna o mes de uma data.
// Month(CtoD("01/01/2018")) -> 01

// Year(dData): retorna o ano de uma data.
// Year(CtoD("01/01/2018")) -> 2018

// Time(): retorna a hora atual no formato "HH:MM:SS"

// Elaptime(Hora Ini, Hora Fin): retorna o tempo decorrido.

Return( NIL )