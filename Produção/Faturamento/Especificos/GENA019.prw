#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*/
Programa: GENA019

Autor: Rafael Leite

Data: 07/06/2015

Descrição: rotina de calculo da Prévia da Prestação de Contas
/*/

User Function GENA019

Private cCadastro := "Prestação de Contas"

//³ Monta um aRotina proprio                                            ³

Private aRotina := {	{"Pesquisar"	,"AxPesqui",0,1} ,;
{"Visualizar"	 ,"AxVisual",0,2} ,;
{"Incluir"		 ,"AxInclui",0,3} ,;
{"Alterar"		 ,"AxAltera",0,4} ,;
{"Excluir"		 ,"AxDeleta",0,5} ,;
{"1-Calcular"	 ,'Processa({|| U_GENA019A() },"Processando...")',0,3} ,;
{"Ajusta Prestacao",'Processa({|| U_GENA019G() },"Processando...")',0,2} ,;
{"2-Anali.Saldo" ,"U_GENA057",0,2} ,;
{"3-Gera Saldo"	 ,"U_GENA058",0,2} ,;
{"Compatibilizar",'Processa({|| U_GENA019H() },"Processando...")',0,2} ,;
{"4-Bkp 1Âª Parte",'Processa({|| U_GENA019E() },"Processando...")',0,2} ,;
{"Rel Quant"	 ,"U_GENA019C",0,2} ,;
{"Rel Valor"	 ,"U_GENA019D",0,2} ,;
{"Excluir Calc"	 ,'Processa({|| U_GENA019B() },"Processando...")',0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZA"

dbSelectArea(cString)
dbSetOrder(1)

mBrowse( 6,1,22,75,cString)

Return

User Function GENA019A

Local _cPerg   	:= "GENA019A"
Local _cSQL
Local _cAlias1 	:= GetNextAlias()
Local _cAlias2 	:= GetNextAlias() 
Local _cAlias3 	:= GetNextAlias() 
Local _cTesPr  
Local _cFil		:= GetMv("GEN_FAT019") //Contém a Filial correta da empresa GEN que será realizado as movimentações de consignação  
Local _cMvTbPr 	:= GetMv("GEN_FAT006") //Contém a tabela de preço usado no pedido de vendas

/*
U_xGPutSx1(_cPerg, "01", "Referencia"	, ".", ".", "mv_ch1" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "02", "Fornecedor"	, ".", ".", "mv_ch2" , "C", 07, 0, 0, "G","", "SA2_B", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "03", "Loja"      	, ".", ".", "mv_ch3" , "C", 02, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "04", "Tipo"      	, ".", ".", "mv_ch4" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR04","Oferta","Oferta","Oferta","","Venda","Venda","Venda","","","","","","","","","")
U_xGPutSx1(_cPerg, "05", "Tipo Oferta" , ".", ".", "mv_ch5" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR05","Oferta CRM","Oferta CRM","Oferta CRM","","Oferta DA","Oferta DA","Oferta DA","","","","","","","","","")
*/
If !Pergunte(_cPerg,.T.)
	Return
Else
	MV_PAR04 := Alltrim(Str(MV_PAR04))
	
	If MV_PAR04 == "1"
		If Empty(MV_PAR05)
			MsgStop("Quando prestação de oferta o TIPO de oferta deve ser informado!")
		Else
			MV_PAR05 := Alltrim(Str(MV_PAR05))
		EndIf	
	Else
		MV_PAR05 := " "			
	EndIf	 
Endif

//Verifica se filial e data já foram processados
_cSQL := " SELECT Count(ZA_FILIAL) AS CONTADOR
_cSQL += " FROM " + RetSqlName("SZA")
_cSQL += " WHERE ZA_REF = '"+DTOS(LastDay(MV_PAR01))+"'  
_cSQL += " AND ZA_PROC = '"+MV_PAR02+"'
_cSQL += " AND ZA_LOJPROC = '"+MV_PAR03+"'
_cSQL += " AND ZA_TIPO = '"+MV_PAR04+"'
_cSQL += " AND ZA_TPOFER = '"+MV_PAR05+"'
_cSQL += " AND D_E_L_E_T_ = ' '

If Select(_cAlias3) > 0
	dbSelectArea(_cAlias3)
	(_cAlias3)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias3, .F., .T.)

If (_cAlias3)->CONTADOR > 0
	MsgStop("Referência e Fornecedor já gravados.")
	Return
Endif

//Query para pegar os TES que serão utilizados no processo de consignação³
_cSQL := " SELECT F4_CODIGO, F4_XPRCONT, F4_XTPCONT
_cSQL += " FROM " + RetSqlName("SF4") + " SF4
_cSQL += " WHERE F4_XPRCONT = 'S'
_cSQL += " AND F4_XTPCONT = '" + MV_PAR04 + "'
_cSQL += " AND F4_XTPOFER = '" + MV_PAR05 + "'
_cSQL += " AND D_E_L_E_T_ = ' '

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)

_cTesPr := "" //Limpando a variavel

While (_cAlias1)->(!EOF())
	_cTesPr += (_cAlias1)->F4_CODIGO + "','"
	(_cAlias1)->(DbSkip())
EndDo

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

_cTesPr := Substr(_cTesPr,1,Len(_cTesPr)-3)

_cSQL := " SELECT * FROM ( " + CRLF
_cSQL += " SELECT DISTINCT SB1.B1_COD, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_DESC, SB1.B1_UM, SB1.B1_LOCPAD, SB1.B1_MSBLQL " + CRLF
_cSQL += " ,NVL(DA1.DA1_PRCVEN,0) AS VALOR_UNIT, " + CRLF
_cSQL += " ( " + CRLF
_cSQL += "     SELECT NVL(SUM(SD2PR.D2_QUANT),0) " + CRLF
_cSQL += "     FROM " + RetSqlName("SD2") + " SD2PR " + CRLF
_cSQL += "     WHERE SD2PR.D2_TES   IN ('" + _cTesPr + "') " + CRLF
_cSQL += "     AND SD2PR.D2_COD     = SB1.B1_COD " + CRLF
_cSQL += "     AND SD2PR.D2_FILIAL  = '" + _cFil + "' " + CRLF
//_cSQL += " 	 AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "' " + CRLF
_cSQL += " 	 AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' " + CRLF
//_cSQL += "     AND SD2PR.D2_XCONSIG = ' ' " + CRLF
_cSQL += "     AND SD2PR.D_E_L_E_T_ = ' ' " + CRLF
_cSQL += " ) AS VALOR_ORI, " + CRLF
_cSQL += " ( " + CRLF
_cSQL += "     SELECT NVL(SUM(SD1SE.D1_QUANT),0) " + CRLF
_cSQL += "     FROM " + RetSqlName("SD1") + " SD1SE " + CRLF
_cSQL += "     WHERE SD1SE.D1_TES   IN ('" + _cTesPr + "') " + CRLF
_cSQL += "     AND SD1SE.D1_COD     = SB1.B1_COD " + CRLF
_cSQL += "     AND SD1SE.D1_FILIAL  = '" + _cFil + "' " + CRLF
//_cSQL += " 	 AND SD1SE.D1_DTDIGIT BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "' " + CRLF
_cSQL += " 	 AND SD1SE.D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR06) + "' AND '" + DTOS(MV_PAR07) + "' " + CRLF
//_cSQL += "     AND SD1SE.D1_XCONSIG = ' ' " + CRLF
_cSQL += "     AND SD1SE.D_E_L_E_T_ = ' ' " + CRLF
_cSQL += " ) AS VALOR_DEV, " + CRLF
_cSQL += " ( " + CRLF
_cSQL += "     SELECT NVL(SUM(SD2CA.D2_QUANT),0) " + CRLF
_cSQL += "     FROM " + RetSqlName("SD2") + " SD2CA " + CRLF
_cSQL += "     WHERE SD2CA.D2_COD     = SB1.B1_COD " + CRLF
_cSQL += "     AND SD2CA.D2_TES   IN ('" + _cTesPr + "') " + CRLF
_cSQL += "     AND SD2CA.D2_FILIAL  = '" + _cFil + "' " + CRLF
_cSQL += "     AND SD2CA.D_E_L_E_T_ = '*' " + CRLF
_cSQL += "     AND SD2CA.D2_XCONSIG = 'S' " + CRLF
_cSQL += " ) AS VALOR_CAN " + CRLF
_cSQL += " FROM " + RetSqlName("SB1") + " SB1 " + CRLF

_cSQL += " LEFT JOIN " + RetSqlName("DA1") + " DA1 " + CRLF
_cSQL += " ON DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " + CRLF
_cSQL += " 	 AND DA1.DA1_CODTAB = '"+_cMvTbPr+"' " + CRLF
_cSQL += " 	 AND DA1.DA1_CODPRO = SB1.B1_COD " + CRLF
_cSQL += " 	 AND DA1.D_E_L_E_T_ = ' ' " + CRLF

_cSQL += " INNER JOIN " + RetSqlName("SZ4") + " SZ4 ON SB1.B1_XSITOBR = SZ4.Z4_COD " + CRLF
//_cSQL += " AND SZ4.Z4_MSBLQL = '2' //05/01/2016 - Rafael Leite - Retirado, pois todas as obras com venda devem prestar contas.
_cSQL += " 	 AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "' " + CRLF
_cSQL += " 	 AND SZ4.D_E_L_E_T_ = ' ' " + CRLF

_cSQL += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "' " + CRLF
_cSQL += " AND SB1.D_E_L_E_T_ = ' ' " + CRLF
//_cSQL += " AND SB1.B1_ISBN <> ' ' //05/01/2016 - Rafael Leite - Retirado, pois todas as obras com venda devem prestar contas.

_cSQL += " AND SB1.B1_PROC = '"+MV_PAR02+"' " + CRLF
_cSQL += " AND SB1.B1_LOJPROC = '"+MV_PAR03+"' " + CRLF

_cSQL += " ) " + CRLF
_cSQL += " WHERE VALOR_ORI <> 0 OR VALOR_DEV <> 0 OR VALOR_CAN <> 0 " + CRLF
_cSQL += " ORDER BY B1_PROC, B1_LOJPROC "

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf

Memowrite("GENA019_"+MV_PAR04+"_"+cFilAnt+".sql",_cSQL)

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)       

Begin Transaction
	While (_cAlias2)->(!EOF())
		
		_nSaldo := ((_cAlias2)->VALOR_ORI - (_cAlias2)->VALOR_DEV - (_cAlias2)->VALOR_CAN)
		
		_nValUnit := NoRound((_cAlias2)->VALOR_UNIT * 0.5,2)
		
		//Não existe preço menor que R$ 0,01
		If _nValUnit < 0.01 
		
			_nValUnit := 0.01
		Endif  
		
		_nValTot := NoRound(_nSaldo * _nValUnit,2)
		
		Reclock("SZA",.T.)
		SZA->ZA_FILIAL	:= ""  
		SZA->ZA_TIPO   	:= MV_PAR04
		SZA->ZA_TPOFER	:= MV_PAR05
		SZA->ZA_REF    	:= LastDay(MV_PAR01) 
		SZA->ZA_COD    	:= (_cAlias2)->B1_COD
		SZA->ZA_DESC   	:= (_cAlias2)->B1_DESC
		SZA->ZA_LOCPAD 	:= (_cAlias2)->B1_LOCPAD
		SZA->ZA_UM     	:= (_cAlias2)->B1_UM
		SZA->ZA_MSBLQL 	:= (_cAlias2)->B1_MSBLQL
		SZA->ZA_PROC   	:= (_cAlias2)->B1_PROC
		SZA->ZA_LOJPROC	:= (_cAlias2)->B1_LOJPROC
		SZA->ZA_VALORI 	:= (_cAlias2)->VALOR_ORI
		SZA->ZA_VALDEV 	:= (_cAlias2)->VALOR_DEV
		SZA->ZA_VALCAN	:= (_cAlias2)->VALOR_CAN 
		SZA->ZA_SALDO		:= _nSaldo
		SZA->ZA_VALUNI	:= _nValUnit
		SZA->ZA_VALTOT	:= _nValTot
		
		If AllTrim((_cAlias2)->B1_MSBLQL) == "1"
			SZA->ZA_STATUS  := "5"
		Endif             
		
		SZA->(MsUnlock()) 
		
		(_cAlias2)->(DbSkip())
	EndDo  
End Transaction

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf  

MsgInfo("Fim do processamento. Verifique a gravação dos dados.")

Return    

User Function GENA019B

Local _cPerg   	:= "GENA019A" //Não alterar o grupo de perguntas da função A para manter o mesmo padrão.
Local _cSQL
Local _cAlias1 	:= GetNextAlias()
Local _cAlias2 	:= GetNextAlias()

U_xGPutSx1(_cPerg, "01", "Referencia"	, ".", ".", "mv_ch1" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "02", "Fornecedor"	, ".", ".", "mv_ch2" , "C", 07, 0, 0, "G","", "SA2_B", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "03", "Loja"      	, ".", ".", "mv_ch3" , "C", 02, 0, 0, "G","", "", "", "", "MV_PAR03","","","","","","","","","","","","","","","","")
U_xGPutSx1(_cPerg, "04", "Tipo"      	, ".", ".", "mv_ch4" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR04","Oferta","Oferta","Oferta","","Venda","Venda","Venda","","","","","","","","","")
U_xGPutSx1(_cPerg, "05", "Tipo Oferta" , ".", ".", "mv_ch5" , "C", 01, 0, 1, "C","", "", "", "", "MV_PAR05","Oferta CRM","Oferta CRM","Oferta CRM","","Oferta DA","Oferta DA","Oferta DA","","","","","","","","","")

If !Pergunte(_cPerg,.T.)
	Return
Else
	MV_PAR04 := Alltrim(Str(MV_PAR04))
	
	If MV_PAR04 == "1"
		If Empty(MV_PAR05)
			MsgStop("Quando prestação de oferta o TIPO de oferta deve ser informado!")
		Else
			MV_PAR05 := Alltrim(Str(MV_PAR05))
		EndIf	
	Else
		MV_PAR05 := " "			
	EndIf	 
Endif

_cSQL := " SELECT '1' AS CAMPO
_cSQL += " FROM " + RetSQLName("SZA") 
_cSQL += " WHERE ZA_FILIAL = '" + xFilial("SZA") + "' " 
_cSQL += " AND ZA_REF = '" + DtoS(MV_PAR01) + "' " 
_cSQL += " AND ZA_PROC = '" + MV_PAR02 + "' " 
_cSQL += " AND ZA_LOJPROC = '" + MV_PAR03 + "' " 
_cSQL += " AND ZA_TIPO = '" + MV_PAR04 + "' " 
_cSQL += " AND ZA_TPOFER = '"+MV_PAR05+"'
_cSQL += " AND ZA_LOTE <> ' ' " 
_cSQL += " AND D_E_L_E_T_ = ' ' " 

If Select(_cAlias2) > 0
	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias2, .F., .T.)

If (_cAlias2)->CAMPO == '1'
	MsgStop("Não será possível efetuar a exclusão, pois o lote já foi gerado.")
	Return
Endif       

_cSQL := " SELECT R_E_C_N_O_ AS REC
_cSQL += " FROM " + RetSQLName("SZA") 
_cSQL += " WHERE ZA_FILIAL = '" + xFilial("SZA") + "' " 
_cSQL += " AND ZA_REF = '" + DtoS(MV_PAR01) + "' " 
_cSQL += " AND ZA_PROC = '" + MV_PAR02 + "' " 
_cSQL += " AND ZA_LOJPROC = '" + MV_PAR03 + "' " 
_cSQL += " AND ZA_TIPO = '" + MV_PAR04 + "' "
_cSQL += " AND ZA_TPOFER = '"+MV_PAR05+"' 
_cSQL += " AND ZA_LOTE = ' ' " 
_cSQL += " AND D_E_L_E_T_ = ' ' " 

If Select(_cAlias1) > 0
	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cSQL), _cAlias1, .F., .T.)       

Begin Transaction

	While (_cAlias1)->(!EOF())
	
		SZA->(DbGoTo((_cAlias1)->REC))
		
		RecLock("SZA",.F.)
		SZA->(DbDelete())
		SZA->(MsUnlock())
		
		(_cAlias1)->(DbSkip())	
	End        
	
End Transaction 

Return

User Function GENA019E()
Local cQuery := ""
Local cPerg  := "GENA019E"
Local nSql1  := 0
Local nSql2  := 0
Local lRet   := .F.

If !Pergunte(cPerg,.T.)
	Return
EndIf

If MsgYesNo("Confirma backup e exclusão da tabela SZA e ZZ8 Ref. "+DtoC(MV_PAR01)+"?","Confirmação")
	//Realiza backup da SZA
	
	cQuery := "select R_E_C_N_O_ from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' ' and ROWNUM = 1 "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		TRB->(dbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T.)

	DbSelectArea("TRB")

	If !TRB->(EOF())
		nSql1 := TCSQLExec("DROP TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE1")
		nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE1 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")

		If nSql2 < 0
			MsgStop("Falha ao executar o Backup1 da tabela SZA Ref.: "+DTOC(MV_PAR01),"Erro")
			Return
		Else
			lRet := .T.
		EndIf

		nSql1 := TCSQLExec("DROP TABLE BKP.SZA_PARTE1")
		nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_PARTE1 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")

		If nSql2 < 0
			MsgStop("Falha ao executar o Backup2 da tabela SZA Ref.: "+DTOC(MV_PAR01),"Erro")
			Return
		else
			lRet := .T.
		EndIf
	Else
		MsgAlert("Não existe registro na SZA com a Ref. "+DTOC(MV_PAR01),"Atenção!")
	EndIf

	//Realiza backup da ZZ8

	cQuery := "select R_E_C_N_O_ from "+RetSqlName("ZZ8")+" where ZZ8_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' ' and ROWNUM = 1 "

	If Select("TRB") > 0
		dbSelectArea("TRB")
		TRB->(dbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TRB", .F., .T.)

	DbSelectArea("TRB")

	If !TRB->(EOF())
		nSql1 := TCSQLExec("DROP TABLE ZZ8_"+DTOS(MV_PAR01)+"_PARTE1")
		nSql2 := TCSQLExec("CREATE TABLE ZZ8_"+DTOS(MV_PAR01)+"_PARTE1 AS select * from "+RetSqlName("ZZ8")+" where ZZ8_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")

		If nSql2 < 0
			MsgStop("Falha ao executar o Backup da tabela ZZ8 Ref.: "+DTOC(MV_PAR01),"Erro")
			Return
		Else
			lRet := .T.
		EndIf
	Else
		MsgAlert("Não existe registro na ZZ8 com a Ref. "+DTOC(MV_PAR01),"Atenção!")
	EndIf

	If lRet

		cQuery := "select R_E_C_N_O_ As REC "
		cQuery += "from "+RetSqlName("SZA")+" SZA "
		cQuery += "where ZA_REF = '"+DtoS(MV_PAR01)+"' "
		cQuery += "and D_E_L_E_T_ = ' ' "

		If Select("TMP") > 0
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TMP", .F., .T.)       

		DbSelectArea("TMP")

		If TMP->(!EOF())
			Begin Transaction
				While TMP->(!EOF())
					SZA->(DbGoTo(TMP->REC))
					
					RecLock("SZA",.F.)
					SZA->(DbDelete())
					SZA->(MsUnlock())

					TMP->(DbSkip())	
				EndDo
			End Transaction 
		else
			MsgAlert("Não existe nenhum registro SZA para exclusão com essa data de referência.","Atenção!")
			lRet := .F.
		EndIf

		cQuery := "select R_E_C_N_O_ As REC "
		cQuery += "from "+RetSqlName("ZZ8")+" ZZ8 "
		cQuery += "where ZZ8_REF = '"+DtoS(MV_PAR01)+"' "
		cQuery += "and D_E_L_E_T_ = ' ' "

		If Select("TMP") > 0
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TMP", .F., .T.)       

		DbSelectArea("TMP")

		If TMP->(!EOF())
			Begin Transaction
				While TMP->(!EOF())
					DbSelectArea("ZZ8")
					ZZ8->(DbGoTo(TMP->REC))
					
					RecLock("ZZ8",.F.)
					ZZ8->(DbDelete())
					ZZ8->(MsUnlock())

					TMP->(DbSkip())	
				EndDo
			End Transaction 
		else
			MsgAlert("Não existe nenhum registro ZZ8 para exclusão com essa data de referência.","Atenção!")
			lRet := .F.
		EndIf
	EndIf

	If lRet
		MsgInfo("Backup e exclusão Ref. "+DTOC(MV_PAR01)+" finalizado com sucesso!","Aviso")
	EndIf

EndIf

Return

User Function GENA019G()
Local cQuery  := ""
Local _cQry   := ""
Local cPerg   := "GENA019E"
Local aResult1:= {}
Local aResult2:= {}
Local aResult3:= {}
Local nSql1   := 0
Local nSql2   := 0

If !Pergunte(cPerg,.T.)
	Return
else
	If !MsgYesNo("Confirma ajuste da tabela SZA para a segunda prestação Ref.: "+DtoC(MV_PAR01)+"?","Confirmação")
		Return 
	EndIf
EndIf

_cQry := "select R_E_C_N_O_ from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' ' and ROWNUM = 1 "

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry),"TRB", .F., .T.)

DbSelectArea("TRB")

If !TRB->(EOF())

	//Backup SZA Parte 2
	nSql1 := TCSQLExec("DROP TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE2")
	nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE2 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")		

	If nSql2 < 0
		MsgStop("Falha ao executar o Backup1 da tabela SZA PARTE2 Ref.: "+DTOC(MV_PAR01),"Erro")
		Return
	EndIf

	nSql1 := TCSQLExec("DROP TABLE BKP.SZA_PARTE2")		
	nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_PARTE2 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")		

	If nSql2 < 0
		MsgStop("Falha ao executar o Backup2 da tabela SZA PARTE2 Ref.: "+DTOC(MV_PAR01),"Erro")
		Return
	EndIf

	//Executa SPs para ajustar SZA
	aResult1 := TCSPExec("SP_PRESTACAO_AJUSTE1",DtoS(MV_PAR01))
	aResult2 := TCSPExec("SP_PRESTACAO_AJUSTE2",DtoS(MV_PAR01))
	aResult3 := TCSPExec("SP_PRESTACAO_AJUSTE3",DtoS(MV_PAR01))

	MsgInfo("Procedure de ajuste executada. Será executada query de Conferência.","Aviso")

	/* CONFERENCIA, SE RETORNAR RESGITRO Ã‰ PQ O UPDATE FOI FEITO ERRADO */
	cQuery += "SELECT SZA.ZA_SALDO+NVL(B.ZA_SALDO,0) SALDO,C.ZA_SALDO "
	cQuery += "FROM SZA000 SZA "
	cQuery += " JOIN BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE1 B "
	cQuery += "   ON B.ZA_FILIAL = SZA.ZA_FILIAL "
	cQuery += "   AND B.ZA_TIPO = SZA.ZA_TIPO "
	cQuery += "   AND B.ZA_REF = SZA.ZA_REF "
	cQuery += "   AND B.ZA_COD = SZA.ZA_COD "
	cQuery += "   AND B.ZA_LOCPAD = SZA.ZA_LOCPAD "
	cQuery += "   AND B.ZA_UM = SZA.ZA_UM "
	cQuery += "   AND B.ZA_LOJPROC = SZA.ZA_LOJPROC "
	cQuery += "   AND B.ZA_PROC = SZA.ZA_PROC "
	cQuery += "   AND B.ZA_TPOFER = SZA.ZA_TPOFER "
	cQuery += "   AND B.d_e_l_e_t_ <> '*' "
	cQuery += " JOIN BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE2 C "
	cQuery += "   ON C.ZA_FILIAL = SZA.ZA_FILIAL "
	cQuery += "   AND C.ZA_TIPO = SZA.ZA_TIPO "
	cQuery += "   AND C.ZA_REF = SZA.ZA_REF "
	cQuery += "   AND C.ZA_COD = SZA.ZA_COD "
	cQuery += "   AND C.ZA_LOCPAD = SZA.ZA_LOCPAD "
	cQuery += "   AND C.ZA_UM = SZA.ZA_UM "
	cQuery += "   AND C.ZA_LOJPROC = SZA.ZA_LOJPROC "
	cQuery += "   AND C.ZA_PROC = SZA.ZA_PROC "
	cQuery += "   AND C.ZA_TPOFER = SZA.ZA_TPOFER "
	cQuery += "   AND C.d_e_l_e_t_ <> '*' "
	cQuery += "WHERE SZA.d_e_l_e_t_ <> '*' "
	cQuery += "AND SZA.ZA_REF = '"+DTOS(MV_PAR01)+"' "
	cQuery += "AND SZA.ZA_STATUS <> '1' "
	cQuery += "AND B.ZA_STATUS = '1' "
	cQuery += "AND SZA.ZA_SALDO+NVL(B.ZA_SALDO,0) <> C.ZA_SALDO "

	If Select("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery),"TMP", .F., .T.)       

	DbSelectArea("TMP")

	If TMP->(!EOF())
		MsgAlert("Foram encontradas diferenças entre as prestações Ref. "+DTOC(MV_PAR01)+" verifique.","Atenção!")
	Else
		MsgInfo("Dados analisados com sucesso. Sem erros!","Aviso")
	EndIf
Else
	MsgAlert("Não foram encontrados dados na tabela SZA para ajuste.","Atenção")
EndIf

Return

User Function GENA019H()
Local _cQry   := ""
Local cPerg   := "GENA019E"
Local aResult := {}
Local nSql1   := 0
Local nSql2   := 0

If !Pergunte(cPerg,.T.)
	Return
else
	If !MsgYesNo("Confirma ajuste final da tabela SZA Ref.: "+DtoC(MV_PAR01)+"?","Confirmação")
		Return 
	EndIf
EndIf

_cQry := "select R_E_C_N_O_ from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' ' and ROWNUM = 1 "

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry),"TRB", .F., .T.)

DbSelectArea("TRB")

If !TRB->(EOF())
	
	//Backup SZA Parte 2
	nSql1 := TCSQLExec("DROP TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE3")
	nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_"+DTOS(MV_PAR01)+"_PARTE3 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")		

	If nSql2 < 0
		MsgStop("Falha ao executar o Backup1 da tabela SZA PARTE3 Ref.: "+DTOC(MV_PAR01),"Erro")
		Return
	EndIf

	nSql1 := TCSQLExec("DROP TABLE BKP.SZA_PARTE3")		
	nSql2 := TCSQLExec("CREATE TABLE BKP.SZA_PARTE3 AS select * from "+RetSqlName("SZA")+" where ZA_REF = '"+DTOS(MV_PAR01)+"' and D_E_L_E_T_ = ' '")		

	If nSql2 < 0
		MsgStop("Falha ao executar o Backup2 da tabela SZA PARTE3 Ref.: "+DTOC(MV_PAR01),"Erro")
		Return
	EndIf

	//Executa SP para ajustar SZA

	aResult := TCSPExec("SP_PRESTACAO_FINAL",DtoS(MV_PAR01))

	MsgInfo("Procedure de ajuste final executada com sucesso.","Aviso")
Else
	MsgAlert("Não foram encontrados dados na tabela SZA para ajuste.","Atenção")
EndIf

Return