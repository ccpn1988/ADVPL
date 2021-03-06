#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

#DEFINE cEnt CHR(13)+CHR(10)

#DEFINE nIniRot	1
#DEFINE nFimRot	2
#DEFINE nIniView	3
#DEFINE nFimView	4

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?GENI017   ?Autor  ?Danilo Azevedo      ? Data ?  28/05/14   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Programa para importacao de produtos                        ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Altera??o ?Autor     ?Joni Fujiyama               ? Data ?  02/07/14   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Rotina foi adaptada para rodar por schedule.                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? GEN                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function GENI017()

Private cFunName := PROCNAME()
If MsgYesNo("Esta rotina far? a importa??o de Produtos. Deseja continuar?","Aten??o")
	Processa({||Importa()})
EndIf

Return()

//*************************************************************************************************//
// Rotina da execu??o por schedule				Autor: Joni Fujiyama			Data:02/07/2014			 //
//*************************************************************************************************//
User Function GENI017A()

Local nX			:= 0
Local lRotMens		:=.F.
Local cDtHrExec		:= ""
Local cEmailTi		:= ""

Private aTempoExec	:= { {nil,nil} , {nil,nil} , {nil,nil} , {nil,nil} }
Private cFunName	:= PROCNAME()

aTempoExec[nIniRot][1]	:= Date()
aTempoExec[nIniRot][2]	:= Time()

RPCSetType(3)
Prepare Environment Empresa "00" Filial "1022" //EXECUTA NA EMPRESA 1022 GEN DEPOSITO SP

Private cTab := GETMV("GEN_FAT064") // "150" - 2015 - PRECO NOVO

//RotMens("Executando a rotina ==> " + cFunName,"","")
lRotMens := RotMens("Iniciando o Schedule...","","")
//cMail := "GENI017 Carga de Produtos - Processo iniciado "+dtoc(MsDate())+" - "+Time() + cEnt + cEnt

While !LockByName("GENI017A",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2     
		Conout("GENI017A - N?o foi poss?vel executar a rotina importa??o de Produtos neste momento pois a fun??o GENI017A j? esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

cDtHrExec	:= DtoC(DDataBase)+" "+AllTrim(Time())

Importa(cDtHrExec)

lRotMens := RotMens("Fim do Schedule...","","")

UnLockByName("GENI017A",.T.,.T.,.T.)

aTempoExec[nFimRot][1]	:= DDataBase
aTempoExec[nFimRot][2]	:= Time()

aTime	:= Separa(ELAPTIME( aTempoExec[nIniRot][2] , aTempoExec[nFimRot][2] ),":")

If Val(aTime[1]) > 0 .OR. Val(aTime[2]) > 30 .OR. aTempoExec[nIniRot][1] <> aTempoExec[nFimRot][1]
	
	cEmailTi	:= SuperGetMv("GEN_MAILTI",.F.,"cleuto.lima@grupogen.com.br")
	
	cMsg := "A rotina de integra??o de Obras levou "+ELAPTIME( aTempoExec[nIniRot][2] , aTempoExec[nFimRot][2] )+" para executar."+cEnt
	cMsg += "Data/Hora inicio da rotina:"+DtoC(aTempoExec[nIniRot][1])+" "+aTempoExec[nIniRot][2]+cEnt
	cMsg += "Data/Hora fim da rotina:"+DtoC(aTempoExec[nFimRot][1])+" "+aTempoExec[nFimRot][2]+cEnt
	cMsg += "Data/Hora inicio da view:"+DtoC(aTempoExec[nIniView][1])+" "+aTempoExec[nIniView][2]+cEnt
	cMsg += "Data/Hora fim da view:"+DtoC(aTempoExec[nFimView][1])+" "+aTempoExec[nFimView][2]+cEnt
		
	U_GenSendMail(,,,"noreply@grupogen.com.br",cEmailTi,Oemtoansi("Integra??o de Obras - Demora na execu??o"),cMsg,,,.F.)
EndIf


Reset Environment


Return()

/**************************************************************************************************
Mostra a mensagem na tela ou no console			Autor: Joni Fujiyama		Data:02/07/2014
**************************************************************************************************/
Static Function RotMens(pTexto1,pTexto2,pTexto3,pTipo)

IF cFunName == "U_GENI017"
	DO CASE
		Case pTipo = "1"
			MSGBOX(pTexto1,pTexto2)
		Case pTipo = "2"
			MSGINFO(pTexto1,pTexto2)
		Case pTipo = "3"
			AVISO(pTexto1,pTexto2,pTexto3)
		Case pTipo = "4"
			ALERTA(pTexto1,pTexto2)
		Case pTipo = "5"
			Return AVISO(pTexto1,pTexto2,pTexto3)
	ENDCASE
ELSE
	IF cFunName == "U_GENI017A"
		Conout(pTexto1)
	ENDIF
ENDIF

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Funcao    ?Importa   ?Autor  ?Danilo Azevedo      ? Data ?  28/05/14   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Responsavel pelo processamento da rotina                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

Static Function Importa(cDtHrExec)

Local lErro   	:= .F.
Local cPath   	:= "\LogSiga\Produtos\"
Local cFile   	:= ""
Local cQuery 		:= Space(0)
Local _cTs			:= GetMv("GENA017TS")
Local _cTsGEN       := GetMv("GEN_FAT169")
Local nTotReg		:= 0               
Local cRegObra	:= ""
Local aImpSV		:= Separa(SuperGetMv("GEN_FAT213",.F.," "),"#")//CODISS#ALIQISS#CNAE#TRIBMUN#POSIPI
Local aImpSVB		:= Separa(SuperGetMv("GEN_FAT212",.F.," "),"#")//PIS#COFINS#CSLL#IRRF                                              
Local cCODISS		:= aImpSV[1] 
Local cALIQISS	:= Val(aImpSV[2])
Local cCNAE		:= aImpSV[3]
Local cTRIBMUN	:= aImpSV[4]
Local cISSEALU  := SuperGetMv("GEN_FAT245",.F.,"0109")   //Cod. ISS RJ para produtos E-ALUGUEL
Local cTRIBEAPF := SuperGetMv("GEN_FAT246",.F.,"010902") //Cod Trib Municipio RJ p/ produtos E-ALUGUEL PF
Local cTRIBEAPJ := SuperGetMv("GEN_FAT247",.F.,"010901") //Cod Trib Municipio RJ p/ produtos E-ALUGUEL PJ
Local cTRIB := ""
Local cISS  := ""
Local cPISIPI		:= aImpSV[5]
Local cUnExp		:= SuperGetMv("GEN_FAT208",.F.," ")
Local cDtHr		:= ""
Local nPeso		:= 0
Local cTpPubSep	:= SuperGetMv("GEN_FAT214",.f.,.f.,"")
			
Local cPIS			:= aImpSVB[1]
Local cConfis		:= aImpSVB[2]
Local cCsll		:= aImpSVB[3]
Local cIrrf		:= aImpSVB[4]
Local nTxPis		:= SuperGetMv("MV_TXPIS",.F.,0)
Local nTxCof		:= SuperGetMv("MV_TXCOFIN",.F.,0)
		
//????????????????????????????????????????Ŀ
//? TRATAMENTO DE AREA, CURSO E DISCIPLINA ?
//??????????????????????????????????????????
If chkfile("SZ6")
	//tcsqlexec("DELETE FROM "+RetSqlName("SZ6")) //DISCIPLINAS
	cAlias := GetNextAlias()
	cQuery := "SELECT D.IDDISCIPLINACRM COD, D.DESCRICAO DESCRI, CD.IDCURSOCRM CURSO
	cQuery += " FROM DBA_EGK.DISCIPLINACRM2 D
	cQuery += " JOIN DBA_EGK.CURSOCRMDISCIPLINACRM2 CD ON D.IDDISCIPLINACRM = CD.IDDISCIPLINACRM
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
	dbSelectArea(cAlias)
	dbGoTop()
	Do While !(cAlias)->(Eof())
		cCod := strzero((cAlias)->COD,tamsx3("Z6_DISCIPLI")[1])
		dbSelectArea("SZ6")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ6")+cCod)
			Reclock("SZ6",.F.)
		Else
			Reclock("SZ6",.T.)
			SZ6->Z6_FILIAL := xFilial("SZ6")
			SZ6->Z6_DISCIPLI := cCod
		Endif
		SZ6->Z6_DESC := alltrim((cAlias)->DESCRI)
		SZ6->Z6_CURSO := strzero((cAlias)->CURSO,tamsx3("Z6_CURSO")[1])
		msUnlock()
		(cAlias)->(dbSkip())
	Enddo
	fErase(cAlias)
Endif

If chkfile("SZ5")
	//tcsqlexec("DELETE FROM "+RetSqlName("SZ5")) //CURSO
	cAlias := GetNextAlias()
	cQuery := "SELECT C.IDCURSOCRM COD, C.DESCRICAO DESCRI, AC.IDAREACRM AREA
	cQuery += " FROM DBA_EGK.CURSOCRM2 C
	cQuery += " JOIN DBA_EGK.AREACRMCURSOCRM2 AC ON C.IDCURSOCRM = AC.IDCURSOCRM"
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
	dbSelectArea(cAlias)
	dbGoTop()
	Do While !(cAlias)->(Eof())
		cCod := strzero((cAlias)->COD,tamsx3("Z5_CURSO")[1])
		dbSelectArea("SZ5")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ5")+cCod)
			Reclock("SZ5",.F.)
		Else
			Reclock("SZ5",.T.)
			SZ5->Z5_FILIAL := xFilial("SZ5")
			SZ5->Z5_CURSO := cCod
		Endif
		SZ5->Z5_DESC := (cAlias)->DESCRI
		SZ5->Z5_AREA := strzero((cAlias)->AREA,tamsx3("Z5_AREA")[1])
		msUnlock()
		(cAlias)->(dbSkip())
	Enddo
	fErase(cAlias)
Endif

If chkfile("SZ7")
	//tcsqlexec("DELETE FROM "+RetSqlName("SZ7")) //AREA
	cAlias := GetNextAlias()
	cQuery := "SELECT IDAREACRM COD, DESCRICAO DESCRI FROM DBA_EGK.AREACRM2"
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
	dbSelectArea(cAlias)
	dbGoTop()
	Do While !(cAlias)->(Eof())
		cCod := strzero((cAlias)->COD,tamsx3("Z7_AREA")[1])
		dbSelectArea("SZ7")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ7")+cCod)
			Reclock("SZ7",.F.)
		Else
			Reclock("SZ7",.T.)
			SZ7->Z7_FILIAL := xFilial("SZ7")
			SZ7->Z7_AREA := cCod
		Endif
		SZ7->Z7_DESC := (cAlias)->DESCRI
		msUnlock()
		(cAlias)->(dbSkip())
	Enddo
	fErase(cAlias)
Endif

Private lMSHelpAuto := .T. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro

cAmbiente := upper(alltrim(GetEnvServer()))

If "TST" $ cAmbiente
	cArqT := "TT_I03_PRODUTO_TB@hmg_dba_egk"
Else
	cArqT := "TT_I03_PRODUTO_TB"	
EndIF 
	
cArqLob := "DBA_EGK.ATUALIZA_TEXTOS_DE_OBRAS"
cTabLob := "TEXTOS_DE_OBRAS"
//TCSPExec(cArqLob) //EXECUTA A PROCEDURE PARA RESGATAR CAMPOS CLOB DA TABELA DE OBRAS NO ORACLE

cQry1 := "SELECT COLUMN_NAME COLUNA FROM ALL_TAB_COLS WHERE OWNER = 'DBA_EGK' and TABLE_NAME = '"+cArqT+"' AND COLUMN_NAME LIKE 'B5_%' ORDER BY INTERNAL_COLUMN_ID"
cAlias1 := Criatrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),cAlias1,.T.)
(cAlias1)->(dbGoTop())
aColunas := {}
Do While (cAlias1)->(!EOF())
	aAdd(aColunas,alltrim((cAlias1)->COLUNA))
	(cAlias1)->(dbSkip())
Enddo
fErase(cAlias1)

Private cAlias := GetNextAlias()
//cQuery := "SELECT * FROM "+cArqT
cQuery := " SELECT TRIM(TO_CHAR (DTHRALT, 'YYYYMMDDHH24MISS')) DTHRALTERA,TB.* FROM DBA_EGK."+cArqT+" TB WHERE UPD = 0 AND ROWNUM <= 200 ORDER BY DTHRALT" 

aTempoExec[nIniView][1]	:= DDataBase
aTempoExec[nIniView][2]	:= Time()

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

aTempoExec[nFimView][1]	:= DDataBase
aTempoExec[nFimView][2]	:= Time()

//Count TO nTotReg// Conta Registro
cRegObra+="Obras retornadas pela view"+CHR(13)+CHR(10)
dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
(cAlias)->(DbEval({|x| nTotReg++,cRegObra+=Strzero((cAlias)->B1_COD,8)+CHR(13)+CHR(10) }))
(cAlias)->(dbGoTop())

MemoWrite(cPath+"RES_VIEW_"+cArqT+"_"+DTOS(DDATABASE)+"_"+STRTRAN(TIME(),":","")+".LOG",cRegObra)

DbSelectArea("DA1")
DbSetOrder(1)
Private cAlias2 := GetNextAlias()
cQuery := "SELECT MAX(DA1_ITEM) ITEM FROM "+RetSqlName("DA1")+" WHERE DA1_CODTAB = '"+cTab+"' AND D_E_L_E_T_ <> '*'"
DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias2, .F., .T.)
cItem := (cAlias2)->ITEM

//CAMPOS MEMO DA TABELA SB5
aMem := {}
aAdd(aMem,{'B5_XDESWEB', '1'})
aAdd(aMem,{'B5_XDIFERE', '2'})
aAdd(aMem,{'B5_XERRATA', '3'})
//aAdd(aMem,{'SERIE', '4'})
aAdd(aMem,{'B5_XSOBAUT', '5'})
aAdd(aMem,{'B5_XSUMARI', '6'})

aSldOrig := {}
cCod := Space(0)
nTamCod := 8
nReg := 0

Do While !(cAlias)->(Eof())
	
	cDtHr	:= (cAlias)->DTHRALTERA
	
	nReg++
	aProduto := {}
	
	//cCod := strzero((cAlias)->B1_COD,nTamCod)
	cCod := strzero((cAlias)->B1_COD,nTamCod)
	Conout("GENI017A - Processando obra "+cCod+" - "+StrZero(nReg,4))
	IF "#"+alltrim((cAlias)->B1_XIDTPPU)+"#" $ cTpPubSep
		nPeso	:= (cAlias)->B1_PESO
	Else
		nPeso	:= 1
	EndIF
	
	/*
	If cCod = strzero((cAlias)->B1_COD,nTamCod) //DESCONSIDERAR REPETIDOS
		(cAlias)->(DbSkip())
		Loop
	Else
		cCod := strzero((cAlias)->B1_COD,nTamCod)
	Endif
	*/
	DbSelectArea("SB1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SB1")+cCod)
		nOpt := 3 //INCLUI
		aAdd(aProduto, {"B1_PESBRU", nPeso	, Nil})
	Else
		nOpt := 4 //ATUALIZA
	Endif

	cLoj := "01"
	If (cAlias)->B1_PROC = 1 //EDITORA GUANABARA KOOGAN LTDA
		cFab := "0380795"
	ElseIf (cAlias)->B1_PROC = 2 //LTC-LIVROS TEC. CIENTIFICOS LTDA
		cFab := "0380796"
	ElseIf (cAlias)->B1_PROC = 4 //GEN - GRUPO EDITORIAL NACIONAL PARTICIPA
		cFab := "378803 "
	ElseIf (cAlias)->B1_PROC = 12 //EDITORA FORENSE LTDA
		cFab := "0380794"
	ElseIf (cAlias)->B1_PROC = 28 //EDITORA FORENSE UNIVERSITARIA LTDA
		cFab := "0380794"
	ElseIf (cAlias)->B1_PROC = 30 //AC FARMACEUTICA LTDA
		cFab := "031811 "
		cLoj := "02"
	ElseIf (cAlias)->B1_PROC = 41 //FORUM
		cFab := "0382982"
	ElseIf (cAlias)->B1_PROC = 42 //ATLAS
		cFab := "0378128"
		cLoj := "07"
	Else
		cFab := Space(0)
	Endif

	aAdd(aProduto, {"B1_COD"		, cCod									, Nil})
	aAdd(aProduto, {"B1_DESC"	, alltrim((cAlias)->B1_DESC)				, Nil})
	aAdd(aProduto, {"B1_TIPO"	, alltrim((cAlias)->B1_TIPO)				, Nil})
	aAdd(aProduto, {"B1_UM"		, alltrim((cAlias)->B1_UM)					, Nil})
	aAdd(aProduto, {"B1_LOCPAD"	, alltrim((cAlias)->B1_LOCPAD)				, Nil})
	aAdd(aProduto, {"B1_GRUPO"	, cValToChar((cAlias)->B1_GRUPO)			, Nil})
	aAdd(aProduto, {"B1_ORIGEM"	, alltrim((cAlias)->B1_ORIGEM)				, Nil})
	
	If !Empty(alltrim((cAlias)->B1_MSBLQL))
		aAdd(aProduto, {"B1_MSBLQL"	, alltrim((cAlias)->B1_MSBLQL)			, Nil})
	else
		aAdd(aProduto, {"B1_MSBLQL"	, "1"									, Nil})	
	endIf	
	
	aAdd(aProduto, {"B1_CODBAR"	, substr(alltrim((cAlias)->B1_CODBAR),1,13), Nil})
	aAdd(aProduto, {"B1_ISBN"	, alltrim((cAlias)->B1_ISBN)				, Nil})
	aAdd(aProduto, {"B1_XSITOBR", alltrim((cAlias)->B1_XSITOBR)				, Nil})
	aAdd(aProduto, {"B1_XEMPRES", alltrim((cAlias)->B1_XEMPRES)				, Nil})
	aAdd(aProduto, {"B1_XIDMAE"	, strzero((cAlias)->B1_XIDMAE,nTamCod)		, Nil})
	aAdd(aProduto, {"B1_XIDTPPU", alltrim((cAlias)->B1_XIDTPPU)				, Nil})
	aAdd(aProduto, {"B1_XPERCRM", alltrim((cAlias)->B1_XPERCRM)				, Nil})
	aAdd(aProduto, {"B1_XPSITEG", alltrim((cAlias)->B1_XPSITEG)				, Nil})
	aAdd(aProduto, {"B1_CC"		, (cAlias)->B1_CC								, Nil})
	aAdd(aProduto, {"B1_XCC"		, (cAlias)->B1_XCC							, Nil})
	If AllTrim(cFab) = "378803" //Inclu?da condi??o para alterar TES padr?o das obras GEN [Bruno Parreira,28/08/2019]
		aAdd(aProduto, {"B1_TS"		, _cTsGEN											, Nil}) //TES DE SAIDA = VENDA 	
	else
		aAdd(aProduto, {"B1_TS"		, _cTs											, Nil}) //TES DE SAIDA = VENDA 
	EndIf
	aAdd(aProduto, {"B1_PESO"	, nPeso										, Nil})
	aAdd(aProduto, {"B1_PESBRU"	, nPeso 										, Nil})
	
	//??????????????????????????????????????????????Ŀ
	//?Cleuto Lima - 24/02/2016                      ?
	//?                                              ?
	//?incluido tratamento para produtos tipo Servi?o?
	//????????????????????????????????????????????????
	If (cAlias)->B1_TIPO $ "SV#"
		If alltrim((cAlias)->B1_XIDTPPU) = '28'
			cTRIB := cTRIBEAPF
			cISS  := cISSEALU 
		Else
			cTRIB := cTRIBMUN
			cISS  := cCODISS
		EndIf
		
		aAdd(aProduto, {"B1_CODISS"		, cISS 		, Nil	})
		aAdd(aProduto, {"B1_ALIQISS"	, cALIQISS	, Nil 	})
		aAdd(aProduto, {"B1_CNAE"		, cCNAE 	, Nil	})
		aAdd(aProduto, {"B1_TRIBMUN"	, cTRIB		, Nil	})
		aAdd(aProduto, {"B1_POSIPI"		, cPISIPI	, Nil	})			
		aAdd(aProduto, {"B1_PIS"		, cPIS		, Nil	})
		aAdd(aProduto, {"B1_COFINS"		, cConfis	, Nil	})
		aAdd(aProduto, {"B1_CSLL"		, cCsll		, Nil	})
		aAdd(aProduto, {"B1_IRRF"		, cIrrf		, Nil	})
		
		aAdd(aProduto, {"B1_PPIS"		, nTxPis	, Nil	})
		aAdd(aProduto, {"B1_PCOFINS"	, nTxCof	, Nil	})
		
	Else
		aAdd(aProduto, {"B1_POSIPI"		, alltrim((cAlias)->B1_POSIPI)	, Nil})	
	EndIF

	aAdd(aProduto, {"B1_TNATREC"	, "4313" 						, Nil})
	aAdd(aProduto, {"B1_CNATREC"	, "903" 						, Nil})
	
	aAdd(aProduto, {"B1_PROC", cFab, Nil}) //FORNECEDOR PADRAO
	aAdd(aProduto, {"B1_LOJPROC", cLoj, Nil}) //LOJA FORNECEDOR PADRAO	

	MSExecAuto({|x,y| Mata010(x,y)},aProduto,nOpt)
	
	If lMSErroAuto
		lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+".log"
		
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Else //ERRO NA SB1 IMPEDE O RESTANTE
		
		cIdProd := cValToChar((cAlias)->B1_COD) //CODIGO DO PRODUTO PARA GRAVAR NA FLAGVIEW
		
		DbSelectArea("SB5")
		DbSetOrder(1)
		If !DbSeek(xFilial("SB5")+cCod)
			nOpt := 3 //INCLUI
		Else
			nOpt := 4 //ATUALIZA
		Endif
		aSB5 := {}
		aAdd(aSB5,{"B5_FILIAL", xFilial("SB5"), Nil})
		aAdd(aSB5,{"B5_COD", cCod, Nil})
				
		For i := 1 to len(aColunas)
			lIgual := .T.
			If SB5->(FieldPos(aColunas[i])) > 0 //SE O CAMPO EXISTIR NA SB5
				
				If nOpt == 4 .AND. "B5_XCONSIG" == AllTrim(aColunas[i])
					Loop
				EndIf
				
				//VERIFICA INCONSISTENCIA DE TIPOS DE DADOS, CONVERTE E GRAVA NA TABELA
				cTipoDic := valtype(&("SB5->"+aColunas[i]))
				cTipoTab := valtype(&("(cAlias)->"+aColunas[i]))
				If cTipoDic <> cTipoTab
					If cTipoDic = "C" //DICIONARIO = CARACTER
						If cTipoTab = "N" //VIEW = NUMERO
							aAdd(aSB5,{aColunas[i], cValToChar(&("(cAlias)->"+aColunas[i])), Nil})
						Endif
					ElseIf cTipoDic = "D" //DICIONARIO = DATA
						If cTipoTab = "C" //VIEW = CARACTER
							If At("/",&("(cAlias)->"+aColunas[i])) > 0 //SE TIVER SEPARADOR DE DATA
								aAdd(aSB5,{aColunas[i], CTOD(&("(cAlias)->"+aColunas[i])), Nil})
							Else
								aAdd(aSB5,{aColunas[i], STOD(&("(cAlias)->"+aColunas[i])), Nil})
							Endif
						Endif
					ElseIf cTipoDic = "N" //DICIONARIO = NUMERO
						If cTipoTab = "C" //VIEW = CARACTER
							aAdd(aSB5,{aColunas[i], val(&("(cAlias)->"+aColunas[i])), Nil})
						Endif
					Endif
				Else
					If cTipoDic == "C"
						aAdd(aSB5,{aColunas[i], SubStr(alltrim(&("(cAlias)->"+aColunas[i])),1,tamsx3(aColunas[i])[1]), Nil})
					Else
						aAdd(aSB5,{aColunas[i], alltrim(&("(cAlias)->"+aColunas[i])), Nil})
					EndIf	
				Endif
			Endif
		Next i

//		ALTERADO POR HELIMAR TAVARES - 14/12/2015 AS OBRAS AGORA EST?O NO MAKER COM OS CAMPOS MEMO
//		If (cAlias)->B1_PROC <> 42 //ATLAS NAO TEM CAMPO MEMO A PARTE
		For x := 1 to len(aMem) //GRAVA OS CAMPOS MEMO, QUE ERAM ORIGINALMENTE CLOB NO ORACLE LEGADO
			cQry := "SELECT * FROM "+cTabLob
			cQry += " WHERE IDOBRA = "+alltrim(cCod)+" AND LINHA <> ' ' AND TIPOCAMPO = '"+aMem[x][2]+"'
			cQry += " ORDER BY IDOBRA, NUMLINHA
			Private cAliasM := GetNextAlias()
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), cAliasM, .F., .T.)
			cMemo := Space(0)
			Do While !(cAliasM)->(EOF())
				cMemo += (cAliasM)->LINHA
				(cAliasM)->(dbSkip())
			Enddo
			dbCloseArea(cAliasM)
			fErase(cAliasM)
			cMemo := alltrim(cMemo)
			If !Empty(cMemo)
				aAdd(aSB5,{aMem[x][1],cMemo, Nil})
			Endif
		Next x
/*	
		Else
			tcSqlExec("UPDATE APP_ATLAS.PRODUTOS SET UPLOAD = ' ' WHERE B1_COD = '"+cValToChar((cAlias)->B1_COD)+"' AND UPLOAD = '*'")
		Endif
*/		
		//ADICIONADO POR DANILO AZEVEDO PARA PERMITIR A EXECUCAO DO CADASTRO DE COMPLEMENTO DO PRODUTO - 13/10/2015
		cBlq := SB1->B1_MSBLQL
		nRec := SB1->(RECNO())
		If cBlq <> '2'
			tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_MSBLQL = '2' WHERE B1_COD = '"+cCod+"' AND D_E_L_E_T_ = ' '")
			SB1->(dbGoTo(nRec))
		Endif

		// Cleuto -  17/09/2018 - incluida segunda unidade de medida para notas fiscais de exporta??o.
		aAdd(aSB5,{"B5_UMDIPI",	cUnExp, Nil})
		
		IF "#"+alltrim((cAlias)->B1_XIDTPPU)+"#" $ cTpPubSep
			aAdd(aSB5,{"B5_CONVDIP",	nPeso, Nil})
		Else
			aAdd(aSB5,{"B5_CONVDIP",	1, Nil})		
		EndIF	
				
		MSExecAuto({|x,y| Mata180(x,y)},aSB5,nOpt)
		
		//ADICIONADO POR DANILO AZEVEDO PARA PERMITIR A EXECUCAO DO CADASTRO DE COMPLEMENTO DO PRODUTO - 13/10/2015
		tcSqlExec("UPDATE "+RetSqlName("SB1")+" SET B1_MSBLQL = '"+cBlq+"' WHERE B1_COD = '"+cCod+"' AND D_E_L_E_T_ = ' '")
		SB1->(dbGoTo(nRec))
		
		//ERRO NA SB5 GERA LOG MAS NAO IMPEDE O RESTANTE
		If lMSErroAuto
			lErro := .T.
			cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (complemento).log"
			MostraErro(cpath,cfile)
			lMsErroAuto := .F.
			lMSHelpAuto	:= .F.
		Else
			Begin transaction
				cQueryINS := " UPDATE DBA_EGK.TT_I03_PRODUTO_TB SET UPD = 1 WHERE B1_COD = '"+cCod+"' AND UPD = 0 AND TRIM(TO_CHAR (DTHRALT, 'YYYYMMDDHH24MISS')) <= '"+cDtHr+"' "
				tcSqlExec(cQueryINS)
			End transaction	
		Endif
		
		If cBlq <> '1'
			dbSelectArea("DA1")
			dbSetOrder(1)
			nPrc := (cAlias)->PRECO
			If nPrc > 0
				If !dbSeek(xFilial("DA1")+cTab+cCod) //SE ENCONTRAR, ATUALIZA SOMENTE O PRECO
					cItem := Soma1(cItem)
					Reclock("DA1",.T.)
					DA1->DA1_FILIAL := xFilial("DA1")
					DA1->DA1_ITEM := cItem
					DA1->DA1_CODTAB := cTab
					DA1->DA1_CODPRO := cCod
				Else
					Reclock("DA1",.F.)
				Endif
				DA1->DA1_PRCVEN := nPrc
				DA1->DA1_ATIVO := "1"
				DA1->DA1_TPOPER := "4"
				DA1->DA1_QTDLOT := 999999.99
				DA1->DA1_INDLOT := "000000000999999.99"
				msUnlock()
				
				If !dbSeek(xFilial("DA1")+cTab+cCod)
					cFile := "Produto "+Alltrim(cCod)+" (tab.preco).log"
					MemoWrite(cPath+cFile,"Falha ao gravar na tabela DA1 (Pre?o)")
				Endif
			Endif
			

			//CARREGA SALDO INICIAL - TABELA SB9 - EMPRESA ORIGEM
			cFiliOrig := alltrim((cAlias)->EMPORIG)
//			If !(cFiliOrig $ "0000-9022") //ALTERADO POR DANILO AZEVEDO - 21/08/2015 PARA NAO GERAR SALDO ORIGEM ATLAS
			If !(cFiliOrig $ "0000")//ALTERADO POR HELIMAR TAVARES - 14/12/2015 PARA GERAR SALDO ORIGEM ATLAS, POIS AS OBRAS AGORA EST?O NO MAKER
				cFilAnt := cFiliOrig
				cProd := Padr(cCod,tamsx3("B9_COD")[1]," ")
				dbSelectArea("SB9")
				dbSetOrder(1)
				If !dbSeek(xFilial("SB9")+cProd+"01") //SE NAO ENCONTRAR, GERA SALDO INICIAL
					nOp := 3
					aSldIni  := {}
					aAdd(aSldIni  ,{"B9_COD",cCod,Nil})
					aAdd(aSldIni  ,{"B9_LOCAL","01",Nil})
					aAdd(aSldIni  ,{"B9_QINI",Iif((cAlias)->BOM+(cAlias)->CONSIGNACAO > 0, (cAlias)->BOM+(cAlias)->CONSIGNACAO,0),Nil})
					MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,nOp)
					cFilAnt := "1022"
					If lMSErroAuto
						lErro := .T.
						cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (saldo origem).log"
						MostraErro(cpath,cfile)
						lMsErroAuto := .F.
						lMSHelpAuto	:= .F.
					Endif
				Endif
				cFilAnt := "1022"
			Endif
			
				//CARREGA SALDO INICIAL ZERADO - TABELA SB9 - GEN
				cProd := Padr(cCod,tamsx3("B9_COD")[1]," ")
				nQt := 0
				For nAmz := 1 to 5
					cLoc := strzero(nAmz,2)
					dbSelectArea("SB9")
					dbSetOrder(1)
					If !dbSeek(xFilial("SB9")+cProd+cLoc) .and. !Empty(cProd) .and. !Empty(cLoc) //SE NAO ENCONTRAR, GERA SALDO INICIAL
						nOp := 3
						aSldIni  := {}
						aAdd(aSldIni  ,{"B9_COD",cCod,Nil})
						aAdd(aSldIni  ,{"B9_LOCAL",cLoc,Nil})
						aAdd(aSldIni  ,{"B9_QINI",nQt,Nil})
						MsExecAuto({|x,y,z|MATA220(x,y,z)},aSldIni,nOp)
						If lMSErroAuto
							lErro := .T.
							cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+" (saldo GEN).log"
							MostraErro(cpath,cfile)
							lMsErroAuto := .F.
							lMSHelpAuto	:= .F.
							(cAlias)->(DbSkip())
							Loop
						Endif
						nQt := 0
					Endif
				Next nAmz
		Endif
	Endif
	
	(cAlias)->(DbSkip())
EndDo

//cMail += "Processados "+cValToChar(nReg)+" itens."+ cEnt + cEnt
//cMail += "GENI017 Carga de Produtos - Processo finalizado "+dtoc(MsDate())+" - "+Time() + cEnt + cEnt
//U_GenSendMail(,,,"noreply@grupogen.com.br","danilo.azevedo@grupogen.com.br;rodrigo.mourao@grupogen.com.br",oemtoansi("Protheus - Cadastro de Produtos"),cMail,,,.F.)

If !lErro
	RotMens("Importa??o Finalizada com sucesso!","Aviso","2")
Else
	RotMens("Ocorreram erros na importa??o. Consulte o log de erro em "+cPath+".","Aten??o","1")
Endif

//RODRIGO MOURAO - Altera??o para gravar apenas a data e hora da execu??o da rotina.
//???????????????????????????????????????????????????????
//?GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO?
//???????????????????????????????????????????????????????
//cQueryINS := "INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL,DATAHORAINCLUSAO) "
//cQueryINS += " VALUES ('"+cArqT+"','B1_COD','9999','    ',TO_DATE('"+cDtHrExec+"', 'DD/MM/RRRR HH24:MI:SS'))" //18/07/2012 13:27:18
//TCSqlExec(cQueryINS)

fErase(cAlias)

Return()
