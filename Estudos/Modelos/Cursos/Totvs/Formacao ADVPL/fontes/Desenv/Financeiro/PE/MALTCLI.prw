#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MALTCLI   � Autor � Danilo Azevedo     � Data �  28/04/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada apos atualizacao de cliente.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Cadastro de Clientes                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MALTCLI()

If upper(alltrim(GetEnvServer())) $ "PRODUCAO-DANILO"
	U_LIBCLI(Empty(SA1->A1_XCODOLD)) //EXECUTA ROTINA PARA ATUALIZAR O CADASTRO
Endif


//����������������������������������������������������������������Ŀ
//�Verifica se o cliente existe na tabela de autores e em existindo�
//�muda o tipo de clientes para autor.                             �
//������������������������������������������������������������������
U_GENA045C()

Return()
