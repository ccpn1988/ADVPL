/* ===
    Esse � um exemplo disponibilizado no Terminal de Informa��o
    Confira o artigo sobre esse assunto, no seguinte link: https://terminaldeinformacao.com/2017/04/11/funcao-sobrepoe-conteudo-da-sx3-atraves-de-um-dbf-dtc/
    Caso queira ver outros conte�dos envolvendo AdvPL e TL++, veja em: https://terminaldeinformacao.com/advpl/
=== */

//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zRepSX3
Fun��o que d� replace em campos da SX3, conforme arquivo de origem
@author Atilio
@since 11/11/2016
@version 1.0
@type function
@example U_zRepSX3("\x_pasta\sx3_orig.dbf", "SA1", "X3_RELACAO;X3_FOLDER")
/*/

User Function zRepSX3(cArquiPar, cAliasPar, cCamposPar)
	Local aArea        := GetArea()
	Default cArquiPar  := ""
	Default cAliasPar  := ""
	Default cCamposPar := ""
	Private lAuto      := .F.
	Private cPerg      := "X_ZREPSX3"
	Private cArquiAux  := ""
	Private cAliasAux  := ""
	Private cCamposAux := ""
	
	//Cria / Atualiza o Grupo de Perguntas
	fValidPerg()
	
	//Se veio dados do parâmetro, ser� de forma autom�tica
	If !Empty(cArquiPar) .And. !Empty(cAliasPar) .And. !Empty(cCamposPar)
		cArquiAux  := cArquiPar
		cAliasAux  := cAliasPar
		cCamposAux := cCamposPar
		lAuto      := .T.
		
		Processa({|| fAtualiza()}, 'Atualizando')
		
	Else
		//Se a Pergunta for Confirmada, chama a atualiza��o
		If Pergunte(cPerg, .T.)
			cArquiAux  := MV_PAR01
			cAliasAux  := MV_PAR02
			cCamposAux := MV_PAR03
			
			//Se estiver algum campo em branco, aborta
			If Empty(cArquiAux) .Or. Empty(cAliasAux) .Or. Empty(cCamposAux)
				MsgAlert("Existe(m) parâmetro(s) em branco.", "Aten��o")
			Else
				Processa({|| fAtualiza()}, 'Atualizando')
			EndIf
		EndIf
	EndIf
	
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fValidPerg                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  11/11/2016                                                   |
 | Desc:  Fun��o para criar o grupo de perguntas                       |
 *---------------------------------------------------------------------*/

Static Function fAtualiza()
	Local aArea     := GetArea()
	Local aAreaX3   := SX3->(GetArea())
	Local aStruX3   := SX3->(DbStruct())
	Local aCampVer  := StrTokArr(Alltrim(cCamposAux), ';')
	Local aCampos   := {}
	Local nAtual    := 0
	Local cAliasTmp := "SX3_TMP"
	Local cArqTmp   := ""
	Local cIndTmp   := ""
	Local cLogAux   := ""
	Local xContOld  := Nil
	Local xContNew  := Nil
	Local nTotal    := 0
	Local cDirLog   := "\x_log_sx3\"
	
	//Verifica na DbStruct, se esses campos realmente existem
	For nAtual := 1 To Len(aCampVer)
		//Se encontrou o campo no Dicion�rio
		If aScan(aStruX3, {|x| Alltrim(x[1]) == Alltrim(aCampVer[nAtual])}) > 0
			aAdd(aCampos, aCampVer[nAtual])
		EndIf
	Next
	
	//Caso n�o existam, retorna
	If Len(aCampVer) == 0
		MsgAlert("Campos da SX3 n�o encontrados!", "Aten��o")
		Return
	EndIf
	
	//Se o arquivo n�o existir, retorna
	If !File(cArquiAux)
		MsgAlert("Arquivo de dados n�o encontrado!", "Aten��o")
		Return
	EndIf
	
	//Abre o arquivo como uma tempor�ria, cria um índice por campo e filtra a tabela
	DbUseArea(.T., "DBFCDX", cArquiAux, cAliasTmp, .T., .F.)
	cArqTmp := CriaTrab(Nil, .F.)
	cIndTmp := "X3_CAMPO"
	IndRegua(cAliasTmp, cArqTmp, cIndTmp, , , "Criando Indice temporario...")
	If cAliasAux != '*'
		(cAliasTmp)->(DbSetFilter({|| X3_ARQUIVO == cAliasAux }, "X3_ARQUIVO == '"+cAliasAux+"'"))
	EndIf
	
	//Filtra o Dicion�rio
	DbSelectArea('SX3')
	If cAliasAux != '*'
		SX3->(DbSetFilter({|| X3_ARQUIVO == cAliasAux }, "X3_ARQUIVO == '"+cAliasAux+"'"))
	EndIf
	
	//Inicia controle de transa��o
	Begin Transaction
		//Seta a Regua
		SX3->(DbGoTop())
		Count To nTotal
		ProcRegua(nTotal)
		
		//Percorre o Dicion�rio enquanto for essa tabela
		SX3->(DbGoTop())
		While ! SX3->(EoF())
			IncProc("Analisando "+Alltrim(SX3->X3_CAMPO)+"...")
			
			//Se conseguir posicionar no campo na tempor�ria
			If (cAliasTmp)->(DbSeek(SX3->X3_CAMPO))
				RecLock('SX3', .F.)
				//Percorre os campos
				For nAtual := 1 To Len(aCampos)
					xContOld := &("SX3->"+aCampos[nAtual])
					xContNew := &(cAliasTmp+"->"+aCampos[nAtual])
					
					//Somente se o conte�do novo n�o estiver em branco
					If !Empty(Alltrim(cValToChar(xContNew)))
						//Somente se o conte�do antigo for diferente do novo
						If xContOld != xContNew
							//Atualiza vari�vel de log
							cLogAux += 	"Campo "+SX3->X3_CAMPO+" - "+aCampos[nAtual]+", '"+;
										Alltrim(cValToChar(xContOld))+"' -> '"+Alltrim(cValToChar(xContNew))+"'; "+;
										Chr(13)+Chr(10)
							
							//Se for tipo Num�rico
							If ValType(xContNew) == 'N'
								xContNew := cValToChar(xContNew)
								
							//Se for tipo Data
							ElseIf ValType(xContNew) == 'D'
								xContNew := 'sToD("'+dToS(xContNew)+'")'
							
							//Sen�o
							Else
								//Se tiver Aspas no Conte�do, utilizar� ap�strofo
								If '"' $ xContNew
									xContNew := "'"+xContNew+"'"
									
								Else
									xContNew := '"'+xContNew+'"'
								EndIf
							EndIf
							
							//Sobrepõe os campos da SX3
							&("SX3->"+aCampos[nAtual]+" := "+xContNew)
						EndIf
					EndIf
				Next
				
				SX3->(MsUnlock())
			EndIf
			
			SX3->(DbSkip())
		EndDo
		
		//Se tiver mensagem, teve atualiza��o
		If !Empty(cLogAux)
			cLogAux := 	"A tabela '"+cAliasAux+"' teve as seguintes atualiza�ões: "+Char(13)+Chr(10)+Char(13)+Chr(10)+;
						cLogAux
			
			//Mostra a mensagem
			If !lAuto
				Aviso("Aten��o", cLogAux, , 3)
			EndIf
			
			//Caso n�o exista o diret�rio de Log, cria
			If !ExistDir(cDirLog)
				MakeDir(cDirLog)
			EndIf
			
			//Gera o Log
			If cAliasAux == '*'
				MemoWrite(cDirLog+"TUDO_sim_"+dToS(Date())+"_"+StrTran(Time(), ':', '-')+".log", cLogAux)
			Else
				MemoWrite(cDirLog+cAliasAux+"_sim_"+dToS(Date())+"_"+StrTran(Time(), ':', '-')+".log", cLogAux)
			EndIf
			
		Else
			cLogAux := 	"A tabela '"+cAliasAux+"' n�o teve atualiza�ões!"
			If cAliasAux == '*'
				MemoWrite(cDirLog+cAliasAux+"_nao_"+dToS(Date())+"_"+StrTran(Time(), ':', '-')+".log", cLogAux)
			Else
				MemoWrite(cDirLog+"TUDO_nao_"+dToS(Date())+"_"+StrTran(Time(), ':', '-')+".log", cLogAux)
			EndIf
		EndIf
		
		//Fecha a tempor�ria e limpa o filtro do Dicion�rio
		(cAliasTmp)->(DbCloseArea())
		SX3->(DbClearFilter())
		
	//Finaliza a Transa��o
	End Transaction
	
	RestArea(aAreaX3)
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fValidPerg                                                   |
 | Autor: Daniel Atilio                                                |
 | Data:  11/11/2016                                                   |
 | Desc:  Fun��o para criar o grupo de perguntas                       |
 *---------------------------------------------------------------------*/

Static Function fValidPerg()
	//(		cGrupo,	cOrdem,	cPergunt,							cPergSpa,		cPergEng,	cVar,		cTipo,	nTamanho,	nDecimal,	nPreSel,	cGSC,	cValid,			cF3,		cGrpSXG,	cPyme,	cVar01,		cDef01,	cDefSpa1,	cDefEng1,	cCnt01,	cDef02,		cDefSpa2,	cDefEng2,	cDef03,			cDefSpa3,		cDefEng3,	cDef04,	cDefSpa4,	cDefEng4,	cDef05,	cDefSpa5,	cDefEng5,	aHelpPor,	aHelpEng,	aHelpSpa,	cHelp)
	PutSx1(	cPerg,	"01",	"Arquivo Origem?",					"",				"",			"mv_ch0",	"C",	60,			0,			0,			"F",	"", 			"",			"",			"",		"mv_par01",	"",		"",			"",			"",		"",			"",			"",			"",				"",				"",			"",		"",			"",			"",		"",			"",			{},			{},			{},			"")
	PutSx1(	cPerg,	"02",	"Tabela (Alias)?",					"",				"",			"mv_ch1",	"C",	3,			0,			0,			"G",	"NaoVazio()", 	"SX2PAD",	"",			"",		"mv_par02",	"",		"",			"",			"",		"",			"",			"",			"",				"",				"",			"",		"",			"",			"",		"",			"",			{},			{},			{},			"")
	PutSx1(	cPerg,	"03",	"Campos SX3 (separado por ;)?",		"",				"",			"mv_ch2",	"C",	60,			0,			0,			"G",	"NaoVazio()", 	"",			"",			"",		"mv_par03",	"",		"",			"",			"",		"",			"",			"",			"",				"",				"",			"",		"",			"",			"",		"",			"",			{},			{},			{},			"")
Return

/*/{Protheus.doc} zRepAll
Fun��o que d� um replace de todas as tabelas
@author Atilio
@since 11/11/2016
@version 1.0
@type function
@example u_zRepAll()
/*/

User Function zRepAll()
	Local aArea    := GetArea()
	Local cArqOrig := "\x_p11\sx3_p11.dtc"
	Local cCampos  := "X3_FOLDER"
	
	u_zRepSX3(cArqOrig, "*", cCampos)
	
	RestArea(aArea)
Return