#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#DEFINE cEnt Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Original  � MT103FIM �Autor  � Joni Fujiyama      � Data � 02/12/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que ser� executado ap�s a digita��o do do ���
���          � cumento de entrada de nota de devolu��o, emitida pelo clien���
���          � te (devolvendo a consigna��o).                             ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103FIM()

Local _nOpcao    := PARAMIXB[1] 		// Op��o Escolhida pelo usuario no aRotina
Local _nConfirma := PARAMIXB[2]
Local _aArea 	 := GetArea()
Local lAmbSch := upper(alltrim(GetEnvServer())) $ "SCHEDULE" //ambiente Schedule

//Acerto de consigna��o com cliente
//If _nOpcao == 3 .and. _nConfirma == 1
If _nConfirma == 1
	
	If _nOpcao == 3 .and. !lAmbSch .and. Alltrim(FunName()) <> "GENA021"
		U_GENA013()
	Endif
	
	If SF1->(FieldPos("F1_XIDNFE")) > 0 .and. Empty(SF1->F1_XIDNFE)
		Reclock("SF1",.F.)
		cIdNf := GetMV("GEN_COM008")
		SF1->F1_XIDNFE := cIdNf
		MsUnlock()
		PutMV("GEN_COM008",soma1(cIdNf))
	Endif
Endif

RestArea(_aArea)

Return()



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT103FIM  �Autor  �Danilo Azevedo      � Data �  14/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na gravacao da Pre nota (MATA140)          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SD1140I()

If SF1->(FieldPos("F1_XIDNFE")) > 0 .and. Empty(SF1->F1_XIDNFE)
	Reclock("SF1",.F.)
	cIdNf := GetMV("GEN_COM008")
	SF1->F1_XIDNFE := cIdNf
	MsUnlock()
	PutMV("GEN_COM008",soma1(cIdNf))
Endif

Return()
