#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMC001  �Autor  �Microsiga           � Data �  05/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function GENMC01J(aParam)

Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nX			:= 0
Local nLimite		:= 50  

Conout("GENMC01J - Iniciando Job - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENMC01J - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENMC01J - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENMC01J",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENMC01J - N�o foi poss�vel executar a job neste momento pois a fun��o GENMC01J j� esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

Conout("GENMC01J - iniciando processamento das notas intercia - "+Time()+".")
U_GENMC001(.T.)
Conout("GENMC01J - finalizado processamento com sucesso das notas intercia - "+Time()+".")

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENMC01J - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENMC01J",.T.,.T.,.T.)

Conout("GENMC01J - Finalizando Job - "+Time()+".")

Return nil  

User Function GENMC001(lJobProc)

Local cDirXML	:= SuperGetMv("GEN_XMC001",.f.,"\imp_xml\")
Local cTmpXML	:= cDirXML+"TEMP\"
Local cDirUsr	:= ""
Local cPerg		:= "GENMC001"
Local aLog		:= {} 
Local aCpFile	:= {}
Local aFilFor	:= {}

Local nX		:= 0
Local nAuxCp	:= 0

Default lJobProc	:= .F.

WFForceDir(cDirXML)
WFForceDir(cTmpXML)

PutSx1(cPerg, "01", "Dt.Digita��o De:  ",	"" ,"",	"mv_ch1" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Dt.Digita��o Ate: ",	"" ,"",	"mv_ch2" , "D", 08, 0, 0, "G","", "", "", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(cPerg ,"03", "Processar"			,	"" ,"", "mv_ch3" , "N", 01, 0, 0, "C","", "", "", "", "MV_PAR03","Todas","Todas","Todas","","Processa XML","Processa XML","Processa XML","Processa Notas Fiscais","Processa Notas Fiscais","Processa Notas Fiscais","Proc.Intercompany","Proc.Intercompany","Proc.Intercompany","","","",nil,nil,nil,	"")
PutSx1(cPerg ,"04", "Diretorio"			,	"" ,"", "mv_ch4" , "C", 99, 0, 0, "C","", "DIRXML", "", "", "MV_PAR04","","","","","","","","","","","","","","","","",nil,nil,nil,"")

If lJobProc
	Pergunte(cPerg,.F.)
	MV_PAR01 := FIRSTDATE(Date())
	MV_PAR02 := Date()
	MV_PAR03 := 4
	MV_PAR04 := ""
ElseIf !Pergunte(cPerg,.T.)
	Return()
Endif
	    
If MV_PAR03 == 1 .OR.  MV_PAR03 == 2 

	cDirUsr := AllTrim(MV_PAR04)
	
	If !Left(cDirUsr,1) == "1" // verifico se o diretorio � rootpath
		If Right(cDirUsr,1) <> "\"
			cDirUsr +="\"
		EndIf
			aCpFile	:= DIRECTORY(cDirUsr+"*.xml")
			For nAuxCp := 1 To Len(aCpFile)
				CPYT2S(cDirUsr+aCpFile[nAuxCp][1], cTmpXML)
			Next
	EndIF
		
	Processa({|| ProcXML(AllTrim(cTmpXML),@aLog) },"Processando arquivos XML...")
	
	aCpFile	:= DIRECTORY(cTmpXML+"*.xml")
	For nAuxCp := 1 To Len(aCpFile)
		//CPYT2S(cTmpXML+aCpFile[nAuxCp][1], cDirXML)
		__CopyFile(cTmpXML+aCpFile[nAuxCp][1], cDirXML+aCpFile[nAuxCp][1])
		FErase(cTmpXML+aCpFile[nAuxCp][1])
	Next
					
EndIf

If MV_PAR03 == 1 .OR.  MV_PAR03 == 3
	Processa({|| ProcNOTAS(AllTrim(cDirXML),@aLog) },"Processando Notas Fiscais...")
EndIF	

If MV_PAR03 == 1 .OR.  MV_PAR03 == 4

	//������������������������������������������������������������������������������Ŀ
	//� Estrutura do array aFilFor:                                                  �
	//� [1] - Nota de entrada: Filial do Fornecedor                                  �
	//� [2] - Nota de entrada: Codigo do Fornecedor                                  �
	//� [3] - Nota de entrada: Loja do Fornecedor                                    �
	//� [4] - Nota de saida: Filial do Cliente                                       �
	//� [5] - Nota de saida: Codigo do Cliente                                       �
	//� [6] - Nota de saida: Loja do Cliente                                         �
	//��������������������������������������������������������������������������������
	aAdd(aFilFor, {'1022', '0380795', '01', '2022', '0005065'	, '01'})
	aAdd(aFilFor, {'1022', '0380796', '01', '3022', '0005065'	, '01'})
	aAdd(aFilFor, {'1022', '0380794', '01', '4022', '0005065'	, '01'})
	aAdd(aFilFor, {'1022', '031811'	, '02', '6022', '0005065'	, '01'})
	aAdd(aFilFor, {'1022', '0378128', '07', '9022', '0005065'	, '01'})

	aAdd(aFilFor, {'2022', '0005065', '01', '1022', '0380795'	, '01'})
	aAdd(aFilFor, {'3022', '0005065', '01', '1022', '0380796'	, '01'})
	aAdd(aFilFor, {'4022', '0005065', '01', '1022', '0380794'	, '01'})
	aAdd(aFilFor, {'6022', '0005065', '01', '1022', '031811'	, '02'})
	aAdd(aFilFor, {'9022', '0005065', '01', '1022', '0378128'	, '07'})

	For nX := 1 To Len(aFilFor)
		//������������������������������������������������������������������������������Ŀ
		//� Processamento de notas de entrada de todas as filiais                        �
		//��������������������������������������������������������������������������������
		Processa({|| ProcNFInterCO(@aLog, aFilFor[nX]) },"Processando Notas Intercompany...")
	Next nX
EndIF	

If Len(aLog) > 0 .AND. !lJobProc
	ViewLog(aLog)
EndIF	

Return nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMC001  �Autor  �Microsiga           � Data �  05/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcNOTAS(cDirXML,aLog)

Local cAliasTmp	:= GetNextAlias()
Local aFileXML	:= {}
Local cError	:= ""
Local cWarning	:= ""

ProcRegua(0)
IncProc()

SF3->(dbSetOrder(4))//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE                                                                                                                
SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO 

BeginSql Alias cAliasTmp 
	SELECT SF1.R_E_C_N_O_ SF1RECNO,TO_CHAR(TO_NUMBER(X5_DESCRI))||SUBSTR(F1_EMISSAO,3,4)||A2_CGC||'55'||'???'||LPAD(TRIM(F1_DOC),9,'0') CHAVE FROM %Table:SF1% SF1
	JOIN %Table:SA2% SA2
	ON A2_FILIAL = %xFilial:SA2%
	AND A2_COD = F1_FORNECE
	AND A2_LOJA = F1_LOJA
	AND SA2.%NotDel%
	JOIN %Table:SX5% SX5
	ON X5_FILIAL = ' '
	AND X5_TABELA = 'AA'
	AND X5_CHAVE = F1_EST
	AND SX5.%NotDel%
	WHERE F1_FILIAL = %xFilial:SF1%
	AND F1_DTDIGIT BETWEEN %Exp:DtoS(MV_PAR01)% AND %Exp:DtoS(MV_PAR02)%
	AND F1_ESPECIE = 'SPED'
	AND F1_TIPO NOT IN ('D','B')
	AND F1_CHVNFE = ' '
	AND SF1.%NotDel%
	UNION 
	SELECT SF1.R_E_C_N_O_ SF1RECNO,TO_CHAR(TO_NUMBER(X5_DESCRI))||SUBSTR(F1_EMISSAO,3,4)||A1_CGC||'55'||'???'||LPAD(TRIM(F1_DOC),9,'0') CHAVE FROM %Table:SF1% SF1
	JOIN %Table:SA1% SA1
	ON A1_FILIAL = %xFilial:SA1%
	AND A1_COD = F1_FORNECE
	AND A1_LOJA = F1_LOJA
	AND SA1.%NotDel%
	JOIN %Table:SX5% SX5
	ON X5_FILIAL = ' '
	AND X5_TABELA = 'AA'
	AND X5_CHAVE = F1_EST
	AND SX5.%NotDel%
	WHERE F1_FILIAL = %xFilial:SF1%
	AND F1_DTDIGIT BETWEEN %Exp:DtoS(MV_PAR01)% AND %Exp:DtoS(MV_PAR02)%
	AND F1_ESPECIE = 'SPED'
	AND F1_TIPO IN ('D','B')
	AND F1_CHVNFE = ' '
	AND SF1.%NotDel%
EndSql

(cAliasTmp)->(DbGoTop())
While (cAliasTmp)->(!EOF())
	 
	aFileXML	:= DIRECTORY(cDirXML+"???"+PADR(AllTrim((cAliasTmp)->CHAVE),44,"?")+".XML")
	If Len(aFileXML) == 0
		aFileXML	:= DIRECTORY(cDirXML+PADR(AllTrim((cAliasTmp)->CHAVE),44,"?")+".XML")
	EndIf
	If Len(aFileXML) > 0
		SF1->(DbGoTo((cAliasTmp)->SF1RECNO))
		If Empty(SF1->F1_CHVNFE)
			
			cFile	:= cDirXML+aFileXML[1,1]
			
			//Gera o Objeto XML
			oXml := XmlParserFile( cFile, "_", @cError, @cWarning )	
			lContinua	:= .F.
			
			If !Empty(cError)
				
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,cError} )
				
			Else
			
				Do Case
					//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT") == "U"
				 	Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE, "_MOD" )) == "U"
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_IDE:_MOD"} )
					Case oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT <> "55"
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Modelo de XML "+oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT+" n�o contemplado pela rotina"} )				
					//Case Type("oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT") == "U"
					Case !Valtype(XmlChildEx(oXml:_NFEPROC:_PROTNFE:_INFPROT, "_CHNFE" )) == "U"
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_PROTNFE:_INFPROT:_CHNFE"} )  
					//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT") == "U"
					Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT, "_CNPJ" )) == "U"					
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ"} )
					//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT") == "U"
					Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE, "_NNF" )) == "U"					
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_IDE:_NNF"} )
					//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT") == "U"
					Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE, "_SERIE" )) == "U"					
						Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFE:_INFNFE:_IDE:_SERIE"} )  
					OtherWise
						lContinua	:= .T.	
				EndCase
					
			EndIf
			
			If lContinua
				RecLock("SF1",.F.)
				SF1->F1_CHVNFE	:= oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
				MsUnLock()			

				SF3->(DbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
				While !SF3->(Eof()) .And. SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE == SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE			
					
					If AllTrim(SF3->F3_CHVNFE) <> AllTrim(SF1->F1_CHVNFE) .AND. !Empty(SF1->F1_CHVNFE)
						RecLock("SF3",.F.)
						SF3->F3_CHVNFE	:= SF1->F1_CHVNFE
						MsUnLock()
					EndIF
					
					SF3->(DbSkip())
				EndDo
				
				cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
				If SFT->(DbSeek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)) .AND. !Empty(SF1->F1_CHVNFE)
					While SFT->(!Eof()) .AND. cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
						RecLock("SFT",.F.)
						SFT->FT_CHVNFE := SF1->F1_CHVNFE
						MsUnLock()
						SFT->(dbSkip())
					EndDo
				EndIf				
			EndIf

			FT_FUse()
			//FreeObj(oXml)
				
		EndIf
	EndIF
	
	(cAliasTmp)->(Dbskip())
EndDo

Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENMC001  �Autor  �Microsiga           � Data �  05/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcXML(cDirXML,aLog)

Local aFileXML	:= DIRECTORY(cDirXML+"*.XML")
Local nLen		:= Len(aFileXML)
Local nAux		:= 0
Local cError	:= ""
Local cWarning	:= ""
Local cFile		:= ""
Local lContinua	:= .F. 
Local cAliasXML	:= GetNextAlias()

ProcRegua(nLen)

SF3->(dbSetOrder(4))//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE                                                                                                                
SFT->(dbSetOrder(1))//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO                                                                                  

For nAux := 1 To nLen

	IncProc(StrZero(nAux,6)+" de "+StrZero(nLen,6))
	
	cFile	:= cDirXML+aFileXML[nAux,1]
	
	//Gera o Objeto XML
	oXml := XmlParserFile( cFile, "_", @cError, @cWarning )	
	lContinua	:= .F.
	
	If !Empty(cError)
		
		Aadd(aLog, {"Falha ao ler aquivo "+cFile,cError} )
		
	Else
	
		Do Case
			//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT") == "U"
			Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE, "_MOD" )) == "U"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_IDE:_MOD"} )
			Case oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT <> "55"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Modelo de XML "+oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_MOD:TEXT+" n�o contemplado pela rotina"} )				
			//Case Type("oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT") == "U"
			Case !Valtype(XmlChildEx(oXml:_NFEPROC:_PROTNFE:_INFPROT, "_CHNFE" )) == "U"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_PROTNFE:_INFPROT:_CHNFE"} )  
			//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT") == "U"
			Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT, "_CNPJ" )) == "U"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ"} )
			//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT") == "U"              
			Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE, "_NNF" )) == "U"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFEPROC:_NFE:_INFNFE:_IDE:_NNF"} )
			//Case Type("oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT") == "U"
			Case !Valtype(XmlChildEx(oXml:_NFEPROC:_NFE:_INFNFE:_IDE,"_SERIE" )) == "U"
				Aadd(aLog, {"Falha ao ler aquivo "+cFile,"Falha na estrutura do XMl n�o localizada TAG _NFE:_INFNFE:_IDE:_SERIE"} )  
			OtherWise
				lContinua	:= .T.	
		EndCase
			
	EndIf
	
	If lContinua
		
		If Select(cAliasXML) > 0
			(cAliasXML)->(DbCloseArea())
		EndIf
		
		BeginSql Alias cAliasXML
			
			SELECT SF1.R_E_C_N_O_ SF1RECNO FROM %Table:SF1% SF1
			JOIN %Table:SA2% SA2
			ON A2_FILIAL = %xFilial:SA2%
			AND A2_COD = F1_FORNECE
			AND A2_LOJA = F1_LOJA
			AND SA2.D_E_L_E_T_ <> '*'
			JOIN %Table:SX5% SX5
			ON X5_FILIAL = ' '
			AND X5_TABELA = 'AA'
			AND X5_CHAVE = F1_EST
			AND SX5.%NotDel%
			WHERE F1_ESPECIE = 'SPED'
			AND F1_CHVNFE = ' '
			AND F1_TIPO NOT IN ('D','B')
			AND SF1.%NotDel%
			AND A2_CGC = %Exp:oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT%
			AND LPAD(TRIM(F1_DOC),9,'0') = %Exp:Padl(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")%
			AND LPAD(TRIM(F1_SERIE),3,'0') = %Exp:Padl(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT),3,"0")%
			UNION 
			SELECT SF1.R_E_C_N_O_ SF1RECNO FROM %Table:SF1% SF1
			JOIN %Table:SA1% SA1
			ON A1_FILIAL = %xFilial:SA1%
			AND A1_COD = F1_FORNECE
			AND A1_LOJA = F1_LOJA
			AND SA1.%NotDel%
			JOIN %Table:SX5% SX5
			ON X5_FILIAL = ' '
			AND X5_TABELA = 'AA'
			AND X5_CHAVE = F1_EST
			AND SX5.%NotDel%
			WHERE F1_ESPECIE = 'SPED'
			AND F1_CHVNFE = ' '
			AND F1_TIPO IN ('D','B')
			AND SF1.%NotDel%
			AND A1_CGC = %Exp:oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT%
			AND LPAD(TRIM(F1_DOC),9,'0') = %Exp:Padl(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0")%
			AND LPAD(TRIM(F1_SERIE),3,'0') = %Exp:Padl(AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT),3,"0")%		
			
		EndSql
		
		(cAliasXML)->(DbGoTop())
		If (cAliasXML)->(!EOF())
			SF1->(DbGoTo((cAliasXML)->SF1RECNO))
			If Empty(SF1->F1_CHVNFE)
				RecLock("SF1",.F.)
				SF1->F1_CHVNFE	:= oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
				MsUnLock()
			EndIF
			
			SF3->(DbSeek(SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
			While !SF3->(Eof()) .And. SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE == SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE			
				
				If AllTrim(SF3->F3_CHVNFE) <> AllTrim(SF1->F1_CHVNFE) .AND. !Empty(SF1->F1_CHVNFE)
					RecLock("SF3",.F.)
					SF3->F3_CHVNFE	:= SF1->F1_CHVNFE
					MsUnLock()
				EndIF
				
				SF3->(DbSkip())
			EndDo
			
			cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
			If SFT->(DbSeek(cChave)) .AND. !Empty(SF1->F1_CHVNFE)
				While SFT->(!Eof()) .AND. cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
					RecLock("SFT",.F.)
					SFT->FT_CHVNFE := SF1->F1_CHVNFE
					MsUnLock()
					SFT->(dbSkip())
				EndDo
			EndIf
										
		EndIF
		(cAliasXML)->(DbCloseArea())
	EndIf
	       
	FT_FUse()
	If lContinua
		If !(AllTrim(oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT) $ cFile)
			Frename(cFile , cDirXML+"Nfe"+AllTrim(oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT)+".XML" )
		EndIf
    EndIf
    
	//FreeObj(oXml)
	
Next nAux


Return nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA043   �Autor  �Microsiga           � Data �  11/24/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewLog(aLog)

Local oReport

oReport := reportDef(aLog)
oReport:printDialog()

Return

Static function ReportDef(aLog)

local oReport
local cTitulo	:= "Log de processamento"
local cPerg		:= ""

oReport := TReport():New(FunName(), cTitulo, cPerg , {|oReport| PrintReport(oReport,aLog)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Mensagens",{""})

TRCell():New(oSection0,"LOG"  ,,"Log",,300)
TRCell():New(oSection0,"MSG"  ,,"Mensagem",,300)

return (oReport)


Static Function PrintReport(oReport,aLog)

Local oSection0 := oReport:Section(1)
Local nx		:= 0

For nx:=1 To Len(aLog)
 
 oReport:IncMeter()
 
 oSection0:Init()
 
 oSection0:Cell("LOG"):SetValue(aLog[nx][1])
 oSection0:Cell("MSG"):SetValue(aLog[nx][2])
 
 oSection0:PrintLine()      
  
Next nx

oSection0:Finish()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcNFInte� Autor � Renato Calabro'    � Data �  07/14/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que efetua o processamento de chave NFE de saida em ���
���          � notas fiscais de entrada, considerando filiais enviadas    ���
���          � por parametro                                              ���
�������������������������������������������������������������������������͹��
���Parametros� aExp1 - Array com dados de fornecedor/cliente a processar: ���
���          �        [1] - Nota de entrada: Filial do Fornecedor         ���
���          �        [2] - Nota de entrada: Codigo do Fornecedor         ���
���          �        [3] - Nota de entrada: Loja do Fornecedor           ���
���          �        [4] - Nota de saida: Filial do Cliente              ���
���          �        [5] - Nota de saida: Codigo do Cliente              ���
���          �        [6] - Nota de saida: Loja do Cliente                ���
�������������������������������������������������������������������������͹��
���Retorno   � Nil                                                        ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcNFInterCO(aLog, aFilFor)

Local cAliasTmp	:= GetNextAlias()
Local cFilFor	:= aFilFor[1]
Local cFornece	:= aFilFor[2]
Local cLjForn	:= aFilFor[3]
Local cFilCli	:= aFilFor[4]
Local cCliente	:= aFilFor[5]
Local cLjCli	:= aFilFor[6]

Local nX		:= 1
Local nTotReg	:= 0

Default aLog	:= {}

SF3->(dbSetOrder(4))	//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE                                                                                                                
SFT->(dbSetOrder(1))	//FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO 

BeginSql Alias cAliasTmp 

	SELECT SF1.R_E_C_N_O_ SF1RECNO, SF2.F2_CHVNFE 
	  FROM %Table:SF2% SF2
	  JOIN %Table:SF1% SF1
    	ON SF1.F1_FILIAL = %Exp:cFilFor%
	   AND LPAD(TRIM(SF1.F1_DOC),%Exp:TamSX3("F1_DOC")[1]%,'0') = LPAD(TRIM(SF2.F2_DOC),%Exp:TamSX3("F2_DOC")[1]%,'0')
	   AND SF1.F1_SERIE = SF2.F2_SERIE
	   AND SF1.F1_FORNECE = %Exp:cFornece%
	   AND SF1.F1_LOJA = %Exp:cLjForn%
	   AND SF1.F1_ESPECIE = 'SPED'
	   /*AND SF1.F1_CHVNFE = ' '*/
	   AND SF1.%NotDel%
	 WHERE SF2.F2_FILIAL = %Exp:cFilCli%
	   AND SF2.F2_CLIENTE = %Exp:cCliente%//'0378128'--'0380796'--'0380795'
	   AND SF2.F2_LOJA = %Exp:cLjCli%
	   AND SF2.F2_CHVNFE <> ' '
	   AND SF2.F2_ESPECIE = 'SPED'
	   AND SF1.F1_DTDIGIT BETWEEN %Exp:DtoS(MV_PAR01)% AND %Exp:DtoS(MV_PAR02)%	   
	   AND SF2.%NotDel%
EndSql

nTotReg := Contar(cAliasTmp, "!EOF()")
ProcRegua(nTotReg)

(cAliasTmp)->(DbGoTop())
While (cAliasTmp)->(!EOF())
	 
	SF1->(DbGoTo((cAliasTmp)->SF1RECNO))
	IncProc("Atual.NF Entrada: " + SF1->F1_DOC + "/" + SF1->F1_SERIE + " - " + cValToChar(nX++) + "/" + cValToChar(nTotReg))

	If Empty(SF1->F1_CHVNFE)

		//������������������������������������������������������������������������������Ŀ
		//� Atualizacao de nota fiscal de entrada - SF1                                  �
		//��������������������������������������������������������������������������������
		RecLock("SF1",.F.)
			SF1->F1_CHVNFE := (cAliasTmp)->F2_CHVNFE
		SF1->( MsUnLock() )			
	ENDIF

	//������������������������������������������������������������������������������Ŀ
	//� Atualizacao de livros fiscais - SF3                                          �
	//��������������������������������������������������������������������������������
	SF3->(DbSeek(xFilial("SF3")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE))
	While !SF3->(Eof()) .And. SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE == SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE			
		If AllTrim(SF3->F3_CHVNFE) <> AllTrim(SF1->F1_CHVNFE) .AND. !Empty(SF1->F1_CHVNFE)
			RecLock("SF3",.F.)
				SF3->F3_CHVNFE	:= SF1->F1_CHVNFE
			SF3->( MsUnLock() )
		EndIF
		SF3->( DbSkip() )
	EndDo
	
	cChave := SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA
	If SFT->(DbSeek(SF1->F1_FILIAL+"E"+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)) .AND. !Empty(SF1->F1_CHVNFE)
		While SFT->(!Eof()) .AND. cChave == SFT->FT_FILIAL+"E"+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
			If AllTrim(SFT->FT_CHVNFE) <> AllTrim(SF1->F1_CHVNFE)
				RecLock("SFT",.F.)
					SFT->FT_CHVNFE := SF1->F1_CHVNFE
				SFT->( MsUnLock() )				
			EndIf
			SFT->( DbSkip() )
		EndDo
	EndIf				

	(cAliasTmp)->( Dbskip() )
EndDo

Return Nil
