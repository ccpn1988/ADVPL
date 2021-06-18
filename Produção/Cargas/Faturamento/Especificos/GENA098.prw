#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENA098  �Autor  � Bruno Parreira     � Data �  22/06/20   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de CUPOM da rotina de relatorio Comsisao B2B      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA098()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cVldAlt 		:= ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc 		:= ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString		:= "ZZD"

dbSelectArea("ZZD")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Cupons", cVldAlt, cVldExc)

Return()