#Include 'Protheus.ch'

User Function XMenu1()

If MsgYesNo ("Deseja Executar a rotina?")
    U_xAlterar()
    MsgInfo ("Produto: " +SB1->B1_DESC + CRLF +;
             "Cadastrado com Sucesso")
             
Endif
             
Return()

User Function xAlterar()

   dbSelectArea("SB1")
   dbSetOrder(1) //Filial + Codigo  
if MsSeek (xFilial("SB1")+ 'TERCEIROS000001')   
   RecLock ("SB1",.F.) //ALterar
   //      SB1->B1_FILIAL := xFilial("SB1")//FwFilial ("SB1")
   //      SB1->B1_COD := GetsxeNum ("SB1","B1_COD")
           SB1->B1_DESC   := "Exemplo Alterar" 
           //SB1->B1_LOCPAD   := "01" 
//         SB1->B1_UM   := "XX" 
//         SB1->B1_MSBLQL   := "1" 
       MsUnlock()//Libera o registro
 //ConfirmSx8()  
Endif  
Return

