#INCLUDE "PROTHEUS.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO14    ºAutor  ³Microsiga           º Data ³  07/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA051(cAlias,nReg,nOpc)

Local cUserAcess	:= ""
Local cAlAcess		:= "" 
Local lAtiva		:= SuperGetMv("GEN_FAT116",.F.,.F.)

If !(upper(alltrim(GetEnvServer())) $ "SCHEDULE")
	
	cUserAcess	:= SuperGetMv("GEN_FAT109",.F.,"")
	cAlAcess 	:= GetNextAlias()
	
	BeginSql Alias cAlAcess
		SELECT count(*) QTD FROM %Table:SC6% SC6
		  JOIN TOTVS.%Table:SF4% SF4
		    ON F4_FILIAL = %xFilial:SF4%
		    AND F4_CODIGO = C6_TES
		    AND SF4.%NotDel%
		    AND SF4.F4_XSEPPED     = '1'   
		WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
		AND C6_NUM = %Exp:SC5->C5_NUM%
		AND SC6.%NotDel%
	EndSql
	
	(cAlAcess)->(DbGoTop())
	
	lTesWMS := (cAlAcess)->QTD > 0
    
	(cAlAcess)->(DbCloseArea())

	If lTesWMS .AND. lAtiva
		If !( RetCodUsr() $ cUserAcess )
			MsgStop("Você não tem permissão para utilizar esta funcionalidade! Seu código de usuário é "+RetCodUsr())
			Return .F.
		EndIf
	EndIf
	
	If "RPC" $ FunName()
		lContinua := ProcStorn(lTesWMS)
	Else
		MsAguarde({|| ProcStorn(lTesWMS) },"Processamento","Aguarde! Processando estorno...")	
	EndIF
EndIf

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA051   ºAutor  ³Microsiga           º Data ³  07/28/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcStorn(lTesWMS)

Local cUsrAcess			:= ""
Local cSqlSaida			:= ""
Local cAlSaida			:= ""
Local cAlItSai			:= ""
Local cAlEmpGen			:= ""
Local nNumPedido		:= 0 
Local lContinua			:= .F.
Local cUpCabdWms		:= ""
Local cUpItedWms		:= ""
Local cVldSC9			:= ""

IF !MsgYesNo("Confirma o estorno da liberação do pedido: "+SC5->C5_NUM)
	Return nil
EndIf

If !("RPC" $ FunName())
	ProcRegua(0)
	IncProc()
EndIF


If !Empty(SC5->C5_NOTA)
	MsgStop("Pedido contem nota fiscal, não será possível realizar o estorno!")
	Return nil
EndIf


If lTesWMS
	If "RPC" $ FunName()
		lContinua := U_xStsRoma(SC5->C5_FILIAL,SC5->C5_NUM,nil,nil,.t.)
	Else
		MsAguarde({|| lContinua := U_xStsRoma(SC5->C5_FILIAL,SC5->C5_NUM,nil,nil,.t.) },"Processamento","Aguarde! Consultando Romaneio...")	
	EndIF
else
	lContinua := .T.
EndIf

If lContinua
	
	if lTesWMS
		cUpCabdWms := "DELETE DBA_EGK.DPS_E04_SAIDA_TBL WHERE E04_NR_PEDIDOGEN = "+SC5->C5_NUM+" AND E01_CD_EMPRESA = ( SELECT IDEMPRESAGEN FROM TT_I10_FILIAL_GEN_TOTVS I10 WHERE I10.IDEMPRESATOTVS = '"+SC5->C5_FILIAL+"' )
		cUpItedWms := "DELETE DBA_EGK.DPS_E05_ITENS_SAIDA_TBL WHERE E04_NR_PEDIDOGEN = "+SC5->C5_NUM+" AND E05_ID_EMPRESA = ( SELECT IDEMPRESAGEN FROM TT_I10_FILIAL_GEN_TOTVS I10 WHERE I10.IDEMPRESATOTVS = '"+SC5->C5_FILIAL+"' )

		If !("RPC" $ FunName())
			IncProc("Removendo pedido do Deposito")
		EndIF
			
		Begin Transaction
			
			If (lErroTc := TCSqlExec(cUpCabdWms) < 0)
				MsgStop("Falha ao remover o pedido do Deposito!"+Chr(13)+Chr(10)+TCSQLError())
				Disarmtransaction()
			EndIf		

			If (lErroTc := TCSqlExec(cUpItedWms) < 0)
				MsgStop("Falha ao remover o pedido do Deposito!"+Chr(13)+Chr(10)+TCSQLError())
				Disarmtransaction()
			EndIf
					
		End Transaction
		
		If lErroTc     
			Return()
		EndIf	

		nNumPedido	:= Val(SC5->C5_NUM)
		cAlSaida 	:= GetNextAlias()
		
		BeginSql Alias cAlSaida
			SELECT * FROM DBA_EGK.DPS_E04_SAIDA_TBL SAIDA
			JOIN TT_I10_FILIAL_GEN_TOTVS I10  
			ON I10.IDEMPRESATOTVS = %exp:SC5->C5_FILIAL%
			AND I10.IDEMPRESAGEN = SAIDA.E01_CD_EMPRESA
			WHERE SAIDA.E04_NR_PEDIDOGEN = %Exp:nNumPedido%
		EndSql
		
		lContinua	:= (cAlSaida)->(EOF())
		
		(cAlSaida)->(DbCloseArea())
		
	EndIf

	If !lContinua
		MsgStop("Ocorreu falha no processo remoção do pedido no deposito, tento novamente em alguns minutos, se o problema persistir entre em contato com TI!")
	Else

		If !("RPC" $ FunName())
			IncProc("Estornando pedido no Protheus!")
		EndIF
				
		SC6->(DbSetOrder(1)) 
		SC6->(DbSeek( SC5->C5_FILIAL+SC5->C5_NUM ))
		
		If Select("ESTSC9") <> 0
			ESTSC9->(DbcloseArea())
		EndIf
		
		BeginSql Alias "ESTSC9"
			SELECT R_E_C_N_O_ SC9RECNO FROM %Table:SC9% SC9
			 WHERE C9_FILIAL =  %Exp:SC5->C5_FILIAL%
			 AND C9_PEDIDO =  %Exp:SC5->C5_NUM%
			 AND SC9.%NotDel%
		EndSql
		
		ESTSC9->(DbgoTop())
		
		DbSelectarea("SC9")
		
		While ESTSC9->(!EOF())
			SC9->(DbGoTo(ESTSC9->SC9RECNO))
			
			Begin Transaction
				a460Estorna()
			End Transaction			
			
			ESTSC9->(DbSkip())
		EndDo
		ESTSC9->(DbcloseArea())
		/*
		While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
			
			SC9->(DbSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM)))
			While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->(C6_FILIAL+C6_NUM+C6_ITEM)
				SC9->(a460Estorna())
				SC9->(DbSkip())
			Enddo
			
			RecLock("",)
			
			SC6->(DbSkip())
	        EndDo		
			
		EndIf
	    */
	    
	    
	    cVldSC9	:= GetNextAlias()
	    
		BeginSql Alias cVldSC9
			SELECT count(*) QTD FROM %Table:SC9% SC9
			WHERE C9_FILIAL = %Exp:SC5->C5_FILIAL%
			AND C9_PEDIDO = %Exp:SC5->C5_NUM%
			AND SC9.%NotDel%
		EndSql
		
		(cVldSC9)->(DbGoTop())
		
		If (cVldSC9)->QTD > 0
			MsgStop("Ocorreu falha no processo remoção do pedido no deposito, tento novamente em alguns minutos, se o problema persistir entre em contato com TI!")			
		Else 
			/*
			If !Empty(SC5->C5_LIBEROK)
				RecLock("SC5",.F.)
				SC5->C5_LIBEROK := ""
				MsUnLock()
			EndIf	
			*/
			MsgStop("Estorno realizado com sucesso!")			
		EndIf
		
		(cVldSC9)->(DbCloseArea())	
		
	EndIF
EndIf

Return nil