#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA089   บAutor  ณCleuto Lima         บ Data ณ  06/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณimporta xml notas ELSEVIER                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA089()

Local cLocFile	:= "\ImpXML\"
Local cCadastro	:= "Importa็ใo XML"
Local aRet		:= {}
Local nOpcA		:= 0
Local aFile		:= {}
Local aXml		:= {}
Local cFilNoCp	:= ""

WFForceDir(cLocFile)
WFForceDir(cLocFile+"\Error\")
WFForceDir(cLocFile+"\Importados\")

If cFilAnt <> "1022"
	MsgStop("Rotina deve ser utilizada na filial 1022")
	Return nil
EndIf

///Parambox ( aParametros@cTitle@aRet [ bOk ] [ aButtons ] [ lCentered ] [ nPosX ] [ nPosy ] [ oDlgWizard ] [ cLoad ] [ lCanSave ] [ lUserSave ] ) --> aRet
ParamBox({ {06,"Diretorio XML"		,Space(150),"",".F.",".T.",80,.F.,"*.XML/*.XML",Space(150),GETF_RETDIRECTORY  + GETF_LOCALHARD} },cCadastro,@aRet,{|x| nOpcA := 1 },,,,,,,.F.,.F.)

If nOpcA <> 1
	Return
EndIf

aRet[1] := AllTrim(aRet[1])
aRet[1] := aRet[1]+IIF( Right(aRet[1],1) == "" , "\" , "")
aXml := Directory(Alltrim(aRet[1])+"*.xml")

For nAuxXML := 1 To Len(aXml)	
	If __CopyFile( aRet[1] + aXml[nAuxXML][1] , cLocFile+aXml[nAuxXML][1])		
		Aadd(aFile, aclone(aXml[nAuxXML]) )	
	Else
		cFilNoCp+=aRet[1] + aXml[nAuxXML][1]+Chr(13)+Chr(10)
	EndIf
Next nAuxXML

If Len(aFile) == 0
	MsgStop("Nใo foram encontrados arquivos XML para serem importados!")
	Return nil
ElseIf !Empty(cFilNoCp)
	xMagHelpFis("Copia de XML","Alguns arquivo nใo foram copiados",cFilNoCp)
	Return nil	
EndIf

If MsgYesNo("Confirmar processamento dos arquivo XML?")
	Processa({||  ProcXML(aFile,cLocFile,aRet[1]) },"Processando arquivos...","Aguarde...",.F.)	
EndIf

Return nil

Static Function ProcXML(aFiles,cLocFile,cDirCli)

Local nOpc 		:= 0
Local cFilLog	:= "log_tmp008_"+DtoS(DDataBase)+Replace(Time(),":","")+".log"
Local cArqTxt	:= "\ImpXML\"+cFilLog
Local cEOL 		:= CHR(13)+CHR(10)
Local cError	:= ""
Local cWarning	:= ""
Local _oObjet	:= nil
Local _oXml		:= nil
Local _lNfeProc	:= .F.

//Cabe็alho das Notas Fiscais de Entrada
Local _cFilCNPJ    	:= nil
Local _cFornCNPJ   	:= nil
	
Local _cUF   		:= nil
Local _cNumNota    	:= nil
Local _cSerNota    	:= nil
Local _cChvNFE 		:= nil
Local _dEmissao   	:= nil
Local _cPedido	 	:= nil
Local _cTipo       	:= nil
Local _aAreaSM0 	:= SM0->(GetArea())
Local _lOK 			:= .F.
Local aItens 		:= {}
Local cItem			:= ""
Local _aDetAx		:= nil
Local cArmEnt		:= GetMv("GEN_COM023",.f.,"05")
Local cTesEnt		:= GetMv("GEN_COM024",.f.,"004")
Local cNatEnt		:= GetMv("GEN_COM025",.f.,"40020")
Local _CodForn		:= Separa(GetMv("GEN_COM026",.f.,"0383945|02"),"|")[1]
Local _LojForn		:= Separa(GetMv("GEN_COM026",.f.,"0383945|02"),"|")[2]
Local cTransp		:= GetMv("GEN_COM027",.f.,"000379")

Private nHandle := fCreate(cArqTxt)
Private aCabec	:= {}
Private aItens	:= {}
Private aLinha	:= {}

ProcRegua(Len(aFiles))

For nAuxNF := 1 To Len(aFiles)
	
	IncProc("Processando "+StrZero(nAuxNF,4)+" de "+StrZero(Len(aFiles),4))
	
	aItens	:= {}
	_lOK	:= .T.
	//Gera o Objeto XML
	_oXml := XmlParserFile( cLocFile+aFiles[nAuxNF][1], "_", @cError, @cWarning )
	
	//Verifica se ocorreu erro na leitura
	If !Empty(cError)

		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])
		
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, cError+cEOL )
		
		Loop
	EndIf
		
	If ValType(XmlChildEx( _oXml , "_NFEPROC" )) == "O"
		If ValType(XmlChildEx( _oXml:_NFEPROC , "_NFE" )) == "O"
			_oObjet := _oXml:_NFEPROC:_NFE
			_lNfeProc := .T.			
		EndIf
	ElseIf ValType(XmlChildEx( _oXml , "_NFE" )) == "O"
		_oObjet := _oXml:_NFE
		_lNfeProc := .T.			
	EndIf
	
	If !_lNfeProc
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Erro de estrutura do arquivo"+cEOL )
		
		Loop
	EndIf
	

	//Cabe็alho das Notas Fiscais de Entrada
	_cFilCNPJ    	:= _oObjet:_INFNFE:_DEST:_CNPJ:Text
	_cFornCNPJ   	:= _oObjet:_INFNFE:_EMIT:_CNPJ:Text
	
	_cUF   		 	:= _oObjet:_INFNFE:_EMIT:_ENDEREMIT:_UF:Text
	_cNumNota    	:= PADL(AllTrim(_oObjet:_INFNFE:_IDE:_NNF:Text),TAMSX3("F1_DOC")[1],"0")
	_cSerNota    	:= PADR(AllTrim(_oObjet:_INFNFE:_IDE:_SERIE:Text),TAMSX3("F1_SERIE")[1])
	//_vProd		 	:= _oObjet:_INFNFE:_TOTAL:_ICMSTOT:_vProd:Text
	_cChvNFE 		:= StrTran(_oObjet:_INFNFE:_ID:TEXT,"NFe","")
	_cChvNFE 		:= StrTran(_cChvNFE,"NFE","")
	_cChvNFE 		:= StrTran(_cChvNFE,"nfe","")
	_cChvNFE 		:= StrTran(_cChvNFE,"Nfe","")
	
	If _oObjet:_INFNFE:_VERSAO:Text == '3.10' .or.  _oObjet:_INFNFE:_VERSAO:Text == '4.00'
		_dEmissao   := _oObjet:_INFNFE:_IDE:_DHEMI:Text
	Else
		_dEmissao   := _oObjet:_INFNFE:_IDE:_DEMI:Text
	EndIf
	
	If Type("_oObjet:_INFNFE:_COMPRA:_xPed") <> "U"
		_cPedido	 := _oObjet:_INFNFE:_COMPRA:_xPed:Text
	Else
		_cPedido	 := ""
	EndIf
	
	//Coloca a Data de emissใo no formato ddmmaaaa
	_dEmissao    := Iif(!Empty(_dEmissao),SUBSTR(_dEmissao,1,4)+SUBSTR(_dEmissao,6,2)+SUBSTR(_dEmissao,9,2),"")
	_dEmissao    := StoD(_dEmissao)
	_cTipo       := _oObjet:_INFNFE:_IDE:_TPNF:Text

	_aAreaSM0 	:= SM0->(GetArea())
	
	//Valida variaveis carregadas no XML
	If Valtype(_cFilCNPJ) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG CNPJ Filial."+cEOL )
		
		Loop	
	ElseIf Valtype(_cFornCNPJ) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG CNPJ Fornecedor."+cEOL )
		
		Loop
	ElseIf Valtype(_cUF) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG UF."+cEOL )
		
		Loop
	ElseIf Valtype(_cNumNota) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG Numero da Nota."+cEOL )
		
		Loop
	ElseIf Valtype(_cSerNota) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG Numero da Nota."+cEOL )
		
		Loop
	ElseIf Valtype(_cChvNFE) <> "C"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG Chave."+cEOL )
		
		Loop		
	ElseIf Valtype(_dEmissao) <> "D"
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Informa็ใo invแlida na TAG Emissใo."+cEOL )
		
		Loop
	Endif
			
	SA2->(DbSetOrder(1))
	If !SA2->(dbSeek(xFilial("SA2")+_CodForn+_LojForn))
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Fornecedor nใo localizado."+cEOL )
		
		Loop
	ElseIf AllTrim(_cFornCNPJ) <> AllTrim(SA2->A2_CGC)
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Fornecedor invalido."+cEOL )
		
		Loop		
	EndIf

	SF1->(DbSetOrder(1))
	If SF1->( DbSeek( xFilial("SF1")+_cNumNota+_cSerNota+_CodForn+_LojForn))
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "nota fiscal jแ existe na base de dados para este fornecedor "+_cNumNota+"-"+_cSerNota+cEOL )
		
		Loop			
	EndIF
			
	aCabec	:= {}
	cItem	:= StrZero(0,TamSX3("D1_ITEM")[1])
	 
	aAdd(aCabec,{'F1_TIPO'		, "N"	 					,NIL})
	aAdd(aCabec,{'F1_FORMUL'	, "N"						,NIL})
	aAdd(aCabec,{'F1_DOC'		, _cNumNota					,NIL})
	aAdd(aCabec,{'F1_SERIE'		, _cSerNota					,NIL})
	aAdd(aCabec,{'F1_EMISSAO'	, _dEmissao					,NIL})
	aadd(aCabec,{"F1_DTDIGIT"	, dDataBase					,NIl})
	aAdd(aCabec,{'F1_FORNECE'	, _CodForn					,NIL})
	aAdd(aCabec,{'F1_LOJA'		, _LojForn					,NIL})
	aAdd(aCabec,{'F1_ESPECIE'	, "SPED"					,NIL})
	aAdd(aCabec,{'F1_TRANSP'	, cTransp					,NIL})
	aAdd(aCabec,{'F1_COND'		, "001"						,NIL})
	aadd(aCabec,{"F1_CHVNFE"	, _cChvNFE					,Nil})	
	aadd(aCabec,{"E2_NATUREZ"	, cNatEnt					,NIL})

	If Valtype( _oObjet:_INFNFE:_DET) <> "A"
		XmlNode2Arr(_oObjet:_INFNFE:_DET, "_DET" )
	Endif

	_aDetAx :=  _oObjet:_INFNFE:_DET
			
	For _nTmp := 1 to len(_aDetAx)
		
		cItem		:= Soma1(cItem)
		_cCodProd	:= _aDetAx[_nTmp]:_Prod:_cProd:Text
		_cEAN		:= _aDetAx[_nTmp]:_Prod:_cEAN:Text
		_cNumItem	:= _aDetAx[_nTmp]:_nItem:Text
		_cUm		:= _aDetAx[_nTmp]:_Prod:_Ucom:Text
		_cQuant		:= Val(_aDetAx[_nTmp]:_Prod:_Qcom:Text)
		_cValPrec	:= Val(_aDetAx[_nTmp]:_Prod:_VunCom:Text)
		_cVlTot		:= Val(_aDetAx[_nTmp]:_Prod:_VProd:Text)
		_cValDesc	:= Val(_aDetAx[_nTmp]:_Prod:_VDesc:Text)
		_cValUnit	:= (Val(_aDetAx[_nTmp]:_Prod:_VProd:Text)-Val(_aDetAx[_nTmp]:_Prod:_VDesc:Text))/Val(_aDetAx[_nTmp]:_Prod:_Qcom:Text)
				
		SB1->(DbOrderNickName("GENISBN"))
		IF !SB1->(Dbseek( xFilial("SB1")+_cCodProd ))
			If !SB1->(Dbseek( xFilial("SB1")+_cEAN ))
				SB1->(DbSetOrder(1))
				If !SB1->(Dbseek( xFilial("SB1")+_cCodProd ))
					If !SB1->(Dbseek( xFilial("SB1")+_cEAN ))
						FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
						FWrite(nHandle, _cCodProd+" Codigo nใo encontrato"+cEOL )
											
						_lOK := .F.
						Exit
					EndIf
				EndIF
			EndIf
		EndIF
	
		aLinIt := {}
		
		If _lOK
			aAdd(aLinIt,{"D1_ITEM"		, cItem										,Nil})
			aAdd(aLinIt,{'D1_COD'		, SB1->B1_COD								,NIL})
			aAdd(aLinIt,{'D1_UM'		, "UN"										,NIL})
			aAdd(aLinIt,{'D1_QUANT'		, _cQuant									,NIL})
			aAdd(aLinIt,{'D1_VUNIT'		, _cValPrec									,NIL})
			aAdd(aLinIt,{'D1_TOTAL'		, _cVlTot									,NIL})
			aAdd(aLinIt,{'D1_VALDESC'	, _cValDesc									,NIL})
			aAdd(aLinIt,{'D1_TES'		, cTesEnt							  		,NIL})
			aAdd(aLinIt,{'D1_LOCAL'		, cArmEnt									,NIL})
		
			aAdd(aItens,aLinIt)
		EndIf
	Next _nTmp
	
	If !_lOK .AND. Len(aItens) > 0
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
		FErase(cLocFile+aFiles[nAuxNF][1])	
		FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Nota com problemas nos itens nใo foi possํvel dar entrada "+_cNumNota+"-"+_cSerNota+cEOL )
							
		Loop		
	EndIf
	
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	
	Begin Transaction
		MSExecAuto({|x,y,z|MATA103(x,y,z)}, aCabec, aItens, 3)		
	End Transaction
	
	If lMsErroAuto
		_aErro	:= GetAutoGRLog()
		cError	:= ""
		For _ni := 1 To Len(_aErro)
			cError += _aErro[_ni] + cEnt
			CONOUT(_cErroLg)
		Next _ni		
		
		If Empty(cError)
			Mostraerro()
		Else
			FWrite(nHandle, "Inicio Erro: "+Replicate("-",500)+cEOL )
			FWrite(nHandle, cError+cEOL )
		EndIf
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Error\"+aFiles[nAuxNF][1])
	Else
		__CopyFile( cLocFile+aFiles[nAuxNF][1] , "\ImpXML\Importados\"+aFiles[nAuxNF][1])		
		FWrite(nHandle, "Sucesso "+Replicate("-",500)+cEOL )
		FWrite(nHandle, "Nota: "+SF1->F1_DOC+SF1->F1_SERIE )
	EndIf
	
	FErase(cLocFile+aFiles[nAuxNF][1])
	FreeObj(_oXml)
	FreeObj(_aDetAx)
	FreeObj(_oObjet)
	
Next nAuxNF

FClose(nHandle)
//__CopyFile( cArqTxt+cFilLog , cDirCli+cFilLog)
CpyS2T( cArqTxt , cDirCli)
ShellExecute("Open", cDirCli+cFilLog, "", cFilLog, 1 )

Return()
