#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function FListBox()

Private oDlg
Private oLbx1,oLbx2,oLbx4,oLbx5,oTotal
Private oFld
Private oBtn  
Private oFont1     := TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )  
Private oFont2		 := TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )   

Private aTitles		:= {"Cad. Cliente","Fornecedor","Produto"}
Private aCliente	:= {{"","","","","","//"}}
Private aFornece	:= {{"","","","",""}}
Private aProdutos	:= {{"","","",""}}
 
Private   oOk      := LoadBitmap( GetResources(), 'LBOK' )
Private   oNo      := LoadBitmap( GetResources(), 'LBNO' )

Private   oVERDE      := LoadBitmap( GetResources(), 'BR_VERDE' )
Private   oVERMELHO   := LoadBitmap( GetResources(), 'BR_VERMELHO' ) 
 
 RPCSETENV("99","01")
 
oDlg := MsDialog():New(000,000,550,960,"Exemplo de LisBox",,,.F.,,,,,,.T.,,,.T.) 

oFld := tFolder():New(025,005,aTitles,{},oDlg,,,,.T.,.F.,468,228)
//oFld:bSetOption:={|nIndo|FldMuda(nIndo,oFld:nOption,@oDlg,@oFld)}  

fCarregaDados() 

//===================================================================== Folder 1 - Cliente ======================================================================
//@ 005,005 LISTBOX oLbx1 FIELDS HEADER "Cod.Cliente","Loja","Nome ","Estado","Ultima Compra","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[1]
oLbx1 := TCBrowse():New( 001 , 001, 456,200,, {"Bloqueado","Cod.Cliente","Loja","Nome ","Estado","Ultima Compra"},{20,15,5,50,20,50}, oFld:aDialogs[1],,,,,{||})
oLbx1:SetArray(aCliente)
oLbx1:bLine := { || {	aCliente[oLbx1:nAt,06],;
	                   aCliente[oLbx1:nAt,01],;
	                   aCliente[oLbx1:nAt,02],;
	                   aCliente[oLbx1:nAt,03],;
	                   aCliente[oLbx1:nAt,04],;
					aCliente[oLbx1:nAt,05]}}  
//@ 100,10 SAY oTotal VAR oLbx1:nLen PICTURE "@E 9,999,999,999" SIZE 70,7 OF oFld:aDialogs[1] PIXEL

 oLbx1:bLDblClick := {|| MsgInfo(aCliente[oLbx1:nAt,01] + CRLF + ;
	                            aCliente[oLbx1:nAt,02] + CRLF +  ;
	                            aCliente[oLbx1:nAt,03]) }							
//===================================================================== Folder 2 - aFornece ======================================================================
@ 005,005 LISTBOX oLbx2 FIELDS HEADER 	" ","Cod.Forne","Loja","Nome"," UF ","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[2]
oLbx2:SetArray(aFornece)
oLbx2:bLine := { || {IIF(aFornece[oLbx2:nAt,06],oOk,oNo),;
	                aFornece[oLbx2:nAt,01],;
	                aFornece[oLbx2:nAt,02],;
	                aFornece[oLbx2:nAt,03],;
	                aFornece[oLbx2:nAt,04],;
	                aFornece[oLbx2:nAt,05]}} 							

oLbx2:bLDblClick := {|| aFornece[oLbx2:nAt,06] := !aFornece[oLbx2:nAt,06] }
							
//===================================================================== Folder 3 - aProdutos ======================================================================
@ 005,005 LISTBOX oLbx3 FIELDS HEADER 	"Produto ","Descriçao ", "Tipo ","Bloqueado" colsizes 35,25,50,20, SIZE 456,205 PIXEL OF oFld:aDialogs[3]
oLbx3:SetArray(aProdutos)
oLbx3:bLine := { || {	aProdutos[oLbx3:nAt,01],aProdutos[oLbx3:nAt,02],aProdutos[oLbx3:nAt,03],aProdutos[oLbx3:nAt,04] } } 							



oBtn := tButton():New(258,435,"Sair",oDlg,{||Sair()},036,012,,,,.T.,,"",,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED


Return( NIL )

//******************************************************************************************************

Static Function fCarregaDados() 

Local cAliasFor := GetNextAlias()  
Local cSql      := ""
Local cAliasProd := GetNextAlias()                                     
                                                
// 1º  Folder Cliente

dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbGoTop())

aCliente := {}

While ! SA1->( EOF() ) 

		aAdd ( aCliente, { SA1->A1_COD   ,;
 	  				          SA1->A1_LOJA  ,;
 	  				          SA1->A1_NREDUZ,;
 	  				          SA1->A1_EST   ,;
 	  				          SA1->A1_ULTCOM,;
 	  				      IIF( SA1->A1_MSBLQL <> "1" , oVERDE,oVERMELHO ) } )             

	SA1->(dbSkip())

EndDo

 If Empty(aCliente)
	aCliente	:=	{{"","","","","","//"}}
 EndIf	            

//******************************************************************************

// 2º  Folder Fornecedor   


cSql :=" Select A2_COD as CODIGO,   "
cSql +="	   A2_LOJA,      "
cSql +="       A2_NREDUZ, "
cSql +="       A2_EST,    "
cSql +="       A2_MSBLQL  "
cSql +=" FROM " + RetSQLName("SA2")  /*Nome da tabela no banco de dados*/
cSql +="  Where A2_FILIAL = '" + xFilial("SA2") + "'" /*Filial corrente*/
cSql +="  AND D_E_L_E_T_ = ' '  " 

//Esta função tem como objetivo retornar uma query 
//modificada de acordo a escrita adequada para o banco de dados em uso
cSql := ChangeQuery(cSql)
dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),(cAliasFor), .F., .T.)

If Select( cAliasFor ) == 0
	(cAliasFor)->( dbCloseArea() )
EndIf	



 dbSelectArea( cAliasFor )
 (cAliasFor)->( dbGoTop() )
 
 aFornece	:=	{}
   
While ! (cAliasFor)->( EOF() ) 
	                              
        AADD ( aFornece, { (cAliasFor)->CODIGO   ,;
 	  				            (cAliasFor)->A2_LOJA  ,;
 	  						      (cAliasFor)->A2_NREDUZ,;
 	  						      (cAliasFor)->A2_EST   ,;
 	  				       IIF( (cAliasFor)->A2_MSBLQL <> "1" , "Não","Sim" ) ,;
 	  				       .F. } )             

	   (cAliasFor)->(dbSkip())

EndDo

 If Empty(aFornece) 
	aFornece	:=	{{ "","","","","" }}
 EndIf	            


//******************************************************************************

// 3º  Folder Produto


BeginSql Alias cAliasProd

	SELECT B1_COD, 
		    B1_DESC, 
		  	 B1_TIPO, 
			 B1_UM, 
			 B1_MSBLQL 
	FROM %Table:SB1%
		WHERE B1_FILIAL =  %xFilial:SB1%
		AND %NotDel%
EndSQL

aSQL := GetLastQuery()

MsgInfo(aSQL[2])
        

If Select( cAliasProd ) == 0
	(cAliasFor)->( dbCloseArea() )
EndIf	     

 dbSelectArea( cAliasProd )
 (cAliasProd)->( dbGoTop() ) 
 
 aProdutos := {} 

While ! (cAliasProd)->(EOF())
        
	 AADD ( aProdutos, { (cAliasProd)->B1_COD   ,;
	 							(cAliasProd)->B1_DESC   ,;
							   (cAliasProd)->B1_TIPO   ,;
						  IIF((cAliasProd)->B1_MSBLQL <> "1" , "Não","Sim" ) } )  

	(cAliasProd)->(dbSkip())

EndDo           

 If Empty(aProdutos) 
	aProdutos	:=	{{ "","","","" }}
 EndIf	  


Return( NIL )

//******************************************************************************************************

Static Function Sair()

	
	oDlg:END()	
	

Return( NIL )

//******************************************************************************************************



