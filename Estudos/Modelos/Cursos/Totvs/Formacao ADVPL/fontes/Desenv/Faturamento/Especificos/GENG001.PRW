#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENG001  �Autor  � Joni Fujiyama       � Data �  16/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa contendo alguns gatilhos do Pedido de Venda.	      ���
���          �								                              ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Par�metros:
_cOpcao:	1=Peso / 2=Quantidade / 3=Peso
*/

//************************************************************************************************//
User Function GENG001(_cOpcao)
//************************************************************************************************//

Local aArea	:= GetArea()
Local lAmbSch := upper(alltrim(GetEnvServer())) $ "SCHEDULE" //ambiente Schedule


If _cOpcao = "1" //Peso
	M->C5_PESOL := U_GENG002(_cOpcao)
ElseIf _cOpcao = "2" //Quantidade
	
	If ! lAmbSch // 06/02/2015 - Rafael Leite - Nao executa no ambiente Schedule
		M->C5_XQTDTOT := U_GENG002(_cOpcao)
	Endif
Else //Preco 

	If ! lAmbSch // 06/02/2015 - Rafael Leite - Nao executa no ambiente Schedule
		M->C5_XVALTOT := U_GENG002(_cOpcao)
	Endif
ENDIF

GETDREFRESH()
RestArea(aArea)

Return()
