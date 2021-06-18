/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DPCTB102GR�Autor  �Rafael Lima         � Data �  22/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado apos a grava��o dos dados da    ���
���          � tabela de lan�amento.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DPCTB102GR

Local 	aArea	:= GetArea()
Local 	aVet	:= ParamIxb 
local	cMailx

//Local 	lRet	:= .T.

If Inclui .or. Altera
	
	//Alert("Entrei no If")
	
	PswOrder(1)
	PswSeek(__cUserId,.T.)
	aUser := PswRet(1) //traz o email
	
	If !Empty(aUser[1,14])
		cMailx := ALLTRIM(aUser[1,14])  
		Alert(ALLTRIM(aUser[1,14]))
	//	lRet := .T.
	Else
		Alert("Favor informar email no cadastro do seu usu�rio para recebimento do Aviso de Libera��o da conta.")
	//	lRet := .F.
	Endif
	
	DbSelectArea("CT2")
	RecLock("CT2", .F.)
	CT2->CT2_XUSER  := __cUserId 
	CT2->CT2_XEMAIL := cMailx
	MsUnLock()
	
EndIf
//Dispara o wf para libera��o para efetiva��o
//U_APVA002(aVet)
	
RestArea(aArea)
	
Return
