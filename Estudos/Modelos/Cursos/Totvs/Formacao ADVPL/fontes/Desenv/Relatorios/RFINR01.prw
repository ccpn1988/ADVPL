#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR01   ºAutor  ³ Microsiga          º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de Titulos em aberto contas a Receber            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINR01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao de variaveis                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := PadR ("RFINR01", Len (SX1->X1_GRUPO))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao e apresentacao das perguntas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
U_xGPutSx1(cPerg,"01","Filial de	  ? " ,'','',"mv_ch1","C",TamSx3 ("E1_FILIAL")[1]  ,0,,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"02","Filial ate	  ? " ,'','',"mv_ch2","C",TamSx3 ("E1_FILIAL")[1]  ,0,,"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"03","Emissão de	  ? " ,'','',"mv_ch3","D",TamSx3 ("E1_EMISSAO")[1] ,0,,"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"04","Emissao ate    ? " ,'','',"mv_ch4","D",TamSx3 ("E1_EMISSAO")[1] ,0,,"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"05","Vcto Real de   ? " ,'','',"mv_ch5","D",TamSx3 ("E1_VENCREA")[1] ,0,,"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"06","Vcto Real ate  ? " ,'','',"mv_ch6","D",TamSx3 ("E1_VENCREA")[1] ,0,,"G","","","","","mv_par06","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"07","Tipo			  ? " ,'','',"mv_ch7","C",TamSx3 ("E1_TIPO")[1]    ,0,,"G","U_MARCAR01()","","","","mv_par07","","","","","","","","","","","","","","","","")
U_xGPutSx1(cPerg,"08","Natureza  	  ? " ,'','',"mv_ch8","C",36 ,0,,"G","","","","","mv_par08","","","","","","","","","","","","","","","","")
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicoes/preparacao para impressao      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ReportDef()
oReport	:PrintDialog()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³ Vinícius Moreira   º Data ³ 21/10/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição da estrutura do relatório.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

oReport := TReport():New("RFINR01","Titulos a Receber",cPerg,{|oReport| PrintReport(oReport)},"Relação de Titulos a Receber com Saldo")
oReport:SetLandscape(.T.)

oSection1 := TRSection():New(oReport,"Titulos em Aberto","SE1")
//Celulas da secao
TRCell():New(oSection1,"E1_FILIAL"		,"","Filial"				,,04)
TRCell():New(oSection1,"E1_LOJA"		,"","Loja"					,,02)
TRCell():New(oSection1,"E1_TIPO"		,"","Tipo"					,,04)
TRCell():New(oSection1,"E1_CLIENTE"		,"","Cod Cli."				,,10)
TRCell():New(oSection1,"A1_NREDUZ"		,"","Razão Social"			,,20)
TRCell():New(oSection1,"A1_XTIPCLI"		,"","Tipo Cliente"			,,20)
TRCell():New(oSection1,"A1_NOME"		,"","Nome"			  		,,30)
TRCell():New(oSection1,"E1_NUM"			,"","Numero"	   			,,15)
TRCell():New(oSection1,"E1_PARCELA"		,"","Parcela"	   			,,5 )
TRCell():New(oSection1,"E1_NATUREZ"		,"","Natureza"				,,15)
TRCell():New(oSection1,"E1_EMISSAO"		,"","Emissao"				,,10)
TRCell():New(oSection1,"E1_VENCTO" 		,"","Vencimento"			,,10)
TRCell():New(oSection1,"E1_VENCREA"		,"","Vencimento Real"  		,,10)
TRCell():New(oSection1,"E1_VALOR"		,"","Vlr. Titulo"  			,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"E1_SALDO"		,"","Saldo"					,"@E 999,999,999.99",18,,,,,"RIGHT")
TRCell():New(oSection1,"A1_GRPVEN"		,"","Grupo de Vendas"		,,03)
//TRCell():New(oSection1,"E1_XOPERA"		,"","Operação"				,,03)
//TRCell():New(oSection1,"E1_XBANDEI"		,"","Bandeira"				,,15)
//TRCell():New(oSection1,"E1_DOCTEF"		,"","Nom NSU"				,,10)
TRCell():New(oSection1,"A1_XCANALV"		,"","Canal de Venda"		,,03)

//Totalizadores
TRFunction():New(oSection1:Cell("E1_SALDO" ),"Total Saldo"	 ,"SUM")
TRFunction():New(oSection1:Cell("E1_VALOR" ),"Total Geral"  ,"SUM")

//TRFunction():New(/*Cell*/             ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
//TRFunction():New(oSecCab:Cell("E1_SALDO"),/*cId*/,"SUM"     ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSecCab)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrintReport ºAutor  ³                    º Data ³           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrintReport(oReport)

Local cQuery     := ""
Local _cAlias    := GetNextAlias()
Local oSection1 := oReport:Section(1)

Pergunte(cPerg,.F.)

cQuery += " SELECT
cQuery += " A.E1_FILIAL,
cQuery += " A.E1_LOJA,
cQuery += " A.E1_TIPO,
cQuery += " A.E1_CLIENTE,
cQuery += " B.A1_NREDUZ,
cQuery += " B.A1_NOME,
cQuery += " B.A1_XTIPCLI,
cQuery += " A.E1_NUM,
cQuery += " A.E1_TIPO,
cQuery += " A.E1_NATUREZ,
cQuery += " A.E1_EMISSAO,
cQuery += " A.E1_PARCELA,
cQuery += " A.E1_VENCTO,
cQuery += " A.E1_VENCREA,
//cQuery += " A.E1_VALOR,
//cQuery += " A.E1_SALDO,
cQuery += " CASE WHEN E1_TIPO IN ('NCC' , 'RA ') THEN E1_VALOR *(-1) ELSE E1_VALOR END E1_VALOR,"
cQuery += " CASE WHEN E1_TIPO IN ('NCC' , 'RA ') THEN E1_SALDO *(-1) ELSE E1_SALDO END E1_SALDO,"
cQuery += " B.A1_GRPVEN,
//cQuery += " A.E1_XOPERA,
//cQuery += " A.E1_XBANDEI,
//cQuery += " A.E1_DOCTEF,
cQuery += " B.A1_XCANALV FROM "+RETSQLNAME("SE1")+" A
cQuery += " JOIN "+RETSQLNAME("SA1")+" B
cQuery += "     ON A.E1_CLIENTE = B.A1_COD
cQuery += "     AND A.E1_LOJA = B.A1_LOJA
cQuery += "     AND B.D_E_L_E_T_ = ' '
cQuery += " WHERE E1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'
cQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'
cQuery += " AND E1_NATUREZ NOT IN "+ FormatIN(MV_PAR08,";")
//cQuery += " AND E1_TIPO IN ('"++"')
cQuery += " AND E1_SALDO > 0
cQuery += " AND A.D_E_L_E_T_ = ' '
cQuery := ChangeQuery(cQuery)

If Select(_cAlias) > 0
	dbSelectArea(_cAlias)
	dbCloseArea()
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), _cAlias, .F., .T.)

Do While !(_cAlias)->(eof()) .And. !oReport:Cancel()
	oReport:IncMeter()
	
	oSection1:Init()
	
	oSection1:Cell("E1_FILIAL" ):SetValue((_cAlias)->E1_FILIAL	)
	oSection1:Cell("E1_LOJA"   ):SetValue((_cAlias)->E1_LOJA	)
	oSection1:Cell("E1_TIPO"   ):SetValue((_cAlias)->E1_TIPO	)
	oSection1:Cell("E1_CLIENTE"):SetValue((_cAlias)->E1_CLIENTE)
	oSection1:Cell("A1_NREDUZ" ):SetValue((_cAlias)->A1_NREDUZ	)
	oSection1:Cell("A1_NOME"   ):SetValue((_cAlias)->A1_NOME	)
	oSection1:Cell("E1_NUM"    ):SetValue((_cAlias)->E1_NUM	)
	oSection1:Cell("E1_NATUREZ"):SetValue((_cAlias)->E1_NATUREZ)
	oSection1:Cell("E1_EMISSAO"):SetValue(STOD((_cAlias)->E1_EMISSAO))
	oSection1:Cell("E1_VENCTO" ):SetValue(STOD((_cAlias)->E1_VENCTO ))
	oSection1:Cell("E1_VENCREA"):SetValue(STOD((_cAlias)->E1_VENCREA))
	oSection1:Cell("E1_VALOR"  ):SetValue((_cAlias)->E1_VALOR  )
	oSection1:Cell("E1_SALDO"  ):SetValue((_cAlias)->E1_SALDO  )
	oSection1:Cell("A1_GRPVEN" ):SetValue((_cAlias)->A1_GRPVEN )
	//oSection1:Cell("E1_XOPERA" ):SetValue((_cAlias)->E1_XOPERA )
	//oSection1:Cell("E1_XBANDEI"):SetValue((_cAlias)->E1_XBANDEI)
	//oSection1:Cell("E1_DOCTEF" ):SetValue((_cAlias)->E1_DOCTEF )
	oSection1:Cell("E1_PARCELA" ):SetValue((_cAlias)->E1_PARCELA )
	oSection1:Cell("A1_XCANALV"):SetValue((_cAlias)->A1_XCANALV)
	oSection1:Cell("A1_XTIPCLI"):SetValue((_cAlias)->A1_XTIPCLI)
	
	oSection1:PrintLine()
	
	(_cAlias)->(dbSkip())
EndDo

DbSelectArea(_cAlias)
DbCloseArea()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMR01   ºAutor  ³Microsiga           º Data ³  07/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MARCAR01()

Local _lRetorno 	:= .F. //Validacao da dialog criada oDlg
Local _nOpca 		:= 0 //Opcao da confirmacao
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel 		:= {|| _nOpca:=0,oDlg:End() } //botao de cancelamento
Local _cArqEmp 		:= "" //Arquivo temporario com as empresas a serem escolhidas
Local _aStruTrb 	:= {} //estrutura do temporario
Local _aBrowse 		:= {} //array do browse para demonstracao das empresas
Local cCodNats 		:= ""
Private lInverte 	:= .F. //Variaveis para o MsSelect
Private cMarca 		:= GetMark() //Variaveis para o MsSelect
Private oBrwTrb //objeto do msselect
Private oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿

//³ Define campos do TRB ³

//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(_aStruTrb,{"X5CHAVE" ,"C",15,0})
aadd(_aStruTrb,{"X5DESCRI" ,"C",20,0})
aadd(_aStruTrb,{"OK" ,"C",02,0})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define campos do MsSelect 							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aadd(_aBrowse,{"OK" ,,"" })
aadd(_aBrowse,{"X5CHAVE",,"Un. Negócio" })
aadd(_aBrowse,{"X5DESCRI",,"Descrição" })

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

//_cArqEmp := CriaTrab(_aStruTrb)
//dbUseArea(.T.,__LocalDriver,_cArqEmp,"TRB")

_oTRB	:= FWTemporaryTable():New("TRB")
_oTRB:SetFields( _aStruTrb ) // seta os campos que serão utilizados na tabela temporária
_oTRB:Create() // Cria a tabela temporária


//Aqui você monta sua query que serve para gravar os dados no arquivo temporario...

cQuery := " SELECT X5_CHAVE X5CHAVE, X5_DESCRI X5DESCRI " 
cQuery += "   FROM " + RetSqlTab("SX5") + " (NOLOCK) "
cQuery += "  WHERE SX5.X5_TABELA = '05' "
cQuery += " AND SX5.D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)

//TCQuery cQuery new Alias (cAlias:=GetNextAlias())admin
TCQuery (cQuery) New Alias (cAlias:=GetNextAlias())
 
While (cAlias)->(!Eof())
 
	RecLock("TRB",.T.)
 
	TRB->OK := space(2)
 	TRB->X5CHAVE 	:= (cAlias)->X5CHAVE
 	TRB->X5DESCRI 	:= (cAlias)->X5DESCRI

	MsUnlock()
 
(cAlias)->(DbSkip())
 
Enddo
 
(cAlias)->(DbCloseArea())
 
@ 001,001 TO 400,700 DIALOG oDlg TITLE OemToAnsi("Tipo de Titulos")
@ 015,005 SAY OemToAnsi("Defina quais tipos deseja ")
oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{025,001,170,350})
oBrwTrb:oBrowse:lCanAllmark := .T.
Eval(oBrwTrb:oBrowse:bGoTop)
oBrwTrb:oBrowse:Refresh()
 
Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,)) Centered VALID _lRetorno
 
TRB->(DbGotop())
 
If _nOpca == 1
	
	Do While TRB->(!Eof())
		
		If !Empty(TRB->OK)//se usuario marcou o registro
			cCodNats += Alltrim(TRB->X5CHAVE)+";"
		EndIf
		
		TRB->(DbSkip())
		
	EndDo
	
Endif

//fecha area de trabalho e arquivo temporário criados

If Select("TRB") > 0
	
	DbSelectArea("TRB")
	
	DbCloseArea()
	
	Ferase(_cArqEmp+OrdBagExt())
	
Endif

If IsInCallStack("U_RFINR01") 
	MV_PAR07 := cCodNats
Endif

Return(.T.)
