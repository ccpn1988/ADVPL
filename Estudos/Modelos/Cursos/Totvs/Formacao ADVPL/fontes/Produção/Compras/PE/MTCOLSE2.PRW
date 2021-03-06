

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
Local lContinua := !Empty(cCondicao) .AND. Upper(AllTrim(readvar())) $ "CCONDICAO|CNATUREZA" .AND. upper(alltrim(GetEnvServer())) <> "SCHEDULE" .AND. nOpc == 1

IF lContinua
    oDlgAtu     := GetWndDefault()
    cFormPgt    := AllTrim(Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_XFORPGT"))
    lContinua   := !Empty(cFormPgt)
EndIf

while lContinua
    nQtdLoop++
    nLastPos := aScan(oDlgAtu:aControls, {|x|  AllTrim(x:ClassName()) == "MSBRGETDBASE"  },nLastPos+1 )
    IF nLastPos == 0
        lContinua := .F.
        Exit
    else 
        If AttIsMemberOf(oDlgAtu:aControls[nLastPos],"aAlter",.F.)
            nPosForm := aScan(oDlgAtu:aControls[nLastPos]:aAlter, {|x|  AllTrim(x) == "E2_XFORPGT"  } )// busco o objeto pois os genios da totvs disponibilizam o acols mas n�o o ahedar
            IF nPosForm > 0
                lContinua := .F.
                Exit
            EndIf
        EndIf 
    EndIf
    IF nQtdLoop >= 20 // apenas como seguran�a para n�o entrar em loo infinito
        lContinua := .F.
        Exit
    endIf
end

IF nPosForm > 0
    For nAuxSE2 := 1 To Len(aColsE2)
        If Empty(aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",oDlgAtu:aControls[nLastPos]:oMother:aHeader)])
            aColsE2[nAuxSE2][GdFieldPos("E2_XFORPGT",oDlgAtu:aControls[nLastPos]:oMother:aHeader)] := cFormPgt        
        EndIf 
    Next nAuxSE2
EndIf

Return aColsE2