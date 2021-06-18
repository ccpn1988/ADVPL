#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA069   �Autor  �Cleuto Lima         � Data �  20/09/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega natureza no pedido                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA069(cTesFilho)

Local aAreaSF4	:= SF4->(GetArea())
Local cRet		:= M->C5_NATUREZ

Default cTesFilho	:= ""

If !("SCHEDULE" $ Upper(GetEnvServer()))
	
	If Empty(cTesFilho)
		Return cRet
	EndIf
	
	cRet	:= Posicione("SF4",1,xFilial("SF4")+cTesFilho,"F4_XTESPAI")
	cRet	:= Posicione("SF4",1,xFilial("SF4")+cRet,"F4_XNATURE")
	
	RestArea(aAreaSF4)
	
	If !Empty(M->C5_NATUREZ) .AND. AllTrim(M->C5_NATUREZ) <> AllTrim(cRet)
		If !MsgYesNo("A natureza para a TES informada � diferente da TES do Pedido, deseja alterar a natureza atual para natureza da TES: "+cRet+"?")
			Return M->C5_NATUREZ
		EndIf
	EndIf
	
	M->C5_NATUREZ	:= cRet
	If Type("oGetPV") == "O"
		oGetPV:Refresh()
	EndIf
EndIf

Return cRet
