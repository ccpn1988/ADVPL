#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA007   ºAutor  ³ Joni Fujiyama      º Data ³  21/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mensagem de motivo de bloqueio na rotina Liberacao de Pedidoº±±
±±º          ³por Regra                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA007()

Local _aArea	:= GetArea()
Local _aAreaSA1	:= GetArea("SA1")
Local _nValMin	:= SuperGetMv( "MV_XVALMIN" , , 1000.00 )
Local _cCanal		:= SuperGetMv( "MV_XCANAL" , ,"1/2" )
//Local _cAlias1	:= GetNextAlias()
Local _cAlias2	:= GetNextAlias()
Local _cAlias3	:= GetNextAlias()
Local _cSQL := ""
Local _cMotivo := ""

/*
//Selecao do valor total do pedido
_cSQL := "SELECT SUM(C6_VALOR) AS C6_TOTAL "
_cSQL += "FROM " + RetSQLName("SC6") + " SC6 "
_cSQL += "WHERE SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
_cSQL += "AND SC6.C6_NUM = '" + SC5->C5_NUM + "' "
_cSQL += "AND SC6.D_E_L_E_T_ <> '*' "

_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias1) New
*/

//Selecao para verificar se existe algum item com a TES que contemple o Valor Mínimo
_cSQL := "SELECT F4_XVALMIN,C6_NUM,C6_FILIAL,( SELECT SUM(T.C6_VALOR) FROM " + RetSQLName("SC6") + " T WHERE T.C6_FILIAL = SC6.C6_FILIAL AND T.C6_NUM = SC6.C6_NUM AND T.D_E_L_E_T_ <> '*' ) C6_TOTAL  "
_cSQL += "FROM " + RetSQLName("SF4") + " SF4, " + RetSQLName("SC6") + " SC6 "
_cSQL += "WHERE SF4.F4_FILIAL = '" + xFilial("SF4") + "' "
_cSQL += "AND SF4.F4_XVALMIN = 'S' "
_cSQL += "AND SF4.F4_CODIGO = SC6.C6_TES "
_cSQL += "AND SF4.D_E_L_E_T_ <> '*' "
_cSQL += "AND SC6.C6_FILIAL = '" + xFilial("SC6") + "' "
_cSQL += "AND SC6.C6_NUM = '" + SC5->C5_NUM + "' "
_cSQL += "AND SC6.D_E_L_E_T_ <> '*' "
_cSQL += "GROUP BY F4_XVALMIN,C6_NUM,C6_FILIAL "

_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias2) New


_cSQL := "SELECT C6_ITEM, C6_PRODUTO, C6_DESCONT, Z2_PERCDES, C6_XDESCON
_cSQL += " FROM "+RetSqlName("SC6")+" C6
_cSQL += " JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND C6_PRODUTO = B1_COD
_cSQL += " JOIN "+RetSqlName("SA1")+" A1 ON A1_FILIAL = '"+xFilial("SA1")+"' AND C6_CLI = A1_COD AND C6_LOJA = A1_LOJA
_cSQL += " JOIN "+RetSqlName("SZ2")+" Z2 ON Z2_FILIAL = '"+xFilial("SZ2")+"' AND A1_XTPDES = Z2_TIPO AND B1_GRUPO = Z2_CLASSE
_cSQL += " WHERE C6_FILIAL = '"+SC5->C5_FILIAL+"' "  
_cSQL += " AND C6_NUM = '"+SC5->C5_NUM+"'
_cSQL += " AND C6.D_E_L_E_T_ <> '*' 
_cSQL += " AND B1.D_E_L_E_T_ <> '*' 
_cSQL += " AND A1.D_E_L_E_T_ <> '*'  
_cSQL += " AND Z2.D_E_L_E_T_ <> '*' 
_cSQL += " AND (C6_DESCONT+C6_XDESCON) <> Z2_PERCDES
TcQuery _cSQL Alias (_cAlias3) New

//Pesquisa cliente
If SC5->C5_CLIENTE+SC5->C5_LOJACLI <> SA1->A1_COD+SA1->A1_LOJA
	SA1->(DbSetOrder(1))
	SA1->(DBSEEK(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
EndIf

IF SC5->C5_CLIENTE+SC5->C5_LOJACLI == SA1->A1_COD+SA1->A1_LOJA 
	
	//Verifica condicao de pagamento
	IF SA1->A1_COND <> SC5->C5_CONDPAG
		_cMotivo += "Condicao de pagamento do pedido diferente do cadastro do cliente."+chr(13)+chr(10)
	Endif
	
	//Verifica frete do cliente
	IF SA1->A1_TPFRET <> SC5->C5_TPFRETE .and. SA1->A1_TPFRET == 'F'
	
		_cMotivo += "Frete do pedido diferente do cadastro do cliente."+chr(13)+chr(10)
	Endif
	
	//Verifica desconto do item do pedido
	While !(_cAlias3)->(EOF())
		_cMotivo += "Desconto concedido ("+cValTochar((_cAlias3)->C6_DESCONT+(_cAlias3)->C6_XDESCON)+"%) diverge do cadastro do cliente para este produto ("+cValTochar((_cAlias3)->Z2_PERCDES)+"%). Item "+(_cAlias3)->C6_ITEM+"."+chr(13)+chr(10)
		(_cAlias3)->(DbSkip())
	EndDo
	
	
	//Verifica se o pedido esta abaixo do valor minimo
	IF _nValMin > (_cAlias2)->C6_TOTAL .AND. (_cAlias2)->F4_XVALMIN == "S".AND. ALLTRIM(SA1->A1_XCANALV) $ _cCanal
		_cMotivo += "Pedido abaixo do valor mínimo (R$ " + cValToChar(_nValMin) + ")"+chr(13)+chr(10)
	ELSE
		BlqRegBrw()
	ENDIF
	
	If Empty(_cMotivo) .AND. SC5->C5_BLQ == "3"
		_cMotivo += "Pedido Bloqueado por regra de consignação!"+chr(13)+chr(10)
	EndIf
	
	If !Empty(_cMotivo)
		//Alert(_cMotivo)
		xMagHelpFis("Bloquei de Regra",_cMotivo,"Verifique os erros apontados!")
	EndIf
Else
	Alert("ERRO NO POSICIONAMENTO DO CADASTRO DE CLIENTES!!!")
	BlqRegBrw()
Endif

(_cAlias2)->(DbCloseArea())
//(_cAlias1)->(DbCloseArea())
(_cAlias3)->(DbCloseArea())

RestArea(_aAreaSA1)
RestArea(_aArea)

Return

