/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/04/18/funcao-retorna-titulo-da-rotina-atual-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zFunTit
Fun��o que retorna o t�tulo da rotina em Execu��o
@type function
@author Atilio
@since 26/11/2016
@version 1.0
@return cTitle, T�tulo da Rotina atual
	@example
	MsgInfo("Estou na rotina <b>'"+u_zFunTit()+"'</b>", "Aten��o")
/*/

User Function zFunTit()
	Local aArea := GetArea()
	Local cTitle := ""
	
	//Se estiver instanciado no Objeto
	If Type("oApp:oMainWnd:cTitle") == "C"
		cTitle := oApp:oMainWnd:cTitle
		
		//Se tiver um colchetes, pega o texto at� a posi��o inicial do colchete
		If '[' $ cTitle
			cTitle := SubStr(cTitle, 1, At('[', cTitle)-1)
		EndIf
		
		cTitle := Alltrim(cTitle)
	EndIf
	
	RestArea(aArea)
Return cTitle