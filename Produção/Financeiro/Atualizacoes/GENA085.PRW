#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt	Chr(13)+chr(10)

#DEFINE P_Emp_01	01 // Nome da Empresa
#DEFINE P_Emp_02	02 // Endereço
#DEFINE P_Emp_03	03 // Bairro
#DEFINE P_Emp_04	04 // Cidade
#DEFINE P_Emp_05	05 // Estado
#DEFINE P_Emp_06	06 // Cep
#DEFINE P_Emp_07	07 // Telefone
#DEFINE P_Emp_08	08 // Fax
#DEFINE P_Emp_09	09 // CNPJ
#DEFINE P_Emp_10	10 // Inscrição Estadual
#DEFINE P_Emp_11	11 // sacador avalista
#DEFINE P_Emp_SZ	11 // tamanho do array dados da empresa

#DEFINE P_Bco_01	01 // Código do Banco
#DEFINE P_Bco_02	02 // Dígito do Banco
#DEFINE P_Bco_03	03 // Código da Agência
#DEFINE P_Bco_04	04 // Dígito da Agência
#DEFINE P_Bco_05	05 // Número da Conta Corrente
#DEFINE P_Bco_06	06 // Dígito da Conta Corrente
#DEFINE P_Bco_07	07 // Nome Completo do Banco
#DEFINE P_Bco_08	08 // Nome Reduzido do Banco
#DEFINE P_Bco_09	09 // Nome do Arquivo com o Logotipo do Banco
#DEFINE P_Bco_10	10 // Taxa de juros a ser utilizado no cálculo de juros de mora
#DEFINE P_Bco_11	11 // Taxa de multa a ser impressa no boleto
#DEFINE P_Bco_12	12 // Número de dias para envio do título ao cartório
#DEFINE P_Bco_13	13 // Dado para o campo "Uso do Banco"
#DEFINE P_Bco_14	14 // Dado para o campo "Espécie do Documento"
#DEFINE P_Bco_15	15 // Código do Cedente
#DEFINE P_Bco_16	16 // tamanho da imagem do banco
#DEFINE P_Bco_SZ	16 // tamanho do array dados do banco
				
#DEFINE P_Tit_01	01	// Prefixo do Título
#DEFINE P_Tit_02	02	// Número do Título
#DEFINE P_Tit_03	03	// Parcela do Título
#DEFINE P_Tit_04	04	// Tipo do título
#DEFINE P_Tit_05	05	// Data de Emissão do título
#DEFINE P_Tit_06	06	// Data de Vencimento do Título
#DEFINE P_Tit_07	07	// Data de Vencimento Real
#DEFINE P_Tit_08	08	// Valor Líquido do Título
#DEFINE P_Tit_09	09	// Código do Barras Formatado
#DEFINE P_Tit_10	10	// Carteira de Cobrança
#DEFINE P_Tit_11	11	// 1.a Linha de Mensagens Diversas
#DEFINE P_Tit_12	12	// 2.a Linha de Mensagens Diversas
#DEFINE P_Tit_13	13	// 3.a Linha de Mensagens Diversas
#DEFINE P_Tit_14	14	// 4.a Linha de Mensagens Diversas
#DEFINE P_Tit_15	15	// 5.a Linha de Mensagens Diversas
#DEFINE P_Tit_16	16	// 6.a Linha de Mensagens Diversas
#DEFINE P_Tit_17	17	// DESCONTOS E ABATIMENTOS
#DEFINE P_Tit_18	18	// MORA / MULTAS
#DEFINE P_Tit_19	19	// VALOR COBRADO
#DEFINE P_Tit_20	20	// data de geração do boleto
#DEFINE P_Tit_SZ	20	// tamanho do array dados titulo

#DEFINE P_Cli_01	01 // Código do cliente
#DEFINE P_Cli_02	02 // Loja do Cliente
#DEFINE P_Cli_03	03 // Nome Completo do Cliente
#DEFINE P_Cli_04	04 // CNPJ do Cliente
#DEFINE P_Cli_05	05 // Inscrição Estadual do cliente
#DEFINE P_Cli_06	06 // Tipo de Pessoa do Cliente
#DEFINE P_Cli_07	07 // Endereço
#DEFINE P_Cli_08	08 // Bairro
#DEFINE P_Cli_09	09 // Município
#DEFINE P_Cli_10	10 // Estado
#DEFINE P_Cli_11	11 // Cep
#DEFINE P_Cli_SZ	11 // tamanho do array dados titulo

#DEFINE P_Barra_01	01 // Código de barras (Banco+"9"+Dígito+Fator+Valor+Campo Livre
#DEFINE P_Barra_02	02 // Linha Digitável
#DEFINE P_Barra_03	03 // Nosso Número sem formatação
#DEFINE P_Barra_04	04 // Nosso Número Formatado
#DEFINE P_Barra_SZ	04 // tamanho do array dados codigo de barras


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA085   ºAutor  ³CLEUTO LIMA         º Data ³  13/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PREPARA DADOS PARA IMPRESSÃO DO BOLETO                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENA085(nRecSE1,cFilTit,cNumTit,cPrefixo,cParcela,aLogs,lViewPDF,lServidor,nRecSA1,cCodCli,cLojaCli,cFilePrint)

Local lRet			:= .T.
Local aArea		:= GetArea()
Local cDirError	:= ""
Local oprn
Local aDadEmp		:= Array(P_Emp_SZ)
Local aDadBco		:= Array(P_Bco_SZ)
Local aDadTit		:= Array(P_Tit_SZ)
Local aDadCli		:= Array(P_Cli_SZ)
Local aBarra		:= Array(P_Barra_SZ)
Local nTpImp		:= 0
Local cDirPDF		:= IIF( lServidor  , GetMv("GEN_FIN009",.f.,"\workflow\Anexos\Boleto\")+cFilAnt+"\" , GetTempPath()+cFilAnt+"\" )
Local cSerirS		:= GetMv("GEN_FIN013",.f.,"3#")
Local cDadosBend	:= GetMv("GEN_FIN014",.f.,"GEN GRUPO EDITORIAL NACIONAL PAR SA      CNPJ 08.914.167/0001-70")
Local cEnderBenc	:= GetMv("GEN_FIN015",.f.,"TRAVESSA OUVIDOR 11 7AND SL702 PART CENTRO RIO DE JANEIRO RJ 2004 040")
Local aMsgBlt		:= {} 
Local aMsgAux		:= {}
Local nSaldo		:= 0
Local cValTit		:= ""
Local nVlAbat		:= 0
Local cNossoNum	:= ""
Local cDACNossoN	:= ""
Local cSubConta	:= GetMv("GEN_FIN016",.f.,"003")
Local aCartSant	:= StrtokArr(GetMv("GEN_FIN017",.f.,"109:PENH.ELETR#"),"#")
Local nPosCart	:= 0

Private nValLiq	:= 0

Default cFilePrint	:= ""
Default lServidor		:= .T.
Default lViewPDF		:= .F.
Default nRecSE1		:= 0
Default cFilTit		:= "" 
Default cNumTit		:= ""
Default cPrefixo		:= ""
Default cParcela		:= ""

If nRecSE1 == 0 .OR. Empty(cFilTit)  .OR. Empty(cNumTit)//  .OR. Empty(cPrefixo)
	Aadd(aLogs, "GENA085: Dados para localização do titulo não informados, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.
EndIf

DbSelectArea("SE1")
SE1->(DbSetOrder(1))
DbSelectArea("SA1")
SA1->(DbSetOrder(1))

SE1->(Dbgoto(nRecSE1))

If !(SE1->E1_FILIAL == cFilTit .AND. SE1->E1_NUM == cNumTit .AND. SE1->E1_PREFIXO == cPrefixo .AND. SE1->E1_PARCELA == cParcela)
	Aadd(aLogs, "GENA085: Dados para localização do titulo inconsistentes, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If Empty(AllTrim(SE1->E1_NUMBCO))
	Aadd(aLogs, "GENA085: Nosso numero não informado, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If SE1->E1_SALDO == 0
	Aadd(aLogs, "GENA085: Não existe saldo para o titulo , Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If Empty(AllTrim(SE1->E1_NUMBOR))
	Aadd(aLogs, "GENA085: Bordero não informado, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If xFilial("SE1") <> SE1->E1_FILIAL .OR. SE1->E1_FILIAL <> cFilAnt
	Aadd(aLogs, "GENA085: Filial do sistema diferente de filial do titulo, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

SA1->(Dbseek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ))

If SA1->(Recno()) <> nRecSA1 .OR. SA1->A1_COD <> cCodCli .OR. SA1->A1_LOJA <> cLojaCli
	Aadd(aLogs, "GENA085: Dados para localização do cliente inconsistentes, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.
EndIf

SEE->(DbSetOrder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
If !SEE->( DbSeek( xFilial( "SEE" ) + SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+cSubConta ) )// Banco / Agencia / Conta / Sub-conta
	Aadd(aLogs, "GENA085: Cadastro do banco não localizado para o titulo, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.		
EndIf

Do Case
	Case SEE->EE_CODIGO == "341"
		cNossoNum := StrZero(Val(AllTrim(SE1->E1_NUMBCO)),8)
	Case SEE->EE_CODIGO == "033"
		cNossoNum := StrZero(Val(AllTrim(SE1->E1_NUMBCO)),6)
	OtherWise
		cNossoNum := AllTrim(SE1->E1_NUMBCO)	
EndCase	

aDadEmp[P_Emp_01]	:= cDadosBend//ALLTRIM(SM0->M0_NOMECOM) //	01 // Nome da Empresa
aDadEmp[P_Emp_02]	:= cEnderBenc//ALLTRIM(SM0->M0_ENDCOB) + " " + ALLTRIM(SM0->M0_COMPCOB)//"TRAVESSA OUVIDOR 11 7AND SL702 PART CENTRO RIO DE JANEIRO RJ 20040 040" //	02 // Endereço
aDadEmp[P_Emp_03]	:= ALLTRIM(SM0->M0_BAIRCOB)//	03 // Bairro
aDadEmp[P_Emp_04]	:= ALLTRIM(SM0->M0_CIDCOB)//	04 // Cidade
aDadEmp[P_Emp_05]	:= ALLTRIM(SM0->M0_ESTCOB)//	05 // Estado
aDadEmp[P_Emp_06]	:= ALLTRIM(SM0->M0_CEPCOB)//Transform(SM0->M0_CEPCOB,"@R XXXXX-XXX")//	06 // Cep
aDadEmp[P_Emp_07]	:= ALLTRIM(SM0->M0_TEL)//	07 // Telefone
aDadEmp[P_Emp_08]	:= ALLTRIM(SM0->M0_FAX)//	08 // Fax
aDadEmp[P_Emp_09]	:= ALLTRIM(SM0->M0_CGC)//	09 // CNPJ
aDadEmp[P_Emp_10]	:= ALLTRIM(SM0->M0_INSC)//	10 // Inscrição Estadual

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadEmp[P_Emp_11]	:= cDadosBend//ALLTRIM(SM0->M0_NOMECOM)+" "+AllTrim(SM0->M0_CGC)
	Case SEE->EE_CODIGO == "033"
		aDadEmp[P_Emp_11]	:= ""
	OtherWise
		aDadEmp[P_Emp_11]	:= ""
EndCase	

aDadTit[P_Tit_01]	:= SE1->E1_PREFIXO//	01	// Prefixo do Título

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadTit[P_Tit_02]	:= SE1->E1_NUM+SE1->E1_PARCELA//	02	// Número do Título
	Case SEE->EE_CODIGO == "033"
		aDadTit[P_Tit_02]	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA//	02	// Número do Título
	OtherWise
		aDadTit[P_Tit_02]	:= SE1->E1_NUM//	02	// Número do Título
EndCase	

aDadTit[P_Tit_03]	:= SE1->E1_PARCELA//	03	// Parcela do Título
aDadTit[P_Tit_04]	:= SE1->E1_TIPO//	04	// Tipo do título
aDadTit[P_Tit_05]	:= SE1->E1_EMISSAO//	05	// Data de Emissão do título
aDadTit[P_Tit_06]	:= SE1->E1_VENCTO//	06	// Data de Vencimento do Título
aDadTit[P_Tit_07]	:= SE1->E1_VENCTO//SE1->E1_VENCREA//	07	// Data de Vencimento Real
aDadTit[P_Tit_20]	:= IIF( Empty(SE1->E1_XDTBOL) , DDataBase , SE1->E1_XDTBOL )

nSaldo		:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDatabase,,SE1->E1_LOJA )
nVlAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)
nValLiq	:= nSaldo-nVlAbat

aDadTit[P_Tit_08]	:= nValLiq//	08	// Valor Líquido do Título

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadTit[P_Tit_10]	:= SEE->EE_CODCART//	10	// Carteira de Cobrança
	Case SEE->EE_CODIGO == "033"
	
		nPosCart := aScan(aCartSant,{|x| left(x,3) == SEE->EE_CODCART })
		IF nPosCart > 0
			aDadTit[P_Tit_10]	:= AllTrim(SubStr(aCartSant[nPosCart],5,100))
		Else
			aDadTit[P_Tit_10]	:= ""	
		EndIf
		
	OtherWise
		aDadTit[P_Tit_10]	:= SEE->EE_CODCART//	10	// Carteira de Cobrança
EndCase

If !Empty(AllTrim(SEE->EE_FORMEN1))
	aMsgAux := StrTokArr(AllTrim(&(SEE->EE_FORMEN1)),Chr(13)+Chr(10))
	aEval(aMsgAux, {|x| Aadd(aMsgBlt, x ) } )
EndIf

If !Empty(AllTrim(SEE->EE_FORMEN2))
	aMsgAux := StrTokArr(AllTrim(&(SEE->EE_FORMEN2)),Chr(13)+Chr(10))
	aEval(aMsgAux, {|x| Aadd(aMsgBlt, x ) } )
EndIf

If !Empty(SEE->EE_FOREXT1)
	aMsgAux := StrTokArr(&(SEE->EE_FOREXT1),Chr(13)+Chr(10))
	aEval(aMsgAux, {|x| Aadd(aMsgBlt, x ) } )
EndIf

If !Empty(SEE->EE_FOREXT2)
	aMsgAux := StrTokArr(&(SEE->EE_FOREXT2),Chr(13)+Chr(10))
	aEval(aMsgAux, {|x| Aadd(aMsgBlt, x ) } )
endIf

aDadTit[P_Tit_11]	:= IIF( Len(aMsgBlt) >= 1 , aMsgBlt[1] , "" )  //	11	// 1.a Linha de Mensagens Diversas	
aDadTit[P_Tit_12]	:= IIF( Len(aMsgBlt) >= 2 , aMsgBlt[2] , "" )//	12	// 2.a Linha de Mensagens Diversas
aDadTit[P_Tit_13]	:= IIF( Len(aMsgBlt) >= 3 , aMsgBlt[3] , "" )//	13	// 3.a Linha de Mensagens Diversas
aDadTit[P_Tit_14]	:= IIF( Len(aMsgBlt) >= 4 , aMsgBlt[4] , "" )//	14	// 4.a Linha de Mensagens Diversas
aDadTit[P_Tit_15]	:= IIF( Len(aMsgBlt) >= 5 , aMsgBlt[5] , "" )//	15	// 5.a Linha de Mensagens Diversas
aDadTit[P_Tit_16]	:= IIF( Len(aMsgBlt) >= 6 , aMsgBlt[6] , "" )//	16	// 6.a Linha de Mensagens Diversas

/* cleuto - 21/03/2019 - alinhado com pacheco que sempre demonstraremos apenas o valor liquido
aDadTit[P_Tit_17]	:= nVlAbat//SE1->E1_DECRESC
aDadTit[P_Tit_18]	:= SE1->E1_ACRESC
aDadTit[P_Tit_19]	:= nValLiq
*/

aDadTit[P_Tit_17]	:= 0
aDadTit[P_Tit_18]	:= 0
aDadTit[P_Tit_19]	:= 0

aDadBco[P_Bco_01]	:= ALLTRIM(SEE->EE_CODIGO)//	01 // Código do Banco
aDadBco[P_Bco_02]	:= ALLTRIM(SEE->EE_XDIGBC)//	02 // Dígito do Banco
aDadBco[P_Bco_03]	:= SUBSTR(SEE->EE_AGENCIA,1,4)//	03 // Código da Agência
aDadBco[P_Bco_04]	:= ALLTRIM(SEE->EE_DVAGE)//	04 // Dígito da Agência
aDadBco[P_Bco_05]	:= SUBSTR(SEE->EE_CONTA,1,5)//"28132"//	05 // Número da Conta Corrente
aDadBco[P_Bco_06]	:= ALLTRIM(SEE->EE_DVCTA)//	06 // Dígito da Conta Corrente
aDadBco[P_Bco_07]	:= ALLTRIM(SEE->EE_XNOMEBC)//"Banco Itaú S.A."//	07 // Nome Completo do Banco
aDadBco[P_Bco_08]	:= ALLTRIM(SEE->EE_XNREDUZ)//	08 // Nome Reduzido do Banco
aDadBco[P_Bco_09]	:= ALLTRIM(SEE->EE_XIMGLG)//"itau_logo.jpg"//	09 // Nome do Arquivo com o Logotipo do Banco
aDadBco[P_Bco_10]	:= SE1->E1_PORCJUR//	10 // Taxa de juros a ser utilizado no cálculo de juros de mora
aDadBco[P_Bco_11]	:= SE1->E1_PORCJUR//	11 // Taxa de multa a ser impressa no boleto
aDadBco[P_Bco_12]	:= 0//	12 // Número de dias para envio do título ao cartório
aDadBco[P_Bco_13]	:= "USO DO BANCO"//	13 // Dado para o campo "Uso do Banco"

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadBco[P_Bco_16]	:= {130, 110 , 010}
		//aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DSI","DMI")//	14 // Dado para o campo "Espécie do Documento"
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DS","DM")//	14 // Dado para o campo "Espécie do Documento"
	Case SEE->EE_CODIGO == "033"
		aDadBco[P_Bco_16]	:= {500, 200, -35}
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DS","DM")//	14 // Dado para o campo "Espécie do Documento"
	OtherWise 
		aDadBco[P_Bco_16]	:= {120, 100 , 010}
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DSI","DMI")//	14 // Dado para o campo "Espécie do Documento"
EndCase

//aDadBco[P_Bco_15]	:= ALLTRIM(SEE->EE_NUMCTR)//	15 // Código do Cedente
aDadBco[P_Bco_15]	:= ALLTRIM(SEE->EE_XNUMCED)//	15 // Código do Cedente

aDadCli[P_Cli_01]	:= ALLTRIM(SE1->E1_CLIENTE)//	01 // Código do cliente
aDadCli[P_Cli_02]	:= ALLTRIM(SE1->E1_LOJA)//	02 // Loja do Cliente
aDadCli[P_Cli_03]	:= ALLTRIM(SA1->A1_NOME)//	03 // Nome Completo do Cliente
aDadCli[P_Cli_04]	:= ALLTRIM(SA1->A1_CGC)//	04 // CNPJ do Cliente
aDadCli[P_Cli_05]	:= ALLTRIM(SA1->A1_INSCR)//	05 // Inscrição Estadual do cliente
aDadCli[P_Cli_06]	:= ALLTRIM(SA1->A1_PESSOA)//	06 // Tipo de Pessoa do Cliente
aDadCli[P_Cli_07]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_END) + " " + ALLTRIM(SA1->A1_XENDNUM) , ALLTRIM(SA1->A1_ENDCOB) )//	07 // Endereço
aDadCli[P_Cli_08]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_BAIRRO) , ALLTRIM(SA1->A1_BAIRROC) )//	08 // Bairro
aDadCli[P_Cli_09]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_MUN) , ALLTRIM(SA1->A1_MUNC) )//	09 // Município
aDadCli[P_Cli_10]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_EST) , ALLTRIM(SA1->A1_ESTC) )//	10 // Estado
aDadCli[P_Cli_11]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,Transform(ALLTRIM(SA1->A1_CEP),"@R 99999-999") , Transform(ALLTRIM(SA1->A1_CEPC),"@R 99999-999") )//	11 // Cep

aBarra[P_Barra_01]	:= xRetCodBar(SEE->EE_CODIGO,"9",SE1->E1_VENCTO,nValLiq,ALLTRIM(SEE->EE_CODCART),@cNossoNum,SUBSTR(SEE->EE_AGENCIA,1,4),SUBSTR(SEE->EE_CONTA,1,5),ALLTRIM(SEE->EE_DVCTA),@cDACNossoN,AllTrim(SEE->EE_CODEMP))//	01 // Código de barras (Banco+"9"+Dígito+Fator+Valor+Campo Livre
aBarra[P_Barra_02]	:= xRetLinDig(aBarra[P_Barra_01],SEE->EE_CODIGO,"9",SE1->E1_VENCTO,nValLiq,ALLTRIM(SEE->EE_CODCART),@cNossoNum,SUBSTR(SEE->EE_AGENCIA,1,4),SUBSTR(SEE->EE_CONTA,1,5),ALLTRIM(SEE->EE_DVCTA),cDACNossoN,AllTrim(SEE->EE_CODEMP))//	//02 // Linha Digitável
aBarra[P_Barra_03]	:= ALLTRIM(SEE->EE_CODCART)+cNossoNum//	03 // Nosso Número sem formatação

Do Case
	Case SEE->EE_CODIGO == "341"
		aBarra[P_Barra_04]	:= Transform(ALLTRIM(SEE->EE_CODCART)+cNossoNum+cDACNossoN,"@R 999/99999999-9")//	04 // Nosso Número Formatado
	Case SEE->EE_CODIGO == "033"
		aBarra[P_Barra_04]	:= Padl(cNossoNum+cDACNossoN,13,"0")//	04 // Nosso Número Formatado
	OtherWise
		aBarra[P_Barra_04]	:= Transform(ALLTRIM(SEE->EE_CODCART)+cNossoNum+cDACNossoN,"@R 999/99999999-9")//	04 // Nosso Número Formatado
EndCase	

//aDadTit[P_Tit_09]		:= Transform(aBarra[P_Barra_01], "99999.99999 99999.999999 99999.999999 9 99999999999999" )//	09	// Código do Barras Formatado

RestArea(aArea)

If lRet	
	lRet := VldCodBar(aBarra[P_Barra_01])
	If !lRet
		lRet	:= .F.
		Aadd(aLogs, "Codigo de barras '"+aBarra[P_Barra_01]+"' gerado é invalido para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
		Return .F.	
	EndIf
EndIf	

If lRet	
	lRet := VldCodBar(StrTran(StrTran(aBarra[P_Barra_02],".","")," ",""))
	If !lRet
		lRet	:= .F.
		Aadd(aLogs, "Linha digitavel '"+aBarra[P_Barra_02]+"' gerada é invalida para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
		Return .F.
	EndIf
EndIf	

If lRet
	//cFilePrint	:= aDadTit[P_Tit_02]+IIF( Empty(aDadTit[P_Tit_03]),"","_"+AllTrim(aDadTit[P_Tit_03]) )+"_"+StrTran(time(),":","")+".PDF"
	cFilePrint	:= aDadTit[P_Tit_02]+IIF( Empty(aDadTit[P_Tit_03]),"","_"+AllTrim(aDadTit[P_Tit_03]) )+".PDF"
	
	/* executa rotina de geração do boleto */
	If U_GENA086(aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp,cDirPDF,cFilePrint,lViewPDF)	
		If !File(cDirPDF+cFilePrint)
			Aadd(aLogs, "Falha ao gerar o arqui PDF para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
			lRet	:= .F.
			Return .F.
		Else
			SE1->(Dbgoto(nRecSE1))
			If Empty(SE1->E1_XDTBOL) 
				RecLock("SE1",.F.)
				SE1->E1_XDTBOL	:= DDataBase
				MsUnLock()		
			EndIf	
		EndIf
	Else
		Aadd(aLogs, "Falha ao gerar o arqui PDF para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
		lRet	:= .F.
		Return .F.		
	EndIf	
EndIf

Return lRet

Static Function xRetLinDig(cCodCar,cCodBanco,cMoeda,dDtVenc,nValLiq,cCart,cNossNum,cAgencia,cConta,cDacCC,cDACNossoN,cCodCedente)

Local cRet			:= ""
Local cCodAux		:= ""
Local cCod			:= ""
Local cValTit		:= Strzero((nValLiq*100),10)
Local cDvCC		:= AllTrim(DacMod10(cAgencia + cConta))
Local cFatVenc	:= xRetFatVenc(dDtVenc)
Local cDvDAC		:= cDACNossoN//Modulo10(SubStr(cAgencia,4,1)+cConta+cDacCC+cNossNum)
Local cDvBLT		:= ""
Local cCodCedSant	:= cValToChar(Val(cCodCedente))

//cDvBLT		:= GENA085D(cCodBanco,cMoeda,cFatVenc,cValTit,cCart,cNossNum,cDvDAC,cAgencia,cConta,cDvCC,"000")
cDvBLT		:= U_GENA085D(Left(cCodCar,4)+Substr(cCodCar,6,39),cCodBanco,.T.)

Do Case
	Case cCodBanco == "341"
				
		/* campo 1 */	
		cCodAux	:= cCodBanco // Código do Banco na Câmara de Compensação (Itaú=341)
		cCodAux	+= cMoeda // Código da moeda = "9"
		cCodAux	+= cCart // Código da carteira de cobrança
		cCodAux	+= Left(cNossNum,2) // Dois primeiros dígitos do Nosso Número
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 1
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,5)
	
		/* campo 2 */
		cCodAux	:= Substr(cNossNum,3,Len(cNossNum)-2) //Restante do Nosso Número
		cCodAux	+= cDvDAC//DAC do campo [Agência/Conta/Carteira/ Nosso Número]
		cCodAux	+= Left(cAgencia,3) 
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 2
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,6)+" "
		
		/* campo 3 */
		cCodAux	:= SubStr(cAgencia,4,1)//F = Restante do número que identifica a agência
		cCodAux	+= Left(cConta,5)+cDacCC//DacMod10(Left(cConta,5)) //Left(cConta,5)+cDvCC//GGGGGG = Número da conta corrente + DAC
		cCodAux	+= "000"//HHH = Zeros ( Não utilizado )
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 2
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,6)+" "
		
		/* campo 4 */
		cCod		+= cDvBLT//" "+cDvBLT+" "
		
		/* campo 5 */		
		cCodAux	:= cFatVenc
		cCodAux	+= cValTit
		cCod		+= cCodAux

	Case cCodBanco == "033"
				
		/* campo 1 */	
		cCodAux	:= cCodBanco
		cCodAux	+= cMoeda
		cCodAux	+= "9" 
		cCodAux	+= Left(cCodCedSant,4)
		cCodAux	+= AllTrim(DacMod10(cCodAux))
		cCod		+= cCodAux
	
		/* campo 2 */
		cCodAux	:= Substr(cCodCedSant,5,3)
		cCodAux	+= Left(Padl(cNossNum,12,"0"),7)
		cCodAux	+= AllTrim(DacMod10(cCodAux))
		cCod		+= cCodAux
		
		/* campo 3 */
		cCodAux	:= SubStr(Padl(cNossNum,12,"0"),8,5)+U_GENA085D(cNossNum,cCodBanco)
		cCodAux	+= "0"
		cCodAux	+= cCart
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 2
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,6)+" "
		
		/* campo 4 */
		cCod		+= cDvBLT//" "+cDvBLT+" "
		
		/* campo 5 */		
		cCodAux	:= cFatVenc
		cCodAux	+= cValTit
		cCod		+= cCodAux		
EndCase

cRet	:= cCod

Return cRet

Static Function xRetCodBar(cCodBanco,cMoeda,dDtVenc,nValLiq,cCart,cNossNum,cAgencia,cConta,cDacCC,cDACNossoN,cCodCedente)

Local cValTit		:= Strzero((nValLiq*100),10)
Local cCod			:= ""
Local cDvDAC		:= ""
Local cDvCC		:= AllTrim(DacMod10(cAgencia + cConta))
Local cFatVenc	:= xRetFatVenc(dDtVenc)
Local cDvBLT		:= ""//U_GENA085D(cCodBanco,cMoeda,cFatVenc,cValTit,cCart,cNossNum,cDvDAC,cAgencia,cConta,cDvCC,"000")

Do Case
	Case cCodBanco == "341"
		/* ----------------------------- ITAU -------------------------
		01 a 03 03 9(03) Código do Banco na Câmara de Compensação = '341'
		04 a 04 01 9(01) Código da Moeda = '9'
		05 a 05 01 9(01) DAC código de Barras (Anexo 2)
		06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		10 a 19 10 9(08)V(2) Valor
		20 a 22 03 9(03) Carteira
		23 a 30 08 9(08) Nosso Número
		31 a 31 01 9(01) DAC [Agência /Conta/Carteira/Nosso Número] (Anexo 4)
		32 a 35 04 9(04) N.º da Agência BENEFICIÁRIO
		36 a 40 05 9(05) N.º da Conta Corrente
		41 a 41 01 9(01) DAC [Agência/Conta Corrente] (Anexo 3)
		42 a 44 03 9(03) Zeros		
		--------------------------------------------------------------- */
		
		cDvDAC		:= DacMod10(SubStr(cAgencia,1,4)+cConta+cCart+cNossNum)//Modulo10(SubStr(cAgencia,4,1)+cConta+cDacCC+cNossNum)		
		cDACNossoN	:= cDvDAC
		
		cCod += cCodBanco	//01 a 03 03 9(03) Código do Banco na Câmara de Compensação = '341'
		cCod += cMoeda	// 04 a 04 01 9(01) Código da Moeda = '9'
		//cCod += cDvBLT	// 05 a 05 01 9(01) DAC código de Barras (Anexo 2)
		cCod += cFatVenc // 06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		cCod += cValTit // 10 a 19 10 9(08)V(2) Valor
		cCod += cCart// 20 a 22 03 9(03) Carteira
		cCod += cNossNum// 23 a 30 08 9(08) Nosso Número
		cCod += cDvDAC // 31 a 31 01 9(01) DAC [Agência /Conta/Carteira/Nosso Número] (Anexo 4)
		cCod += cAgencia// 32 a 35 04 9(04) N.º da Agência BENEFICIÁRIO
		cCod += cConta// 36 a 40 05 9(05) N.º da Conta Corrente
		cCod += AllTrim(cDacCC)//DacMod10(cConta) //cDvCC// 41 a 41 01 9(01) DAC [Agência/Conta Corrente] (Anexo 3)
		cCod += "000"// 42 a 44 03 9(03) Zeros			
		
		cDvBLT := U_GENA085D(cCod,cCodBanco)
		cCod	:= Left(cCod,4)+cDvBLT+SubStr(cCod,5,39)
		
	Case cCodBanco == "033"

		cDvDAC		:= U_GENA085D(cNossNum,cCodBanco)		
		cDACNossoN	:= cDvDAC
			
		/* ----------------------------- ITAU -------------------------
		01 a 03 03 9(03) Código do Banco na Câmara de Compensação = '341'
		04 a 04 01 9(01) Código da Moeda = '9'
		05 a 05 01 9(01) DAC código de Barras (Anexo 2)
		06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		10 a 19 10 9(08)V(2) Valor
		20 a 22 03 9(03) Carteira
		23 a 30 08 9(08) Nosso Número
		31 a 31 01 9(01) DAC [Agência /Conta/Carteira/Nosso Número] (Anexo 4)
		32 a 35 04 9(04) N.º da Agência BENEFICIÁRIO
		36 a 40 05 9(05) N.º da Conta Corrente
		41 a 41 01 9(01) DAC [Agência/Conta Corrente] (Anexo 3)
		42 a 44 03 9(03) Zeros		
		--------------------------------------------------------------- */
		cCod += cCodBanco	//01 a 03 03 9(03) Código do Banco na Câmara de Compensação = '341'
		cCod += cMoeda	// 04 a 04 01 9(01) Código da Moeda = '9'
		//cCod += cDvBLT	// 05 a 05 01 9(01) DAC código de Barras (Anexo 2)
		cCod += cFatVenc // 06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		cCod += cValTit // 10 a 19 10 9(08)V(2) Valor
		cCod += "9"// 20 a 20 FIXO DE 9
		cCod += cValtoChar(Val(cCodCedente)) // 21-27 7 9 (07) número do PSK(Código do Cliente)
		cCod += Padl(cNossNum+cDvDAC,13,"0")//Modulo11(cNossNum)// 28-40 13 9 (13) Nosso Número
		cCod += "0"
		cCod += cCart

		cDvBLT := U_GENA085D(cCod,cCodBanco,.T.)
		cCod	:= Left(cCod,4)+cDvBLT+SubStr(cCod,5,39)
				
EndCase

Return cCod

//Static Function U_GENA085D(cCodBanco,cMoeda,cFatVenc,cValTit,cCart,cNossNum,cDvDAC,cAgencia,cConta,cDvCC,cZeros)
User Function GENA085D(cAux,cCdBanc,lCodBar)

Local cRet		:= ""
Local nTotAux	:= 0
Local nAuxDac	:= 2

Default lCodBar	:= .F.

While !Empty(cAux)
	nTotAux += Val(Right(cAux,1))*nAuxDac
	nAuxDac++
	If nAuxDac > 9
		nAuxDac := 2
	EndIf
	cAux := Left(cAux,Len(cAux)-1)
EndDo

Do Case
	Case cCdBanc == "341"
		nTotAux	:= 11-Mod(nTotAux,11)
		If nTotAux == 0 .OR. nTotAux == 1 .OR. nTotAux == 10 .OR. nTotAux == 11
			nTotAux := 1
		EndIf
	Case cCdBanc == "033"
		If !lCodBar
			nTotAux	:= Mod(nTotAux,11)
			If nTotAux == 1 .OR. nTotAux == 0
				nTotAux := 0
			ElseIf nTotAux = 10
				nTotAux := 1
			Else
				nTotAux	:= 11-nTotAux
			EndIf
		Else
			nTotAux	:= Mod(nTotAux*10,11)
			If nTotAux == 0 .OR. nTotAux == 1 .OR. nTotAux == 10
				nTotAux := 1
			EndIf				
		EndIf	
EndCase 

cRet	:= AllTrim(cValToChar(nTotAux))

//cRet	:= AllTrim(modulo11( cCodBanco+cMoeda+cFatVenc+cValTit+cCart+cNossNum+cDvDAC+cAgencia+cConta+cDvCC+cZeros ))

Return cRet 

Static Function xRetFatVenc(dDFim)

Local cRet	:= StrZero(dDFim - CtoD("07/10/97"),4)
/*
Local dDtIn	:= GetMv("GEN_FIN???",.f.,CtoD("07/10/1997")) 
Local nAuxFt	:= 0
Local nFatIni	:= 999

While dDtIn <= dDFim
	If nFatIni == 9999 .OR. dDtIn == CtoD("22/02/2025")
		nFatIni	:= 999
	EndIf
	nFatIni++
	dDtIn++
EndDo
cValToChar(nFatIni)
*/

Return cRet


Static Function DacMod10(cAux)

Local cRet		:= ""
Local nTotAux	:= 0
Local nAuxDac	:= 2
Local nVAux	:= 0

While !Empty(cAux)
	nVAux	:= Val(Right(cAux,1))*nAuxDac
	If nVAux > 9
		nVAux := Val(Left(cValtoChar(nVAux),1))+Val(Right(cValtoChar(nVAux),1))
	EndIf	
	nTotAux += nVAux	
	
	cAux := SubStr(cAux,1,Len(cAux)-1)
	If nAuxDac == 1
		nAuxDac := 2
	Else
		nAuxDac := 1	 
	EndIf
EndDo

If Mod(nTotAux,10) == 0
	nTotAux := 0
Else
	nTotAux := 10-Mod(nTotAux,10)
EndIF

cRet	:= cValToChar(nTotAux)



Return cRet