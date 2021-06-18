
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA070CA2  ºAutor  ³Microsiga           º Data ³  12/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ponto de entreda na rotina de baixas a receber              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FA070CA2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea		:= GetArea()
Local aAreaSE1	:= SE1->(GetArea())
Local cTitPai	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA//Prefixo + Número + Parcela + Tipo + Cliente + Loja
Local nOpcAux	:= PARAMIXB[1]
Local cAliAux	:= GetNextAlias()
Local nPosTit	:= aScan( aBaixaSE5, {|x| AllTrim(x[4]) == "NF" } )
Local nPosNCC	:= aScan( aBaixaSE5, {|x| AllTrim(x[4]) == "NCC" } )
Local nReSld	:= nValRec
Local nValTx	:= 0
Local nAuxNcc	:= 0
Local nSldEsto	:= 0
Local nSldTxEs	:= 0
Local cParcAux	:= IIF( !Empty( AllTrim(SE1->E1_PARCELA) ) , SE1->E1_PARCELA , "A" )
Local cErro		:= ""
//nOpcx == 5 // cancelamento
//nOpcx == 6 // exclusao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para estornar o valor da baixa                 ³
//³na tabela de controle de pagamento das operados de cartão ³
//³de credito                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nPosTit > 0
	BeginSql Alias cAliAux
		SELECT ZZ9.R_E_C_N_O_ RECZZ9 FROM %Table:ZZ9% ZZ9
		WHERE ZZ9_FILIAL = %xFilial:ZZ9%
		AND TO_NUMBER(ZZ9_NSU) = %Exp:val(SE1->E1_DOCTEF)%
		AND ZZ9_PARCEL = %Exp:cParcAux%
		AND ZZ9.%NotDel%
	EndSql
	
	(cAliAux)->(DbGoTop())
	
	While (cAliAux)->(!EOF()) .AND. nReSld > 0
		
		ZZ9->( DbGoTo((cAliAux)->RECZZ9) )
		
		SE1->(DbSetOrder(28))
		If SE1->(DbSeek(xFilial("SE1")+cTitPai))		
			nValTx	:= SE1->E1_SALDO
		EndIf
		
		RecLock("ZZ9",.F.)
		ZZ9->ZZ9_SALDO	:= IIF ( ZZ9->ZZ9_SALDO+nReSld > ZZ9->ZZ9_LIGPAG , ZZ9->ZZ9_LIGPAG , ZZ9->ZZ9_SALDO+nReSld )
		ZZ9->ZZ9_STXADM	:= IIF ( ZZ9->ZZ9_STXADM+nValTx > ZZ9->ZZ9_TXADM , ZZ9->ZZ9_TXADM , ZZ9->ZZ9_STXADM+nValTx )
		ZZ9->ZZ9_CONCIL	:= "2"
		MsUnLock("ZZ9")
		
		nReSld-= ZZ9->ZZ9_SALDO
		
		(cAliAux)->(DbSkip())
	EndDo
	
	(cAliAux)->(DbCloseArea())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³tratamento para estornar o valor da baixa na tabela  ³
//³de controle de pagamento das operadoras de cartão de ³
//³credito                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPosNCC > 0

		For nAuxNcc := 1 To Len(aBaixaSE5)
			If AllTrim(aBaixaSE5[nAuxNcc][4]) <> "NCC" .OR. AllTrim(aBaixaSE5[nAuxNcc][2]) <> SE1->E1_NUM
				Loop
			EndIf
			nPosNCC	:= nAuxNcc // PEGO O ULTIMO MOVIMENTO DE BAIXA POIS AS BAIXAS DEVEM SER ESTORNADAS NA ORDEM IVERSA QUE FORAM BAIXADAS
		Next
		
		nSldEsto	:= aBaixaSE5[nPosNCC][8]*(-1) // valor estornado
		nSldTxEs	:= aBaixaSE5[nPosNCC][16]*(-1) // valor do desconto estornado

		If Select("BUSCA_NSU") >0 
			BUSCA_NCC->(DbCloseArea())
		EndIf
		
		BeginSql Alias "BUSCA_NSU"
			
			SELECT DISTINCT SE1B.E1_DOCTEF E1_DOCTEF
			FROM %Table:SE1% SE1
			
			JOIN %Table:SF1% SF1
			ON F1_FILIAL = E1_FILIAL
			AND F1_DUPL = E1_NUM
			AND F1_PREFIXO = E1_PREFIXO
			AND F1_FORNECE = E1_CLIENTE
			AND F1_LOJA = E1_LOJA
			AND SF1.%NotDel%
						
			JOIN %Table:SD1% SD1
			ON F1_FILIAL = D1_FILIAL
			AND F1_DOC = D1_DOC
			AND F1_SERIE = D1_SERIE
			AND F1_FORNECE = D1_FORNECE
			AND F1_LOJA = D1_LOJA
			AND SD1.%NotDel%
			
			JOIN %Table:SF2% SF2
			ON D1_FILIAL = F2_FILIAL
			AND D1_NFORI = F2_DOC
			AND D1_SERIORI = F2_SERIE
			AND D1_FORNECE = F2_CLIENTE
			AND D1_LOJA = F2_LOJA
			AND SF2.%NotDel%
			
			JOIN %Table:SE1%  SE1B			
			ON SE1B.E1_FILIAL = F2_FILIAL
			AND SE1B.E1_NUM = F2_DUPL
			AND SE1B.E1_PREFIXO = F2_PREFIXO
			AND SE1B.E1_CLIENTE = F2_CLIENTE
			AND SE1B.E1_LOJA = F2_LOJA
			AND SE1B.E1_TIPO = 'NF'
			AND SE1B.%NotDel%	
						
			WHERE SE1.E1_TIPO = 'NCC'
			AND SE1.R_E_C_N_O_ = %EXP:SE1->(Recno())%
			AND SE1.%NotDel%
			
		EndSql		
		
        If BUSCA_NSU->(!EOF())
        	
        	If Select("TMP_ZZ9") > 0	
	        	TMP_ZZ9->(DbCloseArea())
        	EndIf
        	
        	BeginSql Alias "TMP_ZZ9"
		      SELECT ZZ9.R_E_C_N_O_ RECZZ9,ZZ9.ZZ9_DTCRED 
		      FROM %Table:ZZ9% ZZ9
		      WHERE ZZ9_FILIAL = %xFilial:ZZ9%
		      AND TO_NUMBER(ZZ9_NSU) = %Exp:VAL(BUSCA_NSU->E1_DOCTEF)%
		      AND ZZ9_TIPO = '12'
		      AND ZZ9.%NotDel%
		      ORDER BY ZZ9.ZZ9_DTCRED DESC        	
        	EndSql
        	
        	While TMP_ZZ9->(!EOF()) .AND. nSldEsto <> 0 .AND. nSldTxEs <> 0
        		
        		ZZ9->(DbGoTo( TMP_ZZ9->RECZZ9 ))
		   		    
	   		    Do Case
	   				Case ZZ9->ZZ9_SALDO+nSldEsto < ZZ9->ZZ9_LIGPAG .AND. ZZ9->ZZ9_SALDO+ZZ9->ZZ9_STXADM <> 0
	   					cErro	+= "Valor do estorno maior que o saldo disponivel na ZZ9, verifique os valores da ZZ9 pois a baixa da NCC foi estornada"+Chr(13)+Chr(10)
	   					Exit
					Case ZZ9->ZZ9_SALDO == ZZ9->ZZ9_LIGPAG
						TMP_ZZ9->(DbSkip())
						Loop
					Case ZZ9->ZZ9_SALDO+nSldEsto >= ZZ9->ZZ9_LIGPAG

						RecLock("ZZ9",.F.)							
						ZZ9->ZZ9_SALDO	+= nSldEsto
						ZZ9->ZZ9_STXADM	+= nSldTxEs
						ZZ9->ZZ9_CONCIL	:= "2"							
						ZZ9->(MsUnLock())
						
						nSldEsto 	:= 0
						nSldTxEs	:= 0
						
						TMP_ZZ9->(DbSkip())
						Loop											
						
					OtherWise
						cErro	+= "Não foi possível identificar o saldo disponivel na ZZ9, verifique os valores da ZZ9 pois a baixa da NCC foi estornada"+Chr(13)+Chr(10)
						Exit
	   			EndCase

        		TMP_ZZ9->(DbCloseArea())
        	EndDo

        	If Select("TMP_ZZ9") > 0	
	        	TMP_ZZ9->(DbCloseArea())
        	EndIf
        	
        	BeginSql Alias "TMP_ZZ9"
		      SELECT SUM(ZZ9.ZZ9_SALDO) ZZ9_SALDO,SUM(ZZ9.ZZ9_STXADM) ZZ9_STXADM
		      FROM %Table:ZZ9% ZZ9
		      WHERE ZZ9_FILIAL = %xFilial:ZZ9%
		      AND TO_NUMBER(ZZ9_NSU) = %Exp:VAL(BUSCA_NSU->E1_DOCTEF)%
		      AND ZZ9_TIPO = '12'
		      AND ZZ9.%NotDel%      	
        	EndSql		
        	
        	If TMP_ZZ9->ZZ9_STXADM+TMP_ZZ9->ZZ9_SALDO <> (-1)*SE1->E1_SALDO
        		cErro += "Saldo de estorno da Acesstage (ZZ9) é diferente do saldo financeiro! Verifique os saldos e corrija!"
        	EndIf
        	
        	TMP_ZZ9->(DbCloseArea())
        	
        EndIf
        
		If !Empty(cErro)
			cErro := "NSU: "+BUSCA_NSU->E1_DOCTEF+", NCC: "+SE1->E1_NUM+", Parcela: "+SE1->E1_PARCELA+Chr(13)+Chr(10)+cErro
			U_GenSendMail(,,,"noreply@grupogen.com.br","cleuto.lima@grupogen.com.br",oemtoansi("FA070CA2 - Estorno de NCC"),cErro,,,.F.)			
			MsgStop(cErro)
		EndIf

		BUSCA_NSU->(DbCloseArea())
EndIf

RestArea(aAreaSE1)
RestArea(aArea)

Return nil