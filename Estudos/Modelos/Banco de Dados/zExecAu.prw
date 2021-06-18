#include 'protheus.ch'
#include 'parmtype.ch'

//EXECAUTO - EXECUTA ROTINAS AUTOMATICAS 

user function zExecAu()
	Local aArea := GetArea()
	Local nOpc := 4
	Local aDados:= {}
	Private lMSErroAuto := .F. //ARMAZENA ERROS INICIA-SE EM .F.
	

	
	//VETOR PARA INCLUS�O SB1
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
				
	//INICIO DO CONTROLE DE TRANSA��O
		Begin Transaction
		
			//ACESSANDO O CADASTRO DE PRODUTO - OPERA��O 3 INCLUS�O
			MsExecAuto({|x,y|MATA010(x,y)},aDados,nOpc)
			
			//VALIDA��O DE ERROS 
				IF lMSErroAuto  //CASO APRESENTE ERRO
					Alert("Ocorreram erros durante a opera��o!")
					MostraErro() //APRESENTA OS ERROS SE EXISTENTES
			
				ELSE
					MsgInfo("Opera��o Finalizada", "Aten��o!")
				ENDIF
		
		END Transaction()
	
	RestArea(aArea)
	
return