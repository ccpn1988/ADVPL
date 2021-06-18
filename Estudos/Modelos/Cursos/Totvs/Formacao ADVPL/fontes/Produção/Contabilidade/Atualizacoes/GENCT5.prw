#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENTCT5   �Autor  �Danilo Azevedo      � Data �  04/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tratamento de contabilizacao                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - CTB                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENCT5(cCampo,cTypeAux,cTipo,cEstorno)

Local aAreaSA6	:= {}
Local aAreaSE1	:= {}
Local xRet		:= " "   
Local cTitPai	:= ""

Default cTypeAux	:= "C"
Default cTipo		:= ""
Default cEstorno	:= "N"

If cCampo == "CT5_DEBITO"
	/*
	
	// Cleuto - 10/03/2017 - Regra antiga substituida para o projeto de parcelamento do cart�o de credito
	
	IF SE5->E5_MOTBX = 'VIS'
		xRet := '11020104'
	ElseIF SE5->E5_MOTBX = 'RDC'
		xRet := '11020105'
	ElseIF SE5->E5_MOTBX = 'AMX'
		xRet := '11020106'
	ElseIF SE5->E5_MOTBX = 'DNS'
		xRet := '11020108'
	ElseIF SE5->E5_MOTBX = 'ELO'
		xRet := '11020109'
	ElseIF SE5->E5_MOTBX = 'INC'
		xRet := '42040101'
	ElseIF SE5->E5_MOTBX = 'DAD'
		xRet := '43010104'
	ElseIF SE5->E5_MOTBX = 'DNI'
		xRet := '21090402'
	Else
		xRet := SA6->A6_CONTA
	Endif
	*/

	If cEstorno == "N"
		If AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#RDC#AMX#STO#"
			If cTipo == "AB-"
				xRet := "43010109"
			Else
				aAreaSA6	:= SA6->(GetArea())			
				xRet := Posicione("SA6",1,xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA),"A6_CONTA")
				RestArea(aAreaSA6)		
			EndIf	
		Else
			xRet := SA6->A6_CONTA
		EndIf		
	Else
	
		If AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#RDC#AMX#STO#"
			Do Case
				Case AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#" //CIELO
					xRet := "11020104"
				Case AllTrim(SE5->E5_MOTBX)+"#" $ "RDC#" //REDECARD
					xRet := "11020105"
				Case AllTrim(SE5->E5_MOTBX)+"#" $ "AMX#" //AMEX
					xRet := "11020106"
				Case AllTrim(SE5->E5_MOTBX)+"#" $ "STO#" //STONE
					xRet := "11020111"
			EndCase
		Else
			xRet := SA1->A1_CONTA
		EndIf
		
	EndIf
	
	
ElseIf cCampo == "CT5_CREDIT"// .OR. ( cCampo == "CT5_DEBITO" .AND. cEstorno == "S" )
	
	Do Case
		//Case cCampo == "CT5_DEBITO" .AND. cEstorno == "S"
		//	xRet := SA1->A1_CONTA
		Case cCampo == "CT5_CREDIT" .AND. cEstorno == "S"

			If AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#RDC#AMX#STO#"
				If cTipo == "AB-" .AND. cEstorno == "S"
					xRet := "43010109"
				Else
					aAreaSA6	:= SA6->(GetArea())				
					xRet := Posicione("SA6",1,xFilial("SA6")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA),"A6_CONTA")
					RestArea(aAreaSA6)		
				EndIf	
			Else
				xRet := SA6->A6_CONTA
			EndIf
			
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#" //CIELO
			xRet := "11020104"
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "RDC#" //REDECARD
			xRet := "11020105"
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "AMX#" //AMEX
			xRet := "11020106"
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "STO#" //STONE
			xRet := "11020111"
		OtherWise
			xRet := IF(SE1->E1_DEBITO<>' ',SE1->E1_DEBITO,SA1->A1_CONTA)
	EndCase

ElseIf cCampo == "CT5_CCD"
	IF SE5->E5_MOTBX $ 'INC-DAD'
		xRet := '20401010'
	Endif
ElseIf cCampo == "CT5_CLVCR"
	
	Do Case
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#" //CIELO
			xRet := " "
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "RDC#" //REDECARD
			xRet := " "
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "AMX#" //AMEX
			xRet := " "
		Case AllTrim(SE5->E5_MOTBX)+"#" $ "STO#" //STONE
			xRet := " "
		OtherWise
			xRet := "C"+SA1->A1_COD
	EndCase

ElseIf cCampo == "CT5_VLR1" .AND. cTipo == "AB-"	
	xRet	:= 0
	If AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#RDC#AMX#STO#"
		aAreaSE1	:= SE1->(GetArea())		
		cTitPai := SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA
		//SE1->(DBSetNickname("TITPAI"))//Prefixo + N�mero + Parcela + Tipo + Cliente + Loja
		SE1->(DbSetOrder(28))//Prefixo + N�mero + Parcela + Tipo + Cliente + Loja
		If SE1->(DbSeek(cTitPai))
			xRet := IIF( SE1->E1_TIPO == cTipo,SE1->E1_VALOR,0)
		EndIf	
		RestArea(aAreaSE1)
	EndIf   
ElseIf cCampo == "CT5_VLR1" .AND. cEstorno == "S"
	xRet	:= 0
	If AllTrim(SE5->E5_MOTBX)+"#" $ "CIE#RDC#AMX#STO#"
		xRet	:= IF(SE1->E1_TIPO="NCC",0,SE5->(E5_VALOR-E5_VLJUROS+E5_VLDESCO+E5_VRETPIS+E5_VRETCOF+E5_VRETCSL+E5_VRETISS))-SE1->E1_IRRF
	EndIf	
Endif

If cTypeAux == "N" .AND. ValType(xRet) <> "N"
	xRet	:= Val(xRet)
EndIf

Return(xRet)
