#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI010   ºAutor  ³Helimar Tavares     º Data ³  21/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para importação de titulos a pagar InterCia        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI010

If Aviso("Atenção", "Esta rotina fará a importação de Títulos a Pagar InterCompany. Deseja continuar ?", {"Sim", "Nao"}) == 1
	Processa ( {  ||  Importa() } )
EndIf

Return


//*************************************************************************************************//
Static Function Importa
//*************************************************************************************************//

Local lErro   	:= .F.
Local nItens  	:= 0
Local cFilBkp 	:= cFilant //Para salvar a filial original
Local cPath   	:= "\LogSiga\pagarintercia\"
Local cFile   	:= ""
Local cQuery
Local nTotReg 	:= 0
Local cGrupo	:= ''
Local lFind	    := .F.
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

Private cPerg       := 'GENI10'
Private lAchou      := .F.
Private lMSHelpAuto := .T. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro
Private cAliasQry   := GetNextAlias()
Private aTitulo     := {}

IF cFunName == "U_GENI010A"

	mv_par01 := dDataBase
	mv_par02 := dDataBase

ELSE 

	PutSx1(cPerg,"01","Data inicial"    ,"","","mv_ch1","D",08,0,0,"G","","   ","","","mv_par01" , ""    ,""     ,""       ,"","","","","","","" )
	PutSx1(cPerg,"02","Data final"      ,"","","mv_ch2","D",08,0,0,"G","","   ","","","mv_par02" , ""    ,""     ,""       ,"","","","","","","" )
	                              
	If !Pergunte(cPerg,.T.)
		return
	endif
	
ENDIF	

//cQuery := "SELECT * from TT_I10_TITULOS_PAGAR_INTERCIA@TOTVS_LINK //ALTERADO EM 18/01/2014 - DANILO AZEVEDO
cQuery := "SELECT * FROM TT_I10_TITULOS_PAGAR_INTERCIA
cQuery += " WHERE E2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'
cQuery += " ORDER BY E2_FILIAL, E2_NUM

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAliasQry, .F., .T.)

Count TO nTotReg// Conta Registro
dbSelectArea(cAliasQry)
dbGoTop()

ProcRegua(nTotReg) // Numero de registros a processar

nItens:= 0

While !(cAliasQry)->(Eof())
	aTitulo	:= {}
	                                                                  
	cPrefix	    := Iif(Empty(AllTrim((cAliasQry)->E2_PREFIXO)),SPACE(TamSx3("E2_PREFIXO")[1]),AllTrim((cAliasQry)->E2_PREFIXO))
	cNum		:= Iif(Empty(AllTrim((cAliasQry)->E2_NUM)),SPACE(TamSx3("E2_NUM")[1]),AllTrim((cAliasQry)->E2_NUM))
	cParcela	:= Iif(Empty(AllTrim((cAliasQry)->E2_PARCELA)),SPACE(TamSx3("E2_PARCELA")[1]),AllTrim((cAliasQry)->E2_PARCELA))
	cTipo		:= Iif(Empty(AllTrim((cAliasQry)->E2_TIPO)),SPACE(TamSx3("E2_TIPO")[1]),AllTrim((cAliasQry)->E2_TIPO))
	cCodNat		:= StrTRan((cAliasQry)->E2_NATUREZ,'.','')
	_cFilial	:= Alltrim((cAliasQry)->E2_FILIAL)
	cCGC        := Alltrim((cAliasQry)->CNPJ_FORNECEDOR)
	cCodFor		:= Alltrim((cAliasQry)->E2_FORNECE)
	cCGC        := padr(cCGC,TamSx3("A2_CGC")[1])
	
	nItens++
	lAchou := .F.
	
	If alltrim(cCodFor) = ''
		Memowrite(cPath+"\"+Dtos(dDataBase) + " - Título "+Alltrim(cNum)+".log","Cod. Fornecedor GEN: " + cCodOld +" | CNPJ: "+ALLTRIM(cCGC)+" - Não Encontrado")
		lErro := .T.
	Else
		cContabil	:= (cAliasQry)->E2_CONTA
		cLojaFor 	:= POSICIONE("SA2",1,xFilial("SA2")+cCodFor,"A2_LOJA")
		cNomefor	:= POSICIONE("SA2",1,xFilial("SA2")+cCodFor+cLojaFor,"A2_NREDUZ")
		cBanco   	:= POSICIONE("SA2",1,xFilial("SA2")+cCGC,"A2_BANCO")
		
		If empty(cBanco)
			cForPgt := "  "
		ElseIf alltrim(cBanco) = '341'
			cForPgt := "01"
		ElseIf (cAliasQry)->E2_VALOR <= 1000
			cForPgt := "03"
		Else
			cForPgt := "41"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa a regua                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		IncProc("Importando titulos a pagar...  Linha "+cValtoChar(nItens))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ~*¿
		//³PREENCHE COM ESPAÇO NECESSARIO PARA FUNCIONAR O DBSEEK³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ~*Ù
		_cFilial	:= padr(_cFilial,TamSx3("E2_FILIAL")[1])
		cNum		:= padr(cNum,TamSx3("E2_NUM")[1])
		cPrefix		:= padr(cPrefix,TamSx3("E2_PREFIXO")[1])
		cParcela	:= padr(cParcela,TamSx3("E2_PARCELA")[1])
		cTipo		:= padr(cTipo,TamSx3("E2_TIPO")[1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os campos obtendo os valores da linha lida do arquivo. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilAnt := _cFilial
		
		DbSelectArea("SE2")
		DbSetOrder(1)
		lFind := DbSeek(ALLTRIM(_cFilial+cPrefix+cNum+cParcela+cTipo+cCodFor+cLojaFor))
		
		aAdd(aTitulo, {"E2_FILIAL" 	, _cFilial									, Nil})
		aAdd(aTitulo, {"E2_PREFIXO" , cPrefix									, Nil})
		aAdd(aTitulo, {"E2_NUM" 	, cNum 										, Nil})
		aAdd(aTitulo, {"E2_PARCELA" , cParcela									, Nil})
		aAdd(aTitulo, {"E2_TIPO" 	, cTipo										, Nil})
		aAdd(aTitulo, {"E2_CONTAD"	, cContabil		   		      				, Nil})
		aAdd(aTitulo, {"E2_NATUREZ" , cCodNat		   							, Nil})
		aAdd(aTitulo, {"E2_FORNECE" , cCodFor		   							, Nil})
		aAdd(aTitulo, {"E2_LOJA" 	, cLojaFor					   				, Nil})
		aAdd(aTitulo, {"E2_EMISSAO" , sTod((cAliasQry)->E2_EMISSAO)			, Nil})
		aAdd(aTitulo, {"E2_EMIS1"	, sTod((cAliasQry)->E2_EMISSAO)				, Nil})
		aAdd(aTitulo, {"E2_VENCTO" 	, sTod((cAliasQry)->E2_VENCTO)				, Nil})
		aAdd(aTitulo, {"E2_VENCREA" , DATAVALIDA(sTod((cAliasQry)->E2_VENCREA)) 	, Nil})
		aAdd(aTitulo, {"E2_VALOR" 	, (cAliasQry)->E2_VALOR 					, Nil})
		aAdd(aTitulo, {"E2_MOEDA" 	, (cAliasQry)->E2_MOEDA	     				, Nil})
		aAdd(aTitulo, {"E2_FLUXO" 	, "S"										, Nil})
		aAdd(aTitulo, {"E2_XFORPGT" , cForPgt                                   , Nil})
		//RODRIGO MOURAO - CAMPOS CRIADOS PARA ATENDER A IMPORTAÇÃO DOS TITULOS RPA SEM INSS
		aAdd(aTitulo, {"E2_ITEMD"   , (cAliasQry)->E2_ITEMD     				, Nil})
		aAdd(aTitulo, {"E2_CLVLDB" 	, (cAliasQry)->E2_CLVLDB        			, Nil})
		aAdd(aTitulo, {"E2_RATEIO" 	, (cAliasQry)->E2_RATEIO 					, Nil})
		aAdd(aTitulo, {"E2_CCD" 	, (cAliasQry)->E2_CCD       				, Nil})
		//HELIMAR TAVARES - CAMPOS CRIADOS PARA DIRF NA IMPORTAÇÃO DOS TITULOS RPA SEM INSS	E D.A. NACIONAL
		aAdd(aTitulo, {"E2_DIRF"    , (cAliasQry)->E2_DIRF       				, Nil})
		aAdd(aTitulo, {"E2_CODRET"  , (cAliasQry)->E2_CODRET        			, Nil})
		aAdd(aTitulo, {"E2_HIST"	, " "										, Nil})
		aAdd(aTitulo, {"E2_XCODGEN" , ALLTRIM((cAliasQry)->E2_XCODGEN)			, Nil})
		//Taxa fixa para importação de titulos de DA
		aAdd(aTitulo, {"E2_TXMDCOR"	, (cAliasQry)->E2_TXMDCOR					, Nil})
		
		DbSelectArea("SE2")
		DbSetOrder(1)
		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		If !DbSeek(_cFilial+cPrefix+cNum+cParcela+cTipo+cCodFor+cLojaFor)
			MSExecAuto({|x,y| Fina050(x,y)},aTitulo,3)
		Endif
		
		If lMSErroAuto
			lErro := .T.
			cFile := Dtos(dDataBase) + " - Título "+Alltrim(cNum)+".log"
			
			MostraErro(cpath, cfile)
			lMsErroAuto := .F.
			lMSHelpAuto	:= .F.
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄë¿
		//³GRAVA NA VIEW 'TT_I11_FLAG_VIEW' O REGISTRO IMPORTADO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄëÙ
		If !lMsErroAuto
			_cChave := alltrim((cAliasQry)->E2_FILIAL)+alltrim((cAliasQry)->E2_PREFIXO)+alltrim((cAliasQry)->E2_NUM)+alltrim((cAliasQry)->E2_PARCELA)+alltrim((cAliasQry)->E2_TIPO)+alltrim((cAliasQry)->E2_FORNECE)
//			cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW@TOTVS_LINK (VIEW_NAME,CHAVE,VALOR,FILIAL) "
			cQueryINS := " INSERT INTO TT_I11_FLAG_VIEW (VIEW_NAME,CHAVE,VALOR,FILIAL) "
			cQueryINS += " VALUES ('TT_I10_TITULOS_PAGAR_INTERCIA','E2_NUM','"+alltrim((cAliasQry)->E2_NUM_GEN)+"','"+ALLTRIM((cAliasQry)->E2_FILIAL)+"') "
//			TCSqlExec( cQueryINS )
		EndIf
	Endif
	
	DbSelectARea(cAliasQry)
	DbSkip()
EndDo

//*******************************************//
//Fecha conexão com o Banco de Produção
//TcUnLink(nCon)
//*******************************************//
cFilAnt	:= cFilOld

If !lErro
	MsgInfo("Importação Finalizada com Sucesso!","Aviso")
else
	MsgBox("Ocorreram erros na importação! Consulte o log de erro em \logsiga\pagarintercia\ e avise o TI.","Atenção")
endif

fErase(cAliasQry)

Return()
