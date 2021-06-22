/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2016/04/19/funcao-retorna-semanas-entre-duas-datas-em-advpl/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zSemanas
Retorna as semanas entre duas datas
@author Atilio
@since 15/01/2015
@version 1.0
	@param dDataIni, Data, Data Inicial para verifica��o
	@param dDataFim, Data, Data Final para verifica��o
	@param lQuebDif, L�gico, Define se a quebra da semana ser� conforme o primeiro dia (dDataIni) ou se ser� o padr�o (s�bado)
	@return aSemanas, Array com as datas da semana
	@example
	u_zSemanas(dDatabase,dDatabase)
@obs Estrutura do array aSemanas:
	aSemanas [X][1] ==> Dia Inicial
	aSemanas [X][2] ==> Dia Final
	aSemanas [X][3] ==> Todos os dias da semana em formato texto separado por ;
/*/

User Function zSemanas(dDataIni, dDataFim, lQuebDif)
	Local aArea			:= GetArea()
	Local aSemanas		:= {}
	Local dDataAtu		:= dDataBase
	Local cDiaQueb		:= "saturday"
	Default dDataIni	:= DaySub(dDataBase, 15)
	Default dDataFim	:= DaySum(dDataBase, 15)
	Default lQuebDif	:= .F.

	//Definindo o dia de quebra
	If lQuebDif
		cDiaQueb := Alltrim(Lower(cDoW(dDataIni)))
	EndIf
	
	//Zerando vari�veis
	dDataAtu := dDataIni
	aAdd(aSemanas, {dDataAtu, dDataAtu, dToS(dDataAtu)+";"})
	nAtual := 1
	
	//Enquanto o dia atual for diferente do �ltimo dia
	While dDataAtu <= dDataFim
		//Se for s�bado, quebra a semana
		If Alltrim( Lower( cDow(dDataAtu) ) ) == cDiaQueb
			aSemanas[nAtual][2] := dDataAtu
			aSemanas[nAtual][3] += dToS(dDataAtu)+";"
			dDataAtu := DaySum(dDataAtu, 1)
			aAdd(aSemanas, {dDataAtu, dDataAtu, ""})
			nAtual++
		EndIf
	
		aSemanas[nAtual][2] := dDataAtu
		aSemanas[nAtual][3] += dToS(dDataAtu)+";"
		dDataAtu := DaySum(dDataAtu, 1)
	EndDo
	
	RestArea(aArea)
Return aSemanas