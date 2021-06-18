#include 'protheus.ch'

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENA021   ∫Autor  ≥Rafael Leite        ∫ Data ≥  25/06/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Importacao de XML para Documento de Entrada                 ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ GEN                                                        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫04/08/2015≥Danilo - Opcao para importar retorno de conserto grafica    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function GENA021()

Private cCadastro 	:= "ReconsignaÁ„o GEN"
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
Local cTpPub		:= CriaVar("B1_XIDTPPU",.F.)
Local cArmazem	:= CriaVar("B2_LOCAL",.F.)
Local lAcessLocal	:= AllTrim(RetCodUsr())$GetMv("GEN_COM021") .AND. _cTipImp == "2"

Private cCombo1		:= ""
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
	_cMsgInfo := "Deseja importar CONSIGNA«√O Intercia?"
ElseIf _cTipImp == "2"
	_cMsgInfo := "Deseja importar DEVOLU«√O DE CONSIGNA«√O?"
ElseIf _cTipImp == "3"
	_cMsgInfo := "Deseja importar DEVOLU«√O DE ACERTO?"
ElseIf _cTipImp == "4"
	_cMsgInfo := "Deseja importar RETORNO DE REPARO DA GRAFICA?"
ElseIf _cTipImp == "5"
	_cMsgInfo := "Deseja importar DEVOLU«√O INTERCIA?"
ElseIf _cTipImp == "6"
	_cMsgInfo := "PRESTACAO DE CONTAS - DEVOLUCAO VENDA?"
ElseIf _cTipImp == "7"
	_cMsgInfo := "PRESTACAO DE CONTAS - VENDA ATLAS?"
ElseIf _cTipImp == "8"
	_cMsgInfo := "PRESTACAO DE CONTAS - OFERTA ATLAS?"
ElseIf _cTipImp == "9"
	_cMsgInfo := "RETORNO OFERTA? TES 463"
ElseIf _cTipImp == "A"       // temporario deve ser removida
	_cMsgInfo := "RETORNO TES 414"	
ElseIf _cTipImp == "B"       // temporario deve ser removida
	_cMsgInfo := "Deseja importar CONSIGNA«√O com a TES 438"	
ElseIf _cTipImp == "C"       // temporario deve ser removida
	_cMsgInfo := "Deseja importar dev.aparas TES 441?"		
Endif

//Par‚metros iniciais
If !MsgNoYes(_cMsgInfo)
	Return()
Endif

DEFINE MSDIALOG oDlg TITLE "Selecionar arquivo" FROM 000,000 TO 180,440 PIXEL

@010,010 SAY "Selecione o arquivo a ser importado." OF oDlg PIXEL
@025,010 SAY "Arquivo:" SIZE 55,07 OF oDlg PIXEL
@023,035 MSGET _cFile F3 "ARQ1" SIZE 150,10 OF oDlg PIXEL PICTURE "@!" //VALID !Vazio()
@040,010 SAY "Msg.Nota:" SIZE 55,07 OF oDlg PIXEL
@038,035 MSGET _cMsgNf SIZE 150,10 OF oDlg PIXEL PICTURE "@!" //VALID !Vazio()

If _cTipImp $ '1/7/8/9/A/C/B/C'
	@055,010 SAY "Tipo PublicaÁ„o:" SIZE 55,07 OF oDlg PIXEL
	@053,051 MSGET cTpPub SIZE 25,10 OF oDlg F3 "Z4" PIXEL PICTURE "@!" VALID ( IIF( SX5->(DbSeek(xFilial("SX5")+"Z4"+cTpPub)) .OR. Empty(cTpPub) , (oObjTpTub:SetText(AllTrim(SX5->X5_DESCRI)),.t.) , (oObjTpTub:SetText(""),.f.)  )  )
	
	oObjTpTub := TSay():New(056,080,{||''},oDlg,,,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	@070,010 SAY "Busca Prod.:" SIZE 55,07 OF oDlg PIXEL
	aItems	:= {"1=Produtos","2=Pela Nota"}
	cCombo1	:= aItems[1]
	oCombo1 := TComboBox():New(070,051,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItems,100,20,oDlg,,{|| },,,,.T.,,,,,,,,,'cCombo1')
	If lAcessLocal 
		@055,085 SAY "Armazem:" SIZE 55,07 OF oDlg PIXEL
		@053,115 MSGET cArmazem SIZE 25,10 OF oDlg PIXEL PICTURE "99" VALID ( ExistCpo("NNR", cArmazem, 1, "REGNOIS") )
	EndIf	
Else
	If lAcessLocal 
		@055,010 SAY "Armazem:" SIZE 55,07 OF oDlg PIXEL
		@053,045 MSGET cArmazem SIZE 25,10 OF oDlg PIXEL PICTURE "99" VALID ( ExistCpo("NNR", cArmazem, 1, "REGNOIS") )
	EndIf	
EndIf
	
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
	GN003("Esta rotina permite apenas a importaÁ„o de arquivo do tipo XML.",_cPath)
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
GN002(_cPathDes,_cFile,_cXML,_cTipImp,_cTES,cTpPub,cArmazem)

End Transaction

tcsqlexec("UPDATE "+RetSqlName("SB2")+" SET B2_QTNP = 0 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' '")

Return()

Static Function MenuDef()

Local _aRet := {}

AADD(_aRet,{"Importar XML"		,"Processa( {|| U_GENA021A('2')})"	,0,3})
AADD(_aRet,{"Importar Acerto"	,"Processa( {|| U_GENA021A('3')})"	,0,3})
AADD(_aRet,{"Importar Ret. Grafica"	,"Processa( {|| U_GENA021A('4')})"	,0,3})
AADD(_aRet,{"Importar Intercia"	,"Processa( {|| U_GENA021A('5')})"	,0,3})
AADD(_aRet,{"DevoluÁ„o GEN"		,"Processa( {|| U_GENA022()  })"	,0,3})
AADD(_aRet,{"Pedido de Venda"	,"Processa( {|| U_GENA023()  })"	,0,3})
AADD(_aRet,{"Ret.Origem Aparas"	,"Processa( {|| U_GENA021A('C')})"	,0,3})
//AADD(_aRet,{"DevoluÁ„o Compras"	,"Processa( {|| U_GENA021A('6')})"	,0,3})
	
//06/10/2015 - Rafael Leite - Ajuste prestaÁ„o de contas Atlas
If (upper(alltrim(GetEnvServer())) $ "SCHEDULE")
//	AADD(_aRet,{"Dev. Venda Prest. "	,"Processa( {|| U_GENA021A('3')})"	,0,3})
	AADD(_aRet,{"Venda - Atlas"		,"Processa( {|| U_GENA021A('7')})"	,0,3})
	AADD(_aRet,{"Oferta - Atlas"	,"Processa( {|| U_GENA021A('8')})"	,0,3})
Endif

AADD(_aRet,{"Visualizar"	,"A103NFiscal",0,2})

Return(_aRet)

/*
FunÁ„o: GENA021B

DescriÁ„o: Tela para selecionar arquivo

ManutenÁıes:
25/06/2015 - Rafael Leite - CriaÁ„o do fonte
*/
User Function GENA021B

Default _cFile := ""

_cFile := cGetFile("*.xml",OemToAnsi("Selecionar..."),0,"C:\",.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.,.T.)

If FunName()=="GENA021"
	oDlg:Refresh()
Endif

Return(_cFile)

/*
FunÁ„o: GN002

DescriÁ„o: InterpretaÁ„o do arquivo XML

ManutenÁıes:
25/06/2015 - Rafael Leite - CriaÁ„o do fonte
*/
Static Function GN002(_cPath,_cFile,_cXML,_cTipImp,_cTES,cTpPub,cArmazem)

Local _oXml 	:= NIL
Local cError 	:= ""
Local cWarning 	:= ""
Local _lFaltCpo := .F.
Local _lXValBru := .F. //GravaÁ„o do campo personalizado F1_XVALBRU
Local _cAlias1  := GetNextAlias()
Local _cAliasX  := GetNextAlias()
Local _cTesImp	:= GetMV("GEN_COM002")  
Local _cFilOrig	:= "" 
Local lVldOrig	:= .F.
Local lSB2Ok	:= .T.

Private aLogTmp	:= {} 

Private oServer := NIL

Default cArmazem	:= ""

//Se for tipo 1 pega TES selecionado pelo usu·rio
If _cTipImp == "1"
	_cTesImp := GetMv("GEN_COM011") //Entrada consignaÁ„o intercompany
	_cLocImp := GetMv("GEN_COM014") //Armazem a ser movimentado
ElseIf _cTipImp == "2"
	_cLocImp := GetMv("GEN_COM018") //Armazem a ser movimentado 
	_cTesImp := GetMv("GEN_COM020") //TES DEVOLUCAO DE CONSIGNACAO GENA021              				
ElseIf _cTipImp == "3"
	_cTesImp := GetMv("GEN_COM009") //Entrada consignaÁ„o intercompany
	_cLocImp := GetMv("GEN_COM010") //Armazem a ser movimentado
ElseIf _cTipImp == "4"
	_cTesImp := GetMv("GEN_COM012") //Entrada retorno reparo grafica
ElseIf _cTipImp == "5"
	_cTesImp := GetMv("GEN_COM013") //Entrada retorno reparo grafica
ElseIf _cTipImp == "6"
	_cTesImp := "452" //Devolucao venda prestacao
	_cLocImp := "01" //Armazem a ser movimentado
ElseIf _cTipImp == "7"
	_cTesImp := GetMv("GEN_FAT024") //Entrada Venda PrestaÁÁao Atlas
	_cLocImp := '01' //Armazem a ser movimentado                       
ElseIf _cTipImp == "8"
	_cTesImp := GetMv("GEN_FAT008") //Entrada Oferta PrestaÁÁao Atlas
	_cLocImp := '01' //Armazem a ser movimentado
ElseIf _cTipImp == "9"
	_cTesImp := GetMv("GEN_COM015") //Outras Entradas
	_cLocImp := GetMv("GEN_COM016") //Armazem a ser movimentado   
ElseIf _cTipImp == "A"
	_cTesImp := "414" //Entrada consignaÁ„o intercompany
	_cLocImp := "01" //Armazem a ser movimentado	 
ElseIf _cTipImp == "B"
	_cTesImp := "438" //Entrada consignaÁ„o intercompany
	_cLocImp := "03" //USANDO PARA APARAS //GetMv("GEN_COM014") //Armazem a ser movimentado	 
ElseIf _cTipImp == "C" 
	_cTesImp := "441" //Entrada dev aparas
	_cLocImp := "01"//GetMv("GEN_COM014") //Armazem a ser movimentado	 	
ElseIf _cTipImp == "D" // PARA FORNECEDOR
	_cTesImp := "439" //Entrada consignaÁ„o intercompany
	_cLocImp := GetMv("GEN_COM014") //Armazem a ser movimentado	 	
	
Endif

If !Empty(cArmazem)
	_cLocImp	:= cArmazem 
EndIf

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

//CabeÁalho das Notas Fiscais de Entrada
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

//If Type("_oObjet:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO") <> "U"
//	_cDesp       := _oObjet:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text
//Else
//	_cDesp       := "0"
//EndIf

//Coloca a Data de emiss„o no formato ddmmaaaa
_dEmissao    := Iif(!Empty(_dEmissao),SUBSTR(_dEmissao,1,4)+SUBSTR(_dEmissao,6,2)+SUBSTR(_dEmissao,9,2),"")
_dEmissao    := StoD(_dEmissao)
_cTipo       := _oObjet:_INFNFE:_IDE:_TPNF:Text

_aAreaSM0 	:= SM0->(GetArea())
_lOK 		:= .F.

//Valida variaveis carregadas no XML
If Valtype(_cFilCNPJ) <> "C"
	GN003("InformaÁ„o inv·lida na TAG CNPJ Filial.")
	Return()
ElseIf Valtype(_cFornCNPJ) <> "C"
	GN003("InformaÁ„o inv·lida na TAG CNPJ Fornecedor.")
	Return()
ElseIf Valtype(_cUF) <> "C"
	GN003("InformaÁ„o inv·lida na TAG UF.")
	Return()
ElseIf Valtype(_cNumNota) <> "C"
	GN003("InformaÁ„o inv·lida na TAG Numero da Nota.")
	Return()
ElseIf Valtype(_cSerNota) <> "C"
	GN003("InformaÁ„o inv·lida na TAG Numero da Nota.")
	Return()
ElseIf Valtype(_cChvNFE) <> "C"
	GN003("InformaÁ„o inv·lida na TAG Chave.")
ElseIf Valtype(_dEmissao) <> "D"
	GN003("InformaÁ„o inv·lida na TAG Emiss„o.")
	Return()
ElseIf Valtype(_cPedido) <> "C"
	GN003("InformaÁ„o inv·lida na TAG Pedido.")
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

//Posiciona na Filial
DbSelectArea("SM0")
SM0->(DbGoTop())
While !SM0->(Eof())
	
	//Verifica se o CNPJ do destinatario existe no Cadastro de empresas
	If Alltrim(_cFornCNPJ) == Alltrim(SM0->M0_CGC)
		_cFilOrig 	:= SM0->M0_CODFIL
	EndIf
	
	SM0->(DbSkip())
EndDo

RestArea(_aAreaSM0)

If !_lOK
	_cErro := " Filial n„o encontrada no Cadastro de empresas"
Else
	_cErro := ""
	
	//Verifica o tipo de nota fiscal
	If _cTipo != '1'
		_cErro += "Tipo do Documento Fiscal inv·lido" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o CNPJ est· em branco
	If Empty(_cFornCNPJ)
		_cErro += "CNPJ do Fornecedor em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o numero da nota est· em branco
	If Empty(_cNumNota)
		_cErro += "Numero da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se a serie da nota est· em branco
	If Empty(_cSerNota)
		_cErro += "SÈrie da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se a emiss„o est· em branco
	If Empty(_dEmissao)
		_cErro += "Emiss„o da Nota Fiscal em Branco" + " / "
		_lOK 	:= .F.
	Endif
	
	//Verifica se o fornecedor do xml est· cadastrado
	If _cTipImp $ "1/4/7/8/9/A"
		dbSelectArea("SA2")
		dbSetOrder(3)
		If SA2->(dbSeek(xFilial("SA2")+Alltrim(_cFornCNPJ)))
			_CodForn := SA2->A2_COD
			_LojForn := SA2->A2_LOJA
			_cErro := _CodForn + " - " + SA2->A2_NOME + CRLF
		Else
			_cErro += "Fornecedor n„o encontrado" + " / "
			_lOK 	:= .F.
		EndIf
	Elseif _cTipImp $ "2/3/5/6/B/C"
		dbSelectArea("SA1")
		dbSetOrder(3)
		If SA1->(dbSeek(xFilial("SA1")+Alltrim(_cFornCNPJ)))
			_CodForn := SA1->A1_COD
			_LojForn := SA1->A1_LOJA
			_cErro	 := _CodForn + " - " + SA1->A1_NOME + CRLF
			lVldOrig := SA1->A1_XCTRPD3 == "1"
		Else
			_cErro += "Cliente n„o encontrado" + " / "
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
	If _cTipImp $ "1/4/7/8/9/A"
		_cTipoDoc := 'N'
	ElseIf _cTipImp $ "2/3/5/B/C"
		_cTipoDoc := 'B'
	ElseIf _cTipImp $ "6"
		_cTipoDoc := 'D'
	Endif
	
	_cMvEspc := GetMv("GEN_FAT020") //ContÈm a especie utilizada na nota de entrada das empresas Matriz e Origem
	_cMvCdDe := GetMv("GEN_FAT021") //ContÈm a condiÁ„o de pagamento utilizada na nota de entrada das empresas Matriz e Origem
	
	//carrega array com os dados do cabeÁalho da PrÈ-Nota de Entrada
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
	_nCnt	:= 0
	
	If lVldOrig
		If !Valtype(XmlChildEx( _oObjet:_INFNFE:_IDE, "_NFREF" )) <> "U"
			GN003("Notas fiscias referenciadas n„o informadas no XML!")
			_lOK := .F.
			Return .F.		
		Else
			If Valtype(XmlChildEx( _oObjet:_INFNFE:_IDE, "_NFREF" )) <> "A"
				XmlNode2Arr( _oObjet:_INFNFE:_IDE:_NFREF, "_NFREF" )
			EndIf
		EndIf

		If Len(_oObjet:_INFNFE:_IDE:_NFREF) == 0
			GN003("Notas fiscias referenciadas n„o informadas no XML!")
			_lOK := .F.
			Return .F.		
		EndIf
				
    EndIf
    		
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
			GN003("InformaÁ„o inv·lida na TAG Produto. Item:" + cValToChar(_nTmp))
			_lOK := .F.
			Exit
		ElseIf Valtype(_cEAN) <> "C"
			GN003("InformaÁ„o inv·lida na TAG EAN. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cNumItem) <> "C"
			GN003("InformaÁ„o inv·lida na TAG Numero Item. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cUm) <> "C"
			GN003("InformaÁ„o inv·lida na TAG Unidade. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cQuant) <> "C"
			GN003("InformaÁ„o inv·lida na TAG Quantidade. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cValUnit) <> "C"
			GN003("InformaÁ„o inv·lida na TAG Valor unitario. Item:" + cValToChar(_nTmp))
			Exit
		ElseIf Valtype(_cVlTot) <> "C"
			GN003("InformaÁ„o inv·lida na TAG Valor total. Item:" + cValToChar(_nTmp))
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
		
		//ValidaÁıes
		If Empty(_cCodProd)
			_cErro += "CÛdigo do Produto em Branco" + " / "
			_lOK 	:= .F.
		Endif
		If Empty(_cNumItem)
			_cErro += "Numero do Item do CabeÁalho da Nota Fiscal em Branco" + " / "
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
			
			//Verifica se o produto enviado no xml est· cadastrado
			/*
			DbSelectArea("SB1")
			SB1->(DbSetOrder(11))
			If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
			DbSelectArea("SB1")
			SB1->(DbSetOrder(5))
			If !SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cEAN),TamSX3("B1_CODBAR")[1])))
			*/
			
			If cCombo1 == "2" .AND. _cTipImp $ '1/7/8/9/A/C/B'
				
				If Empty(_cFilOrig)
					MsgStop("Falha ao identificar a filial emitende da nota fiscal!")
					Return nil
				endIf
                				
				cItAux	:= Replicate("0",TamSX3("D2_ITEM")[1])
				nLoop	:= 1
				While nLoop <= Val(_cNumItem)
					nLoop++
					cItAux	:= Soma1(cItAux)
				EndDo
											  				
				_cQuery := " SELECT DISTINCT B1_COD FROM "+RetSqlName("SD2")+" SD2
				_cQuery += " JOIN "+RetSqlName("SB1")+" SB1
				_cQuery += " ON B1_FILIAL = '" + xFilial("SB1") + "'
				_cQuery += " AND B1_COD = D2_COD
				_cQuery += " AND SB1.D_E_L_E_T_ <> '*'
				_cQuery += " WHERE D2_FILIAL = '"+_cFilOrig+"'
				_cQuery += " AND D2_DOC = '"+_cNumNota+"'
				_cQuery += " AND D2_SERIE = '"+_cSerNota+"'
				_cQuery += " AND D2_ITEM = '"+cItAux+"'"
			   /*	If Empty(cTpPub)
					_cQuery += " AND B1_XIDTPPU <> '11'
				Else
					_cQuery += " AND B1_XIDTPPU = '"+cTpPub+"'	
				EndIf			*/
				_cQuery += " AND (B1_ISBN = '" + ALLTRIM(_cEAN) + "' OR B1_CODBAR = '" + ALLTRIM(_cEAN) + "')
				_cQuery += " AND SD2.D_E_L_E_T_ <> '*'			
			
			Else

				_cQuery := " SELECT B1_COD
				_cQuery += " FROM " + RetSqlName("SB1")
				_cQuery += " WHERE D_E_L_E_T_ = ' '
				_cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "'"
				
				If Empty(cTpPub)
					_cQuery += " AND B1_XIDTPPU <> '11'
				Else
					_cQuery += " AND B1_XIDTPPU = '"+cTpPub+"'	
				EndIf	
				
				_cQuery += " AND (B1_ISBN   = '" + ALLTRIM(_cEAN) + "'"
				_cQuery += "  OR B1_CODBAR = '" + ALLTRIM(_cEAN) + "')"
						
			EndIf
			
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
						
						//Caso n„o encontre o produto, abre tela para que o usu·rio selecione
						_cEAN := f001("Produto n„o identificado. Item: " + cValtoChar(_cNumItem) ;
						+ ". Valor total: " + cValtoChar(_cVlTot) ;
						+ ". Informe o ISBN ou cÛdigo de produto.")
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
						If Empty(cTpPub)
							_cQuery += " AND B1_XIDTPPU <> '11'
						Else
							_cQuery += " AND B1_XIDTPPU = '"+cTpPub+"'	
						EndIf
						_cQuery += " AND (B1_ISBN   = '" + ALLTRIM(_cEAN) + "'"
						_cQuery += "  OR B1_COD = '" + ALLTRIM(_cEAN) + "')"
						If Select(_cAlias1) > 0
							dbSelectArea(_cAlias1)
							(_cAlias1)->(dbCloseArea())
						EndIf
						dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
						
						If (_cAlias1)->(EOF())
							_cErro += "Produto " + _cEAN + " n„o cadastrado" + " / "
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
				_cErro += "Produto " + _cCodProd + " n„o cadastrado" + " / "
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
		If SB1->(DbSeek(xFilial("SB1")+_cCodProd)) .AND. (AllTrim(SB1->B1_XIDTPPU) == AllTrim(cTpPub) .OR. Empty(AllTrim(cTpPub)))
			If _cTipImp $ '4'
				_cClasse := f003("Informe a Classe de Valor. Item: " + cValtoChar(_cNumItem) ;
				+ ". Produto: " + Alltrim(_cCodProd) ;
				+ ".")
			Endif
			
			_cUm := SB1->B1_UM
			
			//Parametro com o armazÈm a ser utilizado
			_cLocal := SB1->B1_LOCPAD
			
			//_nQtde := val(_cQuant)*_nMulti
			_nQtde := val(_cQuant)
			_nVlrUni := Val(_cVlTot) / _nQtde
			_nVlrTot := Val(_cVlTot)
			_nVlrDes := Val(_cVDesc)
			
			//Documentos que precisam informar Doc Origem, Serie Origem, Item Origem e IdentB6
			If _cTipImp $ '2/3/4/5/B/C'
				
				//Consulta saldo PODER 3
				//Realizando a busca por saldo em poder de terceiros
				_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B6_DOC, B6_SALDO,
				_cQuery += " B6_SERIE, D2_ITEM, B6_IDENT, B6_LOCAL
				_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD2") + " SD2
				
				If lVldOrig
					_cQuery += " , "+RetSqlName("SF2") + " SF2 "
				EndIf
				
				_cQuery += " WHERE SB6.B6_DOC = SD2.D2_DOC
				_cQuery += " AND SB6.B6_SERIE = SD2.D2_SERIE
				_cQuery += " AND SB6.B6_PRODUTO = SD2.D2_COD
				_cQuery += " AND SB6.B6_CLIFOR = SD2.D2_CLIENTE
				_cQuery += " AND SB6.B6_LOJA = SD2.D2_LOJA

				If lVldOrig
					_cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL
					_cQuery += " AND SF2.F2_DOC = SD2.D2_DOC
					_cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE
					_cQuery += " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE
					_cQuery += " AND SF2.F2_LOJA = SD2.D2_LOJA
					
					If !(AllTrim(_CodForn) $ "0380795#0380796#0380794#031811#0378128#0005065")
						_cQuery += " AND F2_CHVNFE IN ("
						For nAuxChv := 1 To Len(_oObjet:_INFNFE:_IDE:_NFREF)
							
							If ValType(XmlChildEx( _oObjet:_INFNFE:_IDE:_NFREF[nAuxChv], "_REFNFE" )) == "O"
								cChaveNfe := "'"+_oObjet:_INFNFE:_IDE:_NFREF[nAuxChv]:_REFNFE:TEXT+"'"
							ElseIf ValType(XmlChildEx( _oObjet:_INFNFE:_IDE:_NFREF[nAuxChv], "_REFNF" )) == "O"
							
								SF2->(DbSetOrder(1))//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
								If SF2->( DbSeek( ;
										xFilial("SF2")+;
										PadL(AllTrim(_oObjet:_INFNFE:_IDE:_NFREF[nAuxChv]:_REFNF:_NNF:TEXT),TamSX3("F2_DOC")[1],"0")+;
										PadR(AllTrim(_oObjet:_INFNFE:_IDE:_NFREF[nAuxChv]:_REFNF:_SERIE:TEXT),TamSX3("F2_SERIE")[1])+;
										SA1->A1_COD+SA1->A1_LOJA;
								 ) )
								 
									cChaveNfe := "'"+SF2->F2_CHVNFE+"'"
								EndIf
							EndIf

							_cQuery += cChaveNfe
							If nAuxChv < Len(_oObjet:_INFNFE:_IDE:_NFREF)
								_cQuery += ","
							EndIf

						Next nAuxChv
						_cQuery += " )"
					EndIf
					
					If AllTrim(_CodForn) $ "0380795#0380796#0380794#031811#0378128#0005065"
						cItAux	:= Replicate("0",TamSX3("D2_ITEM")[1])
						nLoop	:= 1
						While nLoop <= Val(_cNumItem)
							nLoop++
							cItAux	:= Soma1(cItAux)
						EndDo
									
						/* Notas intercia devem pegar o item correto da nota de entrada */												
						_cQuery += " AND ( "
												
						_cQuery += " EXISTS( "
						_cQuery += " SELECT 1 FROM " + RetSqlName("SD2") + " SD2ORI "
						_cQuery += " WHERE SD2ORI.D2_FILIAL	= DECODE(SD2.D2_CLIENTE,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','0005065','1022') "
						_cQuery += " AND SD2ORI.D2_DOC		= '"+_cNumNota+"' "
						_cQuery += " AND SD2ORI.D2_SERIE	= '"+_cSerNota+"' "
						_cQuery += " AND SD2ORI.D2_ITEM 	= '"+cItAux+"' "
						_cQuery += " AND SD2ORI.D2_COD		= SD2.D2_COD "
						_cQuery += " AND SD2ORI.D2_NFORI	= SD2.D2_DOC "
						_cQuery += " AND SD2ORI.D2_SERIORI	= SD2.D2_SERIE "
						_cQuery += " AND SD2ORI.D2_ITEMORI = SD2.D2_ITEM "
						_cQuery += " AND SD2ORI.D_E_L_E_T_ <> '*' "
						_cQuery += " ) "

						_cQuery += " OR ("

						_cQuery += " EXISTS( "
						_cQuery += " SELECT 1 FROM " + RetSqlName("SD2") + " SD2ORI "
						_cQuery += " WHERE SD2ORI.D2_FILIAL	= DECODE(SD2.D2_CLIENTE,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','0005065','1022') "
						_cQuery += " AND SD2ORI.D2_DOC		= '"+_cNumNota+"' "
						_cQuery += " AND SD2ORI.D2_SERIE	= '"+_cSerNota+"' "
						_cQuery += " AND SD2ORI.D2_ITEM 	= '"+cItAux+"' "
						_cQuery += " AND SD2ORI.D2_COD		= SD2.D2_COD "
						_cQuery += " AND SD2ORI.D2_NFORI	= SD2.D2_DOC "
						_cQuery += " AND SD2ORI.D2_SERIORI	= SD2.D2_SERIE "
						_cQuery += " AND SD2ORI.D_E_L_E_T_ <> '*' "
						_cQuery += " 	) "

						_cQuery += " AND NOT EXISTS( "
						_cQuery += " SELECT 1 FROM " + RetSqlName("SD2") + " SD2ORI "
						_cQuery += " WHERE SD2ORI.D2_FILIAL	= DECODE(SD2.D2_CLIENTE,'0380795','2022','0380796','3022','0380794','4022','031811 ','6022','0378128','9022','0005065','1022') "
						_cQuery += " AND SD2ORI.D2_DOC		= '"+_cNumNota+"' "
						_cQuery += " AND SD2ORI.D2_SERIE	= '"+_cSerNota+"' "
						_cQuery += " AND SD2ORI.D2_ITEM 	= '"+cItAux+"' "
						_cQuery += " AND SD2ORI.D2_COD		= SD2.D2_COD "
						_cQuery += " AND SD2ORI.D2_NFORI	= SD2.D2_DOC "
						_cQuery += " AND SD2ORI.D2_SERIORI	= SD2.D2_SERIE "
						_cQuery += " AND SD2ORI.D_E_L_E_T_ <> '*' "
						_cQuery += " 	) "
						
						_cQuery += " 	) "
						_cQuery += " ) "
																		
					EndIf
				EndIf
								
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
				
				If lVldOrig
					_cQuery += " AND SB6.B6_SALDO >= "+AllTrim(cValTochar(_nQtde))+" "
				Else
					_cQuery += " AND SB6.B6_SALDO > 0
				EndIf
				
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
						//Verifica se B6IDENT j· foi usando em outro item da mesma nota
						If ascan(_aItens,{|x| len(x) >= 12 .AND. x[12][2] == (_cAlias1)->B6_IDENT}) > 0
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
						
						//Caso a quantidade desejada seja menor que o saldo, ir· gravar o array e sair do while para este produto
						If _nQtdB6 < 0
							_nQtdB6 := _nQtdB6 * -1
							aAdd(_aSldB6,{_nQtdSld, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL })
							Exit
						EndIf
						
						//Caso a quantidade seja maior que o saldo, ir· continuar no while deste produto para preencher o array dando a quantidade correta
						If _nQtdB6 > 0
							_lCalcDesc := .T.
							aAdd(_aSldB6,{_nSldB6Comp, (_cAlias1)->B6_DOC, (_cAlias1)->B6_SERIE, (_cAlias1)->D2_ITEM, (_cAlias1)->B6_IDENT,(_cAlias1)->B6_LOCAL })
							_nQtdSld := _nQtdSld - _nSldB6Comp
						EndIf
						(_cAlias1)->(DbSkip())
					EndDo
				Else
					Aadd( aLogTmp , "'"+_cCodProd+";"+AllTrim(Str(Val(_cQuant)))+";Produto " + AllTrim(_cCodProd) + " sem saldo de retorno (poder 3)." )
					_lOK	:= .F.
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
						ElseIf _cTipImp $ '2/B/C'
							If !Empty(_cLocImp)
								aAdd(_alinhaOr	,	{"D1_LOCAL"		, _cLocImp								, Nil})
							Else
								aAdd(_alinhaOr	,	{"D1_LOCAL"		, _aSldB6[_ni][6]						, Nil})	
							EndIf	
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
					Aadd( aLogTmp , "'"+_cCodProd+";"+AllTrim(Str(Val(_cQuant)))+";Produto sem saldo de terceiros: " + Alltrim(_cCodProd) + "." )
					_lOK	:= .F.
					_cErro += "Produto sem saldo de terceiros: " + _cCodProd + "."
					GN003(_cErro,_cPath)									
					Return()
				Endif
			Elseif _cTipImp $ '1/7/8/9/A'

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
				//_cQuery += " AND D2_ITEM = '"+STRZERO(Val(_cNumItem),TAMSX3("D2_ITEM")[1])+"' "
				_cQuery += " AND D2_ITEM = '"+PadItemSD2(_cNumItem)+"' "

				If Select(_cAlias1) > 0
					dbSelectArea(_cAlias1)
					(_cAlias1)->(dbCloseArea())
				EndIf
				
				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1, .F., .T.)
				
				_alinhaOr:={}    

				_cItemSD2	:= PadItemSD2((_cAlias1)->D2_ITEMORI)
                
				_cQuery := " SELECT D2_ITEM 
				_cQuery += " FROM " + RetSQLName("SD2") + " "
				_cQuery += " WHERE D_E_L_E_T_ = ' ' "
				_cQuery += " AND D2_FILIAL = '4022' "
				_cQuery += " AND D2_DOC = '"+(_cAlias1)->D2_NFORI+"' "
				_cQuery += " AND D2_SERIE = '"+(_cAlias1)->D2_SERIORI+"' "
				//_cQuery += " AND D2_ITEM = '"+STRZERO(Val(_cNumItem),TAMSX3("D2_ITEM")[1])+"' "
				_cQuery += " AND D2_COD = '"+_cCodProd+"' "

				If Select(_cAliasX) > 0
					dbSelectArea(_cAliasX)
					(_cAliasX)->(dbCloseArea())
				EndIf

				dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliasX, .F., .T.)
				(_cAlias1)->(DbGoTop())
				_cItemSD2	:= PadItemSD2((_cAliasX)->D2_ITEM)
				
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
				aAdd(_alinhaOr	,	{"D1_ITEMORI"	, _cItemSD2										, Nil})

				aadd(_aItens,_alinhaOr)
			Endif
		Else
			_cErro += "Produto n„o localizado (posicionamento): " + _cCodProd + "."
			
			GN003(_cErro,_cPath)
			
			Return
		Endif
	Next
	If !_lOK
		//Envia o E-mail
		GN003("NOTA: " + _cNumNota + " " + _cErro,_cPath)
		Return()
	EndIf
	
	If Len(_aItens) == 0
		GN003("N„o foram encontrados intes com saldo para est· nota!")
		return nil
	endIf
	
	If Alltrim(_cFil) == Alltrim(cFilAnt)

		lSB2Ok := .T.
		while !U_GENA025V(_aItens)
			If !MsgYesNo("Existe uma pesagem em andamento no deposito que est· utilizando algumas das obras existentes no XML que vocÍ est· importando, ser· preciso aguardar o termino desta pesagem!"+chr(13)+chr(10)+;
						"Deseja tentar novamente?")
				lSB2Ok := .F.
				_cErro := "ImportaÁ„o cancelada pelo usu·rio devido a pesagem em andamento"
				//Envia Email de erro
				GN003(_cErro,'')
				Return						
			endIf
		EndDo
		
		If lSB2Ok
			//Chamada da funÁ„o
			_aRet	:= {}
			
			Processa({|| _aRet := U_GNCOM01B(_aCabDcOr, _aItens, _cTipImp, lVldOrig) },"Processando...","Aguarde.. importando nota fiscal!",.F.)
			
			If _aRet[1]
				MsgInfo("Nota importada:" + _cSerNota + "/" + _cNumNota  )
			Else
				GN003("Falha na importaÁ„o da nota.","")
			EndIf
		EndIf	
	Else
		_cErro := "Nota fiscal n„o pertence a esta empresa/filial. Utilize a filial: " + _cEmp + "/" + _cFil
		//Envia Email de erro
		GN003(_cErro,_cPath+_cFile)
		Return
	EndIf
EndIf

Static Function GN003(_cErro, _cArquivo)

Conout(_cErro)
_cTitulo := "ImportaÁ„o de XML de NFE"
MsgStop(_cErro,_cTitulo)

Return()

/*
FunÁ„o: GNCOM01B

DescriÁ„o: GravaÁ„o da nota fiscal de entrada.

ManutenÁıes:
25/06/2015 - Rafael Leite - CriaÁ„o do fonte
*/
User Function GNCOM01B(_aCabDcOr, _aItmDcOr, _cTipImp,_lNfIntegra)

Local cTempLocal	:= ""

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
//Private lAutoErrNoFile 	:= .T.

Default _lNfIntegra		:= .F.

ProcRegua(0)
IncProc()

_lRet := .T.
_cRet := ""
	
DbSelectArea("SC5")
DbSetOrder(1)

DbSelectArea("SA1")
DbSelectArea("SA2")

If Len(aLogTmp) > 0
	If _lNfIntegra
		xMagHelpFis("Integridade de nota fiscal","Foram identificados erros que impedem a inclus„o da nota fiscal!","A seguir ser· apresentado um log com os problemas encontratos!")	
		_lRet := .F.
	Else
		MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)
	EndIf
Else
	MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)	
EndIf

If lMsErroAuto
	_lRet := .F.
	_aErro := GetAutoGRLog()
	_cErro := MostraErro()
	Disarmtransaction()
Else
	If !Empty(aLogTmp)		
		cLogTemp:="Obras n„o processadas por falta de saldo"+Chr(13)+Chr(10)
		aEval(aLogTmp, {|x| cLogTemp+= x+Chr(13)+Chr(10) })		
		
		cTempLocal := cGetFile("Arquivo Texto|*.TXT|Todos os Arquivos|*.*", OemToAnsi("Selecione o local e nome para salvar o log."),0,"SERVIDOR",.F.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
		MemoWrite(cTempLocal,cLogTemp)		
	EndIf	
EndIf

Return({_lRet,_cRet})

//TELA PARA INFORMAR O C”DIGO DO PRODUTO DURANTE A IMPORTA«√O
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
	Alert("Informe um cÛdigo de produto.")
	Return(.F.)
Endif

//Pesquisa cÛdigo de produto
SB1->(DbSetOrder(1))
If SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cRetProd),TamSX3("B1_COD")[1])))
	_cDesProd := "Produto localizado: " + SB1->B1_DESC
	_oDlg:Refresh()
	Return(.T.)
Else
	//Pesquisa ISBN
	//SB1->(DbSetOrder(11))
	// cleuto lima - alterado pois este indice È proprietario totvs e deve ser tulizado nickname
	SB1->(DbOrderNickName("GENISBN"))	
	If SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(_cRetProd),TamSX3("B1_CODBAR")[1])))
		_cDesProd := "Produto localizado: " + SB1->B1_DESC
		_oDlg:Refresh()
		Return(.T.)
	Endif
Endif

Alert("Produto n„o encontrado.")

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
	
	Alert("Informe um cÛdigo de Classe de Valor.")
	
	Return .F.
Endif

//Pesquisa cÛdigo de produto
CTH->(DbSetOrder(1))
If CTH->(DbSeek(xFilial("CTH")+PadR(ALLTRIM(_cRetClas),TamSX3("CTH_CLVL")[1])))
	
	_cDesClas := "Classe localizada: " + CTH->CTH_DESC01
	_oDlg:Refresh()
	
	Return .T.
Endif

Alert("Classe n„o encontrada.")

Return .F.


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥GENA021   ∫Autor  ≥Microsiga           ∫ Data ≥  04/13/16   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function PadItemSD2(cAuxItm)

Local nItem		:= Val(cAuxItm)
Local nTamIt	:= TamSX3("D2_ITEM")[1]
Local nAux		:= 0
Local cItem		:= StrZero(0,nTamIt)

If Len(AllTrim(cAuxItm)) <= 2
	Return Padl(AllTrim(cAuxItm),nTamIt,"0")
EndIf

For nAux := 1 To nItem
	cItem := Soma1(cItem)
Next

Return cItem
