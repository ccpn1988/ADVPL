/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2019/10/10/funcao-para-validar-nome-de-um-arquivo-txt-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zNameFile
Fun��o que serve para retirar caracteres especiais para nome de arquivos
@author Atilio
@since 10/08/2018
@version 1.0
@param cString, characters, Nome do arquivo que ser� recomposto
@type function
@example //...
	cCaminho := "C:\spool\"
	cArquivo := SA1->A1_NREDUZ + ".txt"          //Teste | Cliente: 01.txt
	cCamFull := cCaminho + u_zNameFile(cArquivo) //Resultado ser�: C:\spool\Teste  Cliente 01.txt
	//...
@obs A fun��o foi baseada no Windows, onde ao renomear um arquivo, n�o pode ser usado \ / : * ? " < > |
/*/

User Function zNameFile(cString)
	Local aArea      := GetArea()
	Local cStringNov := ""
	Local aSubstit   := {}
	Local nAtual     := 0
	Default cString  := ""
	
	//Se houver dados
	If ! Empty(cString)
		
		//Adiciona caracteres que ser�o retirados
		aAdd(aSubstit, '\')
		aAdd(aSubstit, '/')
		aAdd(aSubstit, ':')
		aAdd(aSubstit, '*')
		aAdd(aSubstit, '?')
		aAdd(aSubstit, '"')
		aAdd(aSubstit, '<')
		aAdd(aSubstit, '>')
		aAdd(aSubstit, '|')
		
		//Pega o conte�do original e joga na nova vari�vel
		cStringNov := cString
		
		//Percorre os dados
		For nAtual := 1 To Len(aSubstit)
			cStringNov := StrTran(cStringNov, aSubstit[nAtual], "")
		Next
	EndIf
	
	RestArea(aArea)
Return cStringNov