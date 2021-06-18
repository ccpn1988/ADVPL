//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} zCodAno
Fun��o que retorna o ultimo campo c�digo com separa��o de ano (ex.: 00001/15)
@type function
@author Atilio
@since 27/11/2015
@version 1.0
	@param cTab, Caracter, Tabela que ser� consultada
	@param cCampo, Caracter, Campo utilizado de c�digo
	@param [dData], Data, Data de Refer�ncia
	@param [cSep], Caracter, Caracter Separador
	@param [nTamAno], Num�rico, Tamanho do ano (n�o pode ser menor que 2)
	@param [lSoma1], L�gico, Define se al�m de trazer o �ltimo, j� ir� somar 1 no valor
	@example
	u_zCodAno("SC5", "C5_X_CAMPO", dDataBase, "/", 2, .T.)
/*/

User Function zCodAno(cTab, cCampo, dData, cSep, nTamAno, lSoma1)
	Local aArea		:= GetArea()
	Local cCodFull	:= ""
	Local cCodAux		:= ""
	Local cAno			:= ""
	Local cQuery		:= ""
	Local nTamCampo	:= 0
	Default dData		:= dDataBase
	Default cSep		:= "/"
	Default nTamAno	:= 2
	Default lSoma1	:= .F.
	
	//Se o tamanho do ano for menor que 2 ou maior que 4, ser� 2
	If nTamAno < 2 .Or. nTamAno > 4
		nTamAno := 2
	EndIf
	
	//Definindo o c�digo atual
	nTamCampo := TamSX3(cCampo)[01]
	cCodAux   := Space(nTamCampo-(nTamAno+1))
	cCodAux   := StrTran(cCodAux, ' ', '0')
	
	//Definindo o ano
	cAno := dToS(dDataBase)
	cAno := SubStr(cAno, 5-nTamAno, nTamAno)
	
	//Fa�o a consulta para pegar as informa��es
	cQuery := " SELECT "
	cQuery += "   ISNULL(MAX(SUBSTRING("+cCampo+", 1, "+cValToChar(nTamCampo - (nTamAno+1))+")), '"+cCodAux+"') AS MAXIMO "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName(cTab)+" TAB "
	cQuery += " WHERE "
	cQuery += "   SUBSTRING(TAB."+cCampo+", "+cValToChar(nTamCampo+1 - nTamAno)+", "+cValToChar(nTamAno)+") = '"+cAno+"' "
	cQuery += "   AND TAB.D_E_L_E_T_ = '' "
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery New Alias "QRY_TAB"
	
	//Se n�o tiver em branco
	If !Empty(QRY_TAB->MAXIMO)
		cCodAux := QRY_TAB->MAXIMO
	EndIf
	
	//Se for para atualizar, soma 1 na vari�vel
	If lSoma1
		cCodAux := Soma1(cCodAux)
	EndIf
	
	//Definindo o c�digo de retorno
	cCodFull := cCodAux + cSep + cAno
	
	QRY_TAB->(DbCloseArea())
	RestArea(aArea)
Return cCodFull