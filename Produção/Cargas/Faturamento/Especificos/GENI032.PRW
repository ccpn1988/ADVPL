#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#include "ap5mail.ch"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"


// Tabela de Diretivas - Cabeçalho arquivo
#define _cEof			chr(13) + chr(10)
#define Z25EMPR 		01
#define Z25FILIAL 		02
#define Z25PEDIDO		03
#define Z25DTNF			04
#define Z25SERIE 		05
#define Z25NF	   		06
#define Z25STSEFAZ	   	07
#define Z25RECNO	   	08


/*{Protheus.doc} GENI032
	   		TRANSMISSAO AUTOMATICA DE NOTA FISCAL APOS PESAGEM.geni034
@type 		User function
@author 	Ivan de Oliveira
@since 		10/02/2018
@version 	1.0
@Param  	${Null}, ${Nulo}
@return 	${Null}, ${Nulo}
@example
u_GENI029()
*/
User Function GENI032()

Local alEmp 		:= {}
Local lEmp			:= Type('cFilAnt') == "C" .AND. Select("SM0") <> 0
Local nAuxEmp		:= 0
Local nX			:= 0
Local nLimite		:= 50

Conout("GENI032 - Iniciando Job - "+Time()+".")

If !lEmp
	RpcSetType(2)
	lOpenSM0 := RpcSetEnv( "00" , "1022")
	If !lOpenSM0
		ConOut("")
	   	ConOut(Replicate("+",nLimite))
	   	ConOut(Padc("GENI032 - Nao foi possivel incializar ambiente confirme a senha/usuario digitado. "+Dtoc(Date())+" "+Time(),nLimite))
	   	ConOut(Replicate("+",nLimite))
	   	ConOut("")
	   	RpcClearEnv()
		Return Nil
	Else
		Conout("GENI032 - Abrindo empresa "+SM0->M0_CODIGO+" '"+AllTrim(SM0->M0_NOMECOM)+"'"+" e filial "+SM0->M0_CODFIL+" '"+AllTrim(SM0->M0_FILIAL)+"' "+DTOC(DDataBase)+" "+Time())
	EndIf
EndIF

While !LockByName("GENI032",.T.,.T.,.T.)
    nX++
	Sleep(10)
	If nX > 2
		Conout("GENI032 - Não foi possível executar a fila WMS neste momento pois a função GENI032 já esta sendo executada por outra processamento!"+DTOC(DDataBase)+" "+Time())
		Return .F.
    EndIf
EndDo

ProcTrans()

If !lEmp .AND. Type('cFilAnt') == "C"
	RpcClearEnv()
EndIF

UnLockByName("GENI032",.T.,.T.,.T.)

Conout("GENI032 - Finalizando Job - "+Time()+".")

Return nil

Static Function ProcTrans()
Local _lSche  	:= !(Type("oMainWnd")=="O")
Local _cMLinErr := ''
Local _bError 	:= ErrorBlock( {|x| _Erro(x,@_cMLinErr ) } ) // CodeBlock de Erro
Local _cEmp     := '00'
Local _cFil     := '1022'
Local _nItTemp  := 0
Local _aNfs     := {}
Local _aRetTSS  := {}
Local _aParam	:= {}
Local _aErros   := {}
Local _nIt  	:= 0
Local _cSer     := _cNFIni := _cNFFin := ''
Local _cSession := GetPrinterSession()

Private cVerTss := ''
Private cEntSai := "1"
Private cTempDir	:= "\DANFE_PDF\"

Conout("Iniciando JOB GENI032 "+Time())

Begin Sequence

	// LOG DE ERROS     10         17                  16                 07        10           10           8          15
	Aadd( _aErros, { 'Empresa/Filial','Número NF.  ','Série  ','Descrição Erro  ' })
	Aadd( _aErros, { '..............','............','.......', Repl('.',100) })

	// Seta ambiente
	//RpcSetType(3)
 	if RpcSetEnv(_cEmp, _cFil)

 		// Identificadores para consulta Sefaz.
 		_cIdEnt   := StaticCall( FISA022, GETIDENT )
 	 	_lUsaColab:= UsaColaboracao("3")
 	 	_aParNF   := {Space(Len(SerieNfId("SF2",2,"F2_SERIE"))),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),CtoD(""),CtoD("")}
 	 	_cURL	  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
 	 	_nTamSer  := TamSx3( "F2_SERIE" )[1]
	 	_nTamNF   := TamSx3( "F2_DOC" )[1]
	 	_nPrzCNF  := SuperGetmv('MV_SPEDEXC', .T.,24 )

	 	_aItAlt   := {}

 		// Criando Parâmetros.
 		Aadd( _aParam, {'GEN_FAT190' , 'C', 'Define e-mail de notificação' ,'p/ocorrências da rotina Transferência  '	,'Automática NF.' 				, 'IVAN3001@GMAIL.COM'	} )
 		Aadd( _aParam, {'GEN_FAT191' , 'C', 'Define pasta     onde  serão' ,'gravados os arquivos Danfe e LOG rotina' 	,'Transferência Automática NF.' , '\DANFE_PDF\'			} )
  		Aadd( _aParam, {'GEN_FAT192' , 'C', 'Define pasta     onde  serão' ,'gravados os arquivos   de    LOG rotina' 	,'Transferência Automática NF.' , '\LOGSIGA\TRANSFAUT\'	} )

  		// Criando os Parâmetros.
	    //If !u_GENI033(_aParam)
		//	Aadd(_aErros, {  _cEmp + ' - ' + _cFil," Não possivel relizar a criação dos parâmetros da rotina. Verifique a existencia dos parâmetros GEN_FAT190 GEN_FAT191 GEN_FAT192"  })
	    //EndIf
	    _cMailNotif := Getmv(_aParam[01][01])
  		_cPastaPDF	:= SuperGetmv(_aParam[02][01], .T.,_aParam[02][06] )
  		_cPastaLOG	:= SuperGetmv(_aParam[03][01], .T.,_aParam[03][06] )
  		cVerTss 	:= getVersaoTSS()

  		// Criação das Pastas
  		if !ExistDir(_cPastaPDF)

  			_nRet := MakeDir( _cPastaPDF )

   			if _nRet != 0


  	   			Aadd(_aErros, { _cEmp + ' - ' + _cFil, "Todas", "-", "Não foi possível criar a pasta:  " + _cPastaPDF  +;
  								" no servidor protheus, informe ao T.I. esta ocorrência. Cód.Erro: " + cValToChar(FError()) })

			endif

  		Endif

  		if !ExistDir(_cPastaLOG)

  			_nRet := MakeDir( _cPastaLOG )

   			if _nRet != 0

  				Aadd(_aErros, {  _cEmp + ' - ' + _cFil, "Todas", "-", "Não foi possível criar a pasta:  " + _cPastaLOG  +;
  							 	" no servidor protheus, informe ao T.I. esta ocorrência. Cód.Erro: " + cValToChar(FError()) })

			endif

  		Endif

  		// Se não houve erro.
  		if Len(_aErros) == 2

  			// Prazo do Cancelamento da NF
  			_cDtCanc := dtos(date() - int( _nPrzCNF / 24))

			// _aNfs:={ Empresa, Filial, Pedido, Dt.Emiss.NF, Serie, NF, Status Sefaz}
	 		_CarregaNF(@_aNfs,_cDtCanc)

	 		// Executa as Transmissões
	 		for _nIt := 1 to len(_aNfs)

	 			conout("GENI032 - Processando DANFE "+StrZero(_nIt,4)+" de "+StrZero(len(_aNfs),4))

	 			// Se ocorrer erro em temo de execução
	 			/*
				if !empty(_cMLinErr)

					Exit

				Endif
	 			*/

	 			// logar noutra filial, caso diferente
	 			if _aNfs[_nIt][Z25EMPR]#_cEmp .or. _aNfs[_nIt][Z25FILIAL]# _cFil

	 				RpcClearEnv()
		   			RpcSetType( 2 )

		   			_cEmp := _aNfs[_nIt][Z25EMPR]
		   			_cFil := _aNfs[_nIt][Z25FILIAL]

		   			// Logando nova filial
		   			RpcSetType(3)
		   			if !RpcSetEnv(_cEmp, _cFil)

		   		 		Aadd(_aErros, { _cEmp + ' - ' + _cFil, "Todas", "-",'Não foi possível conexão com ambiente(Empresa/Filial): ' + _cEmp + ' / ' + _cFil })
		   				Exit

		   			Else

		   				// Identificadores para consulta Sefaz(por empresa/filial)
				 		_cIdEnt   := StaticCall( FISA022, GETIDENT )
				 	 	_lUsaColab:= UsaColaboracao("3")
				 	 	_aParam   := {Space(Len(SerieNfId("SF2",2,"F2_SERIE"))),Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),CtoD(""),CtoD("")}
				 	 	_cURL	  := PadR(GetNewPar("MV_SPEDURL","http://"),250)
				 	 	_nTamSer  := TamSx3( "F2_SERIE" )[1]
	   					_nTamNF   := TamSx3( "F2_DOC" )[1]

	 				Endif

	 			Endif

	 			// Carregando as Informações de NF
	 			_cSer 	:= _aNfs[_nIt][Z25SERIE]
 		   		_cNFIni := _aNfs[_nIt][Z25NF]
 		   		_nStSef := _aNfs[_nIt][Z25STSEFAZ]
 		   		_cNFFin := _aNfs[_nIt][Z25NF]
 		   		_DfNFIni:= _aNfs[_nIt][Z25DTNF]
 		   		_DfNFFin:= _aNfs[_nIt][Z25DTNF]
				_cIndice:= Padr(_cSer,_nTamSer)+Padr(_cNFIni, _nTamNF)
				_cInd002:= Padr(_cNFIni, _nTamNF)+ Padr(_cSer,_nTamSer)
				_cArqPDF:= Alltrim(_aNfs[_nIt][Z25FILIAL])+_cNFIni+_cSer

				Aadd( _aItAlt,{	_cIndice,_cInd002, _aNfs[_nIt][Z25RECNO],_cArqPDF,_cSer,_cNFIni  })
				_lUltima := .F.


				// Verificando o Status de Transmitido.
 				/*
 				Nota fiscal autorizada 		-> F2_FIMP == S"
				Nota fiscal transmitida 	-> F2_FIMP == T"
				Nota fiscal uso denegado 	-> F2_FIMP == D"
				Nota fiscal não autorizada 	-> F2_FIMP == N"
				*/
		  		_cSt := GetAdvFVal("SF2","F2_FIMP",FwXFilial("SF2") + Padr(_cNFIni, _nTamNF)+ Padr(_cSer,_nTamSer),1,"N")

		  		if !empty(_cSt)

					_nStSef :=  5

	 			Endif

	 			// Se ainda não transmitida. Status == 0
	 				/*
		   			Status NFe Sped050
						[1] NFe Recebida
						[2] NFe Assinada
						[3] NFe com falha no schema XML
						[4] NFe transmitida
						[5] NFe com problemas
						[6] NFe autorizada
						[7] Cancelamento
	                	*/

		   		// Sem Status tentativa de Transmissão
	 			if  _nStSef==0

	 				// Envio da NF ao Sefaz -->	AutoNfeEnv(cEmpresa,cFilProc,cWait,cOpc,cSerie,cNotaIni,cNotaFim)
		   			AutoNfeEnv(_cEmp,_cFil,Nil,Nil,_cSer,_cNFIni,_cNFIni)
		   			_nStSef := 1

		   			// Verificando erro.
		   			_cErro := GetWscError(1)

		   			// Sem erros, atualizar a zz5 com status de enviada para evitar reenvios.
		   			if empty(_cErro)

		   				for _nItTemp := 1  to len( _aItAlt )

		   					// Verificando o Status de Transmitido.
		   					_cSt := GetAdvFVal("SF2","F2_FIMP",FwXFilial("SF2") +_aItAlt[_nItTemp][02],1,"N")

		   					// Somente se estiver transmitida.
		   					if _cSt $ '|T|D|N|'

		   				   		dbselectarea("ZZ5")
		   				   		ZZ5->(DbGoTo( _aItAlt[_nItTemp][03] ))
		   						if RecLock("ZZ5",.F.)

									ZZ5->ZZ5_STSEFA	:= if( _cSt=='T',4,5)
									ZZ5->ZZ5_DSEF   := if( _cSt=='T','NFe transmitida',;
											    if(_cSt=='D','NFe uso Denegado, não poderá ser reutilizada',;
											    			  'NFe não autorizada.' ))
									ZZ5->ZZ5_STATUS	:= "00"
					       		ZZ5->(MsUnLock())

					     		Else

					     			Aadd(_aErros, { _cEmp + ' - ' + _cFil, _aItAlt[_nItTemp][05], _aItAlt[_nItTemp][06],'Não foi realizar atualização de registro na tabela ZZ5(Série/NF): ' + _aItAlt[_nT][01]  })

					     		Endif

					     	Endif

		  				Next

		   			endif


		   			// Ativa temporizador para aguardar monitoramento.(10 segundos)
		   			_nMiliS := 10000

		   			for _nItTemp := 1  to _nMiliS

		   				a := _nItTemp

		   			Next

				Endif

		  		// Realiza Monitoramento.
		   		If _nStSef#0

	 				// Preencimento parâmetros para Monitor
	 				_aParNF[01] := Padr(_cSer  , _nTamSer)
 	   		   		_aParNF[02] := Padr(_cNFIni, _nTamNF)
 	   		   		_aParNF[03] := Padr(_cNFIni, _nTamNF)

 	 				// Monitora os documentos no TSS
	 			 	_aRetTSS := StaticCall( SPEDNFE, GETLISTBOX, _cIdEnt, _cUrl, _aParNF, 1, '', .f., .T., .f., .f.,_lUsaColab)

				 	// Verifica retorno e imprime NF   cfilant
				 	for _nItTemp := 1  to len(_aRetTSS)

						// Realizando alterações na zz5 quanto as mensagens
						_nPos := aScan(_aItAlt, {|x| AllTrim(Upper(x[01])) == _aRetTSS[_nItTemp][02]})
				 		if _nPos#0

				 			dbselectarea("ZZ5")
				 			ZZ5->(Dbgoto(_aItAlt[_nPos][03]))
							cUsuBan	:= ZZ5->ZZ5_USUBAN
							If Empty(cUsuBan)
								If Select("USR_PESAGEM") > 0
									USR_PESAGEM->(DbCloseArea())
								EndIf

								BeginSql Alias "USR_PESAGEM"
									SELECT DISTINCT D47_TX_USUARIO FROM GUA_PEDIDOS.DPS_D47_SOLICITACOES
									WHERE D04_NR_ROMANEIO = %Exp:ZZ5->ZZ5_ROMANEIO%
									AND D04_NR_PEDIDO = %Exp:cValToChar(ZZ5->ZZ5_PEDIDO)%
									AND D04_ID_PEDIDO = %Exp:cValToChar(ZZ5->ZZ5_IDPEDI)%
								EndSql
								USR_PESAGEM->(DbGoTop())
								//MemoWrite ( "\sql\"+cIdPedido+".sql" , getLastquery()[2] )
								cUsuBan	:= USR_PESAGEM->D47_TX_USUARIO
								 USR_PESAGEM->(DbCloseArea())
				 			EndIf

							if RecLock("ZZ5",.F.)

								// Verificando o Status de Transmitido.
		   				   		_cSt := GetAdvFVal("SF2","F2_FIMP",FwXFilial("SF2") +_aItAlt[_nPos][02],1,"N")
		   				   		_cSt := if ( _cSt  == 'T', 4 , 5)

								if Left(Alltrim(_aRetTSS[_nItTemp][06]),3) == '001'

									_cSt := 6

								Elseif Left(Alltrim(_aRetTSS[_nItTemp][06]),3) == '015'

									_cSt := 7

								ElseIf 'SCHEMA'$upper(Alltrim(_aRetTSS[_nItTemp][06]))

									_cSt := 3

								Else

									_cDtCanc := GetAdvFVal("SF3","F3_DTCANC",FwXFilial("SF2") +_aItAlt[_nPos][01],5,"N")
									_cSt 	 := if ( Empty(_cDtCanc), _cSt, 7 )

								Endif

								ZZ5->ZZ5_STSEFA	:= _cSt
								ZZ5->ZZ5_DSEF   	:= Alltrim(_aRetTSS[_nItTemp][06])
								ZZ5->ZZ5_DTUPDA	:= DDataBase
								ZZ5->ZZ5_HRUPDA	:= Time()
								ZZ5->ZZ5_QTDPRC	:= ZZ5->ZZ5_QTDPRC+1
								ZZ5->ZZ5_USUBAN	:= cUsuBan
								ZZ5->ZZ5_STATUS	:= "00"
					     		ZZ5->(MsUnLock())

					     	 Else

					     		Aadd(_aErros, {_cEmp + ' - ' + _cFil, _aItAlt[_nPos][05], _aItAlt[_nPos][06],'Não foi realizar atualização de registro na tabela ZZ5(Série/NF): ' + _aItAlt[_nPos][01]  })

					  		Endif

					  		// Ponto para emissão da Danfe
					  		if ZZ5->ZZ5_STSEFA == 6

					  			// Nome arquivo Danfe a gerar-->FILIAL+NOTA+SERIE.PDF, exp: FFFFNNNNNNNNNSSS.PDF,
					  			_cNomPDF := Alltrim(_aItAlt[_nPos][04])
					  			_cSerPDF := _aItAlt[_nPos][05]
					  			_cNFPDF  := _aItAlt[_nPos][06]

								FErase(Alltrim(cTempDir)+ _cNomPDF + '.pdf')

					  			// Gravar o arquivo PDF na pasta indicada via Parâmetro MV???
					  			_lAdjustToLegacy	:= .F. // Inibe legado de resolução com a TMSPrinter
					  			_nLocal			:= 1
					  			_nOrientation		:= 1
								_cDevice			:= "PDF"
								_nPrintType		:= 6
					  			_nFlags			:= PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN

					  			// Instancia os objetos de impressão.
					  			_oDanfe := FWMSPrinter():New(_cNomPDF , IMP_PDF, _lAdjustToLegacy, cTempDir, .T.,,,,.F.)
					  			_oDanfe:lServer := .T.
					  			_oDanfe:lViewPDF:= .F.
					  			_oDanfe:cPathPDF:= cTempDir//GetTempPath()

					  			_oSetup := FWPrintSetup():New(_nFlags, "DANFE")

					  			// ----------------------------------------------
								// Define saida
		   						// ----------------------------------------------
								_oSetup:SetPropert(PD_PRINTTYPE   , _nPrintType)
								_oSetup:SetPropert(PD_ORIENTATION , _nOrientation)
								_oSetup:SetPropert(PD_DESTINATION , _nLocal)
								_oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
								_oSetup:SetPropert(PD_PAPERSIZE   , 2)
								_oSetup:SetPropert(PD_VALUETYPE   , cTempDir)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Salva os Parametros no Profile             ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								fwWriteProfString( _cSession, "LOCAL"      ,"SERVER" 	, .T.  ) //If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
						        fwWriteProfString( _cSession, "PRINTTYPE"  ,"PDF"		, .T.  )//If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
						        fwWriteProfString( _cSession, "ORIENTATION","LANDSCAPE" 	, .T.  ) //If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

						        _oDanfe:setCopies(1)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Danfe Paisagem DANFEIII.PRW                ³
			   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					  			u_DANFE_P1(_cIdEnt,'','',_oDanfe,  _oSetup ,{_cPastaPDF,_cNomPDF,Padr(Alltrim(_cSerPDF),_nTamSer), _cNFPDF},.T. )

					  		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Copia o arquivo para pasta indicativa server ³
			   					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					  			 //__CopyFile(Alltrim(GetTempPath())+ _cNomPDF + '.pdf', _cPastaPDF  +  _cNomPDF + '.pdf' )
					  			 //__CopyFile(Alltrim(cTempDir)+ _cNomPDF + '.pdf', _cPastaPDF  +  _cNomPDF + '.pdf' )
					  			 //Ferase(Alltrim(GetTempPath())+ _cNomPDF + '.pdf')
					  			 If file(_cPastaPDF  +  _cNomPDF + '.pdf')
									RecLock("ZZ5",.F.)
						     		ZZ5->ZZ5_STATUS	:= "01"
						     		ZZ5->ZZ5_STSEFA	:= 6
						     		ZZ5->ZZ5_DSEF		:= "001 - Emissão de DANFE autorizada"
						     		ZZ5->(MsUnLock())
						     	 	Conout("Danfe Gerada com sucesso - "+_cNomPDF+" - ZZ5 status "+StrZero(ZZ5->ZZ5_STSEFA,1)+" "+" - "+Time())
						     	 Else
						     	 	Conout("Danfe Gerada com sucesso ao gerar DANFE - "+_cNomPDF+" - "+Time())
					  			 EndIf

					  			 FreeObj(_oDanfe)
					  			 FreeObj(_oSetup)
					  			 //Ferase(Alltrim(cTempDir)+ _cNomPDF + '.pdf')

					  		Endif

				 	    Endif

					Next

					// Zerar os itens a Envio.
					_aItAlt := {}

					/*
					if !_lUltima

						// Próximo Registro.
			   			_cSer 	:= _aNfs[_nIt][Z25SERIE]
		 		   		_cNFIni := _aNfs[_nIt][Z25NF]
		 		   		_nStSef := _aNfs[_nIt][Z25STSEFAZ]
		 		   		_cNFFin := _aNfs[_nIt][Z25NF]
		 		   		_DfNFIni:= _aNfs[_nIt][Z25DTNF]
		 		   		_DfNFFin:= _aNfs[_nIt][Z25DTNF]
		 		   		_aItAlt := {}
		 		   		_cIndice:= Padr(_cSer,_nTamSer)+Padr(_cNFIni, _nTamNF)
						_cInd002:= Padr(_cNFIni, _nTamNF)+ Padr(_cSer,_nTamSer)
						_cArqPDF:= Alltrim(_aNfs[_nIt][Z25FILIAL])+_cNFIni+_cSer
						Aadd( _aItAlt,{	_cIndice,_cInd002, _aNfs[_nIt][Z25RECNO],_cArqPDF,_cSer,_cNFIni })

						// Se for o último e ainda não executou, voltar 1
						if _nIt == len(_aNfs) .and. len(_aNfs)>1

							_nIt--
							_lUltima := .T.

						Endif

					Endif

				Else

					_cNFFin := _aNfs[_nIt][Z25NF]
					_DfNFFin:= _aNfs[_nIt][Z25DTNF]
					_cIndice:= Padr(_cSer,_nTamSer)+Padr(_cNFFin, _nTamNF)
					_cInd002:= Padr(_cNFFin, _nTamNF)+ Padr(_cSer,_nTamSer)
					_cArqPDF:= Alltrim(_aNfs[_nIt][Z25FILIAL])+_cNFFin+_cSer

					if aScan(_aItAlt, {|x| AllTrim(Upper(x[1])) == _cIndice}) == 0

				   		Aadd( _aItAlt,{	_cIndice,_cInd002, _aNfs[_nIt][Z25RECNO],_cArqPDF,_cSer,_cNFFin })

	 				Endif
				*/
				Endif



			Next

	 		// Somente em ambientes Schedule
	   		if  _lSche

				//-- FECHA ARQUIVOS AMBIENTE RPC
				RpcClearEnv()
				RpcSetType( 2 )

			Endif

		Endif

	Else

		Aadd(_aErros, {_cEmp + ' - ' + _cFil, "Todas", "-",'Não foi possível conexão com ambiente(Empresa/Filial): ' + _cEmp + ' / ' + _cFil })

	Endif

 	// Eliminando Arrays
	_aNfs  := ASize(_aNfs,0)
	_aNfs  :=  Nil

	// Gravando erro
	if !Empty(_cMLinErr)

		Aadd(_aErros, {_cEmp + ' - ' + _cFil, "Todas", "-", _cMLinErr })

	Endif

	// Enviar e-mail / arquivo LOG das rejeições. --> ambos via MV???
	if len(_aErros)>2

		_cCab01  :=  'GEO - Log de Ocorrências em TRANSMISSAO AUTOMATICA DE NOTA FISCAL'
		_cCab02  :=  'Data/Hora Evento:' + Dtoc(date()) + ' - ' + Time()
		_cCab03  :=  Repl('=',200)
		_cNomeArq:= _cPastaLOG + StrTran(dtoc(date()),'/','') + StrTran(time(),':','') + '.log'
	 	_nHandle := Fcreate( _cNomeArq, 0)

   		If _nHandle == -1

			Aadd(_aErros, {_cEmp + ' - ' + _cFil, "Todas", "-", 'Não foi possivel criar o arquivo texto de LOG. Cód.Erro:'+ Str(FERROR())  })

			// Gravando a falha no console para erros na geração do arquivo LOG
			ConOut(Repl('*',200))
			ConOut(_cCab01)
			ConOut(_cCab02)
			ConOut(_cCab03)

			for _nItTemp := 1  to len(_aErros)

				ConOut('Empr.Filial: ' + Padr(_aErros[_nItTemp][01],14))
				ConOut('Desc.Erro  : ' + Padr(_aErros[_nItTemp][04],100))

			Next

			ConOut(Repl('*',200))

		Else

			for _nItTemp := 1  to len(_aErros)

				if _nItTemp == 1

					fwrite(_nHandle, _cCab01 + _cEof )
					fwrite(_nHandle, _cCab02 + _cEof )
					fwrite(_nHandle, _cCab03 + _cEof )

				Endif

				// Formando linha para gravação do erro.
			 	_cItem :=  Padr(_aErros[_nItTemp][01],14) + Padr(_aErros[_nItTemp][02],12)+;
						   Padr(_aErros[_nItTemp][03],07) + Padr(_aErros[_nItTemp][04],200)

				fwrite(_nHandle, _cItem + _cEof )

			Next

			fclose(_nHandle)

			// Envio da Notificação de falha
			if !empty(_cMailNotif) .and. '@'$_cMailNotif

				_cMens := '<h3><em><span style="color: #800000;"><strong>Segue em anexo descri&ccedil;&otilde;es de ocorr&ecirc;ncias.</strong></span></em></h3>'

				// Envio de Notificação.
				StaticCall( GENI024A, _ENVNOTIF, _cMailNotif, '','', _cMens , 'Notificação de Falha no Processo de TRANSMISSAO AUTOMATICA DE NOTA FISCAL', {_cNomeArq})

			Endif

		 Endif

	EndIf

//Mesmo com possiveis erros de formulas, retoma a partir deste processamento
End Sequence

Conout("fianlizando JOB GENI032 "+Time())

ErrorBlock( _bError ) // Restaura rotina de erro anterior

Return

/*{Protheus.doc} _Erro
//			Função Destinada a Gerar a Linha de Erro em tempo de execução
@author 	iVan de Oliveira
@since 		10/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _Erro(_oErro,_cMens )

Local _lRet    := .F.

Default _cMens := ''

If _oErro:Gencode > 0

    _cMens := "Processo: " + FunName() + CRLF
    _cMens += "Descrição do erro em tempo de execução: " + _oErro:DESCRIPTION + CRLF
    _cMens += "Errorstack:"  	  + CRLF
    _cMens +=  _oErro:ERRORSTACK  + CRLF

    _lRet  := .T.

Endif

Return _lRet

/*{Protheus.doc} _CarregaNF
//			Função que seleciona as NFs a importar
@author 	iVan de Oliveira
@since 		13/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _CarregaNF(_aItens, _cDtCanc )

Local cDtAux	:= DtoC(DDataBase)+" "+Time()

// Criando a lista a enviar.
_cAlias := GetNextAlias()

BeginSql ALIAS _cAlias

	SELECT
			ZZ5_FILIAL, ZZ5_STATUS, ZZ5_IDFUNC, ZZ5_DESC, ZZ5_PEDIDO, ZZ5_DTNF,
			ZZ5_NOTA  , ZZ5_SERIE , ZZ5_STSEFA, R_E_C_N_O_ REGIS,ZZ5_DTUPDA,ZZ5_HRUPDA
	FROM
			%table:ZZ5% A

	WHERE
			A.%notDel%
			/*AND ZZ5_NOTA <> ' '*/
			AND ZZ5_STATUS = '00'
			AND ZZ5_IDFUNC = '0004'
			AND ZZ5_STSEFA IN ( '0','1','2','3','4','5','6' )

	ORDER BY ZZ5_FILIAL, ZZ5_NOTA, ZZ5_SERIE, ZZ5_STSEFA
	Endsql

	//AND ZZ5_DTNF >= %exp:_cDtCanc%
	TcSetfield( _cAlias,'ZZ5_DTNF'  ,"D", 10, 0 )
	TcSetfield( _cAlias,'ZZ5_DTUPDA'  ,"D", 10, 0 )
	TcSetfield( _cAlias,'ZZ5_STSEFA',"N", 01, 0 )

	//MemoWrite ( "\sql\geni032"+DtoS(DDataBase)+StrTran(Time(),":","")+".sql" , getLastquery()[2] )

	// Processando as linhas
	(_cAlias)->( DbGotop() )
	While !(_cAlias)->( Eof() )

		If (_cAlias)->ZZ5_STSEFA == 5
			If (_cAlias)->ZZ5_DTUPDA == DDataBase
				aTimeAux	:= StrTokArr(ElapTime ( (_cAlias)->ZZ5_HRUPDA, Time() ),":")
				IF Len(aTimeAux) >= 3 .AND. ( Val(aTimeAux[1]) == 0 .AND. Val(aTimeAux[2]) <= 15 )
					(_cAlias)->(DbSkip())
					Loop
				EndIf
			EndIf
		EndIf

		Aadd(_aItens, { CEMPANT,;
						(_cAlias)->ZZ5_FILIAL,;
						Alltrim((_cAlias)->ZZ5_PEDIDO),;
					    (_cAlias)->ZZ5_DTNF,;
					    Alltrim((_cAlias)->ZZ5_SERIE),;
					    Alltrim((_cAlias)->ZZ5_NOTA),;
					   (_cAlias)->ZZ5_STSEFA,;
					   (_cAlias)->REGIS })

 			(_cAlias)->(DbSkip())

	Enddo

	(_cAlias)->(DbCloseArea())


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GetIdEnt  ³ Autor ³Eduardo Riera          ³ Data ³18.06.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtem o codigo da entidade apos enviar o post para o Totvs  ³±±
±±³          ³Service                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: Codigo da entidade no Totvs Services                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GetIdEnt()

Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs	 := Nil
Local lRetWs := .F.

If Type("lJob") == "U"
	lJob := .F.
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

lRetWs	:= oWs:ADMEMPRESAS()
lRetWs	:= Iif(ValType(lRetWs) <> "L",.F.,lRetWs)

If lRetWs
	cIdEnt  := oWs:cADMEMPRESASRESULT
EndIf

RestArea(aArea)

Return(cIdEnt)
