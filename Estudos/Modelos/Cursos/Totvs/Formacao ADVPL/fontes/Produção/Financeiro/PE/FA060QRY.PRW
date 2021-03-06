
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA060QRY  �Autor  �Cleuto Lima - Loop  � Data �  21/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para inclus�o de filtro na query de        ���
���          �titulos do fonte FINA060 para bordero de contas a receber   ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
02/06/2016 - Rafael Leite - Inserido getarea SE1, pergunta 03 e tratamento na query para MV_PAR03.
*/


User Function FA060QRY()

//������������������������������������������������������������������������������������������Ŀ
//�Variaveis da rotina.                                                                      �
//��������������������������������������������������������������������������������������������

Local cFiltro	:= ""
Local cQuebra	:= Chr(13)+Chr(10)
Local _aSE1		:= SE1->(GetArea())

cPerg := "GENFA060"
PutSx1(cPerg, "01", "Natureza De"	 , "Natureza De"	, "Natureza De"	, "mv_ch1", "C", tamsx3("E1_NATUREZ")[1], 0, 0, "G", "", "SED", "", "", "MV_PAR01","","","",""	 ,"","","","","","","","","","","","")
PutSx1(cPerg, "02", "Natureza At�"	 , "Natureza At�"	, "Natureza At�", "mv_ch2", "C", tamsx3("E1_NATUREZ")[1], 0, 0, "G", "", "SED", "", "", "MV_PAR02","","","","ZZZZZ","","","","","","","","","","","","")
PutSx1(cPerg, "03", "Cliente Boleto?", "a"            	, "a"			, "mv_ch3", "C", 1, 0, 0, "C", "", "", "", "", "MV_PAR03","Sim","Sim","Sim","1","Nao","Nao","Nao","","","","","","","","","")
Pergunte(cPerg,.T.)


//������������������������������������������������������������������
//�26923 - filtrar titulos de acordo com cadastro do cliente campo �
//�Boleto Email Sim/N�o.                                           �
//������������������������������������������������������������������

cFiltro += " E1_NATUREZ BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "+cQuebra

cFiltro += " EXISTS ("
cFiltro += " SELECT * FROM "+RetSqlName("SA1")+" SA1 "+cQuebra
cFiltro += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "+cQuebra
cFiltro += " AND A1_COD = E1_CLIENTE "+cQuebra
cFiltro += " AND A1_LOJA = E1_LOJA "+cQuebra

If MV_PAR03 == 1
	cFiltro += " AND SA1.A1_BLEMAIL = '1' "+cQuebra
Endif

cFiltro += " AND SA1.D_E_L_E_T_ = ' ' "+cQuebra

cFiltro += ") "+cQuebra

RestArea(_aSE1)

Return cFiltro