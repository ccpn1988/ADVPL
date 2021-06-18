#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA410   ºAutor  ³ Joni Fujiyama      º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que inclui a transportadora caso o tipo de frete   º±±
±±º          ³for igual CIF.											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//************************************************************************************************//
User Function MTA410()
//************************************************************************************************//

Local aArea		:= GetArea()
Local lRet 		:= .T.
Local lAtivaVld	:= GetMv("GEN_FAT238",.f.,.T.)

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return .T.
EndIf

//Verifica valor mínino do pedido de venda
U_GENA009()

//Verifica transportadora do pedido de venda
lRet	:= U_GENG005()

If FunName()=="MATA410"
	
	//Verifica condicao de pagamento do pedido
	U_GENA015()
Endif

lWeb := !Empty(M->C5_XPEDWEB)
lOld := !Empty(M->C5_XPEDOLD)

If lAtivaVld
	If (lWeb .or. lOld) .and. lWeb <> lOld
		If upper(alltrim(GetEnvServer())) $ "SCHEDULE"
			AutoGrLog( "MT410TOK - Os campos Ped. Antigo e Pedido Web devem estar preenchidos. Favor verificar. pedido: "+DtoC(DDataBase)+" "+Time() )
			AutoGrLog( "MT410TOK - Filial:"+cFilant+" Pedido: "+M->C5_NUM )
		Else
			MsgBox("Os campos Ped. Antigo e Pedido Web devem estar preenchidos. Favor verificar.","Atenção")
		Endif
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return lRet
