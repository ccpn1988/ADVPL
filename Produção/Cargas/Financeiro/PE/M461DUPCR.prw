/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F460GERNCC ºAutor ³Cleuto Lima         º Data ³  18/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ponto de entrada para complemento de informa~ções de NCC   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ F460GERNCC                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M461DUPCR()

Local nNfOri	:= 0
Local nSeOri	:= 0
Local cNatCC	:= ""
/*
	atualiza a da NCC com as informações de pagamento da nota fiscal de venda
*/

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return nil
EndIf

If Type('cTipo') == "C" .and. cTipo == "D" .AND. cFormul == "S" .AND. cArqSA == "SA1" .AND. SE1->E1_TIPO == "NCC"

	nNfOri	:= GdFieldPos("D1_NFORI")
	nSeOri	:= GdFieldPos("D1_SERIORI")
	cNatCC	:= GetMv("GENI018CAR") 
	
	If Select("PGT_TMP") > 0
		PGT_TMP->(DbCloseArea())
	EndIf
	
	BeginSql Alias "PGT_TMP"
		SELECT E1_XBANDEI,E1_XOPERA,E1_DOCTEF 
		FROM %Table:SF2% SF2
		JOIN %Table:SE1% SE1
		ON E1_FILIAL = F2_FILIAL
		AND E1_NUM = SF2.F2_DUPL
		AND E1_PREFIXO = SF2.F2_PREFIXO
		AND E1_TIPO = 'NF'
		AND SE1.E1_CLIENTE = F2_CLIENTE
		AND E1_LOJA = F2_LOJA
		AND SE1.%NotDel%
		WHERE F2_FILIAL = %Exp:SE1->E1_FILIAL%
		AND F2_DOC = %Exp:aCols[n][nNfOri]%
		AND F2_SERIE = %Exp:aCols[n][nSeOri]%
		AND F2_CLIENTE = %Exp:cA100For%
		AND F2_LOJA = %Exp:cLoja% 
		AND E1_NATUREZ = %Exp:cNatCC%
		AND SF2.%NotDel%		
		AND E1_XBANDEI <> ' ' 
		AND E1_XOPERA <> ' ' 
		AND E1_DOCTEF <> ' ' 		
	EndSql
	
	PGT_TMP->(DbGoTop())
	If PGT_TMP->(!EOF())
		Reclock("SE1",.F.)
		SE1->E1_XBANDEI	:= PGT_TMP->E1_XBANDEI	 
		SE1->E1_XOPERA	:= PGT_TMP->E1_XOPERA
		SE1->E1_DOCTEF	:= PGT_TMP->E1_DOCTEF
		MsUnLock()
	EndIf
	
	PGT_TMP->(DbCloseArea())
EndIf


Return nil