#INCLUDE "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103TRV  �Autor  �cleuto Lima         � Data �  08/01/20   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada implementado na fun��o A103TRAVA para      ���
���          �melhorar o tempo de LOCK de registros das tabelas           ���
���          �SA1/SA2/SB2 na inclus�o do documento de entrada.            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103TRV()

Local aRet := ARRAY(4)

aRet1 := .F. //Desliga trava da tabela SA1
aRet2 := .F. //Desliga trava da tabela SA2
aRet3 := .F. //Desliga trava da SB2
aRet4 := .T. //Atualiza os Acumulados somente no final da gravação dos itens da NFE

Return aRet