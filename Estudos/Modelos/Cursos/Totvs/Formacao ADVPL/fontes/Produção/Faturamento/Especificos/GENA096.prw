#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA096   �Autor  �Bruno Parreira      � Data �  08/01/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclusao de pedidos WEB na lista de pedidos a serem        ���
���          � ignorados na importa��o de pedidos. (pedidos duplicados)   ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA096()
Local cPerg := "GENA096"
Local lExist := .F.

If Pergunte(cPerg,.T.)
    lExist := PESQPED(mv_par01)
    
    If lExist
        MsgAlert("Pedido j� foi removido da lista de alertas.","Aten��o")
        Return
    Else    
        If MsgYesNo("Confirma remo��o do pedido "+mv_par01+" da lista de alertas?","Confirma��o")
            REMOVPED(mv_par01)
            msgInfo("Pedido removido com sucesso!","Aten��o")
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