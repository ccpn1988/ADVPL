#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MYMATA030 �Autor  �Microsiga           � Data �  30/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina automatica do cadastro de clientes.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Excli()

Local aVetor 		:= {}
Local _cArqPd		:= GetNextAlias()
PRIVATE lMsErroAuto := .F.

//��������������������������������������������������������������Ŀ
//| Abertura do ambiente                                         |
//����������������������������������������������������������������

PREPARE ENVIRONMENT EMPRESA "00" FILIAL "1001" MODULO "FAT" TABLES "SA1"

_cQuery := "SELECT A1_COD, A1_LOJA FROM SA1000 WHERE A1_XCODOLD IN ('13122182','13125744')"
If Select(_cArqPd) > 0
	dbSelectArea(_cArqPd)
	(_cArqPd)->(dbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cArqPd, .F., .T.)
Do While (_cArqPd)->(!EOF())
	
	aVetor:={{"A1_COD"	,(_cArqPd)->A1_COD	,Nil},; // Codigo
	{"A1_LOJA"			,(_cArqPd)->A1_LOJA,Nil}} // Loja
	//{"A1_NOME"      ,"INC. AUTOMATICO"  	,Nil},; // Nome
	//{"A1_NREDUZ"    ,"AUTOMATICO"			,Nil},; // Nome reduz.
	//{"A1_TIPO"      ,"R"					,Nil},; // Tipo
	//{"A1_END"       ,"RUA AUTOMATICA"		,Nil},; // Endereco
	//{"A1_MUN"       ,"SAO AUTOMATICO"		,Nil},; // Cidade
	//{"A1_EST"       ,"SP"				    ,Nil}}  // Estado
	
	MSExecAuto({|x,y| Mata030(x,y)},aVetor,5) //3- Inclus�o, 4- Altera��o, 5- Exclus�o
	
/*
	If lMsErroAuto
		Alert("Erro")
	Else
		Alert("Ok")
	Endif
*/
	(_cArqPd)->(dbSkip())
Enddo

Return()
