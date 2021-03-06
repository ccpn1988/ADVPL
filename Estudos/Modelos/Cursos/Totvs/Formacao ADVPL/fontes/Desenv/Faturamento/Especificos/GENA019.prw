#INCLUDE "rwmake.ch"

/*/
Programa: GENA019

Autor: Rafael Leite

Data: 07/06/2015

Descri??o: rotina de calculo da Pr?via da Presta??o de Contas
/*/

User Function GENA019

Private cCadastro := "Presta??o de Cotnas"

//? Monta um aRotina proprio                                            ?

Private aRotina := {	{"Pesquisar"	,"AxPesqui",0,1} ,;
{"Visualizar"	,"AxVisual",0,2} ,;
{"Incluir"		,"AxInclui",0,3} ,;
{"Alterar"		,"AxAltera",0,4} ,;
{"Excluir"		,"AxDeleta",0,5} ,;
{"Calcular"		,'Processa({|| U_GENA019A() },"Processando")',0,3} ,;
{"Excluir Calc"	,'Processa({|| U_GENA019B() },"Processando")',0,5} ,;
{"Rel Quant"	,"U_GENA019C",0,2} ,;
{"Rel Valor"	,"U_GENA019D",0,2} ,;
{"Anali.Saldo"	,"U_GENA057",0,2} ,;
{"Gera Saldo"	,"U_GENA058",0,2} }

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
Local _cFil		:= GetMv("GEN_FAT019") //Cont?m a Filial correta da empresa GEN que ser? realizado as movimenta??es de consigna??o  
Local _cMvTbPr 	:= GetMv("GEN_FAT006") //Cont?m a tabela de pre?o usado no pedido de vendas

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
			MsgStop("Quando presta??o de oferta o TIPO de oferta deve ser informado!")
		Else
			MV_PAR05 := Alltrim(Str(MV_PAR05))
		EndIf	
	Else
		MV_PAR05 := " "			
	EndIf	 
Endif

//Verifica se filial e data j? foram processados
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
	MsgStop("Refer?ncia e Fornecedor j? gravados.")
	Return
Endif

//Query para pegar os TES que ser?o utilizados no processo de consigna??o?
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

_cSQL := " SELECT * FROM (
_cSQL += " SELECT DISTINCT SB1.B1_COD, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_DESC, SB1.B1_UM, SB1.B1_LOCPAD, SB1.B1_MSBLQL
_cSQL += " ,NVL(DA1.DA1_PRCVEN,0) AS VALOR_UNIT,
_cSQL += " (
_cSQL += "     SELECT NVL(SUM(SD2PR.D2_QUANT),0)
_cSQL += "     FROM " + RetSqlName("SD2") + " SD2PR
_cSQL += "     WHERE SD2PR.D2_TES   IN ('" + _cTesPr + "')
_cSQL += "     AND SD2PR.D2_COD     = SB1.B1_COD
_cSQL += "     AND SD2PR.D2_FILIAL  = '" + _cFil + "'
_cSQL += " 	 AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "'
//_cSQL += "     AND SD2PR.D2_XCONSIG = ' '
_cSQL += "     AND SD2PR.D_E_L_E_T_ = ' '
_cSQL += " ) AS VALOR_ORI,
_cSQL += " (
_cSQL += "     SELECT NVL(SUM(SD1SE.D1_QUANT),0)
_cSQL += "     FROM " + RetSqlName("SD1") + " SD1SE
_cSQL += "     WHERE SD1SE.D1_TES   IN ('" + _cTesPr + "')
_cSQL += "     AND SD1SE.D1_COD     = SB1.B1_COD
_cSQL += "     AND SD1SE.D1_FILIAL  = '" + _cFil + "'
_cSQL += " 	 AND SD1SE.D1_DTDIGIT BETWEEN '" + DTOS(FirstDay(MV_PAR01)) + "' AND '" + DTOS(LastDay(MV_PAR01)) + "'
//_cSQL += "     AND SD1SE.D1_XCONSIG = ' '
_cSQL += "     AND SD1SE.D_E_L_E_T_ = ' '
_cSQL += " ) AS VALOR_DEV,
_cSQL += " (
_cSQL += "     SELECT NVL(SUM(SD2CA.D2_QUANT),0)
_cSQL += "     FROM " + RetSqlName("SD2") + " SD2CA
_cSQL += "     WHERE SD2CA.D2_COD     = SB1.B1_COD
_cSQL += "     AND SD2CA.D2_TES   IN ('" + _cTesPr + "')
_cSQL += "     AND SD2CA.D2_FILIAL  = '" + _cFil + "'
_cSQL += "     AND SD2CA.D_E_L_E_T_ = '*'
_cSQL += "     AND SD2CA.D2_XCONSIG = 'S'
_cSQL += " ) AS VALOR_CAN
_cSQL += " FROM " + RetSqlName("SB1") + " SB1

_cSQL += " LEFT JOIN " + RetSqlName("DA1") + " DA1 
_cSQL += " ON DA1.DA1_FILIAL = '" + xFilial("DA1") + "'
_cSQL += " 	 AND DA1.DA1_CODTAB = '"+_cMvTbPr+"'
_cSQL += " 	 AND DA1.DA1_CODPRO = SB1.B1_COD
_cSQL += " 	 AND DA1.D_E_L_E_T_ = ' '

_cSQL += " INNER JOIN " + RetSqlName("SZ4") + " SZ4 ON SB1.B1_XSITOBR = SZ4.Z4_COD
//_cSQL += " AND SZ4.Z4_MSBLQL = '2' //05/01/2016 - Rafael Leite - Retirado, pois todas as obras com venda devem prestar contas.
_cSQL += " 	 AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "'
_cSQL += " 	 AND SZ4.D_E_L_E_T_ = ' '

_cSQL += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'
_cSQL += " AND SB1.D_E_L_E_T_ = ' '
//_cSQL += " AND SB1.B1_ISBN <> ' ' //05/01/2016 - Rafael Leite - Retirado, pois todas as obras com venda devem prestar contas.

_cSQL += " AND SB1.B1_PROC = '"+MV_PAR02+"'
_cSQL += " AND SB1.B1_LOJPROC = '"+MV_PAR03+"'

_cSQL += " )
_cSQL += " WHERE VALOR_ORI <> 0 OR VALOR_DEV <> 0 OR VALOR_CAN <> 0
_cSQL += " ORDER BY B1_PROC, B1_LOJPROC

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
		
		//N?o existe pre?o menor que R$ 0,01
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

MsgInfo("Fim do processamento. Verifique a grava??o dos dados.")

Return    

User Function GENA019B

Local _cPerg   	:= "GENA019A" //N?o alterar o grupo de perguntas da fun??o A para manter o mesmo padr?o.
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
			MsgStop("Quando presta??o de oferta o TIPO de oferta deve ser informado!")
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
	MsgStop("N?o ser? poss?vel efetuar a exclus?o, pois o lote j? foi gerado.")
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
