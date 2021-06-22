/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/11/29/funcao-quebra-um-campo-memo-em-varias-linhas-para-impressao-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zMemoToA
Fun��o Memo To Array, que quebra um texto em um array conforme n�mero de colunas
@author Atilio
@since 15/08/2014
@version 1.0
	@param cTexto, Caracter, Texto que ser� quebrado (campo MEMO)
	@param nMaxCol, Num�rico, Coluna m�xima permitida de caracteres por linha
	@param cQuebra, Caracter, Quebra adicional, for�ando a quebra de linha al�m do enter (por exemplo '<br>')
	@param lTiraBra, L�gico, Define se em toda linha ser� retirado os espa�os em branco (Alltrim)
	@return nMaxLin, N�mero de linhas do array
	@example
	cCampoMemo := SB1->B1_X_TST
	nCol        := 200
	aDados      := u_zMemoToA(cCampoMemo, nCol)
	@obs Difere da MemoLine(), pois j� retorna um Array pronto para impress�o
/*/

User Function zMemoToA(cTexto, nMaxCol, cQuebra, lTiraBra)
	Local aArea     := GetArea()
	Local aTexto    := {}
	Local aAux      := {}
	Local nAtu      := 0
	Default cTexto  := ''
	Default nMaxCol := 80
	Default cQuebra := ';'
	Default lTiraBra:= .T.

	//Quebrando o Array, conforme -Enter-
	aAux:= StrTokArr(cTexto,Chr(13))
	
	//Correndo o Array e retirando o tabulamento
	For nAtu:=1 TO Len(aAux)
		aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
	Next
	
	//Correndo as linhas quebradas
	For nAtu:=1 To Len(aAux)
	
		//Se o tamanho de Texto, for maior que o n�mero de colunas
		If (Len(aAux[nAtu]) > nMaxCol)
		
			//Enquanto o Tamanho for Maior
			While (Len(aAux[nAtu]) > nMaxCol)
				//Pegando a quebra conforme texto por parâmetro
				nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
				
				//Caso n�o tenha, a �ltima posi��o ser� o �ltimo espa�o em branco encontrado
				If nUltPos == 0
					nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
				EndIf
				
				//Se n�o encontrar espa�o em branco, a �ltima posi��o ser� a coluna m�xima
				If(nUltPos==0)
					nUltPos:=nMaxCol
				EndIf
				
				//Adicionando Parte da Sring (de 1 at� a Úlima posi��o v�lida)
				aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
				
				//Quebrando o resto da String
				aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
			EndDo
			
			//Adicionando o que sobrou
			aAdd(aTexto,aAux[nAtu])
		Else
			//Se for menor que o M�ximo de colunas, adiciona o texto
			aAdd(aTexto,aAux[nAtu])
		EndIf
	Next
	
	//Se for para tirar os brancos
	If lTiraBra
		//Percorrendo as linhas do texto e aplica o AllTrim
		For nAtu:=1 To Len(aTexto)
			aTexto[nAtu] := Alltrim(aTexto[nAtu])
		Next
	EndIf
	
	RestArea(aArea)
Return aTexto