#Include 'Protheus.ch'

User Function  xMenu()
If MsgYesNo("Deseja executara Rotina?")
	U_ExpSB1()
	MsgInfo("Produto: " + SB1->B1_DESC + CRLF+;
			"CADASTRO COM SUCESSO")
	EndIf
	
Return()

User Function xINCLUIR()
  RecLock("SB1",.T.) //INCLUIR
  
    SB1->B1_FILIAL	:= XfILIAL("SB1") //FwFilial("SB1")
    SB1->B1_COD		:= GetSxeNum("SB1","B1_COD")
    SB1->B1_DESC	:= "EXEMPLO INCLUIR"
    SB1->B1_LOCPAD	:= "01"
    SB1->B1_UM		:= "XX"
    SB1->B1_MSBLQL	:= '1'
  
  MsUnLock() //Libera o registro
  ConfirmSX8()
   
Return


//-----------------------------------------------------------
User Function xAlterar()

dbSelectArea("SB1")
dbsetorder(1) //FILIAL + CODIGO
IF MsSeek(xFilial("SB1") + 'Terceiros000001')
  RecLock("SB1",.F.) //Alterar
  
  
    //SB1->B1_FILIAL	:= XfILIAL("SB1") //FwFilial("SB1")
    //SB1->B1_COD		:= GetSxeNum("SB1","B1_COD")
    SB1->B1_DESC	:= "EXEMPLO Alterar"
    //SB1->LOCPAD		:= "01"
    //SB1->B1_UM		:= "XX"
    //SB1->B1_MSBLQL	:= '1'
  
  MsUnLock() //Libera o registro
  //ConfirmSX8()
Endif
Return

//----------------------------------------------------------------------
 User Function xBusca()

dbSelectArea("SA1")
dbsetorder(1) //FILIAL + CGC
IF MsSeek(xFilial("SA1") + '03338610002646')
RecLock("SB1",.F.) //Alterar

  SA1->A1_Nome	:= "EXEMPLO Alterar" + Alltrim(SA1->A1_NOME)
 MsUnLock()
Endif

Return

//------------------------------------------------------------

User Function xDelete()

dbSelectArea("SB1")
dbsetorder(1) //FILIAL + CODIGO
IF MsSeek(xFilial("SB1") + 'Terceiros000001')
  RecLock("SB1",.F.) //Alterar
  dbDelete()
  
  MsUnLock() //Libera o registro
Endif
Return
//----------------------------------------------------------------

User Function xSQL()
Local cSQL := "UPDATE SB1990 Set D_E_L_E_T_= 'where B1_FILIAL= '01' AND B1_COD= 'TERCEIROS000001' "

If TCSQLExec (cSQL) < 0
	MsgStop("TCSQLError()",TCSQLError(), "Atenção")

Endif
return
