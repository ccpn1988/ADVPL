
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENSX7VL  �Autor  �CLEUTO LIMA         � Data �  22/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � fun��s genericas dicionario de dados projeto gest�o de     ���
���          � produtos                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENSX7VL(cField,cSkill)

Local cRet		:= ""
Local oModel	:= FWModelActive()
Local oModelZZL := oModel:GetModel( 'ZZL_FORM' )

Do Case
	Case cSkill == "A" // remove acentua��o
		oModelZZL:LoadValue(cField, FwNoAccent(oModelZZL:GetValue(cField)) )
		FwNoAccent(oModelZZL:GetValue(cField))
	OtherWise
		cRet	:= oModelZZL:GetValue(cField)
EndCase

Return cRet