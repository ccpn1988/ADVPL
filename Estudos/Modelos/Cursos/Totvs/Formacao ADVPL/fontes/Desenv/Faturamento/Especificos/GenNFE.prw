#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GenNFE    � Autor � Danilo Azevedo     � Data �  26/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para filtrar dados da tabela SF2 antes de executar  ���
���          � a rotina padrao SPEDNFE no menu NFE SEFAZ.                 ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
//ALTERA��ES
08/06/2015 - Rafael Leite - Alterado fonte para servir como fun��o de impress�o da DANFE. Esta rotina trabalha em conjunto com o fonte FISFILNFE
para gerar um menu somente de impress�o do DANFE.

/*/

User Function GenNFE()

SPEDNFE() //EXECUTAO FUNCAO ORIGINAL DO MENU NFE SEFAZ

Return()
