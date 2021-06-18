#include "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Telso Carneiro      º Data ³  11/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. No final do faturament                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()

Local aArea		:= GetArea()
Local aAreaSFT	:= SFT->(GetArea())
Local aAreaSF3	:= SF3->(GetArea())

GravaNSU() 

GravaCDL() // complemento de exportação

If cFilAnt == "1001"
	/* 
	Cleuto - 05/08/2019
	Projeto e-Alquel.
	01.09.01 disponibilização, sem cessão definitiva, de conteúdos de áudio, vídeo, imagem ou texto por meio da internet, para pessoas jurídicas
	01.09.02 disponibilização, sem cessão definitiva, de conteúdos de áudio, vídeo, imagem ou texto por meio da internet, para pessoas naturais
	*/
	If Select("TMP_TRIB") > 0
		TMP_TRIB->(DbCloseArea())
	EndIf
	BeginSql Alias "TMP_TRIB"
		SELECT SFT.R_E_C_N_O_ SFTREC,SF3.R_E_C_N_O_ SF3REC 
		FROM %Table:SFT% SFT
		JOIN %Table:SB1% SB1
		ON B1_FILIAL = %xFilial:SB1%
		AND SFT.FT_PRODUTO = B1_COD
		AND SB1.%NotDel%
		JOIN %Table:SA1% SA1
		ON A1_FILIAL = %xFilial:SA1%
		AND A1_COD = FT_CLIEFOR
		AND A1_LOJA = FT_LOJA
		AND SA1.%NotDel%
		JOIN %Table:SF3% SF3
		ON F3_FILIAL = SFT.FT_FILIAL		
		AND SF3.F3_NFISCAL = SFT.FT_NFISCAL
		AND SF3.F3_SERIE = SFT.FT_SERIE
		AND SF3.F3_EMISSAO = SFT.FT_EMISSAO
		AND SF3.F3_CLIEFOR = SFT.FT_CLIEFOR
		AND SF3.F3_LOJA = SFT.FT_LOJA
		WHERE FT_FILIAL = %Exp:SFT->FT_FILIAL%		
		AND SFT.FT_NFISCAL = %Exp:SFT->FT_NFISCAL%
		AND SFT.FT_SERIE = %Exp:SFT->FT_SERIE%
		AND SFT.FT_EMISSAO = %Exp:SFT->FT_EMISSAO%
		AND SFT.FT_CLIEFOR = %Exp:SFT->FT_CLIEFOR%
		AND SFT.FT_LOJA = %Exp:SFT->FT_LOJA%
		AND SFT.FT_TIPOMOV = %Exp:SFT->FT_TIPOMOV%
		AND SA1.A1_PESSOA = 'J'
		AND SB1.B1_XIDTPPU IN ('28')
		AND SFT.%NotDel%
	EndSql
	
	Begin Transaction 
		While TMP_TRIB->(!EOF())
		 	SFT->(DbGoTo( TMP_TRIB->SFTREC ))
		 	RecLock("SFT",.F.)
		 	SFT->FT_TRIBMUN	:= "010901"
		 	MsUnLock()
		 	
		 	SF3->(DbGoTo( TMP_TRIB->SF3REC ))
		 	RecLock("SF3",.F.)
		 	SF3->F3_TRIBMUN	:= "010901"
		 	MsUnLock()
		 	
		 	TMP_TRIB->(DbSkip())
		EndDo
	End Transaction
	
	If Select("TMP_TRIB") > 0
		TMP_TRIB->(DbCloseArea())
	EndIf	
EndIf

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaNSU  ºAutor  ³Telso Carneiro      º Data ³  11/07/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³função para atualizaar o campo numero da autorização de     º±±
±±º          ³pagamento no titulo.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaNSU()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³variaveis da rotina                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea			:= GetArea()
Local aNSUTEF			:= {}
Local cAliasSF2		:= GetNextAlias()
Local cAliasSVC		:= GetNextAlias()
Local cAliasSE1		:= GetNextAlias()
Local nPosPar			:= 0

If !Empty(SF2->F2_DUPL) .AND. SF2->F2_SERIE <> '4'			
	BeginSql Alias cAliasSF2
		SELECT D2_FILIAL, D2_PEDIDO 
			FROM %Table:SD2% SD2 
				WHERE SD2.D2_FILIAL  = %exp:SF2->F2_FILIAL% AND 
					  SD2.D2_DOC     = %exp:SF2->F2_DOC% AND 
					  SD2.D2_SERIE   = %exp:SF2->F2_SERIE% AND 
					  SD2.D2_CLIENTE = %exp:SF2->F2_CLIENTE% AND 
					  SD2.D2_LOJA    = %exp:SF2->F2_LOJA% AND 
					  SD2.%notdel%
					  Group By  D2_FILIAL, D2_PEDIDO 
	EndSql
	
	While (cAliasSF2)->(!Eof())
		BeginSql Alias cAliasSVC
			SELECT CV_XPARCEL, CV_XNSUTEF,CV_XOPERA,CV_XBANDEI 
				FROM %Table:SCV% SCV 
					WHERE SCV.CV_FILIAL = %exp:(cAliasSF2)->D2_FILIAL% AND 
						  SCV.CV_PEDIDO = %exp:(cAliasSF2)->D2_PEDIDO% AND 
						  SCV.%notdel%
						  Order By CV_FILIAL,CV_PEDIDO,CV_XPARCEL
		EndSql
		While (cAliasSVC)->(!Eof()) 			
			aADD(aNSUTEF,{ (cAliasSVC)->CV_XNSUTEF , (cAliasSVC)->CV_XOPERA , (cAliasSVC)->CV_XBANDEI })
			(cAliasSVC)->(dbSkip())
		EndDo
		(cAliasSVC)->(DbCloseArea())
		Exit //Somente um pedido por nota fiscal
		(cAliasSF2)->(dbSkip())
	Enddo
	(cAliasSF2)->(dbCloseArea())	
	
	If Len(aNSUTEF) > 0
		nPosPar := 0			
		BeginSql Alias cAliasSE1
			SELECT SE1.R_E_C_N_O_ SE1RECNO  
				FROM %table:SE1% SE1 
				WHERE SE1.E1_FILIAL = %exp:SF2->F2_FILIAL% AND 
					  SE1.E1_CLIENTE = %exp:SF2->F2_CLIENTE% AND 
					  SE1.E1_LOJA = %exp:SF2->F2_LOJA% AND 
					  SE1.E1_PREFIXO = %exp:SF2->F2_PREFIXO% AND 
					  SE1.E1_NUM = %exp:SF2->F2_DUPL% AND 				  
					  SE1.E1_TIPO = 'NF ' AND
					  SE1.E1_DOCTEF = ' ' AND
					  SE1.%notdel%
					  ORDER BY %Order:SE1,1% 
		EndSql
		Begin Transaction
			While (cAliasSE1)->(!Eof())   
				nPosPar++
				SE1->(DbGoto((cAliasSE1)->SE1RECNO))				
				RecLock("SE1",.F.)					
				SE1->E1_DOCTEF	:= aNSUTEF[nPosPar][1]
				SE1->E1_XOPERA	:= aNSUTEF[nPosPar][2]
				SE1->E1_XBANDEI	:= aNSUTEF[nPosPar][3]
				MsUnLock()
				(cAliasSE1)->(dbSkip())
			EndDo		
			(cAliasSE1)->(dbCloseArea())
		End Transaction			
	EndIf
EndIf

RestArea(aArea)
Return

Static Function GravaCDL()

Local aAreaSD2	:= {}
Local aAreaCDL	:= {}

IF SF2->F2_FILIAL <> "1022" .OR. SF2->F2_EST <> 'EX' .OR. SF2->F2_TIPOCLI <> 'X'
	Return nil
ENDIF

aAreaSD2	:= SD2->(GetArea())
aAreaCDL	:= CDL->(GetArea())

CDL->(DbSetOrder(2))//CDL_FILIAL+CDL_DOC+CDL_SERIE+CDL_CLIENT+CDL_LOJA+CDL_ITEMNF+CDL_NUMDE+CDL_DOCORI+CDL_SERORI+CDL_FORNEC+CDL_LOJFOR+CDL_NRREG
SD2->(DbSetOrder(3))//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM

SD2->(DbSeek( SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ))

While SD2->(!EOF()) .AND. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == SF2->(F2_FILIAL+F2_DOC+F2_SERIE)

	cChaveCDL	:= SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEM
	IF !CDL->(DbSeek( cChaveCDL ))
		RecLock("CDL",.T.)
		CDL->CDL_FILIAL := SD2->D2_FILIAL
		CDL->CDL_DOC    := SD2->D2_DOC
		CDL->CDL_SERIE  := SD2->D2_SERIE
		CDL->CDL_ESPEC  := SF2->F2_ESPECIE
		CDL->CDL_CLIENT := SD2->D2_CLIENTE
		CDL->CDL_LOJA   := SD2->D2_LOJA
		CDL->CDL_INDDOC := "1"
		CDL->CDL_NATEXP := "0"
		CDL->CDL_UFEMB  := "SP"
		CDL->CDL_LOCEMB := "BARUERI"
		CDL->CDL_ITEMNF := SD2->D2_ITEM
		CDL->CDL_PRODNF := SD2->D2_COD
		CDL->CDL_LOCDES := "BARUERI"
		CDL->CDL_SDOC   := SD2->D2_SERIE	
		MsUnLock()
	ENDIF

	SD2->(DbSkip())
EndDo

RestArea(aAreaSD2)
RestArea(aAreaCDL)

Return nil
