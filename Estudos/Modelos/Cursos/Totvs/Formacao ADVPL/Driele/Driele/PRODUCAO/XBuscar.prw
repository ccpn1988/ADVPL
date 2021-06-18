#Include 'Protheus.ch'

User Function XBuscar()
Local cBuscar := ""     
     
   dbSelectArea("SA1")
   dbSetOrder(3) //Filial + CNPJ  
If MsSeek (xFilial("SA1")+ '03338610002646')  
   MsgInfo("Buscar:" +"Verdadeiro" + SA1->A1_NOME)
  Else 
   MsgInfo("Buscar:" + CRLF+ "Falso")
Endif

Return

