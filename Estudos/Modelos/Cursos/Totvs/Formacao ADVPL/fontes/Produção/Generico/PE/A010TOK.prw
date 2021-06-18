#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010Tok   � Autor � Danilo Azevedo     � Data �  10/06/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na inclusao/alteracao do cadastro de pro- ���
���          � dutos (SB1) para validar obrigatoriedade de campos.        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Cadastro de produtos                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A010TOK()

lRet := .T.

If Empty(M->B1_CC) .and. (M->B1_CONTA >= "3" .and. M->B1_CONTA < "5")
	lRet := .F.
	MsgBox("� necess�rio preencher o campo "+alltrim(Posicione("SX3",2,"B1_CC","X3_TITULO"))+" quando a Conta Cont�bil iniciar com 3 ou 4.","Aten��o")
Endif

If M->B1_CONTA = "11030201" .and. (empty(M->B1_ITEMCC) .or. empty(M->B1_CLVL))
	lRet := .F.
	MsgBox("� necess�rio preencher os campos "+alltrim(Posicione("SX3",2,"B1_ITEMCC","X3_TITULO"))+" e "+alltrim(Posicione("SX3",2,"B1_CLVL","X3_TITULO"))+" quando a Conta Cont�bil iniciar com 3 ou 4.","Aten��o")
Endif

Return(lRet)
