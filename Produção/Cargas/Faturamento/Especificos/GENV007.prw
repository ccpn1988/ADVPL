#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GENV007  ºAutor  ³ Renato Calabro'    º Data ³  06/22/146  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao no campo C6_TES para verificar se TES e' de con- º±±
±±º          ³ signacao e se cliente esta' habilitado para operacao       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	
		Aviso(	"TES inválida", "A TES especificada é uma TES de consignação e o cliente não tem permissão para essa operação." + CRLF +;
				"Não será permitido utilizar esta TES, se o cadastro do cliente estiver com o campo '" +;
				GetSX3Cache("A1_XCONSIG", "X3_TITULO") + "' vazio ou sem permissão de consignação ('N').", {"&Voltar"},, "Atenção",,;
				"MSGHIGH")
	Else
		lRet := .T.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Renato Calabro' - 24/jun/2016                                                ³
	//³ Verifica se existe mais de um codigo de TES inserido, e nao permite sair do  ³
	//³ campo                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Cleuto - 08/07/2016 GMUD - 29428
	//If lRet
	//	aEval(aCols, {|x| cTES += If(x[GdFieldPos("C6_TES")] <> M->C6_TES/*At(x[GdFieldPos("C6_TES")], cTES) == 0*/ .AND. !aTail(x), /*x[GdFieldPos("C6_TES")]*/M->C6_TES + "@!@", "") })
	//	If Len(Separa(cTES, "@!@", .F.)) > 1
	//		Aviso(	"Múltiplas TES inseridas", "Não é permitido selecionar mais de um código de TES." + CRLF + "Por favor, revise os " +;
	//				"itens novamente para confirmar o pedido de venda.", {"&Voltar"},, "Atenção",, "MSGHIGH" )
	//		lRet := .F.
	//	EndIf
	//EndIf
		
Else
	lRet := .T.
EndIf

Return(lRet)
