#INCLUDE "Protheus.ch" 
#INCLUDE "TopConn.ch"

#DEFINE CRLF	CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA076  � Autor �Cleuto Lima          � Data �  05/10/18   ���
�������������������������������������������������������������������������͹��
���Descricao � valida��o para execu��o do gatilho de carga de conta       ���
���          � contabil.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA076()

Local lRet		:= "D1_TES" $ ReadVar() .OR. upper(alltrim(GetEnvServer())) $ "SCHEDULE"
Local nPosCt	:= GDFieldPos("D1_CONTA")

If nPosCt > 0 .AND. "D1_TES" $ ReadVar()
	If Empty(GDFieldGet("D1_CONTA")) .AND. !Empty(AllTrim(SF4->F4_XCONTA))
		lRet := .T.
	ElseIf !Empty(GDFieldGet("D1_CONTA")) .AND. !Empty(AllTrim(SF4->F4_XCONTA))
		If AllTrim(SF4->F4_XCONTA) <> AllTrim(GDFieldGet("D1_CONTA"))
			If upper(alltrim(GetEnvServer())) $ "SCHEDULE"
				lRet := .F.
			Else
				lRet := !MsgYesNo("A TES informada tem uma conta contabil padr�o e a conta informada no item '"+AllTrim(GDFieldGet("D1_CONTA"))+"' � diferente da conta contabil da TES '"+AllTrim(SF4->F4_XCONTA)+"', deseja manter a conta '"+AllTrim(GDFieldGet("D1_CONTA"))+"' digitada no item?")
			EndIf
		EndIf
	Else
		lRet := .F.
	EndIf	
EndIf

Return lRet