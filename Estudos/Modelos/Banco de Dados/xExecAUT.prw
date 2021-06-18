#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE STR_PULA CHR(13) + CHR(10)

user function xExecAUT()
	Local aArea := GetArea()
	Local aDados := {}
	Private lMSErroAuto := .F.
	//VARIAVEIS UTILIZADAS PARA GRAVAR O LOG DE ERRO EM ARQUIVO TEXTO
	/*Private lMSHelpAuto 	:= .T.
	Private lAutoErrNoFile 	:= .T.
	Private lMSErroAuto := .F.
	*/
	
				//INCLUINDO DADOS A TABELA SB1
	
	aDados := {;
				{"B1_COD",		"0012348", 			NIL},;
				{"B1_DESC",		"YOUTUBE EXECAUTO",	NIL},;
				{"B1_TIPO",		"P+",				NIL},; //FOR�ANDO ERRO
				{"B1_UM",		"PC",				NIL},;
				{"B1_LOCPAD",	"01",				NIL},;
				{"B1_PICM",		 0,					NIL},;
				{"B1_IPI",		 0,					NIL},;
				{"B1_CONTRAT",	"N",				NIL},;
				{"B1_LOCALIZ",	"N",				NIL};
				}
				
	//INICIO DO CONTROLE DE TRANSA��O
		Begin Transaction
		
			//ACESSANDO O CADASTRO DE PRODUTO - OPERA��O 3 INCLUS�O/4 ALTERA��O/5 EXCLUS�O
			MsExecAuto({|x,y|MATA010(x,y)},aDados,3)
			
			//VALIDA��O DE ERROS 
				IF lMSErroAuto  //CASO APRESENTE ERRO
					
			/*//GRAVA��O DO LOG EM ARQUIVO TEXTO NAO SE USA A ROTINA MOSTRA ERRO, SIM O TRECHO ABAIXO
					aLogAuto := {}
					cLogTxt := ""
			//PEGANDO LOG DO EXECAUTO
					aLogAuto := GetAutoGRLog()
			//PERCORRENDO O LOG
				FOR nAux := 1 TO LEN(aLogAuto)
					cLogTxt := aLogAuto(nAux) + STR_PULA
				NEXT*/
				
			//MOSTRA JANELA DE ERRO
			MostraErro()
			
			//DISARMANDO A TRANSA��O
			DisarmTransaction()
			
				ENDIF
		
		END Transaction()
		
		RestArea(aArea)
return