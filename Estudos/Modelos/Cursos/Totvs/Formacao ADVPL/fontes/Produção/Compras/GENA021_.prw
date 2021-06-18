#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA021   ºAutor  ³Rafael Leite        º Data ³  25/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Importacao de XML para Documento de Entrada                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º04/08/2015³Danilo - Opcao para importar retorno de conserto grafica    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENA021

Private cCadastro 	:= "Reconsignação GEN"
Private aRotina 	:= MenuDef()
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString 	:= "SF1"

dbSelectArea(cString)
dbSetOrder(1)

mBrowse( 6,1,22,75,cString)

Return()

User Function GENA021A(_cTipImp)

Local _cXML := ""
Local _cPath := ""
Local _nOpca := 2
Local _cMsgInfo := ""

Private _cFile		:= Space(100)
Private _cMsgNF		:= Space(TamSX3("F1_MENNOTA")[1])
Private _cTES		:= Space(TamSX3("D2_TES")[1])
Private _cTESDesc	:= Space(TamSX3("F4_TEXTO")[1])
Private _cCondPag	:= Space(TamSX3("E4_CODIGO")[1])
Private _cCondDesc	:= Space(TamSX3("E4_DESCRI")[1])
Private _cNat		:= Space(TamSX3("ED_CODIGO")[1])
Private _cNatDesc	:= Space(TamSX3("ED_DESCRIC")[1])
Private oDlg

If _cTipImp == "1"
	_cMsgInfo := "Deseja importar CONSIGNAÇÃO ATLAS?"
ElseIf _cTipImp == "2"
	_cMsgInfo := "Deseja importar DEVOLUÇÃO DE CONSIGNAÇÃO?"
ElseIf _cTipImp == "3"
	_cMsgInfo := "Deseja importar DEVOLUÇÃO DE ACERTO?"
ElseIf _cTipImp == "4"
	_cMsgInfo := "Deseja importar RETORNO DE REPARO DA GRAFICA?"
ElseIf _cTipImp == "5"
	_cMsgInfo := "Deseja importar DEVOLUÇÃO INTERCIA?"
ElseIf _cTipImp == "6"
	_cMsgInfo := "PRESTACAO DE CONTAS - DEVOLUCAO VENDA?"
ElseIf _cTipImp == "7"
	_cMsgInfo := "PRESTACAO DE CONTAS - VENDA ATLAS?"
ElseIf _cTipImp == "8"
	_cMsgInfo := "PRESTACAO DE CONTAS - OFERTA ATLAS?"
ElseIf _cTipImp == "9"
	_cMsgInfo := "RETORNO OFERTA? TES 463"
Endif

//Parâmetros iniciais
If !MsgNoYes(_cMsgInfo)
	Return()
Endif

DEFINE MSDIALOG oDlg TITLE "Selecionar arquivo" FROM 000,000 TO 125,440 PIXEL

@010,010 SAY "Selecione o arquivo a ser importado." OF oDlg PIXEL
@025,010 SAY "Arquivo:" SIZE 55,07 OF oDlg PIXEL
@023,035 MSGET _cFile F3 "ARQ1" SIZE 150,10 OF oDlg PIXEL PICTURE "@!" //VALID !Vazio()
@040,010 SAY "Msg.Nota:" SIZE 55,07 OF oDlg PIXEL
@038,035 MSGET _cMsgNf SIZE 150,10 OF oDlg PIXEL PICTURE "@!" //VALID !Vazio()

DEFINE SBUTTON FROM 023, 190 TYPE 1 ACTION (_nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 038, 190 TYPE 2 ACTION (_nOpca := 2,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpca == 1
	_cPath := Alltrim(_cFile)
	_cMsgNf := Alltrim(_cMsgNf)
Else
	Return()
Endif

//Valida tipo de arquivo
If UPPER(Right(_cPath,3)) <> "XML"
	GN003("Esta rotina permite apenas a importação de arquivo do tipo XML.",_cPath)
	Return()
Endif

//Copia arquivo para o servidor
_cPathDes	:= Alltrim(GetMV("GEN_COM001"))
_cFile 		:= DtoS(dDataBase)+ StrTran(Time(),":","")+".xml"
__CopyFile( _cPath, _cPathDes+_cFile)
_cPath 		:= _cPathDes

//Abre o arquivo para uso
FT_FUSE(_cPath+_cFile)

//Posiciona no inicio do arquivo
FT_FGOTOP()

_cXML := ""

//Enquanto nao for fim do arquivo
While ( !FT_FEOF() )
	
	//Armazena a linha do arquivo
	_cXML += Alltrim( FT_FREADLN() )
	
	//Proxima linha
	FT_FSKIP()
	
EndDo

Begin Transaction

//Fecha o arquivo
FT_FUSE()

// Processamento do XML
GN002(_cPathDes,_cFile,_cXML,_cTipImp,_cTES)

End Transaction

tcsqlexec("UPDATE "+RetSqlName("SB2")+" SET B2_QTNP = 0 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' '")

Return()

Static Function MenuDef()

Local _aRet := {}

AADD(_aRet,{"Importar XML"		,"Processa( {|| U_GENA021A('2')})"	,0,3})
AADD(_aRet,{"Importar Acerto"	,"Processa( {|| U_GENA021A('3')})"	,0,3})
AADD(_aRet,{"Importar Ret. Grafica"	,"Processa( {|| U_GENA021A('4')})"	,0,3})
AADD(_aRet,{"Importar Intercia"	,"Processa( {|| U_GENA021A('5')})"	,0,3})
AADD(_aRet,{"Devolução GEN"		,"Processa( {|| U_GENA022()  })"	,0,3})
AADD(_aRet,{"Pedido de Venda"	,"Processa( {|| U_GENA023()  })"	,0,3})

//06/10/2015 - Rafael Leite - Ajuste prestação de contas Atlas
If (upper(alltrim(GetEnvServer())) $ "SCHEDULE")
//	AADD(_aRet,{"Dev. Venda Prest. "	,"Processa( {|| U_GENA021A('3')})"	,0,3})
	AADD(_aRet,{"Venda - Atlas"		,"Processa( {|| U_GENA021A('7')})"	,0,3})
	AADD(_aRet,{"Oferta - Atlas"	,"Processa( {|| U_GENA021A('8')})"	,0,3})
Endif

AADD(_aRet,{"Visualizar"	,"A103NFiscal",0,2})

Return(_aRet)

/*
Função: GENA021B

Descrição: Tela para selecionar arquivo

Manutenções:
25/06/2015 - Rafael Leite - Criação do fonte
*/
User Function GENA021B

Default _cFile := ""

_cFile := cGetFile("*.xml",OemToAnsi("Selecionar..."),0,"C:\",.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.,.T.)

If FunName()=="GENA021"
	oDlg:Refresh()
Endif

Return(_cFile)

/*
Função: GN002

Descrição: Interpretação do arquivo XML

Manutenções:
25/06/2015 - Rafael Leite - Criação do fonte
*/
Static Function GN002(_cPath,_cFile,_cXML,_cTipImp,_cTES)

Local _oXml 	:= NIL
Local cError 	:= ""
Local cWarning 	:= ""
Local _lFaltCpo := .F.
Local _lXValBru := .F. //Gravação do campo personalizado F1_XVALBRU
Local _cAlias1  := GetNextAlias()
Local _cTesImp	:= GetMV("GEN_COM002")

Private oServer := NIL

//Se for tipo 1 pega TES selecionado pelo usuário
If _cTipImp == "1"
	_cTesImp := GetMv("GEN_COM011") //Entrada consignação intercompany
	_cLocImp := GetMv("GEN_COM014") //Armazem a ser movimentado
ElseIf _cTipImp == "2"
	_cLocImp := GetMv("GEN_COM018") //Armazem a ser movimentado
ElseIf _cTipImp == "3"
	_cTesImp := GetMv("GEN_COM009") //Entrada consignação intercompany
	_cLocImp := GetMv("GEN_COM010") //Armazem a ser movimentado
ElseIf _cTipImp == "4"
	_cTesImp := GetMv("GEN_COM012") //Entrada retorno reparo grafica
ElseIf _cTipImp == "5"
	_cTesImp := GetMv("GEN_COM013") //Entrada retorno reparo grafica
ElseIf _cTipImp == "6"
	_cTesImp := "452" //Devolucao venda prestacao
	_cLocImp := "01" //Armazem a ser movimentado
ElseIf _cTipImp == "7"
	_cTesImp := GetMv("GEN_FAT024") //Entrada Venda Prestaççao Atlas
	_cLocImp := '01' //Armazem a ser movimentado
ElseIf _cTipImp == "8"
	_cTesImp := GetMv("GEN_FAT008") //Entrada Oferta Prestaççao Atlas
	_cLocImp := '01' //Armazem a ser movimentado
ElseIf _cTipImp == "9"
	_cTesImp := GetMv("GEN_COM015") //Outras Entradas
	_cLocImp := GetMv("GEN_COM016") //Armazem a ser movimentado
Endif

If Right(Alltrim(_cXML),1) == "="
	_cXML := Substr(Alltrim(_cXML),1,Len(Alltrim(_cXML))-1)
EndIf

//Gera o Objeto XML
_oXml := XmlParserFile( _cPath+_cFile, "_", @cError, @cWarning )

//Verifica se ocorreu erro na leitura
If !Empty(cError)
	_cErro := cError
	GN003(_cErro,_cPath)
	Return()
EndIf

_oObjet := _oXml

//Valida objeto criado com o XML
If Type("_oObjet:_NFEPROC:_NFE") <> "U"
	_oObjet := _oObjet:_NFEPROC:_NFE
	_lNfeProc := .T.
ElseIf Type("_oObjet:_NFE") <> "U"
	_oObjet := _oObjet:_NFE
	_lNfeProc := .T.
Else
	_lNfeProc := .F.
EndIf

If !_lNfeProc
	_cErro := "Estrutura invalida"
	GN003(_cErro,_cPath)
	Return()
EndIf

_oObjet:_INFNFE:_ID

//Cabeçalho das Notas Fiscais de Entrada
_cFilCNPJ    	:= _oObjet:_INFNFE:_DEST:_CNPJ:Text
_cFornCNPJ   	:= _oObjet:_INFNFE:_EMIT:_CNPJ:Text

_cUF   		 	:= _oObjet:_INFNFE:_EMIT:_ENDEREMIT:_UF:Text
_cNumNota    	:= PADL(AllTrim(_oObjet:_INFNFE:_IDE:_NNF:Text),TAMSX3("F1_DOC")[1],"0")
_cSerNota    	:= _oObjet:_INFNFE:_IDE:_SERIE:Text
//_vProd		 	:= _oObjet:_INFNFE:_TOTAL:_ICMSTOT:_vProd:Text
_cChvNFE 		:= StrTran(_oObjet:_INFNFE:_ID:TEXT,"NFe","")
_cChvNFE 		:= StrTran(_cChvNFE,"NFE","")
_cChvNFE 		:= StrTran(_cChvNFE,"nfe","")
_cChvNFE 		:= StrTran(_cChvNFE,"Nfe","")

If _oObjet:_INFNFE:_VERSAO:Text == '3.10'
	_dEmissao   := _oObjet:_INFNFE:_IDE:_DHEMI:Text
Else
	_dEmissao   := _oObjet:_INFNFE:_IDE:_DEMI:Text
EndIf

If Type("_oObjet:_INFNFE:_COMPRA:_xPed") <> "U"
	_cPedido	 := _oObjet:_INFNFE:_COMPRA:_xPed:Text
Else
	_cPedido	 := ""
EndIf

//If Type("_oObjet:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO") <> "U"
//	_cDesp       := _oObjet:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text
//Else
//	_cDesp       := "0"
//EndIf

//Coloca a Data de emissão no formato ddmmaaaa
_dEmissao    := Iif(!Empty(_dEmissao),SUBSTR(_dEmissao,1,4)+SUBSTR(_dEmissao,6,2)+SUBSTR(_dEmissao,9,2),"")
_dEmissao    := StoD(_dEmissao)
_cTipo       := _oObjet:_INFNFE:_IDE:_TPNF:Text

_aAreaSM0 	:= SM0->(GetArea())
_lOK 		:= .F.

//Valida variaveis carregadas no XML
If Valtype(_cFilCNPJ) <> "C"
	GN003("Informação inválida na TAG CNPJ Filial.")
	Return()
ElseIf Valtype(_cFornCNPJ) <> "C"
	GN003("Informação inválida na TAG CNPJ Fornecedor.")
	Return()
ElseIf Valtype(_cUF) <> "C"
	GN003("Informação inválida na TAG UF.")
	Return()
ElseIf Valtype(_cNumNota) <> "C"
	GN003("Informação inválida na TAG Numero da Nota.")
	Return()
ElseIf Valtype(_cSerNota) <> "C"
	GN003("Informação inválida na TAG Numero da Nota.")
	Return()
ElseIf Valtype(_cChvNFE) <> "C"
	GN003("Informação inválida na TAG Chave.")
ElseIf Valtype(_dEmissao) <> "D"
	GN003("Informação inválida na TAG Emissão.")
	Return()
ElseIf Valtype(_cPedido) <> "C"
	GN003("Informação inválida na TAG Pedido.")
	Return()
Endif

//Posiciona na Filial
DbSelectArea("SM0")
SM0->(DbGoTop())
While !SM0->(Eof())
	
	//Verifica se o CNPJ do destinatario existe no Cadastro de empresas
	If Alltrim(_cFilCNPJ) == Alltrim(SM0->M0_CGC)
		_cEmp 	:= SM0->M0_CODIGO
		_cFil 	:= SM0->M0_CODFIL
		_lOK 	:= .T.
	EndIf
	
	SM0->(DbSkip())
EndDo

RestArea(_aAreaSM0)

If !_lOK
	_cErro := " Filial não encontrada no Cadastro de empresas"
Else
	_cErro := ""
	
	//Verifica o tipo de nota fiscal
	If _cTipo != '1'
		_cErro += "Tipo do Documento Fiscal inválido" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o CNPJ está em branco
	If Empty(_cFornCNPJ)
		_cErro += "CNPJ do Fornecedor em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o numero da nota está em branco
	If Empty(_cNumNota)
		_cErro += "Numero da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se a serie da nota está em branco
	If Empty(_cSerNota)
		_cErro += "Série da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se a emissão está em branco
	If Empty(_dEmissao)
		_cErro += "Emissão da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o fornecedor do xml está cadastrado
	If _cTipImp $ "1/4/7/8/9"
		dbSelectArea("SA2")
		dbSetOrder(3)
		If SA2->(dbSeek(xFilial("SA2")+Alltrim(_cFornCNPJ)))
			_CodForn := SA2->A2_COD
			_LojForn := SA2->A2_LOJA
			_cErro := _CodForn + " - " + SA2->A2_NOME + CRLF
		Else
			_cErro += "Fornecedor não encontrado" + " / "
			_lOK 	:= .F.
		EndIf
	Elseif _cTipImp $ "2/3/5/6"
		dbSelectArea("SA1")
		dbSetOrder(3)
		If SA1->(dbSeek(xFilial("SA1")+Alltrim(_cFornCNPJ)))
			_CodForn := SA1->A1_COD
			_LojForn := SA1->A1_LOJA
			_cErro := _CodForn + " - " + SA1->A1_NOME + CRLF
		Else
			_cErro += "Cliente não encontrado" + " / "
			_lOK 	:= .F.
		EndIf
	Endif
Endif

If !_lOK
	GN003("NOTA: " + _cNumNota + " " + _cErro,_cPath)
	Return()
Else
	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))
	If SF1->(DbSeek(xFilial("SF1");
		+_cNumNota;
		+PADR(AllTrim(_cSerNota),TAMSX3("F1_SERIE")[1]);
		+PADR(AllTrim(_CodForn),TAMSX3("F1_FORNECE")[1]);
		+PADR(AllTrim(_LojForn),TAMSX3("F1_LOJA")[1])) )
		_cErro += "NOTA: " + _cNumNota + ". Nota fiscal ja importada"
		GN003(_cErro,_cPath)
		Return()
	EndIf
	
	//Verifica tipo de nota fiscal
	If _cTipImp $ "1/4/7/8/9"
		_cTipoDoc := 'N'
	ElseIf _cTipImp $ "2/3/5"
		_cTipoDoc := 'B'
	ElseIf _cTipImp $ "6"
		_cTipoDoc := 'D'
	Endif
	
	_cMvEspc := GetMv("GEN_FAT020") //Contém a especie utilizada na nota de entrada das empresas Matriz e Origem
	_cMvCdDe := GetMv("GEN_FAT021") //Contém a condição de pagamento utilizada na nota de entrada das empresas Matriz e Origem
	
	//carrega array com os dados do cabeçalho da Pré-Nota de Entrada
	_aCabDcOr := {}
		
	aadd(_aCabDcOr , {"F1_TIPO"   	,_cTipoDoc				, Nil} ) // 03/02 - RAFAEL LEITE
	aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"					, Nil} )
	aadd(_aCabDcOr , {"F1_SERIE"  	,Alltrim(_cSerNota)		, Nil} )
	aadd(_aCabDcOr , {"F1_EMISSAO"	,_dEmissao				, Nil} )
	aadd(_aCabDcOr , {"F1_DTDIGIT"	,dDataBase				, Nil} )
	aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_CodForn),TAMSX3("F1_FORNECE")[1])	, Nil} )
	aadd(_aCabDcOr , {"F1_LOJA"   	,Alltrim(_LojForn)		, Nil} )
	aadd(_aCabDcOr , {"F1_ESPECIE"	,_cMvEspc				, Nil} )
	aadd(_aCabDcOr , {"F1_COND"		,_cMvCdDe				, Nil} )
	aadd(_aCabDcOr , {"F1_DOC"		,PADR(AllTrim(_cNumNota),TAMSX3("F1_DOC")[1])		, Nil} )
	aAdd(_aCabDcOr , {"F1_CHVNFE"	,_cChvNFE				, NIL} )
	aAdd(_aCabDcOr , {"F1_MENNOTA"	,_cMsgNf				, NIL} )
	
	//Caso a Nota Fiscal seja de um item, o sitema transforma o item de objeto para array
	If Valtype( _oObjet:_INFNFE:_DET) = "O"
		XmlNode2Arr(_oObjet:_INFNFE:_DET, "_DET" )
	Endif
	
	//Array auxiliar recebe o array de itens para leitura
	_aDetAx :=  _oObjet:_INFNFE:_DET
	_aItens := {}
	_nCnt := 0
	
	For _nTmp := 1 to len(_aDetAx)
		
		_cCodProd    := _aDetAx[_nTmp]:_Prod:_cProd:Text
		_cEAN	     := _aDetAx[_nTmp]:_Prod:_cEAN:Text
		_cNumItem    := _aDetAx[_nTmp]:_nItem:Text
		_cUm         := _aDetAx[_nTmp]:_Prod:_Ucom:Text
		_cQuant      := _aDetAx[_nTmp]:_Prod:_Qcom:Text
		_cValUnit    := _aDetAx[_nTmp]:_Prod:_VunCom:Text
		_cVlTot      := _aDetAx[_nTmp]:_Prod:_VProd:Text
		
		If Type("_aDetAx[_nTmp]:_Prod:_VDesc:Text") == "C"
			_cVDesc	:= _aDetAx[_nTmp]:_Prod:_VDesc:Text
		Else
			_cVDesc := "0"
		Endif
		
		If Valtype(_cCodProd) <> "C"
			GN003("Informação inválida na TAG Produto. Item:" + cValToChar(_nTmp))
			_lOK := .F.
			Exit
		ElseIf Valtype(_cEAN) <> "C"
			GN003("Informação inválida na TAG EAN. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cNumItem) <> "C"
			GN003("Informação inválida na TAG Numero Item. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cUm) <> "C"
			GN003("Informação inválida na TAG Unidade. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cQuant) <> "C"
			GN003("Informação inválida na TAG Quantidade. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cValUnit) <> "C"
			GN003("Informação inválida na TAG Valor unitario. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cVlTot) <> "C"
			GN003("Informação inválida na TAG Valor total. Item:" + cValToChar(_nTmp))
			Exit
		Endif
		
		If Type("_aDetAx[_nTmp]:_Prod:_VDesc")<> "U"
			_cDesc       := _aDetAx[_nTmp]:_Prod:_VDesc:Text
		Else
			_cDesc       := "0"
		EndIf
		
		If Type("_aDetAx[_nTmp]:_Imposto:_IPI:_IPITrib:_pIPI")<> "U"
			_cPIPI       := _aDetAx[_nTmp]:_Imposto:_IPI:_IPITrib:_pIPI:Text
		Else
			_cPIPI       := "0"
		EndIf
		
		If Type("_aDetAx[_nTmp]:_Imposto:_IPI:_IPITrib:_vIPI")<> "U"
			_cVIPI       := _aDetAx[_nTmp]:_Imposto:_IPI:_IPITrib:_vIPI:Text
		Else
			_cVIPI       := "0"
		EndIf
		
		//_nMulti		 := 1
		
		//Validações
		If Empty(_cCodProd)
			_cErro += "Código do Produto em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cNumItem)
			_cErro += "Numero do Item do Cabeçalho da Nota Fiscal em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cUm)
			_cErro += "Unidade de Medida do Produto " + _cCodProd + " em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cQuant)
			_cErro += "Quantidade do Produto " + _cCodProd + " em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cValUnit)
			_cErro += "Valor do Produto " + _cCodProd + " em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cVlTot)
			_cErro += "Valor Total do Produto " + _cCodProd + " em Branco" + " / "
			_lOK 	:= .F.
		Endif
		
		/*
		DbSelectArea("SA5")
		SA5->(DbsetOrder(14))
		If SA5->(DbSeek(xFilial("SA5")+_CodForn+_LojForn+_cCodProd))
		_nMulti := 1
		If _nMulti == 0
		_nMulti := 1
		EndIf
		EndIf
		*/
		
		//Preencher EAN para fazer posicionamento
		If Empty(_cEAN)
			_cEAN := _cCodProd
		Endif
		
		//Posicionamento do produto
		If Alltrim(_cEAN) <> ""
			
			//Verifica se o produto enviado no xml está cadastrado
			/*
			DbSelectArea("SB1")
			SB1->(DbSetOrder(11))
			If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
			DbSelectArea("SB1")
			SB1->(DbSetOrder(5))
			If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
			*/
			_cQuery := " SELECT B1_COD
			_cQuery += " FROM " + RetSqlName("SB1")
			_cQuery += " WHERE D_E_L_E_T_ = ' '
			_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'"
			_cQuery += " AND B1_XIDTPPU <> '11'
			_cQuery += " AND (B1_ISBN   = '" + ALLTRIM(_cEAN) + "'"
			_cQuery += "  OR B1_CODBAR = '" + ALLTRIM(_cEAN) + "')"
			
			If Select(_cAlias1) > 0
				dbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
			
			If (_cAlias1)->(EOF())
				DbSelectArea("SLK")
				SLK->(DbSetOrder(1))
				If !SLK->(DbSeek(xFilial("SLK")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
					DbSelectArea("SA5")
					SA5->(DbsetOrder(14))
					If !SA5->(DbSeek(xFilial("SA5")+_CodForn+_LojForn+_cCodProd))
						
						//Caso não encontre o produto, abre tela para que o usuário selecione
						_cEAN := f001("Produto não identificado. Item: " + cValtoChar(_cNumItem) ;
						+ ". Valor total: " + cValtoChar(_cVlTot) ;
						+ ". Informe o ISBN ou código de produto.")
						/*
						DbSelectArea("SB1")
						SB1->(DbSetOrder(11))
						If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
						
						DbSelectArea("SB1")
						SB1->(DbSetOrder(1))
						If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_COD")[1])))
						*/
						_cQuery := " SELECT B1_COD
						_cQuery += " FROM " + RetSqlName("SB1")
						_cQuery += " WHERE D_E_L_E_T_ = ' '
						_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'"
						_cQuery += " AND B1_XIDTPPU <> '11'
						_cQuery += " AND (B1_ISBN   = '" + ALLTRIM(_cEAN) + "'"
						_cQuery += "  OR B1_COD = '" + ALLTRIM(_cEAN) + "')"
						If Select(_cAlias1) > 0
							dbSelectArea(_cAlias1)
							(_cAlias1)->(dbCloseArea())
						EndIf
						dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
						
						If (_cAlias1)->(EOF())
							_cErro += "Produto " + _cEAN + " não cadastrado" + " / "
							_lOK 	:= .F.
						Else
							//							_cCodProd := SB1->B1_COD
							_cCodProd := (_cAlias1)->B1_COD
						Endif
						/*
						Else
						_cCodProd := SB1->B1_COD
						Endif
						*/
					Else
						_cCodProd := SA5->A5_PRODUTO
						
						/*
						_nMulti := 0
						If _nMulti == 0
						_nMulti := 1
						EndIf
						*/
					EndIf
				Else
					DbSelectArea("SA5")
					SA5->(DbsetOrder(2))
					_cCodProd := SLK->LK_CODIGO
					
					If SA5->(DbSeek(xFilial("SA5")+_cCodProd+_CodForn+_LojForn))
						_cCodProd := SA5->A5_PRODUTO
						
						/*
						_nMulti := 0
						If _nMulti == 0
						_nMulti := 1
						EndIf
						*/
					EndIf
				EndIf
			Else
				DbSelectArea("SA5")
				SA5->(DbsetOrder(2))
				//				_cCodProd := SB1->B1_COD
				_cCodProd := (_cAlias1)->B1_COD
				If SA5->(DbSeek(xFilial("SA5")+_cCodProd+_CodForn+_LojForn))
					_cCodProd := SA5->A5_PRODUTO
					/*
					_nMulti := 0
					If _nMulti == 0
					_nMulti := 1
					EndIf
					*/
				EndIf
			EndIf
			/*
			Else
			
			DbSelectArea("SA5")
			SA5->(DbsetOrder(2))
			_cCodProd := SB1->B1_COD
			If SA5->(DbSeek(xFilial("SA5")+_cCodProd+_CodForn+_LojForn))
			_cCodProd := SA5->A5_PRODUTO
			/*
			_nMulti := 0
			If _nMulti == 0
			_nMulti := 1
			EndIf
			
			EndIf
			
			EndIf
			*/
		Else
			
			DbSelectArea("SA5")
			SA5->(DbsetOrder(14))
			If !SA5->(DbSeek(xFilial("SA5")+_CodForn+_LojForn+_cCodProd))
				_cErro += "Produto " + _cCodProd + " não cadastrado" + " / "
				_lOK 	:= .F.
			Else
				_cCodProd := SA5->A5_PRODUTO
				/*
				_nMulti := 0
				If _nMulti == 0
				_nMulti := 1
				EndIf
				*/
			EndIf
		EndIf
		
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+_cCodProd))
			If _cTipImp $ '4'
				_cClasse := f003("Informe a Classe de Valor. Item: " + cValtoChar(_cNumItem) ;
				+ ". Produto: " + Alltrim(_cCodProd) ;
				+ ".")
			Endif
			
			_cUm := SB1->B1_UM
			
			//Parametro com o armazém a ser utilizado
			_cLocal := SB1->B1_LOCPAD
			
			//_nQtde := val(_cQuant)*_nMulti
			_nQtde := val(_cQuant)
			_nVlrUni := Val(_cVlTot) / _nQtde
			_nVlrTot := Val(_cVlTot)
			_nVlrDes := Val(_cVDesc)
			
			//Documentos que precisam informar Doc Origem, Serie Origem, Item Origem e IdentB6
			If _cTipImp $ '2/3/4/5'
				
				//Consulta saldo PODER 3
				//Realizando a busca por saldo em poder de terceiros
				_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SALDO,
				_cQuery += " B6_SERIE, D2_ITEM, B6_IDENT, B6_LOCAL
				_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD2") + " SD2
				_cQuery += " WHERE SB6.B6_DOC = SD2.D2_DOC
				_cQuery += " AND SB6.B6_SERIE = SD2.D2_SERIE
				_cQuery += " AND SB6.B6_PRODUTO = SD2.D2_COD
				_cQuery += " AND SB6.B6_CLIFOR = SD2.D2_CLIENTE
				_cQuery += " AND SB6.B6_LOJA = SD2.D2_LOJA
				_cQuery += " AND SB6.D_E_L_E_T_ = ' '
				_cQuery += " AND SD2.D_E_L_E_T_ = ' '
				_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "'
				_cQuery += " AND SD2.D2_FILIAL = '" + _cFil + "'
				_cQuery += " AND SB6.B6_TIPO = 'E'
				_cQuery += " AND SB6.B6_PODER3 = 'R'
				If _cTipImp $ '4'
					_cQuery += " AND SB6.B6_TPCF = 'F'
				Else
					_cQuery += " AND SB6.B6_TPCF = 'C'
				Endif
				_cQuery += " AND SB6.B6_SALDO > 0
				_cQuery += " AND SB6.B6_PRODUTO = '" + _cCodProd + "'
				_cQuery += " AND SB6.B6_CLIFOR = '" + _CodForn + "'
				_cQuery += " AND SB6.B6_LOJA = '" + _LojForn + "'
				_cQuery += " ORDER BY B6_EMISSAO
				
				If Select(_cAlias1) > 0
					dbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
				
				If (_cAlias1)->(!EOF())
					_aSldB6 := {} //Zerando o Vetor de Saldos em poder de terceiros
					_nQtdSld := _nQtde
					_lCalcDesc := .F. //Indica se precisa proporcionalizar o valor do desconto
					While (_cAlias1)->(!EOF())
						//Verifica se B6IDENT já foi usando em outro item da mesma nota
						If ascan(_aItens,{|x| x[12][2] == (_cAlias1)->B6_IDENT}) > 0
							//Verifica o saldo atualizado desse B6_IDENT, considerando os itens da nota atual
							_nSldB6Atu := 0
							For _nw:=1 To Len(_aItens)
								//Soma o saldo do B6_IDENT usado na nota atual
								If _aItens[_nw][12][2] == (_cAlias1)->B6_IDENT
									_nSldB6Atu += _aItens[_nw][3][2]
								Endif
							Next _nw
							_nSldB6Comp := (_cAlias1)->B6_SALDO - _nSldB6Atu
							If _nSldB6Comp <= 0
								(_cAlias1)->(DbSkip())
								Loop
							Endif                                    
							If _nSldB6Comp < _nQtdSld
								_lCalcDesc := .T.
								aAdd(_aSldB6,{_nSldB6Comp, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL})
								_nQtdSld := _nQtdSld - _nSldB6Comp
								(_cAlias1)->(DbSkip())
								Loop
							Else
								aAdd(_aSldB6,{_nQtdSld, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL})
								Exit
							Endif
						Endif

						_nSldB6Comp := (_cAlias1)->B6_SALDO
						_nQtdB6 := _nQtdSld - _nSldB6Comp
						//Caso a quantidade seja igual ao saldo, preencher somente um vez o array e sair do while para este produto
						If _nQtdB6 = 0
							aAdd(_aSldB6,{_nQtdSld, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL})
							Exit
						EndIf
						
						//Caso a quantidade desejada seja menor que o saldo, irá gravar o array e sair do while para este produto
						If _nQtdB6 < 0
							_nQtdB6 := _nQtdB6 * -1
							aAdd(_aSldB6,{_nQtdSld, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL })
							Exit
						EndIf
						
						//Caso a quantidade seja maior que o saldo, irá continuar no while deste produto para preencher o array dando a quantidade correta
						If _nQtdB6 > 0
							_lCalcDesc := .T.
							aAdd(_aSldB6,{_nSldB6Comp, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL })
							_nQtdSld := _nQtdSld - _nSldB6Comp
						EndIf
						(_cAlias1)->(DbSkip())
					EndDo
				Else
					_cErro += "Produto " + _cCodProd + " sem saldo de retorno (poder 3)."
					GN003(_cErro,_cPath)
					Return()
				EndIf
				
				//Validando se a quantidade esta correta para prosseguir
				_nQtdSld := 0
				
				For _ni := 1 To Len(_aSldB6)
					_nQtdSld += _aSldB6[_ni][1]
				Next _ni
				
				_cContC6 := STRZERO(1,TAMSX3("C6_ITEM")[1])
				
				If _nQtdSld == Val(_cQuant)
					For _ni := 1 To Len(_aSldB6)
						_alinhaOr:={}
						_nCnt++
						
						aAdd(_alinhaOr	,	{"D1_ITEM"		, STRZERO(_nCnt,TAMSX3("D1_ITEM")[1])	, Nil})
						aAdd(_alinhaOr	,	{"D1_COD"  		, _cCodProd								, Nil})
						aAdd(_alinhaOr	,	{"D1_QUANT"		, _aSldB6[_ni][1]						, Nil})
						aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nVlrUni								, Nil})
						aAdd(_alinhaOr	,	{"D1_TOTAL"		, _aSldB6[_ni][1]*_nVlrUni				, Nil})
						If _lCalcDesc
							aAdd(_alinhaOr	,	{"D1_VALDESC"	, (_nVlrDes/_nQtde)*_aSldB6[_ni][1]	, Nil})
						Else
							aAdd(_alinhaOr	,	{"D1_VALDESC"	, _nVlrDes								, Nil})
						Endif
						aAdd(_alinhaOr	,	{"D1_TES"		, _cTESImp								, Nil})
						If _cTipImp $ '1-3'
							aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocImp								, Nil})
						ElseIf _cTipImp == '4'
							aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocal								, Nil})
						ElseIf _cTipImp $ '2' .and. !Empty(_cLocImp)
							aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocImp								, Nil})
						Else
							aAdd(_alinhaOr	,	{"D1_LOCAL"		, _aSldB6[_ni][6]						, Nil})
						Endif
						aAdd(_alinhaOr	,	{"D1_NFORI"		, _aSldB6[_ni][2]						, Nil})
						aAdd(_alinhaOr	,	{"D1_SERIORI"	, _aSldB6[_ni][3]						, Nil})
						aAdd(_alinhaOr	,	{"D1_ITEMORI"	, _aSldB6[_ni][4]						, Nil})
						aAdd(_alinhaOr	,	{"D1_IDENTB6"	, _aSldB6[_ni][5]						, Nil}) // 03/02 - RAFAEL LEITE
						If _cTipImp == '4'
							aAdd(_alinhaOr	,	{"D1_CLVL"	, _cClasse									, Nil}) // 03/02 - RAFAEL LEITE
						Endif
						aadd(_aItens,_alinhaOr)
						
					Next _ni
				Else
					_cErro += "Produto sem saldo de terceiros: " + _cCodProd + "."
					GN003(_cErro,_cPath)
					Return()
				Endif
			Elseif _cTipImp $ '1/7/8/9'

				_alinhaOr:={}

				aAdd(_alinhaOr	,	{"D1_ITEM"		, STRZERO(Val(_cNumItem),TAMSX3("D1_ITEM")[1])	, Nil})
				aAdd(_alinhaOr	,	{"D1_COD"  		, _cCodProd										, Nil})
				aAdd(_alinhaOr	,	{"D1_QUANT"		, _nQtde										, Nil})
				aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nVlrUni										, Nil})
				aAdd(_alinhaOr	,	{"D1_TOTAL"		, _nVlrTot										, Nil})
				aAdd(_alinhaOr	,	{"D1_VALDESC"	, _nVlrDes										, Nil})
				aAdd(_alinhaOr	,	{"D1_TES"		, _cTESImp										, Nil})
				//aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocal										, Nil})
				aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocImp										, Nil})

				aadd(_aItens,_alinhaOr)

			Elseif _cTipImp $ '6'
                
				_cQuery := " SELECT D2_NFORI, D2_SERIORI, D2_ITEMORI
				_cQuery += " FROM " + RetSQLName("SD2") + " "
				_cQuery += " WHERE D_E_L_E_T_ = ' ' "
				_cQuery += " AND D2_FILIAL = '1022' "
				_cQuery += " AND D2_DOC = '"+PADR(AllTrim(_cNumNota),TAMSX3("F1_DOC")[1])+"' "
				_cQuery += " AND D2_SERIE = '"+PADR(AllTrim(_cSerNota),TAMSX3("F1_SERIE")[1])+"' "
				_cQuery += " AND D2_ITEM = '"+STRZERO(Val(_cNumItem),TAMSX3("D2_ITEM")[1])+"' "
				
				If Select(_cAlias1) > 0
					dbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
				
				_alinhaOr:={}

				aAdd(_alinhaOr	,	{"D1_ITEM"		, STRZERO(Val(_cNumItem),TAMSX3("D1_ITEM")[1])	, Nil})
				aAdd(_alinhaOr	,	{"D1_COD"  		, _cCodProd										, Nil})
				aAdd(_alinhaOr	,	{"D1_QUANT"		, _nQtde										, Nil})
				aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nVlrUni										, Nil})
				aAdd(_alinhaOr	,	{"D1_TOTAL"		, _nVlrTot										, Nil})
				aAdd(_alinhaOr	,	{"D1_VALDESC"	, _nVlrDes										, Nil})
				aAdd(_alinhaOr	,	{"D1_TES"		, _cTESImp										, Nil})
				aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocImp										, Nil}) 
				aAdd(_alinhaOr	,	{"D1_NFORI"		, (_cAlias1)->D2_NFORI							, Nil})
				aAdd(_alinhaOr	,	{"D1_SERIORI"	, (_cAlias1)->D2_SERIORI						, Nil})
				aAdd(_alinhaOr	,	{"D1_ITEMORI"	, (_cAlias1)->D2_ITEMORI						, Nil})

				aadd(_aItens,_alinhaOr)
			Endif
		Else
			_cErro += "Produto não localizado (posicionamento): " + _cCodProd + "."
			
			GN003(_cErro,_cPath)
			
			Return
		Endif
	Next
	If !_lOK
		//Envia o E-mail
		GN003("NOTA: " + _cNumNota + " " + _cErro,_cPath)
		Return()
	EndIf
	
	If Alltrim(_cFil) == Alltrim(cFilAnt)
		//Chamada da função
		_aRet := U_GNCOM01B(_aCabDcOr, _aItens, _cTipImp) //_xParam eh um parametro que serah passado para a funcao de destino tratar
		
		If _aRet[1]
			MsgInfo("Nota importada:" + _cSerNota + "/" + _cNumNota  )
		Else
			GN003("Falha na importação da nota.","")
		EndIf
	Else
		_cErro := "Nota fiscal não pertence a esta empresa/filial. Utilize a filial: " + _cEmp + "/" + _cFil
		//Envia Email de erro
		GN003(_cErro,_cPath+_cFile)
		Return
	EndIf
EndIf

Static Function GN003(_cErro, _cArquivo)

Conout(_cErro)
_cTitulo := "Importação de XML de NFE"
MsgStop(_cErro,_cTitulo)

Return()

/*
Função: GNCOM01B

Descrição: Gravação da nota fiscal de entrada.

Manutenções:
25/06/2015 - Rafael Leite - Criação do fonte
*/
User Function GNCOM01B(_aCabDcOr, _aItmDcOr, _cTipImp)

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
//Private lAutoErrNoFile 	:= .T.

_lRet := .T.
_cRet := ""
	
DbSelectArea("SC5")
DbSetOrder(1)

DbSelectArea("SA1")
DbSelectArea("SA2")

MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	_lRet := .F.
	_aErro := GetAutoGRLog()
	_cErro := MostraErro()
	Disarmtransaction()
EndIf

Return({_lRet,_cRet})

//TELA PARA INFORMAR O CÓDIGO DO PRODUTO DURANTE A IMPORTAÇÃO
Static Function f001(_cTexto)

Private _oDlg
Private _cRetProd := Space(TamSx3("B1_COD")[1])
Private _cDesProd := Space(100)

DEFINE MSDIALOG _oDlg TITLE "Informe o produto" FROM 000,000 TO 110,500 PIXEL
@010,010 SAY _cTexto OF _oDlg PIXEL
@025,010 SAY "Produto:" SIZE 55,07 OF _oDlg PIXEL
@023,035 MSGET _cRetProd SIZE 150,11 OF _oDlg PIXEL PICTURE "@!" VALID f002()
@040,010 SAY _cDesProd OF _oDlg PIXEL
DEFINE SBUTTON FROM 024, 208 TYPE 1 ACTION (_oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG _oDlg CENTERED

Return Alltrim(_cRetProd)

Static Function f002()

If Empty(_cRetProd)
	Alert("Informe um código de produto.")
	Return(.F.)
Endif

//Pesquisa código de produto
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cRetProd),TamSX3("B1_COD")[1])))
	_cDesProd := "Produto localizado: " + SB1->B1_DESC
	_oDlg:Refresh()
	Return(.T.)
Else
	//Pesquisa ISBN
	SB1->(DbSetOrder(11))
	If SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cRetProd),TamSX3("B1_CODBAR")[1])))
		_cDesProd := "Produto localizado: " + SB1->B1_DESC
		_oDlg:Refresh()
		Return(.T.)
	Endif
Endif

Alert("Produto não encontrado.")

Return(.F.)

Static Function f003(_cTexto)

Private _oDlg
Private _cRetClas := Space(TamSx3("CTH_CLVL")[1])
Private _cDesClas := Space(100)

DEFINE MSDIALOG _oDlg TITLE "Informe o Classe de Valor" FROM 000,000 TO 110,500 PIXEL

@010,010 SAY _cTexto OF _oDlg PIXEL
@025,010 SAY "Classe:" SIZE 55,07 OF _oDlg PIXEL
@023,035 MSGET _cRetClas SIZE 150,11 OF _oDlg PIXEL PICTURE "@!" VALID f004()
@040,010 SAY _cDesClas OF _oDlg PIXEL

DEFINE SBUTTON FROM 024, 208 TYPE 1 ACTION (_oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG _oDlg CENTERED

Return Alltrim(_cRetClas)

Static Function f004()

If Empty(_cRetClas)
	
	Alert("Informe um código de Classe de Valor.")
	
	Return .F.
Endif

//Pesquisa código de produto
CTH->(DbSetOrder(1))
If CTH->(DbSeek(xFilial("CTH")+PadR(ALLTRIM(_cRetClas),TamSX3("CTH_CLVL")[1])))
	
	_cDesClas := "Classe localizada: " + CTH->CTH_DESC01
	_oDlg:Refresh()
	
	Return .T.
Endif

Alert("Classe não encontrada.")

Return .F.
