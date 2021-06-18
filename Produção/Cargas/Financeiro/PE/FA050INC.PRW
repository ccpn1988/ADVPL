#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE   cEnt      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC  ºAutor  ³Vinicius Lança      º Data ³  23/01/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ - Valida Multiplas Naturezas no momento da inclusão.       º±±
±±º          ³ - Valida CTA.CONTABIL quando rateio igual a não.			  º±±
±±º          ³ - Valida os tipos de pagamentos conforme informado no 	  º±±
±±º          ³   parâmetro MV_XINFPGT (valor da validação TED/DOC)no 	  º±±
±±º          ³   momento da inclusão		  							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FA050INC   Contas a Pagar                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()

Local lRet := .T.
Local cParam := 0

If !"GPE" $ FUNNAME()
		
	If !lF050Auto
		
		// Cleuto - 15/09/2017
		/* se natureza calula IR e fornecedor pessoa juridica campo DIRF deve ser igual a SIM e codigo de retenção deve ser informado */
		If !Empty(M->E2_NATUREZ) ;
			.AND. Posicione("SED",1,xFilial("SED")+M->E2_NATUREZ,"ED_CALCIRF") == "S";
			.AND. Posicione("SA2",1,xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA,"A2_TIPO") == "F"
			
			Do Case
				Case Empty(M->E2_CODRET)
					If !MsgYesNo("Código de retenção não foi informado e natureza calcula IR, deseja continuar mesmo assim?")
						Return .F.
					EndIf	
				Case M->E2_DIRF <> "1"
					If !MsgYesNo("Campo DIRF diferente de SIM e natureza calcula IR, deseja continuar mesmo assim?")
						Return .F.
					EndIf
			EndCase
			
		EndIf
		
		// - Valida Multiplas Naturezas no momento da inclusão.
		If (!Empty(M->E2_ISS) .OR. !Empty(M->E2_IRRF) .OR. !Empty(M->E2_INSS) .OR. !Empty(M->E2_COFINS) .OR. !Empty(M->E2_PIS) .OR. !Empty(M->E2_CSLL)) .AND. M->E2_MULTNAT = "1"
			Aviso("ATENÇÃO!","Não pode haver Multiplas Naturezas quando há retenção de impostos.",{"OK"})
			lRet := .F.
		EndIf
		
		// - Valida CTA.CONTABIL quando rateio igual a não.
		If M->E2_RATEIO = 'N' .AND. EMPTY(M->E2_CONTAD)
			Aviso("ATENÇÃO!","Campo CTA.CONTABIL obrigatório para rateio igual a NÃO.",{"OK"})
			lRet := .F.
		EndIf
	Endif
	//************************************************************************************************************************
	/*
	±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	±±³ VALIDA OS TIPOS DE PAGAMENTOS DOC E TED CONFORME VALOR DO   ¹±±
	±±³ PARAMETRO MV_XINFPGTA   								    ¹±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍ¹±±
	±±º           ºAutor: FLORENCE FRANCA      º Data ³  25/01/2012 º±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºALTERAÇÃO  ºAutor: Vinicius Lança       º Data ³  27/02/2012 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍ¹±±
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄATEH¿
	//³VERIFICA VALOR DO ISS                                        ³
	//³SE FOR NA EMISSÃO E2_VALOR JA CONSIDERA O ISS (NÃO ABATE)    ³
	//³SE FOR NA BAIXA DEDUZ O VALOR DO E2_ISS DO E2_VALOR          ³
	//³PARAMETRO "MV_MRETISS" | "1" = EMISSAO | "2" = BAIXA         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄATEHÙ
	
	cISS := GETMV("MV_MRETISS")
	If cISS = "2"
		nValISS = M->E2_ISS
	ElseIf cISS = "1"
		nValISS = 0
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PIS/COFINS/CSLL                                                                                                     ³
	//³Caso campo de Valor Retido (E2_VRETPIS, E2_VRETCOF, E2_VRETCSL) for diferente de 0, o E2_VALOR já contempla,        ³
	//³se o E2_VRETxxx  for "zero",  considerar os valores calculados (E2_PIS, E2_COFINS e E2_CSLL) na dedução do E2_VALOR.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
				MsgBox("Valor do Título com dedução de impostos: "+cValpag+cEnt+"Não é permitido a inclusão de títulos do tipo TED para valores MENORES de "+str(cParam)+".","Título "+alltrim(M->E2_NUM))
				lRet := .F.
			EndIf
		EndIf
		
		If (M->E2_XFORPGT == '03') .and. M->E2_TIPO <> "DAE"
			If ( nValpag > GETMV("MV_XINFPGT")) 			//	If (M->E2_VALOR > GETMV("MV_XINFPGT"))
				MsgBox("Valor do Título com dedução de impostos: "+cValpag+cEnt+"Não é permitido a inclusão de títulos do tipo DOC para valores MAIORES de "+str(cParam)+".","Atenção")
				lRet := .F.
			EndIf
		EndIf
	Endif
	//************************************************************************************************************************
	
EndIf

Return lRet
