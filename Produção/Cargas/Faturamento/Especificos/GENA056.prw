#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA056   ºAutor  ³Cleuto Lima         º Data ³  27/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Avalia Saldo em poder 3                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gen                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA056(cObra,nSldPrest,cLocal,cFilGen,cFilOri,cCodFor,cLojfor,dDtRef,cTipo,nSldBal,aInfo)
/*
Default cObra		:= "04204034"
Default nSldPrest	:= -10
Default cLocal		:= "01"                   
Default cFilGen		:= "1022"
Default cFilOri		:= "9022"
Default cCodFor		:= "0378128"
Default cLojfor		:= "07"
Default dDtRef		:= StoD("20160831")
Default cTipo		:= "1"
Default aInfo		:= {}
Default nSldBal		:= 0 // Saldo balanceado possível de ser utilizado

RpcSetEnv("00","1022")

Teste(cObra,nSldPrest,cLocal,cFilGen,cFilOri,cCodFor,cLojfor,dDtRef,cTipo,@nSldBal,aInfo)

Return nil

Static Function Teste(cObra,nSldPrest,cLocal,cFilGen,cFilOri,cCodFor,cLojfor,dDtRef,cTipo,nSldBal,aInfo)
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da rotina.                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet		:= .F.
Local nSaldo	:= 0
Local nAuxSld	:= 0
Local _cQuery	:= ""
Local cAliSB6	:= ""
Local cErroSql	:= ""
Local aDocs		:= {}
Local _cLogPd	:= GetMv("GEN_FAT016") 

Default nSldBal	:= 0 // Saldo balanceado possível de ser utilizado

If nSldPrest > 0
	_cQuery := " SELECT B6_FILIAL, B6_DOC,B6_QUANT,
	_cQuery += " B6_SERIE, D1_ITEM, B6_IDENT
	
	_cQuery += " ,NVL((SELECT SUM(B6_ORI.B6_SALDO)
	_cQuery += "      FROM "+ RetSqlName("SB6") +" B6_ORI
	_cQuery += "      JOIN "+ RetSqlName("SD2") +" D2_ORI
	_cQuery += "      ON D2_ORI.D2_FILIAL = B6_ORI.B6_FILIAL
	_cQuery += "      AND D2_ORI.D2_DOC = B6_ORI.B6_DOC
	_cQuery += "      AND D2_ORI.D2_SERIE = B6_ORI.B6_SERIE
	_cQuery += "      AND D2_ORI.D2_CLIENTE = B6_ORI.B6_CLIFOR
	_cQuery += "      AND D2_ORI.D2_LOJA = B6_ORI.B6_LOJA
	_cQuery += "      AND D2_ORI.D2_COD = B6_ORI.B6_PRODUTO
	_cQuery += "      AND D2_ORI.D2_IDENTB6 = B6_ORI.B6_IDENT
	_cQuery += "      AND D2_ORI.D_E_L_E_T_ <> '*'
	_cQuery += "      WHERE B6_ORI.B6_FILIAL = '"+cFilOri+"'
	_cQuery += "        AND B6_ORI.B6_DOC = SB6.B6_DOC
	_cQuery += "        AND B6_ORI.B6_SERIE = SB6.B6_SERIE
	_cQuery += "        AND B6_ORI.B6_PRODUTO = SB6.B6_PRODUTO
	_cQuery += "        AND B6_ORI.B6_QUANT = SB6.B6_QUANT
	_cQuery += "        AND B6_ORI.D_E_L_E_T_ = ' ' 
	//Removi esta validação para permitir utilizar notas com saldo parcialmente balanceado, esta validação permite apenas notas com 100% saldo correto
	//_cQuery += "        AND D2_ORI.D2_QUANT - D2_ORI.D2_QTDEDEV >= B6_ORI.B6_SALDO
	//_cQuery += "        AND D2_ORI.D2_QUANT - ( SELECT SUM(D1_QUANT) FROM "+ RetSqlName("SD1") +" SD1_ORI WHERE SD1_ORI.D1_FILIAL = D2_ORI.D2_FILIAL AND SD1_ORI.D1_NFORI = D2_ORI.D2_DOC AND SD1_ORI.D1_SERIORI = D2_ORI.D2_SERIE AND SD1_ORI.D1_ITEMORI = D2_ORI.D2_ITEM AND SD1_ORI.D_E_L_E_T_ <> '*') >= B6_ORI.B6_SALDO       
	_cQuery += "        ),0) SALDO_ORI "
	
	_cQuery += " ,(D1_QUANT-NVL(( SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2
	_cQuery += "     WHERE D2_FILIAL = SB6.B6_FILIAL
	_cQuery += "     AND SD2.D2_NFORI = SB6.B6_DOC
	_cQuery += "     AND SD2.D2_SERIORI = SB6.B6_SERIE
	_cQuery += "     AND SD2.D2_ITEMORI = D1_ITEM
	_cQuery += "     AND D2_CLIENTE = SB6.B6_CLIFOR
	_cQuery += "     AND D2_LOJA = SB6.B6_LOJA
	_cQuery += "     AND D2_COD = SB6.B6_PRODUTO
	_cQuery += "     AND SD2.D_E_L_E_T_ <> '*'
	_cQuery += "     ),0)) SALDO_SAIDA, " 
	
	_cQuery += " B6_SALDO " 
														
	_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1
	/* <BASE> */
	_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC
	_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE
	_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD
	_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE
	_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA
	_cQuery += " AND SB6.B6_IDENT = SD1.D1_IDENTB6
	_cQuery += " AND SB6.D_E_L_E_T_ = ' '
	_cQuery += " AND SD1.D_E_L_E_T_ = ' '
	_cQuery += " AND SB6.B6_FILIAL = '" + cFilGen + "'
	_cQuery += " AND SD1.D1_FILIAL = '" + cFilGen + "'
	_cQuery += " AND SD1.D1_EMISSAO <= '"+DtoS(dDtRef)+"'												
	_cQuery += " AND SB6.B6_TIPO = 'D'
	_cQuery += " AND SB6.B6_TPCF = 'F'
	_cQuery += " AND SB6.B6_PODER3 = 'R'      
	_cQuery += " AND SB6.B6_SALDO > 0
	_cQuery += " AND SB6.B6_PRODUTO = '" + cObra + "'
	_cQuery += " AND SB6.B6_CLIFOR = '" + cCodFor + "'
	_cQuery += " AND SB6.B6_LOJA = '" + cLojfor + "' 
	/* </BASE> */
	
	/* <FILTRA SALDO GEN> */ 
	/* Removi esta validação para permitir utilizar notas com saldo parcialmente balanceado, esta validação permite apenas notas com 100% saldo correto
	_cQuery += " AND (SD1.D1_QUANT-SD1.D1_QTDEDEV) >= B6_SALDO "// VERIFICO SE NÃO HOUVE DEVOLUÇÃO
	_cQuery += " AND B6_SALDO <= (D1_QUANT-( SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2
	_cQuery += "     WHERE D2_FILIAL = SB6.B6_FILIAL
	_cQuery += "     AND SD2.D2_NFORI = SB6.B6_DOC
	_cQuery += "     AND SD2.D2_SERIORI = SB6.B6_SERIE
	_cQuery += "     AND SD2.D2_ITEMORI = D1_ITEM
	_cQuery += "     AND D2_CLIENTE = SB6.B6_CLIFOR
	_cQuery += "     AND D2_LOJA = SB6.B6_LOJA
	_cQuery += "     AND D2_COD = SB6.B6_PRODUTO
	_cQuery += "     AND SD2.D_E_L_E_T_ <> '*'
	_cQuery += "     )) " //VALIDAO SE NÃO HOUVE SAIDA QUE NÃO BAIXOU SB6
	*/
	_cQuery += " AND (D1_QUANT-NVL(( SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2
	_cQuery += "     WHERE D2_FILIAL = SB6.B6_FILIAL
	_cQuery += "     AND SD2.D2_NFORI = SB6.B6_DOC
	_cQuery += "     AND SD2.D2_SERIORI = SB6.B6_SERIE
	_cQuery += "     AND SD2.D2_ITEMORI = D1_ITEM
	_cQuery += "     AND D2_CLIENTE = SB6.B6_CLIFOR
	_cQuery += "     AND D2_LOJA = SB6.B6_LOJA
	_cQuery += "     AND D2_COD = SB6.B6_PRODUTO
	_cQuery += "     AND SD2.D_E_L_E_T_ <> '*'
	_cQuery += "     ),0)) > 0 " //VALIDAO SE NÃO HOUVE SAIDA QUE NÃO BAIXOU SB6
	
	/* </FILTRA SALDO GEN> */
	
	/* <FILTRA SALDO ORIGEM> */
	_cQuery += " AND
	_cQuery += "     NVL((SELECT SUM(B6_SALDO)
	_cQuery += "      FROM "+ RetSqlName("SB6") +" B6_ORI
	_cQuery += "      JOIN "+ RetSqlName("SD2") +" D2_ORI
	_cQuery += "      ON D2_ORI.D2_FILIAL = B6_ORI.B6_FILIAL
	_cQuery += "      AND D2_ORI.D2_DOC = B6_ORI.B6_DOC
	_cQuery += "      AND D2_ORI.D2_SERIE = B6_ORI.B6_SERIE
	_cQuery += "      AND D2_ORI.D2_CLIENTE = B6_ORI.B6_CLIFOR
	_cQuery += "      AND D2_ORI.D2_LOJA = B6_ORI.B6_LOJA
	_cQuery += "      AND D2_ORI.D2_COD = B6_ORI.B6_PRODUTO
	_cQuery += "      AND D2_ORI.D2_IDENTB6 = B6_ORI.B6_IDENT
	_cQuery += "      AND D2_ORI.D_E_L_E_T_ <> '*'
	_cQuery += "      WHERE B6_ORI.B6_FILIAL = '"+cFilOri+"'
	_cQuery += "        AND B6_ORI.B6_DOC = SB6.B6_DOC
	_cQuery += "        AND B6_ORI.B6_SERIE = SB6.B6_SERIE
	_cQuery += "        AND B6_ORI.B6_PRODUTO = SB6.B6_PRODUTO
	_cQuery += "        AND B6_ORI.B6_QUANT = SB6.B6_QUANT
	_cQuery += "        AND B6_ORI.D_E_L_E_T_ = ' ' 
	/* Removi esta validação para permitir utilizar notas com saldo parcialmente balanceado, esta validação permite apenas notas com 100% saldo correto
	_cQuery += "        AND D2_ORI.D2_QUANT - D2_ORI.D2_QTDEDEV >= B6_ORI.B6_SALDO
	_cQuery += "        AND D2_ORI.D2_QUANT - ( SELECT SUM(D1_QUANT) FROM "+ RetSqlName("SD1") +" SD1_ORI WHERE SD1_ORI.D1_FILIAL = D2_ORI.D2_FILIAL AND SD1_ORI.D1_NFORI = D2_ORI.D2_DOC AND SD1_ORI.D1_SERIORI = D2_ORI.D2_SERIE AND SD1_ORI.D1_ITEMORI = D2_ORI.D2_ITEM AND SD1_ORI.D_E_L_E_T_ <> '*') >= B6_ORI.B6_SALDO       
	*/
	_cQuery += "        ),0) > 0 " // VALIDO SALDO ORIGEM EM RELAÇÃO AS NOTAS DE SAIDA DA ORIGEM PARA O GEN        
	/* </FILTRA SALDO ORIGEM> */
	
	_cQuery += " ORDER BY B6_EMISSAO

Else

	_cQuery := " SELECT D1_FILIAL AS B6_FILIAL,D1_DOC AS B6_DOC, D1_QUANT B6_QUANT, "
	_cQuery += " D1_SERIE AS B6_SERIE, D1_ITEM,"
	_cQuery += " ' ' AS B6_IDENT,  "
	_cQuery += " (D1_QUANT - D1_QTDEDEV) AS B6_SALDO, "
		
	_cQuery += " (SELECT SUM(SD2_1.D2_QUANT - SD2_1.D2_QTDEDEV) "
	_cQuery += "   FROM " + RetSqlName("SD2") + " SD2_1 "
	_cQuery += "   WHERE SD2_1.D2_FILIAL = '"+cFilOri+"'
	_cQuery += "   AND SD2_1.D2_DOC      = SD1.D1_DOC "
	_cQuery += "   AND SD2_1.D2_SERIE    = SD1.D1_SERIE "
	_cQuery += "   AND SD2_1.D2_COD      = SD1.D1_COD "
	_cQuery += "   AND SD2_1.D_E_L_E_T_         = ' ') AS SALDO_ORI, "

	_cQuery += " D1_QUANT- "
	_cQuery += "   (SELECT SUM(D2_QUANT) "
	_cQuery += "    FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += "    WHERE D2_FILIAL = SD1.D1_FILIAL "
	_cQuery += "      AND SD2.D2_NFORI = SD1.D1_DOC "
	_cQuery += "      AND SD2.D2_SERIORI = SD1.D1_SERIE "
	_cQuery += "      AND SD2.D2_ITEMORI = SD1.D1_ITEM "
	_cQuery += "      AND D2_CLIENTE = SD1.D1_FORNECE "
	_cQuery += "      AND D2_LOJA = SD1.D1_LOJA "
	_cQuery += "      AND D2_COD = SD1.D1_COD "
	_cQuery += "      AND SD2.D_E_L_E_T_ <> '*' ) SALDO_SAIDA "
		
	_cQuery += " FROM " + RetSqlName("SD1") + " SD1 "
	_cQuery += " WHERE SD1.D1_FILIAL  = '" + cFilGen + "' "
	_cQuery += " AND (D1_QUANT - D1_QTDEDEV)  > 0 "
	_cQuery += " AND SD1.D1_COD = '" + cObra + "' "
	_cQuery += " AND SD1.D1_FORNECE = '" + cCodFor + "' "
	_cQuery += " AND SD1.D1_LOJA    = '" + cLojfor + "' "
	_cQuery += " AND SD1.D1_DOC NOT IN ('000000035','000000036','000000037','000000038') "
	_cQuery += " AND SD1.D1_EMISSAO <= '"+DtoS(dDtRef)+"' "	
	_cQuery += " AND 	(D1_QUANT - D1_QTDEDEV) > 0 "
	
	_cQuery += " AND NVL((SELECT MAX(SD2.D2_QUANT - SD2.D2_QTDEDEV) "
	_cQuery += "   FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += "   WHERE SD2.D2_FILIAL	= '"+cFilOri+"' "
	_cQuery += "   AND SD2.D2_DOC		= SD1.D1_DOC "
	_cQuery += "   AND SD2.D2_SERIE		= SD1.D1_SERIE "
	_cQuery += "   AND SD2.D2_COD		= SD1.D1_COD "
	_cQuery += "   AND SD2.D_E_L_E_T_	= ' ' ),0) > 0 "

	_cQuery += " AND (D1_QUANT- "
	_cQuery += "   NVL((SELECT SUM(D2_QUANT) "
	_cQuery += "    FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += "    WHERE D2_FILIAL = SD1.D1_FILIAL "
	_cQuery += "      AND SD2.D2_NFORI = SD1.D1_DOC "
	_cQuery += "      AND SD2.D2_SERIORI = SD1.D1_SERIE "
	_cQuery += "      AND SD2.D2_ITEMORI = SD1.D1_ITEM "
	_cQuery += "      AND D2_CLIENTE = SD1.D1_FORNECE "
	_cQuery += "      AND D2_LOJA = SD1.D1_LOJA "
	_cQuery += "      AND D2_COD = SD1.D1_COD "
	_cQuery += "      AND SD2.D_E_L_E_T_ <> '*' ),0)) > 0 "
	
	_cQuery += " AND SD1.D_E_L_E_T_ <> '*' "												
	_cQuery += " ORDER BY D1_EMISSAO DESC "
	
EndIf

If TcSqlExec(_cQuery) < 0
	cErroSql	:= TCSQLError()
	lRet		:= .F.
	MemoWrite ( _cLogPd + " Fil_" + cFilOri + "_" + STRTRAN(DTOC(ddatabase),"/","_") + "_" + SUBSTR(STRTRAN(Time(),":",""),1,4) + "_ERROSQL_VALIDA_SALDO_"+AllTrim(cObra)+".txt" , cErroSql )
Else 
	cAliSB6	:= GetNextAlias()
	If Select(cAliSB6) > 0
		(cAliSB6)->(DbCloseArea())
	EndIf
	DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), cAliSB6, .F., .T.)	
	lRet	:= .T.
EndIf

If lRet
	(cAliSB6)->(DbGoTop())
	
	If (cAliSB6)->(!EOF())
		While (cAliSB6)->(!EOF())
			
			nSaldo	:= (cAliSB6)->B6_SALDO
				
			If nSaldo > (cAliSB6)->SALDO_SAIDA
				nSaldo := (cAliSB6)->SALDO_SAIDA
			EndIf
			
			If nSaldo > (cAliSB6)->SALDO_ORI
				nSaldo := (cAliSB6)->SALDO_ORI
			EndIf
			
			nSldBal+=nSaldo
			
			If nSaldo > 0
				Aadd(aDocs, { (cAliSB6)->B6_DOC , (cAliSB6)->B6_SERIE , (cAliSB6)->B6_IDENT , (cAliSB6)->D1_ITEM , (cAliSB6)->B6_QUANT , nSaldo } )
			EndIf	
			
			(cAliSB6)->(DbSkip())
		EndDo
	Else
		nSldBal := 0
	EndIf
	
	If Select(cAliSB6) > 0
		(cAliSB6)->(DbCloseArea())
	EndIf
EndIf
	
Return lRet