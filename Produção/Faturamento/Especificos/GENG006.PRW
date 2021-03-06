#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENG006 �Autor  � Joni Fujiyama       � Data �  01/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para emitir uma mensagem caso transportadora esteja ���
���          � com o campo fornecedor em branco.				   	           ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//************************************************************************************************//
User Function GENG006()
//************************************************************************************************//

Local aArea	:= GetArea()
Local aAreaSA4	:= SA4->(GetArea())
Local lRet 	:= .T.
Local cCodCorreio := GetMv("MV_XCORREI")

//Verifica se o Tipo de Frete � CIF 
IF M->C5_TPFRETE == "C"
	
	DBSELECTAREA("SA4")
	DBSETORDER(1)
	
	// Busca a Transportadora
	IF DBSEEK ( XFILIAL("SA4") + M->C5_TRANSP )
	
		// Verifica se o campo de fornecedor est� preenchido	
		IF EMPTY ( SA4->A4_XFORNEC )
		
			ALERT ( "Esta transportadora n�o possui Fornecedor" )
	
		ENDIF
		
	ELSE
	
		ALERT ( "Esta transportadora n�o est� cadastrada" )
	
	ENDIF
	
ENDIF

GETDREFRESH()

RestArea(aAreaSA4)
RestArea(aArea)

Return lRet
