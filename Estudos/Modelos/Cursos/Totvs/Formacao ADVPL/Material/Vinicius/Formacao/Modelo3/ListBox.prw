#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

User Function FListBox()

Private oDlg
Private oLbx1,oLbx2,oLbx4,oLbx5,oLbx6
Private oFld
Private oBtn  
Private oFont1     := TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )  
Private oFont2		 := TFont():New( "Arial",0,24,,.T.,,,,.F.,.F.,,,,,, )   

Private aTitles		:= {"Cad. Cliente","Fornecedor","Produto","Sucata"}
Private aCliente	:= {{"","","","","","//"}}
Private aFornece	:= {{"","","","",""}}
Private aProdutos	:= {{"","","",""}}
Private aSucata	:= {{"","","","","",""}}

RpcSetEnv("99","01")
 
oDlg := MsDialog():New(000,000,550,950,"Exemplo de LisBox",,,.F.,,,,,,.T.,,,.T.) 

oFld := tFolder():New(025,005,aTitles,{},oDlg,,,,.T.,.F.,468,228)
//oFld:bSetOption:={|nIndo|FldMuda(nIndo,oFld:nOption,@oDlg,@oFld)}  

fCarregaDados() 

//===================================================================== Folder 1 - Cliente ======================================================================
@ 005,005 LISTBOX oLbx1 FIELDS HEADER 	"Cod.Cliente","Loja","Nome ","Estado","Ultima Compra","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[1]
oLbx1:SetArray(aCliente)
oLbx1:bLine := { || {	aCliente[oLbx1:nAt,01],	aCliente[oLbx1:nAt,02],	aCliente[oLbx1:nAt,03],	aCliente[oLbx1:nAt,04],;
								aCliente[oLbx1:nAt,05],	aCliente[oLbx1:nAt,06]}}  
								
//===================================================================== Folder 2 - aFornece ======================================================================
@ 005,005 LISTBOX oLbx2 FIELDS HEADER 	"Cod.Forne","Loja","Nome"," UF ","Bloqueado" SIZE 456,205 PIXEL OF oFld:aDialogs[2]
oLbx2:SetArray(aFornece)
oLbx2:bLine := { || {aFornece[oLbx2:nAt,01],	aFornece[oLbx2:nAt,02],	aFornece[oLbx2:nAt,03],	aFornece[oLbx2:nAt,04],	aFornece[oLbx2:nAt,05]}} 							


							
//===================================================================== Folder 3 - aProdutos ======================================================================
@ 005,005 LISTBOX oLbx3 FIELDS HEADER 	"Produto ","Descriçao ", "Tipo ","Bloqueado" colsizes 35,25,50,20, SIZE 456,205 PIXEL OF oFld:aDialogs[3]
oLbx3:SetArray(aProdutos)
oLbx3:bLine := { || {	aProdutos[oLbx3:nAt,01],aProdutos[oLbx3:nAt,02],aProdutos[oLbx3:nAt,03],aProdutos[oLbx3:nAt,04] } } 							


//===================================================================== Folder 4 - aSucata ======================================================================
@ 005,005 LISTBOX oLbx6 FIELDS HEADER  "Produto ","Descriçao ", "Quantidade ", "Valor ", "Total ","Ativo" colsizes 35,125,50,50,50,30, SIZE 456,205 PIXEL OF oFld:aDialogs[4]
oLbx6:SetArray(aSucata)
oLbx6:bLine := { || {	aSucata[oLbx6:nAt,01],aSucata[oLbx6:nAt,02],aSucata[oLbx6:nAt,03],aSucata[oLbx6:nAt,04],aSucata[oLbx6:nAt,05],aSucata[oLbx6:nAt,06]} } 							

oBtn := tButton():New(258,435,"Sair",oDlg,{||Sair()},036,012,,,,.T.,,"",,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED


Return( NIL )

//******************************************************************************************************

Static Function fCarregaDados() 

Local cAliasFor := GetNextAlias()  
Local cSql      := ""
/*PEGA O NOME DA TABELA ALEATORIO*/
Local cAliasProd := GetNextAlias()  
Local cAliasSucata := GetNextAlias()                                   
                                                
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
 	  				      IIF( SA1->A1_MSBLQL <> "1" , "Não","Sim" ) } )             

	SA1->(dbSkip())

EndDo

 If Empty(aCliente)
	aCliente	:=	{{"","","","","","//"}}
 EndIf	            

//******************************************************************************

// 2º  Folder Fornecedor   


cSql :=" Select A2_COD,   "
cSql +="	   A2_LOJA,      "
cSql +="       A2_NREDUZ, "
cSql +="       A2_EST,    "
cSql +="       A2_MSBLQL  "
cSql +=" FROM " + RetSQLName("SA2") 
cSql +="  Where A2_FILIAL = '" + xFilial() + "'"
cSql +="  AND D_E_L_E_T_ = ' '  "

cSql := ChangeQuery(cSql)

/*INSTANCIANDO UMA VIEW NO BANCO
Pega o nome aleatorio e coloca pela INSTANCIA - cAliasFor
*/
dbUseArea( .T.,"TOPCONN", TCGENQRY(,,cSql),(cAliasFor), .F., .T.)

/*FECHANDO A AREA AO TENTAR ABRIR*/
If Select( cAliasFor ) == 0
	(cAliasFor)->( dbCloseArea() )
EndIf	



 dbSelectArea( cAliasFor )
 (cAliasFor)->( dbGoTop() )
 
 aFornece	:=	{}
   
While ! (cAliasFor)->( EOF() ) 
	                              
        AADD ( aFornece, { (cAliasFor)->A2_COD   ,;
 	  				            (cAliasFor)->A2_LOJA  ,;
 	  						      (cAliasFor)->A2_NREDUZ,;
 	  						      (cAliasFor)->A2_EST   ,;
 	  				       IIF( (cAliasFor)->A2_MSBLQL <> "1" , "Não","Sim" ) } )             

	   (cAliasFor)->(dbSkip())

EndDo

 If Empty(aFornece) 
	aFornece	:=	{{ "","","","","" }}
 EndIf	            


//******************************************************************************

// 3º  Folder Produto

/*FORMA DE FAZER O DBUSERAREA - AS %% INFORMAM UMA EXPRESSÂO A SER SUBSTITUIDA*/
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

//******************************************************************************

// 4º  Folder Sucata

/*FORMA DE FAZER O DBUSERAREA - AS %% INFORMAM UMA EXPRESSÂO A SER SUBSTITUIDA*/
BeginSql Alias cAliasSucata

	SELECT  Z0_COD,
		    B1_DESC, 
		  	Z0_QTD, 
			 Z0_VALOR,
			 Z0_QTD * Z0_VALOR, 
			 Z0_ATIVO 
	FROM %Table:SZ0%
		JOIN %Table:SB1% A on (Z0_PROD = B1_COD)
		WHERE Z0_FILIAL =  %xFilial:SZ0%
		AND A.%NotDel%
EndSQL
        
aSQL := GetLastQuery()
msgInfo(aSQL[2])

If Select( cAliasSucata ) == 0
	(cAliasFor)->( dbCloseArea() )
EndIf	     

 dbSelectArea( cAliasSucata )
 (cAliasSucata)->( dbGoTop() ) 
 
 aSucata := {} 

While ! (cAliasSucata)->(EOF())
     AADD ( aSucata, { (cAliasSucata)->Z0_COD   ,;
	 							(cAliasSucata)->B1_DESC   ,;
							   (cAliasSucata)->Z0_QTD   ,;
							    (cAliasSucata)->Z0_VALOR   ,;
							     (cAliasSucata)->Z0_VALOR * Z0_QTD ,;
						  IIF((cAliasSucata)->Z0_ATIVO <> "S" , "Não","Sim" ) } )  

	(cAliasSucata)->(dbSkip())
EndDo           

 If Empty(aSucata) 
	aSucata	:=	{{ "","","","","",""}}
 EndIf	  


Return( NIL )


//******************************************************************************************************

Static Function Sair()

	
	oDlg:END()	
	

Return( NIL )

//******************************************************************************************************



