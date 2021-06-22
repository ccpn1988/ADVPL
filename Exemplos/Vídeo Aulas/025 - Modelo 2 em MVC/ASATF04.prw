/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/01/30/vd-advpl-025/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
  
//Vari�veis Est�ticas
Static cTitulo := "Abastecimentos"
  
/*/{Protheus.doc} ASATF04
Fun��o para cadastros de Abastecimentos dos veículos
@author Atilio
@since 13/09/2020
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_ASATF04()
    @obs Os campos chave usado entre cabe�alho e grid s�o: ZAF_IDSEQ (C�digo Sequencial), ZAF_NOTFIS (Nota Fiscal), ZAF_VALOR (Valor)
/*/
 
User Function ASATF04()
    Local aArea   := GetArea()
    Local oBrowse
      
    //Cria um browse para a ZAF
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZAF")
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
      
    RestArea(aArea)
Return Nil
 
Static Function MenuDef()
    Local aRot := {}
      
    //Adicionando op�ões
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ASATF04' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ASATF04' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ASATF04' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ASATF04' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
Return aRot
 
Static Function ModelDef()
    //Na montagem da estrutura do Modelo de dados, o cabe�alho filtrar� e exibir� somente 3 campos, j� a grid ir� carregar a estrutura inteira conforme fun��o fModStruct
    Local oModel      := NIL
    Local oStruCab     := FWFormStruct(1, 'ZAF', {|cCampo| AllTRim(cCampo) $ "ZAF_IDSEQ;ZAF_NOTFIS;ZAF_VALOR;"})
    Local oStruGrid := fModStruct()
 
    //Monta o modelo de dados, e na P�s Valida��o, informa a fun��o fValidGrid
    oModel := MPFormModel():New('ASATF04M', /*bPreValidacao*/, {|oModel| fValidGrid(oModel)}, /*bCommit*/, /*bCancel*/ )
 
    //Agora, define no modelo de dados, que ter� um Cabe�alho e uma Grid apontando para estruturas acima
    oModel:AddFields('MdFieldZAF', NIL, oStruCab)
    oModel:AddGrid('MdGridZAF', 'MdFieldZAF', oStruGrid, , )
 
    //Monta o relacionamento entre Grid e Cabe�alho, as expressões da Esquerda representam o campo da Grid e da direita do Cabe�alho
    oModel:SetRelation('MdGridZAF', {;
            {'ZAF_FILIAL', 'xFilial("ZAF")'},;
            {"ZAF_IDSEQ",  "ZAF_IDSEQ"},;
            {"ZAF_NOTFIS", "ZAF_NOTFIS"},;
            {"ZAF_VALOR",  "ZAF_VALOR"};
        }, ZAF->(IndexKey(1)))
     
    //Definindo outras informa�ões do Modelo e da Grid
    oModel:GetModel("MdGridZAF"):SetMaxLine(9999)
    oModel:SetDescription("Atualiza��o Controle de Combustível")
    oModel:SetPrimaryKey({"ZAF_FILIAL", "ZAF_IDSEQ", "ZAF_NOTFIS"})
 
Return oModel
 
Static Function ViewDef()
    //Na montagem da estrutura da visualiza��o de dados, vamos chamar o modelo criado anteriormente, no cabe�alho vamos mostrar somente 3 campos, e na grid vamos carregar conforme a fun��o fViewStruct
    Local oView        := NIL
    Local oModel    := FWLoadModel('ASATF04')
    Local oStruCab  := FWFormStruct(2, "ZAF", {|cCampo| AllTRim(cCampo) $ "ZAF_IDSEQ;ZAF_NOTFIS;ZAF_VALOR;"})
    Local oStruGRID := fViewStruct()
 
    //Define que no cabe�alho n�o ter� separa��o de abas (SXA)
    oStruCab:SetNoFolder()
 
    //Cria o View
    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    //Cria uma �rea de Field vinculando a estrutura do cabe�alho com MDFieldZAF, e uma Grid vinculando com MdGridZAF
    oView:AddField('VIEW_ZAF', oStruCab, 'MdFieldZAF')
    oView:AddGrid ('GRID_ZAF', oStruGRID, 'MdGridZAF' )
 
    //O cabe�alho (MAIN) ter� 25% de tamanho, e o restante de 75% ir� para a GRID
    oView:CreateHorizontalBox("MAIN", 25)
    oView:CreateHorizontalBox("GRID", 75)
 
    //Vincula o MAIN com a VIEW_ZAF e a GRID com a GRID_ZAF
    oView:SetOwnerView('VIEW_ZAF', 'MAIN')
    oView:SetOwnerView('GRID_ZAF', 'GRID')
    oView:EnableControlBar(.T.)
 
    //Define o campo incremental da grid como o ZAF_ITEM
    oView:AddIncrementField('GRID_ZAF', 'ZAF_ITEM')
Return oView
 
//Fun��o chamada para montar o modelo de dados da Grid
Static Function fModStruct()
    Local oStruct
    oStruct := FWFormStruct(1, 'ZAF')
Return oStruct
 
//Fun��o chamada para montar a visualiza��o de dados da Grid
Static Function fViewStruct()
    Local cCampoCom := "ZAF_IDSEQ;ZAF_NOTFIS;ZAF_VALOR;"
    Local oStruct
 
    //Ir� filtrar, e trazer todos os campos, menos os que tiverem na vari�vel cCampoCom
    oStruct := FWFormStruct(2, "ZAF", {|cCampo| !(Alltrim(cCampo) $ cCampoCom)})
Return oStruct
 
//Fun��o que faz a valida��o da grid
Static Function fValidGrid(oModel)
    Local lRet     := .T.
    Local nDeletados := 0
    Local nLinAtual :=0
    Local oModelGRID := oModel:GetModel('MdGridZAF')
    Local oModelMain := oModel:GetModel('MdFieldZAF')
    Local nValorMain := oModelMain:GetValue("ZAF_VALOR")
    Local nValorGrid := 0
    Local cPictVlr   := PesqPict('ZAF', 'ZAF_VALOR')
 
    //Percorrendo todos os itens da grid
    For nLinAtual := 1 To oModelGRID:Length() 
        //Posiciona na linha
        oModelGRID:GoLine(nLinAtual) 
         
        //Se a linha for excluida, incrementa a vari�vel de deletados, sen�o ir� incrementar o valor digitado em um campo na grid
        If oModelGRID:IsDeleted()
            nDeletados++
        Else
            nValorGrid += NoRound(oModelGRID:GetValue("ZAF_TCOMB"), 4)
        EndIf
    Next nLinAtual
 
    //Se o tamanho da Grid for igual ao n�mero de itens deletados, acusa uma falha
    If oModelGRID:Length()==nDeletados
        lRet :=.F.
        Help( , , 'Dados Inv�lidos' , , 'A grid precisa ter pelo menos 1 linha sem ser excluida!', 1, 0, , , , , , {"Inclua uma linha v�lida!"})
    EndIf
 
    If lRet
        //Se o valor digitado no cabe�alho (valor da NF), n�o bater com o valor de todos os abastecimentos digitados (valor dos itens da Grid), ir� mostrar uma mensagem alertando, por�m ir� permitir salvar (do contr�rio, seria necess�rio alterar lRet para falso)
        If nValorMain != nValorGrid
            //lRet := .F.
            MsgAlert("O valor do cabe�alho (" + Alltrim(Transform(nValorMain, cPictVlr)) + ") tem que ser igual o valor dos itens (" + Alltrim(Transform(nValorGrid, cPictVlr)) + ")!", "Aten��o")
        EndIf
    EndIf
 
Return lRet