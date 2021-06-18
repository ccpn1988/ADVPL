#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI008   บAutor  ณVinicius Lan็a      บ Data ณ  05/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para importa็ใo de titulos a pagar                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบAltera็ใo ณAutor  ณJoni Fujiyama                  บ Data ณ  02/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina foi adaptada para rodar por schedule.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENI008()

Private cFunName := PROCNAME()

If MsgYesNo("Esta rotina farแ a importa็ใo de Tํtulos a Pagar. Deseja continuar?","Aten็ใo")
	Processa({||Importa()})
EndIf

Return()


//*************************************************************************************************//
// Rotina da execu็ใo por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI008A()

/*
Local lRotMens:=.F.
Prepare Environment Empresa "00" Filial "1001"
RotMens("Executando a rotina ==> " + cFunName,"","")
lRotMens := RotMens("Iniciando o Schedule ...","","")
Importa()
lRotMens := RotMens("Fim do Schedule ...","","")
Reset Environment
*/


Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50  
Private cFunName 	:= nil
Conout("GENI008A - Iniciando Job - integra็ใo contas a pagar - "+Time()+".")

If !lEmp		
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENI008A - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("") 
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENI008A - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())		
	EndIf
EndIF   

While !LockByName("GENI008A",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENI008A - Nใo foi possํvel executar a integra็ใo contas a pagar neste momento pois a fun็ใo GENI008A jแ esta sendo executada por outro processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

cFunName 	:= PROCNAME()
Importa()

If !lEmp .AND. Type('cFilAnt') == "C"
	Conout("GENI008A - Fechando empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())	
	RpcClearEnv()
EndIF

UnLockByName("GENI008A",.T.,.T.,.T.)

Conout("GENI008A - Finalizando Job - integra็ใo contas a pagar - "+Time()+".")

Return()



/*****************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
*****************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTipo)


IF cFunName == "U_GENI008"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
	ENDCASE
ELSE
	IF cFunName == "U_GENI008A"
		Conout(pTexto1)
	ENDIF
ENDIF


Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณImporta   บAutor  ณVinicius Lan็a      บ Data ณ  05/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณResponsavel pelo processamento da rotina                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importa()

Local lErro   	:= .F.
Local nItens  	:= 0
Local cFilBkp 	:= cFilant //Para salvar a filial original
Local cPath   	:= "\logsiga\pagar\"
Local cFile   	:= ""
Local cQuery
Local nTotReg 	:= 0
Local cGrupo	:= ''
Local cPrefix	:= ''
Local cNum		:= ''
Local cParcela	:= ''
Local cTipo		:= ''
Local cCodNat	:= ''
Local cCodFor	:= ''
Local cLojaFor	:= ''
Local cBanco	:= ''
Local cForPgt   := ''
Local __cFilial	:= ''
Local cFilOld	:= cFilAnt
Local _cEmpCd	:= "00"			//Empresa de conexใo
Local _cEmpFl	:= cFilAnt		//Filial de conexใo 

Local _cServ	:= SuperGetmv("GEN_FAT110",.f.,"10.1.0.243")//IP do servidor
Local _nPort	:= SuperGetmv("GEN_FAT111",.f.,1888) //Porta de conexใo do servidor
Local _cAmb		:= SuperGetmv("GEN_FAT112",.f.,"SCHEDULE") //Ambiente do servidor
Local _oServer	:= nil

//U_GenSendMail(,,,"noreply@grupogen.com.br","helimar@grupogen.com.br;danilo.azevedo@grupogen.com.br",oemtoansi("Importa็ใo de Tํtulos a Pagar"),"Usuแrio "+alltrim(UsrFullName(RetCodUsr()))+" estแ executando a rotina de importa็ใo.",,,.F.)

Private lMSHelpAuto := .T. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasQry   := GetNextAlias()
Private aTitulo     := {}

_aDir := directory(Alltrim(cPath)+"*")
For i:=1 to len(_aDir)
	fErase(Alltrim(cPath)+_aDir[i][1])
Next i

lNorm := .T.

cQuery := "SELECT TRIM(E2_FILIAL) E2_FILIAL,TRIM(E2_PREFIXO) E2_PREFIXO,TRIM(E2_NUM) E2_NUM,E2_PARCELA,TRIM(E2_TIPO) E2_TIPO,REPLACE(E2_NATUREZ,'.','') E2_NATUREZ,TRIM(E2_CLIENTE) E2_CLIENTE,E2_LOJA,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALOR,TEM_PIS,TEM_CSLL,TEM_COFINS,TEM_ISS,TEM_IRRF,TRIM(CNPJ_FORNECEDOR) CNPJ_FORNECEDOR,E2_XCODGEN,E2_MOEDA,E2_CONTA,E2_TXMDCOR,E2_RATEIO,E2_ITEMD,E2_CLVLDB,E2_CCD,E2_DIRF,E2_CODRET,E2_NUM_GEN,DEPENDE
cQuery += " FROM TT_I09_TITULOS_A_PAGAR"
cQuery += " ORDER BY CNPJ_FORNECEDOR, E2_CLIENTE"

//RotMens("Query a ser executada ==> " + cQuery,"","")
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)
//Count TO nTotReg// Conta Registro
dbSelectArea(cAliasQry)
dbGoTop()
IF cFunName == "U_GENI008"					// Autor: Joni Fujiyama			Data: 09/07/2014
	ProcRegua(nTotReg) // Numero de registros a processar
ENDIF
nItens:= 0

nTamXCOD	:= TamSx3("A2_XCODOLD")[1]
nTamCGC		:= TamSx3("A2_CGC")[1]
nTamPref	:= TamSx3("E2_PREFIXO")[1]
nTamE2Num	:= TamSx3("E2_NUM")[1]
nTamParc	:= TamSx3("E2_PARCELA")[1]
nTamTipo	:= TamSx3("E2_TIPO")[1]
nTamFili	:= TamSx3("E2_FILIAL")[1]

nValTed := GETMV("MV_XINFPGT")
Do While !(cAliasQry)->(Eof())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nItens++
	//IncProc("Importando tํtulos a pagar... Linha "+cValtoChar(nItens))
	IF cFunName == "U_GENI008"
		IncProc()
	ENDIF
	cCGC		:= padr((cAliasQry)->CNPJ_FORNECEDOR,nTamCGC)
	cCodOld	:= Alltrim((cAliasQry)->E2_CLIENTE)
	
	If !Empty(cCGC) //CGC PREENCHIDO = NACIONAL
		cCodFor	:= POSICIONE("SA2",3,xFilial("SA2")+cCGC,"A2_COD")
		cLojaFor	:= POSICIONE("SA2",3,xFilial("SA2")+cCGC,"A2_LOJA")
		//cBanco   := POSICIONE("SA2",3,xFilial("SA2")+cCGC,"A2_BANCO")
		
		If Empty(cCodFor)
			If !VldCodOld(cCodOld,@cCodFor,@cLojaFor)
				Memowrite(cPath+"\"+dtos(dDatabase)+" - Titulo "+Alltrim(Iif(Empty((cAliasQry)->E2_NUM),SPACE(nTamE2Num),(cAliasQry)->E2_NUM))+" (Fornecedor).log","Cod. Fornecedor GEN: " + alltrim(cCodOld) +" | CNPJ: "+ALLTRIM(cCGC)+" - Nใo Encontrado")
				lErro := .T.
				(cAliasQry)->(DbSkip())
				Loop
			EndIf
			/*
			SA2->(DbOrderNickName("A2_XCODOLD"))						
			If SA2->(DbSeek(xFilial("SA2")+cCodOld))
				cCodFor	:= SA2->A2_COD
				cLojaFor	:= SA2->A2_LOJA
			EndIf
			*/	
			//cCodFor	 := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_COD")
			//cLojaFor := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_LOJA")						
			//cBanco   := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_BANCO")
		EndIf
	Else //CGC EM BRANCO = ESTRANGEIRO
		If !VldCodOld(cCodOld,@cCodFor,@cLojaFor)
			Memowrite(cPath+"\"+dtos(dDatabase)+" - Titulo "+Alltrim(Iif(Empty((cAliasQry)->E2_NUM),SPACE(nTamE2Num),(cAliasQry)->E2_NUM))+" (Fornecedor).log","Cod. Fornecedor GEN: " + alltrim(cCodOld) +" | CNPJ: "+ALLTRIM(cCGC)+" - Nใo Encontrado")
			lErro := .T.
			(cAliasQry)->(DbSkip())
			Loop						
		EndIf
		/*
		SA2->(DbOrderNickName("A2_XCODOLD"))						
		If SA2->(DbSeek(xFilial("SA2")+cCodOld))
			cCodFor	:= SA2->A2_COD
			cLojaFor	:= SA2->A2_LOJA
		EndIf
		*/		
		//cCodFor	 := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_COD")
		//cLojaFor := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_LOJA")
		//cBanco   := POSICIONE("SA2",9,xFilial("SA2")+cCodOld,"A2_BANCO")
	EndIf
	
	cChave := cCGC+cCodOld
	
	Do while cChave = cCGC+cCodOld .and. !(cAliasQry)->(Eof())
		
		//RotMens("Iniciando a importa็ใo dos tํtulos a pagar do fornecedor ... "+cCodFor,"","")
		aTitulo	:= {}
		
		cPrefix	:= Iif(Empty((cAliasQry)->E2_PREFIXO),SPACE(nTamPref),(cAliasQry)->E2_PREFIXO)
		cNum		:= Iif(Empty((cAliasQry)->E2_NUM),SPACE(nTamE2Num),(cAliasQry)->E2_NUM)
		cParcela	:= Iif(Empty((cAliasQry)->E2_PARCELA),SPACE(nTamParc),(cAliasQry)->E2_PARCELA)
		cTipo		:= Iif(Empty((cAliasQry)->E2_TIPO),SPACE(nTamTipo),(cAliasQry)->E2_TIPO)
		cCodNat		:= (cAliasQry)->E2_NATUREZ
		_cFilial	:= (cAliasQry)->E2_FILIAL
		cCodOld     := padr((cAliasQry)->E2_CLIENTE,nTamXCOD)
		cCGC        := padr((cAliasQry)->CNPJ_FORNECEDOR,nTamCGC)

		SA2->(DbSetOrder(1))
		
		If Empty(cCodFor) .OR. !SA2->(DbSeek(XFILIAL("SA2")+cCodFor+cLojaFor))
			Memowrite(cPath+"\"+dtos(dDatabase)+" - Titulo "+Alltrim(cNum)+" (Fornecedor).log","Cod. Fornecedor GEN: " + alltrim(cCodOld) +" | CNPJ: "+ALLTRIM(cCGC)+" - Nใo Encontrado")
			lErro := .T.
		Else
			
			cNomefor	:= SA2->A2_NREDUZ//POSICIONE("SA2",1,XFILIAL("SA2")+cCodFor+cLojaFor,"A2_NREDUZ")
			cBanco		:= SA2->A2_BANCO//POSICIONE("SA2",1,XFILIAL("SA2")+cCodFor+cLojaFor,"A2_BANCO")
			
			cContabil	:= (cAliasQry)->E2_CONTA
			
			If SA2->A2_NUMDEP < (cAliasQry)->DEPENDE
				RecLock("SA2",.F.)
				SA2->A2_NUMDEP	:= (cAliasQry)->DEPENDE
				MsUnLock()
			EndIf
			
			If empty(cBanco) .or. cTipo = "DAE" .or. !lNorm
				cForPgt := "  "
			ElseIf alltrim(cBanco) = '341'
				cForPgt := "01"
			ElseIf (cAliasQry)->E2_VALOR <= nValTed
				cForPgt := "03"
			Else                                               '
				cForPgt := "41"
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ~*ฟ
			//ณPREENCHE COM ESPAวO NECESSARIO PARA FUNCIONAR O DBSEEKณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ~*ู
			_cFilial	:= padr(_cFilial,nTamFili)
			cNum		:= padl(alltrim(cNum),nTamE2Num,"0")
			cPrefix		:= padr(cPrefix,nTamPref)
			cParcela	:= padr(cParcela,nTamParc)
			cTipo		:= padr(cTipo,nTamTipo)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava os campos obtendo os valores da linha lida do arquivo. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			//cFilAnt := _cFilial
			
			DbSelectArea("SE2")
			DbSetOrder(1)
			
			aAdd(aTitulo, {"E2_FILIAL" 	, _cFilial									, Nil})
			aAdd(aTitulo, {"E2_PREFIXO" , cPrefix									, Nil})
			aAdd(aTitulo, {"E2_NUM" 	, cNum 										, Nil})
			aAdd(aTitulo, {"E2_PARCELA" , cParcela									, Nil})
			aUpd := aClone(aTitulo) //Array para exclusao do titulo, caso necessario
			aAdd(aTitulo, {"E2_TIPO" 	, cTipo										, Nil})
			aAdd(aTitulo, {"E2_FORNECE" , cCodFor		   							, Nil})
			aAdd(aTitulo, {"E2_LOJA" 	, cLojaFor					   				, Nil})
			aExcl := aClone(aTitulo) //Array para exclusao do titulo, caso necessario
			aAdd(aTitulo, {"E2_CONTAD"	, cContabil		   		      				, Nil})
			aAdd(aTitulo, {"E2_NATUREZ" , cCodNat		   							, Nil})
			aAdd(aTitulo, {"E2_EMISSAO" , sTod((cAliasQry)->E2_EMISSAO)			, Nil})
			aAdd(aTitulo, {"E2_EMIS1"	, sTod((cAliasQry)->E2_EMISSAO)				, Nil})
			//aAdd(aTitulo, {"E2_VENCTO" 	, sTod((cAliasQry)->E2_VENCTO)				, Nil})
			aAdd(aTitulo, {"E2_VENCTO" 	, DataValida(sTod((cAliasQry)->E2_VENCTO),.F.), Nil})
			//aAdd(aTitulo, {"E2_VENCREA" , DATAVALIDA(sTod((cAliasQry)->E2_VENCREA)) 	, Nil})
			aAdd(aTitulo, {"E2_VALOR" 	, (cAliasQry)->E2_VALOR 					, Nil})
			aAdd(aTitulo, {"E2_MOEDA" 	, (cAliasQry)->E2_MOEDA	     				, Nil})
			aAdd(aTitulo, {"E2_FLUXO" 	, "S"										, Nil})
			aAdd(aTitulo, {"E2_XFORPGT" , cForPgt									, Nil})
			//RODRIGO MOURAO - CAMPOS CRIADOS PARA ATENDER A IMPORTAวรO DOS TITULOS RPA SEM INSS
			aAdd(aTitulo, {"E2_ITEMD"   , (cAliasQry)->E2_ITEMD     				, Nil})
			aAdd(aTitulo, {"E2_CLVLDB" 	, (cAliasQry)->E2_CLVLDB        			, Nil})
			aAdd(aTitulo, {"E2_RATEIO" 	, (cAliasQry)->E2_RATEIO 					, Nil})
			aAdd(aTitulo, {"E2_CCD" 	, (cAliasQry)->E2_CCD       				, Nil})
			//HELIMAR TAVARES - CAMPOS CRIADOS PARA DIRF NA IMPORTAวรO DOS TITULOS RPA SEM INSS	E D.A. NACIONAL
			
			If Len(AllTrim(SA2->A2_CGC)) == 14 // Cleuto - vivaz 36587 - 16/08/2017 - Se pessoa Juridica nใo vai pra DIRF
				aAdd(aTitulo, {"E2_DIRF"    , "2"       							, Nil})
				aAdd(aTitulo, {"E2_CODRET"  , " "									, Nil})
			Else
				aAdd(aTitulo, {"E2_DIRF"    , (cAliasQry)->E2_DIRF       			, Nil})
				aAdd(aTitulo, {"E2_CODRET"  , (cAliasQry)->E2_CODRET        		, Nil})			
			EndIf
			
			aAdd(aTitulo, {"E2_HIST"	, " "												, Nil})
			aAdd(aTitulo, {"E2_XCODGEN" , ALLTRIM((cAliasQry)->E2_XCODGEN)			, Nil})
			aAdd(aTitulo, {"E2_CODRDA" , "EXECAUTO"									, Nil}) //FLAG PARA SABER SE O TITULO FOI IMPORTADO OU INSERIDO MANUALMENTE
						
			/*
			//FORCA CALCULO DE IR - UTILIZADO QUANDO O SISTEMA NAO ESTAVA CALCULANDO CORRETAMENTE
			If cValToChar((cAliasQry)->E2_MOEDA) <> "1"
			//aAdd(aTitulo, {"E2_TXMDCOR"	, (cAliasQry)->E2_TXMDCOR					, Nil})
			If !Empty((cAliasQry)->E2_TXMDCOR)
			nCambio := (cAliasQry)->E2_TXMDCOR
			//Else
			//nCambio := Posicione("SM2",1,sTod((cAliasQry)->E2_EMISSAO),)
			Endif
			aAdd(aTitulo, {"E2_TXMOEDA"	, (cAliasQry)->E2_TXMDCOR					, Nil})
			nPercIR := Posicione("SED",1,xFilial("SED")+cCodNat,"ED_PERCIRF")/100
			aAdd(aTitulo, {"E2_IRRF",(cAliasQry)->E2_VALOR*(cAliasQry)->E2_TXMDCOR*nPercIR,Nil})
			Endif
			*/
			
			aAdd(aUpd, {"E2_VALOR", (cAliasQry)->E2_VALOR , Nil})

			_cEmpCd	:= "00"          		//Empresa de conexใo
			_cEmpFl	:= _cFilial				//Filial de conexใo 
			
			CREATE RPCCONN _oServer ON  SERVER _cServ 			;   //IP do servidor
			PORT  _nPort           								;   //Porta de conexใo do servidor
			ENVIRONMENT _cAmb       							;   //Ambiente do servidor
			EMPRESA _cEmpCd          							;   //Empresa de conexใo
			FILIAL  _cEmpFl          							;   //Filial de conexใo
			TABLES  "SA2,SE2"	;   //Tabela que serใo abertas
			MODULO  "SIGAFIN"               					//M๓dulo de conexใo
				
			If ValType(_oServer) == "O"														
				_oServer:CallProc("RPCSetType", 2)					
				_oServer:CallProc("U_GENI008B",aTitulo,_cFilial,cPrefix,cNum,cParcela,cTipo,cCodFor,cLojaFor,sTod((cAliasQry)->E2_EMISSAO),alltrim((cAliasQry)->E2_NUM_GEN))
 
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณRealizando a nova conexใo para entrafr na empresa e filial corretaณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				//Fecha a Conexao com o Servidor
				RESET ENVIRONMENT IN SERVER _oServer
				CLOSE RPCCONN _oServer
				_oServer := Nil
			EndIf  
							
		
		Endif
		
		(cAliasQry)->(DbSkip())
		cCGC        := padr((cAliasQry)->CNPJ_FORNECEDOR,nTamCGC)
		cCodOld  	:= Alltrim((cAliasQry)->E2_CLIENTE)
	Enddo
EndDo

//cFilAnt	:= cFilOld
If !lErro
	RotMens("Importa็ใo Finalizada com sucesso!","Aviso","2")
Else
	RotMens("Ocorreram erros na importa็ใo. Consulte o log de erro em "+cPath+" e avise o TI.","Aten็ใo","1")
Endif
fErase(cAliasQry)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGENI008   บAutor  ณMicrosiga           บ Data ณ  04/13/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GENI008B(aTitulo,_cFilial,cPrefix,cNum,cParcela,cTipo,cCodFor,cLojaFor,dEmissao,cE2NUMGEN)

Local cPath   	:= "\logsiga\pagar\"
Local cFile   	:= ""
Local cTitulos	:= "<table border='1'>"
Local nQtdTit	:= 0
Local cTo		:= SuperGetMv("GEN_FIN002")
Local cHtml		:= ""
Local cQuebra	:= Chr(13)+Chr(10)


cHtml += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+cQuebra
cHtml += '<html xmlns="http://www.w3.org/1999/xhtml"> '+cQuebra
cHtml += ' <head> '+cQuebra
cHtml += ' <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> '+cQuebra
cHtml += ' <title>Untitled Document</title> '+cQuebra
cHtml += ' </head> '+cQuebra
cHtml += ' <body> '+cQuebra
cHtml += ' <h3>Incluidos titulos para o fornecedor '+AllTrim(Posicione("SA2",1,xFilial("SA2")+cCodFor+cLojaFor,"A2_NOME"))+' com o mesmo vencimento!</h3> '+cQuebra

	DbSelectArea("SE2")
	DbSetOrder(1)	//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	lMsErroAuto := .F.
	lMSHelpAuto	:= .F.
	If !DbSeek(_cFilial+cPrefix+cNum+cParcela+cTipo+cCodFor+cLojaFor)
		dDataOld	:= dDataBase
		dDataBase	:= dEmissao//sTod((cAliasQry)->E2_EMISSAO) //ADICIONADO POR DANILO - 12/12/2013
		MSExecAuto({|x,y| Fina050(x,y)},aTitulo,3)
		cFile := Dtos(dDataBase) + " A - Tํtulo "+Alltrim(cNum)+".log"
		//MostraErro(cpath,cfile)
		dDataBase := dDataOld
		/*
		Else //TITULO EXISTE, DELETA
		MSExecAuto({|x,y,z|Fina050(x,y,z)},aExcl,,5) //EXCLUI O TITULO
		If !lMSErroAuto //INCLUI NOVAMENTE
		dDataOld := dDataBase
		dDataBase := sTod((cAliasQry)->E2_EMISSAO)
		MSExecAuto({|x,y| Fina050(x,y)},aTitulo,3) //INCLUI O TITULO
		cFile := Dtos(dDataBase) + " B - Tํtulo "+Alltrim(cNum)+".log"
		//MostraErro(cpath,cfile)
		dDataBase := dDataOld
		Endif
		*/
	Endif
	
	If lMSErroAuto
		lErro := .T.
		//cFile := Dtos(dDataBase) + " C - Tํtulo "+Alltrim(cNum)+".log"
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Else
		//MSExecAuto({|x,y| Fina050(x,y)},aUpd,4) //FORCA ATUALIZACAO DE VALOR
		//cFile := Dtos(dDataBase) + " C - Tํtulo "+Alltrim(cNum)+".log"
		//MostraErro(cpath,cfile)
		//lMsErroAuto := .F.
		//lMSHelpAuto	:= .F.
		
		//RotMens("FINA050 executado com sucesso ...  " + cNum,"","")
		
		cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL)
		cQueryINS += " VALUES ('TT_I09_TITULOS_A_PAGAR','E2_NUM','"+cE2NUMGEN+"','"+cFilAnt+"')
		TCSqlExec(cQueryINS)
		//RotMens("Feito o INSERT na View TT_I11 ... " + E2_NUM ,"","")
		
		If Select("TMP_TITULO") > 0
			TMP_TITULO->(DbClosearea())
		EndIf
		
		BeginSql Alias "TMP_TITULO"
			SELECT E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_NUM,E2_PREFIXO,E2_VENCTO FROM %Table:SE2% SE2
			WHERE E2_FILIAL = %xFilial:SE2%
			AND E2_FORNECE = %Exp:cCodFor%
			AND E2_LOJA = %Exp:cLojaFor%
			AND E2_VENCTO = %Exp:DtoS(SE2->E2_VENCTO)%
			AND SE2.%NotDel%
		EndSql
		TMP_TITULO->(DbGoTop())
        
		cTitulos	:= "<table border='1'>"
		cTitulos+="<tr>"
			cTitulos+="<td>Fornecedor</td>"
			cTitulos+="<td>Nome</td>"
			cTitulos+="<td>Titulo</td>"
			cTitulos+="<td>Prefixo</td>"
			cTitulos+="<td>Vencimento</td>"
		cTitulos+="</tr>"
					
		While TMP_TITULO->(!EOF())
			nQtdTit++
			
			cTitulos+="<tr>"
				cTitulos+="<td>"+TMP_TITULO->E2_FORNECE+"-"+TMP_TITULO->E2_LOJA+"</td>"
				cTitulos+="<td>"+AllTrim(TMP_TITULO->E2_NOMFOR)+"</td>"				
				cTitulos+="<td>"+TMP_TITULO->E2_NUM+"</td>"
				cTitulos+="<td>"+TMP_TITULO->E2_PREFIXO+"</td>"
				cTitulos+="<td>"+DtoC(StoD(TMP_TITULO->E2_VENCTO))+"</td>"
			cTitulos+="</tr>"
			
			TMP_TITULO->(DbSkip())
		EndDo
		
		cTitulos+="</table>"
		TMP_TITULO->(DbClosearea())
		
		cHtml += cTitulos+cQuebra
		cHtml += '</body> '+cQuebra
		cHtml += '</html>  '+cQuebra
        
		If nQtdTit > 1
			U_GenSendMail(,,,"noreply@grupogen.com.br",cTo,oemtoansi("Inclusao de contas a pagar"),cHtml,,,.F.)
		EndIf	

	EndIf


Return nil

/*

VALIDA FORNECEDOR

*/

Static Function VldCodOld(cCodOld,cCodFor,cLojaFor)

Local lRet	:= .F.

cCodFor	:= ""
cLojaFor	:= ""

If Select("XCODOLD") > 0
	XCODOLD->(DbCloseArea())
EndIf
BeginSql Alias "XCODOLD"
	SELECT A2_COD,A2_LOJA 
	FROM %Table:SA2% SA2
	WHERE A2_FILIAL = %xFilial:SA2%
	AND Trim(A2_XCODOLD) = %Exp:cCodOld%
	AND SA2.%NotDel%				 
EndSql
XCODOLD->(DbGoTop())
If XCODOLD->(!EOF())
	lRet		:= .T.
	cCodFor	:= XCODOLD->A2_COD
	cLojaFor	:= XCODOLD->A2_LOJA
EndIf
XCODOLD->(DbCloseArea())
Return lRet 