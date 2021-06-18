#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA096   ºAutor  ³Bruno Parreira      º Data ³  08/01/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclusao de pedidos WEB na lista de pedidos a serem        º±±
±±º          ³ ignorados na importação de pedidos. (pedidos duplicados)   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA096()
Local cPerg := "GENA096"
Local lExist := .F.

If Pergunte(cPerg,.T.)
    lExist := PESQPED(mv_par01)
    
    If lExist
        MsgAlert("Pedido já foi removido da lista de alertas.","Atenção")
        Return
    Else    
        If MsgYesNo("Confirma remoção do pedido "+mv_par01+" da lista de alertas?","Confirmação")
            REMOVPED(mv_par01)
            msgInfo("Pedido removido com sucesso!","Atenção")
        EndIf
    EndIf
EndIf

Return

Static Function PESQPED(cPedido)
Local lRet := .F.
Local cQuery := ""

cQuery += "select NUMERO from DBA_EGK.RETIRAR_PEDIDO_WEB "
cQuery += "where NUMERO = "+cPedido+" "
cQuery += "UNION ALL "
cQuery += "select NUMERO from DBA_EGK.RETIRAR_DA_LISTA "
cQuery += "where NUMERO = "+cPedido+" "

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TRB->(DbGoTop())

If TRB->(!EOF())
    lRet := .T.
EndIf

Return lRet

Static Function REMOVPED(cPedido)
Local cInsert := ""

cInsert := "insert into DBA_EGK.RETIRAR_PEDIDO_WEB(NOME_DA_LISTA,NUMERO,USUARIO,DATA_INC) VALUES ('PEDIDO_WEB',"+cPedido+",'"+cUserName+"','"+DtoS(dDataBase)+"')"

BEGIN TRANSACTION 
    If (TCSqlExec(cInsert) < 0)
        MsgStop("TCSQLError() " + TCSQLError())
    EndIf
END TRANSACTION	

cInsert := "insert into DBA_EGK.RETIRAR_DA_LISTA(NOME_DA_LISTA,NUMERO,USUARIO,DATA_INC) VALUES ('TT_I32_PEDIDOS_SERVICO',"+cPedido+",'"+cUserName+"','"+DtoS(dDataBase)+"')"

BEGIN TRANSACTION 
    If (TCSqlExec(cInsert) < 0)
        MsgStop("TCSQLError() " + TCSQLError())
    EndIf
END TRANSACTION	

Return