

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTCOLSE2  �Autor  �cleuto Lima         � Data �  22/10/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validar a digita��o da natureza na NF de Entrada Eventos    ���
���          �O ponto de entrada � chamado ao digitar a natureza          ���
���          �no documento de entrada.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTCOLSE2()

Local aColsE2   := PARAMIXB[1] //aCols de duplicatas
Local nOpc      := PARAMIXB[2] //0-Tela de visualiza��o / 1-Inclus�o ou Classifica��o
Local oDlgAtu   := nil
Local nLastPos  := 1
Local nPosForm  := 0
Local nQtdLoop  := 0
Local cFormPgt  := ""
Local lContinua := .T.
Local lOriCtr   := Type("l103Auto") == "L" .AND. !l103Auto .AND. lNfMedic .AND. upper(alltrim(GetEnvServer())) <> "SCHEDULE" .AND. INCLUI .AND. !ALTERA
Local lAtuConPg := (!Empty(cCondicao) .AND. Upper(AllTrim(readvar())) $ "CCONDICAO|CNATUREZA" .AND. upper(alltrim(GetEnvServer())) <> "SCHEDULE" .AND. nOpc == 1)                    
Local aHrdSE2   := {}
Local nAuxSE2   := 0

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
                nPosForm := aScan(oDlgAtu:aControls[nLastPos]:aAlter, {|x|  AllTrim(x) == "E2_XFORPGT" .OR. AllTrim(x) == "E2_HIST"  } )// busco o objeto pois os genios da totvs disponibilizam o acols mas n�o o ahedar
                IF nPosForm > 0
                    aHrdSE2     := oDlgAtu:aControls[nLastPos]:oMother:aHeader
                    lContinua   := .F.
                    Exit
                EndIf
            EndIf 
        EndIf
        IF nQtdLoop >= 20 // apenas como seguran�a para n�o entrar em loo infinito
            lContinua := .F.
            Exit
        endIf
    EndDo
EndIf

IF nPosForm > 0
    cFormPgt    := AllTrim(Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_XFORPGT"))
    lAtuConPg   := !Empty(cFormPgt)

    IF lAtuConPg .OR. lOriCtr
        For nAuxSE2 := 1 To Len(aColsE2)

            If lAtuConPg .AND. GdFieldPos("E2_XFORPGT",aHrdSE2) > 0 .AND. Empty(aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",aHrdSE2)])
                aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",aHrdSE2)] := cFormPgt        
            EndIf
            IF lOriCtr .AND. GdFieldPos("E2_HIST",aHrdSE2) > 0 .AND. Empty(aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)])
                aColsE2[nAuxSE2][GdFieldPos("E2_HIST",aHrdSE2)] := xGetHistCtr()
            ENDIF
        Next nAuxSE2
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