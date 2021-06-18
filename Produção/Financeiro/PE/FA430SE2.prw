#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA430SE2     � Autor � Vinicius Lan�a  � Data �  29/02/2012 ���
�������������������������������������������������������������������������͹��
���Descricao �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA430SE2


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cQuery
Local cArqSE2	:= GetNextAlias()
Local cArqID	:= GetNextAlias()
Local lRet		:= .F.
Local cIDCNAB

//aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer })

//Verificar a quantidade de ocorrencias do IDCNAB

If (PARAMIXB[1][1]) == '0000000000'
	cIDCNAB := ' '
Else              
	cIDCNAB := PARAMIXB[1][1]
EndIf

cQuery := " SELECT COUNT(E2_NUM) CONTADOR"
cQuery += " FROM "+RetSqlName("SE2")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit

If Select(cArqID) > 0
	dbSelectArea(cArqID)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cArqID, .F., .T.)

DbSelectArea(cArqID)
DbGoTop()

If (cArqID)->CONTADOR > 1
	
	cQuery := " SELECT R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SE2")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit
	cQuery += " AND E2_VALOR - E2_DECRESC + E2_ACRESC  = "+alltrim(str(PARAMIXB[1][8])) //nValPgto
	
Else
	
	cQuery := " SELECT R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SE2")
	cQuery += " WHERE D_E_L_E_T_ = ' '"
	cQuery += " AND E2_IDCNAB = '"+cIDCNAB+"'" //cNumTit
	
Endif

If Select(cArqSE2) > 0
	dbSelectArea(cArqSE2)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cArqSE2, .F., .T.)

DbSelectArea("SE2")
DbGoTo((cArqSE2)->R_E_C_N_O_)

Return