#INCLUDE "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  13/06/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA410VLD(nOpcao)

lRet := .T.

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return .T.
EndIf

If !Empty(M->C5_CLIENTE) .and. !Empty(M->C5_LOJACLI) .and. !Empty(M->C5_CONDPAG) .and. M->C5_TIPO = 'N' //usuario confirmou alteracao/inclusao de pedido NORMAL
	cCondCli := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COND")
	
	If cCondcli <> M->C5_CONDPAG //verifica se o campo perda est� preenchido e valida a regra de perda menor
		nPerCli := Posicione("SE4",1,xFilial("SE4")+cCondcli,"E4_XPERDA") //perda da condicao do cliente
		nPerPed := Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_XPERDA") //perda da condicao informada no pedido
		
		If nPerPed > nPerCli
			lRet := MsgYesNo("A condi��o de pagamento informada n�o � v�lida para este cliente. O pedido ficar� bloqueado por regra de neg�cio. Deseja continuar assim mesmo?","Aten��o")
		Endif
	Endif
Endif

Return(lRet)
