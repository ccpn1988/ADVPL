#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "Totvs.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA094   ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ fora de uso, foi descontinuado pelo fonte GENA100          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GENA094()

Private oBrowse                                                               
Private aRotina     := {}
Private cTipo       := ""
Private cTitTela    := "Cadastro de Colaborador"

Default cParamTipo   := "S"

DbSelectArea("ZZH")
ZZH->(DbSetOrder(1))

// Definição das Operações disponíveis.
aRotina := MenuDef()           

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('ZZH')

oBrowse:AddLegend( "ZZH_STATUS=='1'", "GREEN", "Integrado" )
oBrowse:AddLegend( "ZZH_STATUS=='2'", "RED", "Não Integrado" )
oBrowse:AddLegend( "ZZH_STATUS=='3'", "YELLOW", "Falha Integração" )

oBrowse:DisableDetails()
oBrowse:SetDescription(cTitTela) 
oBrowse:Activate()

Return NIL

Static Function MenuDef()
Local aRotina := {}

//aRotina := FWMVCMenu( "GENA092" )
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.GENA094' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.GENA094' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.GENA094' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.GENA094' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Aprovar' ACTION 'U_GENA094D' OPERATION 4 ACCESS 0

Return aRotina

Static Function ModelDef()
// Cria Estruturas para serem usadas no Modelo de Dados
Local oStruZZX  := FWFormStruct(1,'ZZH')
Local bBloco	:= {|oModel| loadField(oModel)}
// Cria Modelo de Dados
Local oModel 

oModel := MPFormModel():New('MDFGENA094')

// Adiciona um Componente de Formulário ao modelo.
oModel:AddFields('ZZH_FORM',/*cOwner*/,oStruZZX,/*blinePre*/,/*blinePos*/) 

// Descrição do Modelo
oModel:SetDescription(cTitTela) 
// Descrição do Modelo
oModel:GetModel('ZZH_FORM'):SetDescription(cTitTela)

Return oModel      

Static Function ViewDef()

// Cria Estruturas para serem usadas na View
Local oStruZZX  := FWFormStruct(2,'ZZH')
// Carrega o modelo de dados de um fonte MVC. No caso, carregamos deste fonte mesmo.
Local oModel := FWLoadModel('GENA094')
// Cria o modelo da View
Local oView := FWFormView():New()

// Definimos qual modelo será carregado nessa View
oView:SetModel(oModel)

// Adiciona os componentes visuais. Cada componente Está relacionado à um modelo de Estrutura de dados, definidos em ModelDef()
oView:AddField('VIEW_ZZH', oStruZZX, 'ZZH_FORM')

//oStruZZX:SetProperty( "ZZX_MSBLQL", MVC_VIEW_INSERTLINE , .T. )

// Agora vamos criar 'box' para suportar os componentes. Box é uma descrição genérica para Window, Panel, etc
oView:CreateHorizontalBox( 'CAB', 100 ) // ocupar 100% da tela
 
// Relacionamos o Box criado ao objeto View
oView:SetOwnerView('VIEW_ZZH' ,'CAB')

//Para mostrar os titulos dos grids                                          
oView:EnableTitleView('VIEW_ZZH')

Return oView

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA094   ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function GENA094J()

Local aCabec    := {}
Local cPath     := "\LogSiga\Autonomos\"
Local cfile     := ""
Local cNewMat   := ""
Local aSraSx3   := {}
Local aSXOrig   := {}
Local cObrCp    := ""
Local nAuxVld   := 0

    Conout("GENA094J - Iniciando Job - Integração de colaboradores - "+Time()+".")
 
    RpcSetType(2)
    RpcSetEnv( "00" , "1022")
    
    IF !LockByName("GENA094J",.T.,.T.,.T.)
        Conout("GENA094J - Não foi possível iniciar a Jobs pois a mesma já está em execução - "+Time()+".")
        Return nil
    EndIF

    DbSelectArea("ZZH")

    aSraSx3   := FWSX3Util():GetAllFields( "SRA", .T. )

    aEval(aSraSx3,{|x| IIF(  X3Obrigat( X ) , (Aadd(aSXOrig,x),cObrCp+="'"+x+"',") , nil ) })

    IF Select("TMP_ZZH") > 0
        TMP_ZZH->(DbCloseArea())
    EndIf

    BEGINSQL ALIAS "TMP_ZZH"
        SELECT ZZH_FILIAL,ZZH_MAT,ZZH.R_E_C_N_O_ ZZHREC FROM %Table:ZZH% ZZH
        WHERE ZZH.ZZH_STATUS <> '1'
        AND ZZH.%NotDel%
        ORDER BY ZZH_FILIAL        
    ENDSQL

    TMP_ZZH->(DbGotop())

    While TMP_ZZH->(!EOF())
        
        ZZH->(DBGoto(TMP_ZZH->ZZHREC))
        
        IF ZZH->ZZH_FILIAL <> cFilAnt
            SM0->(dbSetOrder(1))
            SM0->(dbSeek(cEmpAnt + ZZH->ZZH_FILIAL,.T.)) //Posiciona Empresa
                    
            cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
            cFilAnt := SM0->M0_CODFIL
            OpenFile(cEmpAnt + cFilAnt)
        ENDIF
        
        IF Select("TMP_MAT")
            TMP_MAT->(DbCloseArea())
        Endif

        BEGINSQL ALIAS "TMP_MAT"
            SELECT NVL(MAX(RA_MAT),"600000") RA_MAT FROM %Table:SRA% SRA
            WHERE RA_FILIAL = %xFilial:SRA% 
            AND RA_CATFUNC = 'A' 
            AND RA_PROCES ='00003' 
            AND SRA.%NotDel%
            AND RA_MAT BETWEEN '600000' AND '699999'
        ENDSQL
        
        cNewMat := Soma1(TMP_MAT->RA_MAT)

        IF cNewMat >= "699999"
            MemoWrite(cPath+"FALHA_NUMERACAO.LOG","O CONTROLE DE NUMERAÇÃO NÃO TEM REGISTROS LIBERADOS PARA A FILIAL "+cFilAnt)
            Exit
        EndIF
        
        aCabec := {;
        {'RA_FILIAL',cFilAnt,NIL},;
        {'RA_MAT',cNewMat,NIL},;
        {'RA_ESTADO',ZZH->ZZH_ESTADO,NIL},;
        {'RA_SERCP',ZZH->ZZH_SERCP,NIL},;
        {'RA_COMPSAB',ZZH->ZZH_COMPSA,NIL},;
        {'RA_CIC',ZZH->ZZH_CIC,NIL},;
        {'RA_CLVL',ZZH->ZZH_CLVL,NIL},;
        {'RA_NACIONA',ZZH->ZZH_NACION,NIL},;
        {'RA_APELIDO',ZZH->ZZH_APELID,NIL},;
        {'RA_HRSEMAN',ZZH->ZZH_HRSEMA,NIL},;
        {'RA_TNOTRAB',ZZH->ZZH_TNOTRA,NIL},;
        {'RA_NOMECMP',ZZH->ZZH_NOMECM,NIL},;
        {'RA_GRINRAI',ZZH->ZZH_GRINRA,NIL},;
        {'RA_EMAIL',ZZH->ZZH_EMAIL,NIL},;
        {'RA_BCDEPSA',ZZH->ZZH_BCDEPS,NIL},;
        {'RA_HOPARC',ZZH->ZZH_HOPARC,NIL},;
        {'RA_PROCES',ZZH->ZZH_PROCES,NIL},;
        {'RA_CC',ZZH->ZZH_CC,NIL},;
        {'RA_ITEM',ZZH->ZZH_ITEM,NIL},;
        {'RA_NACIONC',ZZH->ZZH_NACRFB,NIL},;
        {'RA_NOME',ZZH->ZZH_NOME,NIL},;
        {'RA_MUNICIP',ZZH->ZZH_MUNICI,NIL},;
        {'RA_PIS',ZZH->ZZH_PIS,NIL},;
        {'RA_SEXO',ZZH->ZZH_SEXO,NIL},;
        {'RA_DEPIR',ZZH->ZZH_DEPIR,NIL},;
        {'RA_TIPOADM',ZZH->ZZH_TIPOAD,NIL},;
        {'RA_OPCAO',ZZH->ZZH_OPCAO,NIL},;
        {'RA_VIEMRAI',ZZH->ZZH_VIEMRA,NIL},;
        {'RA_CEP',ZZH->ZZH_CEP,NIL},;
        {'RA_RG',ZZH->ZZH_RG,NIL},;
        {'RA_CATFUNC',ZZH->ZZH_CATFUN,NIL},;
        {'RA_TIPOPGT',ZZH->ZZH_TIPOPG,NIL},;
        {'RA_DEPTO',ZZH->ZZH_DEPTO,NIL},;
        {'RA_NATURAL',ZZH->ZZH_NATURA,NIL},;
        {'RA_NUMCP',ZZH->ZZH_NUMCP,NIL},;
        {'RA_CTDEPSA',ZZH->ZZH_CTDEPS,NIL},;
        {'RA_HRSMES',ZZH->ZZH_HRSMES,NIL},;
        {'RA_HRSDIA',ZZH->ZZH_HRSDIA,NIL},;
        {'RA_ENDEREC',ZZH->ZZH_ENDERE,NIL},;
        {'RA_BAIRRO',ZZH->ZZH_BAIRRO,NIL},;
        {'RA_NASC',ZZH->ZZH_NASC,NIL},;
        {'RA_ESTCIVI',ZZH->ZZH_ESTCIV,NIL},;
        {'RA_RGORG',ZZH->ZZH_RGORG,NIL},;
        {'RA_ADMISSA',ZZH->ZZH_ADMISS,NIL},;
        {'RA_CODFUNC',ZZH->ZZH_CODFUN,NIL};
        }
        
        cMsg := ""
        for nAuxVld := 1 to Len(aSXOrig)
            nPosObr := aScan(aCabec,{|x| AllTrim(x[1]) == AllTrim(aSXOrig[nAuxVld]) })
            IF nPosObr == 0 .or. Empty(aCabec[nPosObr][2])
                cMsg += "Campo: "+aSXOrig[nAuxVld]+" - "+Posicione("SX3",2,aSXOrig[nAuxVld],"X3_TITULO")+","+chr(13)+chr(10)
            EndIf
        next

        IF !Empty(cMsg)
            MemoWrite(cPath+TMP_ZZH->ZZH_MAT+"_CAMPO_OBR_NO.LOG",cMsg)
            TMP_ZZH->(DbSkip())
            Loop
        EndIf

        lMsErroAuto := .F.
        //lMSHelpAuto	:= .F.

        MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,3)
                
        If lMsErroAuto
            RecLock("ZZH",.F.)    
            ZZH->ZZH_STATUS := "3"
            MsUnLock()

            cfile   := ZZH->ZZH_MAT+".log"
            MostraErro(cPath,cfile)
        else
            RecLock("ZZH",.F.)    
            ZZH->ZZH_STATUS := "1"
            MsUnLock()
        EndIF 

        TMP_ZZH->(DbSkip())
    EndDo

    UnLockByName("GENA094J",.T.,.T.,.T.)

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENA094D  ºAutor  ³Cleuto Lima         º Data ³  23/08/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function GENA094D()

    Processa({|| AutToGPE() },"Processando...","Aguarde.. integrando cadastro com modulo GPE!",.F.)

Return nil

Static function AutToGPE()

    Local aCabec    := {}
    Local cPath     := "\LogSiga\Autonomos\"
    Local cfile     := ""
    Local cNewMat   := ""
    Local aSraSx3   := {}
    Local aSXOrig   := {}
    Local cObrCp    := ""
    Local nAuxVld   := 0
    Local cEmpBkp   := cEmpAnt
    Local cFilBkp   := cFilant
    Local cEmpAux   := cEmpant
    Local cFilAux   := ""

    ProcRegua(0)
    IncProc()

    IF !Empty(ZZH->ZZH_MATGPE) .OR. ZZH->ZZH_STATUS == "1"
        MsgStop("Autônomo já cadastrado no modulo GPE!")
        Return nil
    EndIf

    IF !MsgYesNo("Confirma aprovação do cadastro deste autônomo?")
        Return nil
    EndIF

    SRA->(DbSetOrder(5))
    If SRA->(DbSeek( ZZH->ZZH_FILIAL+ZZH->ZZH_CIC ))
        If !MsgYesNo("Já existe uma matricula para o CPF informado!"+Chr(13)+Chr(10)+"Deseja continuar mesmo assim?")
            Return nil
        EndIf
    EndIf

    SM0->(dbSetOrder(1))
    SM0->(dbSeek(cEmpAux + ZZH->ZZH_FILIAL,.T.)) //Posiciona Empresa
    
    cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
    cFilAnt := SM0->M0_CODFIL
    OpenFile(cEmpAnt + cFilAnt)

    aSraSx3   := FWSX3Util():GetAllFields( "SRA", .T. )
    aEval(aSraSx3,{|x| IIF(  X3Obrigat( X ) , (Aadd(aSXOrig,x),cObrCp+="'"+x+"',") , nil ) })

    IF Select("TMP_MAT")
        TMP_MAT->(DbCloseArea())
    Endif

    BEGINSQL ALIAS "TMP_MAT"
        SELECT NVL(MAX(RA_MAT),"600000") RA_MAT FROM %Table:SRA% SRA
        WHERE RA_FILIAL = %xFilial:SRA% 
        AND RA_CATFUNC = 'A' 
        AND RA_PROCES ='00003' 
        AND SRA.%NotDel%
        AND RA_MAT BETWEEN '600000' AND '699999'
    ENDSQL
    
    cNewMat := Soma1(TMP_MAT->RA_MAT)

    IF cNewMat >= "699999"
        MSgStop("O CONTROLE DE NUMERAÇÃO NÃO TEM REGISTROS LIBERADOS PARA A FILIAL "+cFilAnt)
        Return nil
    EndIF
    
    aCabec := {;
    {'RA_FILIAL',cFilAnt,NIL},;
    {'RA_MAT',cNewMat,NIL},;
    {'RA_ESTADO',ZZH->ZZH_ESTADO,NIL},;
    {'RA_SERCP',ZZH->ZZH_SERCP,NIL},;
    {'RA_COMPSAB',ZZH->ZZH_COMPSA,NIL},;
    {'RA_CIC',ZZH->ZZH_CIC,NIL},;
    {'RA_CLVL',ZZH->ZZH_CLVL,NIL},;
    {'RA_NACIONA',ZZH->ZZH_NACION,NIL},;
    {'RA_APELIDO',ZZH->ZZH_APELID,NIL},;
    {'RA_HRSEMAN',ZZH->ZZH_HRSEMA,NIL},;
    {'RA_TNOTRAB',ZZH->ZZH_TNOTRA,NIL},;
    {'RA_NOMECMP',ZZH->ZZH_NOMECM,NIL},;
    {'RA_GRINRAI',ZZH->ZZH_GRINRA,NIL},;
    {'RA_EMAIL',ZZH->ZZH_EMAIL,NIL},;
    {'RA_BCDEPSA',ZZH->ZZH_BCDEPS,NIL},;
    {'RA_HOPARC',ZZH->ZZH_HOPARC,NIL},;
    {'RA_PROCES',ZZH->ZZH_PROCES,NIL},;
    {'RA_CC',ZZH->ZZH_CC,NIL},;
    {'RA_ITEM',ZZH->ZZH_ITEM,NIL},;
    {'RA_NACIONC',ZZH->ZZH_NACRFB,NIL},;
    {'RA_NOME',ZZH->ZZH_NOME,NIL},;
    {'RA_MUNICIP',ZZH->ZZH_MUNICI,NIL},;
    {'RA_PIS',ZZH->ZZH_PIS,NIL},;
    {'RA_SEXO',ZZH->ZZH_SEXO,NIL},;
    {'RA_DEPIR',ZZH->ZZH_DEPIR,NIL},;
    {'RA_TIPOADM',ZZH->ZZH_TIPOAD,NIL},;
    {'RA_OPCAO',ZZH->ZZH_OPCAO,NIL},;
    {'RA_VIEMRAI',ZZH->ZZH_VIEMRA,NIL},;
    {'RA_CEP',ZZH->ZZH_CEP,NIL},;
    {'RA_RG',ZZH->ZZH_RG,NIL},;
    {'RA_CATFUNC',ZZH->ZZH_CATFUN,NIL},;
    {'RA_TIPOPGT',ZZH->ZZH_TIPOPG,NIL},;
    {'RA_DEPTO',ZZH->ZZH_DEPTO,NIL},;
    {'RA_NATURAL',ZZH->ZZH_NATURA,NIL},;
    {'RA_NUMCP',ZZH->ZZH_NUMCP,NIL},;
    {'RA_CTDEPSA',ZZH->ZZH_CTDEPS,NIL},;
    {'RA_HRSMES',ZZH->ZZH_HRSMES,NIL},;
    {'RA_HRSDIA',ZZH->ZZH_HRSDIA,NIL},;
    {'RA_ENDEREC',ZZH->ZZH_ENDERE,NIL},;
    {'RA_BAIRRO',ZZH->ZZH_BAIRRO,NIL},;
    {'RA_NASC',ZZH->ZZH_NASC,NIL},;
    {'RA_ESTCIVI',ZZH->ZZH_ESTCIV,NIL},;
    {'RA_RGORG',ZZH->ZZH_RGORG,NIL},;
    {'RA_ADMISSA',ZZH->ZZH_ADMISS,NIL},;
    {'RA_CODFUNC',ZZH->ZZH_CODFUN,NIL},;
    {'RA_CATEFD',"701",NIL},;
    {'RA_CODMUN' ,ZZH->ZZH_CODMUN,NIL},;
    {'RA_CPAISOR',ZZH->ZZH_CPAISO,NIL},;
    {'RA_LOGRDSC',ZZH->ZZH_LOGRDS,NIL},;
    {'RA_LOGRNUM',ZZH->ZZH_LOGRNU,NIL},;
    {'RA_RACACOR',ZZH->ZZH_RACACO,NIL},;
    {'RA_XCODGEN',ZZH->ZZH_MAT,NIL};
    }
    
    cMsg := ""
    for nAuxVld := 1 to Len(aSXOrig)
        nPosObr := aScan(aCabec,{|x| AllTrim(x[1]) == AllTrim(aSXOrig[nAuxVld]) })
        IF nPosObr == 0 .or. Empty(aCabec[nPosObr][2])
            cMsg += "Campo: "+aSXOrig[nAuxVld]+" - "+Posicione("SX3",2,aSXOrig[nAuxVld],"X3_TITULO")+","+chr(13)+chr(10)
        EndIf
    next

    IF !Empty(cMsg)
        MsgStop(cMsg)
        Return nil
    EndIf

    lMsErroAuto := .F.

    MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,3)

    SM0->(dbSetOrder(1))
    SM0->(dbSeek(cEmpBkp + cFilBkp,.T.)) //Posiciona Empresa
    
    cEmpAnt := SM0->M0_CODIGO //Seto as variaveis de ambiente
    cFilAnt := SM0->M0_CODFIL
    OpenFile(cEmpAnt + cFilAnt)

    If lMsErroAuto
        RecLock("ZZH",.F.)    
        ZZH->ZZH_STATUS := "3"
        MsUnLock()
        MostraErro()
    else
        RecLock("ZZH",.F.)    
        ZZH->ZZH_STATUS := "1"
        ZZH->ZZH_MATGPE := cNewMat
        MsUnLock()
        MsgInfo("Autônomo cadastrado com sucesso!")
    EndIF 

    
Return nil