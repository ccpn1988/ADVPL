#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SPED0150  �Autor  �Cleuto Pereita Lima � Data �  28/09/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada SPED0150 pode ser utilizado para         ���
���          �alterar as informa��es dos registros 0150 gerados para      ���
���          �o SPED Fiscal e SPED Contribui��es                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �GEN - Fiscal                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SPED0150()

Local aReg0150	:= PARAMIXB[1]
Local nEND			:= Iif( IsInCallStack("SPEDPISCOF") , 11 , 10 )
 
/*
Quando originado do arquivo SPEDFISCAL:

aReg0150[01] REG
aReg0150[02] COD_PART
aReg0150[03] NOME
aReg0150[04] COD_PAIS
aReg0150[05] CNPJ
aReg0150[06] CPF
aReg0150[07] IE
aReg0150[08] COD_MUN
aReg0150[09] SUFRAMA
aReg0150[10] END
aReg0150[11] NUM
aReg0150[12] COMPL
aReg0150[13] BAIRRO
-----------------------------------------------------------
Quando originado do arquivo SPEDPISCOF:

aReg0150[01] Rela��o com o registro pai 0140
aReg0150[02] REG
aReg0150[03] COD_PART
aReg0150[04] NOME
aReg0150[05] COD_PAIS
aReg0150[06] CNPJ
aReg0150[07] CPF
aReg0150[08] IE
aReg0150[09] COD_MUN
aReg0150[10] SUFRAMA
aReg0150[11] END
aReg0150[12] NUM
aReg0150[13] COMPL
aReg0150[14] BAIRRO
*/

aReg0150[nEND]	:= Left(aReg0150[nEND],60) 
//10 END Logradouro e endere�o do im�vel C 060 - N

Return aReg0150