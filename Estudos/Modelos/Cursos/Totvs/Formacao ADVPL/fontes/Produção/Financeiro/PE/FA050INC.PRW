#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE   cEnt      CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050INC  �Autor  �Vinicius Lan�a      � Data �  23/01/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � - Valida Multiplas Naturezas no momento da inclus�o.       ���
���          � - Valida CTA.CONTABIL quando rateio igual a n�o.			  ���
���          � - Valida os tipos de pagamentos conforme informado no 	  ���
���          �   par�metro MV_XINFPGT (valor da valida��o TED/DOC)no 	  ���
���          �   momento da inclus�o		  							  ���
�������������������������������������������������������������������������͹��
���Uso       � FA050INC   Contas a Pagar                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA050INC()

Local lRet := .T.
Local cParam := 0

If !"GPE" $ FUNNAME()
		
	If !lF050Auto
		
		// Cleuto - 15/09/2017
		/* se natureza calula IR e fornecedor pessoa juridica campo DIRF deve ser igual a SIM e codigo de reten��o deve ser informado */
		If !Empty(M->E2_NATUREZ) ;
			.AND. Posicione("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_CALCIRF") == "S";
			.AND. Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,"A2_TIPO") == "F"
			
			Do Case
				Case Empty(M->E2_CODRET)
					If !MsgYesNo("C�digo de reten��o n�o foi informado e natureza calcula IR, deseja continuar mesmo assim?")
						Return .F.
					EndIf	
				Case M->E2_DIRF <> "1"
					If !MsgYesNo("Campo DIRF diferente de SIM e natureza calcula IR, deseja continuar mesmo assim?")
						Return .F.
					EndIf
			EndCase
			
		EndIf
		
		// - Valida Multiplas Naturezas no momento da inclus�o.
		If (!Empty(M->E2_ISS) .OR. !Empty(M->E2_IRRF) .OR. !Empty(M->E2_INSS) .OR. !Empty(M->E2_COFINS) .OR. !Empty(M->E2_PIS) .OR. !Empty(M->E2_CSLL)) .AND. M->E2_MULTNAT = "1"
			Aviso("ATEN��O!","N�o pode haver Multiplas Naturezas quando h� reten��o de impostos.",{"OK"})
			lRet := .F.
		EndIf
		
		// - Valida CTA.CONTABIL quando rateio igual a n�o.
		If M->E2_RATEIO = 'N' .AND. EMPTY(M->E2_CONTAD)
			Aviso("ATEN��O!","Campo CTA.CONTABIL obrigat�rio para rateio igual a N�O.",{"OK"})
			lRet := .F.
		EndIf
	Endif
	//************************************************************************************************************************
	/*
	�����������������������������������������������������������������Ŀ
	��� VALIDA OS TIPOS DE PAGAMENTOS DOC E TED CONFORME VALOR DO   ���
	��� PARAMETRO MV_XINFPGTA   								    ���
	���������������������������������������������������������������͹��
	���           �Autor: FLORENCE FRANCA      � Data �  25/01/2012 ���
	�������������������������������������������������������������������
	���������������������������������������������������������������ͻ��
	���ALTERA��O  �Autor: Vinicius Lan�a       � Data �  27/02/2012 ���
	���������������������������������������������������������������͹��
	*/
	
	//����������������������������������������������������������ATEH�
	//�VERIFICA VALOR DO ISS                                        �
	//�SE FOR NA EMISS�O E2_VALOR JA CONSIDERA O ISS (N�O ABATE)    �
	//�SE FOR NA BAIXA DEDUZ O VALOR DO E2_ISS DO E2_VALOR          �
	//�PARAMETRO "MV_MRETISS" | "1" = EMISSAO | "2" = BAIXA         �
	//����������������������������������������������������������ATEH�
	
	cISS := GETMV("MV_MRETISS")
	If cISS = "2"
		nValISS = M->E2_ISS
	ElseIf cISS = "1"
		nValISS = 0
	EndIf
	
	//��������������������������������������������������������������������������������������������������������������������Ŀ
	//�PIS/COFINS/CSLL                                                                                                     �
	//�Caso campo de Valor Retido (E2_VRETPIS, E2_VRETCOF, E2_VRETCSL) for diferente de 0, o E2_VALOR j� contempla,        �
	//�se o E2_VRETxxx  for "zero",  considerar os valores calculados (E2_PIS, E2_COFINS e E2_CSLL) na dedu��o do E2_VALOR.�
	//����������������������������������������������������������������������������������������������������������������������
	
	//VALOR DO PIS
	nValPIS := IIF( M->E2_VRETPIS <> 0, 0, M->E2_PIS )
	//VALOR DO COFINS
	nValCOF := IIF( M->E2_VRETCOF <> 0, 0, M->E2_COFINS )
	//VALOR DO CSLL
	nValCSL := IIF( M->E2_VRETCSL <> 0, 0, M->E2_CSLL )
	
	//CALCULA VALOR DO TITULO SEM IMPOSTOS
	nValpag := ( M->E2_VALOR - nValISS - nValPIS - nValCOF - nValCSL )
	cValpag := substr(alltrim(str((nValpag*100))),1,len(alltrim(str((nValpag*100))))-2)+"."+substr(alltrim(str((nValpag*100))),len(alltrim(str((nValpag*100))))-1,len(alltrim(str((nValpag*100)))))
	
	//VERIFICA LIMITE DE VALOR PARA PAGAMENTOS COM DOC E TED APENAS EM MOEDA NACIONAL
	If !lF050Auto
		cParam := GETMV("MV_XINFPGT")
		
		If (M->E2_XFORPGT $ "41|43") .and. M->E2_TIPO <> "DAE"
			If ( nValpag <= GETMV("MV_XINFPGT"))           //If (M->E2_VALOR <= GETMV("MV_XINFPGT"))
				MsgBox("Valor do T�tulo com dedu��o de impostos: "+cValpag+cEnt+"N�o � permitido a inclus�o de t�tulos do tipo TED para valores MENORES de "+str(cParam)+".","T�tulo "+alltrim(M->E2_NUM))
				lRet := .F.
			EndIf
		EndIf
		
		If (M->E2_XFORPGT == '03') .and. M->E2_TIPO <> "DAE"
			If ( nValpag > GETMV("MV_XINFPGT")) 			//	If (M->E2_VALOR > GETMV("MV_XINFPGT"))
				MsgBox("Valor do T�tulo com dedu��o de impostos: "+cValpag+cEnt+"N�o � permitido a inclus�o de t�tulos do tipo DOC para valores MAIORES de "+str(cParam)+".","Aten��o")
				lRet := .F.
			EndIf
		EndIf
	Endif
	//************************************************************************************************************************
	
EndIf

Return lRet
