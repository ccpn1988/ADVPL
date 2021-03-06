#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENG004  �Autor  � Joni Fujiyama       � Data �  30/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que inclui a transportadora caso o tipo de frete   ���
���          �for igual CIF.													 ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//************************************************************************************************//
User Function GENG004()
//************************************************************************************************//

Local aArea	:= GetArea()
Local aAreaSA1	:= GetArea("SA1")
Local aAreaSA4	:= GetArea("SA4")
Local lRet 	:= .T.

// Verifica se o Frete � do Tipo CIF
IF M->C5_TPFRETE == "C"

	DBSELECTAREA("SA1")
	DBSETORDER(1)
	
	// Busca o cliente 
	IF DBSEEK ( XFILIAL ( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI )
	
		DBSELECTAREA("SA4")
		DBSETORDER(1)		
		
		// Verifica se o campo da transportadora est� vazio
		IF !EMPTY(SA1->A1_TRANSP)

			// Busca a transportadora
			IF DBSEEK ( XFILIAL ( "SA4" ) + SA1->A1_TRANSP )
		
				M->C5_TRANSP := A4_COD
			
			ELSE
		
				MSGBOX("Transportadora n�o cadastrada")
		
			ENDIF

		ELSE
		
			MSGBOX("O campo transportadora est� em branco")
		
		ENDIF
				
	ELSE
	
		MSGBOX("Cliente n�o cadastrado")
		
	ENDIF

ENDIF

GETDREFRESH()

RestArea(aAreaSA4)
RestArea(aAreaSA1)
RestArea(aArea)

Return lRet
