#include "Rwmake.ch"
#include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240FIL   � Autor � Florence Fran�a    � Data �  01/12/10   ��� 
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado na tela de par�metros no campo  ���
���          � MODO (Forma de Pagamento) rotina border� a Pagar.		  ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/        

User Function F240FIL()
                          
Local cRet := " " 

/*
Local cFormPag  := Space(2)
Local cRet := " "                       

	DEFINE MSDIALOG oDlgClie FROM  000,000 TO 150,300 TITLE OemToAnsi("Filtro") PIXEL 
	
	@ 00, 005 TO 070, 200 Title "Parametros"
	@ 12, 025 SAY "Cobran�a por Forma de Pagamento" SIZE 100,100 PIXEL 
	@ 25, 025 GET cFormPag SIZE 35,10 F3 "58"
    
	DEFINE SBUTTON FROM 55, 020 oButton2 TYPE 1 ENABLE OF oDlgClie ACTION (lRet := .T.,oDlgClie:End()) PIXEL
	DEFINE SBUTTON FROM 55, 050 oButton3 TYPE 2 ENABLE OF oDlgClie ACTION (lRet := .F.,oDlgClie:End()) PIXEL
	
	ACTIVATE MSDIALOG oDlgClie CENTERED                                                                                      
*/   

cRet := " E2_XFORPGT == '"+CMODPGTO+"'"


Return cRet                                                       	