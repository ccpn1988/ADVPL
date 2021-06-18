#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt Chr(13)+Chr(10)   

/*
ZA_STATUS = ' ' -> NAO PROCESSADO AINDA
ZA_STATUS = '1' -> PROCESSADO COM SUCESSO
ZA_STATUS = '2' -> SALDO INSUFICIENTE
ZA_STATUS = '3' -> SALDO INSUFICIENTE - FOI GERADO COPIA
ZA_STATUS = '4' -> NAO TEM SALDO
ZA_STATUS = '5' -> PRODUTO BLOQUEADO
ZA_STATUS = '6' -> ERRO QUERY PESQUISA SB6 
ZA_STATUS = '7' -> SALDO SB6 NÃO IDENTIFICADO NA ORIGEM
*/                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA011   ºAutor  ³Angelo Henrique     º Data ³  29/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de prestação de contas do processo de consignação    º±±
±±º          ³que foi realizado manualmente.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para chamar rotina   ³
//³principal e processar Oferta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function GENA011T() //VENDA + OFERTA

Private _cPrTipo := Space(1)
Private _cPrEmp  := Space(3)
Private _cPrData := Space(8)  
Private _cTpOfer := Space(1)

	DEFINE MSDIALOG oDlg TITLE "Prestação de Contas" FROM 000,000 TO 200,300 PIXEL
	
	@ 010,010 SAY "Tipo" SIZE 55,07 OF oDlg PIXEL
	@ 010,050 MSGET _cPrTipo SIZE 55,11 OF oDlg PIXEL PICTURE "@!" 
	@ 030,010 SAY "Empresa" SIZE 55,07 OF oDlg PIXEL
	@ 030,050 MSGET _cPrEmp SIZE 55,11 OF oDlg PIXEL PICTURE "@!" 
	@ 050,010 SAY "Data" SIZE 55,07 OF oDlg PIXEL
	@ 050,050 MSGET _cPrData SIZE 55,11 OF oDlg PIXEL PICTURE "@!" 

	@ 070,010 SAY "Tipo Oferta" SIZE 55,07 OF oDlg PIXEL
	@ 070,050 MSGET _cTpOfer SIZE 55,11 OF oDlg PIXEL PICTURE "@!"
		
	DEFINE SBUTTON FROM 010, 120 TYPE 1 ACTION (U_GENA011N({_cPrTipo,_cPrEmp,_cPrData}),oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 030, 120 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg
	                                             
	ACTIVATE MSDIALOG oDlg CENTERED             
	
Return

User Function GENA011N(_aTela) //VENDA + OFERTA

If _aTela[1] == "O"
	_cPrTipo := "1"
	
	If Empty(_cTpOfer) .OR. !(_cTpOfer $ "12")
		MsgStop("Tipo de oferta não informado ou invalido!")
		Return .F.
	EndIf
	
Else
	_cPrTipo	:= "2"
	_cTpOfer	:= " "
Endif

If _aTela[2] == "EGK"
	_cFornece := "0380795" 
	_cLojafor := "01"

ElseIf _aTela[2] == "ACF"
	_cFornece := "031811 "
	_cLojafor := "02" 

ElseIf _aTela[2] == "LTC"
	_cFornece := "0380796"
	_cLojafor := "01"

ElseIf _aTela[2] == "FOR"
	_cFornece := "0380794"
	_cLojafor := "01"

ElseIf _aTela[2] == "ATL"
	_cFornece := "0378128"
	_cLojafor := "07"
	
Endif

_dRef := StoD(_aTela[3])

U_GENA011({_cPrTipo,_cFornece,_cLojafor,_dRef,_cTpOfer})

Return                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para chamar rotina   ³
//³principal e processar Oferta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*User Function GENA011O() //OFERTA

conout(Time()+ " " + "GENA011 - OFERTA")

U_GENA011({"1"})

Return()*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para chamar rotina   ³
//³principal e processar Venda ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*User Function GENA011V() //VENDA

conout(Time()+ " " + "GENA011 - VENDA")

U_GENA011({"2"})

Return()*/


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para chamar rotina   ³
//³principal e processar Venda ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function GENA011U()

Prepare Environment Empresa "00" Filial "1022"
tcsqlexec("UPDATE "+RetSqlName("SB2")+" SET B2_QTNP = 0 WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '01' AND D_E_L_E_T_ = ' '")
Reset Environment

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina Principal - Executada via schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Par01 - Tipo - 1=Oferta; 2=Venda
// Par02 - Fornecedor
// Par03 - Loja
// Par04 - Data
// Par05 - Saldo - P=Somente positivo; N=Somente negativo
User Function GENA011(_aParam1) //CHAMADA VIA SCHEDULE PASSANDO PARAMETROS 1 (OFERTA) OU 2 (VENDA)

Private _cParam1		:= _aParam1[1] 
Private cFornInter	:= _aParam1[2] 
Private cLojaInter	:= _aParam1[3] 
Private dProcInter	:= _aParam1[4] 
Private cTipoOfert	:= _aParam1[5]
Private cRetInter	:= ""

conout(Time()+ " " + "GENA011 - Inicio - Rotina de Geração do Processo de Prestacao de Contas")

Prepare Environment Empresa "00" Filial "1022"

If upper(alltrim(GetEnvServer())) $ "SCHEDULE" //EXECUTA SOMENTE NO AMBIENTE SCHEDULE
	dDataBase := dProcInter

	cRetInter := "P"
               
	conout(Time()+ " " + "GENA011 - Tipo: " + IIF( _cParam1 == "1" , "Oferta" , "Venda" ) )
	conout(Time()+ " " + "GENA011 - Fornecedor: " + cFornInter )
	conout(Time()+ " " + "GENA011 - Loja: " + cLojaInter )
	conout(Time()+ " " + "GENA011 - Data: " + DtoS(dProcInter) )
	conout(Time()+ " " + "GENA011 - Opcao: " + cRetInter )
	conout(Time()+ " " + "GENA011 - Tp.Oferta: " + cTipoOfert )
	
	U_GENA011A(_cParam1)
	
	If _cParam1 == "2"
		cRetInter := "N"
	
		conout(Time()+ " " + "GENA011 - Tipo: " + IIF( _cParam1 == "1" , "Oferta" , "Venda" ) )
		conout(Time()+ " " + "GENA011 - Fornecedor: " + cFornInter )
		conout(Time()+ " " + "GENA011 - Loja: " + cLojaInter )
		conout(Time()+ " " + "GENA011 - Data: " + DtoS(dProcInter) )
		conout(Time()+ " " + "GENA011 - Opcao: " + cRetInter )
		conout(Time()+ " " + "GENA011 - Tp.Oferta: " + IIF( cTipoOfert == "1" , "CRM" , "DA" ) )
			
		U_GENA011A(_cParam1)
	Endif
Endif

conout(Time()+ " " + "GENA011 - Fim - Rotina de Geração do Processo de Prestacao de Contas")
Reset Environment

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA011A   ºAutor  ³Angelo Henrique     º Data ³  29/08/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por fazer o filtro das Notas de Entradas º±±
±±º          ³corretas para realizar o processo de prestação de contas.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA011A(_cParam1)

Local _aArea 	:= GetArea()
Local _cQuery 	:= ""
Local _cAliQry	:= GetNextAlias()
Local _cEmpCd 	:= ""
Local _cEmpFl 	:= ""
Local _cForn 	:= ""
Local _cLojFn  	:= ""
Local _cAliQry1	:= GetNextAlias()
Local _cAliQry2	:= GetNextAlias()
Local _cAliQry3	:= GetNextAlias()
Local _cAliQry4	:= GetNextAlias()
Local _cAliQry5	:= GetNextAlias()
Local _cAliQryX	:= GetNextAlias()
Local _aDir		:= {}
Local _aCabDcEn := {} //Vetor contendo o cabeçalho documento de entrada empresa Matriz
Local _alinhaDe := {} //Vetor que recebe os itens do documento de entrada empresa Matriz
Local _aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
Local _aCabDcOr := {} //Vetor contendo o cabeça'lho documento de entrada empresa Origem
Local _alinhaOr := {} //Vetor que recebe os itens do documento de entrada empresa Origem
Local _aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
Local _nQuant	:= 0
Local _aCabPd 	:= {} //Geração do cabeçalho Pedido de Vendas na empresa Origem
Local _alinha	:= {} //Geração do Item do Pedido de Vendas na empresa Origem
Local _aItmPd	:= {} //Recebe os itens do pedido de Vendas na empresa Origem
Local _aCabPv	:= {} //Geração do cabeçalho Pedido de Vendas na empresa Matriz
Local _aLinPd	:= {} //Geração do Item do Pedido de Vendas na empresa Matriz
Local _aItmPv	:= {} //Recebe os itens do pedido de Vendas na empresa Matriz
Local _cCliPv 	:= ""
Local _cLjPv  	:= ""
Local _cCliGen 	:= ""
Local _cLojGen 	:= ""
Local _cTrpGen 	:= ""
Local _cTipGen 	:= ""
Local _cVenGen 	:= ""
Local _cTrpPv	:= ""
Local _cTipPv 	:= ""
Local _cVenPv 	:= ""
Local _lOkNe	:= .T.
Local _dDtAco	:= CTOD(" \ \ ")
Local _cMsg		:= ""
Local _nDesc	:= 0
Local _nContOr	:= 0
Local _cContC6	:= 0
Local _nPrcVn	:= 0
Local _nQtdTot  := 0
Local _nValTot 	:= 0
Local _cNotaImp	:= ""
Local _oServer 	:= Nil
Local _cCGCOr	:= ""
Local _aArM0	:= {}
Local _lEmp		:= .T.
Local _lNegat   := .F.
Local _nQdTtOr  := 0
Local _nVlTtOr  := 0
Local _cNtDvCon	:= ""
Local _cQryTes  := ""
Local _cAliTes	:= GetNextAlias()
Local _cTesPr	:= ""
Local _cEmp		:= AllTrim(SM0->M0_CODIGO)
Local _cFil		:= AllTrim(SM0->M0_CODFIL)
Local _aSldB6	:= {}
Local _nQtdB6	:= 0
Local _nQtdSld	:= 0
Local _lVcDesc  := .F.
Local _cForUp 	:= ""
Local _cLojUp 	:= ""

Local _cTesEn	:= GetMv("GEN_FAT008") //Contém o TES utilizado na nota de entrada das empresas Matriz - Oferta
Local _cTesCrmDv	:= GetMv("GEN_FAT012") //Contém o TES utilizado no Pedido de Vendas das empresas Origem - Oferta CRM
Local _cTesDaDv	:= GetMv("GEN_FAT204") //Contém o TES utilizado no Pedido de Vendas das empresas Origem - Oferta DA
Local _cMvCdPv 	:= GetMv("GEN_FAT200") //Condição de pagamento pedido de venda empresa Matriz
Local _cMvCdOr 	:= GetMv("GEN_FAT201") //Condição de pagamento pedido de venda empresa Origem
Local _cMvTbPr 	:= GetMv("GEN_FAT015") //Contém a tabela de preço usado no pedido de vendas na empresa Matriz e Origem
Local _cLogPd		:= GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro
Local _cMvClDe	:= GetMv("GEN_FAT017") //Contém o cliente que será utilizado para realizar as movimentações na empresa Matriz
Local _cMvLjDe  	:= GetMv("GEN_FAT018") //Contém a Loja que será utilizado as movimentações na empresa Matriz
Local _cFil		:= GetMv("GEN_FAT019") //Contém a Filial correta da empresa GEN que será realizado as movimentações de consignação
Local _cMvEspc 	:= GetMv("GEN_FAT020") //Contém a especie utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvCdDe	:= GetMv("GEN_FAT202") //Contém a condição de pagamento utilizada na nota de entrada das empresas Matriz e Origem
Local _cMvTsPd	:= GetMv("GEN_FAT022") //Contém o TES utilizado no Pedido de Vendas das empresas Matriz, consignação (positivo)
Local _cMvTsPv	:= GetMv("GEN_FAT023") //Contém o TES utilizado no Pedido de Vendas das empresas Origem - Venda
Local _cMvTsDe	:= GetMv("GEN_FAT024") //Contém o TES utilizado na nota de entrada das empresas Matriz - Venda
Local _cMvTsOr	:= GetMv("GEN_FAT025") //Contém o TES utilizado na nota de entrada das empresas Origem, consignação (positivo) - Vendas
Local _cMvSeri 	:= GetMv("GEN_FAT087") //SERIE nota de saída de entrada nas empresas Matrz e Origem
Local _cServ 		:= GETMV("GEN_FAT027") //Contém o Ip do servidor para realizar as mudanças de ambiente
Local _nPort  	:= GETMV("GEN_FAT028") //Contém a porta para realizar as mudanças de ambiente
Local _cAmb  		:= GETMV("GEN_FAT029") //Contém o ambiente a ser utilizado para realizar as mudanças de filial
Local _cMvTsPdV 	:= GETMV("GEN_FAT042") //Contém o TES utilizado no Pedido de Vendas das empresas Matriz, devolução (negativo) - Vendas
Local _cMvTsOrV 	:= GETMV("GEN_FAT043") //Contém o TES utilizado na nota de entrada das empresas Origem, consignação (negativo)- Vendas
Local _cMvTsOf	:= GetMv("GEN_FAT053") //Contém o TES utilizado no Pedido de Vendas das empresas Matriz, consignação (positivo) - Oferta
Local _cMvTsPOf 	:= GETMV("GEN_FAT054") //Contém o TES utilizado no Pedido de Vendas das empresas Matriz, devolução (negativo) - Oferta
Local _cMvTsOrF	:= GetMv("GEN_FAT055") //Contém o TES utilizado na nota de entrada das empresas Origem, consignação (positivo) - Oferta
Local _cMvTsNoF 	:= GETMV("GEN_FAT056") //Contém o TES utilizado na nota de entrada das empresas Origem, consignação (negativo)- Oferta
Local cNatOriGen	:= GETMV("GEN_FAT175") //Natureza do pedido de vendas da origem para o gen
Local cNatGenOri	:= GETMV("GEN_FAT176") //Natureza do pedido de vendas do Gen para Origem 
Local cNatGenDev	:= GETMV("GEN_FAT181") //Natureza do pedido de vendas do Gen para Origem de devolução

Local aJaUsoSB6	:= {}
//Lote de execucao da rotina
Local _cUpLote := ""

Local cD2_IDENTB6	:= ""
Local cItemOri		:= ""
Local lSaldoOrigem	:= .T.

Local cInIDTPPU		:= SuperGetMv("GEN_FAT125",.f.,"11#14#15#16#17#19#8#9")
Local aInIDTPPU		:= Separa(cInIDTPPU,"#")
Local cFAST115		:= SuperGetMv("GEN_FAT115",.f.,90)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executar limpeza dos logs³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//_aDir := directory(Alltrim(_cLogPd)+"*")
//For _ni:= 1 to Len(_aDir)
//	fErase(Alltrim(_cLogPd)+_aDir[_ni][1])
//Next _ni

conout(Time()+ " " + "GENA011A - Inicio - Verificando Itens da Nota de Entrada")

tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_DESC = REPLACE(B1_DESC,'|','/')") //TROCA "|" POR "/" NA DESCRICAO DOS PRODUTOS PARA NAO GERAR ERRO NA ROTINA GRAVAARQ/LEARQ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd¿
//³Pegando Informações da GEN através dos parametros para ser utilizado no pedido de vendas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄdÙ
DbSelectArea("SA1")
DbSetORder(1)
If DbSeek(xFilial("SA1")+PADR(AllTrim(_cMvClDe),TAMSX3("A1_COD")[1])+PADR(AllTrim(_cMvLjDe),TAMSX3("A1_LOJA")[1]))
	
	_cCliGen := SA1->A1_COD
	_cLojGen := SA1->A1_LOJA
	_cTrpGen := SA1->A1_TRANSP
	_cTipGen := SA1->A1_TIPO
	_cVenGen := SA1->A1_VEND
	
	DbSelectArea("SA2")
	DbSetOrder(3)
	If DbSeek(xFilial("SA2")+SA1->A1_CGC)
		
		_cFnGen := SA2->A2_COD
		_cLjGen := SA2->A2_LOJA
		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query para pegar os TES que serão utilizados no processo de consignação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cQryTes := " SELECT F4_CODIGO, F4_XPRCONT, F4_XTPCONT
		_cQryTes += " FROM " + RetSqlName("SF4") + " SF4
		_cQryTes += " WHERE F4_XPRCONT = 'S'
		_cQryTes += " AND F4_XTPCONT = '" + _cParam1 + "'
		_cQryTes += " AND D_E_L_E_T_ = ' '
		
		If Select(_cAliTes) > 0
			dbSelectArea(_cAliTes)
			(_cAliTes)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQryTes), _cAliTes, .F., .T.)
		_cTesPr := "" //Limpando a variavel
		
		While (_cAliTes)->(!EOF())
			_cTesPr += (_cAliTes)->F4_CODIGO + "','"
			(_cAliTes)->(DbSkip())
		EndDo
		
		If Select(_cAliTes) > 0
			dbSelectArea(_cAliTes)
			(_cAliTes)->(dbCloseArea())
		EndIf
		
		_cTesPr := Substr(_cTesPr,1,Len(_cTesPr)-3)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Query irá varrer os itens das notas de entradas para realizar toda a movimentação nas empresas correspondentes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		_cQuery := "SELECT * FROM (
		_cQuery += " SELECT DISTINCT SB1.B1_COD, SB1.B1_PROC, SB1.B1_LOJPROC, SB1.B1_DESC, SB1.B1_UM, SB1.B1_LOCPAD, SB1.B1_MSBLQL,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD2PR.D2_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD2") + " SD2PR
		_cQuery += "     WHERE SD2PR.D2_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD2PR.D2_COD     = SB1.B1_COD
		_cQuery += "     AND SD2PR.D2_FILIAL  = '" + _cFil + "'
		_cQuery += " 	 AND SD2PR.D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
		_cQuery += "     AND SD2PR.D2_XCONSIG = ' '
		_cQuery += "     AND SD2PR.D_E_L_E_T_ = ' '
		//_cQuery += " 	 AND SD2PR.D2_EMISSAO BETWEEN '20150100' AND '20150105'
		_cQuery += " ) AS VALOR_ORI,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD1SE.D1_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD1") + " SD1SE
		_cQuery += "     WHERE SD1SE.D1_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD1SE.D1_COD     = SB1.B1_COD
		_cQuery += "     AND SD1SE.D1_FILIAL  = '" + _cFil + "'
		_cQuery += " 	 AND SD1SE.D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
		_cQuery += "     AND SD1SE.D1_XCONSIG = ' '
		_cQuery += "     AND SD1SE.D_E_L_E_T_ = ' '
		//_cQuery += " 	 AND SD1SE.D1_EMISSAO BETWEEN '20150100' AND '20150105'
		_cQuery += " ) AS VALOR_DEV,
		_cQuery += " (
		_cQuery += "     SELECT NVL(SUM(SD2CA.D2_QUANT),0)
		_cQuery += "     FROM " + RetSqlName("SD2") + " SD2CA
		_cQuery += "     WHERE SD2CA.D2_COD     = SB1.B1_COD
		_cQuery += "     AND SD2CA.D2_TES   IN ('" + _cTesPr + "')
		_cQuery += "     AND SD2CA.D2_FILIAL  = '" + _cFil + "'
		_cQuery += "     AND SD2CA.D_E_L_E_T_ = '*'
		_cQuery += "     AND SD2CA.D2_XCONSIG = 'S'
		_cQuery += " ) AS VALOR_CAN
		_cQuery += " FROM " + RetSqlName("SB1") + " SB1
		_cQuery += " INNER JOIN " + RetSqlName("SZ4") + " SZ4 ON SB1.B1_XSITOBR = SZ4.Z4_COD
		_cQuery += " 	 AND SZ4.Z4_MSBLQL = '2'
		_cQuery += " 	 AND SZ4.Z4_FILIAL = '" + xFilial("SZ4") + "'
		_cQuery += " 	 AND SZ4.D_E_L_E_T_ = ' '
		_cQuery += " WHERE SB1.B1_FILIAL = '" + xFilial("SB1") + "'
		_cQuery += " AND SB1.D_E_L_E_T_ = ' '
		_cQuery += " AND SB1.B1_ISBN <> ' '
		
		//ATENCAO DEIXAR SEM COMENTARIO SOMENTE UMA EMPRESA. FOI ESCRITO DESSA FORMA PARA FACILITAR A MANUTENCAO.
		//AC
		//_cQuery += " AND SB1.B1_PROC = '031811'
		//_cQuery += " AND SB1.B1_LOJPROC = '02'
		
		//LTC
		//_cQuery += " AND SB1.B1_PROC = '0380796'
		//_cQuery += " AND SB1.B1_LOJPROC = '01'
		  
		//FORENSE
		//_cQuery += " AND SB1.B1_PROC = '0380794'
		//_cQuery += " AND SB1.B1_LOJPROC = '01'
		
		//EGK
		_cQuery += " AND SB1.B1_PROC = '0380795'
		_cQuery += " AND SB1.B1_LOJPROC = '01'
		
		//_cQuery += " AND SB1.B1_COD IN ('00004180                      ','00004289                      ','00004522                      ')
		_cQuery += " )
		_cQuery += " where VALOR_ORI <> 0 OR VALOR_DEV <> 0 OR VALOR_CAN <> 0
		_cQuery += " ORDER BY B1_PROC, B1_LOJPROC
        */
//--------------------------------------------------------------------------------------------------------------------------		
//AJUSTE PRESTACAO DE CONTAS - OBRAS PENDENTES
//--------------------------------------------------------------------------------------------------------------------------		
/*
_cQuery := " SELECT PRO_COD B1_COD  
_cQuery += " ,ORI_COD B1_PROC
_cQuery += " ,ORI_LOJ B1_LOJPROC
_cQuery += " ,PRO_DES B1_DESC
_cQuery += " ,B1_UM
_cQuery += " ,B1_LOCPAD
_cQuery += " ,B1_MSBLQL
_cQuery += " ,VALOR_ORI_VND VALOR_ORI
_cQuery += " ,VALOR_DEV_VND VALOR_DEV
_cQuery += " ,VALOR_CAN_VND VALOR_CAN
_cQuery += " ,(VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) SALDO
_cQuery += " FROM TT_T31_PRESTACAO_CONFERENCIA
_cQuery += " WHERE EMPRESA = 'EGK'
_cQuery += " AND DAT_REF = '20150430'
_cQuery += " AND STATUS LIKE '%OFERTA%'
_cQuery += " AND PRO_COD <> '00114114                      '
_cQuery += " AND PRO_COD <> '01813123                      '
_cQuery += " AND (VALOR_ORI_VND-VALOR_DEV_VND-VALOR_CAN_VND) > 0
_cQuery += " ORDER BY SALDO DESC
*/		
		ZZ8->(DbSetOrder(1))
		If !ZZ8->( Dbseek( xFilial("ZZ8") + _cParam1 + DtoS(dProcInter) ) ) 
			_cMsg := "Auditoria de saldos não localizada para o periodo "+DtoC(dProcInter)
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Auditoria de saldos.txt" , _cMsg )
			Return nil
		EndIf
        
		//19/06/2015 - Rafael Leite - Consulta dados da SZA.
		_cQuery := " SELECT ZA_COD B1_COD  
		_cQuery += " ,ZA_PROC B1_PROC
		_cQuery += " ,ZA_LOJPROC B1_LOJPROC
		_cQuery += " ,ZA_DESC B1_DESC
		_cQuery += " ,ZA_UM B1_UM
		_cQuery += " ,ZA_LOCPAD B1_LOCPAD
		_cQuery += " ,ZA_MSBLQL B1_MSBLQL
		_cQuery += " ,ZA_VALORI VALOR_ORI
		_cQuery += " ,ZA_VALDEV VALOR_DEV
		_cQuery += " ,ZA_VALCAN VALOR_CAN
		_cQuery += " ,ZA_SALDO SALDO
		_cQuery += " ,ZA_VALUNI VALOR_UNI
		_cQuery += " ,B1_XIDTPPU
		_cQuery += " FROM " + RetSQLName("SZA") + " SZA
		
		_cQuery += " JOIN " + RetSQLName("SB1") + " SB1
		_cQuery += " ON B1_FILIAL = '"+xFilial("SB1")+"'
		_cQuery += " AND B1_COD = ZA_COD
		_cQuery += " AND SB1.D_E_L_E_T_ <> '*'
		
		_cQuery += " WHERE SZA.ZA_FILIAL  = '"+xFilial("SZA")+"' 
		_cQuery += " AND SZA.ZA_REF = '"+DtoS(dProcInter)+"'
		_cQuery += " AND SZA.ZA_PROC = '"+cFornInter+"'
		_cQuery += " AND SZA.ZA_LOJPROC = '"+cLojaInter+"'
		_cQuery += " AND SZA.ZA_TIPO = '"+_cParam1+"'
		_cQuery += " AND SZA.ZA_TPOFER = '"+cTipoOfert+"'
		_cQuery += " AND SZA.ZA_STATUS = ' '
		_cQuery += " AND SZA.D_E_L_E_T_ = ' '
		
		If cRetInter == "P"
			_cQuery += " AND SZA.ZA_SALDO > 0
		Else
			_cQuery += " AND SZA.ZA_SALDO < 0
		Endif
		
		//_cQuery += " ORDER BY ZA_SALDO DESC	  		
		_cQuery += " 
		  
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " consulta.txt" , _cQuery )
					
		If Select(_cAliQry) > 0
			dbSelectArea(_cAliQry)
			(_cAliQry)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry, .F., .T.)
		
		cProx074	:=	GETMV("GEN_FAT074")
		
		While (_cAliQry)->(!EOF())  
		    
			//Lote de execução
			_cUpLote	:= Soma1(cProx074)  
			PutMV("GEN_FAT074",_cUpLote)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄä¿
			//³Ponterando no Fornecedor para realizar a busca na SM0 (Cadastro de Empresas), realizando assim   ³
			//³uma nova conexão na empresa em que será gerado a Nota de entrada e Pedido de Vendas/Nota de Saída³
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄä¿
			DbSelectArea("SA2")
			DbSetOrder(1)
			If DbSeek(xFilial("SA2")+(_cAliQry)->B1_PROC+(_cAliQry)->B1_LOJPROC)
				
				_cForn 	:= AllTrim(SA2->A2_COD)
				_cLojFn := AllTrim(SA2->A2_LOJA)
				_cCGCOr := AllTrim(SA2->A2_CGC)
				
				DbSelectArea("SA1")
				DbSetOrder(3)
				If DbSeek(xFilial("SA1")+_cCGCOr)
					
					_cCliPv 	:= SA1->A1_COD
					_cLjPv  	:= SA1->A1_LOJA
					_cTrpPv	:= SA1->A1_TRANSP
					_cTipPv 	:= SA1->A1_TIPO
					_cVenPv 	:= SA1->A1_VEND
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ponterando na SM0 para pegar o CNPJ correto e realzar o ponteramento ³
					//³na empresa quer será gravado a Nota                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_aArM0 := SM0->(GetArea())
					DbSelectArea("SM0")
					SM0->(DbGoTop())
					While SM0->(!EOF())
						If AllTrim(SM0->M0_CGC) == AllTrim(SA2->A2_CGC)
							_lEmp := .T.
							_cEmpCd := SM0->M0_CODIGO
							_cEmpFl := SM0->M0_CODFIL
							Exit
						Else
							_lEmp := .F.
						EndIf
						SM0->(DbSkip())
					EndDo
					
					//IF _cFornece == "0378128"
					IF _cFornece == "AAA"
						_lEmp := .T.	
					Endif           
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Sequência considerada no levantamento, listada abaixo para compreensão:			           ³
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³- Pesquisa tabela de preço;                                                                 ³
					//³- Verifica vigência da tabela;                                                              ³
					//³- Pesquisa produto na tabela de preço;                                                      ³
					//³- pesquisa regra para cliente;                                                              ³
					//³- pesquisa regra de desconto para grupo de cliente;                                         ³
					//³- Pesquisa regra de desconto sem cliente Pesquisa regra de desconto grupo de cliente;       ³
					//³- Verifica vigência da regra de desconto;                                                   ³
					//³- Pesquisa produto dentro da regra de desconto.                                             ³
					//³- Se encontrar o produto, pega o desconto; Se não pega o desconto do cabeçalho da tabela.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se achar a empresa correta realiza a movimentação³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If _lEmp
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ®A¿
						//³Pegando o produto na tabela de preço	  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ®AÙ
						DbSelectArea("DA0")
						DbSetOrder(1)
						If DbSeek(xFilial("DA0")+_cMvTbPr)
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ›„›„¿
							//³Validando se a tabela de preço esta vigente³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ›„›„Ù
							If DA0->DA0_DATATE >= dDatabase .OR. Empty(DA0->DA0_DATATE)
								
								_aCabPv := {}
								
								//Tipo de documento, dependendo da operação
								If cRetInter == "P"
									_cTipo1 := "B"
									_cTipo2 := "B"
								Else
									_cTipo1 := "D"
									_cTipo2 := "D"
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Array contendo o cabeçalho da pedido de vendas para a empresa Matriz	 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//aAdd ( _aCabPv , { "C5_TIPO"    , "D"     	, Nil} ) // 03/02 - Rafael Leite
								aAdd ( _aCabPv , { "C5_TIPO"    , _cTipo1     	, Nil} )
								
								aAdd ( _aCabPv , { "C5_CLIENTE" , _cForn  	, Nil} )
								aAdd ( _aCabPv , { "C5_LOJACLI" , _cLojFn  	, Nil} )
								aAdd ( _aCabPv , { "C5_CLIENT"  , _cForn 	, Nil} )
								aAdd ( _aCabPv , { "C5_LOJAENT" , _cLojFn	, Nil} )
								//aAdd ( _aCabPv , { "C5_TRANSP"  , _cTrpPv	, Nil} )
								aAdd ( _aCabPv , { "C5_TRANSP"  , ''	, Nil} )
								aAdd ( _aCabPv , { "C5_TIPOCLI" , _cTipPv 	, Nil} )
								//aAdd ( _aCabPv , { "C5_VEND1" 	, _cVenPv 	, Nil} )
								//aAdd ( _aCabPv , { "C5_VEND1" 	, ' ' 	, Nil} )    
								aAdd ( _aCabPv , { "C5_TABELA"  , _cMvTbPr	, Nil} )								
								aAdd ( _aCabPv , { "C5_CONDPAG" , _cMvCdPv	, Nil} )
								aAdd ( _aCabPv , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabPv , { "C5_MOEDA" 	, 1			, Nil} )
								aAdd ( _aCabPv , { "C5_TPLIB" 	, "2"		, Nil} )
								
								If _cParam1 == "2" //Vendas
									If _cTipo1 == "D"
										aAdd ( _aCabPv , { "C5_NATUREZ" 	, cNatGenDev		, Nil} )
									Else 
										aAdd ( _aCabPv , { "C5_NATUREZ" 	, cNatGenOri		, Nil} )
									EndIf
								EndIf
								
								_aCabPd := {}
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Array contendo o cabeçalho da pedido de vendas para a empresa origem	 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aAdd ( _aCabPd , { "C5_TIPO"    , "N"      	, Nil} )
								aAdd ( _aCabPd , { "C5_CLIENTE" , _cCliGen 	, Nil} )
								aAdd ( _aCabPd , { "C5_LOJACLI" , _cLojGen 	, Nil} )
								aAdd ( _aCabPd , { "C5_CLIENT"  , _cCliGen	, Nil} )
								aAdd ( _aCabPd , { "C5_LOJAENT" , _cLojGen	, Nil} )
								aAdd ( _aCabPd , { "C5_TRANSP"  , _cTrpGen	, Nil} )
								aAdd ( _aCabPd , { "C5_TIPOCLI" , _cTipGen 	, Nil} )
								//aAdd ( _aCabPd , { "C5_VEND1" 	, _cVenGen 	, Nil} )
								aAdd ( _aCabPd , { "C5_TABELA"  , _cMvTbPr	, Nil} )								
								aAdd ( _aCabPd , { "C5_CONDPAG" , _cMvCdOr	, Nil} )
								aAdd ( _aCabPd , { "C5_EMISSAO" , dDatabase	, Nil} )
								aAdd ( _aCabPd , { "C5_MOEDA" 	, 1			, Nil} )
								aAdd ( _aCabPd , { "C5_TPLIB" 	, "2"		, Nil} )
								
								If _cParam1 == "2" //Vendas
									aAdd ( _aCabPd , { "C5_NATUREZ" , cNatOriGen	, Nil} )								
								EndIf
									
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Array contendo o cabeçalho da nota de entrada para a Matriz³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								
								_aCabDcEn := {} //Vetor contendo o cabeçalho documento de entrada empresa Matriz
								_aItmDcEn := {} //Vetor contendo os itens do documento de entrada empresa Matriz
								
								aadd(_aCabDcEn , {"F1_TIPO"   	,"N"		, Nil} ) //ALTERADO DANILO "D"
								aadd(_aCabDcEn , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcEn , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcEn , {"F1_EMISSAO"	,dDataBase	, Nil} )
								aadd(_aCabDcEn , {"F1_FORNECE"	,PADR(AllTrim(_cForn),TAMSX3("F1_FORNECE")[1])		, Nil} )
								aadd(_aCabDcEn , {"F1_LOJA"   	,_cLojFn	, Nil} )
								aadd(_aCabDcEn , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcEn , {"F1_COND"		,_cMvCdDe	, Nil} )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Array contendo o cabeçalho da nota de entrada para a Origem³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								
								_aCabDcOr := {} //Vetor contendo o cabeçalho documento de entrada empresa Origem
								_aItmDcOr := {} //Vetor contendo os itens do documento de entrada empresa Origem
								
								//aadd(_aCabDcOr , {"F1_TIPO"   	,"D"		, Nil} ) //ALTERADO DANILO "N"								
								aadd(_aCabDcOr , {"F1_TIPO"   	,_cTipo2		, Nil} ) // 03/02 - RAFAEL LEITE
								aadd(_aCabDcOr , {"F1_FORMUL" 	,"N"		, Nil} )
								aadd(_aCabDcOr , {"F1_SERIE"  	,_cMvSeri	, Nil} )
								aadd(_aCabDcOr , {"F1_EMISSAO"	,dDataBase	, Nil} )
								//aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cFnGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
								aadd(_aCabDcOr , {"F1_FORNECE"	,PADR(AllTrim(_cCliGen),TAMSX3("F1_FORNECE")[1])	, Nil} )
								//aadd(_aCabDcOr , {"F1_LOJA"   	,_cLjGen	, Nil} )
								aadd(_aCabDcOr , {"F1_LOJA"   	,_cLojGen	, Nil} )
								aadd(_aCabDcOr , {"F1_ESPECIE"	,_cMvEspc	, Nil} )
								aadd(_aCabDcOr , {"F1_COND"		,_cMvCdDe	, Nil} )
								
								_nContOr := 1
								_cContC6 := STRZERO(1,TAMSX3("C6_ITEM")[1])
								
								_aItmPd := {}
								_alinha := {}
								_aItmPv := {}
								
								_lVcDesc := .F.
								
								_cForUp	:= ""
								_cLojUp := ""
								
								_nItMax := 0                                                                                                    
								nQtdFT115	:= cFAST115
								While AllTrim((_cAliQry)->B1_PROC) == _cForn .And. AllTrim((_cAliQry)->B1_LOJPROC) == _cLojFn .and. _nItMax < nQtdFT115//90
									
									_lNegat := .F.
									_nQuant := 0
									_cForUp 	:= AllTrim((_cAliQry)->B1_PROC)
									_cLojUp 	:= AllTrim((_cAliQry)->B1_LOJPROC)
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Validando a quantidade correta a ser usada nas notas.³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                    
									If cRetInter == "P"
										IF aScan(aInIDTPPU, {|x| AllTrim(x) == AllTrim((_cAliQry)->B1_XIDTPPU) } ) > 0 .AND. !( ZZ8->( Dbseek( xFilial("ZZ8")  + _cParam1 + DtoS(dProcInter) + (_cAliQry)->B1_COD + (_cAliQry)->B1_PROC + (_cAliQry)->B1_LOJPROC ) ) .AND. ZZ8->ZZ8_STATUS == "1" ) 
											
											_cMsg := "Não localizado na tabela de auditoria de saldo. Codigo do produto: " + Alltrim((_cAliQry)->B1_COD)
											conout(Time()+ " " + _cMsg)
											MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Auditoria Saldo "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
											(_cAliQry)->(DbSkip())
											Loop										
											
										EndIf
									EndIf
									
									_nQuant := (_cAliQry)->VALOR_ORI - (_cAliQry)->VALOR_DEV - (_cAliQry)->VALOR_CAN
									If _nQuant == 0
										
										//Rafael Leite - 07/05/2015 - Inclusao de mensagem de log
										_cMsg := "Produto com calculo de prestacao ZERO. Sera desconsiderado do processamento. Codigo do produto: " + Alltrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Calc Zero "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										(_cAliQry)->(DbSkip())
										Loop
									EndIf
									
									//PRODUTOS BLQUEADOS
									If (_cAliQry)->B1_MSBLQL == '1'
										_cMsg := "Produto bloqueado (B1_MSBLQL) nao sera considerado na prestacao, mas tem quantidade a prestar contas: " + Alltrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod Blq "  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										(_cAliQry)->(DbSkip())
										Loop
									Endif
									
									//27/06/2015 - Rafael Leite - Retirado tratamento de desconto e preço, pois calculo está sendo feito na Previa da prestacao
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Validando se a tabela de preço possui o produto selecionado³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									
									DbSelectArea("DA1")
									DbSetOrder(1)
									If DbSeek(xFilial("DA1")+_cMvTbPr+(_cAliQry)->B1_COD)
									/*	
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
										//³Validação da regra de descontos para regra de cliente		   ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
										_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
										_cQuery += " FROM " + RetSqlName("ACO")
										_cQuery += " WHERE D_E_L_E_T_ = ' '
										_cQuery += " AND ACO_CODCLI = '" + SA1->A1_COD + "'
										_cQuery += " AND ACO_LOJA = '" + SA1->A1_LOJA + "'
										
										If Select(_cAliQry1) > 0
											dbSelectArea(_cAliQry1)
											(_cAliQry1)->(dbCloseArea())
										EndIf
										
										dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry1, .F., .T.)
										
										If (_cAliQry1)->(!EOF())
											
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[¿
											//³Validação se a regra de desconto esta válida³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[Ù
											If StoD((_cAliQry1)->ACO_DATATE) > dDatabase .OR. Empty((_cAliQry1)->ACO_DATATE)
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
												//³Validação da para pegar o produto  nas linhas da regra de desconto  ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
												_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
												_cQuery += " FROM " + RetSqlName("ACP")
												_cQuery += " WHERE D_E_L_E_T_ = ' '
												_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
												
												If Select(_cAliQry4) > 0
													dbSelectArea(_cAliQry4)
													(_cAliQry4)->(dbCloseArea())
												EndIf
												
												dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
												If (_cAliQry4)->(!EOF())
													_nDesc := (_cAliQry4)->ACP_PERDES
												Else
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Pega o valor do desconto do cabeçalho, pois não achou o produto nos itens³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													_nDesc := (_cAliQry1)->ACO_PERDES
												EndIf
												
												If Select(_cAliQry4) > 0
													dbSelectArea(_cAliQry4)
													(_cAliQry4)->(dbCloseArea())
												EndIf
											Else
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
												//³Função para alimentar Log de erro³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
												_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry1)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
												_lVcDesc := .T.
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
											EndIf
										Else
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
											//³Validação da regra de descontos para regra de grupo de cliente  ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
											_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
											_cQuery += " FROM " + RetSqlName("ACO")
											_cQuery += " WHERE D_E_L_E_T_ = ' '
											_cQuery += " AND ACO_GRPVEN = '" + SA1->A1_GRPVEN + "'
											
											If Select(_cAliQry2) > 0
												dbSelectArea(_cAliQry2)
												(_cAliQry2)->(dbCloseArea())
											EndIf
											dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry2, .F., .T.)
											If (_cAliQry2)->(!EOF())
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[¿
												//³Validação se a regra de desconto esta válida³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[Ù
												
												_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
												
												If _dDtAco > dDatabase .OR. Empty((_cAliQry2)->ACO_DATATE)
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
													//³Validação da para pegar o produto  nas linhas da regra de desconto  ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
													_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
													_cQuery += " FROM " + RetSqlName("ACP")
													_cQuery += " WHERE D_E_L_E_T_ = ' '
													_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
													
													If Select(_cAliQry4) > 0
														dbSelectArea(_cAliQry4)
														(_cAliQry4)->(dbCloseArea())
													EndIf
													
													dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
													
													If (_cAliQry4)->(!EOF())
														_nDesc := (_cAliQry4)->ACP_PERDES
													Else
														
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
														//³Pega o valor do desconto do cabeçalho, pois não achou o produto nos itens³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
														_nDesc := (_cAliQry2)->ACO_PERDES
													EndIf
													
													If Select(_cAliQry4) > 0
														dbSelectArea(_cAliQry4)
														(_cAliQry4)->(dbCloseArea())
													EndIf
												Else
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													//³Função para alimentar Log de erro³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry2)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
													_lVcDesc := .T.
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
													(_cAliQry)->(DbSkip())
												EndIf
											Else
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
												//³Validação da regra de descontos sem cliente e sem regra de grupo de cliente ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
												_cQuery := " SELECT ACO_FILIAL, ACO_CODREG, ACO_CODCLI, ACO_LOJA, ACO_PERDES, ACO_GRPVEN, ACO_DATATE
												_cQuery += " FROM " + RetSqlName("ACO")
												_cQuery += " WHERE D_E_L_E_T_ = ' '
												_cQuery += " AND (ACO_CODCLI = ' ' OR ACO_GRPVEN = ' ')
												
												If Select(_cAliQry3) > 0
													dbSelectArea(_cAliQry3)
													(_cAliQry3)->(dbCloseArea())
												EndIf
												
												dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry3, .F., .T.)
												
												If (_cAliQry3)->(!EOF())
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[¿
													//³Validação se a regra de desconto esta válida³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx´[Ù
													_dDtAco := IIF(ValType((_cAliQry2)->ACO_DATATE) = "C", STOD((_cAliQry2)->ACO_DATATE), (_cAliQry2)->ACO_DATATE)
													
													If _dDtAco > dDatabase .OR. Empty((_cAliQry3)->ACO_DATATE)
														
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
														//³Validação da para pegar o produto  nas linhas da regra de desconto  ³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄS
														_cQuery := " SELECT ACP_FILIAL, ACP_CODREG, ACP_CODPRO, ACP_PERDES
														_cQuery += " FROM " + RetSqlName("ACP")
														_cQuery += " WHERE D_E_L_E_T_ = ' '
														_cQuery += " AND ACP_CODPRO = '" + (_cAliQry)->B1_COD + "'
														
														If Select(_cAliQry4) > 0
															dbSelectArea(_cAliQry4)
															(_cAliQry4)->(dbCloseArea())
														EndIf
														dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry4, .F., .T.)
														If (_cAliQry4)->(!EOF())
															_nDesc := (_cAliQry4)->ACP_PERDES
														Else
															//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
															//³Pega o valor do desconto do cabeçalho, pois não achou o produto nos itens³
															//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
															_nDesc := (_cAliQry3)->ACO_PERDES
														EndIf
														If Select(_cAliQry4) > 0
															dbSelectArea(_cAliQry4)
															(_cAliQry4)->(dbCloseArea())
														EndIf
													Else
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "Regra de Descontos: " + AllTrim((_cAliQry3)->ACO_CODREG) + " encontra-se vencida, favor verificar. "
														_lVcDesc := .T.
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
														(_cAliQry)->(DbSkip())
													EndIf
												EndIf
												If Select(_cAliQry3) > 0
													dbSelectArea(_cAliQry3)
													(_cAliQry3)->(dbCloseArea())
												EndIf
											EndIf
											If Select(_cAliQry2) > 0
												dbSelectArea(_cAliQry2)
												(_cAliQry2)->(dbCloseArea())
											EndIf
										EndIf
										If Select(_cAliQry1) > 0
											dbSelectArea(_cAliQry1)
											(_cAliQry1)->(dbCloseArea())
										EndIf
										
										If _nDesc != 0
											_nPrcVn := (DA1->DA1_PRCVEN * _nDesc) / 100
										Else
											_nPrcVn := DA1->DA1_PRCVEN
										EndIf
										*/
										
										_nPrcVn := (_cAliQry)->VALOR_UNI
										
										//07/05/2015 - Rafael Leite - Não existe preço de venda menor que R$ 0.01.
										If _nPrcVn < 0.01
											_nPrcVn := 0.01
										Endif
											
										//_nPrcVn := DA1->DA1_PRCVEN
										_nDesc := 0 //Zerando a Variável
										
										If _nPrcVn > 0
											
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Sempre irá gravar todos os produtos na empresa matriz, porém alguns valores podem vir negativos,³
											//³fazer a transformação do negativo para positivo, isso somente para a empresa Matriz             ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If _nQuant < 0
												_lNegat := .T.
												_nQuant := _nQuant * -1
											EndIf
											
											_aSldB6 := {} //Zerando o Vetor de Saldos em poder de terceiros
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄaÆ¿
											//³Realizando a busca por saldo em poder de terceiros³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄaÆÙ
											If cRetInter == "P"

												_cQuery := " SELECT B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, D1_VUNIT, B6_DOC, B6_SALDO,
												_cQuery += " B6_SERIE, B6_CLIFOR, B6_LOJA, D1_ITEM, B6_IDENT, D1_LOCAL, ROUND((D1_VALDESC/D1_TOTAL),2) DESCONTO,ROUND((D1_TOTAL-D1_VALDESC)/D1_QUANT,2) PRC_CALC,
												
												//Rafael Leite - 08/05/2015 - Incluido tratamento para comparar saldo GEN e Empresa Origem
												//If _cFornece == "0378128"
												If _cFornece == "AAA"
													_cQuery += " B6_SALDO SALDO_ORI
												
												Else
												    /*
													_cQuery += " (SELECT SUM(B6_SALDO) B6_SALDO
		  											_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
												  	_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
													_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
													_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
													_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
													_cQuery += " AND B6_ORI.B6_QUANT    = SB6.B6_QUANT
												   //	_cQuery += " AND B6_ORI.B6_IDENT    = SB6.B6_IDENT
													_cQuery += " AND B6_ORI.D_E_L_E_T_  = ' '         
													
													//_cQuery += " AND D1_ORI.D1_FILIAL = '"+_cEmpFl+"'
													//_cQuery += " AND D1_ORI.D1_DOC = B6_ORI.B6_DOC
													//_cQuery += " AND D1_ORI.D1_SERIE = B6_ORI.B6_SERIE
													//_cQuery += " AND D1_ORI.D1_FORNECE = B6_ORI.B6_CLIFOR
													//_cQuery += " AND D1_ORI.D1_LOJA = B6_ORI.B6_LOJA
													//_cQuery += " AND D1_ORI.D1_COD = B6_ORI.B6_PRODUTO
													//_cQuery += " AND D1_ORI.D1_IDENTB6 = B6_ORI.B6_IDENT
													
													_cQuery += " ) SALDO_ORI
													*/

													//cleuto lima - melhoria na query do saldo origem para validar se não ocorreu devolução
													_cQuery += " NVL((SELECT SUM(B6_ORI.B6_SALDO)
													_cQuery += "      FROM "+ RetSqlName("SB6") +" B6_ORI
													_cQuery += "      JOIN "+ RetSqlName("SD2") +" D2_ORI
													_cQuery += "      ON D2_ORI.D2_FILIAL = B6_ORI.B6_FILIAL
													_cQuery += "      AND D2_ORI.D2_DOC = B6_ORI.B6_DOC
													_cQuery += "      AND D2_ORI.D2_SERIE = B6_ORI.B6_SERIE
													_cQuery += "      AND D2_ORI.D2_CLIENTE = B6_ORI.B6_CLIFOR
													_cQuery += "      AND D2_ORI.D2_LOJA = B6_ORI.B6_LOJA
													_cQuery += "      AND D2_ORI.D2_COD = B6_ORI.B6_PRODUTO
													_cQuery += "      AND D2_ORI.D2_IDENTB6 = B6_ORI.B6_IDENT
													_cQuery += "      AND D2_ORI.D_E_L_E_T_ <> '*'
													_cQuery += "      WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
													_cQuery += "        AND B6_ORI.B6_DOC = SB6.B6_DOC
													_cQuery += "        AND B6_ORI.B6_SERIE = SB6.B6_SERIE
													_cQuery += "        AND B6_ORI.B6_PRODUTO = SB6.B6_PRODUTO
													_cQuery += "        AND B6_ORI.B6_QUANT = SB6.B6_QUANT
													_cQuery += "        AND B6_ORI.D_E_L_E_T_ = ' ' 
													_cQuery += "        AND D2_ORI.D2_QUANT - D2_ORI.D2_QTDEDEV > 0
													//Removi esta validação para permitir utilizar notas com saldo parcialmente balanceado, esta validação permite apenas notas com 100% saldo correto
													//_cQuery += "        AND D2_ORI.D2_QUANT - D2_ORI.D2_QTDEDEV >= B6_ORI.B6_SALDO
													//_cQuery += "        AND D2_ORI.D2_QUANT - ( SELECT SUM(D1_QUANT) FROM "+ RetSqlName("SD1") +" SD1_ORI WHERE SD1_ORI.D1_FILIAL = D2_ORI.D2_FILIAL AND SD1_ORI.D1_NFORI = D2_ORI.D2_DOC AND SD1_ORI.D1_SERIORI = D2_ORI.D2_SERIE AND SD1_ORI.D1_ITEMORI = D2_ORI.D2_ITEM AND SD1_ORI.D_E_L_E_T_ <> '*') >= B6_ORI.B6_SALDO       
													_cQuery += "        ),0) SALDO_ORI "
																										
													//cleuto lima - retorna os saldos com base nas devoluções
													_cQuery += " ,(D1_QUANT-NVL(( SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2
													_cQuery += "     WHERE D2_FILIAL = SB6.B6_FILIAL
													_cQuery += "     AND SD2.D2_NFORI = SB6.B6_DOC
													_cQuery += "     AND SD2.D2_SERIORI = SB6.B6_SERIE
													_cQuery += "     AND SD2.D2_ITEMORI = D1_ITEM
													_cQuery += "     AND D2_CLIENTE = SB6.B6_CLIFOR
													_cQuery += "     AND D2_LOJA = SB6.B6_LOJA
													_cQuery += "     AND D2_COD = SB6.B6_PRODUTO
													_cQuery += "     AND SD2.D_E_L_E_T_ <> '*'
													_cQuery += "     ),0)) SALDO_SAIDA " 
														
												Endif
													
												_cQuery += " FROM " + RetSqlName("SB6") + " SB6, " + RetSqlName("SD1") + " SD1
												_cQuery += " WHERE SB6.B6_DOC = SD1.D1_DOC
												_cQuery += " AND SB6.B6_SERIE = SD1.D1_SERIE
												_cQuery += " AND SB6.B6_PRODUTO = SD1.D1_COD
												_cQuery += " AND SB6.B6_CLIFOR = SD1.D1_FORNECE
												_cQuery += " AND SB6.B6_LOJA = SD1.D1_LOJA
												_cQuery += " AND SB6.B6_IDENT = SD1.D1_IDENTB6
												_cQuery += " AND SB6.D_E_L_E_T_ = ' '
												_cQuery += " AND SD1.D_E_L_E_T_ = ' '
												_cQuery += " AND SB6.B6_FILIAL = '" + _cFil + "'
												_cQuery += " AND SD1.D1_FILIAL = '" + _cFil + "'
												_cQuery += " AND SD1.D1_EMISSAO <= '"+DtoS(dProcInter)+"'												
												_cQuery += " AND SB6.B6_TIPO = 'D'
												_cQuery += " AND SB6.B6_TPCF = 'F'
												_cQuery += " AND SB6.B6_PODER3 = 'R'      
												_cQuery += " AND SB6.B6_SALDO > 0
												_cQuery += " AND SB6.B6_PRODUTO = '" + (_cAliQry)->B1_COD + "'
												_cQuery += " AND SB6.B6_CLIFOR = '" + _cForn + "'
												_cQuery += " AND SB6.B6_LOJA = '" + _cLojFn + "' 
                                                
                                                // cleuto lima - 30/09/2016
												// Incluida validação de saldo atraves da nota fiscal de devolução
												_cQuery += " AND (D1_QUANT-NVL(( SELECT SUM(D2_QUANT) FROM " + RetSqlName("SD2") + " SD2
												_cQuery += "     WHERE D2_FILIAL = SB6.B6_FILIAL
												_cQuery += "     AND SD2.D2_NFORI = SB6.B6_DOC
												_cQuery += "     AND SD2.D2_SERIORI = SB6.B6_SERIE
												_cQuery += "     AND SD2.D2_ITEMORI = D1_ITEM
												_cQuery += "     AND D2_CLIENTE = SB6.B6_CLIFOR
												_cQuery += "     AND D2_LOJA = SB6.B6_LOJA
												_cQuery += "     AND D2_COD = SB6.B6_PRODUTO
												_cQuery += "     AND SD2.D_E_L_E_T_ <> '*'
												_cQuery += "     ),0)) > 0 " //VALIDAO SE NÃO HOUVE SAIDA QUE NÃO BAIXOU SB6

												/* <FILTRA SALDO ORIGEM> */
												// cleuto lima - 30/09/2016
												_cQuery += " AND
												_cQuery += "     NVL((SELECT SUM(B6_SALDO)
												_cQuery += "      FROM "+ RetSqlName("SB6") +" B6_ORI
												_cQuery += "      JOIN "+ RetSqlName("SD2") +" D2_ORI
												_cQuery += "      ON D2_ORI.D2_FILIAL = B6_ORI.B6_FILIAL
												_cQuery += "      AND D2_ORI.D2_DOC = B6_ORI.B6_DOC
												_cQuery += "      AND D2_ORI.D2_SERIE = B6_ORI.B6_SERIE
												_cQuery += "      AND D2_ORI.D2_CLIENTE = B6_ORI.B6_CLIFOR
												_cQuery += "      AND D2_ORI.D2_LOJA = B6_ORI.B6_LOJA
												_cQuery += "      AND D2_ORI.D2_COD = B6_ORI.B6_PRODUTO
												_cQuery += "      AND D2_ORI.D2_IDENTB6 = B6_ORI.B6_IDENT
												_cQuery += "      AND D2_ORI.D_E_L_E_T_ <> '*'
												_cQuery += "      WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
												_cQuery += "        AND B6_ORI.B6_DOC = SB6.B6_DOC
												_cQuery += "        AND B6_ORI.B6_SERIE = SB6.B6_SERIE
												_cQuery += "        AND B6_ORI.B6_PRODUTO = SB6.B6_PRODUTO
												_cQuery += "        AND B6_ORI.B6_QUANT = SB6.B6_QUANT
												_cQuery += "        AND B6_ORI.D_E_L_E_T_ = ' ' 
												_cQuery += "        AND D2_ORI.D2_QUANT - D2_ORI.D2_QTDEDEV > 0
												/* Removi esta validação para permitir utilizar notas com saldo parcialmente balanceado, esta validação permite apenas notas com 100% saldo correto												
												_cQuery += "        AND D2_ORI.D2_QUANT - ( SELECT SUM(D1_QUANT) FROM "+ RetSqlName("SD1") +" SD1_ORI WHERE SD1_ORI.D1_FILIAL = D2_ORI.D2_FILIAL AND SD1_ORI.D1_NFORI = D2_ORI.D2_DOC AND SD1_ORI.D1_SERIORI = D2_ORI.D2_SERIE AND SD1_ORI.D1_ITEMORI = D2_ORI.D2_ITEM AND SD1_ORI.D_E_L_E_T_ <> '*') >= B6_ORI.B6_SALDO       
												*/
												_cQuery += "        ),0) > 0 " // VALIDO SALDO ORIGEM EM RELAÇÃO AS NOTAS DE SAIDA DA ORIGEM PARA O GEN        
												/* </FILTRA SALDO ORIGEM> */
													   
												//Rafael Leite - 07/05/2015 - Adicionado filtro para exibir somente documentos com saldo na empresa origem.
												//If _cFornece <> "0378128"
												If _cFornece <> "AAA"
													_cQuery += " AND (SELECT SUM(B6_SALDO)
		  											_cQuery += " FROM " + RetSqlName("SB6") + " B6_ORI
												  	_cQuery += " WHERE B6_ORI.B6_FILIAL = '"+_cEmpFl+"'
													_cQuery += " AND B6_ORI.B6_DOC      = SB6.B6_DOC
													_cQuery += " AND B6_ORI.B6_SERIE    = SB6.B6_SERIE
													_cQuery += " AND B6_ORI.B6_PRODUTO  = SB6.B6_PRODUTO
													_cQuery += " AND B6_ORI.B6_QUANT    = SB6.B6_QUANT " //VERIFICAR SE DEVE SER REMOVIDO POIS IGNORA AS NOTAS QUANDO O ITEM NA ORIGEM É BAIXADO DIFERENTE DO ITEM DESTINO PARA O MESMO PRODUTO 
													//_cQuery += " AND B6_ORI.B6_IDENT    = SB6.B6_IDENT
													_cQuery += " AND B6_ORI.D_E_L_E_T_  = ' ' 
													
													//_cQuery += " AND D1_ORI.D_E_L_E_T_  = ' '
													//_cQuery += " AND D1_ORI.D1_FILIAL = '"+_cEmpFl+"'
													//_cQuery += " AND D1_ORI.D1_DOC = B6_ORI.B6_DOC
													//_cQuery += " AND D1_ORI.D1_SERIE = B6_ORI.B6_SERIE
													//_cQuery += " AND D1_ORI.D1_FORNECE = B6_ORI.B6_CLIFOR
													//_cQuery += " AND D1_ORI.D1_LOJA = B6_ORI.B6_LOJA
													//_cQuery += " AND D1_ORI.D1_COD = B6_ORI.B6_PRODUTO   
													//_cQuery += " AND D1_ORI.D1_IDENTB6 = B6_ORI.B6_IDENT
													_cQuery += " ) > 0  
												Endif
																						   
												_cQuery += " ORDER BY B6_EMISSAO
											Else
												_cQuery := " SELECT D1_FILIAL AS B6_FILIAL,
												_cQuery += " D1_FORNECE AS B6_CLIFOR,
												_cQuery += " D1_LOJA AS  B6_LOJA,
												_cQuery += " D1_COD AS B6_PRODUTO,
												_cQuery += " D1_VUNIT,
												_cQuery += " D1_DOC AS B6_DOC,
												_cQuery += " (D1_QUANT - D1_QTDEDEV) AS B6_SALDO,
												_cQuery += " D1_SERIE AS B6_SERIE,
												_cQuery += " D1_ITEM,
												_cQuery += " D1_LOCAL,
												_cQuery += " (D1_VALDESC/D1_TOTAL) DESCONTO, 
												_cQuery += " (D1_TOTAL-D1_VALDESC)/D1_QUANT PRC_CALC,
												_cQuery += " ' ' AS B6_IDENT,
												
												//If _cFornece == "0378128"
												If _cFornece == "AAA"
	
													_cQuery += " (D1_QUANT - D1_QTDEDEV) AS SALDO_ORI									
													
												Else
													_cQuery += " (SELECT MAX(SD2_1.D2_QUANT - SD2_1.D2_QTDEDEV)
													_cQuery += "   FROM " + RetSqlName("SD2") + " SD2_1
													_cQuery += "   WHERE SD2_1.D2_FILIAL = '"+_cEmpFl+"'
													_cQuery += "   AND SD1.D1_DOC      = SD2_1.D2_DOC
													_cQuery += "   AND SD1.D1_SERIE    = SD2_1.D2_SERIE
													_cQuery += "   AND SD1.D1_COD      = SD2_1.D2_COD
													_cQuery += "   AND SD2_1.D_E_L_E_T_         = ' ') AS SALDO_ORI
												Endif
												
												_cQuery += " ,(D1_QUANT - D1_QTDEDEV) AS SALDO_SAIDA
												
												_cQuery += " FROM " + RetSqlName("SD1") + " SD1
												_cQuery += " WHERE SD1.D1_FILIAL  = '" + _cFil + "'
												_cQuery += " AND SD1.D1_SERIE  = '" + _cMvSeri + "'"
												_cQuery += " AND (D1_QUANT - D1_QTDEDEV)  > 0
												_cQuery += " AND SD1.D1_COD = '" + (_cAliQry)->B1_COD + "'
												_cQuery += " AND SD1.D1_FORNECE = '" + _cForn + "'
												_cQuery += " AND SD1.D1_LOJA    = '" + _cLojFn + "'
//												_cQuery += " AND SD1.D1_DOC NOT IN ('000000035','000000036','000000037','000000038') "
												_cQuery += " AND SD1.D1_EMISSAO <= '"+DtoS(dProcInter)+"'
                                                
                                                If _cParam1 == "2" // Venda 
													_cQuery += " AND SD1.D1_TES IN ('"+_cMvTsDe+"')"
                                                Else // 1 Oferta
                                                	// devolução de oferta ainda não é trada por esta rotina
                                                	_cQuery += " AND SD1.D1_TES IN ('"+_cTesEn+"')"
                                                EndIf
												
												//If _cFornece <> "0378128"
												If _cFornece <> "AAA" 
													_cQuery += " AND (SELECT MAX(SD2.D2_QUANT - SD2.D2_QTDEDEV)
													_cQuery += "   FROM " + RetSqlName("SD2") + " SD2
													_cQuery += "   WHERE SD2.D2_FILIAL = '"+_cEmpFl+"'
													_cQuery += "   AND SD1.D1_DOC      = SD2.D2_DOC
													_cQuery += "   AND SD1.D1_SERIE    = SD2.D2_SERIE
													_cQuery += "   AND SD1.D1_COD      = SD2.D2_COD
													_cQuery += "   AND SD2.D_E_L_E_T_         = ' ' ) > 0
												Endif

												_cQuery += " AND SD1.D_E_L_E_T_ <> '*' "												
												_cQuery += " ORDER BY D1_EMISSAO DESC
												
											Endif
												
											If Select(_cAliQry5) > 0
												dbSelectArea(_cAliQry5)
												(_cAliQry5)->(dbCloseArea())
											EndIf
											
										
										    If TcSqlExec(_cQuery) < 0
										    	
										    	cErroSql := TCSQLError()
												conout(Time()+ " " + cErroSql)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) +" SQL ERROR "+alltrim((_cAliQry)->B1_COD)+".TXT" , AllTrim(cErroSql) )

												//19/06/2015 - Rafael Leite - Atualiza SZA com status de produto sem saldo em terceiros
												_cQuery := "UPDATE " + RetSqlName("SZA")
												_cQuery += " SET ZA_STATUS = '6' 
												_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
												_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
												_cQuery += " AND ZA_PROC = '"+cFornInter+"'
												_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
												_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
												_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
												_cQuery += " AND ZA_STATUS = ' '
												_cQuery += " AND ZA_COD = '"+(_cAliQry)->B1_COD+"'
												_cQuery += " AND D_E_L_E_T_ = ' '

												If TCSQLEXEC(_cQuery) != 0
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													//³Função para alimentar Log de erro³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													_cMsg := "Não foi possivel realizar o update na SZA para com falha na query SB6: " + AllTrim((_cAliQry)->B1_COD) + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
												EndIf
																								
										    	(_cAliQry)->(DbSkip())
										    	Loop
										    	
										    Else
										    	
										    	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliQry5, .F., .T.)
										    	
						                  EndIF

											If (_cAliQry5)->(!EOF())
												//Passando a quantidade para outra variavel, trabalhando assim livremente
												//sem alterar as demais validações e aplicações da variável _nQuant
												//pois a variável _nQuant é utilizada abaixo em outras situações
												_nQtdSld := _nQuant
												
												While (_cAliQry5)->(!EOF())
													
													//08/05/2015 - Rafael Leite - Compara saldo GEN e Empresa Origem
													_nSldB6Comp := (_cAliQry5)->B6_SALDO
													
													//Se o saldo de poder terceiro na origem estiver menor que no GEN, utiliza o saldo da Origem.
													If _nSldB6Comp > (_cAliQry5)->SALDO_ORI
														_nSldB6Comp := (_cAliQry5)->SALDO_ORI
													Endif 

													// cleuto lima - 30/09/2016 - se o saldo do gen com base na movimentação estiver menor usa o saldo da movimentação
													If _nSldB6Comp > (_cAliQry5)->SALDO_SAIDA
														_nSldB6Comp := (_cAliQry5)->SALDO_SAIDA
													Endif 
																										
													//_nQtdB6 := _nQtdSld - (_cAliQry5)->B6_SALDO
													_nQtdB6 := _nQtdSld - _nSldB6Comp
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													//³Caso a quantidade seja igual ao saldo, preencher somente um vez³
													//³o array e sair do while para este produto                      ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													If _nQtdB6 = 0
														//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
														//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
														aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT,(_cAliQry5)->D1_VUNIT,(_cAliQry5)->D1_LOCAL,(_cAliQry5)->DESCONTO,(_cAliQry5)->PRC_CALC})
														Exit
													EndIf
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Caso a quantidade desejada seja menor que o saldo, irá gravar³
													//³o array e sair do while para este produto                    ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													If _nQtdB6 < 0
														_nQtdB6 := _nQtdB6 * -1
														//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
														//aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
														aAdd(_aSldB6,{_nQtdSld, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT,(_cAliQry5)->D1_VUNIT,(_cAliQry5)->D1_LOCAL,(_cAliQry5)->DESCONTO,(_cAliQry5)->PRC_CALC})
														Exit
													EndIf
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Caso a quantidade seja maior que o saldo, irá continuar no while³
													//³deste produto para preencher o array dando a quantidade correta ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													If _nQtdB6 > 0
														//aAdd(_aSldB6,{_nQtdB6, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM })
														//aAdd(_aSldB6,{(_cAliQry5)->B6_SALDO, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM }) //03/02 - RAFAEL LEITE
														
														//08/05/2015 - Rafael Leite - Ajuste para usar variavel com saldo poder 3 comparado (vide inicio do while)
														//aAdd(_aSldB6,{(_cAliQry5)->B6_SALDO, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT })
														aAdd(_aSldB6,{_nSldB6Comp, (_cAliQry5)->B6_DOC, (_cAliQry5)->B6_SERIE, (_cAliQry5)->D1_ITEM, (_cAliQry5)->B6_IDENT,(_cAliQry5)->D1_VUNIT,(_cAliQry5)->D1_LOCAL,(_cAliQry5)->DESCONTO,(_cAliQry5)->PRC_CALC})
														
														//_nQtdSld := _nQtdSld - (_cAliQry5)->B6_SALDO
														_nQtdSld := _nQtdSld - _nSldB6Comp
													EndIf
													(_cAliQry5)->(DbSkip())
												EndDo
											Else
								
												//19/06/2015 - Rafael Leite - Atualiza SZA com status de produto sem saldo em terceiros
												_cQuery := "UPDATE " + RetSqlName("SZA")
												_cQuery += " SET ZA_STATUS = '4' 
												_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
												_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
												_cQuery += " AND ZA_PROC = '"+cFornInter+"'
												_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
												_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
												_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
												_cQuery += " AND ZA_STATUS = ' '
												_cQuery += " AND ZA_COD = '"+(_cAliQry)->B1_COD+"'
												_cQuery += " AND D_E_L_E_T_ = ' '
													
												If TCSQLEXEC(_cQuery) != 0
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													//³Função para alimentar Log de erro³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													_cMsg := "Não foi possivel realizar o update na SZA para produtos sem saldo Produto: " + AllTrim((_cAliQry)->B1_COD) + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
												EndIf

												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
												//³Função para alimentar Log de erro³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
												_cMsg := "Não foi encontrado no sistema Saldo em poder de terceiros para o produto: " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor: " + AllTrim(_cCliPv) + " e Loja: " + AllTrim(_cLjPv)
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												Loop
											EndIf
											
											If Select(_cAliQry5) > 0
												dbSelectArea(_cAliQry5)
												(_cAliQry5)->(dbCloseArea())
											EndIf
											
											_nQtdSld := 0
											
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Validando se a quantidade esta correta para prosseguir ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											For _ni := 1 To Len(_aSldB6)
												_nQtdSld += _aSldB6[_ni][1]
											Next _ni
											
											If _nQtdSld = _nQuant 
												
												aJaUsoSB6	:= {}
												For _ni := 1 To Len(_aSldB6)
													_nItMax++
													//04/10/2015 - Rafael Leite - Dev. respeita valor unitario do Doc de Entrada original
													//If cRetInter == "N" .and. _aSldB6[_ni][6] > 0
													//	_nPrcVn := _aSldB6[_ni][6]	
													//Endif
													                                          
													//_nPrcDv := _aSldB6[_ni][6] //_aSldB6[_ni][9] apenas utilizar a posição 9 quanto o pedido estiver falha emissão por valor total incorreto, isso ocorre devido a nota fiscal de entrda ser digitado com o desconto e o sb6 ser criado o valor bruto sem desconto
            										
            										_nPrcDv := _aSldB6[_ni][9]
            										
 
													If _nPrcDv < 0.01
														_nPrcDv := 0.01
													EndIf
													
													_nTotDv := _aSldB6[_ni][1]*_nPrcDv
													
													//If _cFornece == "0378128" .and. _aSldB6[_ni][8] > 0 
													If _cFornece == "AAA" .and. _aSldB6[_ni][8] > 0 
														_nPrcDv := Round(_nPrcDv * _aSldB6[_ni][8],2)		//PRECO * PERCENTUAL DESCONTO, com arredondamento
														_nTotDv := _nPrcDv * _aSldB6[_ni][1] 				//_nTotDv := Round(_nTotDv * _aSldB6[_ni][8],2)	
													Endif																										
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Array contendo a linha do pedido de vendas na empresa Matriz³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													aAdd ( _alinha 	, 	{ "C6_ITEM"    	, _cContC6, Nil})
													aAdd ( _alinha 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
													aAdd ( _alinha 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
													aAdd ( _alinha 	, 	{ "C6_QTDVEN"  	, _aSldB6[_ni][1]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_PRCVEN"  	, _nPrcDv				    			, Nil})
													aAdd ( _alinha 	, 	{ "C6_VALOR"   	, _nTotDv	   							, Nil})
													aAdd ( _alinha 	, 	{ "C6_QTDLIB"  	, _aSldB6[_ni][1]						, Nil})

													If !_lNegat
														If _cParam1 == "2" //Vendas
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPd 		   					, Nil}) //TES diferente
														Else
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsOf 		   					, Nil}) //TES diferente
														EndIf
													Else
														If _cParam1 == "2" //Vendas
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPdV		   					, Nil}) //TES diferente valor negativo Vendas
														Else
															aAdd ( _alinha 	, 	{ "C6_TES"     	, _cMvTsPOf		   					, Nil}) //TES diferente valor negativo Oferta
														EndIf
													EndIf
													
													aAdd ( _alinha 	, 	{ "C6_LOCAL"   	, _aSldB6[_ni][7]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
													
													/*
													aAdd ( _alinha 	, 	{ "C6_NFORI"	, _aSldB6[_ni][2]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_SERIORI"	, _aSldB6[_ni][3]		   				, Nil})
													aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, _aSldB6[_ni][4]		   				, Nil})
													*/													
													aAdd ( _alinha 	, 	{ "C6_NFORI"	, PADR(AllTrim(_aSldB6[_ni][2]),TAMSX3("C6_NFORI")[1])	, Nil})
													aAdd ( _alinha 	, 	{ "C6_SERIORI"	, PADR(AllTrim(_aSldB6[_ni][3]),TAMSX3("C6_SERIORI")[1])	, Nil})
													aAdd ( _alinha 	, 	{ "C6_ITEMORI"	, PADR(AllTrim(_aSldB6[_ni][4]),TAMSX3("C6_ITEMORI")[1])	, Nil})
													If !Empty(_aSldB6[_ni][5])
														aAdd ( _alinha 	, 	{ "C6_IDENTB6"	, PADR(AllTrim(_aSldB6[_ni][5]),TAMSX3("C6_IDENTB6")[1])	, Nil})
													EndIf
													aAdd(_aItmPv , _alinha  )
													_alinha := {}
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Array contendo os itens do Documento de Entrada empresa Origem³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													aAdd(_alinhaOr	,	{"D1_ITEM"		, _cContC6, Nil})
													aAdd(_alinhaOr	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
													aAdd(_alinhaOr	,	{"D1_QUANT"		, _aSldB6[_ni][1]						, Nil})
													aAdd(_alinhaOr	,	{"D1_VUNIT"		, _nPrcDv								, Nil})
													aAdd(_alinhaOr	,	{"D1_TOTAL"		, _aSldB6[_ni][1] *	_nPrcDv				, Nil})
													
													If !_lNegat
														If _cParam1 == "2" //Vendas
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOr							, Nil})
														Else
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOrF							, Nil})
														EndIf
													Else
														If _cParam1 == "2" //Vendas
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsOrV							, Nil})
														Else
															aAdd(_alinhaOr	,	{"D1_TES"		, _cMvTsNoF							, Nil})
														EndIf
													EndIf
													
													aAdd(_alinhaOr	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
													
													If _lNegat										
														cQry := "SELECT D2_ITEM,D2_QUANT-D2_QTDEDEV SALDO, D2_IDENTB6 FROM "+RetSqlName("SD2")+" D2 "+cEnt
													Else
														cQry := "SELECT B6_SALDO,D2_ITEM, D2_IDENTB6 FROM "+RetSqlName("SD2")+" D2 "+cEnt	
														cQry += " JOIN "+RetSqlName("SB6")+" SB6 "+cEnt
														cQry += " ON B6_FILIAL = D2_FILIAL "+cEnt
														cQry += " AND B6_DOC = D2_DOC "+cEnt
														cQry += " AND B6_SERIE = D2_SERIE "+cEnt
														cQry += " AND B6_PRODUTO = D2_COD "+cEnt
														cQry += " AND B6_CLIFOR = D2_CLIENTE "+cEnt
														cQry += " AND B6_LOJA = D2_LOJA "+cEnt
														cQry += " AND SB6.D_E_L_E_T_ <> '*' "+cEnt
														cQry += " AND SB6.B6_IDENT = D2.D2_IDENTB6 "+cEnt														
													EndIF	
																										
													cQry += " WHERE D2_FILIAL = '"+_cEmpFl+"' "+cEnt
													cQry += " AND D2_DOC = '"+_aSldB6[_ni][2]+"' "+cEnt
													cQry += " AND D2_SERIE = '"+_aSldB6[_ni][3]+"' "+cEnt
													cQry += " AND D2_COD = '"+(_cAliQry)->B1_COD+"' "+cEnt
													cQry += " AND D2.D_E_L_E_T_ = ' ' "+cEnt

													If !_lNegat
														cQry += " ORDER BY B6_SALDO "+cEnt
													EndIF	
																										
													cD2_IDENTB6		:= ""
													cItemOri		:= ""
													lSaldoOrigem	:= .T.
													
													If Select(_cAliQryX) > 0
														dbSelectArea(_cAliQryX)
														(_cAliQryX)->(dbCloseArea())
													EndIf
													
													dbUseArea(.T., "TOPCONN", TcGenQry(,,cQry), _cAliQryX, .F., .T.)
													
													(_cAliQryX)->(DbGoTop())
													cItemOri	:= (_cAliQryX)->D2_ITEM
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Cleuto Lima - 02/06/2016                                        ³
													//³                                                                ³
													//³Incluido tratamento para pegar a nota de origem com saldo no SB6³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													If !_lNegat
														While (_cAliQryX)->(!EOF())
                                                            
															If aScan(aJaUsoSB6, {|x| AllTrim(x) == AllTrim((_cAliQryX)->D2_IDENTB6) } ) <> 0
																(_cAliQryX)->(DbSkip())
																Loop
															EndIf

															If (_cAliQryX)->B6_SALDO >= _aSldB6[_ni][1]
																cD2_IDENTB6	:= (_cAliQryX)->D2_IDENTB6
																cItemOri	:= (_cAliQryX)->D2_ITEM 
																Aadd(aJaUsoSB6, AllTrim((_cAliQryX)->D2_IDENTB6) )
																Exit
															EndIf
															
															(_cAliQryX)->(DbSkip())	
														EndDo
													Else
														
														nQtdDev	:= 0
														While (_cAliQryX)->(!EOF())
															
															For nVldQtd := 1 To Len(_aItmDcOr)
																If	_aItmDcOr[nVldQtd][aScan(_aItmDcOr[nVldQtd],{|x| x[1] == "D1_NFORI" })][2] == _aSldB6[_ni][2] .AND.;
																	_aItmDcOr[nVldQtd][aScan(_aItmDcOr[nVldQtd],{|x| x[1] == "D1_SERIORI" })][2] == _aSldB6[_ni][3]  .AND.;
																	_aItmDcOr[nVldQtd][aScan(_aItmDcOr[nVldQtd],{|x| x[1] == "D1_ITEMORI" })][2] == (_cAliQryX)->D2_ITEM
																	
																	nQtdDev += _aItmDcOr[nVldQtd][aScan(_aItmDcOr[nVldQtd],{|x| x[1] == "D1_QUANT" })][2]
																EndIf	
															Next
															
															If (_cAliQryX)->SALDO-nQtdDev >= _aSldB6[_ni][1]
																cItemOri	:= (_cAliQryX)->D2_ITEM
																Exit
															EndIf
															
															(_cAliQryX)->(DbSkip())	
														EndDo														
															
													EndIF
														
													aAdd(_alinhaOr	,	{"D1_NFORI"		, _aSldB6[_ni][2]						, Nil})
													aAdd(_alinhaOr	,	{"D1_SERIORI"	, _aSldB6[_ni][3]						, Nil})
													aAdd(_alinhaOr	,	{"D1_ITEMORI"	, cItemOri								, Nil})													
																										
													If !_lNegat
														If Empty(cD2_IDENTB6) 
															lSaldoOrigem	:= .F.
														Else	
															aAdd(_alinhaOr	,	{"D1_IDENTB6"	, cD2_IDENTB6				, Nil}) // 03/02 - RAFAEL LEITE
														EndIf	
													EndIf	

													If Select(_cAliQryX) > 0
														dbSelectArea(_cAliQryX)
														(_cAliQryX)->(dbCloseArea())
													EndIf
													
													aadd(_aItmDcOr,_alinhaOr)
													_alinhaOr := {}
													_cContC6 := Soma1(_cContC6)
												Next _ni
												
												If !_lNegat .AND. !lSaldoOrigem
													//02/06/2016 - Cletuo Lima - Atualiza SZA com status SALDO SB6 NÃO IDENTIFICADO NA ORIGEM 
													_cQuery := "UPDATE " + RetSqlName("SZA")
													_cQuery += " SET ZA_STATUS = '7' 
													_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
													_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
													_cQuery += " AND ZA_PROC = '"+cFornInter+"'
													_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
													_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
													_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
													_cQuery += " AND ZA_STATUS = ' '
													_cQuery += " AND ZA_COD = '"+(_cAliQry)->B1_COD+"'
													_cQuery += " AND D_E_L_E_T_ = ' '
														
													If TCSQLEXEC(_cQuery) != 0
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "Não foi possivel realizar o update na SZA para SALDO SB6 NÃO IDENTIFICADO NA ORIGEM Produto: " + AllTrim((_cAliQry)->B1_COD) + cEnt
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
													EndIf
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Função para alimentar Log de erro³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													_cMsg := "SALDO SB6 NÃO IDENTIFICADO NA ORIGEM para o produto " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor " + AllTrim(_cCliPv) + " e Loja " + AllTrim(_cLjPv) + " não atende a quantidade necessária."
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
													(_cAliQry)->(DbSkip())
													Loop
												EndIf
												
											Else
												
												//19/06/2015 - Rafael Leite - Atualiza SZA com status de produto sem saldo em terceiros
												_cQuery := "UPDATE " + RetSqlName("SZA")
												_cQuery += " SET ZA_STATUS = '2' 
												_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
												_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
												_cQuery += " AND ZA_PROC = '"+cFornInter+"'
												_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
												_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
												_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
												_cQuery += " AND ZA_STATUS = ' '
												_cQuery += " AND ZA_COD = '"+(_cAliQry)->B1_COD+"'
												_cQuery += " AND D_E_L_E_T_ = ' '
													
												If TCSQLEXEC(_cQuery) != 0
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													//³Função para alimentar Log de erro³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
													_cMsg := "Não foi possivel realizar o update na SZA para produtos sem saldo Produto: " + AllTrim((_cAliQry)->B1_COD) + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
												EndIf
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³Função para alimentar Log de erro³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												_cMsg := "Saldo em poder de terceiros para o produto " + AllTrim((_cAliQry)->B1_COD) + ", com o cliente/fornecedor " + AllTrim(_cCliPv) + " e Loja " + AllTrim(_cLjPv) + " não atende a quantidade necessária."
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
												(_cAliQry)->(DbSkip())
												Loop
											EndIf
											
											If !_lNegat
												
												nQuantAux := _nQuant
												nSaldoAux := _nQuant
												
												While nQuantAux > 0
													
													If nSaldoAux > 999999
														nSaldoAux := 999999
													EndIf
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Array contendo a linha do pedido de vendas na empresa Origem³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													aAdd ( _aLinPd 	, 	{ "C6_ITEM"    	, STRZERO(_nContOr,TAMSX3("C6_ITEM")[1]), Nil})
													aAdd ( _aLinPd 	, 	{ "C6_PRODUTO" 	, (_cAliQry)->B1_COD 					, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_DESCRI"  	, (_cAliQry)->B1_DESC  					, Nil})
													//aAdd ( _aLinPd 	, 	{ "C6_QTDVEN"  	, _nQuant				   				, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_QTDVEN"  	, nSaldoAux				   				, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_PRCVEN"  	, _nPrcVn	    						, Nil})
													//aAdd ( _aLinPd 	, 	{ "C6_VALOR"   	, _nQuant *	_nPrcVn						, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_VALOR"   	, nSaldoAux *	_nPrcVn						, Nil})
													//aAdd ( _aLinPd 	, 	{ "C6_QTDLIB"  	, _nQuant   							, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_QTDLIB"  	, nSaldoAux   							, Nil})
													
													If _cParam1 == "2" //Vendas
														aAdd ( _aLinPd 	, 	{ "C6_TES"  , _cMvTsPv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem - Venda
													Else													
														If cTipoOfert == "1"
															aAdd ( _aLinPd 	, 	{ "C6_TES"  , _cTesCrmDv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem - Oferta
														Else	
															aAdd ( _aLinPd 	, 	{ "C6_TES"  , _cTesDaDv     		   					, Nil}) //TES utilizado no Pedido de Vendas das empresas Origem - Oferta
														EndIf															
													EndIf
													
													aAdd ( _aLinPd 	, 	{ "C6_LOCAL"   	, (_cAliQry)->B1_LOCPAD   				, Nil})
													aAdd ( _aLinPd 	, 	{ "C6_ENTREG"	, dDataBase				   				, Nil})
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
													//³Array contendo os itens do Documento de Entrada empresa Matriz³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
													aAdd(_alinhaDe	,	{"D1_ITEM"		, STRZERO(_nContOr,TAMSX3("D1_ITEM")[1]), Nil})
													aAdd(_alinhaDe	,	{"D1_COD"  		, (_cAliQry)->B1_COD					, Nil})
													//aAdd(_alinhaDe	,	{"D1_QUANT"		, _nQuant								, Nil})
													aAdd(_alinhaDe	,	{"D1_QUANT"		, nSaldoAux								, Nil})
													aAdd(_alinhaDe	,	{"D1_VUNIT"		, _nPrcVn								, Nil})
													//aAdd(_alinhaDe	,	{"D1_TOTAL"		, _nQuant *	_nPrcVn						, Nil})
													aAdd(_alinhaDe	,	{"D1_TOTAL"		, nSaldoAux *	_nPrcVn						, Nil})
													
													If _cParam1 == "2"
														aAdd(_alinhaDe	,	{"D1_TES"	, _cMvTsDe								, Nil}) //TES utilizado na nota de entrada das empresas Matriz - Venda
													Else
														aAdd(_alinhaDe	,	{"D1_TES"	, _cTesEn								, Nil}) //TES utilizado na nota de entrada das empresas Matriz - Oferta
													EndIf
													aAdd(_alinhaDe	,	{"D1_LOCAL"		, (_cAliQry)->B1_LOCPAD					, Nil})
													
													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÄÄÄÄHÄÄÄÄHÄÄÄÄH
													//³Calcular oos campos customizados de quantidade e valor total empresa Origem³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÄÄÄÄÄÄHÄÄÄÄÄÄHÄ
													//_nQdTtOr += _nQuant
													//_nVlTtOr += _nQuant * _nPrcVn

													_nQdTtOr += nSaldoAux
													_nVlTtOr += nSaldoAux * _nPrcVn
													
													nQuantAux	:= nQuantAux-nSaldoAux
													nSaldoAux	:= nQuantAux
													
													aadd(_aItmDcEn,_alinhaDe)
													aAdd(_aItmPd , _aLinPd  )
													_nContOr ++

													_aLinPd   := {}
													_alinhaDe := {}
																								
												EndDo          
												
											EndIf
											
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÄÄÄÄHÄÄÄÄHÄÄÄÄH
											//³Calcular oos campos customizados de quantidade e valor total empresa Matriz³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÄÄÄÄÄÄHÄÄÄÄÄÄHÄ
											_nQtdTot += _nQuant
											_nValTot += _nQuant * _nPrcVn
											
											_aLinPd   := {}
											_alinhaDe := {}
										Else
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
											//³Função para alimentar Log de erro³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
											_cMsg := "Valor informado na tabela de preço: " + AllTrim(_cMvTbPr) + " não pode ser menor ou igual a 0 (ZERO), produto: " + AllTrim((_cAliQry)->B1_COD)
											conout(Time()+ " " + _cMsg)
											MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod_"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
										EndIf
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
										//³Função para alimentar Log de erro³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
										_cMsg := "Não foi encontrado no sistema tabela de preço/produto com os códigos: " + AllTrim(_cMvTbPr) + " / " + AllTrim((_cAliQry)->B1_COD)
										conout(Time()+ " " + _cMsg)
										MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
									EndIf
									(_cAliQry)->(DbSkip())
								EndDo
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Alimentando o cabeçalho do Pedido de Vendas com as informações customizadas³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aAdd ( _aCabPv , { "C5_XQTDTOT"    , _nQtdTot      	, Nil} )
								aAdd ( _aCabPv , { "C5_XVALTOT"    , _nValTot      	, Nil} )
								aAdd ( _aCabPd , { "C5_XQTDTOT"    , _nQdTtOr      	, Nil} )
								aAdd ( _aCabPd , { "C5_XVALTOT"    , _nVlTtOr      	, Nil} )
								
								//Zerando as Variáveis
								_nQtdTot := 0
								_nValTot := 0
								_nQdTtOr := 0
								_nVlTtOr := 0
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Caso não tenha dado problema na regra de descontos³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								If Len(_aItmPv) > 0
									If !_lVcDesc
										
										//Realizando a geração da Nota de Saída para devolução de Consignação
										//na empresa Matriz (GEN)
										_cNtDvCon := U_GENA011B(_aCabPv,_aItmPv)     
																	
										//If !Empty(_cNtDvCon) .and. _cFornece <> "0378128"
										If !Empty(_cNtDvCon) .and. _cFornece <> "AAA"
											
											conout(Time()+ " " + "GENA011 - Chamada da funcao GENA011C")
											conout(Time()+ " " + "GENA011 - Inicio do RPC para logar na empresa origem Pedido/Nota de Saída")
											conout(Time()+ " " + "GENA011 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
																						
											_cTemp1 := U_GravArq1(_aItmPd)
											_cTemp2 := U_GravArq1(_aItmDcOr)

											SM0->(dbSetOrder(1))
											SM0->(dbSeek(_cEmpCd + _cEmpFl,.T.)) //Posiciona Empresa
													
											cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
											cFilAnt := SM0->M0_CODFIL
											OpenFile(cEmpAnt + cFilAnt)
											
											_cNotaImp	:= U_GENA011C(_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcInter)

											SM0->(dbSetOrder(1))
											SM0->(dbSeek("001022",.T.)) //Posiciona Empresa
													
											cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
											cFilAnt := SM0->M0_CODFIL
											OpenFile(cEmpAnt + cFilAnt)
																						
											/*
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Realizando a nova conexão para entrar na empresa e filial correta³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If ValType(_oServer) == "O"
												//Fecha a Conexao com o Servidor
												RESET ENVIRONMENT IN SERVER _oServer
												CLOSE RPCCONN _oServer
												_oServer := Nil
											EndIf
											
											conout(Time()+ " " + "GENA011 - Inicio do RPC para logar na empresa origem Pedido/Nota de Saída")
											conout(Time()+ " " + "GENA011 - Empresa: " + _cEmpCd + " Filial: " + _cEmpFl)
											
											
											_cTemp1 := U_GravArq1(_aItmPd)
											_cTemp2 := U_GravArq1(_aItmDcOr)                
																						
											CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
											PORT  _nPort           								;   //Porta de conexão do servidor
											ENVIRONMENT _cAmb       							;   //Ambiente do servidor
											EMPRESA _cEmpCd          							;   //Empresa de conexão
											FILIAL  _cEmpFl          							;   //Filial de conexão
											TABLES  "SC5,SC6,SA1,SF4,SB1,SE5,SA2,SC9,SF2,SD2"	;   //Tabela que serão abertas
											MODULO  "SIGAFAT"               					//Módulo de conexão
												
											If ValType(_oServer) == "O"
												
												conout(Time()+ " " + "GENA011 - Chamada da funcao GENA011C")
												
												_oServer:CallProc("RPCSetType", 2)
												_cNotaImp := ""
												_cNotaImp := _oServer:CallProc("U_GENA011C",_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcInter)
	 
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³Realizando a nova conexão para entrar na empresa e filial correta³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
												//Fecha a Conexao com o Servidor
												RESET ENVIRONMENT IN SERVER _oServer
												CLOSE RPCCONN _oServer
												_oServer := Nil
											Else
										   		conout(Time()+ " " + "GENA011 - Nao foi possivel logar. Retorno para empresa origem nao executado.")
											EndIf
											*/
											
											If !Empty(_cNotaImp)
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÆ
												//³Rotina que irá criar a Nota de Entrada/Pedido de Vendas e Nota de Saída na empresa GEN,
												//³após ter ocorrido com sucesso³
												//³a geração do pedido de vendas e da Nota de Saída para a empresa GEN                 ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÆ
												
												_lUpdate := .F. //Controla se deve ou não executar os updates
												
												If _cNotaImp <> "XXX"
													_lUpdate 	:=  U_GENA011D(_aCabDcEn,_aItmDcEn,_cNotaImp)
													_cNotaUpd	:= _cNotaImp 
													_cFilUpd	:= _cFil 
													
												ElseIf _cNotaImp == "XXX"
													_lUpdate	:= .T.
													_cNotaUpd	:= _cNtDvCon
													_cFilUpd	:= _cEmpFl
												Endif
												
												conout(Time()+ " " + "GENA011A - Inicio dos UPDATES para as notas com FLAG")
												
												//Verifica se pode fazer update
												If _lUpdate

													conout(Time()+ " " + "GENA011A - UPDATE da SZA")
												
													_cQuery := "UPDATE " + RetSqlName("SZA")
													_cQuery += " SET ZA_STATUS = '1' , ZA_LOTE = '"+_cUpLote+"'
													_cQuery += " ,ZA_TRACER = '"+Alltrim(_cEmpFl)+_cMvSeri+_cNotaImp+"'
													_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
													_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
													_cQuery += " AND ZA_PROC = '"+cFornInter+"'
													_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
													_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
													_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
													_cQuery += " AND ZA_STATUS = ' '
													_cQuery += " AND ZA_COD IN (SELECT SD1.D1_COD "
													_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
													_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFilUpd + "' "
													_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaUpd + "' "
													_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
													_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
													_cQuery += " AND D_E_L_E_T_ = ' '
																										
													If TCSQLEXEC(_cQuery) != 0
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "0 - Não foi possivel realizar o update na SZA após a execucao da Prestacao de Contas lote: " + _cUpLote + cEnt
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
													EndIf
													
													//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
													/*
													_cQuery := "UPDATE " + RetSqlName("SD2")
													_cQuery += " SET D2_XCONSIG = 'S'
													_cQuery += " WHERE D2_FILIAL  = '" + _cFil + "'
													_cQuery += " AND D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
													_cQuery += " AND D2_TES IN ('" + _cTesPr + "')
													_cQuery += " AND D2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
													_cQuery += " AND D_E_L_E_T_ = ' '
													*/
													
													conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de saida SD2")
												
													_cQuery := "UPDATE " + RetSqlName("SD2")
													_cQuery += " SET D2_XCONSIG = 'S' , D2_XLOTE = '"+_cUpLote+"'
													_cQuery += " ,D2_XTRACER = '"+Alltrim(_cEmpFl)+_cMvSeri+_cNotaImp+"'
													_cQuery += " WHERE D2_FILIAL  = '" + _cFil + "' "
													_cQuery += " AND D2_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
													_cQuery += " AND D2_TES IN ('" + _cTesPr + "')
													_cQuery += " AND D2_COD IN (SELECT SD1.D1_COD "
													_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
													_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFilUpd + "' "
													_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaUpd + "' "
													_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
													_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
													_cQuery += " AND D_E_L_E_T_ = ' '
													
													If TCSQLEXEC(_cQuery) != 0
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "1 - Não foi possivel realizar o update na SD2(Itens da Nota de Saida) após a execucao da Prestacao de Contas lote: " + _cUpLote + cEnt
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
													EndIf
													
													conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de entrada SD1")
													
													//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
													/*
													_cQuery := "UPDATE " + RetSqlName("SD1")
													_cQuery += " SET D1_XCONSIG = 'S'
													_cQuery += " WHERE D1_FILIAL  = '" + _cFil + "'
													_cQuery += " AND D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
													_cQuery += " AND D1_TES IN ('" + _cTesPr + "')
													_cQuery += " AND D1_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
													_cQuery += " AND D_E_L_E_T_ = ' '
													*/
													
													_cQuery := "UPDATE " + RetSqlName("SD1")
													_cQuery += " SET D1_XCONSIG = 'S', D1_XLOTE = '"+_cUpLote+"'
													_cQuery += " ,D1_XTRACER = '"+Alltrim(_cEmpFl)+_cMvSeri+_cNotaImp+"'
													_cQuery += " WHERE D1_FILIAL  = '" + _cFil + "' "
													_cQuery += " AND D1_EMISSAO BETWEEN '" + DTOS(FirstDay(dDatabase)) + "' AND '" + DTOS(LastDay(ddatabase)) + "'
													_cQuery += " AND D1_TES IN ('" + _cTesPr + "')
													_cQuery += " AND D1_COD IN (SELECT SD1.D1_COD "
													_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
													_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFilUpd + "' "
													_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaUpd + "' "
													_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
													_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
													_cQuery += " AND D_E_L_E_T_ = ' '
													
													If TCSQLEXEC(_cQuery) != 0
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "Não foi possivel realizar o update na SD1(Itens da Nota de Entrada) após a execucao da Prestacao de Contas lote: " + _cUpLote + cEnt
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
													EndIf
													
													conout(Time()+ " " + "GENA011A - UPDATE dos Itens nota de saida SD2 CANCELADAS")
													
													//RAFAEL LEITE - 27/01/2015 - ALTERADO PARA ATUALIZAR SOMENTE OS PRODUTOS CONTIDOS NA NOTA FISCAL
													/*
													_cQuery := "UPDATE " + RetSqlName("SD2")
													_cQuery += " SET D2_XCONSIG = 'C'
													_cQuery += " WHERE D2_FILIAL = '" + _cFil + "'
													_cQuery += " AND D2_XCONSIG = 'S'
													_cQuery += " AND D_E_L_E_T_ = '*'
													_cQuery += " AND D2_COD IN (SELECT B1_COD FROM "+RetSqlName("SB1")+" WHERE B1_PROC	= '" + _cForUp + "' AND B1_LOJPROC = '" + _cLojUp + "' AND D_E_L_E_T_ = ' ')
													*/
													
													_cQuery := "UPDATE " + RetSqlName("SD2")
													_cQuery += " SET D2_XCONSIG = 'C', D2_XLOTE = '"+_cUpLote+"'
													_cQuery += " ,D2_XTRACER = '"+Alltrim(_cEmpFl)+_cMvSeri+_cNotaImp+"' 
													_cQuery += " WHERE D2_FILIAL = '" + _cFil + "'
													_cQuery += " AND D2_XCONSIG = 'S'
													_cQuery += " AND D_E_L_E_T_ = '*'
													_cQuery += " AND D2_COD IN (SELECT SD1.D1_COD "
													_cQuery += " 				FROM "+RetSqlName("SD1")+" SD1 "
													_cQuery += " 				WHERE SD1.D1_FILIAL = '" + _cFil + "' "
													_cQuery += " 				AND SD1.D1_DOC = '" + _cNotaImp + "' "
													_cQuery += " 				AND SD1.D1_SERIE = '" + _cMvSeri + "' "
													_cQuery += " 				AND SD1.D_E_L_E_T_ = ' ')
													
													If TCSQLEXEC(_cQuery) != 0
														//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														//³Função para alimentar Log de erro³
														//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
														_cMsg := "2 - Não foi possivel realizar o update na SD2(Itens da Nota de Entrada) Canceladas após a execucao da Prestacao de Contas lote: " + _cUpLote + cEnt
														conout(Time()+ " " + _cMsg)
														MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consignação.txt" , _cMsg )
													EndIf
												
													conout(Time()+ " " + "GENA011A - Fim dos UPDATES para as notas com FLAG")
												Else
												
													_cMsg := "FLAG não atualizado para o lote: " + _cUpLote + cEnt
													conout(Time()+ " " + _cMsg)
													MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "FLAG NAO ATUALIZADO LOTE_"+_cUpLote+".txt" , _cMsg )	
												Endif	
											EndIf
										
										//Elseif !Empty(_cNtDvCon) .and. _cFornece == "0378128" 
										Elseif !Empty(_cNtDvCon) .and. _cFornece == "AAA" 
										
											conout(Time()+ " " + "GENA011A - UPDATE da SZA - ATL")
													
											_cQuery := "UPDATE " + RetSqlName("SZA")
											_cQuery += " SET ZA_STATUS = '1' , ZA_LOTE = '"+_cUpLote+"'
											_cQuery += " ,ZA_TRACER = '"+Alltrim(_cEmpFl)+_cMvSeri+_cNotaImp+"'
											_cQuery += " WHERE ZA_FILIAL  = '"+xFilial("SZA")+"' 
											_cQuery += " AND ZA_REF = '"+DtoS(dProcInter)+"'
											_cQuery += " AND ZA_PROC = '"+cFornInter+"'
											_cQuery += " AND ZA_LOJPROC = '"+cLojaInter+"'
											_cQuery += " AND ZA_TIPO = '"+_cParam1+"'
											_cQuery += " AND ZA_TPOFER = '"+cTipoOfert+"'
											_cQuery += " AND ZA_STATUS = ' '
											_cQuery += " AND ZA_COD IN (SELECT SD2.D2_COD "
											_cQuery += " 				FROM "+RetSqlName("SD2")+" SD2 "
											_cQuery += " 				WHERE SD2.D2_FILIAL = '1022' "
											_cQuery += " 				AND SD2.D2_DOC = '" + _cNtDvCon + "' "
											_cQuery += " 				AND SD2.D2_SERIE = '" + _cMvSeri + "' "
											_cQuery += " 				AND SD2.D_E_L_E_T_ = ' ')
											_cQuery += " AND D_E_L_E_T_ = ' '
											
											conout(_cQuery)
																								
											If TCSQLEXEC(_cQuery) != 0
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
												//³Função para alimentar Log de erro³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
												_cMsg := "0 - Não foi possivel realizar o update na SZA-ATL após a execucao da Prestacao de Contas lote: " + _cUpLote + cEnt
												conout(Time()+ " " + _cMsg)
												MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Update.txt" , _cMsg )
											EndIf
										EndIf
									EndIf
								Else								
										
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
									//³Função para alimentar Log de erro³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
									_cMsg := "Produto:  " + AllTrim((_cAliQry)->B1_COD) + " não processado"
									conout(Time()+ " " + _cMsg)
									MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
									//(_cAliQry)->(DbSkip())
								EndIf
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
								//³Função para alimentar Log de erro³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
								_cMsg := "A Tabela de preço:  " + AllTrim(_cMvTbPr) + " encontra-se vencida, favor verifica. "
								conout(Time()+ " " + _cMsg)
								MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
								(_cAliQry)->(DbSkip())
							EndIf
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
							//³Função para alimentar Log de erro³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
							_cMsg := "Não foi encontrado no sistema tabela de preço com o código: " + AllTrim(_cMvTbPr)
							conout(Time()+ " " + _cMsg)
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
							(_cAliQry)->(DbSkip())
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
						//³Função para alimentar Log de erro³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
						_cMsg := "Não foi encontrado no sistema empresa (SM0) com o CNPJ: " + SA2->A2_CGC
						conout(Time()+ " " + _cMsg)
						MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + ".txt" , _cMsg )
						(_cAliQry)->(DbSkip())
					EndIf
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
					//³Função para alimentar Log de erro³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
					_cMsg := "Não foi encontrado no sistema Cliente com o CNPJ: " + _cCGCOr
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
					(_cAliQry)->(DbSkip())
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
				//³Função para alimentar Log de erro³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
				_cMsg := "Não foi encontrado no sistema fornecedor com o código: " + (_cAliQry)->B1_PROC + " e loja: " + (_cAliQry)->B1_LOJPROC  + ", vinculados ao produto: " + (_cAliQry)->B1_COD
				conout(Time()+ " " + _cMsg)
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil "+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Prod"  + AllTrim((_cAliQry)->B1_COD) + ".txt" , _cMsg )
				(_cAliQry)->(DbSkip())
			EndIf
		EndDo
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
		//³Função para alimentar Log de erro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
		_cMsg := "Não foi encontrado no sistema associação do Cliente com o Fornecedor através do CGC cadastrado nos parametros de Consignação." + cEnt
		_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
		_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
		conout(Time()+ " " + _cMsg)
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consignação.txt" , _cMsg )
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
	//³Função para alimentar Log de erro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄI
	_cMsg := "Não foi encontrado no sistema o cliente cadastrado nos parametros de Consignação." + cEnt
	_cMsg += "Cliente: " + AllTrim(_cMvClDe) + " loja: " + AllTrim(_cMvLjDe) + cEnt
	_cMsg += "Favor verificar os parametros: GEN_FAT015 e GEN_FAT016" + cEnt
	conout(Time()+ " " + _cMsg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + "Consignação.txt" , _cMsg )
EndIf

If Select(_cAliQry) > 0
	dbSelectArea(_cAliQry)
	(_cAliQry)->(dbCloseArea())
EndIf

conout(Time()+ " " + "GENA011A - Fim - Verificando Itens da Nota de Entrada")
RestArea(_aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA011B  ºAutor  ³Angelo Henrique     º Data ³  17/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsável por gerar a Nota Fiscal de Saída para    º±±
±±º          ³devolução da Consignação - Prestação de Contas              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA011B(_aCabPv,_aItmPv)

Local _aArea 			:= GetArea()
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1 			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cPedExc			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _nPosLb			:= aScan(_aItmPv[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })

Local _cLogPd			:= GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT087") //SERIE nota de saída

Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponteramento nas tabelas para não ocorrer erro no execauto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SA1")
DbSelectArea("SA2")

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA011B - Rotina para execução do Execauto de Geração do Pedido de Vendas e de Geração do Documento de Saída, empresa Matriz (GEN)")

Pergunte("MTA440",.F.)
MV_PAR02	:= 2
lLiber	:= .F.

lMsErroAuto := .F.
MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,3)

If !lMsErroAuto
	
	conout(Time()+ " " + "GENA011B - Gerou com sucesso o pedido, irá ver se existe a necessidade de desbloquear por crédito na empresa Matriz (GEN)")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³ Inicio Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9") + SC5->C5_NUM)
		
		bValid := {|| .T.}
		
		_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO "
		_cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
		_cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
		_cQuery += "SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND "
		_cQuery += "(SC9.C9_BLEST <> '  ' OR "
		_cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
		_cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
		_cQuery += "SC9.C9_BLEST <> '10' AND "
		_cQuery += "SC9.D_E_L_E_T_ = ' ' "
		
		If Select(_cAliSC9) > 0
			dbSelectArea(_cAliSC9)
			(_cAliSC9)->(dbCloseArea())
		EndIf
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
		conout(Time()+ " " + "GENA011B - Ira varrer a SC9 para realizar o desbloqueio por crédito na empresa Matriz (GEN)")
		
		While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
				SC9->C9_BLCRED=="09" )
				conout(Time()+ " " + "GENA011B - Liberação de Crédito do Pedido de Vendas na empresa Matriz (GEN)")
				
				/*/
				±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
				±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
				±±³          ³       2 - Rejeicao                                          ³±±
				±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
				±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
				±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
				±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
				±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
				±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
				±±³          ³venda com base na tabela SC9.                                ³±±
				ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
				/*/
				//a450Grava(1,.T.,.F.,.F.)
				a450Grava(1,.T.,.T.,.F.)  //04/02 - RAFAEL LEITE - EFETUA TAMBEM A LIBERACAO DE ESTOQUE
			EndIf
			(_cAliSC9)->(DbSkip())
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³ Fim    Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	//'Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota   '*
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ	DbSelectArea("SC9")
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		
		_cPedExc := SC9->C9_PEDIDO
		conout(Time()+ " " + "GENA011B - Inicio da Geração do Documento de Saída na empresa Matriz (GEN).")
		
		//Controle das quantidades liberadas
		_nConfLib := 0
		_nConfVen := 0
		
		While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
			
			_nConfLib += SC9->C9_QTDLIB
			_nConfVen += SC6->C6_QTDVEN
			
			_aTmpPV1 := {}
			aAdd( _aTmpPV1, SC9->C9_PEDIDO	)
			aAdd( _aTmpPV1, SC9->C9_ITEM 	)
			aAdd( _aTmpPV1, SC9->C9_SEQUEN	)
			aAdd( _aTmpPV1, SC9->C9_QTDLIB	)
			aAdd( _aTmpPV1, SC9->C9_PRCVEN	)
			aAdd( _aTmpPV1, SC9->C9_PRODUTO	)
			aAdd( _aTmpPV1, SF4->F4_ISS=="S")
			aAdd( _aTmpPV1, SC9->(RECNO())	)
			aAdd( _aTmpPV1, SC5->(RECNO())	)
			aAdd( _aTmpPV1, SC6->(RECNO())	)
			aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
			aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
			aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
			aAdd( _aTmpPV1, SF4->(RECNO(POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,""))))
			aAdd( _aTmpPV1, SC9->C9_LOCAL	)
			aAdd( _aTmpPV1, 1				)
			aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
			
			aAdd( _aPVlNFs, aClone(_aTmpPV1))
			
			DbSelectArea("SC9")
			DbSkip()
		EndDo
		
		conout(Time()+ " " + "GENA011B - Ira realizar a geracao da nota de saida na empresa Matriz (GEN) ")
		
		*'---------------------------------------------------------'*
		*'Rotina utilizada para realizar a geração da Nota de Saída'*
		*'---------------------------------------------------------'*
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Validação da especie para a nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nMvEsp := 0
		_aPosEsp := {}
		
		For _ni := 1 To Len(_cMvEsp)
			If SubStr(_cMvEsp,_ni,1) == ";"
				_nMvEsp := _ni
			EndIf
			
			If _nMvEsp = 0
				If SubStr(_cMvEsp,_ni,1) == "="
					aAdd(_aPosEsp,{SubStr(_cMvEsp,1,_ni-1)})
				EndIf
			Else
				If SubStr(_cMvEsp,_ni,1) == "="
					aAdd(_aPosEsp,{Replace(AllTrim(SubStr(_cMvEsp,_nMvEsp+1,_ni-(_nMvEsp+1))),"=")})
				EndIf
			EndIf
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtP¿
		//³Varrendo o vetor que contem as séries para saber se a série contida³
		//³no parametro esta correta.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtPÙ
		
		_lEspec := .F.
		For _ni := 1 To Len(_aPosEsp)
			If _aPosEsp[_ni][1] == _cMvSeri
				_lEspec := .T.
			EndIf
		Next
		
		//_cPedExc := SC9->C9_PEDIDO
		//If _lEspec
		
		If _lEspec .and. _nConfLib == _nConfVen // 04/02 RAFAEL LEITE - VERIFICA QUANTIDADE LIBERADA
			
			_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
			
		Elseif !_lEspec
			
			_cNotaImp := ""
			_cMsg := "A Nota não foi gerada, pois a serie não esta preenchida corretamente." + cEnt
			_cMsg += "Favor revisar o parametro GEN_FAT003." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
			
		Elseif !_nConfLib == _nConfVen //04/02 - RAFAEL LEITE
			
			_cNotaImp := ""
			_cMsg := "A quantidade liberada esta diferente da informada no pedido." + cEnt
			conout(Time()+ " " + _cMsg)
			MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso a nota não seja gerado irá chamar a rotina de erro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(AllTrim(_cNotaImp))
			conout(Time()+ " " + "GENA011B - Geração do Documento de Saída na empresa Matriz (GEN) apresentou erro .")
			//_cPedExc := SC9->C9_PEDIDO
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamando o Execauto de Alteração e em seguida o de exclusão³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Alterando a quantidade liberada³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For _ni := 1 To Len(_aItmPv)
				_aItmPv[_ni][_nPosLb][2] := 0
			Next _ni
			
			conout(Time()+ " " + "GENA011B - Irá alterar o pedido de vendas para poder realizar a exclusão na empresa Matriz (GEN)")

			Pergunte("MTA440",.F.)
			MV_PAR02	:= 2
			lLiber	:= .F.
			
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,4)
			
			If !lMsErroAuto
				conout(Time()+ " " + "GENA011B - Alterou o pedido de vendas com sucesso, irá realizar a exclusão na empresa Matriz (GEN).")
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPv,_aItmPv,5)
				
				If !lMsErroAuto
					conout(Time()+ " " + "GENA011B - Excluiu com sucesso o pedido de vendas na empresa Matriz (GEN).")
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				Else
					conout(Time()+ " " + "GENA011B - Não conseguiu excluir o pedido de vendas na empresa Matriz (GEN).")
					
					_aErro := GetAutoGRLog()
					For _ni := 1 To Len(_aErro)
						_cErroLg += _aErro[_ni] + cEnt
					Next _ni
					
					_cErroLg += "  " + cEnt
					_cErroLg += " O Pedido: " + _cPedExc + " não pode ser excluído. "  + cEnt
					_cErroLg += " Favor verificar o pedido: "  + cEnt
					_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
					_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
					_cErroLg += " " + cEnt
					MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
				EndIf
			Else
				conout(Time()+ " " + "GENA011B - Não conseguiu alterar o pedido de vendas na empresa Matriz (GEN).")
				
				_aErro := GetAutoGRLog()
				For _ni := 1 To Len(_aErro)
					_cErroLg += _aErro[_ni] + cEnt
				Next _ni
				
				_cErroLg += "  " + cEnt
				_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " não pode ser alterado para prosseguir com a exclusão. "  + cEnt
				_cErroLg += " Favor verificar o pedido: "  + cEnt
				_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
				_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
				_cErroLg += " " + cEnt
				MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
			EndIf
		EndIf
	EndIf
Else
	conout(Time()+ " " + "GENA011B - Não conseguiu gerar o Pedido de Vendas na empresa Matriz (GEN). ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
	Next _ni                          
	conout(_cErroLg)
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil  + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedido.txt" , _cErroLg )
	Disarmtransaction()
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA011C  ºAutor  ³Angelo Henrique     º Data ³  17/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que irá gerar a Nota fiscal de entrada para devolucaoº±±
±±º          ³da consignação e a Nota Fiscal de Saída de Venda.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA011C(_aCabPd,_cTemp1,_aCabDcOr,_cTemp2,_cNtDvCon,dProcPed)

Local _aArea 			:= GetArea()
Local _cQuery			:= ""
Local _cAliSC9			:= GetNextAlias()
Local _aTmpPV1			:= {}
Local _aPVlNFs			:= {}
Local _cNotaImp			:= ""
Local _cMsg				:= ""
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _nPosLb			:= 0
Local _cPedExc			:= ""
Local _cLogPd			:= GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro
Local _cMvSeri 			:= GetMv("GEN_FAT087") //SERIE nota de saída
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)
Local _cMvEsp			:= GetMv("MV_ESPECIE") //Contem tipos de documentos fiscais utilizados na emissao de notas fiscais
Local _aPosEsp 			:= {}
Local _nMvEsp 			:= 0
Local _lEspec			:= .F.
Local _aItmPd   		:= {}
Local _aItmDcOr   		:= {}

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

conout(Time()+ " " + "GENA011C - Inicio Rotina")

//Ajusta data base para facilitar execucao retroativa
dDataBase := dProcPed // 03/02 - RAFAEL LEITE

If File(_cTemp1)
	_aItmPd := u_LeArq1(_cTemp1)
Endif

If File(_cTemp2)
	_aItmDcOr := u_LeArq1(_cTemp2)
Endif

DbSelectArea("SC5")
DbSetOrder(1)

conout(Time()+ " " + "GENA011C - Rotina de Geração da Nota Fiscal de Entrada (Devolução da Consignação) e Geração da Nota Fiscal de Saída da Venda na empresa Origem ")
conout(Time()+ " " + "GENA011C - Primeiro a Geração da Nota Fiscal de Entrada (Devolução da Consignação) da empresa origem")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcOr, { "F1_DOC"       ,_cNtDvCon })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcOr, _aItmDcOr,3)

If lMsErroAuto
	_lRet := .F.
	conout(Time()+ " " + "GENA011C - Não conseguiu gerar a Nota Fiscal de Entrada (Devolução da Consignação) na empresa origem. ")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	Disarmtransaction()
EndIf

conout(Time()+ " " + "GENA011C - Segundo a Geração da Nota Fiscal de Saída caso o saldo não seja negativo da empresa origem .")

If Len(_aItmPd) > 0 .And. !lMsErroAuto
	
	conout(Time()+ " " + "GENA011C - Geração da Nota Fiscal de Saída, empresa origem. ")
	
	_nPosLb	:= aScan(_aItmPd[1], { |x| Alltrim(x[1]) == "C6_QTDLIB" })
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄri@&:x´[¿
	//³Forcar o ponteramento no produto para não dar erro no execauto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄril(:x´[Ù
	DbSelectArea("SB1")

	Pergunte("MTA440",.F.)
	MV_PAR02	:= 2
	lLiber	:= .F.
		
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,3)
	If !lMsErroAuto
		conout(Time()+ " " + "GENA011C - Gerou com sucesso o pedido, irá ver se existe a necessidade de desbloquear por crédito, empresa origem")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
		//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
		DbSelectArea("SC9")
		DbSetOrder(1)
		
		SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
		While SC9->(!Eof()) .and. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9") + SC5->C5_NUM
			SC9->(a460Estorna())
			SC9->(DbSkip())
		Enddo	
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina para desbloquear crédito para que o pedido seja faturado sem problemas³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Posiciona na SC9 para confirmar que o pedido foi gravado na tabela
		DbSelectArea("SC9")
		DbSetOrder(1)
		If !DbSeek(xFilial("SC9") + SC5->C5_NUM)
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"  
			SC5->(msUnlock())

			SC6->(DbSetOrder(1)) 
			SC6->(DbSeek(xFilial("SC5") + SC5->C5_NUM))
			While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
					
				RecLock("SC6",.F.)
				SC6->C6_QTDLIB := MaLibDoFat(SC6->(Recno()),SC6->C6_QTDVEN)						 
				SC6->(msUnlock()) 
						
				SC6->(DbSkip())
			EndDo						
		EndIF
				
		If DbSeek(xFilial("SC9") + SC5->C5_NUM)
			bValid := {|| .T.}
			
			_cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO "
			_cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
			_cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
			_cQuery += "SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND "
			_cQuery += "(SC9.C9_BLEST <> '  ' OR "
			_cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
			_cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
			_cQuery += "SC9.C9_BLEST <> '10' AND "
			_cQuery += "SC9.D_E_L_E_T_ = ' ' "
			
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliSC9,.T.,.T.)
			conout(Time()+ " " + "GENA011C - Irá varrer a SC9, desbloqueio por crédito, empresa origem")
			
			While ( (_cAliSC9)->(!Eof()) .And. (_cAliSC9)->C9_FILIAL == xFilial("SC9") .And. (_cAliSC9)->C9_PEDIDO == SC5->C5_NUM .And. Eval(bValid) )
				If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .OR. (SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .OR.;
					SC9->C9_BLCRED=="09" )
					
					conout(Time()+ " " + "GENA011C - Liberação de Crédito do Pedido de Vendas na empresa origem")
					
					/*/
					±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
					±±³          ³       2 - Rejeicao                                          ³±±
					±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
					±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
					±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
					±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
					±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
					±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
					±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
					±±³          ³venda com base na tabela SC9.                                ³±±
					ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
					/*/
					a450Grava(1,.T.,.F.,.F.)
				EndIf
				(_cAliSC9)->(DbSkip())
			EndDo
			
			*'-----------------------------------------------------------------------------------------------------'*
			*'Inicio - Caso tenha ocorrido com sucesso a geração do Pedido de Vendas, irá iniciar a geração da Nota'*
			*'-----------------------------------------------------------------------------------------------------'*
			DbSelectArea("SC9")
			DbSetOrder(1)
			If DbSeek(xFilial("SC9")+SC5->C5_NUM)
				_cPedExc := SC9->C9_PEDIDO
				conout(Time()+ " " + "GENA011C - Inicio da Geração do Documento de Saída de vendas na empresa origem")
				While SC9->(!EOF()) .And. SC9->C9_PEDIDO == SC5->C5_NUM
					DbSelectArea("SC6")
					DbSetOrder(1)
					DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
					_aTmpPV1 := {}
					aAdd( _aTmpPV1, SC9->C9_PEDIDO	)
					aAdd( _aTmpPV1, SC9->C9_ITEM 	)
					aAdd( _aTmpPV1, SC9->C9_SEQUEN	)
					aAdd( _aTmpPV1, SC9->C9_QTDLIB	)
					aAdd( _aTmpPV1, SC9->C9_PRCVEN	)
					aAdd( _aTmpPV1, SC9->C9_PRODUTO	)
					aAdd( _aTmpPV1, SF4->F4_ISS=="S")
					aAdd( _aTmpPV1, SC9->(RECNO())	)
					aAdd( _aTmpPV1, SC5->(RECNO())	)
					aAdd( _aTmpPV1, SC6->(RECNO())	)
					aAdd( _aTmpPV1, SE4->(RECNO(POSICIONE("SE4",1,xFilial("SE4")+"001"				,""))))
					aAdd( _aTmpPV1, SB1->(RECNO(POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO	,""))))
					aAdd( _aTmpPV1, SB2->(RECNO(POSICIONE("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO	,""))))
					aAdd( _aTmpPV1, SF4->(RECNO(POSICIONE("SF4",1,xFilial("SF4")+SC6->C6_TES		,""))))
					aAdd( _aTmpPV1, SC9->C9_LOCAL	)
					aAdd( _aTmpPV1, 1				)
					aAdd( _aTmpPV1, SC9->C9_QTDLIB2	)
					
					aAdd( _aPVlNFs, aClone(_aTmpPV1))
					
					DbSelectArea("SC9")
					DbSkip()
				EndDo
				
				*'------------------------------------------------'*
				*'Rotina utilizada para realizar a geração da Nota'*
				*'------------------------------------------------'*
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Validação da especie para a nota³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_nMvEsp := 0
				_aPosEsp := {}
				
				For _ni := 1 To Len(_cMvEsp)
					If SubStr(_cMvEsp,_ni,1) == ";"
						_nMvEsp := _ni
					EndIf
					If _nMvEsp = 0
						If SubStr(_cMvEsp,_ni,1) == "="
							aAdd(_aPosEsp,{SubStr(_cMvEsp,1,_ni-1)})
						EndIf
					Else
						If SubStr(_cMvEsp,_ni,1) == "="
							aAdd(_aPosEsp,{Replace(AllTrim(SubStr(_cMvEsp,_nMvEsp+1,_ni-(_nMvEsp+1))),"=")})
						EndIf
					EndIf
				Next
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtP¿
				//³Varrendo o vetor que contem as séries para saber se a série contida³
				//³no parametro esta correta.                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄtPÙ
				
				_lEspec := .F.
				lLibOk	:= .F.
				
				For _ni := 1 To Len(_aPosEsp)
					If _aPosEsp[_ni][1] == _cMvSeri
						_lEspec := .T.
					EndIf
				Next
                
				If _lEspec
					If Select("VLD_LIBE") > 0
						VLD_LIBE->(DbCloseArea())
					EndIf
	
					Beginsql Alias "VLD_LIBE"
						SELECT * FROM %Table:SC6% SC6
						WHERE C6_FILIAL = %Exp:SC5->C5_FILIAL%
						AND C6_NUM = %Exp:SC5->C5_NUM%
						AND SC6.%NotDel%
						AND C6_QTDVEN <> (
						  SELECT SUM(C9_QTDLIB) FROM %Table:SC9% SC9
						  WHERE C9_FILIAL = C6_FILIAL
						  AND C9_PEDIDO = C6_NUM
						  AND C9_PRODUTO = C6_PRODUTO
						  AND C9_ITEM = C6_ITEM
						  AND SC9.%NotDel%
						)
					EndSql
					
					VLD_LIBE->(DbGoTop())
					If VLD_LIBE->(!EOF())
						VLD_LIBE->(DbCloseArea())
						lLibOk := .F. 
					Else
						lLibOk	:= .T.
						VLD_LIBE->(DbCloseArea())	
					EndIf
					
				EndIf
				
				//_cPedExc := SC9->C9_PEDIDO
				If _lEspec .AND. lLibOk
					_cNotaImp := MaPVlNFs(_aPVlNFs,_cMvSeri,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,)
				ElseIf !_lEspec .AND. lLibOk
					_cNotaImp := ""
					_cMsg := "A Nota não foi gerada, pois a serie não esta preenchida corretamente." + cEnt
					_cMsg := "Favor revisar o parametro GEN_FAT003." + cEnt
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )
				ElseIf _lEspec .AND. !lLibOk
					_cNotaImp := ""
					_cMsg := "A Nota não foi gerada, pois a quantidade liberada está diferente da quantidade informada no pedido." + cEnt
					conout(Time()+ " " + _cMsg)
					MemoWrite ( _cLogPd + "Emp_" + _cEmp + " Fil_" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped_" + _cPedExc + ".txt" , _cMsg )											
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Caso a nota não seja gerado irá chamar a rotina de erro³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty(AllTrim(_cNotaImp))
					_cNotaImp := ""
					conout(Time()+ " " + "GENA011C - Geração do Documento de Saída de venda apresentou erro na empresa origem.")
					//_cPedExc := SC9->C9_PEDIDO
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Chamando o Execauto de Alteração e em seguida o de exclusão³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Alterando a quantidade liberada³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For _ni := 1 To Len(_aItmPd)
						_aItmPd[_ni][_nPosLb][2] := 0
					Next _ni
					conout(Time()+ " " + "GENA011C - Irá alterar o pedido de vendas para poder realizar a exclusão na empresa origem.")
					
					lMsErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,4)
					If !lMsErroAuto
						conout(Time()+ " " + "GENA011C - Alterou o pedido de vendas com suceeso, irá realizar a exclusão, empresa origem.")
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabPd,_aItmPd,5)
						If !lMsErroAuto
							conout(Time()+ " " + "GENA011B - Excluiu com sucesso o pedido de vendas na empresa origem.")
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " foi excluído com sucesso. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " Pois ele teve que ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
						Else
							conout(Time()+ " " + "GENA011C - Não conseguiu excluir o pedido de vendas na empresa origem.")
							_aErro := GetAutoGRLog()
							For _ni := 1 To Len(_aErro)
								_cErroLg += _aErro[_ni] + cEnt
							Next _ni
							
							_cErroLg += "  " + cEnt
							_cErroLg += " O Pedido: " + _cPedExc + " não pode ser excluído. "  + cEnt
							_cErroLg += " Favor verificar o pedido: "  + cEnt
							_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
							_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
							_cErroLg += " " + cEnt
							
							MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
						EndIf
					Else
						conout(Time()+ " " + "GENA011C - Não conseguiu alterar o pedido de vendas na empresa origem.")
						_aErro := GetAutoGRLog()
						For _ni := 1 To Len(_aErro)
							_cErroLg += _aErro[_ni] + cEnt
						Next _ni
						_cErroLg += "  " + cEnt
						_cErroLg += " O Pedido: " + SC9->C9_PEDIDO + " não pode ser alterado para prosseguir com a exclusão. "  + cEnt
						_cErroLg += " Favor verificar o pedido: "  + cEnt
						_cErroLg += " pois ele deve ser excluído uma vez que o Documento de Saída não foi gerado corretamente. " + cEnt
						_cErroLg += " Favor verificar a geração do Documento de Saída, pois no processo houve erro. " + cEnt
						_cErroLg += " " + cEnt
						MemoWrite ( _cLogPd + "Emp" +SM0->M0_CODIGO + " Fil"+ AllTrim(SM0->M0_CODFIL) + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " Ped" + _cPedExc + ".txt" , _cMsg )
					EndIf
				EndIf
			EndIf
			If Select(_cAliSC9) > 0
				dbSelectArea(_cAliSC9)
				(_cAliSC9)->(dbCloseArea())
			EndIf
		Else
			conout(Time()+ " " + "GENA011C - Não conseguiu gerar o Pedido de Vendas na empresa origem. ")
			_aErro := GetAutoGRLog()
			For _ni := 1 To Len(_aErro)
				_cErroLg += _aErro[_ni] + cEnt
				conout(_cErroLg)
			Next _ni
			MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedidoVenda.txt" , _cErroLg )
			Disarmtransaction()
		EndIf
	Else
		conout(Time()+ " " + "GENA011C - Não conseguiu gerar o Pedido de Vendas na empresa origem. anota de entrada "+_cNtDvCon+" deve ser excluida ")
		_aErro := GetAutoGRLog()
		For _ni := 1 To Len(_aErro)
			_cErroLg += _aErro[_ni] + cEnt
			conout(_cErroLg)
		Next _ni
		MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil"+ _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraPedidoVenda.txt" , _cErroLg )
		Disarmtransaction()		
	EndIf
ElseIf Len(_aItmPd) == 0 .And. !lMsErroAuto
	_cNotaImp := "XXX"
EndIf

RestArea(_aArea)

Return _cNotaImp


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA011D  ºAutor  ³Angelo Henrique     º Data ³  17/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que irá realizar a geração da Nota Fiscal de        º±±
±±º          ³Entrada de Vendas na empresa Matriz (GEN)                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA011D(_aCabDcEn,_aItmDcEn,_cNotaImp)

Local _aArea 			:= GetArea()
Local _aErro			:= {}
Local _cErroLg			:= ""
Local _cEmp				:= AllTrim(SM0->M0_CODIGO)
Local _cFil				:= AllTrim(SM0->M0_CODFIL)

Local _cLogPd			:= GetMv("GEN_FAT016") //Contém o caminho que será gravado o log de erro

Private lMsErroAuto		:= .F.
Private lMsHelpAuto		:= .T.
Private lAutoErrNoFile 	:= .T.

conout(Time()+ " " + "GENA011D - Geração da Nota Fiscal de Entrada de Vendas,  empresa Matriz (GEN)")

DbSelectArea("SA1")
DbSelectArea("SA2")

aAdd( _aCabDcEn, { "F1_DOC" ,_cNotaImp })
MSExecAuto({|x,y,z|MATA103(x,y,z)},_aCabDcEn, _aItmDcEn,3)

If lMsErroAuto
	conout(Time()+ " " + "GENA011D - Não foi possível gerar a Nota Fiscal de Entrada de Vendas na empresa Matriz.")
	_aErro := GetAutoGRLog()
	For _ni := 1 To Len(_aErro)
		_cErroLg += _aErro[_ni] + cEnt
		conout(_cErroLg)
	Next _ni
	MemoWrite ( _cLogPd + "Emp" + _cEmp + " Fil" + _cFil + " " + STRTRAN(DTOC(ddatabase),"/","_") + " " + SUBSTR(STRTRAN(Time(),":",""),1,4) + " GeraDocEntrada.txt" , _cErroLg )
	Disarmtransaction()
EndIf

RestArea(_aArea)

Return (!lMsErroAuto)
