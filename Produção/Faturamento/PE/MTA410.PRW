#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410   �Autor  � Joni Fujiyama      � Data �  30/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que inclui a transportadora caso o tipo de frete   ���
���          �for igual CIF.											  ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//Verifica valor m�nino do pedido de venda
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
			MsgBox("Os campos Ped. Antigo e Pedido Web devem estar preenchidos. Favor verificar.","Aten��o")
		Endif
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return lRet
