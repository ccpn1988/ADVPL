#Include 'Protheus.ch'

User Function xMenu()

if MsgYesNo("Deseja executar a rotina?")
   //U_xINCLUIR()
   //U_xALTERAR()
   //U_xALTCNPJ()
   //u_xDelete()
   u_xSQL()
   MsgInfo("Produto: " + SB1->B1_DESC + CRLF +;
           "Cadastrado com Sucesso" )
Endif 

Return()

User Function xINCLUIR()

	RecLock("SB1",.T.) //Incluir
	
		SB1->B1_FILIAL := XFILIAL("SB1") //FwFilial("SB1") 
		SB1->B1_COD    := GetSxeNum("SB1","B1_COD")
		SB1->B1_DESC   := "Exemplo Incluir
		SB1->B1_LOCPAD := "01"
		SB1->B1_UM 	   := "XX"
		SB1->B1_MSBLQL := '1'
		
	MsUnLock()//Libera o registro
	ConfirmSX8()

Return

User Function xALTERAR()

	dbSelectarea("SB1")
	dbSetorder(1) //FILIAL+CODIGO
	if MsSeek(xfilial("SB1")+'TERCEIROS000001') //Alterar	
	
		RecLock("SB1",.F.) //Alterar
		
			//SB1->B1_FILIAL := XFILIAL("SB1") //FwFilial("SB1") 
			//SB1->B1_COD    := GetSxeNum("SB1","B1_COD")
			SB1->B1_DESC   := "Exemplo Alterar"
			SB1->B1_LOCPAD := "01"
			SB1->B1_UM 	   := "XX"
			SB1->B1_MSBLQL := '1'
			
		MsUnLock()//Libera o registro
	Endif	
	//ConfirmSX8()


Return

User Function xALTCNPJ()

	dbSelectarea("SA1")
	dbSetorder(3) //FILIAL+CGC
	if MsSeek(xfilial("SA1")+'03338610002646') //Alterar	
	
		RecLock("SA1",.F.) //Alterar			
   	    SA1->A1_NOME   := "Exemplo Alterar - SA1"			
		MsUnLock()//Libera o registro
		
	Else
	
	   msginfo("CNPJ  NAO EXISTE")
	   	
	Endif	
	


Return

User Function xDelete()

	dbSelectarea("SA1")
	dbSetorder(3) //FILIAL+CGC
	if MsSeek(xfilial("SA1")+'03338610002646') //Alterar	
	
		RecLock("SA1",.F.) //Alterar			
   	    	dbDelete()			
		MsUnLock()//Libera o registro
		
	Else
	  
	   msginfo("CNPJ  NAO EXISTE")
	   	
	Endif	
	


Return

User Function xSQL()
Local  cSQL := "UPDATE SA1990 SET D_E_L_E_T_ = ' ' WHERE A1_CGC='03338610002646' "

	if TCSQLExec(cSQL) < 0
	    MsgStop("TCSQLError()" + TCSQLError() , 'Atenção!!!')
	endif
	
Return


