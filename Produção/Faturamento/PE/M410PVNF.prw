
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF  ºAutor  ³Cleuto Lima         º Data ³  27/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na função Ma410PvNfs para validar acesso   º±±
±±º          ³a rotina.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function M410PVNF()

Local lRet			:= .T.
Local cUserAcess	:= ""

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

	If lTesWMS
		If !( RetCodUsr() $ cUserAcess )
			MsgStop("Você não tem permissão para utilizar esta funcionalidade para pedidos com separação de estoque! Seu código de usuário é "+RetCodUsr())
			Return .F.
		EndIf
	EndIf
	
EndIf

Return lRet