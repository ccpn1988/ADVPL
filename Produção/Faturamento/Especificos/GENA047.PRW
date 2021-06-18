#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENA047   ∫Autor  ≥Cleuto Renato       ∫ Data ≥  22/06/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ bloqueio por black list                                    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Gen                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User function GENA047(cEmail,cNome,cCgc,cCEP)

Local lRet		:= .T.
Local cSql		:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local cAliTmp	:= GetNextAlias()
Local cSuperGet

Default cCEP	:= ""

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Cleuto - 19/08/2016                         ≥
//≥Incluida validaÁ„o para n„o bloquear Ofertas≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

If Select("TMP_OFERTA") > 0
	TMP_OFERTA->(DbCloseArea())
EndIf

BeginSql Alias "TMP_OFERTA"
	SELECT COUNT(*) QTD FROM %Table:SC6% SC6
	JOIN %Table:SF4% SF4
	ON F4_FILIAL = %xFilial:SF4%
	AND F4_CODIGO = C6_TES
	AND SF4.%NotDel%
	AND SF4.F4_XTPCONT = '1'	
	WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
	AND C6_NUM = %Exp:SC5->C5_NUM%
	AND SC6.%NotDel%
EndSql

TMP_OFERTA->(DbGotop())

If TMP_OFERTA->QTD > 0
	If Select("TMP_OFERTA") > 0
		TMP_OFERTA->(DbCloseArea())
	EndIf
	Return .T.	
EndIf

/*-----------------------------------------------*/

cCEP	:= Left(cCEP,5)

If !Empty(cEmail) .OR. !Empty(cCgc) //.OR. !Empty(cNome) 
	cSql += " SELECT * FROM "+RetSqlName("ZZ6")+" ZZ6 "+cQuebra
	cSql += " WHERE ZZ6_FILIAL = '"+xFilial("ZZ6")+"' "+cQuebra
	
	cSql += " AND ( 
	
	If !Empty(cEmail)
		cSql += " UPPER(ZZ6_EMAIL) LIKE '%"+Upper(AllTrim(cEmail))+"%' "+cQuebra
	EndIf	           
	/*
	If !Empty(cNome)  
		IF !Empty(cEmail)
			cSql += " OR "
		EndIF
		cSql += " upper(translate(ZZ6_NOME,'‚‡„·¡¬¿√ÈÍ… ÌÕÛÙı”‘’¸˙‹⁄«Á','AAAAAAAAEEEEIIOOOOOOUUUUCC')) LIKE '%'||upper(translate('"+AllTrim(cNome)+"','‚‡„·¡¬¿√ÈÍ… ÌÕÛÙı”‘’¸˙‹⁄«Á','AAAAAAAAEEEEIIOOOOOOUUUUCC'))||'%' "+cQuebra
	EndIf	
	*/
	If !Empty(cCgc)
		IF !Empty(cEmail)// .OR. !Empty(cNome)
			cSql += " OR "
		EndIF	
		cSql += " trim(regexp_replace(ZZ6_CGC,'[[:punct:]]','')) = trim(regexp_replace('"+AllTrim(cCgc)+"','[[:punct:]]','')) "+cQuebra
	EndIf	

	If !Empty(cCEP)
		IF !Empty(cEmail) .OR. !Empty(cCgc)
			cSql += " OR "
		EndIF	
		cSql += " SUBSTR(ZZ6_CEP,1,5) = '" + cCEP + "' "+cQuebra
	EndIf
		
	cSql += " )
	
	cSql += " AND ZZ6.D_E_L_E_T_ <> '*' "+cQuebra   
	
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cSql), cAliTmp ,.T.,.T.)
	
	(cAliTmp)->(DbGoTop())
	
	lRet	:= (cAliTmp)->(!EOF())
	
	If lRet
		RecLock("SC5",.F.)
		SC5->C5_BLQ	:= "4" // bloqueio por black list
		SC5->(MsUnLock())
		
		If !(upper(alltrim(GetEnvServer())) $ "SCHEDULE")
			MsgStop("Cliente em black list!"+cQuebra+"Este pedido ser· bloqueado!")
		EndIf
			
	EndIf
	
	(cAliTmp)->(DbCloseArea())
	
EndIF

If Select("TMP_OFERTA") > 0
	TMP_OFERTA->(DbCloseArea())
EndIf
	
Return lRet
