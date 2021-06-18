#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE STR_PULA  CHR(13)+CHR(10)

user function Indices()
	Local aArea := GetArea()
	Local cDescri := ""
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))//NESTA FUN��O INDICA O USO DO INDICE 1
	SB1->(dbgotop()())//AP�S ORDENA��O POSICIONAR A TABELA NO TOP
	
	//POSICIONANDO CONFORME DBSEEK, AONDE � DEFINIDO CONFORME O INDICE MENCIONADO USANDO FWxFilial para FILIAL
	IF SB1->(DbSeek(FWxFilial('SB1')+ 'MANUTENCAO'))
		MSGINFO("Descri��o 1: "+SB1->B1_DESC, "Aten��o!!!")
	ENDIF
	
	//CASO SEJA CUSTOMIZADO O INDICE DEVE SER UTILIZADO O NICKNAME
	//SB1->(DbOrderNickName("NICKNAME"))
	
	//POSICIONE = RETORNA UM CAMPO DA  TABELA APENAS 1 UNICO REGISTRO(CAMPO)
	
	cDescri := POSICIONE(		'SB1',;										 //ALIAS DA TABELA
								1,;											 //INDICE DE PESQUISA
								FWxFilial('SB1') + 'MANUTENCAO',;//CHAVE DE PESQUISA CONFORME INDICE
								'B1_DESC')									 //CAMPO DE RETORNO
	MSGINFO("Descri��o 2: "+ cDescri,"Aten��o")
	
	RestArea(aArea)
							
Return

//----------------------------------------------------------------------------------------------------------

USER FUNCTION INDSRA()
	Local aAreaSRA := SRA->(GetArea())
	Local cCad := ""
		
	
	dbSelectArea("SRA")
	SRA->(dbSetOrder(21))
	SRA->(dbGoTop())
	
	IF SRA->(dbSeek(FWxFilial("SRA")+ "008" + "00002"))
		MSGINFO(SRA->RA_DEPTO +"/"+SRA->RA_MAT)
	ENDIF
	
	
	SRA->(DbGoTop())
	WHILE !SRA->(EOF())
		cCad += SRA->RA_DEPTO + " -- " + SRA->RA_MAT + STR_PULA 
		
		SRA->(dbSkip())
	ENDDO
	
	
AVISO('ATEN��O', cCad, {'OK'}, 03)

RESTAREA(aAreaSRA)

RETURN