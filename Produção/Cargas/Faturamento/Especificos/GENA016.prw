#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA016   � Autor � Danilo Azevedo     � Data �  29/01/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para atualizar campos no cabecalho do Pedido de     ���
���          � Vendas (SC5)                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Ponto de Entrada M410STTS (Apos gravar pedido de venda)    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA016()

Local cAlias := GetNextAlias()

Local cQry := "SELECT SUM(C6_QTDVEN) QTD, SUM(C6_PRCVEN*C6_QTDVEN) VLRTOT, SUM(C6_QTDVEN*B1_PESO) PLIQ
cQry += " FROM "+RetSqlName("SC6")+" C6
cQry += " JOIN "+RetSqlName("SB1")+" B1 ON C6_FILIAL = '"+xFilial("SC6")+"'
cQry += " AND B1_FILIAL = '"+xFilial("SB1")+"' AND C6_PRODUTO = B1_COD
cQry += " WHERE C6_NUM = '"+SC6->C6_NUM+"'
cQry += " AND C6.D_E_L_E_T_ = ' '
cQry += " AND B1.D_E_L_E_T_ = ' '
TcQuery cQry Alias (cAlias) New

RecLock("SC5",.F.)
SC5->C5_PESOL := (cAlias)->PLIQ
SC5->C5_XQTDTOT := (cAlias)->QTD
SC5->C5_XVALTOT := (cAlias)->VLRTOT
MsUnlock()

(cAlias)->(dbCloseArea())

Return()
