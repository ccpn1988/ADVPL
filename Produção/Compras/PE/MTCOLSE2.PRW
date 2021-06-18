

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTCOLSE2  บAutor  ณcleuto Lima         บ Data ณ  22/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidar a digita็ใo da natureza na NF de Entrada Eventos    บฑฑ
ฑฑบ          ณO ponto de entrada ้ chamado ao digitar a natureza          บฑฑ
ฑฑบ          ณno documento de entrada.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gen                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTCOLSE2()

Local aColsE2   := PARAMIXB[1] //aCols de duplicatas
Local nOpc      := PARAMIXB[2] //0-Tela de visualiza็ใo / 1-Inclusใo ou Classifica็ใo
Local oDlgAtu   := nil
Local nLastPos  := 1
Local nPosForm  := 0
Local nQtdLoop  := 0
Local cFormPgt  := ""
Local lContinua := .T.
Local lOriCtr   := Type("l103Auto") == "L" .AND. !l103Auto .AND. lNfMedic .AND. upper(alltrim(GetEnvServer())) <> "SCHEDULE" .AND. INCLUI .AND. !ALTERA
Local lAtuConPg := (!Empty(cCondicao) .AND. Upper(AllTrim(readvar())) $ "CCONDICAO|CNATUREZA" .AND. upper(alltrim(GetEnvServer())) <> "SCHEDULE" .AND. nOpc == 1)                    
Local lAtuForma := .F.
Local aHrdSE2   := {}
Local nAuxSE2   := 0
Local nPosTot   := 0
Local nVlMaior  := 0
Local nItVl     := 0
Local cPrdHist  := SuperGetMV("GEN_COM028",.F.,"00002003#00002002#") //Produtos que deverใo ser considerados na gera็ใo do texto para o hist๓rio de tํtulo.
Local nPosPrd   := 0
Local nQtdIt    := 0

IF lAtuConPg .OR. lOriCtr
    while lContinua
        oDlgAtu     := GetWndDefault()
        nQtdLoop++
        nLastPos := aScan(oDlgAtu:aControls, {|x|  AllTrim(x:ClassName()) == "MSBRGETDBASE"  },nLastPos+1 )
        IF nLastPos == 0
            lContinua := .F.
            Exit
        else 
            If AttIsMemberOf(oDlgAtu:aControls[nLastPos],"aAlter",.F.)
                nPosForm := aScan(oDlgAtu:aControls[nLastPos]:aAlter, {|x|  AllTrim(x) == "E2_XFORPGT" .OR. AllTrim(x) == "E2_HIST"  } )// busco o objeto pois os genios da totvs disponibilizam o acols mas nใo o ahedar
                IF nPosForm > 0
                    aHrdSE2     := oDlgAtu:aControls[nLastPos]:oMother:aHeader
                    lContinua   := .F.
                    Exit
                EndIf
            EndIf 
        EndIf
        IF nQtdLoop >= 20 // apenas como seguran็a para nใo entrar em loo infinito
            lContinua := .F.
            Exit
        endIf
    EndDo
EndIf

IF nPosForm > 0
    cFormPgt    := AllTrim(Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_XFORPGT"))
    lAtuForma   := !Empty(cFormPgt)
    IF lAtuForma .OR. lOriCtr
        For nAuxSE2 := 1 To Len(aColsE2)
            If lAtuForma .AND. GdFieldPos("E2_XFORPGT",aHrdSE2) > 0 .AND. Empty(aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",aHrdSE2)])
                aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",aHrdSE2)] := cFormPgt        
            EndIf
            IF lOriCtr .AND. GdFieldPos("E2_HIST",aHrdSE2) > 0 .AND. Empty(aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)])
                aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)] := xGetHistCtr()
            ENDIF
        Next nAuxSE2
    EndIf
EndIf

If lAtuConPg
    nPosTot := aScan(aHeader,{|x|Alltrim(x[2])=="D1_TOTAL"})
    nPosPrd := aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})

    If !Empty(aCols)
        For nI := 1 to Len(aCols) //Pego o n๚mero do item com maior valor no aCols da SD1
            If AllTrim(aCols[nI][nPosPrd]) $ AllTrim(cPrdHist) 
                If aCols[nI][nPosTot] > nVlMaior
                    nVlMaior := aCols[nI][nPosTot]
                    nItVl := nI
                EndIf
                nQtdIt++
            EndIf
        Next

        If nItVl > 0
            For nAuxSE2 := 1 To Len(aColsE2)
                IF GdFieldPos("E2_HIST",aHrdSE2) > 0 .AND. Empty(aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)])
                    aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)] := xGetHistEd(nItVl,nQtdIt)
                ENDIF
            Next nAuxSE2
        EndIf
    EndIf
EndIf

Return aColsE2

Static Function xGetHistCtr()

Local cRet      := Criavar("E2_HIST",.F.)
Local nPdCompra := GdFieldPos("D1_PEDIDO",aHeadd1)
Local cPedido   := ""

IF nPdCompra > 0
    cPedido := GdFieldGet("D1_PEDIDO",1,.F.,aHeadd1,aColSD1)
    IF !Empty(cPedido)        
        SC7->(DbSetOrder(1))
        IF SC7->(DBseek( xFilial("SC7")+cPedido ))
            IF !Empty(SC7->C7_CONTRA)
                CN9->(DbSetOrder(1))
                IF CN9->(DbSeek( xFilial("CN9")+SC7->C7_CONTRA ))
                    cRet := ALLTRIM(CN9->CN9_XHISTI)
                ENDIF
            ENDIF
        ENDIF
    ENDIF
ENDIF

Return cRet

Static Function xGetHistEd(nItem,nQtdIt)
Local cRet := Criavar("E2_HIST",.F.)
Local nPosPrd   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local nPosIte   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_ITEMCTA"})
Local nPosCta   := aScan(aHeader,{|x|Alltrim(x[2])=="D1_CONTA"})

If !Empty(aCols[nItem][nPosIte])
    cRet := AllTrim(Posicione("CTD",1,xFilial("CTD")+aCols[nItem][nPosIte],"CTD_DESC01"))+xGetOutros(nQtdIt,nItem,nPosIte)//IF(nQtdIt>1," | OUTROS","")
ElseIf !Empty(aCols[nItem][nPosCta])
    cRet := AllTrim(Posicione("CT1",1,xFilial("CT1")+aCols[nItem][nPosCta],"CT1_DESC01"))+xGetOutros(nQtdIt,nItem,nPosCta)//IF(nQtdIt>1," | OUTROS","")
Else
    cRet := AllTrim(Posicione("SB1",1,xFilial("SB1")+aCols[nItem][nPosPrd],"B1_DESC"))+xGetOutros(nQtdIt,nItem,nPosPrd)//IF(nQtdIt>1," | OUTROS","")
EndIf

Return cRet

Static Function xGetOutros(nQtdIt,nItem,nPosGen)
Local cRet := ""
Local cAux := ""

cAux := AllTrim(aCols[nItem][nPosGen])
If nQtdIt > 1
    For nX := 1 to Len(aCols)
        If AllTrim(aCols[nX][nPosGen]) <> cAux
            cRet := " | OUTROS"
        EndIf
    Next
EndIf

Return cRet
