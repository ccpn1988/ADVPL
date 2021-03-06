#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE cEnt	Chr(13)+chr(10)

#DEFINE P_Emp_01	01 // Nome da Empresa
#DEFINE P_Emp_02	02 // Endere�o
#DEFINE P_Emp_03	03 // Bairro
#DEFINE P_Emp_04	04 // Cidade
#DEFINE P_Emp_05	05 // Estado
#DEFINE P_Emp_06	06 // Cep
#DEFINE P_Emp_07	07 // Telefone
#DEFINE P_Emp_08	08 // Fax
#DEFINE P_Emp_09	09 // CNPJ
#DEFINE P_Emp_10	10 // Inscri��o Estadual
#DEFINE P_Emp_11	11 // sacador avalista
#DEFINE P_Emp_SZ	11 // tamanho do array dados da empresa

#DEFINE P_Bco_01	01 // C�digo do Banco
#DEFINE P_Bco_02	02 // D�gito do Banco
#DEFINE P_Bco_03	03 // C�digo da Ag�ncia
#DEFINE P_Bco_04	04 // D�gito da Ag�ncia
#DEFINE P_Bco_05	05 // N�mero da Conta Corrente
#DEFINE P_Bco_06	06 // D�gito da Conta Corrente
#DEFINE P_Bco_07	07 // Nome Completo do Banco
#DEFINE P_Bco_08	08 // Nome Reduzido do Banco
#DEFINE P_Bco_09	09 // Nome do Arquivo com o Logotipo do Banco
#DEFINE P_Bco_10	10 // Taxa de juros a ser utilizado no c�lculo de juros de mora
#DEFINE P_Bco_11	11 // Taxa de multa a ser impressa no boleto
#DEFINE P_Bco_12	12 // N�mero de dias para envio do t�tulo ao cart�rio
#DEFINE P_Bco_13	13 // Dado para o campo "Uso do Banco"
#DEFINE P_Bco_14	14 // Dado para o campo "Esp�cie do Documento"
#DEFINE P_Bco_15	15 // C�digo do Cedente
#DEFINE P_Bco_16	16 // tamanho da imagem do banco
#DEFINE P_Bco_SZ	16 // tamanho do array dados do banco
				
#DEFINE P_Tit_01	01	// Prefixo do T�tulo
#DEFINE P_Tit_02	02	// N�mero do T�tulo
#DEFINE P_Tit_03	03	// Parcela do T�tulo
#DEFINE P_Tit_04	04	// Tipo do t�tulo
#DEFINE P_Tit_05	05	// Data de Emiss�o do t�tulo
#DEFINE P_Tit_06	06	// Data de Vencimento do T�tulo
#DEFINE P_Tit_07	07	// Data de Vencimento Real
#DEFINE P_Tit_08	08	// Valor L�quido do T�tulo
#DEFINE P_Tit_09	09	// C�digo do Barras Formatado
#DEFINE P_Tit_10	10	// Carteira de Cobran�a
#DEFINE P_Tit_11	11	// 1.a Linha de Mensagens Diversas
#DEFINE P_Tit_12	12	// 2.a Linha de Mensagens Diversas
#DEFINE P_Tit_13	13	// 3.a Linha de Mensagens Diversas
#DEFINE P_Tit_14	14	// 4.a Linha de Mensagens Diversas
#DEFINE P_Tit_15	15	// 5.a Linha de Mensagens Diversas
#DEFINE P_Tit_16	16	// 6.a Linha de Mensagens Diversas
#DEFINE P_Tit_17	17	// DESCONTOS E ABATIMENTOS
#DEFINE P_Tit_18	18	// MORA / MULTAS
#DEFINE P_Tit_19	19	// VALOR COBRADO
#DEFINE P_Tit_20	20	// data de gera��o do boleto
#DEFINE P_Tit_SZ	20	// tamanho do array dados titulo

#DEFINE P_Cli_01	01 // C�digo do cliente
#DEFINE P_Cli_02	02 // Loja do Cliente
#DEFINE P_Cli_03	03 // Nome Completo do Cliente
#DEFINE P_Cli_04	04 // CNPJ do Cliente
#DEFINE P_Cli_05	05 // Inscri��o Estadual do cliente
#DEFINE P_Cli_06	06 // Tipo de Pessoa do Cliente
#DEFINE P_Cli_07	07 // Endere�o
#DEFINE P_Cli_08	08 // Bairro
#DEFINE P_Cli_09	09 // Munic�pio
#DEFINE P_Cli_10	10 // Estado
#DEFINE P_Cli_11	11 // Cep
#DEFINE P_Cli_SZ	11 // tamanho do array dados titulo

#DEFINE P_Barra_01	01 // C�digo de barras (Banco+"9"+D�gito+Fator+Valor+Campo Livre
#DEFINE P_Barra_02	02 // Linha Digit�vel
#DEFINE P_Barra_03	03 // Nosso N�mero sem formata��o
#DEFINE P_Barra_04	04 // Nosso N�mero Formatado
#DEFINE P_Barra_SZ	04 // tamanho do array dados codigo de barras


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA085   �Autor  �CLEUTO LIMA         � Data �  13/03/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � PREPARA DADOS PARA IMPRESS�O DO BOLETO                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	Aadd(aLogs, "GENA085: Dados para localiza��o do titulo n�o informados, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.
EndIf

DbSelectArea("SE1")
SE1->(DbSetOrder(1))
DbSelectArea("SA1")
SA1->(DbSetOrder(1))

SE1->(Dbgoto(nRecSE1))

If !(SE1->E1_FILIAL == cFilTit .AND. SE1->E1_NUM == cNumTit .AND. SE1->E1_PREFIXO == cPrefixo .AND. SE1->E1_PARCELA == cParcela)
	Aadd(aLogs, "GENA085: Dados para localiza��o do titulo inconsistentes, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If Empty(AllTrim(SE1->E1_NUMBCO))
	Aadd(aLogs, "GENA085: Nosso numero n�o informado, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If SE1->E1_SALDO == 0
	Aadd(aLogs, "GENA085: N�o existe saldo para o titulo , Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.	
EndIf

If Empty(AllTrim(SE1->E1_NUMBOR))
	Aadd(aLogs, "GENA085: Bordero n�o informado, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
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
	Aadd(aLogs, "GENA085: Dados para localiza��o do cliente inconsistentes, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
	lRet	:= .F.
	Return .F.
EndIf

SEE->(DbSetOrder(1)) // EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
If !SEE->( DbSeek( xFilial( "SEE" ) + SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA+cSubConta ) )// Banco / Agencia / Conta / Sub-conta
	Aadd(aLogs, "GENA085: Cadastro do banco n�o localizado para o titulo, Recno SE1: "+cValToChar(nRecSE1)+", Filial Tit.:"+cFilTit+", Num.Tit.:,"+cNumTit+",Pref.Tit.:"+cPrefixo+",Parc.Tit.:"+cParcela )
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
aDadEmp[P_Emp_02]	:= cEnderBenc//ALLTRIM(SM0->M0_ENDCOB) + " " + ALLTRIM(SM0->M0_COMPCOB)//"TRAVESSA OUVIDOR 11 7AND SL702 PART CENTRO RIO DE JANEIRO RJ 20040 040" //	02 // Endere�o
aDadEmp[P_Emp_03]	:= ALLTRIM(SM0->M0_BAIRCOB)//	03 // Bairro
aDadEmp[P_Emp_04]	:= ALLTRIM(SM0->M0_CIDCOB)//	04 // Cidade
aDadEmp[P_Emp_05]	:= ALLTRIM(SM0->M0_ESTCOB)//	05 // Estado
aDadEmp[P_Emp_06]	:= ALLTRIM(SM0->M0_CEPCOB)//Transform(SM0->M0_CEPCOB,"@R XXXXX-XXX")//	06 // Cep
aDadEmp[P_Emp_07]	:= ALLTRIM(SM0->M0_TEL)//	07 // Telefone
aDadEmp[P_Emp_08]	:= ALLTRIM(SM0->M0_FAX)//	08 // Fax
aDadEmp[P_Emp_09]	:= ALLTRIM(SM0->M0_CGC)//	09 // CNPJ
aDadEmp[P_Emp_10]	:= ALLTRIM(SM0->M0_INSC)//	10 // Inscri��o Estadual

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadEmp[P_Emp_11]	:= cDadosBend//ALLTRIM(SM0->M0_NOMECOM)+" "+AllTrim(SM0->M0_CGC)
	Case SEE->EE_CODIGO == "033"
		aDadEmp[P_Emp_11]	:= ""
	OtherWise
		aDadEmp[P_Emp_11]	:= ""
EndCase	

aDadTit[P_Tit_01]	:= SE1->E1_PREFIXO//	01	// Prefixo do T�tulo

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadTit[P_Tit_02]	:= SE1->E1_NUM+SE1->E1_PARCELA//	02	// N�mero do T�tulo
	Case SEE->EE_CODIGO == "033"
		aDadTit[P_Tit_02]	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA//	02	// N�mero do T�tulo
	OtherWise
		aDadTit[P_Tit_02]	:= SE1->E1_NUM//	02	// N�mero do T�tulo
EndCase	

aDadTit[P_Tit_03]	:= SE1->E1_PARCELA//	03	// Parcela do T�tulo
aDadTit[P_Tit_04]	:= SE1->E1_TIPO//	04	// Tipo do t�tulo
aDadTit[P_Tit_05]	:= SE1->E1_EMISSAO//	05	// Data de Emiss�o do t�tulo
aDadTit[P_Tit_06]	:= SE1->E1_VENCTO//	06	// Data de Vencimento do T�tulo
aDadTit[P_Tit_07]	:= SE1->E1_VENCTO//SE1->E1_VENCREA//	07	// Data de Vencimento Real
aDadTit[P_Tit_20]	:= IIF( Empty(SE1->E1_XDTBOL) , DDataBase , SE1->E1_XDTBOL )

nSaldo		:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDatabase,,SE1->E1_LOJA )
nVlAbat	:= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA)
nValLiq	:= nSaldo-nVlAbat

aDadTit[P_Tit_08]	:= nValLiq//	08	// Valor L�quido do T�tulo

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadTit[P_Tit_10]	:= SEE->EE_CODCART//	10	// Carteira de Cobran�a
	Case SEE->EE_CODIGO == "033"
	
		nPosCart := aScan(aCartSant,{|x| left(x,3) == SEE->EE_CODCART })
		IF nPosCart > 0
			aDadTit[P_Tit_10]	:= AllTrim(SubStr(aCartSant[nPosCart],5,100))
		Else
			aDadTit[P_Tit_10]	:= ""	
		EndIf
		
	OtherWise
		aDadTit[P_Tit_10]	:= SEE->EE_CODCART//	10	// Carteira de Cobran�a
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

aDadBco[P_Bco_01]	:= ALLTRIM(SEE->EE_CODIGO)//	01 // C�digo do Banco
aDadBco[P_Bco_02]	:= ALLTRIM(SEE->EE_XDIGBC)//	02 // D�gito do Banco
aDadBco[P_Bco_03]	:= SUBSTR(SEE->EE_AGENCIA,1,4)//	03 // C�digo da Ag�ncia
aDadBco[P_Bco_04]	:= ALLTRIM(SEE->EE_DVAGE)//	04 // D�gito da Ag�ncia
aDadBco[P_Bco_05]	:= SUBSTR(SEE->EE_CONTA,1,5)//"28132"//	05 // N�mero da Conta Corrente
aDadBco[P_Bco_06]	:= ALLTRIM(SEE->EE_DVCTA)//	06 // D�gito da Conta Corrente
aDadBco[P_Bco_07]	:= ALLTRIM(SEE->EE_XNOMEBC)//"Banco Ita� S.A."//	07 // Nome Completo do Banco
aDadBco[P_Bco_08]	:= ALLTRIM(SEE->EE_XNREDUZ)//	08 // Nome Reduzido do Banco
aDadBco[P_Bco_09]	:= ALLTRIM(SEE->EE_XIMGLG)//"itau_logo.jpg"//	09 // Nome do Arquivo com o Logotipo do Banco
aDadBco[P_Bco_10]	:= SE1->E1_PORCJUR//	10 // Taxa de juros a ser utilizado no c�lculo de juros de mora
aDadBco[P_Bco_11]	:= SE1->E1_PORCJUR//	11 // Taxa de multa a ser impressa no boleto
aDadBco[P_Bco_12]	:= 0//	12 // N�mero de dias para envio do t�tulo ao cart�rio
aDadBco[P_Bco_13]	:= "USO DO BANCO"//	13 // Dado para o campo "Uso do Banco"

Do Case
	Case SEE->EE_CODIGO == "341"
		aDadBco[P_Bco_16]	:= {130, 110 , 010}
		//aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DSI","DMI")//	14 // Dado para o campo "Esp�cie do Documento"
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DS","DM")//	14 // Dado para o campo "Esp�cie do Documento"
	Case SEE->EE_CODIGO == "033"
		aDadBco[P_Bco_16]	:= {500, 200, -35}
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DS","DM")//	14 // Dado para o campo "Esp�cie do Documento"
	OtherWise 
		aDadBco[P_Bco_16]	:= {120, 100 , 010}
		aDadBco[P_Bco_14]	:= IIF( SE1->E1_PREFIXO $ cSerirS,"DSI","DMI")//	14 // Dado para o campo "Esp�cie do Documento"
EndCase

//aDadBco[P_Bco_15]	:= ALLTRIM(SEE->EE_NUMCTR)//	15 // C�digo do Cedente
aDadBco[P_Bco_15]	:= ALLTRIM(SEE->EE_XNUMCED)//	15 // C�digo do Cedente

aDadCli[P_Cli_01]	:= ALLTRIM(SE1->E1_CLIENTE)//	01 // C�digo do cliente
aDadCli[P_Cli_02]	:= ALLTRIM(SE1->E1_LOJA)//	02 // Loja do Cliente
aDadCli[P_Cli_03]	:= ALLTRIM(SA1->A1_NOME)//	03 // Nome Completo do Cliente
aDadCli[P_Cli_04]	:= ALLTRIM(SA1->A1_CGC)//	04 // CNPJ do Cliente
aDadCli[P_Cli_05]	:= ALLTRIM(SA1->A1_INSCR)//	05 // Inscri��o Estadual do cliente
aDadCli[P_Cli_06]	:= ALLTRIM(SA1->A1_PESSOA)//	06 // Tipo de Pessoa do Cliente
aDadCli[P_Cli_07]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_END) + " " + ALLTRIM(SA1->A1_XENDNUM) , ALLTRIM(SA1->A1_ENDCOB) )//	07 // Endere�o
aDadCli[P_Cli_08]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_BAIRRO) , ALLTRIM(SA1->A1_BAIRROC) )//	08 // Bairro
aDadCli[P_Cli_09]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_MUN) , ALLTRIM(SA1->A1_MUNC) )//	09 // Munic�pio
aDadCli[P_Cli_10]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,ALLTRIM(SA1->A1_EST) , ALLTRIM(SA1->A1_ESTC) )//	10 // Estado
aDadCli[P_Cli_11]	:= IIF( EMPTY(SA1->A1_ENDCOB) ,Transform(ALLTRIM(SA1->A1_CEP),"@R 99999-999") , Transform(ALLTRIM(SA1->A1_CEPC),"@R 99999-999") )//	11 // Cep

aBarra[P_Barra_01]	:= xRetCodBar(SEE->EE_CODIGO,"9",SE1->E1_VENCTO,nValLiq,ALLTRIM(SEE->EE_CODCART),@cNossoNum,SUBSTR(SEE->EE_AGENCIA,1,4),SUBSTR(SEE->EE_CONTA,1,5),ALLTRIM(SEE->EE_DVCTA),@cDACNossoN,AllTrim(SEE->EE_CODEMP))//	01 // C�digo de barras (Banco+"9"+D�gito+Fator+Valor+Campo Livre
aBarra[P_Barra_02]	:= xRetLinDig(aBarra[P_Barra_01],SEE->EE_CODIGO,"9",SE1->E1_VENCTO,nValLiq,ALLTRIM(SEE->EE_CODCART),@cNossoNum,SUBSTR(SEE->EE_AGENCIA,1,4),SUBSTR(SEE->EE_CONTA,1,5),ALLTRIM(SEE->EE_DVCTA),cDACNossoN,AllTrim(SEE->EE_CODEMP))//	//02 // Linha Digit�vel
aBarra[P_Barra_03]	:= ALLTRIM(SEE->EE_CODCART)+cNossoNum//	03 // Nosso N�mero sem formata��o

Do Case
	Case SEE->EE_CODIGO == "341"
		aBarra[P_Barra_04]	:= Transform(ALLTRIM(SEE->EE_CODCART)+cNossoNum+cDACNossoN,"@R 999/99999999-9")//	04 // Nosso N�mero Formatado
	Case SEE->EE_CODIGO == "033"
		aBarra[P_Barra_04]	:= Padl(cNossoNum+cDACNossoN,13,"0")//	04 // Nosso N�mero Formatado
	OtherWise
		aBarra[P_Barra_04]	:= Transform(ALLTRIM(SEE->EE_CODCART)+cNossoNum+cDACNossoN,"@R 999/99999999-9")//	04 // Nosso N�mero Formatado
EndCase	

//aDadTit[P_Tit_09]		:= Transform(aBarra[P_Barra_01], "99999.99999 99999.999999 99999.999999 9 99999999999999" )//	09	// C�digo do Barras Formatado

RestArea(aArea)

If lRet	
	lRet := VldCodBar(aBarra[P_Barra_01])
	If !lRet
		lRet	:= .F.
		Aadd(aLogs, "Codigo de barras '"+aBarra[P_Barra_01]+"' gerado � invalido para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
		Return .F.	
	EndIf
EndIf	

If lRet	
	lRet := VldCodBar(StrTran(StrTran(aBarra[P_Barra_02],".","")," ",""))
	If !lRet
		lRet	:= .F.
		Aadd(aLogs, "Linha digitavel '"+aBarra[P_Barra_02]+"' gerada � invalida para o titulo Fil.:"+cFilTit+", Num.:"+cNumTit+", Pref.:"+cPrefixo+" e Parc.:"+cParcela )
		Return .F.
	EndIf
EndIf	

If lRet
	//cFilePrint	:= aDadTit[P_Tit_02]+IIF( Empty(aDadTit[P_Tit_03]),"","_"+AllTrim(aDadTit[P_Tit_03]) )+"_"+StrTran(time(),":","")+".PDF"
	cFilePrint	:= aDadTit[P_Tit_02]+IIF( Empty(aDadTit[P_Tit_03]),"","_"+AllTrim(aDadTit[P_Tit_03]) )+".PDF"
	
	/* executa rotina de gera��o do boleto */
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
		cCodAux	:= cCodBanco // C�digo do Banco na C�mara de Compensa��o (Ita�=341)
		cCodAux	+= cMoeda // C�digo da moeda = "9"
		cCodAux	+= cCart // C�digo da carteira de cobran�a
		cCodAux	+= Left(cNossNum,2) // Dois primeiros d�gitos do Nosso N�mero
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 1
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,5)
	
		/* campo 2 */
		cCodAux	:= Substr(cNossNum,3,Len(cNossNum)-2) //Restante do Nosso N�mero
		cCodAux	+= cDvDAC//DAC do campo [Ag�ncia/Conta/Carteira/ Nosso N�mero]
		cCodAux	+= Left(cAgencia,3) 
		cCodAux	+= AllTrim(DacMod10(cCodAux)) // DAC que amarra o campo 2
		cCod		+= cCodAux//Left(cCodAux,5)+"."+SubStr(cCodAux,6,6)+" "
		
		/* campo 3 */
		cCodAux	:= SubStr(cAgencia,4,1)//F = Restante do n�mero que identifica a ag�ncia
		cCodAux	+= Left(cConta,5)+cDacCC//DacMod10(Left(cConta,5)) //Left(cConta,5)+cDvCC//GGGGGG = N�mero da conta corrente + DAC
		cCodAux	+= "000"//HHH = Zeros ( N�o utilizado )
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
		01 a 03 03 9(03) C�digo do Banco na C�mara de Compensa��o = '341'
		04 a 04 01 9(01) C�digo da Moeda = '9'
		05 a 05 01 9(01) DAC c�digo de Barras (Anexo 2)
		06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		10 a 19 10 9(08)V(2) Valor
		20 a 22 03 9(03) Carteira
		23 a 30 08 9(08) Nosso N�mero
		31 a 31 01 9(01) DAC [Ag�ncia /Conta/Carteira/Nosso N�mero] (Anexo 4)
		32 a 35 04 9(04) N.� da Ag�ncia BENEFICI�RIO
		36 a 40 05 9(05) N.� da Conta Corrente
		41 a 41 01 9(01) DAC [Ag�ncia/Conta Corrente] (Anexo 3)
		42 a 44 03 9(03) Zeros		
		--------------------------------------------------------------- */
		
		cDvDAC		:= DacMod10(SubStr(cAgencia,1,4)+cConta+cCart+cNossNum)//Modulo10(SubStr(cAgencia,4,1)+cConta+cDacCC+cNossNum)		
		cDACNossoN	:= cDvDAC
		
		cCod += cCodBanco	//01 a 03 03 9(03) C�digo do Banco na C�mara de Compensa��o = '341'
		cCod += cMoeda	// 04 a 04 01 9(01) C�digo da Moeda = '9'
		//cCod += cDvBLT	// 05 a 05 01 9(01) DAC c�digo de Barras (Anexo 2)
		cCod += cFatVenc // 06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		cCod += cValTit // 10 a 19 10 9(08)V(2) Valor
		cCod += cCart// 20 a 22 03 9(03) Carteira
		cCod += cNossNum// 23 a 30 08 9(08) Nosso N�mero
		cCod += cDvDAC // 31 a 31 01 9(01) DAC [Ag�ncia /Conta/Carteira/Nosso N�mero] (Anexo 4)
		cCod += cAgencia// 32 a 35 04 9(04) N.� da Ag�ncia BENEFICI�RIO
		cCod += cConta// 36 a 40 05 9(05) N.� da Conta Corrente
		cCod += AllTrim(cDacCC)//DacMod10(cConta) //cDvCC// 41 a 41 01 9(01) DAC [Ag�ncia/Conta Corrente] (Anexo 3)
		cCod += "000"// 42 a 44 03 9(03) Zeros			
		
		cDvBLT := U_GENA085D(cCod,cCodBanco)
		cCod	:= Left(cCod,4)+cDvBLT+SubStr(cCod,5,39)
		
	Case cCodBanco == "033"

		cDvDAC		:= U_GENA085D(cNossNum,cCodBanco)		
		cDACNossoN	:= cDvDAC
			
		/* ----------------------------- ITAU -------------------------
		01 a 03 03 9(03) C�digo do Banco na C�mara de Compensa��o = '341'
		04 a 04 01 9(01) C�digo da Moeda = '9'
		05 a 05 01 9(01) DAC c�digo de Barras (Anexo 2)
		06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		10 a 19 10 9(08)V(2) Valor
		20 a 22 03 9(03) Carteira
		23 a 30 08 9(08) Nosso N�mero
		31 a 31 01 9(01) DAC [Ag�ncia /Conta/Carteira/Nosso N�mero] (Anexo 4)
		32 a 35 04 9(04) N.� da Ag�ncia BENEFICI�RIO
		36 a 40 05 9(05) N.� da Conta Corrente
		41 a 41 01 9(01) DAC [Ag�ncia/Conta Corrente] (Anexo 3)
		42 a 44 03 9(03) Zeros		
		--------------------------------------------------------------- */
		cCod += cCodBanco	//01 a 03 03 9(03) C�digo do Banco na C�mara de Compensa��o = '341'
		cCod += cMoeda	// 04 a 04 01 9(01) C�digo da Moeda = '9'
		//cCod += cDvBLT	// 05 a 05 01 9(01) DAC c�digo de Barras (Anexo 2)
		cCod += cFatVenc // 06 a 09 04 9(04) Fator de Vencimento (Anexo 6)
		cCod += cValTit // 10 a 19 10 9(08)V(2) Valor
		cCod += "9"// 20 a 20 FIXO DE 9
		cCod += cValtoChar(Val(cCodCedente)) // 21-27 7 9 (07) n�mero do PSK(C�digo do Cliente)
		cCod += Padl(cNossNum+cDvDAC,13,"0")//Modulo11(cNossNum)// 28-40 13 9 (13) Nosso N�mero
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