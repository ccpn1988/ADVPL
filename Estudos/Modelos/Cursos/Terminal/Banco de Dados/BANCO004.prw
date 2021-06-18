#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE STR_PULA CHR(13)+CHR(10)

user function BANCO004()
	Local aArea 	:= GetArea()
	Local aAreaB1 	:= SB1->(GetArea())
	Local cMens 	:= ""
	
	//SE A TABELA JA ESTIVER POSICIONADA
	IF Select("SB1") > 0
		MsgStop("Tabela SB1 já está aberta", "Atenção!!!")
	ENDIF
	
	//SELECIONANDO A TABELA DE PRODUTOS - DbSelectArea(<nArea ou cArea>)
	DbSelectArea("SB1") //ABRE A TABELA
	SB1->(DbSetorder(1)) //POSICIONA NO 1 INDICE (B1_FILIAL + B1_COD)
	SB1->(DbGoTop()) //POSICIONA NO 1 REGISTRO
	
	//POSICIONANDO/PESQUISA O PRODUTO 0000001 - DbSeek(<expressão caracter>, <expressão lógica 1>,  [ <expressão lógica 2> ] )
	IF SB1->(DbSeek(FWxFilial("SB1") + "VALE"))
		Alert(SB1->B1_DESC)
	ENDIF
	
	//AGORA PERCORRO OS REGISTROS E ADICIONO A DESCRIÇÃO EM UMA VARIAVEL
	SB1->(DbGoTop())//POSICIONA NO 1 REGISTRO
	While !SB1->(EOF())
		cMens += Alltrim(SB1->B1_DESC)+";"+ STR_PULA
		
	SB1->(DbSkip()) //PULA O REGISTRO
	ENDDO
	
	//AVISO("Título - Teste de Aviso", “Texto”, { “Botao1”, “Fechar” }, 1)
	AVISO('ATENÇÃO', cMens, {'OK'}, 03)
	
	RESTAREA(aAreaB1)
	RESTAREA(aArea)
	
return

//------------------------------------------------------------------------------------------------------------------------------

User Function BD001()
	Local aArea   := GetArea() 
	Local aAreaRA := SRA->(GetArea())
	Local cMsg := ""
	
	dbSelectArea("SRA")
	dbSetOrder(1)
	SRA->(dbGoTop())
	
	IF SB1->(dbSeek(FWxFilial("SRA") + "000002"))
		Alert(SRA->RA_NOME)
	END IF
	
	SB1->(dbGoTop())
	While !SRA->(EOF())
		cMsg += (SRA->RA_NOME)+";"+ STR_PULA
		
		SRA->(DbSKIP())
	ENDDO
	
	AVISO("ALERTA",cMsg,{'OK'},03)
	
	RestArea(aAreaRA)
	RestArea(aArea)
	
Return
//----------------------------------------------------------------------------------------------------------	
