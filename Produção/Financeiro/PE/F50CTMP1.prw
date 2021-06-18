#include "rwmake.ch"
#include "protheus.ch"
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F50CTMP1  �Autor  �Vinicius Lan�a      � Data �  10/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para mostrar as informacoes na tela do    ���
���          � rateio.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F50CTMP1()

Local _aArea    := GetArea()
Local _aAreaTmp := GetArea("TMP")  
Local cTMPCV4   := GetNextAlias()


DbSelectArea("TMP")
DbGoTop()
While TMP->(!Eof())
	
    //BUSCA INFO. COM BASE NO E2_ARQRAT
	cQry := "SELECT CV4_XATVD FROM "+ RetSqlName("CV4")
	cQry += "	WHERE CV4_FILIAL = '"+ SUBSTR(SE2->E2_ARQRAT,1,4) +"'"	
	cQry += "	 AND CV4_DTSEQ   = '"+ SUBSTR(SE2->E2_ARQRAT,5,8) +"'"	
	cQry += "	 AND CV4_SEQUEN  = '"+ SUBSTR(SE2->E2_ARQRAT,13) +"'"	
	cQry += "	 AND CV4_VALOR   = "+ STR(TMP->CTJ_VALOR)  
	cQry += "	 AND CV4_DEBITO  = '"+ TMP->CTJ_DEBITO +"'"	
	
	If Select(cTMPCV4) > 0
		dbSelectArea(cTMPCV4)
		dbCloseArea()
	EndIf
	                                
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), cTMPCV4, .F., .T.)
	
	//GRAVA INFORMA��O NA TABELA TEMPORARIA	
	RecLock("TMP",.F.)
	
	TMP->CTJ_XATVD  := (cTMPCV4)->CV4_XATVD
	
	MsUnlock()

	DbSkip()
	
EndDo

RestArea(_aArea)
RestArea(_aAreaTmp)

Return
