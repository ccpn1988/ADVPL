
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA041   ºAutor  ³Cleuto Lima         º Data ³  05/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realizado tratamento para remover os valores de desconto.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA041()

Local aAreaSC6	:= SC6->(GetArea())
Local cChaveSC5	:= SC5->C5_FILIAL+SC5->C5_NUM
Local lPrcLiq	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XNODESC") == "1"

If lPrcLiq //.AND. ( ALTERA ..)
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(cChaveSC5))
	While SC6->(!EOF()) .AND. cChaveSC5 == SC6->C6_FILIAL+SC6->C6_NUM
		
		RecLock("SC6",.F.) 
		// Realiza backup dos campos atuais
		SC6->C6_XPRUNIT	:= SC6->C6_PRUNIT
		SC6->C6_XDESCON	:= SC6->C6_DESCONT
		SC6->C6_XVALDES	:= SC6->C6_VALDESC				

		// Zera os campos de desconto		
		SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
		SC6->C6_DESCONT	:= 0
		SC6->C6_VALDESC	:= 0
		MsUnLock()
		
		SC6->(DbSkip())
	EndDo
EndIf

RestArea(aAreaSC6)

Return nil  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA041   ºAutor  ³Cleuto Lima         º Data ³  05/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realizado tratamento para restaurar os campos de desconto   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen.                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA041B()

Local aAreaSC6	:= SC6->(GetArea())
Local cChaveSC5	:= SC5->C5_FILIAL+SC5->C5_NUM
Local lPrcLiq	:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_XNODESC") == "1"

Local nPrunit	:= GdFieldPos("C6_PRUNIT")
Local nDescont	:= GdFieldPos("C6_DESCONT")
Local nValdesc	:= GdFieldPos("C6_VALDESC")

Local nItem		:= GdFieldPos("C6_ITEM")
Local nProduto	:= GdFieldPos("C6_PRODUTO")
Local cChave	:= ""
Local nAuxIt	:= 0

If lPrcLiq

	SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	For nAuxIt := 1 To Len(aCols)
		
		cChave := SC5->C5_FILIAL+SC5->C5_NUM+aCols[nAuxIt][nItem]+aCols[nAuxIt][nProduto]
		
		If SC6->(DbSeek(cChave))
			aCols[nAuxIt][nPrunit]	:= SC6->C6_XPRUNIT
			aCols[nAuxIt][nDescont]	:= SC6->C6_XDESCON
			aCols[nAuxIt][nValdesc]	:= SC6->C6_XVALDES						
		EndIf	
		
	Next nAuxIt		
	
EndIf

RestArea(aAreaSC6)


Return nil