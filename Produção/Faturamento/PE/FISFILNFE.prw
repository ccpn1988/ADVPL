#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FISFILNFE �Autor  �Danilo Azevedo      � Data �  21/05/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para adicionar opcoes de filtro na rotina  ���
���          �de transmissao de notas (SPEDNFE).                          ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FISFILNFE()

//08/06/2015 - Rafael Leite - Alterado fonte para servir como fun��o de impress�o da DANFE. Esta rotina trabalha em conjunto com o fonte FISFILNFE
//para gerar um menu somente de impress�o do DANFE.

//If Existblock("GENNFE") .or. Alltrim(FUNNAME()) == "GENDAN" //SE O FILTRO ANTIGO ESTIVER COMPILADO, NAO EXECUTA
If Alltrim(FUNNAME()) == "GENNFE" //Se for rotina de impress�o de danfe n�o faz filtro.
	Return()
Endif

lRet := .T.

If SubStr(MV_PAR01,1,1) == "1"
	
	//������������������������������������������������������������������������Ŀ
	//�Realiza a Filtragem na 1-Saida                                          �
	//��������������������������������������������������������������������������
	
	cUsrLib := GetMv("GEN_NFEFIL")
	If RetCodUsr() $ cUsrLib
		lRet := MsgYesNo("Deseja visualizar apenas produtos j� embalados?","Aten��o")
	Endif
		
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	
	If !Empty(MV_PAR03)
		cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
	EndIf
	If SubStr(MV_PAR02,1,1) == "1" //"1-NF Autorizada"
		cCondicao += ".AND. F2_FIMP$'S' "
	ElseIf SubStr(MV_PAR02,1,1) == "3" //"3-N�o Autorizadas"
		cCondicao += ".AND. F2_FIMP$'N' "
	ElseIf SubStr(MV_PAR02,1,1) == "4" //"4-Transmitidas"
		cCondicao += ".AND. F2_FIMP$'T' "
	ElseIf SubStr(MV_PAR02,1,1) == "5" //"5-N�o Transmitidas"
		cCondicao += ".AND. F2_FIMP$' ' "
	EndIf
	If lRet .and. alltrim(MV_PAR03) <> "2" //SERIE 2 NAO ENTRA NO FILTRO
		cCondicao += ".AND. F2_XSTROMA = 'B' "
	Endif
	
Else
	
	//������������������������������������������������������������������������Ŀ
	//�Realiza a Filtragem na 2-Entrada                                        �
	//��������������������������������������������������������������������������
	
	cCondicao := "F1_FILIAL=='"+xFilial("SF1")+"' .AND. "
	cCondicao += "F1_FORMUL=='S'"
	
	If !Empty(MV_PAR03)
		cCondicao += ".AND.F1_SERIE=='"+MV_PAR03+"'"
	EndIf
	If SubStr(MV_PAR02,1,1) == "1" .And. SF1->(FieldPos("F1_FIMP"))>0 //"1-NF Autorizada"
		cCondicao += ".AND. F1_FIMP$'S' "
	ElseIf SubStr(MV_PAR02,1,1) == "3" .And. SF1->(FieldPos("F1_FIMP"))>0 //"3-N�o Autorizadas"
		cCondicao += ".AND. F1_FIMP$'N' "
	ElseIf SubStr(MV_PAR02,1,1) == "4" .And. SF1->(FieldPos("F1_FIMP"))>0 //"4-Transmitidas"
		cCondicao += ".AND. F1_FIMP$'T' "
	ElseIf SubStr(MV_PAR02,1,1) == "5" .And. SF1->(FieldPos("F1_FIMP"))>0 //"5-N�o Transmitidas"
		cCondicao += ".AND. F1_FIMP$' ' "
	EndIf
	
Endif

Return(cCondicao)
