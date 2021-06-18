#Include 'Protheus.ch'

User Function xDeleta()
    
   dbSelectArea("SB1")
   dbSetOrder(1) //Filial + Codigo  
if MsSeek (xFilial("SB1")+ 'TERCEIROS000001')   
   RecLock ("SB1",.F.) //DELETE
   dbDelete() 
   MsUnlock()//Libera o registro              
Endif  
Return
     

