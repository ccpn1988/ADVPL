#INCLUDE "rwmake.ch"
#Include "TopConn.Ch"

User Function GeRetPD3(cCliFor,cLoja,cProd,dDeData)

Local nSaldo	:= 0
Local aSldSB6	:= {}

BeginSql Alias "TMP_SLD"
	SELECT B6_CLIFOR, B6_LOJA, B6_IDENT,B6_PRODUTO, SB6.B6_DTDIGIT,SB6.B6_EMISSAO,B6_TES
	FROM SB6000 SB6
	WHERE B6_FILIAL = '1022'
	AND B6_CLIFOR = %Exp:cCliFor%
	AND B6_LOJA = %Exp:cLoja%
	AND B6_PRODUTO = %Exp:cProd%
	AND B6_PODER3 = 'R'
	AND B6_TPCF = 'C'
	AND SB6.B6_DTDIGIT <= %Exp:dDeData%
	AND SB6.D_E_L_E_T_ <> '*'
	ORDER BY SB6.B6_DTDIGIT ASC
EndSql

TMP_SLD->(DbGoTop())

/*
±±³Descri‡…o ³ Retorna um Array onde:                                     ³±±
±±³          ³ aSaldo[1] := Saldo de Poder Terceiro                       ³±±
±±³          ³ aSaldo[2] := Quantidade Poder Terceiro Liberada(ainda nao  ³±±
±±³          ³                               faturada)                    ³±±
±±³          ³ aSaldo[3] := Saldo total do poder de terceiro ( Valor)     ³±±
±±³          ³ aSaldo[4] := Soma do total de devolucoes do Poder Terceiros³±±          
±±³          ³ aSaldo[5] := Valor Total em Poder Terceiros				  ³±±
±±³          ³ aSaldo[6] := Quantidade Total em Poder Terceiros			  ³±±
*/
while TMP_SLD->(!EOF()) 

	aSldSB6	:= CalcTerc(TMP_SLD->B6_PRODUTO,TMP_SLD->B6_CLIFOR,TMP_SLD->B6_LOJA,TMP_SLD->B6_IDENT,TMP_SLD->B6_TES,'N',StoD(TMP_SLD->B6_DTDIGIT),dDeData)
	nSaldo += aSldSB6[1]
	
	TMP_SLD->(DbSkip())	
EndDo

TMP_SLD->(DbCloseArea())

Return nSaldo
