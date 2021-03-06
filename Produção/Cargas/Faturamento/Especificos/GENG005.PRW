#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENG005 �Autor  � Joni Fujiyama       � Data �  30/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que verifica se a transportadora est� bloqueada,	  ���
���          �se existe o fornecedor na transportadora.                   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENG005()

Local aArea	:= GetArea()
Local aAreaSA4	:= SA4->( GetArea() )
Local lRet 	:= .T.

lAmbPrd := upper(alltrim(GetEnvServer())) $ "PRODUCAO-" //ambientes de "producao"

DBSELECTAREA("SA4")
DBSETORDER(1)

If lAmbPrd
	
	//Busca a Transportadora
	If dbSeek(XFILIAL("SA4")+M->C5_TRANSP)
		// Verifica se a transportadora est� bloqueada
		If FieldPos("A4_MSBLQL") > 0 .and. SA4->A4_MSBLQL = "1"
			MSGBOX("Transportadora Bloqueada","Aten��o")
			lRet := .F.
		Else
			// Verifica se a ipo de frete e CIF
			IF M->C5_TPFRETE == "C"
				// Verifica se o campo Fornecedor na Transportadora est� vazio
				IF EMPTY(SA4->A4_XFORNEC)
					MSGBOX("A transportadora selecionada est� cadastrada sem c�digo de fornecedor. Quando o pedido de venda tem frete tipo CIF � obrigat�rio que a transportadora esteja cadastrada com um fornecedor.")
					lRet := .F.
				ENDIF
			Endif
		ENDIF
	ELSE
		MSGBOX("Transportadora n�o cadastrada")
		lRet := .F.
	ENDIF

Endif

GETDREFRESH()

RestArea(aAreaSA4)
RestArea(aArea)

Return lRet
