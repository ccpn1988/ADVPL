/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA020TOK  �Autor  �Florence Fran�a     � Data �  01/18/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para obrigar informar o CPF  e dados 	  ���
���          �bancarios se o fornecedor for pessoa f�sica                 ���
�������������������������������������������������������������������������͹��
���Uso       � Cadastro de Fornecedor                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function MA020TOK

Local aArea := GetArea()
Local lRet := .T.

//**** Obriga o Preenchimento dos dados banc�rios ***********************************************

If ( M->A2_TIPO="F" ).and.(alltrim(M->A2_BANCO) != '000')
	If ( Empty(M->A2_CGC) .or. Empty(M->A2_BANCO) .or. Empty(M->A2_AGENCIA) .or. Empty(M->A2_NUMCON))
		lRet := .F.
		
		IF upper(alltrim(GetEnvServer())) $ "SCHEDULE"
			AutoGrLog( "MA020TOK - Para Pessoa F�sica � obrigat�rio o preenchimento do CPF e dos dados Bancarios!: "+DtoC(DDataBase)+" "+Time() )		
		EndIf
		
		Alert("Para Pessoa F�sica � obrigat�rio o preenchimento do CPF e dos dados Bancarios!")
	EndIf
EndIf
//***********************************************************************************************



RestArea(aArea)
Return lRet
