#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENA050  �Autor  � Renato Calabro'    � Data �  07/11/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de rotina da tabela ZZ6 - blacklist de clientes   ���
���          � que devem ter seus pedidos de venda liberados              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA050()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt 		:= ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc 		:= ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString		:= "ZZ6"

dbSelectArea("ZZ6")
dbSetOrder(1)

AxCadastro(cString, "Blacklist de clientes de PVs bloqueados", cVldAlt, cVldExc)

Return()
