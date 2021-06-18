#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GenTmp2   � Autor � Danilo Azevedo     � Data �  29/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Importacao de tabela de Tipo Cliente.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENTMP2()

cQry := "SELECT * FROM TIPOCLIENTE WHERE IDTIPOCLIENTE > 0 AND ATIVO = 1 ORDER BY IDTIPOCLIENTE"
cAlias := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)

dbSelectArea("SX5")
dbSetOrder(1)
Do While !(cAlias)->(eof())
	
	If dbSeek(xFilial("SX5")+"TP"+strzero((cAlias)->IDTIPOCLIENTE,3))
		RecLock("SX5",.F.)
	Else
		RecLock("SX5",.T.)
		SX5->X5_FILIAL := xFilial("SX5")
		SX5->X5_TABELA := "TP"
		SX5->X5_CHAVE := strzero((cAlias)->IDTIPOCLIENTE,3)
	Endif
	SX5->X5_DESCRI := (cAlias)->DESCRICAO
	SX5->X5_DESCSPA := (cAlias)->DESCRICAO
	SX5->X5_DESCENG := (cAlias)->DESCRICAO
	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
