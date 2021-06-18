#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA088   �Autor  � Cleuto P. Lima     � Data �  15/03/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Workflow envio de boletos contas a receber                 ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA088()

Local _aArea		:= GetArea()

Conout("GENA088 - Iniciando envio de boletos contas a receber."+cFilAnt+"-"+DtoC(DDataBase)+" - "+Time())

If upper(alltrim(GetEnvServer())) $ "SCHEDULE"
	
	If LockByName("GENA088",.T.,.T.,.T.)
		
		U_GENA087W()

		UnLockByName("GENA088",.T.,.T.,.T.)			
		Conout("GENA088 - finalizando envio de boletos contas a receber. "+cFilAnt+"-"+DtoC(DDataBase)+" - "+Time())
		
	Else
		Conout("GENA088 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada! "+cFilAnt+"-"+DtoC(DDataBase)+" - "+Time())
	EndIf	
Endif

RestArea(_aArea)

Return nil 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA087W  �Autor  � Cleuto P. Lima     � Data �  15/03/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera boleto                                  				 ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SchedDef()
Local aOrd		:= {}
Local aParam	:= {}

aParam	:= {"P"	, ; // Tipo R para relatorio P para processo
"PARAMDEF"			, ; // Pergunte do relatorio, caso n�o user passar paramdef		
""					, ; // Alias
aOrd				, ; // Array de ordens
}

Return aParam