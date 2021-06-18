#Include 'Protheus.ch'

//User Function xWhile
//Local nCount  := 1
//
////Do While nCount <= 10
////Do While ++nCount <= 10
//Do While nCount <= 10
//  If nCount == 5
//     nCount ++
//     Loop
//  EndIf
//     
//  MSgInfo ("Contador:" + cValtochar( nCount ) )
//    //nCount : = nCount + 1
//        //nCount += 1
//        //++nCount 
//        nCount ++
//EndDo
//        
//Return( NIL )

//User Function xWhile
//Local nCount  := 1
//
//While .T.
//    If MsgYesNo ("Desejar sair do While?", "Atenção!")
//        If MsgYesNo ("'Realmente' deseja sair do while?", "Atenção!")
//       Exit
//        Endif
//    Endif
//    
//EndDo    

User Function xTabWhile()


     dbSelectarea ("SA1")
     dbSelectarea ("SB1")
     SA1->( dbSetOrder(1) )
     SA1->( dbGotop() ) //Incio da Tabela
     
     // EOF () Fim Tabela
     // BOF () Inicio Tabela
     
 While .Not.  EOF()
    
       Msginfo ("Codigo: " + SA1->A1_COD + CHR(13)+ " Nome: " + SA1->A1_NOME)
       
       SA1->( dbSkip() ) //Proximo registro
EndDo
    
      SA1->( dbCloseArea() )
      SB1->( dbCloseArea() )

Return ( Nil )
//-----------------------------------            





