#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENJOB02  ºAutor  ³Cleuto Lima         º Data ³  08/06/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Analise pedidos Web e cria parceria de comissão             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GENJOB02()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verificação para saber se a rotina esta sendo chamada pela Schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Prepare Environment Empresa "00" Filial "1022"

Conout("GENJOB02 - Inicio Job."+DtoC(DDataBase)+" - "+Time())
If LockByName("GENJOB02",.T.,.T.,.T.)

//Bloqueia alterações no Dicionário (Utilizado em base de teste)
/*__SetX31Mode(.T.)
X31UpdTable("ZZG")
__SetX31Mode(.F.)*/

    GENJOB02A()

    UnLockByName("GENJOB02",.T.,.T.,.T.)
    
    Conout("GENJOB02 - finalizando Job "+DtoC(DDataBase)+" - "+Time())
    
Else
    Conout("GENJOB02 - não foi possível iniciar a rotina pois a mesma já está sendo executada! "+DtoC(DDataBase)+" - "+Time())
EndIf	

Reset Environment

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENJOB02A ºAutor  ³Cleuto Lima         º Data ³  08/06/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa Job                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function GENJOB02A()

Local cQuery    := ""
Local cWhere    := ""

Local nRenova   := GetMv("GEN_FAT262",.F.,365)
Local lOK       := .F.
Local cFornece  := "" 
Local cLoja     := "" 
Local cCupom    := ""
Local nComis    := 0
Local cMsg      := ""
Local dPriComp  := CtoD("  /  /  ")
Local cCupGEN   := GetMv("GEN_FAT263",.F.,"CUPOM_GEN")
Local cTipo     := ""

DbSelectArea("ZZD")
DbSelectArea("ZZG")
DbSelectArea("SA1")

SA1->(DbSetOrder(1))
ZZD->(DbSetOrder(1))
ZZG->(DbSetOrder(1))

cQuery += "SELECT * FROM DBA_EGK.TT_I36_PEDIDOS_COMISSAO"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP_PED",.T.,.T.)

TMP_PED->(DbGoTop())

While TMP_PED->(!EOF())

    lOK      := .F.
    cFornece := ""
    cLoja    := ""
    cCupom   := ""
    nComis   := 0
    cMsg     := ""
    dPriComp := ""
    cTipo    := TMP_PED->TIPO

    SA1->( DbSeek( xFilial("SA1")+TMP_PED->C5_CLIENTE + TMP_PED->C5_LOJACLI ) )

    IF TMP_PED->TIPO == "V"
        IF !Empty(TMP_PED->CUPOM) /* pedido tem cupom */
            cCupom   := PadR(Upper(TMP_PED->CUPOM),TamSX3("ZZD_CUPOM")[1])

            IF !(ZZD->(DbSeek( xFilial("ZZD")+cCupom )) .AND. ZZD->ZZD_MSBLQL <> "1") /* verifico de é um cupom de parceria */
                cCupom  := ""
            ELSE

                cFornece := ZZD->ZZD_FORNEC
                cLoja    := ZZD->ZZD_LOJA            
                nComis   := ZZD->ZZD_COMCUP

                /*
                Analiso se devo atualizar a parceria
                */
                IF !Empty(SA1->A1_XCUPOM) /* se cliente tem parceria */
                    IF AllTrim(SA1->A1_XCUPOM) == AllTrim(cCupom)
                        IF SA1->A1_XVALPAR >= DDataBase /* se parceria está vigente, renovo por mais XX dias */
                            RecLock("SA1",.F.)
                            SA1->A1_XVALPAR := DDataBase+nRenova
                            MsUnLock()
                        ENDIF
                    ENDIF
                ENDIF

            ENDIF
        ENDIF

        /* criar vincula de parceria com cliente */
        IF Empty(SA1->A1_XCUPOM) 
            CriaParc()
        ENDIF

        IF Empty(cCupom) .AND. !Empty(SA1->A1_XCUPOM) /* pedido sem cupom e cliente tem parceria */   
            cCupom := PadR(Upper(SA1->A1_XCUPOM),TamSX3("ZZD_CUPOM")[1])

            IF (ZZD->(DbSeek( xFilial("ZZD")+cCupom ))  .AND. ZZD->ZZD_MSBLQL <> "1")/* verifico de é um cupom de parceria */
                cFornece := ZZD->ZZD_FORNEC
                cLoja    := ZZD->ZZD_LOJA
                nComis   := ZZD->ZZD_COMPAR
            ENDIF

            cCupom  := "" // zera o cupom pois o mesmo so deve ser informado na ZZG caso seja originado do pedido
        ENDIF
    ELSEIF TMP_PED->TIPO == "D"
        
        IF Select("TMP_COMISS") > 0
            TMP_COMISS->(DbCloseArea())
        ENDIF

        BeginSql Alias "TMP_COMISS"
            SELECT ZZG_FORNEC, ZZG_LOJA,ZZG_COMIS,ZZG_CUPOM FROM TOTVS.ZZG000 ZZG
            WHERE ZZG_FILIAL = %Exp:TMP_PED->C5_FILIAL%
            AND ZZG_PEDIDO = %Exp:TMP_PED->C5_NUM%
            AND ZZG_PEDWEB = %Exp:TMP_PED->C5_XPEDWEB%
            AND ZZG_NOTA = %Exp:TMP_PED->NFORI%
            AND ZZG_SERIE = %Exp:TMP_PED->SERIORI%
            AND ZZG_TIPO = 'V'
            AND ZZG.%NotDel%     
        EndSql
        
        TMP_COMISS->(DbGoTop())

        IF TMP_COMISS->(!EOF())
            cFornece := TMP_COMISS->ZZG_FORNEC
            cLoja    := TMP_COMISS->ZZG_LOJA
            nComis   := TMP_COMISS->ZZG_COMIS
            cCupom   := TMP_COMISS->ZZG_CUPOM
            cMsg     := ""            
        ELSE
            TMP_COMISS->(DbCloseArea())
            TMP_PED->(Dbskip())
            LOOP
        ENDIF
        TMP_COMISS->(DbCloseArea())
    ELSE
        TMP_PED->(Dbskip())
        LOOP
    ENDIF

    Begin Transaction
        IF !ZZG->(DbSeek( TMP_PED->C5_FILIAL + TMP_PED->C5_NUM + TMP_PED->C5_NOTA + TMP_PED->C5_SERIE ))

            RecLock("ZZG",.T.)
            ZZG->ZZG_STATUS := "2"  // Aguardando processamento
            ZZG->ZZG_TIPO   := cTipo
            ZZG->ZZG_MSG    := cMsg
            ZZG->ZZG_FILIAL := TMP_PED->C5_FILIAL
            ZZG->ZZG_PEDIDO := TMP_PED->C5_NUM
            ZZG->ZZG_PEDWEB := TMP_PED->C5_XPEDWEB
            ZZG->ZZG_NOTA   := TMP_PED->C5_NOTA 
            ZZG->ZZG_SERIE  := TMP_PED->C5_SERIE
            ZZG->ZZG_DTINC  := DDataBase
            ZZG->ZZG_HORAIN := Time()
            ZZG->ZZG_USRINC := "GENJOB02"

            ZZG->ZZG_FORNEC := cFornece
            ZZG->ZZG_LOJA   := cLoja
            ZZG->ZZG_CUPOM  := cCupom
            ZZG->ZZG_COMIS  := nComis
            MsUnLock()

        ENDIF
    End Transaction

    TMP_PED->(Dbskip())
EndDo

Return nil

Static Function CriaParc()

Local dPriComp  := CtoD("  /  /  ")
Local cQuery    := ""
Local cCupGEN   := GetMv("GEN_FAT263",.F.,"CUPOM_GEN")
Local nRenova   := GetMv("GEN_FAT262",.F.,365)

IF Select("TMP_VENDA") > 0
    TMP_VENDA->(DbCloseArea())
ENDIF     

cQuery += " SELECT NVL((
cQuery += " SELECT TO_CHAR(MIN(DATA_PEDIDO),'YYYYMMDD')
cQuery += " FROM GENESB.PEDIDO_NOVO UM_GENESB
cQuery += " WHERE regexp_replace( regexp_replace(regexp_replace(TRIM(UM_GENESB.COBRANCA_CPF_CNPJ),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]','') =  '"+AllTrim(SA1->A1_CGC)+"'"
cQuery += " ),' ') PED_MAG,
cQuery += " NVL(( 
cQuery += " SELECT MIN(F2_EMISSAO) FROM "+RetSqlName("SF2")+" SF2
cQuery += " WHERE F2_CLIENTE = '"+SA1->A1_COD+"'"
cQuery += " AND F2_LOJA = '"+SA1->A1_LOJA+"'"
cQuery += " AND SF2.D_E_L_E_T_ <> '*'
cQuery += " ),' ') PRD_PRO,
cQuery += " NVL((
cQuery += " SELECT TO_CHAR(MIN(DATA_PEDIDO),'YYYYMMDD') 
cQuery += " FROM GENESB.PEDIDO_NOVO UM_GENESB
cQuery += " JOIN GENESB.PAGAMENTO_NOVO PG
cQuery += " ON PG.PEDIDO_ENTITY_ID = UM_GENESB.ENTITY_ID
cQuery += " JOIN "+RetSqlName("ZZD")+" ZZD
cQuery += " ON ZZD_FILIAL = '"+xFilial("ZZD")+"'
cQuery += " AND TRIM(ZZD_CUPOM) = Upper(TRIM(CODIGO_CUPOM))
cQuery += " AND ZZD.D_E_L_E_T_ <> '*'
cQuery += " WHERE TRIM(REPLACE(regexp_replace( regexp_replace(regexp_replace(TRIM(UM_GENESB.COBRANCA_CPF_CNPJ),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]',''),' ','')) =  '"+AllTrim(SA1->A1_CGC)+"'"
cQuery += " ),' ') PED_CUP      
cQuery += " FROM DUAL                

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP_VENDA",.T.,.T.)

/* 
verifico qual a data mais antiga, se a venda web ou venda protheus, deve ser feita desta forma para contemplar pre-venda
*/
TMP_VENDA->(DbGoTop())
IF !Empty(TMP_VENDA->PED_MAG)
    IF StoD(TMP_VENDA->PED_MAG) <= StoD(TMP_VENDA->PRD_PRO)
        dPriComp := StoD(TMP_VENDA->PED_MAG)
    ELSE    
        dPriComp := StoD(TMP_VENDA->PRD_PRO)
    ENDIF
ELSE
    dPriComp := StoD(TMP_VENDA->PRD_PRO)
ENDIF

IF !Empty( TMP_VENDA->PED_CUP ) /* achou venda com cupom de parceria */
    IF StoD(TMP_VENDA->PED_CUP) <= dPriComp /* cupom de parceria é menor que primeira compra protheus/web sem cupom */

        cQuery := " SELECT PG.CODIGO_CUPOM,DATA_PEDIDO
        cQuery += " FROM GENESB.PEDIDO_NOVO UM_GENESB
        cQuery += " JOIN GENESB.PAGAMENTO_NOVO PG
        cQuery += " ON PG.PEDIDO_ENTITY_ID = UM_GENESB.ENTITY_ID
        cQuery += " JOIN "+RetSqlName("ZZD")+" ZZD
        cQuery += " ON ZZD_FILIAL = '"+xFilial("ZZD")+"'
        cQuery += " AND TRIM(ZZD_CUPOM) = Upper(TRIM(CODIGO_CUPOM))
        cQuery += " AND ZZD.D_E_L_E_T_ <> '*'
        cQuery += " AND TO_CHAR(DATA_PEDIDO,'YYYYMMDD') = '"+TMP_VENDA->PED_CUP+"'"
        cQuery += " WHERE TRIM(REPLACE(regexp_replace( regexp_replace(regexp_replace(TRIM(UM_GENESB.COBRANCA_CPF_CNPJ),'[[:alpha:]]',''),'[[:punct:]]',''),'[[:blank:]]',''),' ','')) =  '"+AllTrim(SA1->A1_CGC)+"'"
        cQuery += " ORDER BY DATA_PEDIDO"

        IF Select("TMP_PRIPD") > 0 
            TMP_PRIPD->(DbCloseArea())
        ENDIF
        DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP_PRIPD",.T.,.T.)
        
        TMP_PRIPD->(DbGoTop())

        RecLock("SA1",.F.)
        SA1->A1_XCUPOM  := Upper(AllTrim(TMP_PRIPD->CODIGO_CUPOM))
        SA1->A1_XVALPAR := DDataBase+nRenova
        MsUnLock()
        TMP_PRIPD->(DbCloseArea())
    ELSE
        /* se não localizar parceria o cliente pertencera ao GEN */
        RecLock("SA1",.F.)
        SA1->A1_XCUPOM  := cCupGEN
        MsUnLock()        
    ENDIF
ELSE
    /* se não localizar parceria o cliente pertencera ao GEN */
    RecLock("SA1",.F.)
    SA1->A1_XCUPOM  := cCupGEN
    MsUnLock()    
ENDIF    

TMP_VENDA->(DbCloseArea())

Return nil