#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

 
#DEFINE N_TOT_CAMPO	34

#DEFINE N_CEDENTE_1	01
#DEFINE N_CLIENTE		02
#DEFINE N_DTVENCIME	03
#DEFINE N_VALCOBRAD	04
#DEFINE N_AG_CONTA1	05
#DEFINE N_NOSSO_NUM	06
#DEFINE N_LINHA_DIG	07
#DEFINE N_LOG_PAGAM	08
#DEFINE N_VENCIMENT	09
#DEFINE N_CEDENTE_2	10
#DEFINE N_AG_CONTA2	11
#DEFINE N_DT_DOCUME	12
#DEFINE N_NUM_DOCUM	13
#DEFINE N_ESPECIE  	14
#DEFINE N_ACEITE   	15
#DEFINE N_ENDBENSAC	16
#DEFINE N_DT_PROCES	17
#DEFINE N_NOS_NUMCD	18
#DEFINE N_USO_BANCO	19
#DEFINE N_CARTEIRA 	20
#DEFINE N_ESPEC_MOE	21
#DEFINE N_QTD_MOEDA	22
#DEFINE N_VAL_MOEDA	23
#DEFINE N_VAL_DOCUM	24
#DEFINE N_INSTRUCOE	25
#DEFINE N_DESCONTO 	26
#DEFINE N_OUTRA_DED	27
#DEFINE N_MULTAS   	28
#DEFINE N_ACRESCIMO	29
#DEFINE N_VAL_COB_2	30
#DEFINE N_PAGADOR 	31
#DEFINE N_ENDE_PAG  	32
#DEFINE N_SACADO   	33
#DEFINE N_COD_BARRA	34

/* Cleuto - 13/03/2019 - sempre que manipular estes campos replicar a altera็ใo no fonte GENA085 */

#DEFINE P_Emp_01	01 // Nome da Empresa
#DEFINE P_Emp_02	02 // Endere็o
#DEFINE P_Emp_03	03 // Bairro
#DEFINE P_Emp_04	04 // Cidade
#DEFINE P_Emp_05	05 // Estado
#DEFINE P_Emp_06	06 // Cep
#DEFINE P_Emp_07	07 // Telefone
#DEFINE P_Emp_08	08 // Fax
#DEFINE P_Emp_09	09 // CNPJ
#DEFINE P_Emp_10	10 // Inscri็ใo Estadual
#DEFINE P_Emp_11	11 // sacador avalista
#DEFINE P_Emp_SZ	11 // tamanho do array dados da empresa

#DEFINE P_Bco_01	01 // C๓digo do Banco
#DEFINE P_Bco_02	02 // Dํgito do Banco
#DEFINE P_Bco_03	03 // C๓digo da Ag๊ncia
#DEFINE P_Bco_04	04 // Dํgito da Ag๊ncia
#DEFINE P_Bco_05	05 // N๚mero da Conta Corrente
#DEFINE P_Bco_06	06 // Dํgito da Conta Corrente
#DEFINE P_Bco_07	07 // Nome Completo do Banco
#DEFINE P_Bco_08	08 // Nome Reduzido do Banco
#DEFINE P_Bco_09	09 // Nome do Arquivo com o Logotipo do Banco
#DEFINE P_Bco_10	10 // Taxa de juros a ser utilizado no cแlculo de juros de mora
#DEFINE P_Bco_11	11 // Taxa de multa a ser impressa no boleto
#DEFINE P_Bco_12	12 // N๚mero de dias para envio do tํtulo ao cart๓rio
#DEFINE P_Bco_13	13 // Dado para o campo "Uso do Banco"
#DEFINE P_Bco_14	14 // Dado para o campo "Esp้cie do Documento"
#DEFINE P_Bco_15	15 // C๓digo do Cedente
#DEFINE P_Bco_16	16 // tamanho da imagem do banco
#DEFINE P_Bco_SZ	16 // tamanho do array dados do banco
		
#DEFINE P_Tit_01	01	// Prefixo do Tํtulo
#DEFINE P_Tit_02	02	// N๚mero do Tํtulo
#DEFINE P_Tit_03	03	// Parcela do Tํtulo
#DEFINE P_Tit_04	04	// Tipo do tํtulo
#DEFINE P_Tit_05	05	// Data de Emissใo do tํtulo
#DEFINE P_Tit_06	06	// Data de Vencimento do Tํtulo
#DEFINE P_Tit_07	07	// Data de Vencimento Real
#DEFINE P_Tit_08	08	// Valor Lํquido do Tํtulo
#DEFINE P_Tit_09	09	// C๓digo do Barras Formatado
#DEFINE P_Tit_10	10	// Carteira de Cobran็a
#DEFINE P_Tit_11	11	// 1.a Linha de Mensagens Diversas
#DEFINE P_Tit_12	12	// 2.a Linha de Mensagens Diversas
#DEFINE P_Tit_13	13	// 3.a Linha de Mensagens Diversas
#DEFINE P_Tit_14	14	// 4.a Linha de Mensagens Diversas
#DEFINE P_Tit_15	15	// 5.a Linha de Mensagens Diversas
#DEFINE P_Tit_16	16	// 6.a Linha de Mensagens Diversas
#DEFINE P_Tit_17	17	// DESCONTOS E ABATIMENTOS
#DEFINE P_Tit_18	18	// MORA / MULTAS
#DEFINE P_Tit_19	19	// VALOR COBRADO
#DEFINE P_Tit_20	20	// data de gera็ใo do boleto
#DEFINE P_Tit_SZ	20	// tamanho do array dados titulo

#DEFINE P_Cli_01	01 // C๓digo do cliente
#DEFINE P_Cli_02	02 // Loja do Cliente
#DEFINE P_Cli_03	03 // Nome Completo do Cliente
#DEFINE P_Cli_04	04 // CNPJ do Cliente
#DEFINE P_Cli_05	05 // Inscri็ใo Estadual do cliente
#DEFINE P_Cli_06	06 // Tipo de Pessoa do Cliente
#DEFINE P_Cli_07	07 // Endere็o
#DEFINE P_Cli_08	08 // Bairro
#DEFINE P_Cli_09	09 // Municํpio
#DEFINE P_Cli_10	10 // Estado
#DEFINE P_Cli_11	11 // Cep
#DEFINE P_Cli_SZ	11 // tamanho do array dados titulo

#DEFINE P_Barra_01	01 // C๓digo de barras (Banco+"9"+Dํgito+Fator+Valor+Campo Livre
#DEFINE P_Barra_02	02 // Linha Digitแvel
#DEFINE P_Barra_03	03 // Nosso N๚mero sem formata็ใo
#DEFINE P_Barra_04	04 // Nosso N๚mero Formatado
#DEFINE P_Barra_SZ	04 // tamanho do array dados codigo de barras

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENA086   บAutor  ณ Cleuto P. Lima     บ Data ณ  15/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera boleto                                  				 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENA086(aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp,cDirPDF,cFilePrint,lViewPDF)

Local lPreview	:= .F. 
Local lRet			:= .F.
Local nCountVld	:= 0
Local cSession	:= GetPrinterSession()

Private nBoxBol		:= 960	// Area de imressใo dos Box's principais do recibo e da ficha de compensa็ใo 
Private aLayout		:= ARRAY(N_TOT_CAMPO)
Private opFontN		:= TFont():New( "Arial",,-15,,.T.,,,,,.F.)
Private opFnt13N		:= TFont():New( "Arial",,-13,,.T.,,,,,.F.)
Private opFnt15		:= TFont():New( "Arial",,-15,,.F.,,,,,.F.)//opFont7		:= TFontEx():New(oprn,"MS LineDraw New",08,  ,.F.,.T.,.F.)
Private opFont		:= TFont():New( "Arial",,-10,,.T.,,,,,.F.)
Private opFTitu		:= TFont():New( "Arial",,-13,,.F.,,,,,.F.)
Private opFnt10		:= TFont():New( "Arial",,-10,,.F.,,,,,.F.)

Private opFont2N		:= TFont():New( "Arial",,-20,,.T.,,,,,.F.)
Private opFnt19		:= TFont():New( "Arial",,-19,,.F.,,,,,.F.)
Private opFDados		:= TFont():New( "Arial",,-14,,.F.,,,,,.F.)
Private opFDadosN		:= TFont():New( "Arial",,-15,,.T.,,,,,.F.)
Private opFDados2		:= TFont():New( "Arial",,-09,,.F.,,,,,.F.)
Private oFLinDigN		:= TFont():New( "Arial",,-17,,.T.,,,,,.F.)
Private opFT12		:= TFont():New( "Arial",,-12,,.F.,,,,,.F.)

Private nLimtLeft		:= 0
Private nLimtRight	:= 0
Private nLimitTop		:= 0
Private nLimitDown	:= 0

Default cDirPDF		:= GetTempPath()
Default cFilePrint 	:= CriaTrab("",.f.)
Default lViewPDF		:= .T.
	
WFForceDir(cDirPDF)  
FErase(cDirPDF+cFilePrint)
lPreview := .T.
lAdjustToLegacy := .T. // Inibe legado de resolu็ใo com a TMSPrinter
oprn 			:= FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, cDirPDF, .T.,,,,FWGetRunSchedule(),,,,1)

// ----------------------------------------------
// Define para salvar o PDF
// ----------------------------------------------
oprn:SetPortrait()
oprn:SetPaperSize(DMPAPER_A4) 
oprn:nDevice 		:= IMP_PDF
//oprn:nQtdCopy		:= 1
oprn:lServer 		:= FWGetRunSchedule()
oprn:lViewPDF		:= lViewPDF 
oprn:cPathPDF 	:= cDirPDF
oprn:IsFirstPage	:= .T.

oprn:StartPage()

/* -- Configura็ใo para primeira impressใo do recibo do sacado -- */
nLimtLeft	:= 236//oprn:NPAGEWIDTH*0.10
nLimtRight	:= oprn:NPAGEWIDTH-130
nLimitTop	:= 354//oprn:NPAGEHEIGHT*0.07
nLimitDown	:= nBoxBol+nLimitTop	//oprn:NPAGEHEIGHT*0.43 // 36% do recibo do pagador + 7% consumido pela margem = 46%
/* ------------------------------------------------------------   */

//For nAuxPx := 1 To oprn:NPAGEHEIGHT step 20
// lico remover do fonte	oprn:Say( nAuxPx, 50, StrZero(nAuxPx,4)+" "+ Replicate("-",100), opFDados2, 10)
//Next 

ImpLayout(oprn,"R",aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)
ImpDados(oprn,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp,"R")

/* -- Configura็ใo para primeira impressใo do recibo do sacado -- */
nLimitTop	:= nLimitDown+340//oprn:NPAGEHEIGHT*0.07
nLimitDown	:= nLimitTop+nBoxBol//oprn:NPAGEHEIGHT*0.43 // 36% do recibo do pagador + 7% consumido pela margem = 46%
/* ------------------------------------------------------------   */

ImpLayout(oprn,"F",aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)
ImpDados(oprn,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp,"F")

oprn:lServer := FWGetRunSchedule()
oPrn:Print()  

FreeObj(oPrn)
FreeObj(opFontN)
FreeObj(opFnt15)
FreeObj(opFont)
FreeObj(opFTitu)
FreeObj(opFnt10)
FreeObj(opFont2N)
FreeObj(opFnt19)
FreeObj(opFDados)
FreeObj(opFDadosN)
FreeObj(opFDados2)
FreeObj(oFLinDigN)
FreeObj(opFnt13N)
FreeObj(opFT12)

oPrn := nil

While !lRet .AND. nCountVld <= 10

	aFiles := Directory(cDirPDF+cFilePrint)			
	If File(cDirPDF+cFilePrint)  .AND. Len(aFiles) > 0 .AND. aFiles[1][2] > 0
		lRet	:= .T.
	Else
		nCountVld++	
		Sleep(5000)
	EndIf
	
EndDo

Return lRet
              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpLayout บAutor  ณCleuto Lima-Oficina1บ Data ณ  07/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar layout de impressใo do boleto.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Multirede.                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpLayout(oprn,cModelo,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

Local nTLinRec	:= IIF( cModelo == "R" ,82,85)	// Tamanho da linha do recibo do sacado
Local nColCli		:= (nLimtRight-nLimtLeft)*0.55	// Posicใo da linha que limita o campo Nome do cliente em pocentagem, 70% do total da impressใo
Local nColVen		:= (nLimtRight-nLimtLeft)*0.75	// Posicใo da linha que limita o campo Data de Vencimento pocentagem, 10% do total da impressใo

Local nColNoN		:= nColCli/2

Local nPosLin		:= nLimitTop // Posi็ใo incial da impressใo
Local nAjustTop	:= 25
Local nAjustLef	:= 20
Local nAjTopFont	:= 30
Local nCol1		:= (nLimtRight*0.75)
Local oBrush 		:= TBrush():New( , Rgb(227,227,227) )
Local nLargCol0	:= nCol1-nLimtLeft

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecibo do sacado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

oprn:SayBitmap ( (nPosLin-aDadBco[P_Bco_16][3])-(aDadBco[P_Bco_16][2]) , nLimtLeft+2, "\workflow\html\imagens\"+AllTrim(aDadBco[P_Bco_09]), aDadBco[P_Bco_16][1], aDadBco[P_Bco_16][2] )
oprn:Say( nPosLin-10, nLimtLeft+160, aDadBco[P_Bco_07], opFnt19, 10)

nPoIniBox	:= nPosLin
oprn:Box ( nPosLin, nLimtLeft, nLimitDown, nLimtRight, "-8" )

oprn:Line( nPosLin-nTLinRec, nLimtLeft+550, nPosLin, nLimtLeft+550,,"-8")
oprn:Say( nPosLin-10, nLimtLeft+565, aDadBco[P_Bco_01]+"-"+aDadBco[P_Bco_02], opFnt19, 10)
oprn:Line( nPosLin-nTLinRec, nLimtLeft+710, nPosLin, nLimtLeft+710,,"-8")

// posi็ใo para impressใo da linha digitavel
aLayout[N_LINHA_DIG]	:= {nPosLin-10,nLimtLeft+630}


oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Local de Pagamento", opFTitu, 10)
aLayout[N_LOG_PAGAM]	:= {nPosLin,nLimtLeft}

oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "Vencimento", opFTitu, 10)
aLayout[N_VENCIMENT]	:= {nPosLin,nCol1}

IF cModelo == "R"
	nPosLin	+= nTLinRec
//nPosLin	+= (nTLinRec/2)                                  
	oprn:Line( nPosLin, nLimtLeft, nPosLin, nLimtRight,,"-8")
	oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Endere็o Beneficiแrio / Sacador Avalista", opFTitu, 10)
	aLayout[N_ENDBENSAC]	:= {nPosLin,nLimtLeft}
EndIF

nPosLin	+= nTLinRec

oprn:Line( nPosLin, nLimtLeft, nPosLin, nLimtRight,,"-8")
oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Beneficiแrio", opFTitu, 10)
aLayout[N_CEDENTE_2]	:= {nPosLin,nLimtLeft}

Do Case
	Case aDadBco[P_Bco_01] == "341"
		oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "Ag๊ncia / C๓digo do Cedente", opFTitu, 10)
	Case aDadBco[P_Bco_01] == "033"
		oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "Ag๊ncia / C๓digo do Beneficiแrio", opFTitu, 10)		
	OtherWise
		oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "Ag๊ncia / C๓digo do Cedente", opFTitu, 10)		
EndCase
aLayout[N_AG_CONTA2]	:= {nPosLin,nCol1}

nPosLin	+= nTLinRec

nColAux	:= nLimtLeft
oprn:Line( nPosLin, nColAux, nPosLin, nLimtRight,,"-8")
oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Data Documento", opFTitu, 10)
aLayout[N_DT_DOCUME]	:= {nPosLin,nLimtLeft}

Do Case
	Case aDadBco[P_Bco_01] == "341"
		nColAux	:= nColAux+(nLargCol0*0.22)
	Case aDadBco[P_Bco_01] == "033"
		nColAux	:= nColAux+(nLargCol0*0.18)		
	OtherWise
		nColAux	:= nColAux+(nLargCol0*0.22)		
EndCase
                 
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "N do Documento", opFTitu, 10)
aLayout[N_NUM_DOCUM]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.25)                 
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Esp้cie Doc.", opFTitu, 10)
aLayout[N_ESPECIE]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.17)                
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Aceite", opFTitu, 10)
aLayout[N_ACEITE]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.10)
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Data Processamento", opFTitu, 10)
aLayout[N_DT_PROCES]	:= {nPosLin,nColAux}

oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "Nosso N๚mero / C๓d.Do Documento", opFTitu, 10)
aLayout[N_NOS_NUMCD]	:= {nPosLin,nCol1}

nPosLin	+= nTLinRec
oprn:Line( nPosLin, nLimtLeft, nPosLin, nLimtRight,,"-8")

nColAux	:= nLimtLeft
oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Uso do Banco", opFTitu, 10)
aLayout[N_USO_BANCO]	:= {nPosLin,nLimtLeft}

Do Case
	Case aDadBco[P_Bco_01] == "341"
		nColAux	:= nColAux+(nLargCol0*0.22)
	Case aDadBco[P_Bco_01] == "033"
		nColAux	:= nColAux+(nLargCol0*0.18)		
	OtherWise
		nColAux	:= nColAux+(nLargCol0*0.22)		
EndCase

oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Carteira", opFTitu, 10)
aLayout[N_CARTEIRA]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.15)
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Esp้cie", opFTitu, 10)
aLayout[N_ESPEC_MOE]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.10)
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Quantidade", opFTitu, 10)
aLayout[N_QTD_MOEDA]	:= {nPosLin,nColAux}

nColAux	:= nColAux+(nLargCol0*0.27)
oprn:Line( nPosLin, nColAux, nPosLin+nTLinRec, nColAux,,"-8")
oprn:Say( nPosLin+nAjTopFont, nColAux+nAjustLef, "Valor", opFTitu, 10)
aLayout[N_VAL_MOEDA]	:= {nPosLin,nColAux}

oprn:Say( nPosLin+nAjTopFont, nCol1+nAjustLef, "(=) Valor Documento", opFTitu, 10)
aLayout[N_VAL_DOCUM]	:= {nPosLin,nCol1}

nPosLin	+= nTLinRec
oprn:Line( nPosLin, nLimtLeft, nPosLin, nLimtRight,,"-8")
oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Instru็๕es de responsabilidade do BENEFICIมRIO. Qualquer d๚vida sobre este boleto contate o beneficiแrio.", opFnt10, 10)
aLayout[N_INSTRUCOE]	:= {nPosLin,nLimtLeft}

nLinAux	:= nPosLin
nPosLin	+= nTLinRec
nPosLin	+= nTLinRec                         
nPosLin	+= nTLinRec
nPosLin	+= nTLinRec

oprn:Say( nLinAux+nAjTopFont, nCol1+nAjustLef, "(-) Desconto / Abatimento", opFTitu, 10)
aLayout[N_DESCONTO]	:= {nLinAux,nCol1}

nTamAux	:= ((nPosLin+nTLinRec)-nLinAux)/5
nLinAux+=nTamAux
oprn:Line( nLinAux, nCol1, nLinAux, nLimtRight,,"-8")
oprn:Say( nLinAux+nAjTopFont, nCol1+nAjustLef, "", opFTitu, 10)
aLayout[N_OUTRA_DED]	:= {nLinAux,nCol1}

nLinAux+=nTamAux
oprn:Line( nLinAux, nCol1, nLinAux, nLimtRight,,"-8")
oprn:Say( nLinAux+nAjTopFont, nCol1+nAjustLef, "(+) Mora / Multas", opFTitu, 10)
aLayout[N_MULTAS]	:= {nLinAux,nCol1}

nLinAux+=nTamAux
oprn:Line( nLinAux, nCol1, nLinAux, nLimtRight,,"-8")
oprn:Say( nLinAux+nAjTopFont, nCol1+nAjustLef, "", opFTitu, 10)
aLayout[N_ACRESCIMO]	:= {nLinAux,nCol1}

nLinAux+=nTamAux
oprn:Line( nLinAux, nCol1, nLinAux, nLimtRight,,"-8")
oprn:Say( nLinAux+nAjTopFont, nCol1+nAjustLef, "(=) Valor Cobrado", opFTitu, 10)
aLayout[N_VAL_COB_2]	:= {nLinAux,nCol1}

nPosLin+=nTamAux
oprn:Line( nPosLin, nLimtLeft, nPosLin, nLimtRight,,"-8")

oprn:Say( nPosLin+nAjTopFont, nLimtLeft+nAjustLef, "Pagador:", opFTitu, 10)
aLayout[N_PAGADOR]	:= {nPosLin+nAjTopFont,nLimtLeft+nAjustLef+150}

oprn:Say( nPosLin+nAjTopFont+050, nLimtLeft+nAjustLef, "Endere็o:", opFTitu, 10)
aLayout[N_ENDE_PAG]	:= {nPosLin+nAjTopFont+050,nLimtLeft+nAjustLef+160}

oprn:Say( nPosLin+nAjTopFont+100, nLimtLeft+nAjustLef, "Sacador/Avalista:", opFTitu, 10)
aLayout[N_SACADO]	:= {nPosLin+nAjTopFont+100,nLimtLeft+nAjustLef+265}

/* coluna a direita que separa os campos de valores */
oprn:Line( nLimitTop, nCol1, nPosLin, nCol1,,"-8")

IF cModelo == "F"
	oprn:SayAlign( nLimitDown, nLimtLeft,"Ficha de Compensa็ใo",opFnt13N,nLimtRight-nLimtLeft, 50, CLR_BLACK, 1, 0 )
	oprn:SayAlign( nLimitDown+35, nLimtLeft,"Autentica็ใo Mecโnica",opFTitu,nLimtRight-nLimtLeft, 50, CLR_BLACK, 1, 0 )
Else
	oprn:SayAlign( nLimitDown, nLimtLeft,"Autentica็ใo Mecโnica",opFTitu,nLimtRight-nLimtLeft, 50, CLR_BLACK, 1, 0 )
	oprn:Say( nLimitDown+100, nLimtLeft,Replicate("- ",107),opFTitu, 05 )	
EndIF	

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPDFSAFRA  บAutor  ณMicrosiga           บ Data ณ  02/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ImpDados(oprn,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

Local nAjustLef	:= 25
Local nAjTopFont	:= 65
Local nMgTopFt	:= 30
Local nTLinRec	:= 100
Local nAjustLef2	:= 50
Local bToDate		:= {|x| Right(DtoS(x),2) + "/" + Substr(DtoS(x),5,2) + "/" + Left(DtoS(x),4) }

oprn:Say( aLayout[N_LINHA_DIG,1], aLayout[N_LINHA_DIG,2]+100, Transform(aBarra[P_Barra_02],"@R 99999.99999 99999.999999 99999.999999 9 99999999999999") , oFLinDigN, 10)

oprn:Say( aLayout[N_LOG_PAGAM,1]+nAjTopFont, aLayout[N_LOG_PAGAM,2]+nAjustLef, "EM QUALQUER BANCO OU CORRESP. NAO BANCARIO" , opFDados, 10)

oprn:SayAlign( aLayout[N_VENCIMENT,1]+nMgTopFt, aLayout[N_VENCIMENT,2] , eVal(bToDate,aDadTit[P_Tit_07]) ,opFDados, (nLimtRight-80)-aLayout[N_VENCIMENT,2] , 05, CLR_BLACK, 1, 1 )

oprn:Say( aLayout[N_ENDBENSAC,1]+nAjTopFont, aLayout[N_ENDBENSAC,2]+nAjustLef, aDadEmp[P_Emp_02] , opFDados, 10)
oprn:Say( aLayout[N_CEDENTE_2,1]+nAjTopFont, aLayout[N_CEDENTE_2,2]+nAjustLef, aDadEmp[P_Emp_01]/*+" CNPJ: "+Transform(AllTrim(aDadEmp[P_Emp_09]), "@R 99.999.999/9999-99")*/ , opFDados, 10)

oprn:SayAlign( aLayout[N_AG_CONTA2,1]+nMgTopFt, aLayout[N_AG_CONTA2,2], aDadBco[P_Bco_03]+" / "+aDadBco[P_Bco_15] , opFDados ,(nLimtRight-80)-aLayout[N_AG_CONTA2,2], 05, CLR_BLACK, 1, 1 )

oprn:Say( aLayout[N_DT_DOCUME,1]+nAjTopFont, aLayout[N_DT_DOCUME,2]+nAjustLef, eVal(bToDate,aDadTit[P_Tit_05]) , opFDados, 10)
oprn:Say( aLayout[N_NUM_DOCUM,1]+nAjTopFont, aLayout[N_NUM_DOCUM,2]+nAjustLef, aDadTit[P_Tit_02] , opFDados, 10)
oprn:Say( aLayout[N_ESPECIE,1]+nAjTopFont, aLayout[N_ESPECIE,2]+nAjustLef+nAjustLef2, aDadBco[P_Bco_14] , opFDados, 10)
oprn:Say( aLayout[N_ACEITE,1]+nAjTopFont, aLayout[N_ACEITE,2]+nAjustLef+nAjustLef2, "N" , opFDados, 10)
oprn:Say( aLayout[N_DT_PROCES,1]+nAjTopFont, aLayout[N_DT_PROCES,2]+nAjustLef+nAjustLef2, StrZero(Day(aDadTit[P_Tit_20]),2)+"/"+ ;
								StrZero(Month(aDadTit[P_Tit_20]),2)+"/"+ ;
								StrZero(Year(aDadTit[P_Tit_20]),4) , opFDados, 10)

oprn:SayAlign( aLayout[N_NOS_NUMCD,1]+nMgTopFt, aLayout[N_NOS_NUMCD,2], aBarra[P_Barra_04] , opFDados,(nLimtRight-80)-aLayout[N_NOS_NUMCD,2], 05, CLR_BLACK, 1, 1 )

Do Case
	Case aDadBco[P_Bco_01] == "341"
		oprn:Say( aLayout[N_CARTEIRA,1]+nAjTopFont, aLayout[N_CARTEIRA,2]+nAjustLef+nAjustLef2, aDadTit[P_Tit_10] , opFDados, 10)
		oprn:Say( aLayout[N_ESPEC_MOE,1]+nAjTopFont, aLayout[N_ESPEC_MOE,2]+nAjustLef+nAjustLef2, "R$" , opFDados, 10)
	OtherWise
		oprn:Say( aLayout[N_CARTEIRA,1]+nAjTopFont, aLayout[N_CARTEIRA,2]+nAjustLef, aDadTit[P_Tit_10] , opFT12, 10)	
		oprn:Say( aLayout[N_ESPEC_MOE,1]+nAjTopFont, aLayout[N_ESPEC_MOE,2]+nAjustLef, "REAL" , opFT12, 10)
EndCase
		
oprn:Say( aLayout[N_QTD_MOEDA,1]+nAjTopFont, aLayout[N_QTD_MOEDA,2]+nAjustLef, "" , opFDados, 10)
oprn:Say( aLayout[N_VAL_MOEDA,1]+nAjTopFont, aLayout[N_VAL_MOEDA,2]+nAjustLef, "" , opFDados, 10)

oprn:SayAlign( aLayout[N_VAL_DOCUM,1]+nMgTopFt, aLayout[N_VAL_DOCUM,2], Transform(aDadTit[P_Tit_08],"@E 9999,999,999.99") , opFDados,(nLimtRight-80)-aLayout[N_VAL_DOCUM,2], 05, CLR_BLACK, 1, 1 )

If !Empty(aDadTit[P_Tit_17]) .OR. !Empty(aDadTit[P_Tit_18]) 
	oprn:SayAlign( aLayout[N_DESCONTO,1]+nMgTopFt, aLayout[N_DESCONTO,2], Transform(aDadTit[P_Tit_17],"@E 9999,999,999.99") , opFDados,(nLimtRight-80)-aLayout[N_DESCONTO,2], 05, CLR_BLACK, 1, 1 )
	oprn:SayAlign( aLayout[N_MULTAS,1]+nMgTopFt, aLayout[N_MULTAS,2], Transform(aDadTit[P_Tit_18],"@E 9999,999,999.99") , opFDados,(nLimtRight-80)-aLayout[N_MULTAS,2], 05, CLR_BLACK, 1, 1 )
	oprn:SayAlign( aLayout[N_VAL_COB_2,1]+nMgTopFt, aLayout[N_VAL_COB_2,2], Transform(aDadTit[P_Tit_19],"@E 9999,999,999.99") , opFDados,(nLimtRight-80)-aLayout[N_VAL_COB_2,2], 05, CLR_BLACK, 1, 1 )
EndIf

//oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont, aLayout[N_INSTRUCOE,2]+nAjustLef,"" , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+000, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[11] , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+025, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[12] , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+050, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[13] , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+075, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[14] , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+100, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[15] , opFDados2, 10)
oprn:Say( aLayout[N_INSTRUCOE,1]+nAjTopFont+125, aLayout[N_INSTRUCOE,2]+nAjustLef,aDadTit[16] , opFDados2, 10)

oprn:Say( aLayout[N_PAGADOR,1], aLayout[N_PAGADOR,2], aDadCli[P_Cli_03]+ Space(10) + "CNPJ/CPF"+ Space(05) + Transform(AllTrim(aDadCli[P_Cli_04]), IIF( aDadCli[P_Cli_06] == "F" , "@R 999.999.999-99" , "@R 99.999.999/9999-99" )) , opFDados, 10)

oprn:Say( aLayout[N_ENDE_PAG,1], aLayout[N_ENDE_PAG,2], aDadCli[P_Cli_07]+" "+aDadCli[P_Cli_08]+" "+aDadCli[P_Cli_11]+" "+aDadCli[P_Cli_09]+" "+aDadCli[P_Cli_10]  , opFDados, 10)
oprn:Say( aLayout[N_SACADO,1], aLayout[N_SACADO,2], aDadEmp[P_Emp_11]  , opFDados, 10)

//msBar3( "INT25",17 , 0.5, aBarra[P_Barra_01], oprn, .F., , .T., 0.025, 0.8, .F., 'Interleaved 2of5 NT', , .F. )
oprn:FWMSBAR("INT25" /*cTypeBar*/,62.5/*nRow*/ ,5/*nCol*/, aBarra[P_Barra_01]/*cCode*/,oprn/*oPrint*/,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,/*nWidth*/,1/*nHeigth*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,2/*nPFWidth*/,2/*nPFHeigth*/,.T./*lCmtr2Pix*/)
/*
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[N_USO_BANCO]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[]
aLayout[N_DESCONTO]
aLayout[N_OUTRA_DED]
aLayout[N_MULTAS]
aLayout[N_ACRESCIMO]
aLayout[N_VAL_COB_2]
aLayout[]
aLayout[N_COD_BARRA]
*/
Return nil 