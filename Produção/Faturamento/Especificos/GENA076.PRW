#INCLUDE "Protheus.ch" 
#INCLUDE "TopConn.ch"

#DEFINE CRLF	CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA076  º Autor ³Cleuto Lima          º Data ³  05/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ validação para execução do gatilho de carga de conta       º±±
±±º          ³ contabil.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
				lRet := !MsgYesNo("A TES informada tem uma conta contabil padrão e a conta informada no item '"+AllTrim(GDFieldGet("D1_CONTA"))+"' é diferente da conta contabil da TES '"+AllTrim(SF4->F4_XCONTA)+"', deseja manter a conta '"+AllTrim(GDFieldGet("D1_CONTA"))+"' digitada no item?")
			EndIf
		EndIf
	Else
		lRet := .F.
	EndIf	
EndIf

Return lRet