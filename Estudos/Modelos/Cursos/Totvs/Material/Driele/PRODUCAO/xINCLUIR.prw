#Include 'Protheus.ch'

User Function XMenu()

If MsgYesNo ("Deseja Executar a rotina?")
    U_xINCLUIR()
    MsgInfo ("Produto: " +SB1->B1_DESC + CRLF +;
             "Cadastrado com Sucesso")
             
Endif
             
Return()

User Function xINCLUIR()

   RecLock ("SB1",.T.) //Incluir
         SB1->B1_FILIAL := xFilial("SB1")//FwFilial ("SB1")
         SB1->B1_COD := GetsxeNum ("SB1","B1_COD")
         SB1->B1_DESC   := "Exemplo incluir" 
         SB1->B1_LOCPAD   := "01" 
         SB1->B1_UM   := "XX" 
         SB1->B1_MSBLQL   := "1" 
       MsUnlock()//Libera o registro
 ConfirmSx8()  
Return

