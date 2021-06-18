#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Cleuto Lima         º DATE ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
CLASS GenNewZZL 

DATA ZZL_FILIAL
DATA ZZL_COD
DATA ZZL_SITOBR	//C	18	Sit.Produto 	                                                                                                                                
DATA ZZL_IDTPPU	//C	18	Tp.Produto. 
DATA ZZL_TIPINC	//C	1	Natu.Produto	1=Produto Novo;2=Nova Edição   
DATA ZZL_CC    	//C	9	Centro Lucro	                                                                                                                                
//DATA ZZL_PSITEG	//C	1	Permite Site	1=Sim;2=Não                                                                                                                     
DATA ZZL_AUTOR 	//C	50	Autor Princ.	                                                                                                                                
DATA ZZL_OFERT 	//C	1	Ofertar?    	1=Sim;2=Não                                                                                                                     
//DATA ZZL_PRV1  	//N	12	Preco Venda 	                                                                                                                                
DATA ZZL_DTPPRE	//D	8	Dt.Pub.Prev.	                                                                                                                                
//DATA ZZL_CONSIG	//C	1	Consignar?  	1=Sim;2=Não                                                                                                                     
DATA ZZL_DESC  	//C	254	Titulo      	                                                                                                                                
DATA ZZL_EDICAO	//C	10	Edicao      	                                                                                                                                
DATA ZZL_GRAU  	//C	1	Grau Import.	A=A;B=B;C=C                                                                                                                     
DATA ZZL_CLASSE	//C	18	Clas.Descont	                                                                                                                                
DATA ZZL_PERCRM	//C	1	Perm CRM    	1=Sim;2=Não                                                                                                                     
//DATA ZZL_TABPRC	//C	1	Tab.Preco?  	1=Sim;2=Não                                                                                                                     
DATA ZZL_EMPRES	//C	18	ID Empresa  	                                                                                                                                
DATA ZZL_AREGER	//C	6	Area Gerenc.	                                                                                                                                
DATA ZZL_CODHIS	//C	8	Cod.Hist.   	                                                                                                                                
DATA ZZL_SELO  	//C	2	Selo Editor.	                                                                                                                                
DATA ZZL_ESTRAN	//C	1	Estrangeira 	1=Sim;2=Não                                                                                                                     
//DATA ZZL_DTPUBL	//D	8	Dt.Publica. 	                                                                                                                                	                                                                                                                                
DATA ZZL_QTDPAG	//C	5	Qtd.Paginas 	                                                                                                                                
//DATA ZZL_PESO  	//N	12	Peso        	                                                                                                                                
DATA ZZL_CORMIO	//C	18	Cor Miolo   	                                                                                                                                
DATA ZZL_FORCAP	//C	18	Formato Capa	                                                                                                                                
DATA ZZL_TIRPRE	//C	18	Tirag.Previ.	                                                                                                                                                                                                                                 
DATA ZZL_TPACAB	//C	18	Acab.Capa   	                                                                                                                                
DATA ZZL_IDMAE 	//C	30	ID Obra Mae 	                                                                                                                                
DATA ZZL_CEME  	//C	254	Titulo Web  
DATA ZZL_DTINC 	//D	8	Dt.Inclusão 
DATA ZZL_HRINCL
DATA ZZL_ISBNOR	//C	50	ISBN Origem 
DATA ZZL_NROPAG //N	4	Nro. Paginas	     
DATA ZZL_USRINC	//C	30	User Inclui  
DATA ZZL_AUTWEB
DATA CLASSIFICA
DATA MAE

DATA LERRO
DATA CERRO

METHOD New() CONSTRUCTOR
METHOD DeParaZZExZZL()
METHOD CriaProduto()
METHOD CriaReimpre()

ENDCLASS

/********* CONSTRUCTOR  *********/
METHOD New() Class GenNewZZL

::ZZL_FILIAL    := xFilial("ZZL")
::ZZL_COD       := ""
::ZZL_SITOBR	:= "000"	//C	18	Sit.Produto 	                                                                                                                                
::ZZL_CC    	:= ""	//C	9	Centro Lucro	                                                                                                                                
//::ZZL_PSITEG	:= ""	//C	1	Permite Site	1=Sim;2=Não                                                                                                                     
::ZZL_AUTOR 	:= ""	//C	50	Autor Princ.	                                                                                                                                
::ZZL_OFERT 	:= ""	//C	1	Ofertar?    	1=Sim;2=Não                                                                                                                     
//::ZZL_PRV1  	:= 0	//N	12	Preco Venda 	                                                                                                                                
::ZZL_DTPPRE	:= CtoD("  /  /  ")	//D	8	Dt.Pub.Prev.	                                                                                                                                
//::ZZL_CONSIG	:= ""	//C	1	Consignar?  	1=Sim;2=Não                                                                                                                     
::ZZL_DESC  	:= ""	//C	254	Titulo      	                                                                                                                                
::ZZL_EDICAO	:= ""	//C	10	Edicao      	                                                                                                                                
::ZZL_GRAU  	:= ""	//C	1	Grau Import.	A=A;B=B;C=C                                                                                                                     
::ZZL_CLASSE	:= ""	//C	18	Clas.Descont	                                                                                                                                
::ZZL_PERCRM	:= ""	//C	1	Perm CRM    	1=Sim;2=Não                                                                                                                     
//::ZZL_TABPRC	:= ""	//C	1	Tab.Preco?  	1=Sim;2=Não                                                                                                                     
::ZZL_EMPRES	:= ""	//C	18	ID Empresa  	                                                                                                                                
::ZZL_AREGER	:= ""	//C	6	Area Gerenc.	                                                                                                                                
::ZZL_CODHIS	:= ""	//C	8	Cod.Hist.   	                                                                                                                                
::ZZL_SELO  	:= ""	//C	2	Selo Editor.	                                                                                                                                
::ZZL_ESTRAN	:= ""	//C	1	Estrangeira 	1=Sim;2=Não                                                                                                                     
//::ZZL_DTPUBL	:= CtoD("  /  /  ")	//D	8	Dt.Publica. 	                                                                                                                                
::ZZL_IDTPPU	:= ""	//C	18	Tp.Produto. 	                                                                                                                                
::ZZL_QTDPAG	:= ""	//C	5	Qtd.Paginas 	                                                                                                                                
//::ZZL_PESO  	:= 0	//N	12	Peso        	                                                                                                                                
::ZZL_CORMIO	:= ""	//C	18	Cor Miolo   	                                                                                                                                
::ZZL_FORCAP	:= ""	//C	18	Formato Capa	                                                                                                                                
::ZZL_TIRPRE	:= ""	//C	18	Tirag.Previ.	                                                                                                                                
::ZZL_TIPINC	:= ""	//C	1	Natu.Produto	1=Produto Novo;2=Nova Edição                                                                                                    
::ZZL_TPACAB	:= ""	//C	18	Acab.Capa
::ZZL_IDMAE 	:= ""	//C	30	ID Obra Mae
::ZZL_CEME  	:= ""	//C	254	Titulo Web
::ZZL_DTINC     := DDataBase 	//D	8	Dt.Inclusão 
::ZZL_HRINCL    := TIME()
::ZZL_ISBNOR	:= ""   //C	50	ISBN Origem 
::ZZL_NROPAG    := 0    //N	4	Nro. Paginas	                                                                                                                                                                                                                                                             
::ZZL_USRINC	:= AllTrim(UsrRetName(RetCodUsr()))//C	30	User Inclui   
::ZZL_ESTRAN    := ""
::ZZL_AUTWEB    := ""
::CLASSIFICA    := {}
::MAE           := .F.

::LERRO         := .F.
::CERRO         := ""

Return Self

/********* CriaProduto  *********/
METHOD CriaProduto(cPPE) Class GenNewZZL

Local cCodZZL   := ""
Local aNames    := {}
Local nLenNames := 0
Local nAuxRec   := 0
Local cProp     := ""
Local aZZS      := {}

IF Empty(cPPE)
    ::LERRO := .T.
    ::CERRO := "Numero da PPE não informado!
    Return Self
ENDIF

::ZZL_COD   := ""

IF !Empty(ZZK->ZZK_CODPRO)
    cCodZZL := ZZK->ZZK_CODPRO
ELSE
    IF !xGetZZLCod(@cCodZZL)
        ::LERRO := .T.
        ::CERRO := "Falha no controle de numeração da tabela ZZL, não foi possível gerar o codigo do produto!"+chr(13)+Chr(10)+;
            "Tenta novamente, caso o problema continue entre em contato com a TI"
        Return Self
    ENDIF
ENDIF    

xGetZZS(@aZZS,::ZZL_IDTPPU)
::ZZL_COD := cCodZZL
/* se obra impressa será sempre o ID Mãe */
IF ::MAE
    ::ZZL_IDMAE := cCodZZL
ELSE
    IF Select("TMP_IDMAE") > 0
        TMP_IDMAE->(DbCloseArea())
    ENDIF

    BEGINSQL ALIAS "TMP_IDMAE"
        SELECT ZZK_CODPRO FROM %Table:ZZK% ZZK
        WHERE ZZK_FILIAL = %xFilial:ZZK%
        AND ZZK_PPE = %Exp:ZZE->ZZE_PPE%
        AND ZZK.%NotDel%
        AND ZZK_CODPRO <> ' '
        AND ZZK_EMAE = '1'
    ENDSQL
    
    IF TMP_IDMAE->(!EOF())
        ::ZZL_IDMAE := TMP_IDMAE->ZZK_CODPRO
    ENDIF    

    TMP_IDMAE->(DbCloseArea())
ENDIF

//IF AllTrim(::ZZL_IDTPPU) <> "1" .AND. Empty(::ZZL_IDMAE)
IF Empty(::ZZL_IDMAE)
    ::LERRO := .T.
    ::CERRO := "ID Mãe não informado para "+::ZZL_DESC
    Return Self    
ENDIF

IF AllTrim(::ZZL_TIPINC) == "1"
    ::ZZL_CODHIS := cCodZZL
ELSE
    ::ZZL_CODHIS := ZZK->ZZK_CODHIS
ENDIF

IF Empty(::ZZL_CODHIS)
    ::LERRO := .T.
    ::CERRO := "ID Historico não informado para "+::ZZL_DESC
    Return Self    
ENDIF

aNames    := ClassDataArr(self, .T.)
nLenNames := Len(aNames)

lNew := !ZZL->(DbSeek( xFilial("ZZL") + cCodZZL ))
IF lNew
    IF Empty(cCodZZL)
        ::LERRO := .T.
        ::CERRO := "Código novo não informado!"
        Return Self          
    ENDIF
ELSE 
    IF cCodZZL <> ZZK->ZZK_CODPRO .OR. cCodZZL <> ZZL->ZZL_COD
        ::LERRO := .T.
        ::CERRO := "Código novo invalido!"
        Return Self              
    ELSEIF ZZL->ZZL_DTALTE <> ZZK->ZZK_DTINC .OR. ZZL->ZZL_HALTER <> ZZK->ZZK_HRINCL
        ::LERRO := .T.
        ::CERRO := "Produto não pode ser alterado pois já foi manipulado no modulo gestão de produtos!"
        Return Self
    ENDIF
ENDIF
RecLock("ZZL",lNew)
For nAuxRec := 1 To nLenNames 

    IF aScan(aZZS, {|x| x == aNames[nAuxRec][1] }) == 0 .OR.;
        aNames[nAuxRec][1] $ "ZZL_COD#ZZL_PPE#"        
        Loop
    ENDIF
    
    cProp := 'Self:'+aNames[nAuxRec][1]
    ZZL->&(aNames[nAuxRec][1]) := aNames[nAuxRec][2]//&(cProp)
Next nAuxRec
ZZL->ZZL_PPE    := cPPE
ZZL->ZZL_COD    := cCodZZL
ZZL->ZZL_DTINC  := ::ZZL_DTINC
ZZL->ZZL_HRINCL := ::ZZL_HRINCL
ZZL->ZZL_DTALTE  := ::ZZL_DTINC
ZZL->ZZL_HALTER := ::ZZL_HRINCL

MsUnLock()

ConfirmSX8()

Return Self

/********* xGetZZLCod  *********/
Static Function xGetZZLCod(cCodZZL)

Local lRet      := .F.
Local cCodAux   := ""
Local nQtdAux   := 0

cCodAux := GetSX8Num("ZZL","ZZL_COD")

ZZL->(DbSetOrder(1))
While ZZL->(DbSeek( xFilial("ZZL") + cCodAux )) .AND. nQtdAux <= 500
    ConfirmSX8()
    nQtdAux++
    cCodAux := GetSX8Num("ZZL","ZZL_COD")
EndDo

IF !ZZL->(DbSeek( xFilial("ZZL") + cCodAux ))
    lRet := .T.
    cCodZZL := cCodAux
ENDIF

Return lRet

Static Function xGetZZS(aZZS,cTpPub)

IF Select("TMP_ZZS") > 0
    TMP_ZZS->(DbCloseArea())
ENDIF

BeginSql Alias "TMP_ZZS"
  SELECT DISTINCT ZZS_CAMPO FROM %Table:ZZS% ZZS
  WHERE ZZS_FILIAL = %xFilial:ZZS%
  AND ZZS_NUM = '01'
  AND ZZS.ZZS_TPPUB = %Exp:cTpPub%
  AND ZZS.%NotDel%
  AND ZZS.ZZS_SITOBR BETWEEN '000' AND '199'
  AND ZZS.ZZS_ACESSO = '2'
EndSql
TMP_ZZS->(DbEval( {|| Aadd(aZZS, AllTrim(TMP_ZZS->ZZS_CAMPO) ) } ))
TMP_ZZS->(DbCloseArea())


Return nil


/********* DeParaZZExZZL  *********/
METHOD DeParaZZExZZL(cDescTp) Class GenNewZZL

Local aClassif  := {}

::ZZL_FILIAL := xFilial("ZZL")
::ZZL_CC     := ZZE->ZZE_CC

IF AllTrim(ZZK->ZZK_IDTPPU) == "1"
    ::ZZL_AUTOR  := AllTrim(Upper(NoAcento(ZZE->ZZE_AUTOR)))
ELSE
    ::ZZL_AUTOR  := AllTrim(Upper(NoAcento(ZZE->ZZE_AUTOR)))+"-"+AllTrim(upper(Posicione("ZZT",1,xFilial("ZZT") + ZZK->ZZK_IDTPPU, "ZZT_REDUZ")))
ENDIF
::ZZL_OFERT  := ZZE->ZZE_OFERT
::ZZL_DTPPRE := ZZE->ZZE_DTPPRE
::ZZL_EDICAO := ZZE->ZZE_EDICAO
::ZZL_GRAU   := ZZE->ZZE_GRAU
::ZZL_CLASSE := ZZE->ZZE_CLASSE
::ZZL_EMPRES := ZZE->ZZE_EMPRES
::ZZL_AREGER := ZZE->ZZE_AREGER
::ZZL_SELO   := ZZE->ZZE_SELO
::ZZL_QTDPAG := ZZE->ZZE_QTDPAG
::ZZL_CORMIO := ZZE->ZZE_CORMIO
::ZZL_FORCAP := ZZE->ZZE_FORCAP
::ZZL_TIRPRE := ZZE->ZZE_TIRPRE
::ZZL_TPACAB := ZZE->ZZE_TPACAB	
::ZZL_AUTWEB := ZZE->ZZE_AUTWEB
::MAE        := AllTrim(ZZK->ZZK_EMAE) == "1"

::ZZL_IDTPPU := ZZK->ZZK_IDTPPU
::ZZL_TIPINC := IIF( ZZK->ZZK_TIPINC == "91" , "1" , "2" )

IF AllTrim(ZZK->ZZK_IDTPPU) == "1"    
    ::ZZL_DESC   := ::ZZL_AUTOR+"-"+Upper(AllTrim(NoAcento(ZZE->ZZE_DESC)))+" "+StrTran(AllTrim(ZZE->ZZE_EDICAO),"|","/")
    ::ZZL_CEME   := Capital(ZZE->ZZE_CEME)+" "+StrTran(AllTrim(ZZE->ZZE_EDICAO),"|","/")
ELSE
    ::ZZL_DESC   := ::ZZL_AUTOR+" "+Upper(AllTrim(NoAcento(ZZE->ZZE_DESC)))+" "+StrTran(AllTrim(ZZE->ZZE_EDICAO),"|","/")
    ::ZZL_CEME   := AllTrim(Capital(Posicione("ZZT",1,xFilial("ZZT") + ZZK->ZZK_IDTPPU, "ZZT_REDUZ")))+" "+AllTrim(Capital(ZZE->ZZE_CEME))+" "+StrTran(AllTrim(ZZE->ZZE_EDICAO),"|","/")
ENDIF

xGetClass(@aClassif)

::CLASSIFICA    := aClone(aClassif)

Return Self


Static Function xRetDesc(cDescTp, cDesc, nTipo)

	Local cRet
	Local nPosAux	:= At("-",cDesc)

	IF nTipo == 1
		IF nPosAux > 0
			cRet := SUBSTR(cDesc,1,nPosAux)+cDescTp+" "+SUBSTR(cDesc,nPosAux,Len(cDesc))
		ELSE
			cRet := Upper(cDescTp)+" "+cDesc
		ENDIF
	ELSE
		cRet := Capital(cDescTp)+" "+cDesc
	ENDIF

Return cRet


Static Function xGetClass(aClassif)

	Local cRotina	:= PadR("GENA103",TamSX3("ZZN_ORIGEM")[1])
    aClassif        := {}

	IF Select("TMP_ZZN") > 0
		TMP_ZZN->(DbCloseArea())
	ENDIF

	BeginSql Alias "TMP_ZZN"
	SELECT ZZN_CODSIT, ZZN_CODCAT, ZZN_DESC, ZZN_PRODUT, ZZN_ORIGEM 
	FROM %Table:ZZN% ZZN
	WHERE ZZN_FILIAL = %xFilial:ZZN%
	AND ZZN_PRODUT = %Exp:ZZE->ZZE_PPE%
	AND ZZN_ORIGEM = %Exp:cRotina%
	AND ZZN.%NotDel%
	ORDER BY ZZN_CODSIT, ZZN_CODCAT
	EndSql
	TMP_ZZN->(DbGoTop())
	TMP_ZZN->(DBEval( {|| Aadd(aClassif, { TMP_ZZN->ZZN_CODSIT, TMP_ZZN->ZZN_CODCAT, TMP_ZZN->ZZN_DESC, TMP_ZZN->ZZN_PRODUT, TMP_ZZN->ZZN_ORIGEM } ) } ))
	TMP_ZZN->(DbCloseArea())

Return nil



/********* CriaReimpre  *********/
METHOD CriaReimpre(cPPE) Class GenNewZZL

IF Empty(cPPE)
    ::LERRO := .T.
    ::CERRO := "Numero da PPE não informado!
    Return Self
ENDIF

::ZZL_COD   := ""

IF Empty(ZZK->ZZK_CODANT)
    ::LERRO := .T.
    ::CERRO := "Produto anterior não informado!"+chr(13)+Chr(10)+;
        "Verifique se o codido produto anterior foi devidamente informado!"
    Return Self
ENDIF

ZZL->(DbSetOrder(1))
IF !ZZL->(DbSeek( xFilial("ZZL") + ZZK->ZZK_CODANT))
    ::LERRO := .T.
    ::CERRO := "Produto anterior não localizado!"+chr(13)+Chr(10)+;
        "Verifique se o codido produto anterior foi corretamente informado!"
    Return Self
ENDIF

    nItem   := U_GENA093S()
    IF Empty(ZZK->ZZK_CODPRO)
        cIdProd := U_GENA093P()
        ConfirmSX8()
    ELSE 
        cIdProd := ZZK->ZZK_CODPRO
    ENDIF 

    ::ZZL_COD    := cIdProd
    ::ZZL_DTINC  := DDataBase
    ::ZZL_HRINCL := Time()
    
    ZZW->(DbSetOrder(1))//ZZW_FILIAL+ZZW_CODPRO+ZZW_IDPROD    
    lNew := !ZZW->(DbSeek( xFilial("ZZW") + ZZL->ZZL_COD + cIdProd ))
    RecLock("ZZW", lNew )
    ZZW->ZZW_CODPRO	:= ZZL->ZZL_COD     //C	8	Produto     
    IF lNew
        ZZW->ZZW_ITEM  	:= nItem            //N	2	Sequencia   
    ENDIF
    ZZW->ZZW_IDPROD	:= ::ZZL_COD        //C	8	Id.Produção 
    ZZW->ZZW_DTPREV	:= ZZE->ZZE_DTPPRE  //D	8	Dt.Pub.Prev.
    ZZW->ZZW_TIRPRE	:= Val(ZZE->ZZE_TIRPRE)  //N	15	Tirag.Previ.
    ZZW->ZZW_SITUAC	:= "1"              //C	1	Situação    
    ZZW->ZZW_DTREIM	:= ZZE->ZZE_DTINC//D	8	Dt.Reimpress <-  é preenchido pelo propub
    ZZW->ZZW_QTDPAG	:= VAL(ZZE->ZZE_QTDPAG)//N	5	Qtd.Paginas  <-  é preenchido pelo propub
    //ZZW->ZZW_TIRREL	:= //N	15	Tirag.Reali.  <-  é preenchido pelo propub
    //ZZW->ZZW_DTREAL	:= //D	8	Dt.Reim.Real  <-  é preenchido pelo propub
    //ZZW->ZZW_DTPUB 	:= //D	8	Dt.Publica. 
    MsUnLock()

    MsgRun("Classe de Valor","Processando integração com RPA...",{|| U_GENA093O(ZZW->ZZW_IDPROD,'3') })
    MsgRun("Processando classes de valor...","Integração",{|| U_GENA093C(ZZW->ZZW_IDPROD,ALLTRIM(ZZL->ZZL_DESC),ZZL->ZZL_COD) })

Return Self