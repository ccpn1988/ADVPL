

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  �cleuto Lima         � Data �  22/10/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Complementa a Grava��o dos T�tulos Financeiros a Pagar      ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function MT100GE2()

Local aTitAtual := PARAMIXB[1]
Local nOpc      := PARAMIXB[2]
Local aHeadSE2  := PARAMIXB[3]
Local aParcelas := ParamIXB[5]
Local nX        := ParamIXB[4]

If nOpc == 1 //.. inclusao
    If !aTitAtual[GdPosDeleted( aHeadSE2 )]
        If GdFieldPos( "E2_XFORPGT" , aHeadSE2 ) > 0
            SE2->E2_XFORPGT := aTitAtual[GdFieldPos( "E2_XFORPGT" , aHeadSE2 )]
            SE2->E2_XDFORPG := AllTrim(Posicione("SX5",1,xFilial("SX5")+"58"+SE2->E2_XFORPGT,"X5_DESCRI"))
        EndIf
        If GdFieldPos( "E2_HIST" , aHeadSE2 ) > 0
            SE2->E2_HIST := aTitAtual[GdFieldPos( "E2_HIST" , aHeadSE2 )]
        EndIf    
    EndIF 
Endif

Return nil