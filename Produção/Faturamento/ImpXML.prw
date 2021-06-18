#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpXML    º Autor ³ Danilo Azevedo     º Data ³  09/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FUNCAO PARA IMPORTACAO DE XML                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImpXMLNFE(lJob)

Local aArq
Local cFile := ""
Local I

//Local lJob := .F.

Private cPath  := "\nfe\"

//PREPARE ENVIRONMENT EMPRESA "00" FILIAL "1001" MODULO "EST" TABLES "SA2", "SA5", "SD1", "SB1", "SLK"

//While .T.

aArq := directory(cPath+"*.xml")
For I := 1 To len(aArq)
	cFile := lower(aArq[I][1])
	
	XMLNFE(cFile)
Next I

//    If !lJob // Se nao for chamado como job sai apos a primeira iteracao
//   	Exit
//   EndIf
//	Sleep(5000) // Aguarda 5 segundos para iniciar a verificacao
//End

Return()

Static Function XMLNfe(cFile)

Local cError  	:= ""
Local cWarning 	:= ""
Local oXml 		:= NIL

// variaveis utilizadas para a amarracao com o pedido de compra
Local aPrdCom	:= {}
Local aContr	:= {}
Local nY		:= 0
Local nW		:= 0
Local nDescCom	:= 0
Local nValCom	:= 0
Local nDesComT	:= 0
Local nValComT	:= 0
Local nQtdeRest := 0
Local nDescRest	:= 0
Local cPedCom	:= ""
Local cPedComI	:= ""
Local cNumNewPed:= ""
Local aFornPed	:= {}
Local nPosPed	:= 0
Local cNumPed	:= ""
Local cItemPed	:= ""
Local cNumNewPed:= ""
Local cMaiorItem:= "0000"

oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
If ValType(oXml) != "O"
	Alert(cFile+" - "+cError)
	Return()
Endif

// Alterado para tratar quando nao tem o nó _NFEPROC
oNFE := XmlChildEx( oXml , "_NFE" )
If ValType(oNFE) = "U"
	oNFE := XmlChildEx( oXml:_NFEPROC , "_NFE" )
Endif

If ValType(oNFE:_InfNfe:_DET) = "O"
	XmlNode2Arr(oNFE:_InfNfe:_DET, "_DET")
EndIf

Private cNum //Numero da Nota
Private cForn := ""
Private cLjFornec := ""
//Private cNaturez
//Private cError := 0
//Private nErrorItem := 0

Private cChvNFE
Private cCNPJ_FIL // Cnpj da Loja
Private cCNPJ_FOR// Cnpj da Loja

Private cDtEmissao
Private cCcd // Centro de Custo
//Private cPref  // Prefixo da Filial
Private cFilorig   // Filial de Origem

Private nDescVar
Private nDescNota
Private nDescItens

Private nIcms
Private nIcmsRet
Private nIcmsRepa
Private nIcmsSubs

Private nSeguro
Private nFrete
Private nAdicional

Private nIcmsPer
Private nIcmsBase

Private cSerie := "   "
Private cTipo := "N"
//Private cCod

Private nCont
Private cCodigo
Private cUM
Private bLote
Private cLote
Private cValidade

Private cCodBarra
Private nQuant
Private nPrcUnLiq
Private nDescItem // %
Private nValDesc // $
Private nItem := 0
Private cNcm := space(10)

Private bMed
Private nContLote // Contador do For
Private nTotalMed // Len do Array Med
Private nQtdeLote // Qtde do Lote Atual
Private nDescLote // Desconto do Lote Atual
Private nValLote  // Valor do Lote Atual
Private nDescTT   // Acumulado do Desconto
Private nValorTT  // Acumulado
Private cUnidad   // Unidade do fornecedor
Private nFator    // Fator de Conversao

Private nNumItens
Private nNumUnid

Private nTotalMerc

Private cNumTitulo
Private nValor
Private cVencimento
Private nDescDia
Private nDescFin
Private nJurosDia
Private nMulta
Private nAcrescimo

Private aCabec := {}
Private aItens := {}
Private aLinha := {}
Private lOk    := .T.
Private lMsErroAuto := .F.
Private lMsHelpAuto	:= .T.
Private lExcluir    := .F.

Private cArqLog := cPath+substr(cFile,1,at(".xml" ,cFile)-1) /*+"_"+ dtos(date())*/+".log"

Private cFound := 0 // Resultado de Busca

// inicializa as variaveis de controle
nError := 0
cFilorig := "1001"
/*
cCNPJ_FIL := oNFE:_INFNFE:_DEST:_CNPJ:TEXT

OpenSm0()
SM0->(dbGoTop())
While !SM0->(Eof())
If cEmpAnt != SM0->M0_CODIGO
SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
loop
Endif

If cCNPJ_FIL = SM0->M0_CGC
cFilorig := SM0->M0_CODFIL
Exit //Forca a saida
Endif

SM0->(dbskip())
EndDo
Do Case
Case cFilorig = "XX"
//Msgbox("Impossivel identificar Filial! Informe ao Programador.")
Geralog("Filial Nao identificada: "+cCNPJ_FIL, cArqlog)
nError += 1
Case cFilorig = "00"
cCcd	:= "00040103"
Otherwise
cCcd	:= cFilOrig+"1015"
EndCase
*/
cChvNFE   := substr(oNFE:_INFNFE:_ID:TEXT,4)

// Validar na receita e incluir se estiver Ok
/*
If !(u_ValidaNFE(cChvNFE))
Geralog("NF-E não autorizada: "+cChvNFE, cArqlog)
nError += 1
endif
*/

cCNPJ_FOR := oNFE:_INFNFE:_EMIT:_CNPJ:TEXT
DBSelectArea("SA2")
DBSetOrder(3)
If MSSeek(xFilial("SA2")+cCNPJ_FOR)
	cForn := A2_COD
	cLjFornec := A2_LOJA
	cNaturez := A2_EST
Else
	Geralog("Impossivel identificar Fornecedor! " + cCNPJ_FOR, cArqlog)
	nError += 1
Endif

cNum := padL(Alltrim(oNFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie := PadR(oNFE:_InfNfe:_IDE:_Serie:Text,3," ")

nNumItens	:= len(oNFE:_InfNfe:_DET)
cDtEmissao := oNFE:_INFNFE:_IDE:_dEmi:Text
cDtEmissao := Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)

nTotalMerc := Val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text) // Valor Mercadorias

//			nDescTT = 0 // Inicializa a variavel para realizar o somatorio de descontos da nota.
//			nTotalBrt = Val(Substr(cBuffer,69,12))/100

//	nDescVar 	:= Val(Substr(cBuffer,1,13))/100
nDescNota	:= val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
//	nDescItens 	:= Val(Substr(cBuffer,29,13))/100

//	nIcms  		:= Val(Substr(cBuffer,1,13))/100
//	nIcmsRet 	:= Val(Substr(cBuffer,14,13))/100
//	nIcmsRepa 	:= Val(Substr(cBuffer,117,13))/100


cNumTitulo 	:= cNum // Substr(cBuffer,1,10)
nValor		:= Val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)

If XmlChildEx ( oNFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
	nAcrescimo	:= Val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
Else
	nAcrescimo  := 0
Endif

cVencimento := ""
If XmlChildEx ( oNFE:_INFNFE , "_COBR" ) != Nil
	//Voltar mas tem que alterar para aceitar varias parcelas.
	//cVencimento	:= oNFE:_INFNFE:_COBR:_DUP:_DVENC:Text
	//cVencimento := Substr(cVencimento,9,2)+"/"+Substr(cVencimento,6,2)+"/"+Substr(cVencimento,1,4)
EndIf

nFrete		:= 0//Val(Substr(cBuffer,24,12))/100
nSeguro 	:= Val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)

nIcmsSubs	:= Val(oNFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
//	nAdicional 	:= Val(Substr(cBuffer,1,13))/100

//	nIcmsPer 	:= Val(Substr(cBuffer,1,4))/100
//	nIcmsBase	:= Val(Substr(cBuffer,5,13))/100


// Inclui como alternativa para excluir nf importadas na Filial errada
/*
If cFilorig != "00"
DBSelectArea("SF1")
DbSetorder(1)

//Achei na filial errada
If DbSeek("00"+cNum+cSerie+cForn+cLjFornec+cTipo) .or. DbSeek("00"+substr(cNum,4,6)+Space(3)+cSerie+cForn+cLjFornec+cTipo)
bExcluir := .T.
ELSE
return
Endif
ELSE
return
Endif
*/

// procura pela referência da nota ao pedido de compras
cPedCom := ""
If XmlChildEx ( oNFE:_INFNFE , "_COMPRA" ) != Nil .AND. XmlChildEx ( oNFE:_INFNFE:_COMPRA , "_XPED" ) != Nil //.AND. ValType(oNFE:_INFNFE:_COMPRA:_XPED) != "U"
	cPedCom := padL(allTrim(oNFE:_INFNFE:_COMPRA:_XPED:Text), 6, '0')
Endif


For nCont := 1 to nNumItens
	
	cCodBarra	:= oNFE:_INFNFE:_DET[nCont]:_Prod:_CEAN:Text
	cCodForn	:= AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_CPROD:Text)
	nQuant		:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_QCOM:Text)
	cDescPrd	:= AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_XPROD:Text)
	//			nPrcUnLiq	:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VUNCOM:Text)
	//			nPrcTtLiq	:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VPROD:Text)
	//	nPrcTtBrt	:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VPROD:Text) // Alterei pois quando tem desconto apresentou problema NF Panarello 502867
	nPrcUnBrt	:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VUNCOM:Text)
	nPrcTtBrt	:= nQuant * nPrcUnBrt //Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VPROD:Text)
	cNcm        := AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_NCM:Text)
	cUn			:= AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_uCom:Text)
	If XmlChildEx(oNFE:_InfNfe:_DET[nCont]:_PROD, "_VDESC")!= Nil
		nValDesc	:= Val(oNFE:_INFNFE:_DET[nCont]:_Prod:_VDESC:Text)
	Else
		nValDesc	:= 0
	EndIf
	
	cPedComI := ""
	If XmlChildEx(oNFE:_InfNfe:_DET[nCont]:_PROD, "_XPED") != Nil //ValType(oNFE:_INFNFE:_DET[nCont]:_Prod:_XPED) != "U"
		cPedComI := padL(allTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_XPED:Text), 6, '0')
	Endif
	
	// Busca o Codigo interno do produto.
	dbSelectArea("SA5")
	dbSetOrder(5)
	bOkItem := .F.
	
	If bOkItem == .F. .and. alltrim(str(val(cCodForn))) <> cCodForn .and. val(cCodForn) > 0 // busca sem os zeros no inicio. se existirem zeros.
		// Tem que melhorar.
		While substr(cCodForn,1,1) == "0"
			cCodForn	:= substr(cCodForn,2,len(cCodForn)-1)
		End
		If SA5->(MSSeek(xFilial("SA5")+cCodForn))
			While alltrim(SA5->A5_CODPRF) == cCodForn
				If SA5->(A5_FORNECE+A5_LOJA) == cForn+cLjFornec
					bOkItem := .T.
					cCodigo := SA5->A5_PRODUTO
					cUnidad := SA5->A5_UM
					Exit
				Endif
				DBSkip()
			EndDo
		EndIf
	Endif
	
	If bOkItem == .F.
		If SA5->(MSSeek(xFilial("SA5")+cCodForn))  // Busca pelo codigo do Fornecedor
			While alltrim(SA5->A5_CODPRF) == cCodForn
				If SA5->(A5_FORNECE+A5_LOJA) == cForn+cLjFornec
					bOkItem := .T.
					cCodigo := SA5->A5_PRODUTO
					cUnidad := SA5->A5_UM
					Exit
				EndIf
				DBSkip()
			EndDo
		Endif
	Endif
	
	If bOkItem = .F. .and. !Empty(cCodBarra)
		
		// Busca pelo Codigo de Barras no cadastro do produto
		dbSelectArea("SB1")
		dbSetOrder(5)
		If SB1->(MSSeek(xFilial("SB1")+cCodBarra))
			cCodigo := SB1->B1_COD
			
			// Verifica se existe uma amarracao para o produto encontrado
			dbSelectArea("SA5")
			dbSetOrder(2)
			If ! MSSeek(xFilial("SA5")+cCodigo+cForn+cLjFornec)
				// Inclui a amarracao do produto X Fornecedor
				bOkItem := .T.
				RecLock("SA5",.T.)
				A5_FILIAL     := xFilial("SX5")
				A5_FORNECE    := cForn
				A5_LOJA       := cLjFornec
				A5_NOMEFOR    := SA2->A2_NOME
				A5_PRODUTO    := cCodigo
				A5_NOMPROD    := SB1->B1_DESC
				A5_CODPRF     := cCodForn
				MSUnLock()
				Geralog("F"+cFilOrig+ " " +cNum+"-> Produto sem amarracao: "+cCodForn+" -> "+cCodigo+" -> Incluido",cArqlog)
			Else
				If Empty(SA5->A5_CODPRF) .or. SA5->A5_CODPRF = "0" // Atualiza a amarracao se nao tiver o codigo do fornecedor cadastrado.
					bOkItem := .T.
					RecLock("SA5",.F.)
					A5_CODPRF     := cCodForn
					MSUnLock()
					Geralog("F"+cFilOrig+ " " +cNum+" -> Produto sem amarracao: "+cCodForn+" ->: "+cCodigo+" -> Atualizado",cArqlog)
				Else
					Geralog("F"+cFilOrig+ " " +cNum+ " Produto: "+cCodForn+" ("+oNFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text+") -> "+cCodigo +" ("+Alltrim(SB1->B1_DESC)+")  Erro: Ja Possui amarracao para " + A5_CODPRF, cArqlog)
					Geralog("", cArqlog)
					nError += 1
				Endif
			EndIf
		Endif
		
		// Busca pelo Codigo de Barras no cadastro do produto
		If !bOkItem
			dbSelectArea("SLK")
			DBSetOrder(1)
			If SLK->(MSSeek(xFilial("SLK")+cCodBarra))
				bOkItem := .T.
				cUnidad := "3"
				cCodigo := SLK->LK_CODIGO
			Endif
		Endif
	Endif
	If !bOkItem
		bOkItem := CadProd() // Funcao para incluir o produto caso nao exista.
	Endif
	
	If !bOkItem
		Geralog("F"+cFilOrig+ " " +cNum+" -> Produto sem amarracao: "+cCodForn+" ("+oNFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text +")  Codigo de barras: "+cCodBarra +" -> - ATENCAO -",cArqlog)
		nError += 1 // Jb 19/11/12 - Fazer a funcao para incluir o produto - Deixar para o thiago fazer pq se der merda, e vai dar foi ele que fez.
	Else
		// Posiciona no produto encontrado
		DBSelectArea("SB1")
		DBSetOrder(1)
		MSSeek(xFilial("SB1")+cCodigo)
		
		//Atualiza o NCM do Produto
		If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM)
			RecLock("SB1",.F.)
			SB1->B1_POSIPI := cNCM
			MsUnlock()
		Endif
		
		If SB1->B1_MSBLQL = '1'
			Geralog("F"+cFilOrig+ " " +cNum+" -> Produto Bloqueado: "+cCodigo+" ("+oNFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text +")  Codigo de barras: "+cCodBarra +" -> - ATENCAO -",cArqlog)
			
			//Retirar quando for para a producao
			//RecLock("SB1",.F.)
			//SB1->B1_MSBLQL := "2"
			//MsUnlock()
			
			nError += 1
		Endif
		
		nFator := 1
		Do Case
			Case cUnidad = "2"
				nFator := SB1->B1_CONV
			Case cUnidad = "3" .and. SLK->LK_QUANT > 1
				nFator := SLK->LK_QUANT
		EndCase
		
		//Verifica se possui Node _Med
		bMed := XmlChildEx(oNFE:_INFNFE:_DET[nCont]:_Prod , "_MED" ) != Nil
		
		If bMed
			// Converte o Node Med em array para os casos que existe informacao de mais de um lote do mesmo produto.
			If ValType(oNFE:_InfNfe:_DET[nCont]:_PROD:_MED) = "O"
				XmlNode2Arr(oNFE:_InfNfe:_DET[nCont]:_PROD:_MED, "_MED")
			EndIf
			
			nTotalMed := len(oNFE:_InfNfe:_DET[nCont]:_PROD:_MED)
		Else
			nTotalMed := 1
			nQtdeLote := nQuant
			cLote     := ""
			cValidade := ""
		Endif
		
		// Acumuladores
		nDescTT   := 0
		nValorTT  := 0
		For nContLote := 1 to nTotalMed
			nItem++
			aLinha    := {}
			
			if bMed
				cLote     := oNFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_NLote:Text
				cValidade := oNFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_DVal:Text
				cValidade := Substr(cValidade,9,2)+"/"+Substr(cValidade,6,2)+"/"+Substr(cValidade,1,4)
				nQtdeLote := val(oNFE:_INFNFE:_DET[nCont]:_Prod:_MED[nContLote]:_QLote:Text)
			Endif
			
			If nContLote != nTotalMed
				nDescLote := Round(nValDesc/nQuant*nQtdeLote,2) // Desconto do Lote Atual
				nValLote  := Round(nPrcTtBrt/nQuant*nQtdeLote,2) // Valor do Lote Atual
				
				nDescTT   += nDescLote
				nValorTT  += nValLote
			Else
				nDescLote := nValDesc - nDescTT // Desconto do Lote Atual - Diferenca
				nValLote  := nPrcTtBrt - nValorTT // Valor do Lote Atual - Diferenca
			Endif
			
			// Altera a quantidade em funcao da seg unidade ou da quantidade do cod. de barras.
			If nFator > 1
				nQtdeLote := nQtdeLote*SB1->B1_CONV
			Endif
			
			
			/*
			* AMARRACAO DO PEDIDO DE COMPRAS - INICIO
			*/
			
			nQtdeRest := nQtdeLote
			nDesComT := 0
			nValComT := 0
			
			/*
			* Busca o pedido de compra para a amarração:
			* Ordem de prioridade:
			*   1 - Se exitir, utiliza o numero de pedido informado no item da nota
			*   2 - Se exitir, utiliza o numero de pedido informado no cabeçalho nota
			*   //3 - Utiliza só fornecedor
			*/
			if !empty(cPedComI)
				aPrdCom = U_busPedCom(cFilorig, , , cCodigo, nQtdeLote, @aContr, cPedComI)
			else
				if !empty(cPedCom)
					aPrdCom = U_busPedCom(cFilorig, , , cCodigo, nQtdeLote, @aContr, cPedCom)
				else
					//aPrdCom = U_busPedCom(cFilorig, cForn, cLjFornec, cCodigo, nQtdeLote, @aContr)
				endif
			endif
			
			
			if len(aPrdCom) > 0 // encontrou no pedido de compras
				
				for nY := 1 to len(aPrdCom) // faz a divisão do item da nota por pedido de compras retornado
					
					
					cNumPed := aPrdCom[nY][1]
					cItemPed := aPrdCom[nY][2]
					
					/*
					* INICIO - TRATAMENTO PARA NOTAS COM FORNECEDOR DIFERENTE DO PEDIDO DE COMPRAS
					*/
					
					// Procura o pedido no array de produtos que são de um pedido de fornecedor diferente do
					// fornecedor da nota
					nPosPed := aScan(aFornPed,{|x| x[1] == cNumPed})
					/*
					nPosPed := 0
					cMaiorItem := "0000"
					for nW := 1 to Len(aFornPed)
					if aFornPed[nW][1] == cNumPed
					nPosPed := nW
					
					if cMaiorItem < aFornPed[nW][5]
					cMaiorItem := aFornPed[nW][5]
					endif
					endif
					next
					*/
					
					if nPosPed > 0
						
						cMaiorItem := soma1(cMaiorItem)
						cItemPed := cMaiorItem
						
						// se encontrou, pega o número do pedido que será gerado
						aadd(aFornPed, {cNumPed, cCodigo, aPrdCom[nY][3], cItemPed})
						
						// atribui o número do pedido novo para amarrar na nota
						cNumPed := cNumNewPed
						
					else
						
						// Se não encontrou, verifica se o fornecedor é diferente do fornecedor da nota
						DBSelectArea("SC7")
						DBSetOrder(1)
						DbSeek(cFilOrig + aPrdCom[nY][1])
						
						// Se fornecedor da nota fiscal for diferente do pedido de compras, adiciona o
						// produto e quantidade no array para ser usado na alteração do pedido de compras
						if SC7->C7_FORNECE != cForn
							
							cMaiorItem := soma1(cMaiorItem)
							cItemPed := cMaiorItem
							
							aadd(aFornPed, {cNumPed, cCodigo, aPrdCom[nY][3], cItemPed})
							
							if empty(cNumNewPed)
								// Gera o número do pedido de compras que será gerado com o mesmo fornecedor da nota
								cNumNewPed := Criavar('C7_NUM',.T.)
								ConfirmSX8()
							endif
							
							// atribui o número do pedido novo para amarrar na nota
							cNumPed := cNumNewPed
							
						endif
						
					endif
					
					/*
					FIM - TRATAMENTO PARA NOTAS COM FORNECEDOR DIFERENTE DO PEDIDO DE COMPRAS
					*/
					
					
					aLinha    := {}
					
					nQtdeRest -= aPrdCom[nY][3] // subtrai a quantidade do pc da quantidade restante
					
					if nY > 1
						nItem++
					endif
					
					If nY == len(aPrdCom) .AND. nQtdeRest == 0 // última quantidade do item que falta adicionar ao documento
						nDescCom := nDescLote - nDesComT // Desconto do Item Atual - Diferenca
						nValCom  := nValLote - nValComT // Valor do Item Atual - Diferenca
					Else
						nDescCom := Round(nDescLote/nQtdeLote*aPrdCom[nY][3],2) // Desconto do item atual
						nValCom  := Round(nValLote/nQtdeLote*aPrdCom[nY][3],2) // Valor do item atual
						
						nDesComT += nDescCom
						nValComT += nValCom
					Endif
					
					
					aadd(aLinha,{"D1_ITEM"  ,STRZERO(nItem,TamSX3("D1_ITEM")[1])   ,Nil})
					aadd(aLinha,{"D1_FILIAL",cFilorig           ,Nil})
					aadd(aLinha,{"D1_COD"   ,cCodigo            ,Nil})
					//			aadd(aLinha,{"D1_UM"    ,"UN"               ,Nil})
					
					// amarração com pedido de compra
					// nao retirar desta posicao pois a rotina padrão modifica
					// os dados da nota baseado no pedido de compra
					aadd(aLinha,{"D1_PEDIDO",cNumPed				,Nil})
					aadd(aLinha,{"D1_ITEMPC",cItemPed				,Nil})
					
					
					aadd(aLinha,{"D1_QUANT" , aPrdCom[nY][3]		,Nil})
					//					aadd(aLinha,{"D1_SEGUM" , aPrdCom[nY][3]		,Nil})
					
					//			Passei a calcular o valor unitario, para evitar erro na validacao do total e na conversao de unidade
					//			aadd(aLinha,{"D1_VUNIT" ,nPrcUnBrt          ,Nil})
					aadd(aLinha,{"D1_VUNIT" ,nValCom/aPrdCom[nY][3]	,Nil})
					
					//nTotalBrt += round(nQuant*nPrcUnBrt,2)
					aadd(aLinha,{"D1_TOTAL" ,nValCom				,Nil}) //Valor total proporcional
					
					//						aadd(aLinha,{"D1_TES","081",Nil})
					//					aadd(aLinha,{"D1_OPER"  ,"51"					,Nil})		// RETIREI JB 19/11/2012
					//					aadd(aLinha,{"D1_CONTA" ,"210102"				,Nil})		// RETIREI JB 19/11/2012
					
					aadd(aLinha,{"D1_VALDESC", nDescCom				,Nil}) //Valor Desconto proporcional
					//		aadd(aLinha,{"D1_VALFRE",0,NIL})
					//		aadd(aLinha,{"D1_DESPESA",0,NIL})
					
					//					aadd(aLinha,{"D1_LOTEFOR",cLote					,Nil})
					//						aadd(aLinha,{"D1_LOTECTL",cLote,Nil})
					//						if cValidade != "00/00/0000"
					//							aadd(aLinha,{"D1_DTVALID",ctod(cValidade),NIL})
					//						Endif
					
					// Incluir sempre no ultimo elemento do array de cada item
					aadd(aLinha,{"AUTDELETA","N"					,Nil})
					
					aadd(aItens,aLinha)
					
					
					// Atualiza a tabela de abastecimento urgente para informar que o produto foi comprado
					// Retirei Jb 19/11/12
					//U_InfAtenPrdAU(cFilorig, cCodigo, aPrdCom[nY][3], aPrdCom[nY][1])
				next
			endif
			
			If nQtdeRest > 0 // não encontrou pedidos de compras suficientes
				
				If nQtdeRest != nQtdeLote // se algum pedido de compra foi amarrado, refaz o cálculo
					
					aLinha    := {}
					
					nItem++
					
					nDescLote := nDescLote - nDesComT // Desconto do Item Atual - Diferenca
					nValLote  := nValLote - nValComT // Valor do Item Atual - Diferenca
					
				endif
				
				aadd(aLinha,{"D1_ITEM"  ,STRZERO(nItem,TamSX3("D1_ITEM")[1])   ,Nil})
				aadd(aLinha,{"D1_FILIAL",cFilorig           ,Nil})
				aadd(aLinha,{"D1_COD"   ,cCodigo            ,Nil})
				//			aadd(aLinha,{"D1_UM"    ,"UN"               ,Nil})
				
				
				aadd(aLinha,{"D1_QUANT" , nQtdeRest          ,Nil})
				//				aadd(aLinha,{"D1_SEGUM" , nQtdeRest			,Nil})
				
				//			Passei a calcular o valor unitario, para evitar erro na validacao do total e na conversao de unidade
				//			aadd(aLinha,{"D1_VUNIT" ,nPrcUnBrt          ,Nil})
				aadd(aLinha,{"D1_VUNIT" ,nValLote/nQtdeRest ,Nil})
				
				//nTotalBrt += round(nQuant*nPrcUnBrt,2)
				aadd(aLinha,{"D1_TOTAL" ,nValLote           ,Nil}) //Valor total proporcional
				
				//						aadd(aLinha,{"D1_TES","081",Nil})
				//				aadd(aLinha,{"D1_OPER"  ,"51"               ,Nil}) // RETIREI JB 19/11/2012
				//	aadd(aLinha,{"D1_CONTA" ,"210102"           ,Nil}) // RETIREI JB 19/11/2012
				
				aadd(aLinha,{"D1_VALDESC", nDescLote        ,Nil}) //Valor Desconto proporcional
				//		aadd(aLinha,{"D1_VALFRE",0,NIL})
				//		aadd(aLinha,{"D1_DESPESA",0,NIL})
				
				//				aadd(aLinha,{"D1_LOTEFOR",cLote             ,Nil})  // RETIREI JB 19/11/2012
				//						aadd(aLinha,{"D1_LOTECTL",cLote,Nil})
				//						if cValidade != "00/00/0000"
				//							aadd(aLinha,{"D1_DTVALID",ctod(cValidade),NIL})
				//						Endif
				
				// Incluir sempre no ultimo elemento do array de cada item
				aadd(aLinha,{"AUTDELETA","N"                 ,Nil})
				
				aadd(aItens,aLinha)
				
				// Atualiza a tabela de abastecimento urgente para informar que o produto foi comprado
				// U_InfAtenPrdAU(cFilorig, cCodigo, nQtdeRest) // JB 19/11/12
				
			endif
			/*
			* AMARRACAO DO PEDIDO DE COMPRAS - FIM    (ATENÇÃO - QUANDO DESCOMENTAR, COMENTAR O TRECHO ABAIXO)
			*/
			
			
			// INICIO - fonte antes da amarracao com pedido de compras (COMENTAR DEPOIS)
			/*
			aadd(aLinha,{"D1_ITEM"  ,STRZERO(nItem,TamSX3("D1_ITEM")[1])   ,Nil})
			aadd(aLinha,{"D1_FILIAL",cFilorig           ,Nil})
			aadd(aLinha,{"D1_COD"   ,cCodigo            ,Nil})
			//			aadd(aLinha,{"D1_UM"    ,"UN"               ,Nil})
			
			
			aadd(aLinha,{"D1_QUANT" , nQtdeLote          ,Nil})
			
			//			Passei a calcular o valor unitario, para evitar erro na validacao do total e na conversao de unidade
			//			aadd(aLinha,{"D1_VUNIT" ,nPrcUnBrt          ,Nil})
			aadd(aLinha,{"D1_VUNIT" ,nValLote/nQtdeLote ,Nil})
			
			//nTotalBrt += round(nQuant*nPrcUnBrt,2)
			aadd(aLinha,{"D1_TOTAL" ,nValLote           ,Nil}) //Valor total proporcional
			
			//						aadd(aLinha,{"D1_TES","081",Nil})
			aadd(aLinha,{"D1_OPER"  ,"51"               ,Nil})
			aadd(aLinha,{"D1_CONTA" ,"210102"           ,Nil})
			
			aadd(aLinha,{"D1_VALDESC", nDescLote        ,Nil}) //Valor Desconto proporcional
			//		aadd(aLinha,{"D1_VALFRE",0,NIL})
			//		aadd(aLinha,{"D1_DESPESA",0,NIL})
			
			aadd(aLinha,{"D1_LOTEFOR",cLote             ,Nil})
			//						aadd(aLinha,{"D1_LOTECTL",cLote,Nil})
			//						if cValidade != "00/00/0000"
			//							aadd(aLinha,{"D1_DTVALID",ctod(cValidade),NIL})
			//						Endif
			
			// Incluir sempre no ultimo elemento do array de cada item
			aadd(aLinha,{"AUTDELETA","N"                 ,Nil})
			
			aadd(aItens,aLinha)
			*/
			// FIM - fonte antes da amarracao com pedido de compras (COMENTAR DEPOIS)
			
		Next
	Endif
Next

DBSelectArea("SF1")
DbSetorder(1)

//VOLTAR
If nError = 0
	If MSSeek(cFilorig+cNum+cSerie+cForn+cLjFornec+cTipo/*,.T.*/)// .or. MSSeek(cFilorig+substr(cNum,4,6)+Space(3)+cSerie+cForn+cLjFornec+cTipo/*,.T.*/)
		nError += 1
		cFound += 1
		Geralog("F"+cFilOrig+ " " +cNum+"-> Nao importada. Nota ja foi cadastrada. " + cForn+"/"+cLjFornec,cArqlog)
	Endif
Else
	Geralog("F"+cFilOrig+ " " +cNum+"-> Nao importada. Existem inconsistencias na nota. Fornecedor: "+cForn+"/"+cLjFornec,cArqlog)
Endif

If nError = 0
	
	/*
	* Antes da nota ser criada, cria os pedidos de compras que
	* serão utilizados na amarração da nota
	*/
	if len(aFornPed) > 0
		U_altForPed(cFilOrig, aFornPed, cNumNewPed, cForn, cLjFornec)
	endif
	
	aCabec := {}
	
	aadd(aCabec,{"F1_TIPO"   ,"N"})
	aadd(aCabec,{"F1_FORMUL" ,"N"})
	aadd(aCabec,{"F1_DOC"    ,cNum})
	aadd(aCabec,{"F1_SERIE"  ,cSerie})
	aadd(aCabec,{"F1_EMISSAO",ctod(cDtEmissao)})
	//					aadd(aCabec,{"F1_DESPESA",12}) //despesa - teste
	aadd(aCabec,{"F1_FORNECE",cForn})
	aadd(aCabec,{"F1_LOJA"   ,cLjFornec})
	aadd(aCabec,{"F1_ESPECIE","SPED"})
	aadd(aCabec,{"F1_COND"   ,"#"})
	//					aadd(aCabec,{"F1_DESCONT",nIcmsRepa+nDescItens,NIL})
	aadd(aCabec,{"F1_SEGURO" ,nSeguro,NIL})
	aadd(aCabec,{"F1_FRETE"  ,nFrete,NIL})
	aadd(aCabec,{"F1_VALMERC",nTotalMerc,NIL})
	aadd(aCabec,{"F1_VALBRUT",nTotalMerc+nSeguro+nFrete+nIcmsSubs,NIL})
	//aadd(aCabec,{"F1_VALBRUT",nTotalMerc+nSeguro+nFrete+nAdicional,NIL})
	//aadd(aCabec,{"F1_DESCONT",0,NIL})
	
	
	// Forca a busca pelo codigo interno do produto.
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	Begin Transaction
	
	/* Alteracao da filial corrente. */
	//u_Geralog(U_dumpArray(aItens), "c:\teste\impxmlnfe.txt")
	cFilAtu := cFilAnt
	cFilAnt := cFilOrig
	MATA140(aCabec,aItens,3)
	//	MATA103(aCabec,aItens,3,.t.)
	cFilAnt := cFilAtu
	
	//	MATA140(aCabec,aItens,5)   // Usei quando precisei excluir as nf importadas na filial errada
	
	If !lMsErroAuto
		//Geralog("F"+ cFilOrig+ " " +cNum+"-> Incluido com sucesso !! ",cArqlog) // Deixei de informar para nao gerar log desnecessario
		
		/*
		* Conferência de condições comerciais
		*/
		//  		U_confereNF(cFilOrig, cNum, cSerie, cForn, cLjFornec) // Retirei JB 19/11/12
		
	Else
		mostraerro()
		Geralog("F"+ cFilOrig+ " " +cNum+"-> Erro na Inclusao !! ",cArqlog)
		lMsErroAuto := .F.
		FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".auto")
		//		nError += 1
		//DisarmTransaction() // desfaz as alteracoes ja efetuadas.
	EndIf
	End Transaction
	
	// gravar a chave em F1_CHVNFE se estiver tudo ok na receita
	if MSSeek(cFilorig+cNum+cSerie+cForn+cLjFornec+cTipo/*,.T.*/) .or. MSSeek(cFilorig+substr(cNum,4,6)+Space(3)+cSerie+cForn+cLjFornec+cTipo/*,.T.*/)
		RecLock("SF1",.F.)
		SF1->F1_CHVNFE := cChvNFE
		MsUnlock()
	endif
	
Endif

If nError > 0
	FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".err")
	//envia o email
	// MailNFE() // JB 19/11/12
Else
	FRename(cPath+cFile, cPath+substr(cFile,1,at(".xml",cFile)-1) +".imp")
Endif

nItem := 0
//nErrorItem := 0
aCabec := {}
aItens := {}
aLinha := {}

Return()


User Function RenErrXML
Local aArq, I
Local cPath := "\nfe\err\"

aArq := directory(cPath+"*.err")
For I := 1 To len(aArq)
	cFile := lower(aArq[I][1])
	
	FRename(cPath+cFile, cPath+substr(cFile,1,at(".err",cFile)-1) +".xml")
Next I

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Programa Exemplo de Envio de Email³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MailNFE()

local nEmails

Local _cServer   := SuperGetMv("MV_RELSERV")
Local _cMail     := SuperGetMv("MV_NFEMAIL")
Local _cUser     := SuperGetMv("MV_NFEUSER")
Local _cSenha    := SuperGetMv("MV_NFEPASS")

Local cFrom      := "thiagobueno.net@gmail.com"
Local cTo        := _cMail
Local cAssunto   := "Importacao NFE" + " - " + Time()
Local cBody      := "Erro ao importar NFE"
Local aFiles     := {}

Local lOk        := .T.
//Local msg        :="teste"

aAdd(aFiles, cArqlog)

CONNECT SMTP SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result lOk

If lok
	//     Alert("Conectado com servidor de E-Mail - " + _cServer)
Endif

lEnviado := MailSend(cFrom, {cTo},{},{}, cAssunto, cBody, aFiles,.F.)

If !lEnviado
	cError := MailGetErr()
	connout("Falha na conexao: " + cError + " - " + cArqlog)
	//	Return(.F.)
Endif

DISCONNECT SMTP SERVER result lOk

return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Programa de Exemplo de Recebimento de Email³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function RecebeMail()

Local cFrom      := ""
Local cTo        := ""
Local cBody      := ""
Local cAssunto   := ""
Local aFiles     := {}

Local _cUser     := SuperGetMv("MV_NFEUSER") //"joao@grupoofs.com.br"
Local _cSenha    := SuperGetMv("MV_NFEPASS")
Local _cServer   := SuperGetMv("MV_RELSERV") //"172.20.153.253"
Local lOk        := .T.

Local nEmails

CONNECT pop SERVER _cServer ACCOUNT _cUser PASSWORD _cSenha Result lOk

//lOk := MailPopOn( _cServer, _cUser, _cSenha, 1000)

If !lOk
	cError := MailGetErr()
	MsgAlert("Falha na conexao: " + cError)
	//	Return(.F.)
Endif

lOk := MailAuth(Alltrim(_cUser), Alltrim(_cSenha))
// Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta
// fazer a autenticacao usando apenas o nome de usuario do E-mail
If !lOk
	nA := At("@",_cUser)
	_cUser	:= If(nA>0,Subs(_cUser,1,nA-1),_cUser)
	lOk := MailAuth(Alltrim(_cUser), Alltrim(_cSenha))
Endif

PopMsgCount(@nEmails)

/*//RECEIVE MAIL MESSAGE nMsg FROM cFrom TO     cTo CC cCc BCC cBcc SUBJECT cSubject BODY cBody
MailReceive(nmsg, @cFrom, @cTo, @cCc, @cBcc, @cSubject, @cBody,,, .f. )
return {cFrom, cTo, cCc, cBcc, cSubject, cBody, aFiles}

RECEIVE MAIL MESSAGE <nNumber> ;
[FROM <cFrom>]                                                       ;
[TO     <cTo>]                                                       ;
[CC <cCc>]                                                      ;
[BCC <cBcc>]                                                   ;
[SUBJECT <cSubject>]                                                  ;
[BODY <cBody>]                                                       ;
[ATTACHMENT <aFiles> [SAVE IN <cPath>] ]                    ;
[<lDelete: DELETE>] ;
[IN <lRemote: SERVER> <oRpcSrv> ]                               ;
[RESULT <lResult> ]          */
//aImagens := {}
//aAdd(aImagens, "\CPROVA\" + "front.jpg")
//aAdd(aImagens, "\CPROVA\" + "front.jpg")

Alert(STr(nEmails))

FOR nAtual := 1 TO nEmails
	lRec := MailReceive(nAtual, @cFrom, @cTo,,, @cAssunto ,@cBody, aFiles,, .F. )
	cError := MailGetErr()
	alert(cError)
NEXT

DISCONNECT POP SERVER result lOk

Return()


User Function RecMailObj

Local _cServer := ""
Local _cUser   := ""
Local _cSenha  := ""
Local _cMail   := ""

Local oServer
Local oMessage

Local nNumMsg := 0
Local nTam    := 0
Local nI      := 0

PREPARE ENVIRONMENT EMPRESA "AG" FILIAL "04" MODULO "EST" TABLES "SA2", "SA5", "SD1", "SB1"

_cServer := GetMv("MV_RELSERV")
_cUser   := GetMv("MV_NFEUSER")
_cSenha  := GetMv("MV_NFEPASS")
_cMail   := GetMv("MV_NFEMAIL")

//Crio uma nova conexão, agora de POP
oServer := TMailManager():New()
oMessage := TMailMessage():New()

//Aqui apresenta a mensagem:  * Mail Server not reconigzed
oServer:Init( _cServer, "", _cUser, _cSenha )

/*
If oServer:SetPopTimeOut( 60 ) != 0
Conout( "Falha ao setar o time out" )
Return .F.
EndIf
*/
//	If oServer:PopConnect() != 0
If oServer:IMAPConnect() != 0
	/* E aqui a mensagem:
	Totvs Application Server Error: [thread 1117379504] Segment Fault received
	Totvs Application Server: tManageSignal(threads.hpp) error: 1
	*/
	Conout( "Falha ao conectar: " + MailGetErr() )
	Return .F.
EndIf

/*
If !oServer:ChangeFolder("Pendentes")
Conout( "Falha a acessar pasta Pendentes" )
Return .F.
Endif
*/
//Recebo o número de mensagens do servidor
oServer:GetNumMsgs( @nNumMsg )
nTam := nNumMsg

For nI := 1 To nTam
	//Limpo o objeto da mensagem
	oMessage:Clear()
	//Recebo a mensagem do servidor
	oMessage:Receive( oServer, nI )
	
	//Escrevo no server os dados do e-mail recebido
	Conout( "------------" )
	Conout( oMessage:cFrom )
	Conout( oMessage:cTo )
	Conout( oMessage:cCc )
	Conout( oMessage:cSubject )
	Conout( oMessage:cBody )
	
Next

//Deleto todas as mensagens do servidor
For nI := 1 To nTam
	//oServer:DeleteMsg( nI )
Next

//Desconecto do servidor POP
//	oServer:POPDisconnect()
oServer:IMAPDisconnect()

Return .T.


Static Function GeraLog(cTexto,cArqLog)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para gerar arquivo de Log.³
//³      cPar01: Texto a imprimir   ³
//³      cPar02: Caminho do Arquivo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local nHdl    := 0
Local cArq      := cArqLog

If File(cArq)
	nHdl := FOpen(cArq, 2)
Else
	nHdl := FCreate(cArq)
Endif

If nHdl > 0
	cTexto := cTexto + chr(13) + chr(10)
	FSeek(nHdl,0,2)
	FWrite(nHdl, cTexto)
	FClose(nHdl)
Else
	ConOut("******************************************")
	ConOut("Base - Nao foi possivel criar arquivo " + cArq)
	ConOut("******************************************")
Endif

Return(NIL)


/*
* Utilizado para importar os NCMs dos xmls recebidos pela nfe
* para os produtos que não possuem cadastrado
*
*/
User Function impNCM()

// varre o diretório do fornecedor
// Índices(x) do array resultante da função DIRECTORY, variavel[n][x]
//	x=1 - F_NAME
//	x=2 - F_SIZE
//	x=3 - F_DATE
//	x=4 - F_TIME
//	x=5 - F_ATT
/*
aDirectory := DIRECTORY(allTrim(aFornEle[nI][4]) + allTrim(aFornEle[nI][5]),"D") // D = Pegar também os diretórios

for nX := 1 to len(aDirectory)

//U_EDIGrvLog("Arquivo: " + aDirectory[nX][1], cArqLogRet)
//alert(aFornEle[nI][1] + " - " + aFornEle[nI][3] + " - " + aFornEle[nI][4] + aFornEle[nI][5] + " - " + aDirectory[nX][1])

// chama a função para validação do arquivo do fornecedor
if PediEDIPro(allTrim(aFornEle[nI][4]) + aDirectory[nX][1]) == .T.

if ProcArqRet() == .T.

// move o arquivo para a pasta de arquivos processados
FRENAME(allTrim(aFornEle[nI][4]) + aDirectory[nX][1], allTrim(aFornEle[nI][4]) + "processados/" + aDirectory[nX][1])

U_EDIGrvLog("Arquivo '" + aDirectory[nX][1] + "' processado com sucesso.", cArqLogRet)

else
U_EDIGrvLog("Falha ao processar o arquivo '" + aDirectory[nX][1] + "'.", cArqLogRet)
// renomeia o arquivo
FRENAME(allTrim(aFornEle[nI][4]) + aDirectory[nX][1], allTrim(aFornEle[nI][4]) + substr(aDirectory[nX][1], 1, (len(aDirectory[nX][1]) - 4)) + ".err")
endif

else
U_EDIGrvLog("Falha ao validar o arquivo '" + aDirectory[nX][1] + "'.", cArqLogRet)

// renomeia o arquivo
FRENAME(allTrim(aFornEle[nI][4]) + aDirectory[nX][1], allTrim(aFornEle[nI][4]) + substr(aDirectory[nX][1], 1, (len(aDirectory[nX][1]) - 4)) + ".err")
endif

next
*/

Return


Static Function execINCM(cFile)

Local cError  	:= ""
Local cWarning 	:= ""
Local oXml 		:= NIL

oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )
If ValType(oXml) != "O"
	Alert(cFile+" - "+cError)
	Return()
Endif

// Alterado para tratar quando nao tem o nó _NFEPROC
oNFE := XmlChildEx( oXml , "_NFE" )
If ValType(oNFE) = "U"
	oNFE := XmlChildEx( oXml:_NFEPROC , "_NFE" )
Endif

If ValType(oNFE:_InfNfe:_DET) = "O"
	XmlNode2Arr(oNFE:_InfNfe:_DET, "_DET")
EndIf

Private cNum //Numero da Nota
Private cForn := ""
Private cLjFornec := ""

Private nCont
Private cCodigo

Private cCodBarra
Private cNcm := space(10)

Private cArqLog := "C:\arquivos_nfe\NCM.log"


// inicializa as variaveis de controle
nError := 0

cChvNFE   := oNFE:_INFNFE:_ID:TEXT
cCNPJ_FOR := oNFE:_INFNFE:_EMIT:_CNPJ:TEXT
DBSelectArea("SA2")
DBSetOrder(3)
If MSSeek(xFilial("SA2")+cCNPJ_FOR)
	cForn := A2_COD
	cLjFornec := A2_LOJA
Else
	U_Geralog("Impossivel identificar Fornecedor! " + cCNPJ_FOR, cArqlog)
	nError += 1
Endif

For nCont := 1 to nNumItens
	
	cCodBarra	:= oNFE:_INFNFE:_DET[nCont]:_Prod:_CEAN:Text
	cCodForn	:= AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_CPROD:Text)
	cNcm        := AllTrim(oNFE:_INFNFE:_DET[nCont]:_Prod:_NCM:Text)
	
	// Busca o Codigo interno do produto.
	dbSelectArea("SA5")
	dbSetOrder(5)
	bOkItem := .F.
	
	If bOkItem == .F. .and. alltrim(str(val(cCodForn))) <> cCodForn .and. val(cCodForn) > 0 // busca sem os zeros no inicio. se existirem zeros.
		// Tem que melhorar.
		While substr(cCodForn,1,1) == "0"
			cCodForn	:= substr(cCodForn,2,len(cCodForn)-1)
		End
		If SA5->(MSSeek(xFilial("SA5")+cCodForn))
			While alltrim(SA5->A5_CODPRF) == cCodForn
				If SA5->(A5_FORNECE+A5_LOJA) == cForn+cLjFornec
					bOkItem := .T.
					cCodigo := SA5->A5_PRODUTO
					Exit
				Endif
				DBSkip()
			EndDo
		EndIf
	Endif
	
	If bOkItem == .F.
		If SA5->(MSSeek(xFilial("SA5")+cCodForn))  // Busca pelo codigo do Fornecedor
			While alltrim(SA5->A5_CODPRF) = cCodForn
				If SA5->(A5_FORNECE+A5_LOJA) == cForn+cLjFornec
					bOkItem := .T.
					cCodigo := SA5->A5_PRODUTO
					cUnidad := SA5->A5_UM
					Exit
				EndIf
				DBSkip()
			EndDo
		Endif
	Endif
	
	If bOkItem = .F. .and. !Empty(cCodBarra)
		
		// Busca pelo Codigo de Barras no cadastro do produto
		dbSelectArea("SB1")
		dbSetOrder(5)
		If SB1->(MSSeek(xFilial("SB1")+cCodBarra))
			cCodigo := SB1->B1_COD
		Endif
		
		// Busca pelo Codigo de Barras no cadastro do produto
		If !bOkItem
			dbSelectArea("SLK")
			DBSetOrder(1)
			If SLK->(MSSeek(xFilial("SLK")+cCodBarra))
				bOkItem := .T.
				cCodigo := SLK->LK_CODIGO
			Endif
		Endif
	Endif
	
	If !bOkItem
		U_Geralog("F"+cFilOrig+ " " +cNum+" -> Produto sem amarracao: "+cCodForn+" ("+oNFE:_INFNFE:_DET[nCont]:_Prod:_xProd:Text +")  Codigo de barras: "+cCodBarra +" -> - ATENCAO -",cArqlog)
		nError += 1
	Else
		// Posiciona no produto encontrado
		DBSelectArea("SB1")
		DBSetOrder(1)
		MSSeek(xFilial("SB1")+cCodigo)
		
		//Atualiza o NCM do Produto
		If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM)
			RecLock("SB1",.F.)
			SB1->B1_POSIPI := cNCM
			MsUnlock()
			
			U_Geralog(cCodigo + " - " + SB1->B1_DESC +" -> NCM Importado com sucesso: " + cNCM,cArqlog)
		Endif
		
	Endif
Next

Return

// FUNCAO PARA REALIZAR A INCLUSAO DOS PRODUTOS CASO NAO EXISTA CADASTRO
// DADOS FIXOS SEGUNDO INFORMACOES DE THIAGO BUENO - 19/11/2012
Static function CadProd
cCodigo := "P"+cCodForn
DbselectArea("SB1")
DBSetOrder(1)
If !MSSeek(xFilial("SB1")+cCodigo)
	RecLock("SB1",.T.)
	SB1->B1_FILIAL 	:= xFilial("SB1")
	SB1->B1_COD 	:= cCodigo
	
	SB1->B1_DESC 	:= cDescPrd
	SB1->B1_UM 		:= cUn
	SB1->B1_SEGUM	:= cUn
	
	SB1->B1_TIPO	:= "B1"
	SB1->B1_CONV 	:= 1
	SB1->B1_PROC 	:= cForn
	SB1->B1_LOJPROC := cLjFornec
	SB1->B1_PRV1    := nPrcUnBrt
	SB1->B1_XXCUBAG := "N"
	SB1->B1_QE 		:= 1
	SB1->B1_TE		:= "101"
	SB1->B1_TS		:= "501"
	SB1->B1_LOCPAD	:= "01"
	SB1->B1_FULLSVC := "N"
	SB1->B1_GRUPO	:= "UTEN"
	SB1->B1_TIPCONV	:= "M"
	SB1->B1_PESO	:= 1
	SB1->B1_PBRUTO 	:= 1
	SB1->B1_FRISECO := "S"
	SB1->B1_CODTRI	:= "00"
	SB1->B1_CLPLA	:= "B"
	SB1->B1_CDSp	:= "N"
	SB1->B1_ATIVO	:= "S"
	
	MsUnlock()
Endif

Return .T.
