#include 'protheus.ch'
#include 'parmtype.ch'


/*/{Protheus.doc} BANCO005
//TODO Descrição auto-gerada.
@author RCTI TREINAMENTOS
@since 2018
@version undefined

@type function
/*/
user function BANCO005()
	
	Local aArea := GetArea()
	Local aDados := {}
	Private lMSErroAuto := .F.
	
	// Adionando dados no vetor para teste de inclusão na tabela SB1
	aDados := {;
			   	{"B1_COD",	"111111",				Nil},;
			   	{"B1_DESC",	"PRODUTO TESTE",		Nil},;
			   	{"B1_TIPO",	"GG", 					Nil},;
			   	{"B1_UM", "PC", 					Nil},;
			   	{"B1_LOCPAD", 	"01", 				Nil},;
			   	{"B1_PICM", 	0, 					Nil},;
			   	{"B1_IPI", 0, 						Nil},;
			   	{"B1_CONTRAT", "N", 				Nil},;
			   	{"B1_LOCALIZ", "N", 				Nil};
			   }
	
	//inicio do controle de transação
	Begin Transaction
		//chama cadastro de produto
	MSExecAuto({|x,y|Mata010(x,y)},aDados,3)
	
	//Caso ocorra algum erro
		If lMSErroAuto
			Alert("Ocorreram erros durante a operação!")
			MostraErro()
			
			DisarmTransaction()
		Else
			MsgInfo("Operação finaliada!", "Aviso")
		EndIf
		End Transaction
		
		RestArea(aArea)
	
	
return