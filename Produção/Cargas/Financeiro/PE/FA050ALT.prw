#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA050ALT  �Autor  �FLORENCE FRANCA     � Data �  25/01/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida os tipos de pagamentos conforme informado no 		  ���
���          � parametro MV_XINFPGT (valor da valida��o TED/DOC)no 		  ���     
���          � momento da altera��o		  								  ���  
�������������������������������������������������������������������������͹��
���Uso       � FA050ALT Contas a Pagar                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA050ALT()

Local lRet := .T.
Local cParam := 0
   
cParam := GETMV("MV_XINFPGT")        

If (M->E2_XFORPGT $ "41|43")  .and. M->E2_TIPO <> "DAE"
	If (M->E2_VALOR <= GETMV("MV_XINFPGT"))          
		MsgBox("N�o � permitido a inclus�o de t�tulos do tipo TED para valores MENORES de "+str(cParam)+".","Aten��o") 
		lRet := .F.                
	EndIf
EndIf	   

If (M->E2_XFORPGT == '03') .and. M->E2_TIPO <> "DAE"
	If (M->E2_VALOR > GETMV("MV_XINFPGT"))
		MsgBox("N�o � permitido a inclus�o de t�tulos do tipo DOC para valores MAIORES de "+str(cParam)+".","Aten��o")
		lRet := .F.	  	
	EndIf                              
EndIf
                      
Return(lRet)