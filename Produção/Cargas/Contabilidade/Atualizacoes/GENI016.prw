#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  GENI016    � Autor �Alessandra Pinheiro � Data � 28/03/2013   ���
�������������������������������������������������������������������������͹��
���Descricao � Importa��o de classe de valor.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Ateracao �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function GENI016


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt
Private cString := "SB1"                                                                                               
Private cArqTxt := ""

dbSelectArea("SB1")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

Define MSDialog oLeArq  Title "Importa��o de Produtos" From 000,000 to 150,380 Pixel
@ 000,003 to 075,190 Pixel 
@ 010,018 Say " Este programa ira ler o conteudo da tabela de Produtos atrav�s " pixel
@ 018,018 Say " de View, e import�-los para a tabela CTH (CLASSE DE VALOR).           " pixel

oTButton1 := TButton():Create( oLeArq,055,095,"Ok",{||Processa({|| RunCont() },"Processando..."),oLeArq:End()},;
                  036,012,,,,.T.,,,,,,)
oTButton2 := TButton():Create( oLeArq,055,135,"Cancelar",{||oLeArq:End()},;
                  036,012,,,,.T.,,,,,,)

Activate Dialog oLeArq Centered


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLEArq  � Autor � AP6 IDE            � Data �  27/12/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeArq



//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  27/12/09   ���
����������������������������������'���������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local lErro   := .F.
Local nItens  := 0
Local cFilBkp := cFilant //Para salvar a filial original
Local cPath   := "\LogSiga\classe\"                         
Local cFile   := ""
Local cQuery    
Local cQueryINS
Local nTotReg := 0
Local cGrupo:= ""                    
//Local cBaseTrans := Upper(Alltrim(GetMV("MV_XBASETR"))) // Nome da base de Transferencia.

Private lMSHelpAuto := .F. // para nao mostrar os erro na tela
Private lMSErroAuto := .f. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasQry := GetNextAlias()
Private nTotReg 	:= 0

cQuery := "SELECT * FROM TT_I03_PRODUTO@TOTVS_LINK tt "


DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)

Count TO nTotReg// Conta Registro 

dbSelectArea(cAliasQry)
dbGoTop()

ProcRegua(nTotReg) // Numero de registros a processar

nItens:= 0
While !(cAliasQry)->(Eof())
	
	nItens++
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//����������������������������������������������������������������������
	
	IncProc("Importando Classe de valor...  Linha "+cValtoChar(nItens))
	
   //	cFilant:=(cAliasQry)->B1_FILIAL //Atualiza a filial da importa��o
	
	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������
	
	*'Alessandra Pinheiro - 28/03/13    					 			'*  
	*'Altera��o feita para gravar s� os campos de classe de valor na CTH'* 
	
	
//Campos obrigat�rios na CTH
cCodObra:=StrZero((cAliasQry)->B1_COD,9)
cCodProd:= (cAliasQry)->B1_COD 
cDesc:=(cAliasQry)->B1_DESC                                          
//cClasse:=(cAliasQry)->B1_CLASSE
//cFilial:=(cAliasQry)->B1_Filial 
		
  	DbSelectArea("CTH")
	DbSetOrder(1)
	//If !DbSeek(xFilial("CTH")+cCodProd)
		
		aRotAuto := {{"CTH_CLVL" , cCodObra						, Nil},;
					{"CTH_CLASSE", "2"					, Nil},;
					{"CTH_DESC01", Alltrim(Upper(cDesc))	    , Nil}}  
		
  	DbSelectArea("CTH")
	DbSetOrder(1)
    MSExecAuto({|x, y| CTBA060(x, y)},aRotAuto, 3)
		If lMSErroAuto //deu erro (retorno de msexecauto)
		
		
			lErro := .T.
			cHora:= StrTran(Time(),":")

			cHora:= SubStr(cHora,1,2)+"h"+SubStr(cHora,3,2)+"m"+SubStr(cHora,5,2)+"s"
			cFile := Dtos(dDataBase) + "-" + cHora + " - Cod "+Alltrim(cCodObra)+".log"

			MostraErro(cpath, cfile)
				
			
			DisarmTransaction()
			lMsErroAuto := .F.			
     			
		EndIf	
		               
   //	Else 
  //		cFile := "ErrImpCTH_" +Alltrim((cAliasQry)->B1_CLVL) + "_" + Dtos(dDatabase)  + ".log"
   //		cTexto:= "Classe de valor "+Alltrim((cAliasQry)->B1_CLVL)+" j� existe na base, favor verificar. "
   //		MemoWrite(cpath+cFile,cTexto)			
   //	EndIf
	
    //Comentado por Alessandra Pinheiro - 28/03/2013//
	 /*                         
	cCodProd:= StrZero((cAliasQry)->B1_COD,10)
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB1")+cCodProd)
		
		aProdutos := {{"B1_COD" , cCodProd, Nil},;
		{"B1_DESC"   , Alltrim(Upper((cAliasQry)->B1_DESC))     , Nil},;
		{"B1_TIPO"   , (cAliasQry)->B1_TIPO	    , Nil},; // Conforme orienta��o todos os produtos serao importados como PA
		{"B1_UM"     , (cAliasQry)->B1_UM		, Nil},;
		{"B1_LOCPAD" , "01"  					, Nil},;
		{"B1_CODBAR" , cValtochar((cAliasQry)->B1_CODBAR)   , Nil},;
		{"B1_MSBLQL" , cValtochar((cAliasQry)->B1_MSBLQL)  	, Nil}}
		 
		
		DbSelectArea("SB1")
		DbSetOrder(1)
		MSExecAuto({|x, y| Mata010(x, y)},aProdutos, 3)
		If lMSErroAuto //deu erro (retorno de msexecauto)
			lErro := .T.
			cHora:= StrTran(Time(),":")

			cHora:= SubStr(cHora,1,2)+"h"+SubStr(cHora,3,2)+"m"+SubStr(cHora,5,2)+"s"
			cFile := Dtos(dDataBase) + "-" + cHora + " - Cod "+Alltrim((cAliasQry)->B1_COD)+".log"

			MostraErro(cpath, cfile)
			DisarmTransaction()
			lMsErroAuto := .F.			
        Else    
        	DbSelectARea("SB5")
        	DbSetOrder(1)
        	If !DbSeek(xFilial("SB5")+cCodProd)
				RecLock("SB5",.T.)
				SB5->B5_FILIAL := XFILIAL("SB5")
				SB5->B5_COD := cCodProd
				SB5->B5_CEME := Alltrim(Upper((cAliasQry)->B1_DESC))
				SB5->(MsUnlock())			
			EndIf	
		Endif               
	Else 
		cFile := "ErrImpB1_" +Alltrim((cAliasQry)->B1_COD) + "_" + Dtos(dDatabase)  + ".log"
		cTexto:= "Produto "+Alltrim((cAliasQry)->B1_COD)+" j� existe na base. "
		MemoWrite(cpath+cFile,cTexto)			
	EndIf
	                    

   	//�������������������������������������������������������
	//�GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO�	
	//�������������������������������������������������������
	
	If !lMsErroAuto
				
		cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
		cQueryINS += " VALUES ( 'TT_I03_PRODUTO','B1_COD','"+(cAliasQry)->B1_COD+"','"+(cAliasQry)->B1_FILIAL+"') "   
		TCSqlExec( cQueryINS )
		
	EndIf
	
	//-------------------------------------------------------
	        
	 */ 	                                
	        
	DbSelectARea(cAliasQry)
	DbSkip()
EndDo

DbSelectarea(cAliasQry)
DbcloseArea()


If !lErro
	Aviso("Aviso","Importa��o Finalizada com Sucesso!", {"Ok"} )
else
    Aviso("Aviso","Importa��o finalizada, mas ocorreram algumas inconsist�ncias, verifique a pasta LogSiga", {"Ok"} )
endif

Return                                  
