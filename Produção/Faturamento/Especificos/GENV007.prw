#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GENV007  �Autor  � Renato Calabro'    � Data �  06/22/146  ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao no campo C6_TES para verificar se TES e' de con- ���
���          � signacao e se cliente esta' habilitado para operacao       ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENV007()

Local cInTES	:= GetMv("GEN_FAT094",.F.,"")
Local cAmbiente := upper(alltrim(GetEnvServer()))
Local cTES		:= "" 
Local cConsig	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_XCONSIG")

Local lRet		:= .F.

If !(cAmbiente $ "SCHEDULE")
	//If M->C6_TES $ cInTES .AND. (M->C5_XCONSIG == "N" .OR. Empty(M->C5_XCONSIG))
	If M->C6_TES $ cInTES .AND. (cConsig == "N" .OR. Empty(cConsig))
	
		Aviso(	"TES inv�lida", "A TES especificada � uma TES de consigna��o e o cliente n�o tem permiss�o para essa opera��o." + CRLF +;
				"N�o ser� permitido utilizar esta TES, se o cadastro do cliente estiver com o campo '" +;
				GetSX3Cache("A1_XCONSIG", "X3_TITULO") + "' vazio ou sem permiss�o de consigna��o ('N').", {"&Voltar"},, "Aten��o",,;
				"MSGHIGH")
	Else
		lRet := .T.
	Endif

	//������������������������������������������������������������������������������Ŀ
	//� Renato Calabro' - 24/jun/2016                                                �
	//� Verifica se existe mais de um codigo de TES inserido, e nao permite sair do  �
	//� campo                                                                        �
	//��������������������������������������������������������������������������������
	// Cleuto - 08/07/2016 GMUD - 29428
	//If lRet
	//	aEval(aCols, {|x| cTES += If(x[GdFieldPos("C6_TES")] <> M->C6_TES/*At(x[GdFieldPos("C6_TES")], cTES) == 0*/ .AND. !aTail(x), /*x[GdFieldPos("C6_TES")]*/M->C6_TES + "@!@", "") })
	//	If Len(Separa(cTES, "@!@", .F.)) > 1
	//		Aviso(	"M�ltiplas TES inseridas", "N�o � permitido selecionar mais de um c�digo de TES." + CRLF + "Por favor, revise os " +;
	//				"itens novamente para confirmar o pedido de venda.", {"&Voltar"},, "Aten��o",, "MSGHIGH" )
	//		lRet := .F.
	//	EndIf
	//EndIf
		
Else
	lRet := .T.
EndIf

Return(lRet)
