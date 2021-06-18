#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} FC010LIST
//Ponto de Entrada na tela Posicao de cliente
@author Telso
@since 22/09/2016
@version undefined

@type function
/*/
user function FC010LIST()
Local aPara:= aClone(PARAMIXB)
Local aColsAux := Array(16,6)
Local nValor
Local _nValor1
local _nValor2
Local _nValor3
Local dDtInclus
Local cPitcSld	 := AllTrim(GetSX3Cache("A1_SALPED", "X3_PICTURE"))
Local nValAtraso := 0
Local nI

aEval(aColsAux, {|x| AFill( x, " " ) })

//Ajusta títulos
	aColsAux[1][1]  := "Dados GEN:"
	aColsAux[2][1]  := "Limite de crédito (A)"
	aColsAux[3][1]  := "Soma dos títulos abertos (B)"
	aColsAux[4][1]  := "Soma dos pedidos digitados"
	aColsAux[5][1]  := "Soma dos pedidos com bloqueio de credito"
	aColsAux[6][1]  := "Soma dos pedidos liberados (C)"
	aColsAux[7][1]  := "Soma do limite de crédito (A-B-C)"
	aColsAux[9][1]  := "Maior nota fiscal emitida"
	aColsAux[9][5]  := "Maior título a receber emitido"
	aColsAux[10][1] := "Maior saldo devedor registrado"
	aColsAux[10][5] := "Somatorio pagamentos feitos atrasados"
	aColsAux[11][1] := "Numero notas emitidas"
	aColsAux[11][5] := "Numero títulos pagos"
	aColsAux[12][1] := "Valor Atraso atual (somatório títulos em aberto)"
	aColsAux[12][5] := "Media Atraso"
	aColsAux[13][1] := "Numero títulos protestados"
	aColsAux[13][5] := "Ult.Protesto"
	aColsAux[14][1] := "Numero cheques devolvidos"
	aColsAux[14][5] := "Último cheque devolvido"
	aColsAux[15][1] := "Primeira compra"
	aColsAux[15][5] := "Última compra"
	
	//Ajuste 
	_nValor1:= SA1->A1_LC
	aColsAux[2,2]:=  TransForm(_nValor1,cPitcSld)	
	
	_nValor2:= SldCliente(SA1->A1_COD+SA1->A1_LOJA)
	aColsAux[3,2] := TransForm(_nValor2,cPitcSld)
	
	aColsAux[4,2] := TransForm(SA1->A1_SALPED,cPitcSld)
	aColsAux[5,2] := TransForm(SA1->A1_SALPEDB,cPitcSld)
		
	_nValor3:= SA1->A1_SALPEDL
	aColsAux[6,2] := TransForm(_nValor3,cPitcSld)	

	aColsAux[7][2] := TransForm((_nValor1-_nValor2-_nValor3),cPitcSld)
	
	aColsAux[9][2] := TransForm(SA1->A1_MCOMPRA,cPitcSld)
	aColsAux[9][6] := TransForm(SA1->A1_MAIDUPL,cPitcSld)
	
	aColsAux[10][2] := TransForm(SA1->A1_MSALDO,cPitcSld)
	aColsAux[10][6] := TransForm(A1_PAGATR,cPitcSld)
	
	aColsAux[11][2] := cValToChar(SA1->A1_NROCOM)	
	aColsAux[11][6] := cValToChar(A1_NROPAG)		  			  	
	
	//³ Caso o t¡tulo seja de qualquer natureza credora (-) o saldo  
	//³ deve ser abatido. Os t¡tulos tipo RA (Receb.Antecipado),     
	//³ NCC (Nota de Cr‚dito) e PR (Provis¢rio) n„o precisam de      
	//³ tratamento especial.                             
	//FUNCAO FtSomaAtr no MATA450A
	nValAtraso := FtSomaAtr(xFilial("SE1"))
	
	aColsAux[12][2] := Transform(nValAtraso, cPitcSld) 
	aColsAux[12][6] := Transform(SA1->A1_METR, cPitcSld)
	
	aColsAux[13][2] := cValToChar(SA1->A1_TITPROT)
	aColsAux[13][6] := DTOC(A1_DTULTIT)
	
	aColsAux[14][2] := cValToChar(SA1->A1_CHQDEVO)	
	aColsAux[14][6] := DTOC(A1_DTULCHQ)
		
	aColsAux[15][2] := DTOC(SA1->A1_PRICOM) 
	aColsAux[15][6] := DTOC(SA1->A1_ULTCOM) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciono linha em branco para separar novas informacoes                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AddLinBco(@aColsAux)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informacao de data de inclusao do cliente                                    ³
	//³ Verifica se o campo USERLGI esta preenchido. Se nao, considero a data da     ³
	//³ primeira compra do cliente.                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(SA1->A1_USERLGI)
		dDtInclus := CToD(FwLeUserlg("A1_USERLGI", 2))		//1-Cod. Usuario/2-Data inclusao
	ElseIf !Empty(SA1->A1_PRICOM)
		dDtInclus := SA1->A1_PRICOM
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posicao dos vetores do array aBrowse:                                        ³
	//³ [1] - 1a. informacao a ser exibida                                           ³
	//³ [2] - Valor da moeda 1 da 1a. informacao                                     ³
	//³ [3] - Valor da moeda 2 da 1a. informacao                                     ³
	//³ [4] - 2a. informacao a ser exibida                                           ³
	//³ [5] - Valor da moeda 1 da 2a. informacao                                     ³
	//³ [6] - Valor da moeda 2 da 2a. informacao                                     ³
	//³ [7] - Coluna sobressalente                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aTail(aColsAux)[1] := "Data de cadastro cliente"
	aTail(aColsAux)[2] := DToC(dDtInclus)

	aTail(aColsAux)[5] := "Saldo em Consignação"
	nValor := StaticCall(M450BRW,GetSldConsig,SA1->A1_COD, SA1->A1_LOJA)
	aTail(aColsAux)[6] := Transform(nValor, cPitcSld)
	
	AddLinBco(@aColsAux)
	
	aTail(aColsAux)[1] := RetTitle("A1_XCANALV")
	aTail(aColsAux)[2] := Alltrim(SA1->A1_XCANALV)+"-"+Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5") + "Z2" + SA1->A1_XCANALV, 1))
	
	aTail(aColsAux)[5] := RetTitle("A1_XTIPCLI")
	aTail(aColsAux)[6] := Alltrim(SA1->A1_XTIPCLI)+"-"+Alltrim(GetAdvFval("SX5","X5_DESCRI",xFilial("SX5") + "TP" + SA1->A1_XTIPCLI, 1))
	
	AddLinBco(@aColsAux)
	
	aTail(aColsAux)[1] := RetTitle("A1_VEND")
	aTail(aColsAux)[2] := Alltrim(SA1->A1_VEND)+"-"+Alltrim(GetAdvFval("SA3","A3_NOME",xFilial("SA3") + SA1->A1_VEND, 1))
	
	aTail(aColsAux)[5] := RetTitle("A1_XTPDES")
	aTail(aColsAux)[6] := Alltrim(SA1->A1_XTPDES)
		
	AddLinBco(@aColsAux)
	
	aTail(aColsAux)[1] := RetTitle("A1_XCLIPRE")
	aTail(aColsAux)[2] := If(Alltrim(SA1->A1_XCLIPRE) == "1","Sim","Não")
	
	aTail(aColsAux)[5] := RetTitle("A1_XAUTOR")
	aTail(aColsAux)[6] := If(Alltrim(SA1->A1_XAUTOR) == "1","Sim","Não")
	
nMax2 := 0	
nMax6 := 0
aEval(aColsAux,{|x| nMax2 := If(Len(x[2]) > nMax2,Len(x[2]),nMax2), nMax6 := If(Len(x[6]) > nMax6,Len(x[6]),nMax6) })	

aEval(aColsAux,{|x| x[2] := PADL(Alltrim(x[2]),nMax2," "), x[6] := PADL(Alltrim(x[6]),nMax6," ") })

AddLinBco(@aPara) // Pula linha

aPara := {}

For nI := 1 To Len(aColsAux)	
	aAdd(aPara,aclone(aColsAux[nI]))
Next

return(aPara)

/*/{Protheus.doc} AddLinBco
//Gera linha em branco
@author Telso
@since 22/09/2016
@version undefined
@param aBrowse, array, descricao
@type function
/*/
Static Function AddLinBco(aBrowse)

Local nPosBlank	:= 0				//Posicao de linha em branco

nPosBlank := aScan(aBrowse, {|x| Empty(x[1]) })

If nPosBlank > 0
	aAdd(aBrowse, aClone(aBrowse[nPosBlank]))
Else
	aAdd(aBrowse, Array(Len(aBrowse[1])))
	aEval(aTail(aBrowse), {|x| x := ""})
EndIf

Return Nil