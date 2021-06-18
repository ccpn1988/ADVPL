#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  VALCODBAR     � Autor � Fl�vio Santos   � Data �  09/11/2010 ���
��    Utilizado por Rosana Nascimento                                     ���
�������������������������������������������������������������������������͹��
���Descricao � Valida��o do c�digo de barras                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10 IDE                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VALCODBAR()

Private cRet := ""
Private cTamLin := "" //Tamanho da linha digitada no SE2 antes da montagem do border�.

cTamLin := LEN(ALLTRIM(M->E2_CODBAR))

Do Case
	
	Case cTamLin = 44 // se for digita��o de t�tulos de cobran�a
		cRet := .T.
		
	Otherwise
		
		If  Aviso(" Valida��o C�digo de Barras " ," Este formato n�o � valido para pagamento de fornecedores! Continua?    " ,{"Sim","N�o"}) = 1
			MsgInfo("Este c�digo de barras n�o ser� validado pelo BANCO para Pagamento de fornecedores!")
			cRet := .T.
		Else
			MsgInfo("Utilize a linha digitada ou verifique as configura��es da Leitora!")
			M->E2_CODBAR := ""
			cRet := .T.
		EndIf
EndCase

Return cRet
