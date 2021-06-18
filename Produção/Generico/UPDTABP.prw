#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UPDTABP   �Autor  �Danilo Azevedo      � Data �  30/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualizacao de tabela de preco nos parametros e cadastros   ���
���          �de clientes.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Atualizacao de tabela de preco                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function UPDTABP()

cTabOld := "200"
cTabNew := "210"

Prepare Environment Empresa "00" Filial "1022"

IF dDatabase < CtoD("31/12/2020")
	IF Val(Left(Time(),2)) < 23
		Conout("UPDTABP - n�o pode ser executada antes de 31/12/2020 as 23hs")
		Return nil
	ENDIF
ENDIF

If alltrim(GETMV("GEN_FAT006")) = cTabOld
	PutMv("GEN_FAT006",cTabNew)
Endif

//If alltrim(GETMV("GEN_FAT015")) = cTabOld
//	PutMv("GEN_FAT015",cTabNew)
//Endif

If alltrim(GETMV("GEN_FAT036")) = cTabOld
	PutMv("GEN_FAT036",cTabNew)
Endif

If alltrim(GETMV("GEN_FAT064")) = cTabOld
	PutMv("GEN_FAT064",cTabNew)
Endif

//If alltrim(GETMV("GEN_FAT069")) = cTabOld
//	PutMv("GEN_FAT069",cTabNew)
//Endif                          

If alltrim(GETMV("GEN_FAT107")) = cTabOld
	PutMv("GEN_FAT107",cTabNew)
Endif                          

If alltrim(GETMV("GEN_COM006")) = cTabOld
	PutMv("GEN_COM006",cTabNew)
Endif                          

Begin transaction
	tcsqlexec("CREATE TABLE SA1_"+DTOS(dDatabase)+" AS SELECT * FROM "+RetSqlName("SA1")) //FAZ BACKUP DA TABELA DE CLIENTES
	tcsqlexec("UPDATE "+RetSqlName("SA1")+" SET A1_TABELA = '"+cTabNew+"' WHERE A1_TABELA = '"+cTabOld+"' AND D_E_L_E_T_ = ' '") //ATUALIZA CLIENTES
End Transaction

Conout("Fim 210")

Reset Environment

Return()
