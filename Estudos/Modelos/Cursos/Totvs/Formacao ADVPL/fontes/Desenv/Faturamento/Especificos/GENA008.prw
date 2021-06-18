#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA008   ºAutor  ³ Joni Fujiyama      º Data ³  16/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se pedido está abaixo do valor mínimo				 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA008()

Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())
Local _nValMin	:= SuperGetMv( "MV_XVALMIN" , , 1000.00 )
Local _cCanal	:= SuperGetMv( "MV_XCANAL" , ,"1/2" )
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cSQL		:= ""

//Selecio valor total do pedido
_cSQL := "SELECT SUM(C6_VALOR) AS C6_TOTAL "
_cSQL += "FROM " + RetSQLName("SC6") + " SC6 "
_cSQL += "WHERE SC6.C6_FILIAL = " + ValtoSQL(xFilial("SC6")) + " "
_cSQL += "AND SC6.C6_NUM = " + ValToSQL(SC5->C5_NUM) + " "
_cSQL += "AND SC6.D_E_L_E_T_ = '' " 

//_cAlias1 := GetNextAlias()
_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias1) New 

//Selecao para verificar se existe algum item com a TES que contemple o Valor Mínimo
_cSQL := "SELECT DISTINCT F4_XVALMIN "
_cSQL += "FROM " + RetSQLName("SF4") + " SF4, " + RetSQLName("SC6") + " SC6 "
_cSQL += "WHERE SF4.F4_FILIAL = " + ValtoSQL(xFilial("SF4")) + " "
_cSQL += "AND SF4.F4_XVALMIN = 'S' "
_cSQL += "AND SF4.F4_CODIGO = SC6.C6_TES "
_cSQL += "AND SF4.D_E_L_E_T_ = '' "
_cSQL += "AND SC6.C6_FILIAL = " + ValtoSQL(xFilial("SC6")) + " "
_cSQL += "AND SC6.C6_NUM = " + ValToSQL(SC5->C5_NUM) + " "
_cSQL += "AND SC6.D_E_L_E_T_ = '' "

_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias2) New

//Verifica se pedido está abaixo do valor mínimo

IF _nValMin > (_cAlias1)->C6_TOTAL .AND. (_cAlias2)->F4_XVALMIN == "S"

	//Pesquisa cliente
	SA1->(DbSetOrder(1))
	IF SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
		//Verifica canal do cliente
		IF ALLTRIM(SA1->A1_XCANALV) $ _cCanal

			RecLock("SC5",.F.)
				SC5->C5_BLQ := "1"
			MsUnlock()
	        
			//Posiciona itens do pedido
			SC6->(DBSETORDER(1))
			IF SC6->(DBSEEK(XFILIAL("SC6") + SC5->C5_NUM))
				
				//Percorre todos os itens do pedido
				WHILE (XFILIAL("SC6") + SC5->C5_NUM) = (SC6->C6_FILIAL + SC6->C6_NUM)
			
					RecLock("SC6",.F.)
						SC6->C6_BLOQUEI := "01"
					MsUnlock()
			
					SC6->(DBSKIP())
				ENDDO
			
			ELSE
				MsgStop("M410STTS - Item de pedido não encontrado => " + XFILIAL("SC6") + SC6->C6_NUM + SC6->C6_ITEM )
			ENDIF					
		ENDIF

	ELSE
		MsgStop("M410STTS - Cliente não encontrado => " + XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI )
	ENDIF
ENDIF

(_cAlias2)->(DbCloseArea())
(_cAlias1)->(DbCloseArea())

RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSA1)

Return 
