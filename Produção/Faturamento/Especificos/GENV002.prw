#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GenV002   � Autor � Danilo Azevedo     � Data �  26/11/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do campo C6_PRODUTO no pedido de venda para      ���
���          � alertar sobre obra bloqueada e permissao para exportar.    ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GenV002()

lAmbSch := upper(alltrim(GetEnvServer())) $ "SCHEDULE-PRE" //ambiente Schedule
lRet := .T.

If ! lAmbSch
	
	If Funname()=="MATA410"
		cEst := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
		cExp := alltrim(Posicione("SB5",1,xFilial("SB5")+M->C6_PRODUTO,"B5_XEXPORT"))
		
		If cEst = "EX" .and. cExp <> "1"
			lRet := .F.
			MsgBox("Este produto n�o pode ser exportado. Verifique o cadastro do produto e/ou cliente.","Aten��o")
		Endif
	Endif
	
	If lRet
		If Funname()=="MATA415"
			
			cSit := alltrim(Posicione("SB1",1,xFilial("SB1")+M->CK_PRODUTO,"B1_XSITOBR"))
			lBlq := Posicione("SZ4",1,xFilial("SZ4")+cSit,"Z4_MSBLQL") == "1"			

			If lBlq
				lRet := MsgYesNo("Obra bloqueada. Continuar?","Atencao")
			Endif	
									
		Else
			cSit := alltrim(Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_XSITOBR"))
			lBlq := Posicione("SZ4",1,xFilial("SZ4")+cSit,"Z4_MSBLQL") == "1"
			
			If lBlq //!(cSit$"101-105-109") //SITUACOES DE OBRA ATIVA PARA PEDIDO DE VENDA
				If Funname()=="MATA410"
					lRet := MsgYesNo("Obra bloqueada. Continuar?","Atencao")
					
				ElseIf ProcName()=="U_GENA006B" //ROTINA DE CONSIGNACAO INTERCIA
					lRet := .T.
					
				ElseIf Funname()=="MATA103"	 //DOCUMENTO DE ENTRADA - PARA O PROCESSO DE ACERTO DE CLIENTE
					lRet := .T.
					
				ElseIf Funname()=="GENA021"	 //RECONSIGNACAO GEN
					lRet := .T.
				ElseIf ISINCALLSTACK( "U_GENA066" )	 //COMPLEMENTO DE PRE�O
					lRet := .T.
				ElseIf ISINCALLSTACK( "U_GENA082" )	 //COMPLEMENTO DE PRE�O
					lRet := .T.									
				Else
					lRet := .F.
					conout("GENV002 - Retorno falso (nao considerou registro no pedido de venda)")
				Endif
			Endif	
		EndIf	
	Endif
	
Endif

Return(lRet)
