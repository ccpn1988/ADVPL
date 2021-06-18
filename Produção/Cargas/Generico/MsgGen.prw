#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MsgGen    �Autor  �Danilo Azevedo      � Data �  04/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao utilizada para montar as mensagens do M-MESSENGER   ���
���          � a serem enviadas nos eventos de todos os modulos.          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Configuracao M-Messenger pelo SIGATMK - Call Center  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MsgGen(nTipo)

cEnt := Chr(13)+Chr(10)
cMsg := "###############   M E N S A G E M   A U T O M � T I C A   ###############"+cEnt+cEnt

If nTipo = 1 //ADMISSAO DE FUNCIONARIO
	
	cMsg += "Funcion�rio admitido: "+SRA->RA_NOME +cEnt
	cMsg += "Cargo: "+Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") +cEnt
	cMsg += "Centro de Custo/Departamento: "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") +cEnt
	cMsg += "Matricula: "+SRA->RA_MAT +cEnt
	cMsg += "CPF: "+SRA->RA_CIC +cEnt
	cMsg += "E-Mail: "+SRA->RA_EMAIL +cEnt
	cMsg += cEnt
	cMsg += cEnt
	cMsg += "Favor providenciar a libera��o dos acessos e permiss�es."+cEnt
	
ElseIf nTipo = 2 //DEMISSAO DE FUNCIONARIO
	
	cMsg += "Funcion�rio desligado: "+SRA->RA_NOME +cEnt
	cMsg += "Cargo: "+Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") +cEnt
	cMsg += "Centro de Custo/Departamento: "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") +cEnt
	cMsg += "Matricula: "+SRA->RA_MAT +cEnt
	cMsg += "CPF: "+SRA->RA_CIC +cEnt
	cMsg += "E-Mail: "+SRA->RA_EMAIL +cEnt
	cMsg += cEnt
	cMsg += cEnt
	cMsg += "Favor providenciar o bloqueio dos acessos e permiss�es."+cEnt
	
Endif

Return(cMsg)
