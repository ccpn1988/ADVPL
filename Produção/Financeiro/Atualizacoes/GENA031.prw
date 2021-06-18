#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA031   �Autor  �Cleuto Lima - Loop  � Data �  02/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para concatenar o endere�o no CNAB a receber	      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA031()

//������������������������������������������������������������������������������������Ŀ
//�Varaiveis da rotina.                                                                �
//��������������������������������������������������������������������������������������

Local _cRet := ""

Local cEnd	:= ""
Local cNum	:= ""
Local cComp	:= ""

Local aEndAux	:= FisGetEnd(Alltrim(SA1->A1_END))

If Len(aEndAux) > 1
	
	cEnd := AllTrim(aEndAux[1])
	
	If !Empty(Alltrim(SA1->A1_XENDNUM)) .AND. Alltrim(SA1->A1_XENDNUM) <> "0"
		cNum := Alltrim(SA1->A1_XENDNUM)
	ElseIf 	Len(aEndAux) >= 3
		cNum := Alltrim(aEndAux[3])
	EndIF
	
	If !Empty(Alltrim(SA1->A1_COMPLEM)) .AND. Alltrim(SA1->A1_COMPLEM) <> "-"
		cComp := Alltrim(SA1->A1_COMPLEM)
	ElseIf Len(aEndAux) >= 4
		cComp := Alltrim(aEndAux[4])
	EndIf
	
	If Len(cEnd)+Len(cNum)+Len(cComp)+3 <= 40
		
		// Prioriza o endere�o e numero
		nSpEnd	:= 40
		nSpEnd	:= nSpEnd-Len(cNum)
		
		_cRet	:= SubStr(cEnd,1,nSpEnd)+Space(1)+cNum
		If Len(_cRet) < 40 // Se sobrar espa�o adiciona o complemento
			_cRet	:= Left(_cRet+Space(1)+cComp,40)
		EndIf
		
	Else		
		_cRet	:= Left(cEnd+Space(1)+cNum+Space(1)+cComp,40)			
	EndIF
	
Else
	_cRet := Left(Alltrim(SA1->A1_END),40)
EndIf


Return(_cRet)   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA031B  �Autor  �Cleuto Lima - Loop  � Data �  02/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar a instru��o de cobran;ca.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GENA031B()

//������������������������������������������������������������������������������������Ŀ
//�Varaiveis da rotina.                                                                �
//��������������������������������������������������������������������������������������   

Local cRet	:= "10"

cRet	:= IIF( AllTrim(SA1->A1_XCLIPRE) == "1", "10" , IIF( AllTrim(SA1->A1_XCANALV) $ "1#2#" , "81" , "10" ))


Return(cRet)   

