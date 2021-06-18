#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

User Function GENA014()

Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())
//Local _nValMin	:= SuperGetMv( "MV_XVALMIN" , , 1000.00 )
//Local _cCanal	:= SuperGetMv( "MV_XCANAL" , ,"1/2" )
Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cSQL		:= ""

//Selecio valor total do pedido
_cSQL := "SELECT A1_COND, A1_TPFRET "
_cSQL += "FROM " + RetSQLName("SA1") + " SA1 "
_cSQL += "WHERE SA1.A1_FILIAL = " + ValtoSQL(xFilial("SA1")) + " "
_cSQL += "AND SA1.A1_COD = " + ValToSQL(SC5->C5_CLIENTE) + " "
_cSQL += "AND SA1.A1_LOJA = " + ValToSQL(SC5->C5_LOJACLI) + " "
_cSQL += "AND SA1.D_E_L_E_T_ = '' " 

_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias1) New 

//Verifica condicao de pagamento
If (_cAlias1)->A1_COND <> SC5->C5_CONDPAG .or. ((_cAlias1)->A1_TPFRET <> SC5->C5_TPFRETE .and. (_cAlias1)->A1_TPFRET == 'F') //(_cAlias1)->A1_TPFRET <> SC5->C5_TPFRETE 

	If RecLock("SC5",.F.)
		SC5->C5_BLQ := "1"
		SC5->(MsUnlock())
	Else
		MsgStop("GENA014 - 1 - Falha no reclock da tabela SC5. Atencao o blqueio de regra nao está funcionando. Informe o administrador do sistema.") 
	Endif
		        
	//Posiciona itens do pedido
	SC6->(DBSETORDER(1))
	IF SC6->(DBSEEK(XFILIAL("SC6") + SC5->C5_NUM))
	
		//Percorre todos os itens do pedido
		WHILE (XFILIAL("SC6") + SC5->C5_NUM) = (SC6->C6_FILIAL + SC6->C6_NUM)
	
			If RecLock("SC6",.F.)
				SC6->C6_BLOQUEI := "01"
				SC6->(MsUnlock())
			Else
				MsgStop("GENA014 - 2 - Falha no reclock da tabela SC6. Atencao o blqueio de regra nao está funcionando. Informe o administrador do sistema.") 
			Endif
	
			SC6->(DBSKIP())
		ENDDO
	
	ELSE
		MsgStop("GENA014 - 3 - Item de pedido não encontrado => " + XFILIAL("SC6") + SC6->C6_NUM + SC6->C6_ITEM )
	ENDIF					
ENDIF

(_cAlias1)->(DbCloseArea())

RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSA1)

Return 