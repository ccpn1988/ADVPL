
/* ESTRUTURA DO PARAMETRO SX6 */
#DEFINE N_TES	1
#DEFINE N_NAT	2
#DEFINE N_PRO	3
#DEFINE N_DIR	4  
#DEFINE N_PGT 5
#DEFINE N_SIZE 5

/* ESTRUTURA DO ARQUIVO DE LOG */
#DEFINE N_STS	1
#DEFINE N_MSG	2
#DEFINE N_CTE	3
#DEFINE N_SER	4
#DEFINE N_FOR	5
#DEFINE N_XML	6

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA080  บAutor  ณCleuto Lima 		   บ Data ณ  27/09/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de XML de conhecimento de frete.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Gen                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA080()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis da rotina.                                                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cCadastro	:= "Importa็ใo XML CTE"
Local aRet 		:= {}
Local aCfgCTE		:= Separa(SuperGetMv("GEN_COM022",.F.,";;;"),";")
Local aFiles		:= {}

Private nOpcA	:= 0
Private aLog	:= {}

If Len(aCfgCTE) <> 5
	xMagHelpFis("Parametros SX6","A estrutura de parametros nใo estแ correta!","Verifique se o aprametro GEN_COM022 contem a estrutura TES;NATUREZA;PRODUTO;DIRETORIO ")
	Return nil
EndIf

SF4->(DbSetOrder(1))
SB1->(DbSetOrder(1))
SED->(DbSetOrder(1))
SE4->(DbSetOrder(1))

Do Case
	Case Empty(aCfgCTE[N_TES])
		MsgStop("TES para processamento do conhecimento de frete nใo informada, verificar parametro GEN_COM022!")
		Return nil
	Case !SF4->(DbSeek( xFilial("SF4")+aCfgCTE[N_TES] ))
		MsgStop("TES "+aCfgCTE[N_TES]+" nใo localizada, verificar parametro GEN_COM022!")
		Return nil 
		
	Case Empty(aCfgCTE[N_NAT] )
		MsgStop("Natureza para processamento do conhecimento de frete nใo informada, verificar parametro GEN_COM022!")
		Return nil
	Case !SED->(DbSeek( xFilial("SED")+aCfgCTE[N_NAT] ))
		MsgStop("Natureza "+aCfgCTE[N_NAT]+" nใo localizada, verificar parametro GEN_COM022!")
		Return nil

	Case Empty(aCfgCTE[N_PRO] )
		MsgStop("Produto para processamento do conhecimento de frete nใo informado, verificar parametro GEN_COM022!")
		Return nil
	Case !SB1->(DbSeek( xFilial("SB1")+aCfgCTE[N_PRO] ))
		MsgStop("Produto "+aCfgCTE[N_PRO]+" nใo localizado, verificar parametro GEN_COM022!")
		Return nil
	Case Empty(aCfgCTE[N_PGT])	
		MsgStop("Condi็ใo de pagamento "+aCfgCTE[N_PGT]+" nใo informada, verificar parametro GEN_COM022!")
		Return nil		
	Case !SE4->(DbSeek(xFilial("SE4")+aCfgCTE[N_PGT]))	
		MsgStop("Condi็ใo de pagamento "+aCfgCTE[N_PGT]+" nใo localizada, verificar parametro GEN_COM022!")
		Return nil						
EndCase

///Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet
ParamBox({ {06,"Diretorio XML"		,Space(150),"",".F.",".T.",80,.F.,"*.XML/*.XML",Space(150),GETF_RETDIRECTORY  + GETF_LOCALHARD} },cCadastro,@aRet,{|x| nOpcA := 1 },,,,,,,.T.,.T.)

If nOpcA <> 1
	Return
EndIf

aRet[1] := AllTrim(aRet[1])
aRet[1] := aRet[1]+IIF( Right(aRet[1],1) == "" , "\" , "")
 
aCfgCTE[N_DIR] := AllTrim(aCfgCTE[N_DIR])
aCfgCTE[N_DIR] := aCfgCTE[N_DIR]+IIF( Right(aCfgCTE[N_DIR],1) == "\" , "" , "\")
  
aFiles := Directory(Alltrim(aRet[1])+"*.xml")

If Len(aFiles) == 0
	MsgStop("Nใo foram encontrados arquivos XML para serem importados!")
	Return nil
EndIf

LJMsgRun("Processando arquivos...","Aguarde...",{|| ProcXML(aFiles,aCfgCTE,aRet[1]) })

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcXML  บAutor  ณCleuto Lima          บ Data ณ  27/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa arquivos XML CTe.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Gen                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcXML(aFiles,aCfgCTE,cDirUsr)

Local nAuxCTE		:= 0
Local aCteProd	:= {}
Local cError		:= ""
Local cWarning	:= ""
Local oXml			:= nil
Local oCTE			:= nil

Local aCabCTe 	:= {}		
Local dDtEmiCte	:= CtoD("  /  /  ")
Local cNumCte		:= ""
Local cSerieCte	:= ""
Local cChvCte		:= ""
Local aItAux		:= {}
Local aItens		:= {}
Local nQtdErro	:= 0
Local nQtdOk		:= 0
Local cCGC 		:= ""
Local cCPFCNPJ 	:= ""		
For nAuxCTE := 1 To Len(aFiles)
	
	If !__CopyFile( cDirUsr + aFiles[nAuxCTE][1] , aCfgCTE[N_DIR]+aFiles[nAuxCTE][1])		
		//xAddLog(cMsgLog,cCteLog,cSerLog,cForLog,cCmlLog)
		If aCfgCTE[N_DIR]+aFiles[nAuxCTE][1]
			xAddLog("FALHA","Falha ao copiar arquivo XML para o deritorio do Protheus, arquivo jแ existe!","","","",cDirUsr + aFiles[nAuxCTE][1])
		Else
			xAddLog("FALHA","Falha ao copiar arquivo XML para o deritorio do Protheus!","","","",cDirUsr + aFiles[nAuxCTE][1])
		EndIf
		nQtdErro++	
		Loop
	Else
		Aadd(aCteProd, aCfgCTE[N_DIR]+aFiles[nAuxCTE][1] )	
	EndIf

Next nAuxCTE

If Len(aCteProd) > 0
	For nAuxCTE := 1 To Len(aCteProd)

		SF4->(DbSetOrder(1))
		SB1->(DbSetOrder(1))
		SED->(DbSetOrder(1))
		SE4->(DbSetOrder(1))
		SF1->(DbSetOrder(1))

		SF4->(DbSeek( xFilial("SF4")+aCfgCTE[N_TES] ))
		SED->(DbSeek( xFilial("SED")+aCfgCTE[N_NAT] ))
		SB1->(DbSeek( xFilial("SB1")+aCfgCTE[N_PRO] ))
		SE4->(DbSeek( xFilial("SE4")+aCfgCTE[N_PGT] ))		
			
		cError		:= ""
		cWarning	:= ""
		oXml		:= nil
		oCTE		:= nil
		
		IncProc("Proc.. "+StrZero(nAuxCTE,4)+" de "+StrZero(Len(aCteProd),4))
		
		oXml := XmlParserFile( aCteProd[nAuxCTE], "_", @cError, @cWarning )
		
		If ValType(oXml) != "O"
			nQtdErro++
			xAddLog("FALHA","Falha ao ler aquivo XML!"+chr(13)+chr(10)+cError+" "+cWarning,"","","",aCteProd[nAuxCTE])
			Loop			
		Endif
		
		Do Case
			Case ValType(XmlChildEx( oXml , "_CTEPROC" )) == "O"
				oCTE := XmlChildEx( oXml:_CTEPROC , "_CTE" )
			Case ValType(XmlChildEx( oXml , "_CTE" )) == "O"
				oCTE := XmlChildEx( oXml , "_CTE" )
			OtherWise
				nQtdErro++
				xAddLog("FALHA","Falha ao ler esturura do aquivo XML!","","","",aCteProd[nAuxCTE])
				Loop					
		EndCase
		
		oCTE := XmlChildEx( oCTE , "_INFCTE" )
		
		cCGC	:= ""
		
		Do Case
		 Case ValType(XmlChildEx( oCTE:_EMIT , "_CNPJ" )) == "O"
			cCGC := oCTE:_EMIT:_CNPJ:TEXT
		 Case ValType(XmlChildEx( oCTE:_EMIT , "_CPF" )) == "O"
			cCGC := oCTE:_EMIT:_CPF:TEXT
		OtherWise
			nQtdErro++
			xAddLog("FALHA","tipo de cliente/fornecedor nใo identificado!","","","",aCteProd[nAuxCTE])
			Loop
		EndCase
		
		SA2->(DbSetOrder(3))
		IF !SA2->(DbSeek( xFilial("SA2")+cCGC ))
			nQtdErro++
			xAddLog("FALHA","Transportadora nใo localizada no cadastro de fornecedores, CNPJ: "+cCGC+", Nome: "+oCTE:_EMIT:_XNOME:TEXT+" !","","","",aCteProd[nAuxCTE])
			Loop
		EndIf
		
		cCPFCNPJ := ""
		
		Do Case
		 Case ValType(XmlChildEx( oCTE:_REM , "_CNPJ" )) == "O"
			cCPFCNPJ := oCTE:_REM:_CNPJ:TEXT
		 Case ValType(XmlChildEx( oCTE:_REM , "_CPF" )) == "O"
			cCPFCNPJ := oCTE:_REM:_CPF:TEXT
		OtherWise
			nQtdErro++
			xAddLog("FALHA","tipo de cliente/fornecedor nใo identificado!","","","",aCteProd[nAuxCTE])
			Loop
		EndCase
		
		
		If ! (AllTrim(cCPFCNPJ) == AllTrim(SM0->M0_CGC) .OR. AllTrim(oCTE:_DEST:_CNPJ:TEXT) == AllTrim(SM0->M0_CGC))
			nQtdErro++
			xAddLog("FALHA","Nota fiscal nใo pertence a filial logada, CNPJ: "+cCGC+", Nome: "+oCTE:_EMIT:_XNOME:TEXT+" !","","","",aCteProd[nAuxCTE])
			Loop
		EndIf
		
		

		//carrega array com os dados do cabe็alho da Pr้-Nota de Entrada
		aCabCTe := {}
		
		dDtEmiCte	:= StoD(StrTran(Left(oCTE:_IDE:_DHEMI:TEXT,10),"-",""))
		cNumCte	:= PADL(AllTrim(oCTE:_IDE:_NCT:TEXT),TAMSX3("F1_DOC")[1],"0")
		
		cSerieCte	:= PADR(AllTrim(oCTE:_IDE:_SERIE:TEXT),TAMSX3("F1_SERIE")[1])
		cChvCte	:= oXml:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT
		
		IF SF1->(DbSeek( xFilial("SF1")+cNumCte+cSerieCte+SA2->A2_COD+SA2->A2_LOJA ))
			nQtdErro++
			xAddLog("FALHA","Documento jแ existe na base de dados, CNPJ: "+cCGC+", Nome: "+oCTE:_EMIT:_XNOME:TEXT+", CTe: "+cNumCte+", Serie: "+cSerieCte+" !","","","",aCteProd[nAuxCTE])
			Loop
		EndIf
				
		aadd(aCabCTe , {"F1_TIPO"		, "N" ,				Nil} )
		aadd(aCabCTe , {"F1_FORMUL"		, "N" ,				Nil} )
		aadd(aCabCTe , {"F1_EMISSAO"	, dDtEmiCte ,			Nil} )
		aadd(aCabCTe , {"F1_DTDIGIT"	, dDataBase , 		Nil} )
		aadd(aCabCTe , {"F1_FORNECE"	, SA2->A2_COD	, 		Nil} )
		aadd(aCabCTe , {"F1_LOJA"   	, SA2->A2_LOJA ,		Nil} )
		aadd(aCabCTe , {"F1_ESPECIE"	, "CTE" ,				Nil} )
		aadd(aCabCTe , {"F1_COND"		, aCfgCTE[N_PGT] ,	Nil} )
		aadd(aCabCTe , {"F1_DOC"			, cNumCte ,			Nil} )
		aadd(aCabCTe , {"F1_SERIE"  	, cSerieCte , 		Nil} )		
		aAdd(aCabCTe , {"F1_CHVNFE"		, cChvCte , 			NIL} )
		aAdd(aCabCTe , {"F1_MENNOTA"	, "" , 				NIL} )
		aadd(aCabCTe , {"E2_NATUREZ"	, SED->ED_CODIGO , 	NIL	} )
		
		aItAux	:= {}
		aItens	:= {}		
		aAdd(aItAux,{"D1_ITEM"		, STRZERO(1,TAMSX3("D1_ITEM")[1])	, Nil})
		aAdd(aItAux,{"D1_COD"		, SB1->B1_COD							, Nil})
		aAdd(aItAux,{"D1_QUANT"		, 1										, Nil})
		aAdd(aItAux,{"D1_VUNIT"		, Val(oCTE:_VPREST:_vTPREST:TEXT)	, Nil})
		aAdd(aItAux,{"D1_TOTAL"		, Val(oCTE:_VPREST:_vTPREST:TEXT)	, Nil})
		aAdd(aItAux,{"D1_VALDESC"	, 0										, Nil})
		aAdd(aItAux,{"D1_TES"		, SF4->F4_CODIGO						, Nil})
		aAdd(aItAux,{"D1_LOCAL"		, SB1->B1_LOCPAD						, Nil})		
		
		Aadd(aItens, aClone(aItAux) )
		
		If ValType(oXml) == "O"
			FreeObj(oXml)
		EndIf
		If ValType(oCTE) == "O"
			FreeObj(oCTE)
		EndIf		
		
		lMsErroAuto := .F.
		
		MSExecAuto({|x,y,z|MATA103(x,y,z)},aCabCTe, aItens,3)

		If lMsErroAuto
			nQtdErro++
			cErEx := MostraErro(GetTempPath(),cNumCte+"_"+cSerieCte+".log")
			xAddLog("FALHA",cErEx,cNumCte,cSerieCte,SA2->A2_COD+"-"+SA2->A2_LOJA+"-"+ALLTRIM(SA2->A2_NOME),cDirUsr + aFiles[nAuxCTE][1])
		Else
			nQtdOk++
			xAddLog("SUCESSO","Ct-e importado com sucesso!",cNumCte,cSerieCte,SA2->A2_COD+"-"+SA2->A2_LOJA+"-"+ALLTRIM(SA2->A2_NOME),cDirUsr + aFiles[nAuxCTE][1])	
		EndIf
		
	Next nAuxCTE
	
	If Len(aLog) > 0		
		GerLog()		
		MsgStop("Processamento finalizado!"+Chr(13)+Chr(10)+" Qtd.Arq: "+StrZero(Len(aFiles),4)+Chr(13)+Chr(10)+" Qtd.Sucesso: "+StrZero(nQtdOk,4)+" Qtd.Erro: "+StrZero(nQtdErro,4))		
	EndIf
	
Else
	MsgStop("Nenhum arquivo foi processado!")	 
EndIf

Return nil

Static function xAddLog(cStssLog,cMsgLog,cCteLog,cSerLog,cForLog,cCmlLog)

Aadd(aLog, Array(6) )

aLog[Len(aLog)][N_STS] := cStssLog 
aLog[Len(aLog)][N_MSG] := cMsgLog
aLog[Len(aLog)][N_CTE] := cCteLog
aLog[Len(aLog)][N_SER] := cSerLog
aLog[Len(aLog)][N_FOR] := cForLog
aLog[Len(aLog)][N_XML] := cCmlLog

Return nil

Static Function GerLog()

Local oFWMsExcel	:= FWMSExcel():New()
Local cSheet		:= "Importa็ใo XML"
Local cTable		:= "Resultado importa็ใo"
Local nAuxMsg		:= 0   

oFWMsExcel:AddworkSheet(cSheet)     	
/*
cWorkSheet	Caracteres	Nome da planilha	 	X	 
cTable	Caracteres	Nome da planilha	 	X	 
cColumn	Caracteres	Titulo da tabela que serแ adicionada	 	X	 
nAlign	Num้rico	Alinhamento da coluna ( 1-Left,2-Center,3-Right )	 	X	 
nFormat	Num้rico	Codigo de formata็ใo ( 1-General,2-Number,3-Monetแrio,4-DateTime )	 	X	 
lTotal	L๓gico	Indica se a coluna deve ser totalizada
*/

//Criando a Tabela
oFWMsExcel:AddTable(cSheet,cTable)
oFWMsExcel:AddColumn(cSheet,cTable,"SITUAวรO",1,1)
oFWMsExcel:AddColumn(cSheet,cTable,"TRANSPORTADORA",1,1) 
oFWMsExcel:AddColumn(cSheet,cTable,"CTE",1,1)
oFWMsExcel:AddColumn(cSheet,cTable,"SERIE",1,1)
oFWMsExcel:AddColumn(cSheet,cTable,"ARQUIVO",1,1)
oFWMsExcel:AddColumn(cSheet,cTable,"MENSAGEM",1,1)     	

For nAuxMsg := 1 To Len(aLog)
	oFWMsExcel:AddRow(cSheet,cTable,{ aLog[nAuxMsg][N_STS] , aLog[nAuxMsg][N_FOR] , aLog[nAuxMsg][N_CTE] , aLog[nAuxMsg][N_SER] , aLog[nAuxMsg][N_XML] , aLog[nAuxMsg][N_MSG]  })
Next nAuxMsg

oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(GetTempPath()+FunName()+"_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")+".xml") 

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( GetTempPath()+FunName()+"_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")+".xml" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

FreeObj(oFWMsExcel)
FreeObj(oExcelApp)

Return nil
