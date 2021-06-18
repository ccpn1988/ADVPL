#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA069   ºAutor  ³Cleuto Lima         º Data ³  20/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega natureza no pedido                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		If !MsgYesNo("A natureza para a TES informada é diferente da TES do Pedido, deseja alterar a natureza atual para natureza da TES: "+cRet+"?")
			Return M->C5_NATUREZ
		EndIf
	EndIf
	
	M->C5_NATUREZ	:= cRet
	If Type("oGetPV") == "O"
		oGetPV:Refresh()
	EndIf
EndIf

Return cRet
