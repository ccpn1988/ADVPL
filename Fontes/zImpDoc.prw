/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2020/09/04/como-importar-arquivos-para-o-banco-de-conhecimento/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "TOTVS.ch"
#Include "FileIO.ch"
 
/*/{Protheus.doc} zImpDoc
Fun��o para importar objetos para o Banco de Conhecimento
@author Atilio
@since 02/08/2020
@version 1.0
/*/
 
User Function zImpDoc()
    //Se a pergunta for confirmada
    If MsgYesNo("Esse procedimento realizara a importacao dos arquivos para o Banco de Conhecimento. Deseja continuar?", "Atencao")
        Processa({|| fRunProc() })
    EndIf
Return
 
Static Function fRunProc()
    Local cDirDoc := Alltrim(GetMv("MV_DIRDOC"))
    Local cDirOrig := SuperGetMv("MV_X_DIROR", .F., "\\192.168.10.112\totvs\banco de Conhecimento\Importar\")
    Local aDir 
    Local cProxObj
    Local cCodLoja
    Local cTipo                    
    Local cPathBco
    Local nAtual
    Local cArqAtu
    Local cAliasAtu := ""
     
    //Se o ultimo caracter nao for uma \, acrescenta ela, e depois configura o diretorio com a subpasta co01\shared
    If SubStr(cDirDoc, Len(cDirDoc), 1) != '\'
        cDirDoc := cDirDoc + "\"
    EndIf
    cPathBco := cDirDoc + 'co01\shared\'
 
    //Busca todos os arquivos da origem
    aDir := directory(cDirOrig + "*.*")
 
    //Define o tamanho da regua do Processa
    ProcRegua(Len(aDir))
     
    //Percorre todos os itens
    For nAtual := 1 To Len(aDir)
        IncProc("Importando objeto (" + cValToChar(nAtual) + " de " + cValToChar(Len(aDir)) + ")...")
        cArqAtu := aDir[nAtual, 1]
         
        //Faz a c�pia da origem, para a pasta do banco de conhecimento
        Copy File &(cDirOrig + cArqAtu) To &(cPathBco + cArqAtu)
         
        //Se n�o conseguiu copiar, mostra um alerta, e volta o la�o
        If ! File(cPathBco + cArqAtu)
            MsgAlert("Erro ao importar: " + cPathBco + cArqAtu, "Atencao!")
            Loop
        EndIf
         
        //Pegando o c�digo e loja, a partir da posi��o 2, com 8 caracteres (XXXXXXYY)
        cCodLoja := SubStr(cArqAtu, 2, 8)
        cAliasAtu := ""
         
        //Se come�ar com a letra C, � cliente
        If Upper(SubStr(cArqAtu, 1, 1)) == "C"
            DbSelectArea("SA1")
            SA1->(DbSetOrder(1))
            SA1->(DbGoTop())
            cTipo     := "Cliente"
            cAliasAtu := "SA1"
             
        //Sen�o, se come�ar com a letra F, � fornecedor
        ElseIf Upper(SubStr(cArqAtu, 1, 1)) == "F"
            DbSelectArea("SA2")
            SA2->(DbSetOrder(1))
            SA2->(DbGoTop())
            cTipo     := "Fornecedor"
            cAliasAtu := "SA2"
             
        //Sen�o, pula o objeto
        Else
            Loop
        EndIf
         
        //Se conseguir posicionar conforme a �ltima tabela aberta com DbSelectArea
        If (cAliasAtu)->(DbSeek(FWxFilial(cAliasAtu) + cCodLoja))
             
            //Pega o pr�ximo registro da ACB
            DbSelectArea("ACB")
            ACB->(DbSetOrder(1))
            ACB->(DbGoBottom())
            cProxObj := StrZero((Val(ACB->ACB_CODOBJ) + 1), 10)
            ACB->(DbSetOrder(2))
             
            //Se n�o tiver o arquivo na ACB, ir� incluir
            If ! ACB->(DbSeek(FWxFilial('ACB') + cArqAtu))
                Reclock("ACB", .T.)
                    ACB->ACB_FILIAL := FWxFilial('ACB')
                    ACB->ACB_CODOBJ := cProxObj
                    ACB->ACB_OBJETO := cArqAtu
                    ACB->ACB_DESCRI := cArqAtu
                ACB->(MsUnlock())
                 
                //Se n�o existir na tabela de vinculos, ir� criar
                DbSelectArea("AC9")
                AC9->(DbSetOrder(1))
                If ! AC9->(DbSeek(FWxFilial('AC9') + cProxObj + cCodLoja))
                    Reclock("AC9", .T.)
                        AC9->AC9_FILIAL := FWxFilial('AC9')
                        AC9->AC9_ENTIDA := cAliasAtu
                        AC9->AC9_CODENT := cCodLoja
                        AC9->AC9_CODOBJ := cProxObj
                    AC9->(MsUnlock())
                EndIf
            EndIf
             
            //Exclui o arquivo da origem
            FErase(cDirOrig + cArqAtu)
         
        //Se n�o conseguir dar um Seek na tabela, mostra mensagem de falha
        Else
            MsgStop("Codigo de " + cTipo + " invalido no arquivo: " + cArqAtu, "Aten��o")
        EndIf
    Next
Return