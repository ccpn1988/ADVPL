#include 'protheus.ch'
#include 'parmtype.ch'

//EXECAUTO - EXECUTA ROTINAS AUTOMATICAS 

user function zExecAu()
	Local aArea := GetArea()
	Local nOpc := 4
	Local aDados:= {}
	Private lMSErroAuto := .F. //ARMAZENA ERROS INICIA-SE EM .F.
	

	
	//VETOR PARA INCLUSÂO SB1
	aDados := {;
				{"B1_COD",		"0012347", 			NIL},;
				{"B1_DESC",		"ALTERA EXECAUTO",	NIL},;
				{"B1_TIPO",		"GG",				NIL},;
				{"B1_UM",		"PC",				NIL},;
				{"B1_LOCPAD",	"01",				NIL},;
				{"B1_PICM",		 0,					NIL},;
				{"B1_IPI",		 0,					NIL},;
				{"B1_CONTRAT",	"N",				NIL},;
				{"B1_LOCALIZ",	"N",				NIL};
				}
				
	//INICIO DO CONTROLE DE TRANSAÇÃO
		Begin Transaction
		
			//ACESSANDO O CADASTRO DE PRODUTO - OPERAÇÃO 3 INCLUSÃO
			MsExecAuto({|x,y|MATA010(x,y)},aDados,nOpc)
			
			//VALIDAÇÃO DE ERROS 
				IF lMSErroAuto  //CASO APRESENTE ERRO
					Alert("Ocorreram erros durante a operação!")
					MostraErro() //APRESENTA OS ERROS SE EXISTENTES
			
				ELSE
					MsgInfo("Operação Finalizada", "Atenção!")
				ENDIF
		
		END Transaction()
	
	RestArea(aArea)
	
return