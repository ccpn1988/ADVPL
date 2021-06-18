#include "protheus.ch"
#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"
#include "fileio.ch"
#include "rptdef.ch"
#include "fwprintsetup.ch"
#include "tbiconn.ch"


// Tabela de Diretivas - Cabe�alho arquivo
#define _eol			 	chr(13) + chr(10)
#define ALL_TIPOREGISTRO 	SubsTr(_cLinha, 001,02 )
#define CAB_MENSAGEM		SubsTr(_cLinha, 003,03 )
#define CAB_TIPOPEDIDO		SubsTr(_cLinha, 006,03 )
#define CAB_NROPEDCOMP    	SubsTr(_cLinha, 009,20 )
#define CAB_NROSISTEMI		SubsTr(_cLinha, 029,20 )
#define CAB_DTEMISSPED		SubsTr(_cLinha, 049,12 )
#define CAB_DTINIPENTR		SubsTr(_cLinha, 061,12 )
#define CAB_DTFINPENTR		SubsTr(_cLinha, 073,12 )
#define CAB_NUMCONTRA		SubsTr(_cLinha, 085,15 )
#define CAB_LISTAPRECO		SubsTr(_cLinha, 100,15 )
#define CAB_EANLOCFORN		SubsTr(_cLinha, 115,13 )
#define CAB_EANLOCCOMP		SubsTr(_cLinha, 128,13 )
#define CAB_EANLOCCOBF		SubsTr(_cLinha, 141,13 )
#define CAB_EANLOCENTR		SubsTr(_cLinha, 154,13 )
#define CAB_CNPJFOR			SubsTr(_cLinha, 167,14 )
#define CAB_CNPJCOMPRA		SubsTr(_cLinha, 181,14 )
#define CAB_CNPJLOCCOB		SubsTr(_cLinha, 195,14 )
#define CAB_CNPJLOCENT		SubsTr(_cLinha, 209,14 )
#define CAB_TIPCODTRAN		SubsTr(_cLinha, 223,03 )
#define CAB_CODTRANSP		SubsTr(_cLinha, 226,14 )
#define CAB_RAZAOTRANSP		SubsTr(_cLinha, 240,30 )
#define CAB_CONDENTR		SubsTr(_cLinha, 270,03 )
#define CAB_SECAOPED		SubsTr(_cLinha, 273,03 )
#define CAB_OBSPEDIDO		SubsTr(_cLinha, 276,40 )

// Tabela de Diretivas - Pagamento
#define PAG_CONDPGTO	 	SubsTr(_cLinha, 003,03 )
#define PAG_REFDATA		 	SubsTr(_cLinha, 006,03 )
#define PAG_REFTPODT	 	SubsTr(_cLinha, 009,03 )
#define PAG_TIPOPERI	 	SubsTr(_cLinha, 012,03 )
#define PAG_NROPER	 		SubsTr(_cLinha, 015,03 )
#define PAG_DTVCTO	 		SubsTr(_cLinha, 018,08 )
#define PAG_VALORPG	 		SubsTr(_cLinha, 026,15 )
#define PAG_PERCPAGAR 		SubsTr(_cLinha, 041,05 )


// Tabela de Diretivas - Descontos e encargos.
#define DES_PERCDESCFIN 	SubsTr(_cLinha, 003,05 )
#define DES_VLRDESCFIN	 	SubsTr(_cLinha, 008,15 )
#define DES_PERCDESCOM	 	SubsTr(_cLinha, 023,05 )
#define DES_VLRDESCOM	 	SubsTr(_cLinha, 028,15 )
#define DES_PERCDESCPR	 	SubsTr(_cLinha, 043,05 )
#define DES_VLRDESCPR	 	SubsTr(_cLinha, 048,15 )
#define DES_PERCENCFIN	 	SubsTr(_cLinha, 063,05 )
#define DES_VLRENCFIN	 	SubsTr(_cLinha, 068,15 )
#define DES_PERCENCFRE	 	SubsTr(_cLinha, 083,05 )
#define DES_VLRENCFRE	 	SubsTr(_cLinha, 088,15 )
#define DES_PERCENCSEG	 	SubsTr(_cLinha, 103,05 )
#define DES_VLRENCSEG	 	SubsTr(_cLinha, 108,15 )

// Tabela de Diretivas - Itens
#define ITE_NROSEQ		 	SubsTr(_cLinha, 003,04 )
#define ITE_NROITEMPED		SubsTr(_cLinha, 007,05 )
#define ITE_QUALIFALT		SubsTr(_cLinha, 012,03 )
#define ITE_TIPOCODPROD		SubsTr(_cLinha, 015,03 )
#define ITE_CODPROD			SubsTr(_cLinha, 018,14 )
#define ITE_DESCRPROD		SubsTr(_cLinha, 032,40 )
#define ITE_REFERPROD		SubsTr(_cLinha, 072,20 )
#define ITE_UNIDMED			SubsTr(_cLinha, 092,03 )
#define ITE_NROUNIDCONS		SubsTr(_cLinha, 095,05 )
#define ITE_QTDEPEDIDA		SubsTr(_cLinha, 100,15 )
#define ITE_QTDEBONIF		SubsTr(_cLinha, 115,15 )
#define ITE_QTDETROCA		SubsTr(_cLinha, 130,15 )
#define ITE_TIPOEMBA		SubsTr(_cLinha, 145,03 )
#define ITE_NUMEMB			SubsTr(_cLinha, 148,05 )
#define ITE_VLRBRITEM		SubsTr(_cLinha, 153,15 )
#define ITE_VLRLIQITEM		SubsTr(_cLinha, 168,15 )
#define ITE_PRCBRUNIT		SubsTr(_cLinha, 183,15 )
#define ITE_PRCLIQUNIT		SubsTr(_cLinha, 198,15 )
#define ITE_BASEPRUNIT		SubsTr(_cLinha, 213,05 )
#define ITE_UNIDBASPRUNI	SubsTr(_cLinha, 218,03 )
#define ITE_VLRUNDESCOM		SubsTr(_cLinha, 221,15 )
#define ITE_PERCDESCCOM		SubsTr(_cLinha, 236,05 )
#define ITE_VALORUNITIPI	SubsTr(_cLinha, 241,15 )
#define ITE_ALIQIPI			SubsTr(_cLinha, 256,05 )
#define ITE_VLRUNDATRIB		SubsTr(_cLinha, 261,15 )
#define ITE_VLRUNDANTRIB	SubsTr(_cLinha, 276,15 )
#define ITE_VLRENCFRETE		SubsTr(_cLinha, 291,15 )
#define ITE_VLRPAUTA		SubsTr(_cLinha, 306,07 )
#define ITE_CODRMS			SubsTr(_cLinha, 313,08 )
#define ITE_CODNCM			SubsTr(_cLinha, 321,10 )

// Tabela de Diretivas - Grade
#define GRD_TIPOCODPROD 	SubsTr(_cLinha, 003,03 )
#define GRD_CODPROD			SubsTr(_cLinha, 006,14 )
#define GRD_QTDE			SubsTr(_cLinha, 020,15 )
#define GRD_UNIDMED			SubsTr(_cLinha, 035,03 )

// Tabela de Diretivas - CrossDocking
#define CDK_EANLOCENT		SubsTr(_cLinha, 003,13 )
#define CDK_CNPJLOCENT		SubsTr(_cLinha, 016,14 )
#define CDK_DTINIPENT		SubsTr(_cLinha, 030,12 )
#define CDK_DTFINPENT		SubsTr(_cLinha, 042,12 )
#define CDK_QTDE			SubsTr(_cLinha, 054,15 )
#define CDK_UNIDMED			SubsTr(_cLinha, 069,03 )

// Tabela de Diretivas - Sum�rio.
#define SUM_VLRTOTMERC		SubsTr(_cLinha, 003,15 )
#define SUM_VLRTOTIPI		SubsTr(_cLinha, 018,15 )
#define SUM_VLRTOTABAT		SubsTr(_cLinha, 033,15 )
#define SUM_VLRTOTENC		SubsTr(_cLinha, 048,15 )
#define SUM_VLRTOTDCOM		SubsTr(_cLinha, 063,15 )
#define SUM_VLRTOTDATR		SubsTr(_cLinha, 078,15 )
#define SUM_VLRTOTDANTR		SubsTr(_cLinha, 093,15 )
#define SUM_VLRTOTPED		SubsTr(_cLinha, 108,15 )

// Tabela de Diretivas - Log Execu��o.
#define LOG_PEDSARAIVA		01
#define LOG_CODPRODUTO		02
#define LOG_DTENTREGA		03
#define LOG_CNPJCOMPRADOR	04
#define LOG_CNPJENTREGA		05
#define LOG_MENSAGEMERRO	06
#define LOG_NOMEARQPROC		07
#define LOG_CONDICAOREGIS	08
#define LOG_PEDIDOERP		09
#define LOG_DESCPRODUTO		10

// Tabela de Diretivas - Tabela Diferen�as ( Pre�o x Desconto )
#define DIF_PEDSARAIVA		01
#define DIF_DTENTREGA		02
#define DIF_CODPRODUTO		03
#define DIF_VLRSARAIVA		04
#define DIF_DESCSARAIVA		05
#define DIF_PRCVENERP		06
#define DIF_VLRDIF			07
#define DIF_VLRDESERP		08
#define DIF_VLRDIFDESC		09
#define DIF_QTDESOLIC		10
#define DIF_NOMEARQPROC		11

/*/{Protheus.doc} GENI024

Importa��o de pedidos compras clientes que utilizem plataforma NeoGrid Vers�o 3.2
->> Esta fun��o foi desenvolvida exclusivamente para ser executada via Schedule.

@type User function
@author Ivan Oliveira
@since 04/11/2016
@version 1.0

@param ${Nulo}, ${Nulo}
@return ${Nulo}, ${Nulo}

@example
u_GENI024(aParam)
/*/
User Function GENI024()

_cEmpLOG := "00"   	//aParam[06]
_cFilLOG := "1022"	//aParam[07]

// Prepara o ambiente
PREPARE ENVIRONMENT EMPRESA _cEmpLOG FILIAL _cFilLOG MODULO "FAT" TABLES 'SC5','SC6','SA1','SA4','SB1'

Conout("GENI024-" + DtoC(dDataBase) + "-" + Time() + "-" + "Prepare Environment")

If LockByName("GENI024",.T.,.T.,.T.)

	Conout("GENI024-" + DtoC(dDataBase) + "-" + Time() + "-" + "Inicia rotina")
	
	U_GENI024A()
	
	UnLockByName("GENI024",.T.,.T.,.T.)
	
	Conout("GENI024-" + DtoC(dDataBase) + "-" + Time() + "-" + "Finaliza rotina")
	
Else
	Conout("GENI024 - n�o foi poss�vel iniciar a rotina pois a mesma j� est� sendo executada!")
EndIf

Reset Environment

Return

User Function GENI024A()

Local lRet	:= .F. //Verifica se foi possivel pergar o conteudo para preencher os parametros 
Local _cErroIni  := ''
Local _aValidCab := { '01', '02', '03', '04', '09' }
Local _cCont     := 0
Local _aDif      := {}
Local _aErros    := {}
Local _aAnexoMail:= {}
Local _aParamRot := Array(05)
Local _nProc     := 0
Local _ni        := 0
Local _nConta    := 0
Local _aTipPed   := { {'000', 'Pedido com condi��es especiais'}, {'002', 'Pedido de mercadorias bonificadas'} ,;
{'003', 'Pedido de Consigna��o'}, {'004', 'Pedido Vendor'} , {'005', 'Pedido Compror'},;
{'006', 'Pedido Demonstra��o'} } 
Local cNatSara	:= GetMV("GEN_FAT178")

Private DIR_AUX_LOG := "\Integracoes\Neogrid\logs\"

// caso nao receba nenhum parametro
//Default aParam := { "", "" , "", "", "", "00","1022" }

// Carrega par�metros rotina
If !(lRet := _CarrParam(@_aParamRot))

	_cErroIni += 'N�o foi possivel carregar os parametros da rotina, entre em contato com o administrador do sistema' + ;
	Alltrim(_aParamRot[04]) + _eol
EndIf


// Criando as pastas
if !ExistDir(Alltrim(_aParamRot[04]))
	
	_cErroIni += 'A pasta onde ser�o gravados os arquivos NeoGrid, n�o existe favor verificar o par�metro: GEN_FAT133, conte�do: ' + ;
	Alltrim(_aParamRot[04]) + _eol
	
Endif

If Empty(Alltrim(_aParamRot[01]))
	
	_cErroIni += 'A TES padr�o para gera��o de Pedido de Venda contida no par�metro: GEN_FAT130, n�o esta preenchida,favor verificar ! '+_eol
	
Else
	
	// Padronizando o campo
	_cTes := Padr( _aParamRot[01], TamSX3('F4_CODIGO')[01])
	
	// Verificando se a TES existe e n�o bloqueada !
	dbSelectArea("SF4")
	SF4->(DbSetOrder(1))
	
	If !DbSeek( FwXFilial("SF4") + _cTes )
		
		_cErroIni += 'A TES padr�o para gera��o de Pedido de Venda informada no par�metro: GEN_FAT130, n�o existe,favor verificar ! '
		
	Else
		
		if SF4->F4_MSBLQL == '1'
			
			_cErroIni += 'A TES padr�o para gera��o de Pedido de Venda informada no par�metro: GEN_FAT130, est� bloqueada para uso,favor verificar ! '+ _eol
			
		Endif
		
	Endif
	
Endif

If Empty( Alltrim(_aParamRot[02]) + Alltrim(_aParamRot[03]))
	
	_cErroIni += 'Os e-mails de notifica��o de processamento n�o est�o preenchidos, favor verificar par�metros: GEN_FAT131 e/ou GEN_FAT132 ! '+ _eol
	
Endif

// Se n�o houve erro, prosseguir.
if Empty(_cErroIni)
	
	// Verificando as Supastas
	_cTargetDir  := Alltrim( _aParamRot[04] ) + if ( RIGHT(alltrim(_aParamRot[04]),1) <> '\' ,'\','' )
	_cPastaProc := _cTargetDir + 'Processados'
	_cPastaRej  := _cTargetDir + 'Rejeitados'
	_cPastaGrav := _cTargetDir + 'Gravados\'
	
	if !ExistDir( _cPastaProc )
		
		MakeDir( _cPastaProc)
		
	Endif
	
	if !ExistDir( _cPastaRej )
		
		MakeDir( _cPastaRej )
		
	Endif
	
	// Envios de notifica��es
	_cContaEnvMail := Alltrim(_aParamRot[02])
	_cContaCopia   := if (  Alltrim(_aParamRot[02]) == Alltrim(_aParamRot[03]), '', Alltrim(_aParamRot[03]) )
	
	// Solicita o arquivo--> Ativar em caso de testes.
	//_cTargetDir:= cGetFile( "Arquivo Texto ( *.TXT ) |*.TXT|" , 'Selecione o arquivo', 1, 'C:\', .F.,;
	//				  nOR( GETF_LOCALHARD, GETF_RETDIRECTORY  ),.T., .T. )
	
	// Coletando arquivos a importar
	_aFiles := Directory(_cPastaGrav + '*' + chr(46) + 'txt' , "D")
	_cTabela    := GETMV("GEN_FAT064")			
	
	// Selecionando arquivos
	for _ni := 1 to len(_aFiles)
		
		// Nome do arquivo a abrir.
		_cArquivoTXT := _cPastaGrav + _aFiles[_ni][01]
		
		// Processa o arquivo
		_nHandle := FT_FUse(_cArquivoTXT)
		
		If _nHandle == -1
			
			_cErroIni += 'Erro de abertura do arquivo NeoGrid: ' + Alltrim(_cArquivoTXT) + ', c�digo Ms-Dos: ' +;
			Alltrim(Str( fError(),4)) + _eol
			
		Else
			
			// Efetuando leitura
			_lIdArq   := .f.
			_cNumPed  := ''
			_nProc := 0			
			FT_FGOTOP()
			While !FT_FEOF()
				
				Conout("GENI024-" + DtoC(dDataBase) + "-" + Time() + "-" + "Leitura de linha")
				
				// Leitura da Linha
				_cLinha := FT_FReadLn()
				
				// Validando se realmente � o arquivo
				if !_lIdArq
					
					if Ascan( _aValidCab,  Left(_cLinha,2) ) == 0
						
						// N�o identificado arquivo, sair da rotina e rejeitar arquivo, mover para pasta de rejeitados.
						frename( _cArquivoTXT , _cPastaRej + '\' + _aFiles[_ni][01] )
						Exit
						
					Endif
					
				Endif
				
				// Processamento das linhas
				Do Case
					
					// Cabe�alho
					case ALL_TIPOREGISTRO == '01'
						
						_nTotVal 	:= 0
						_nTotQtd 	:= 0
						_aItmPd    := {}
						_aCabPd    := {}
						_aAcabC5   := {}
						_nCndPgSar := _nNroItem := _nQtCross := 0
						_cCondPgt  := _cPedVend := _cNomCli  := ''
						_cNumPed   := Alltrim(CAB_NROPEDCOMP)
						_cDtIniEnt := Dtoc(Stod(CAB_DTINIPENTR))
						_cDtFinEnt := Dtoc(Stod(CAB_DTFINPENTR))
						_cCnpjForn := Alltrim(CAB_CNPJFOR)
						_cCnpjComp := Alltrim(CAB_CNPJCOMPRA)
						_cCnpjFat  := Alltrim(CAB_CNPJLOCCOB)
						_cCnpjEnt  := Alltrim(CAB_CNPJLOCENT)
						_cCnpjTra  := Alltrim(CAB_CODTRANSP)
						_CondFrete := Alltrim(UPPER(CAB_CONDENTR))
						_lIgnoraPed:= .f.
						_cMensNF   := 'Per�odo Programado Entrega: ' + _cDtIniEnt + ' at� ' + _cDtFinEnt
						
						// Verificando se o pedido j� foi importado.
						if _VerPed(@_cPedVend, _cNumPed)
							
							// 1- N�mero do pedido, 2-C�digo produto, 3-dt.entrega, 4-Cnpj Comprador, 5-Cnpj Entrega, 6-mensagem erro,
							// 7-arquivo processado, 8-registro aceito, 9-pedido Totvs, 10- ARQUIVO PROCESSADO //
							_lIgnoraPed := .t.
							AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD) ,_cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjEnt,;
							'- Pedido de Compra j� foi importado, e foi contemplado pelo Pedido de Venda n�.:' + _cPedVend;
							, _aFiles[_ni][01], 'S', 'N�o gerado', '' })
							
						Else
							
							// Verificando se � a filial para importa��o
							if Alltrim(_cCnpjForn) <> Alltrim(SM0->M0_CGC)
								
								_cCnpjForn:= Transform( _cCnpjForn,"@R 99.999.999/9999-99" )
								
								// 1- N�mero do pedido, 2-C�digo produto, 3-dt.entrega, 4-Cnpj Comprador, 5-Cnpj Entrega, 6-mensagem erro,
								// 7-arquivo processado, 8-registro aceito, 9-pedido Totvs, 10- ARQUIVO PROCESSADO //
								_lIgnoraPed := .t.
								
								AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD) ,_cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjEnt,;
								'- CNPJ para emiss�o do Pedido inv�lido: ' +;
								_cCnpjForn, _aFiles[_ni][01], 'S', 'N�o gerado', '' })
								
							Endif
							
							// Condi��o para Frete
							if _CondFrete <> 'CIF'
								
								_cCnpjEnt	:= Transform( _cCnpjEnt,"@R 99.999.999/9999-99" )
								_lIgnoraPed := .t.
								
								AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjEnt,;
								'- A condi��o Entrega informada no arquivo est� em desacordo com a emiss�o Ped.Venda: ' +;
								_CondFrete, _aFiles[_ni][01], 'S' , 'N�o gerado' , '' })
								
							Endif
							
							// Verificando se o Cliente ( entrega ) / Cliente(Cobran�a) existem no cadastro.
							DbSelectArea("SA1")
							DbSetOrder(3)
							
							// Verificando se o Cliente / Cliente(Entrega) existem no cadastro.
							if _cCnpjFat <> _cCnpjEnt
								
								If !DbSeek( FwXFilial("SA1") + _cCnpjEnt )
									
									_cCnpjEnt	:= Transform( _cCnpjEnt,"@R 99.999.999/9999-99" )
									_lIgnoraPed := .t.
									
									AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjEnt,;
									'- Inexist�ncia do CNPJ(Entrega) no cadastro de Cliente: ' +;
									_cCnpjEnt, _aFiles[_ni][01], 'S' , 'N�o gerado' , '' })
									
								Else
									
									// Verificando se bloqueado
									if SA1->A1_MSBLQL == '1'
										
										_lIgnoraPed := .t.
										AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjEnt,;
										'- Cliente do CNPJ(Entrega): ' + _cCnpjEnt + ;
										', est� bloqueado para uso.', _aFiles[_ni][01], 'S', 'N�o gerado', ''  })
										
									Else
										
										// Informa��es da entrega
										_cCliEntr   := SA1->A1_COD
										_cLjaEntr   := SA1->A1_LOJA
										_cNomCli 	:= Alltrim(SA1->A1_NOME)
										_cTel		:= Alltrim(SA1->A1_TEL)
										_cDDDTel	:= Alltrim(SA1->A1_DDD)
										_cCompl  	:= Alltrim(SA1->A1_COMPLEM)
										_cLogra		:= Alltrim(SA1->A1_END)
										_cCel       := _cDDDCel := ''
										_cBairro  	:= Alltrim(SA1->A1_BAIRRO)
										_cPais  	:= Alltrim(GetAdvFVal( "SYA", "YA_DESCR", FWxFilial("SYA") + SA1->A1_PAIS,1, '' ))
										_cCep	  	:= Alltrim(SA1->A1_CEP)
										_cCodIBGE   := Alltrim(SA1->A1_COD_MUN)
										_cMunicipio	:= Alltrim(SA1->A1_MUN)
										_cUf		:= Alltrim(SA1->A1_EST)
										_cNumEstab  := Alltrim(SA1->A1_XENDNUM)
										
									Endif
									
								Endif
								
							Endif
							
							// Cobran�a
							If !DbSeek( FwXFilial("SA1") + _cCnpjFat )
								
								_cCnpjFat	:= Transform( _cCnpjFat,"@R 99.999.999/9999-99" )
								_lIgnoraPed := .t.
								
								AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjFat,;
								'- Inexist�ncia do CNPJ(Cobran�a) no cadastro de Cliente: ' +;
								_cCnpjFat, _aFiles[_ni][01], 'S' , 'N�o gerado' , '' })
								
							Else
								
								// Verificando se bloqueado
								if SA1->A1_MSBLQL == '1'
									
									_lIgnoraPed := .t.
									AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjFat,;
									'- Cliente do CNPJ(Cobran�a): ' + _cCnpjFat + ;
									', est� bloqueado para uso.', _aFiles[_ni][01], 'S', 'N�o gerado', ''  })
									
								Else
									
									if empty(_cNomCli)
										
										_cCliEntr  := SA1->A1_COD
										_cLjaEntr  := SA1->A1_LOJA
										
									Endif
									
									_cCodCli := SA1->A1_COD
									_cCodLja := SA1->A1_LOJA
									_cTipoCli:= SA1->A1_TIPO
									_cVend   := SA1->A1_VEND
									_cTpoDesc:= SA1->A1_XTPDES
									_cCnpjTra:= if ( Val(_cCnpjTra) == 0 ,GetAdvFVal( "SA4", "A4_CGC", FWxFilial("SA4") + SA1->A1_TRANSP,1, ),;
									_cCnpjTra )
									_cCondPgt:= SA1->A1_COND
									_cNatur  := SA1->A1_NATUREZ
									
									If Empty(_cNatur)
										_cNatur	:= cNatSara	
									EndIf
									
									// Validar transportadora, se preenchido
									if !empty(_cCnpjTra)
										
										// Verificando se a transportadora esta cadastrada
										dbSelectArea("SA4")
										dbSetOrder(3)
										
										If !DbSeek( FwXFilial("SA4") + _cCnpjTra )
											
											_cCnpjTra	:= Transform( _cCnpjTra,"@R 99.999.999/9999-99" )
											_lIgnoraPed := .t.
											
											AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjFat,;
											'- Inexist�ncia do CNPJ no cadastro de Transportadoras: ' +;
											_cCnpjTra, _aFiles[_ni][01], 'S', 'N�o gerado', ''  })
											
										Else
											
											// Verificando bloqueio
											if SA4->A4_MSBLQL == '1'
												
												_lIgnoraPed := .t.
												AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp, _cCnpjFat,;
												'-  Transportadora de CNPJ: ' + _cCnpjEnt +;
												', est� bloqueado para uso.', _aFiles[_ni][01], 'S', 'N�o gerado', , ''  })
												
											Endif
											
										Endif
										
									Endif
									
									// Verificando Cond.pgto.
									dbSelectArea("SE4")
									dbSetOrder(1)
									
									if !MsSeek(FwXFilial("SE4")+ _cCondPgt )
										
										_lIgnoraPed := .t.
										AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp,;
										_cCnpjFat,;
										'- Condi��o de Pagamento informada no cliente: ' + _cCodCli + '-' + _cCodLja + ;
										', n�o existe, favor verificar !',;
										_aFiles[_ni][01], 'S', 'N�o gerado', ''  })
										
									Endif
									
									// Verificando Pedido Normal
									_lIgnoraPed:= Alltrim(CAB_TIPOPEDIDO) <> '001'
									if _lIgnoraPed
										
										_cCnpjComp:= Transform( _cCnpjComp,"@R 99.999.999/9999-99" )
										_cCnpjEnt := Transform( _cCnpjEnt, "@R 999.999.999.999-99" )
										
										_cDescTpPed := Alltrim(CAB_TIPOPEDIDO)
										if _nPos := Ascan( _aTipPed,{|x| alltrim(x[1]) = Alltrim(CAB_TIPOPEDIDO) } ) > 0
											
											_cDescTpPed := _aTipPed[_nPos][01] + ' - ' +_aTipPed[_nPos][02]
											
										Endif
										
										// N�mero do pedido, dt.entrega, Cnpj Comprador, Cnpj Entrega, mensagem erro //
										AADD( _aErros,{ _cNumPed, Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp,;
										_cCnpjFat,;
										'- Tipo de Pedido Compra a importar n�o permitido: ' + _cDescTpPed,;
										_aFiles[_ni][01], 'S', 'N�o gerado', ''  })
										
									ELse
										
										// Verifica se ocorreram erro para continuar valida��es noutros registros
										_lIgnoraPed := Ascan( _aErros,{|x| alltrim(x[1]) = Alltrim(_cNumPed) } ) > 0
										
										
									Endif
									
								Endif
								
							Endif
							
						Endif
						
						// Pagamento
					case ALL_TIPOREGISTRO == '02' .and. !_lIgnoraPed
						
						// Verificar quantas vezes esta sendo solicitado
						_nCndPgSar++
						
						// Descontos
					case ALL_TIPOREGISTRO == '03'.and. !_lIgnoraPed
						
						// Itens
					case ALL_TIPOREGISTRO == '04'.and. !_lIgnoraPed
						
						// Preencendo informa��es do item
						_alinha 	:= {}
						_cProdISBN	:= Alltrim(ITE_CODPROD)
						
						_nQtdSol	:= NoRound(Val(ITE_QTDEPEDIDA) / 100, 2)
						_cArm		:= _cProduto := _cDescPd := ''
						_nVlrItem   := NoRound(Val(ITE_PRCBRUNIT) / 100, 2)
						_nVlrDesco  := NoRound(Val(ITE_VLRUNDESCOM) / 100, 2)
						_cErro	    := _cGrupoProd := ''
						
						
						// Verificando a condi��o pagamento ( verificar se a qtde parcelas esta de acordo com arquivo ).
						_aCondPgto := Condicao( 5000, _cCondPgt, 0, date(),0)
						
						// Validando os itens ( Estoques )
						if _ValItPV( @_cProdISBN, @_nQtdSol, @_cArm , @_cProduto, @_cDescPd, @_cGrupoProd, @_cErro )
							
							// Verificando pre�o e desconto.
							DbSelectArea("DA1")
							DbSetOrder(1)
							
							if DbSeek( FwXFilial("DA1") + _cTabela  + _cProduto )
								
								_nVlrDif := Abs( DA1->DA1_PRCVEN - _nVlrItem )
								
								// Pegando percentual de desconto
								_nPercDesc  := POSICIONE("SZ2",1, FwXFilial("SZ2") + _cTpoDesc + _cGrupoProd, "Z2_PERCDES")
								_nVlDesERP  :=  ( DA1->DA1_PRCVEN *  if ( _nPercDesc > 1, _nPercDesc, 1 ) )/100
								
								_nPrcDA1 := DA1->DA1_PRCVEN
								_nPrcVen := Round(_nPrcDA1*(100-_nPercDesc)/100,2)
								_nValPed := Round(_nPrcVen* _nQtdSol,2)
								_nValDes := Round(_nPrcDA1*_nPercDesc/100*_nQtdSol,2)
								
								_nVlrDifD:= Abs( _nVlDesERP - _nVlrDesco )
								
								if _nVlrDif > 0.01 .or. _nVlrDifD > 0.01
									
									// Menciona array de diferen�as
									// Pedido, Dt_Entrega, ISBN, Pre�o Saravia, Desc Saraiva,Pre�o Gen, Dif.Pre�o, Desconto GEN, Dif Desc, Qtde., arquivo proessado.
									AADD( _aDif, { _cNumPed, _cDtIniEnt + ' � ' + _cDtFinEnt  , Alltrim(ITE_CODPROD),;
									_nVlrItem, _nVlrDesco,;
									DA1->DA1_PRCVEN, _nVlrDif, _nVlDesERP, _nVlrDifD, _nQtdSol, _aFiles[_ni][01] })
									
								Else
									
									// Logando condi��o pagamento
									/*
									if len(_aCondPgto) <> _nCndPgSar
									
									// Logando erros.
									AADD( _aErros,{ _cNumPed, Alltrim(_cProduto) + ' / ' + Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt,;
									_cCnpjComp,;
									_cCnpjEnt, ;
									'- O n�mero de parcelas da Cond.Pgto.informada Arq.de importa��o difere Pedido Venda: '+;
									StrZero(_nCndPgSar,3) + ' Vs. ' + StrZero(len(_aCondPgto),3), _aFiles[_ni][01],;
									'S', '', _cDescPd  })
									
									Endif
									*/
									
									_nNroItem++
									
									//��������������������������������
									//�Alimentando os Itens do pedido�
									//��������������������������������
									aAdd ( _alinha , { "C6_ITEM" 	, StrZero(_nNroItem,2)	, NIL} )
									aAdd ( _alinha , { "C6_PRODUTO" , _cProduto				, NIL} )
									aAdd ( _alinha , { "C6_XISBN " 	, _cProdISBN			, NIL} )
									aAdd ( _alinha , { "C6_DESCRI"  , _cDescPd  			, NIL} )
									aAdd ( _alinha , { "C6_QTDVEN"  , _nQtdSol   			, NIL} )
									aAdd ( _alinha , { "C6_PRUNIT"  , _nPrcDA1  			, NIL} )
									aAdd ( _alinha , { "C6_DESCONT" , _nPercDesc  			, NIL} )
									aAdd ( _alinha , { "C6_PRCVEN"  , _nPrcVen              , NIL} )
									aAdd ( _alinha , { "C6_VALOR"   , _nValPed              , NIL} )
									aAdd ( _alinha , { "C6_VALDESC" , _nValDes              , NIL} )
									aAdd ( _alinha , { "C6_TES"     , _cTes		   	 		, NIL} )
									aAdd ( _alinha , { "C6_LOCAL"   , _cArm   	    		, NIL} )
									aAdd ( _alinha , { "C6_ENTR\EG"  , ctod(_cDtIniEnt)		, NIL} )
									
									_nTotVal += _nValPed
									_nTotQtd += _nQtdSol
									
									aAdd(_aItmPd , _alinha)
									
								Endif
								
								
							Else
								
								// Logando erros.
								AADD( _aErros,{ _cNumPed, Alltrim(_cProduto) + ' / ' + Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp,;
								_cCnpjFat, '- N�o encontrada tabela de pre�os para Obra! ', _aFiles[_ni][01], 'S', 'N�o gerado', _cDescPd  })
							Endif
							
						Else
							
							// Logando erros.
							AADD( _aErros, { _cNumPed, Alltrim(_cProduto) + ' / ' + Alltrim(ITE_CODPROD), _cDtIniEnt + ' � ' + _cDtFinEnt, _cCnpjComp,;
							_cCnpjFat, _cErro , _aFiles[_ni][01], 'S', 'N�o gerado', _cDescPd })
							
						Endif
						
						// Grade
					case ALL_TIPOREGISTRO == '05'.and. !_lIgnoraPed
						
						// CrossDocking
					case ALL_TIPOREGISTRO == '06'.and. !_lIgnoraPed
						
						
						// Sum�rio.
					case ALL_TIPOREGISTRO == '09'.and. !_lIgnoraPed
						
						// Encontrando 1 item v�lido, subir o pedido.
						if !empty(_aItmPd)
							
							aAdd ( _aCabPd , { "C5_CLIENTE"	, _cCodCli		, NIL} )
							aAdd ( _aCabPd , { "C5_TIPO"	, 'N'			, NIL} )
							aAdd ( _aCabPd , { "C5_LOJACLI"	, _cCodLja		, NIL} )
							aAdd ( _aCabPd , { "C5_CLIENT"	, _cCliEntr		, NIL} )
							aAdd ( _aCabPd , { "C5_LOJAENT"	, _cLjaEntr		, NIL} )
							aAdd ( _aCabPd , { "C5_TIPOCLI"	, _cTipoCli		, NIL} )
							aAdd ( _aCabPd , { "C5_NATUREZ"	, _cNatur		, NIL} )
							aAdd ( _aCabPd , { "C5_VEND1"	, _cVend		, NIL} )
							aAdd ( _aCabPd , { "C5_XPEDCLI"	, _cNumPed		, NIL} )
							aAdd ( _aCabPd , { "C5_MENNOTA" , _cMensNF  	, NIL} )
							aAdd ( _aCabPd , { "C5_XUSRDIG" , "Neogrid-GENI024", NIL} )
							aAdd ( _aCabPd , { "C5_XQTDTOT" , _nTotQtd		, NIL} )
							aAdd ( _aCabPd , { "C5_XVALTOT" , _nTotVal		, NIL} )
							
							if !empty(_cNomCli)
								
								aAdd ( _aCabPd , { "C5_XSNOENT" , _cNomCli			, NIL} )//Sob.Nome Ent
								aAdd ( _aCabPd , { "C5_XNOMENT" , _cNomCli			, NIL} )//Nome Entrega
								aAdd ( _aCabPd , { "C5_XTELENT" , _cTel				, NIL} )//Fone Entrega
								aAdd ( _aCabPd , { "C5_XDDDENT" , _cDDDTel			, NIL} )//DDD Entrega
								aAdd ( _aCabPd , { "C5_XCOMENT" , _cCompl			, NIL} )//Comple.Entre
								aAdd ( _aCabPd , { "C5_XLOGENT" , _cLogra			, NIL} )//Logr.Entrega
								aAdd ( _aCabPd , { "C5_XCELENT" , _cCel				, NIL} )//Celular Ent.
								aAdd ( _aCabPd , { "C5_XDDCENT" , _cDDDCel			, NIL} )//DDD Cel.Ent.
								aAdd ( _aCabPd , { "C5_XBAIENT" , _cBairro			, NIL} )//Bairro Entr.
								aAdd ( _aCabPd , { "C5_XPAIENT" , _cPais			, NIL} )//Pais Entrega
								aAdd ( _aCabPd , { "C5_XCEPENT" , _cCep				, NIL} )//CEP Entrega
								aAdd ( _aCabPd , { "C5_XMUNENT" , _cCodIBGE			, NIL} )//Mun.IBGE Ent
								aAdd ( _aCabPd , { "C5_XCIDENT" , _cMunicipio		, NIL} )//Cidade Entr.
								aAdd ( _aCabPd , { "C5_XUFENT " , _cUf				, NIL} )//UF Entrega
								aAdd ( _aCabPd , { "C5_XNUMENT" , _cNumEstab		, NIL} )//Num.Entrega
								
							Endif
							
							_nTotVal := 0
							_nTotQtd := 0
							
							//�������������������������������������������������������Ŀ
							//�Ordenando o vetor conforme estrutura da SX3, pois      �
							//�alguns execauto`s realizam valida;'oes de gatilhos     �
							//�o que pode acabar matando uma informa;'ao obrigat[oria �
							//�que ja havia sido enviada corretamente no array        �
							//���������������������������������������������������������
							dbSelectArea("SX3")
							dbSetOrder(1)
							MsSeek("SC5")  
							aX3SC5	:= FWSX3Util():GetAllFields( "SC5" )
							//While !EOF() .And. (SX3->X3_ARQUIVO == "SC5")
							For nC5	:= 1 To Len(aX3SC5)
								For _nConta := 1 To Len(_aCabPd) 
									//If AllTrim(SX3->X3_CAMPO) == Alltrim(_aCabPd[_nConta][1])
									If Alltrim(aX3SC5[nC5][3]) == Alltrim(_aCabPd[_nConta][1])
										aAdd(_aAcabC5,_aCabPd[_nConta])
										Exit
									EndIf
								Next
							//	dbSelectArea("SX3")
							//	dbSkip()
							//EndDo
							Next nC5
							if !_lIgnoraPed
								
								_cErroExec := _cMensErro := ''
								
								// Executa o arquivo
								_cCnpjComp:= Transform( _cCnpjComp,"@R 99.999.999/9999-99" )
								_cCnpjEnt := Transform( _cCnpjEnt, "@R 999.999.999.999-99" )
								
								if !_IncluiPed(_aAcabC5, _aItmPd, @_cErroExec )
									
									_cControle := 'S'
									_cPedido   := 'N�o gerado'
									_cMensErro := '- Ocorreu erro de auto-execu��o(detalhes no arquivo LOG do sistema, em anexo)'
									
									// Copia arquivo do remote local para o servidor, sem compactar antes de transmitir
									//CpyT2S( DIR_AUX_LOG + _cErroExec, "\Spool\", .F. )
									
									// Apaga o arquivo tempor�rio remote local
									//Ferase(DIR_AUX_LOG + _cErroExec)
									
									// Enviando LOG do Erro
									aadd( _aAnexoMail, DIR_AUX_LOG + _cErroExec )
									
								Else
									
									_nProc++
									_cControle := ' '
									_cPedido   := SC5->C5_NUM
									
								Endif
								
								// Logando as ocorr�ncias
								for _nConta := 1 To len(_aItmPd)
									
									_cCodISBN := GetAdvFVal( "SB1", {"B1_ISBN","B1_COD","B1_DESC"}, FWxFilial("SB1") +;
									_aItmPd[_nConta][02][02],1,'B1_COD' )
									
									// Ver se j� existe erro logado
									_nPos := Ascan( _aErros,{|x| alltrim(x[1]) = Alltrim(_cNumPed) .and.;
									x[2] == Alltrim(_cCodISBN[02])+ ' / ' + Alltrim(_cCodISBN[01]) } )
									
									if _nPos > 0
										
										if _cControle == 'S'
											
											_aErros[_nPos][LOG_MENSAGEMERRO] += _cMensErro
											
										Endif
										
										_aErros[_nPos][LOG_PEDIDOERP] := _cPedido
										
									Else
										
										Aadd( _aErros, { _cNumPed, Alltrim(_cCodISBN[02])+ ' / ' + Alltrim(_cCodISBN[01])  ,;
										_cDtIniEnt + ' � ' + _cDtFinEnt,;
										_cCnpjComp, _cCnpjEnt, _cMensErro,;
										_aFiles[_ni][01], _cControle, _cPedido, Alltrim(_cCodISBN[03]) })
									Endif
									
								Next
								
							Endif
							
						Endif
						
				EndCase
				
				FT_FSKIP()
				
			Enddo
			
			// Fecha arquivo
			fclose(_nHandle)
			FT_FUse()
			
			// Controle de navega��o dos arquivos, se processado parcial, pasta: processados, sen�o: reijeitados
			if _nProc > 0
				
				// Se existir, apagar
				if file ( _cPastaProc + '\' + _aFiles[_ni][01] )
					
					Ferase(_cPastaProc + '\' + _aFiles[_ni][01])
					
				Endif
				
				Frename( _cArquivoTXT , _cPastaProc + '\' + _aFiles[_ni][01] )
				
			Else
				
				// Se existir, apagar
				if file ( _cPastaRej + '\' + _aFiles[_ni][01] )
					
					Ferase(_cPastaRej + '\' + _aFiles[_ni][01])
					
				Endif
				
				Frename( _cArquivoTXT , _cPastaRej + '\' + _aFiles[_ni][01] )
				
			Endif
			
		Endif
		
	Next
	
Endif

// Nome arquivo de loG
_cNomeArq := 'Processamento_NeoGrid_' + dtos(date()) + strtran(time(),':','') + ".xml"

// Logando erros iniciais
if !Empty(_cErroIni)
	
	// Tornando em array erros
	_aErro := Separa(_cErroIni, _eol ,.T.)
	
	_cMensagem := '<h3>&nbsp;**********************************************************************************************************************************</h3>'
	_cMensagem += '<h3 style="text-align: center;"><span style="color: #ff0000;"><em>Processamento n&atilde;o ocorrido devido a Erros listados '+;
	'abaixo na Importa&ccedil;&atilde;o Pedidos NeoGrid - ' + procname(0) + '&nbsp;</em></span></h3>
	_cMensagem += '<h3>&nbsp;**********************************************************************************************************************************</h3>'
	_cMensagem += '<table style="float: left;">'
	_cMensagem += '<tbody>'
	
	for _ni := 1 to len(_aErro)
		
		_cMensagem += '<tr>'
		_cMensagem += '<td style="width: 1000px; height: 20px;">'
		_cMensagem += '<h4>' +_aErro[_ni] + '</h4>'
		_cMensagem += '</td>'
		_cMensagem += '</tr>'
		
	Next
	
	_cMensagem += '</tbody>'
	_cMensagem += '</table>'
	_cMensagem += '<h4>&nbsp;</h4>'
	_cMensagem += '<p>&nbsp;</p>'
	_cMensagem += '<p><span style="color: #0000ff;"><em><span style="text-decoration: underline;">Executado &agrave;s:&nbsp;'+;
	dtoc(date()) + ' - ' + time() + '</span></em></span></p>'
	// Texto Console
	_cConsole := Repl('*', 100)
	_cConsole += ' Importa��o NeoGrid - Comunicado de Erro cr�tico em tempo de execu��o, processo: '+ procname(0) + _eol
	_cConsole += ' ' + _eol
	_cConsole += _cErroIni + _eol
	_cConsole += ' ' + _eol
	_cConsole += 'Executado �s :' + dtoc(date()) + ' - ' + time() + _eol
	_cConsole += Repl('*', 100)
	
	// Notifica��o
	_cContaEnvMail := Alltrim(_aParamRot[05])
	_cContaCopia   := _cCco := ' '
	_cAssunto      := 'Importa��o NeoGrid - Comunica��o de Erro Cr�tico em tempo Execu��o'

	_cMensagem := _MontaCorpo(_aDif, len(_aAnexoMail) )
	MemoWrite(DIR_AUX_LOG+"ConteudoEmail_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")+".HTML",_cMensagem)	
	// Enviando notifica��o
	_EnvNotif( _cContaEnvMail, _cContaCopia, _cCco, _cMensagem, _cAssunto, _aAnexoMail )
	
	// Gravando mensagem no LOG
	ConOut( _cConsole )
	
Endif

// Imprimir LOG
if !empty(_aErros)
	
	// Classificando para impress�o ( pedido + coluna de erro de erro )
	Asort(_aErros,,, { |x, y| x[01] + x[08] < y[01] + y[08] } )
	
	_ImpLOG(_cNomeArq, _aErros)
	
	aadd( _aAnexoMail, DIR_AUX_LOG + _cNomeArq )
	//aadd( _aAnexoMail, "\spool\LayoutOrders_NeoGrid_v032.pdf" )
	
	// Enviar c�pia para ti caso erro de execauto.
	_cContaCopia  := if ( len(_aAnexoMail) > 1 .and. !empty(Alltrim(_aParamRot[05])), Alltrim(_aParamRot[05]), ' ' )
	_cAssunto 	  := 'Importa��o NeoGrid - Relat�rio de Processamento em: ' + dtoc(date()) + ' - ' + time()
	_cCco         := ' '
	
	// Texto corpo e-mail
	_cMensagem := _MontaCorpo(_aDif, len(_aAnexoMail) )
	MemoWrite(DIR_AUX_LOG+"ConteudoEmail_"+DtoS(DDataBase)+"_"+StrTran(Time(),":","")+"_LOG.HTML",_cMensagem)
	// Enviando notifica��o
	_EnvNotif( _cContaEnvMail, _cContaCopia, _cCco, _cMensagem, _cAssunto, _aAnexoMail )
	
Endif

//Excluindo tempor�rio
//for _ni := 1 to len(_aAnexoMail)
//	Ferase( _aAnexoMail[_ni] )
//Next

Return Nil

/*/{Protheus.doc} _CarrParam
incluir pedido na rotina de importa��o

@type User function
@author Ivan Oliveira
@since 04/11/2016
@version 1.0

@param ${_aParametros}, ${Array unidimencional contendo par�metros da rotina}

Sendo: 01 c�digo EMPRESA/filial inclusao pedido,
02 c�digo TES utilizado na inclus�o Pedido
03 usu�rio para envio de notifica��o
04 usu�rio para envio de erro processamento

@return ${Nil}, ${Nil}

@example
_CarrParam( _aCab, _aItens)

/*/
Static Function _CarrParam(_aParametros)

lOCAL _aTmp  := {{'GEN_FAT130','TES utilizada na importa��o pedidos NeoGrid'},;
{'GEN_FAT131','Conta de e-mail para envio de notifica��o LOG importa��o pedidos NeoGrid'},;
{'GEN_FAT132','Conta de e-mail para envio de planilha com diferen�as de valores.' },;
{'GEN_FAT133','Pasta onde ser�o gravados os arquivos referentes � importa��o pedidos NeoGrid'},;
{'GEN_FAT141','Conta de E-mail T.I. para notifica��o erros cr�ticos na importa��o pedidos NeoGrid '}}

Local _nCont := 0

for _nCont := 1 to len(_aTmp)
	
	// Gravando par�metro.
	SX6->(dbSetOrder(1))

	If !SX6->(dbSeek( FWxFilial("SX6") + _aTmp[_nCont][01] ))
		Return(.F.)	
	EndIf
	// Carrega os conte�dos.
	//_aParametros[_nCont] := GetMv(_aTmp[_nCont][01])

	/*
	if !SX6->(dbSeek( FWxFilial("SX6") + _aTmp[_nCont][01] ))
		
		RecLock("SX6", .T. )
		
		SX6->X6_FIL     := FWxFilial('SX6')
		SX6->X6_VAR     := _aTmp[_nCont][01]
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := Left(_aTmp[_nCont][02],45)
		SX6->X6_DESC1   := if ( len(_aTmp[_nCont][02])>45, Substr( _aTmp[_nCont][02], 46, len(_aTmp[_nCont][02])),'' )
		SX6->X6_DESC2   := ' '
		SX6->X6_CONTEUD := if ( _nCont == 4, '\NEOGRID\', if ( _nCont == 5, 'cleuto.lima@grupogen.com.br', ' '))
		SX6->X6_CONTENG := SX6->X6_CONTEUD
		SX6->X6_CONTSPA := SX6->X6_CONTEUD
		SX6->X6_PROPRI  := "S"
		SX6->X6_PYME    := "S"
		
		MsUnLock()
		
		
	Endif
	
	// Carrega os conte�dos.
	_aParametros[_nCont] := SX6->X6_CONTEUD
	*/
Next

Return(.T.)

/*/{Protheus.doc} _IncluiPed
incluir pedido na rotina de importa��o

@type User function
@author Ivan Oliveira
@since 04/11/2016
@version 1.0

@param ${_aCab}	 , ${Array contendo o texto cabe�alho de pedido}
@param ${_aItens}, ${Array contendo o texto itens de pedido}

@return $L�gico}, ${.t. se inclus�o com seucesso, .f. ocorrendo erro na inclus�o}

@example
_IncluiPed( _aCab, _aItens)

/*/
Static Function _IncluiPed(_aCab, _aItens, _cNomeArq )

//������������������������������������������������Ŀ
//�Inicio a grava��o (Execauto) do pedido de vendas�
//��������������������������������������������������
DbSelectArea("SC5")
DbSelectArea("SC6")
DbSelectArea("SB1")

Private lMsErroAuto 	:= .F. // necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
//Private lMsHelpAuto 	:= .T. // se .t. direciona as mensagens   acols  de help para o arq. de log
//Private lAutoErrNoFile:= .T. // for�a a grava��o das informa��es de erro em array para manipula��o da grava��o ao inv�s de gravar direto no arquivo tempor�rio

Conout("GENI024-" + DtoC(dDataBase) + "-" + Time() + "-" + "Grava pedido")
	
MSExecAuto({|x,y,z| mata410(x,y,z)}, _aCab, _aItens, 3)

If lMsErroAuto
	
	// Arquivo LOG de ERRO __aErrAuto    GetAutoGRLog()	 AutoGRLog(cLog)GetAutoGRLog()
	_cNomeArq := 'NeoGridErro-' + dtos(date()) + strtran(time(),':','') + ".log"
	Mostraerro( DIR_AUX_LOG, _cNomeArq )
	
Endif

Return !lMsErroAuto

/*/{Protheus.doc} _EnvNotif
Envia Notifica��es de e-mail na rotina de importa��o

@type User function
@author Ivan Oliveira
@since 04/11/2016
@version 1.0

@param ${_ContaPara}	, ${Caractere}	, ${Conta utilizada para envio de mensagem}
${_cContaCC}		, ${Caractere}	, ${Conta(C�pia) utilizada para envio de mensagem}
${_cContaCCo}	, ${Caractere}	, ${Conta(C�pia oculta) utilizada para envio de mensagem}
${_cCorpo}		, ${Caractere}	, ${Texto para Corpo da Mensagem}
${_cAssuntoM}	, ${Caractere}	, ${Texto para Assunto da Mensagem}
${_aAnexos}		, ${Array}		, ${Array unidimencional contendo o(s) caminho(s) anexo.}

@return ${Nulo}			, ${Nulo}

@example
_EnvNotif('teste@totvs.com.br','teste@totvs.com.br', 'Envio de Nofifica��o', {} )
/*/
Static Function _EnvNotif(_ContaPara, _cContaCC, _cContaCCo, _cCorpo, _cAssuntoM,  _aAnexos)


// Pega informa��es para envio de e-mail
_cSmtpServ  := AllTrim(GetMV("MV_RELSERV"))
_cCtaSmt	:= AllTrim(GetMV("MV_RELFROM"))
_cSenSmt	:= AllTrim(GetMV("MV_RELPSW"))
_lUtilSSL   := GetMV("MV_RELSSL")
_lUtilTLS   := GetMV("MV_RELTLS")
_lAutentic  := GetMV("MV_RELAUTH")
_cErroEnv   := ' '

// Envio de Notifica��o.
u__EnvEmail( 	_cSmtpServ, _cCtaSmt  , _cSenSmt,, _lUtilSSL , _lUtilTLS, _lAutentic , _ContaPara, _cContaCC,;
_cContaCCo, _cAssuntoM, _aAnexos , _cCorpo   , .f. ,   )

Return Nil

/*/{Protheus.doc} _ValItPV
Verifica saldo em estoque e valida informa��es na inclus�o do pedido de venda
- Este fonte foi baseado no fonte: GENA028C que verifica inconsist�ncias na inclus�o de item de PV al�m
de verificar saldo dispon�vel do produto.

@type Static function
@author Ivan Oliveira
@since 04/11/2016
@version 1.0

@param ${_cCodISBN} , ${Caractere} - c�digo de produto ISBN
@param ${_nQtdSol}	, ${Num�rico}  - Qtde.   solicitada no arquivo( repassada como refer�ncia )
@param ${_cArm}		, ${Caractere} - C�digo do armaz�m onde encontra-se material
@param ${_cCodProd}	, ${Caractere} - C�digo do produto ERP Totvs( repassada como refer�ncia )
@param ${_cDescr}	, ${Caractere} - descri��o do produto ERP Totvs( repassada como refer�ncia )
@param ${_cErro}	, ${Caractere} - Mensagem de erro( repassada como refer�ncia )

@return ${_lRet}, ${L�gico}, se existe ou n�o saldo dispo�vel al�m de inconsist�ncias.

@example
_ValItPV( '9788530973070', 100, '01' , @_cCodProd , @_cDescr, @_cRetErro )

/*/
Static Function _ValItPV( _cCodISBN, _nQtdSol, _cArm , _cCodProd, _cDescr, _cGrProd,  _cErro )

Local _lRet		:= .f.
Local _cProdISBN := Padr( Alltrim(_cCodISBN), TamSX3('B1_ISBN')[01] )


//������������������������������������������������������������������������������Ŀ
//�Procura por codigo ISBN                                               	     �
//��������������������������������������������������������������������������������
dbSelectArea("SB1")
if !SB1->( dbOrderNickname("GENISBN") )
	
	_cErro := '- N�o encontrado �ndice espec�fico(GENISBN) para tabela de produtos, informe esta ocorr�ncia ao Depto.TI.'
	
Else
	
	If !dbSeek(xFilial("SB1") + _cProdISBN )
		
		_cErro := '- N�o encontrado Produto ISBN para o c�digo mencionado no arquivo: ' + Alltrim(_cProdISBN)
		
	Else
		
		// Verificando se existe outra ocorr�ncia com mesmo c�digo
		_nRegistro := SB1->(recno())
		_cCodProd  := SB1->B1_COD
		_cDescr    := SB1->B1_DESC
		_cCodISBN  := SB1->B1_ISBN
		_cGrProd   := SB1->B1_GRUPO
		_cArm      := IIF( Empty(SB1->B1_LOCPAD), "01" , SB1->B1_LOCPAD )
		_cTpPublic := SB1->B1_XIDTPPU
		
		// Verificando bloqueio do registro
		if SB1->B1_MSBLQL == "1"
			
			_cErro := "Obra encontra-se bloqueado para uso, favor verificar. '
			
		Else
			
			SB1->(DbSkip())
			
			// Se for mesmo c�digo retornar erro
			if alltrim(SB1->B1_ISBN) == alltrim(_cProdISBN) .and. _cTpPublic == SB1->B1_XIDTPPU
				
				_cErro := ' C�digo ISBN, est�  em duplicidade na base de dados!'
				
			Endif
			
			SB1->(DbGoto(_nRegistro))
			
			// N�o contendo erros, seguir consulta estoque
			if empty(_cErro)
				
				_cErro :=  "Obra n�o possui saldo em estoque."
				
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1))
				
				// Verificando se existe estoque
				if DbSeek( FwXFilial("SB2") + SB1->B1_COD + _cArm )
					
					_nSaldo := SaldoSb2()
					
					if !(_nSaldo >= _nQtdSol).and. Alltrim(SB1->B1_XIDTPPU) <> '15' // 30/10/2015 - Rafael Leite - Ajuste Minha Biblioteca.
						
						// Se tiver saldo.
						If _nSaldo > 0
							
							_cErro := "Obra atendida parcialmente. Qtd. solicitada: "+AllTrim(Str(_nQtdSol))+" / Atendida: "+AllTrim(Str(_nSaldo))
							
							// Devolvendo saldo
							_nQtdSol := _nSaldo
							_lRet    := .t.
							
						Else
							
							_cErro :=  "Obra n�o possui saldo em estoque."
							
							// Devolve qtde,zerada para controle de erros
							_nQtdSol := 0
							
						Endif
						
					Else
						
						// Retira as mensagens e retorna ok
						_cErro  := ''
						_lRet   := .t.
						
					Endif
					
				Else
					
					// Devolve qtde,zerada para controle de erros
					_nQtdSol:= 0
					
				Endif
				
			Endif
			
		Endif
		
	Endif
	
Endif

Return _lRet

/*/{Protheus.doc} _MontaCorpo
Monta Corpo do e-mail para envio de notifica��o advert�ncia quanto a inclus�o de pedidos de vendas

@type Static function
@author Ivan Oliveira
@since 10/11/2016
@version 1.0

@param ${_aItens}, ${Array}, Array multi-dimensional contendo as colunas que dever�o serem enviadas para usu�rio, sendo:

[01] - N�mero Pedido
[02] - Dt_Entrega
[03] - ISBN
[04] - Pre�o Saravia
[05] - Desc Saraiva
[06] - Pre�o Gen
[07] - Dif.Pre�o
[08] - Desconto GEN
[09] - Dif Desc
[10] - Qtde.

@return ${}, ${L�gico}

@example
_EnvNotif()
/*/
Static Function _MontaCorpo( _aItens, _nQtArq )

Local _cHtml := ''
Local _nLin  := 0

// Cabe�halho da mensagem
//_cHtml += '<p><img src="http://cdn-grupogen.intercase.net.br/skin/frontend/intercase/default/images/logo-marcadagua.png" alt="" width="80" height="80" /></p>
_cHtml += '<p><img src="http://mktgen.com.br/logo-pd-medio.png" alt="" width="80" height="80" /></p>
_cHtml += '<h3 style="text-align: center;"><span style="color: #ff0000;"><strong><br /> &nbsp;<em>Importa&ccedil;&atilde;o NeoGrid - '
_cHtml += 'Relat&oacute;rio de Ocorr&ecirc;ncias e inclus&atilde;o Pedidos de Venda</em></strong></span></h3>'
_cHtml += '<p>&nbsp;</p>'
_cHtml += '<p>Este e-mail &eacute; um informativo de processamento de arquivo, sendo:</p>'
_cHtml += '<p>&nbsp;</p>'
_cHtml += '<ol>'
_cHtml += '<li>Anexo referente a processamento de arquivo (favor analisar);</li>'

if !empty(_aItens)
	
	// Se for maior que 1 estar� anexando tamb�m lOG erro.
	if _nQtArq > 1
		
		_cHtml += '<li>Arquivo de Erro processo autom�tico( Error.LOG );</li>'
		
	Endif
	
	_cHtml += '<li>Relat&oacute;rio de diferen&ccedil;as encontradas no processamento do mesmo:</li>'
	
	
Endif

_cHtml += '</ol>'
_cHtml += '<p>&nbsp;</p>'
_cHtml += '<p>&nbsp;</p>'

if !empty(_aItens)
	
	_cHtml += '<html>'
	_cHtml += '	<head>'
	_cHtml += '		<title></title>'
	_cHtml += '	</head>'
	_cHtml += '	<body>'
	_cHtml += '		<table align="left" border="1" cellpadding="1" cellspacing="1" style="width: 800px">'
	_cHtml += '			<tbody>'
	_cHtml += '				<tr>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">N&uacute;mero Pedido</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 350px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Data Entrega</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 200px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">C&oacute;digo ISBN</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Pre&ccedil;o Saraiva</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Desconto Saraiva</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Pre&ccedil;o GEN</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Dif.Pre&ccedil;o</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Desconto Gen</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Dif.Desconto</span></span></strong></em></td>'
	_cHtml += '					<td style="text-align: center; width: 120px; background-color: rgb(0, 153, 255);">'
	_cHtml += '						<em><strong><span style="font-size:10px;"><span style="font-family:arial,helvetica,sans-serif;">Quantidade</span></span></strong></em></td>'
	_cHtml += '				</tr>'
	
	// Gravando as linhas da tabela
	for _nLin := 1 to len(_aItens)
		
		_cHtml += '				<tr>'
		_cHtml += '					<td style="background-color: rgb(255, 255, 0);">'
		_cHtml += '						' + _aItens[_nLin][DIF_PEDSARAIVA] + '</td>'
		
		_cHtml += '					<td style="text-align: center; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ _aItens[_nLin][DIF_DTENTREGA] + '</td>'
		
		_cHtml += '					<td style="background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ _aItens[_nLin][DIF_CODPRODUTO] +'</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_VLRSARAIVA], "@E 999,999.99" )		 + ' </td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '					' 		+ Transform(_aItens[_nLin][DIF_DESCSARAIVA], "@E 999,999.99" ) 		+ '</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_PRCVENERP], "@E 999,999.99" ) 		+ '</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_VLRDIF], "@E 999,999.99" ) 			+ '</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_VLRDESERP], "@E 999,999.99" ) 		+ '</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_VLRDIFDESC], "@E 999,999.99" ) 		+ '</td>'
		
		_cHtml += '					<td style="text-align: right; background-color: rgb(255, 255, 0);">'
		_cHtml += '						' 	+ Transform(_aItens[_nLin][DIF_QTDESOLIC], "@E 999,999,999.9999") 	+ '</td>
		_cHtml += '				</tr>'
		
	Next
	
	_cHtml += '			</tbody>'
	_cHtml += '		</table>'
	_cHtml += '		<p style="text-align: center;">'
	_cHtml += '			&nbsp;</p>'
	_cHtml += '		<p>'
	_cHtml += '			&nbsp;</p>'
	_cHtml += '		<p>'
	_cHtml += '			&nbsp;</p>'
	_cHtml += '	<p>'
	_cHtml += '			&nbsp;</p>'
	_cHtml += '		<p>'
	_cHtml += '			&nbsp;</p>'
	_cHtml += '	</body>'
	_cHtml += '</html>'
	
Endif

_cHtml += '<p>&nbsp;</p>'
_cHtml += '<p>&nbsp;</p>'
_cHtml += '<p>&nbsp;</p>'
_cHtml += '<p>Processamento realizado em: ' + dtoc(date()) + ' - ' + time()+ '&nbsp;</p>

Return _cHtml

/*/{Protheus.doc} _ImpLOG
Imprime LOG de ocorr�ncias na importa��o NeoGrid.

@type Static function
@author Ivan Oliveira
@since 10/11/2016
@version 1.0

@param  ${_cNomeRel}, ${Caractere}, Nome do arquivo a imprimir
@param	${_aItens}  , ${Array}, Array multi-dimensional contendo as colunas que dever�o serem enviadas para usu�rio, sendo:

[01] - N�mero Pedido
[02] - C�digo produto
[03] - dt.Entrega
[04] - Cnpj Comprador
[05] - Cnpj Entrega
[06] - Mensagem erro
[07] - Nome arquivo processado
[08] - Registro aceito
[09] - Pedido Totvs
[10] - Descri��o produto

@return ${Nulo}, ${Nulo}

@example
_ImpLOG( 'Teste.Pdf', {{'123456', '000000000', '11/05/2015', '00.000.000/0000-00', '00.000.000/0000-00','erro', 'teste.txt', 'S', '12346789', 'TESTE' } } )
/*/
/*
Static Function _ImpLOG( _cNomeRel, _aItens )

Local _nQtIt           :=  0
Local _lAdjustToLegacy := .F.
Local _lDisableSetup   := .T.
Local _nMensErro       := 1

IMP_PDF := .F.

_oPrint := FWMSPrinter():New(_cNomeRel,IMP_PDF,_lAdjustToLegacy,,_lDisableSetup)

//_oPrint:SetPortrait()
_oPrint:SetLandscape()
_oPrint:SetPaperSize(9) // A4
_oPrint:cPathPDF := DIR_AUX_LOG
//Quando o tipo de impress�o for PDF, define se o arquivo ser� exibido ap�s a impress�o.
_oPrint:SetViewPDF(.f.)
_oPrint:StartPage()

_oFont := TFont():New('Courier new',,-16,.T.)
_oFont:Bold   := .T.
_oFont:Italic := .T.

_oFont2:= TFont():New( "Arial",21,-19,.F.,.T.,0,,0,.T.,.F.)
_oFont2:nHeight := 8
_oFont2:Bold := .f.

_oFont3:= TFont():New( "Arial",21,-19,.F.,.T.,0,,0,.T.,.F.)
_oFont3:nHeight := 7
_oFont3:Bold := .f.

_nCol 	 := 10
_nLin 	 := 10
_nBott	 := 60
_nRig 	 := 830
_lImpCab := .t.
_nCont   := _nPag := 0
_cDescPed:=''

for _nQtIt := 1 to len(_aItens)

if _lImpCab

_oPrint:SayBitmap( _nLin,_nCol,  GetSrvProfString("Startpath","") + 'logo-gen.bmp' ,50,50 )//"D:\Protheus\Atlas\logo-gen.bmp"
_nCol+=55

_oPrint:Box ( _nLin,_nCol, _nBott, _nRig,)
_nCol+=200
_nLin+=30

_oPrint:Say( _nLin, _nCol, "- Ocorr�ncias na Importa��o Pedidos NeoGrid - ", _oFont, 1400, CLR_HRED )
_nLin+=18
_nCol+=500
_nPag++

_oPrint:Say( _nLin,_nCol, "Pg.: "+ StrZero(_nPag,3), _oFont2, 100, CLR_BLACK )
//_lImpCab := .f.
_nCol:= 10
_nLin+= 05

// Cabe�alho
_oPrint:Box ( _nLin, _nCol, 80, _nRig,)
_nCol+= 10
_nLin+= 10

// T�tulos
_oPrint:Say( _nLin, _nCol, 		  "Ped. Compras"	, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol + 045 , "Cod.Prod/ISBN"	, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol + 135 ,"Descri��o Produto", _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol + 300 , "Pedido TOTVS"	, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol + 350 , "Ocorr�ncia"		, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol + 630 , "Arquivo Origem"	, _oFont3, 1400, CLR_BLACK )

_nLin+= 6
_nCol:= 10
_oPrint:Say(_nLin, 10, Replicate(". ",200), _oFont3, , , 90 )

_lImpCab := .f.


Endif

_nLin+= 9
_nCol:= 20

if _cDescPed <> _aItens[_nQtIt][01]

// pula uma linha para diferenciar Pedidos.
if !empty(_cDescPed)
_nLin+= 9
Endif

_oPrint:Say( _nLin, _nCol , Alltrim(_aItens[_nQtIt][LOG_PEDSARAIVA]), _oFont3, 1400, CLR_BLACK )
_cDescPed := _aItens[_nQtIt][01]

Else

_oPrint:Say( _nLin, _nCol , '   "   ', _oFont3, 1400, CLR_BLACK )

Endif

_oPrint:Say( _nLin, _nCol+ 045, Alltrim(_aItens[_nQtIt][LOG_CODPRODUTO])			, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol+ 135, Left(Alltrim(_aItens[_nQtIt][LOG_DESCPRODUTO]),25)	, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol+ 300, Alltrim(_aItens[_nQtIt][LOG_PEDIDOERP])				, _oFont3, 1400, CLR_BLACK )
_oPrint:Say( _nLin, _nCol+ 630, Alltrim(_aItens[_nQtIt][LOG_NOMEARQPROC])			, _oFont3, 1400, CLR_BLACK )

_cMenErro := Alltrim(_aItens[_nQtIt][LOG_MENSAGEMERRO])

for _nMensErro := 1 to len(_cMenErro)

_oPrint:Say( _nLin, _nCol+ 350, SubsTr(_cMenErro,_nMensErro,85 ), _oFont3, 1400, CLR_BLACK )
_nLin+= 7
_nMensErro+=85

Next
_nCont++

// Controle por p�gina
if _nCont > 55

_nCol 	 := 10
_nLin 	 := 10
_nBott	 := 60
_nRig 	 := 830
_lImpCab := .t.
_nCont   := 0
_oPrint:EndPage()
_oPrint:StartPage()
_lImpCab:= .t.

Endif

Next

// Final p�gina de impress�o
_oPrint:EndPage()
_oPrint:Print()

// Finalizando o objeto impress�o
FreeObj(_oPrint)
_oPrint := Nil

// Copia arquivo do remote local para o servidor, sem compactar antes de transmitir
CpyT2S( DIR_AUX_LOG + _cNomeRel, "\Spool\", .F. )

// Apaga o arquivo tempor�rio remote local
Ferase(DIR_AUX_LOG + _cNomeRel)

Return
*/
Static Function _ImpLOG( _cNomeRel, _aItens )

Local _oExcel := FWMSEXCEL():New()

_oExcel:AddworkSheet("Planilha1")
_oExcel:AddTable ("Planilha1","Processamento")
_oExcel:AddColumn("Planilha1","Processamento","Ped.Cliente",1,1,.F.)
_oExcel:AddColumn("Planilha1","Processamento","Cod.Prod/ISBN",1,1,.F.)
_oExcel:AddColumn("Planilha1","Processamento","Descri��o",1,1,.F.)
_oExcel:AddColumn("Planilha1","Processamento","Ped.Protheus",1,1,.F.)
_oExcel:AddColumn("Planilha1","Processamento","Arquivo",1,1,.F.)
_oExcel:AddColumn("Planilha1","Processamento","Ocorr�ncia",1,1,.F.)

for _nQtIt := 1 to len(_aItens)
	
	_oExcel:AddRow("Planilha1","Processamento",	{Alltrim(_aItens[_nQtIt][LOG_PEDSARAIVA]);
	,Alltrim(_aItens[_nQtIt][LOG_CODPRODUTO]);
	,Left(Alltrim(_aItens[_nQtIt][LOG_DESCPRODUTO]),25);
	,Alltrim(_aItens[_nQtIt][LOG_PEDIDOERP]);
	,Alltrim(_aItens[_nQtIt][LOG_NOMEARQPROC]);
	,Alltrim(_aItens[_nQtIt][LOG_MENSAGEMERRO]);
	})
Next

_oExcel:Activate()

_oExcel:GetXMLFile(DIR_AUX_LOG+_cNomeArq)

// Copia arquivo do remote local para o servidor, sem compactar antes de transmitir
//CpyT2S( DIR_AUX_LOG + _cNomeRel, "\Spool\", .F. )

// Apaga o arquivo tempor�rio remote local
//Ferase(DIR_AUX_LOG + _cNomeRel)

Return

/*/{Protheus.doc} _VerPed
Monta Corpo do e-mail para envio de notifica��o advert�ncia quanto a inclus�o de pedidos de vendas

@type Static function
@author Ivan Oliveira
@since 10/11/2016
@version 1.0

@param ${_cNumPed}, ${Caractere}, Numero do Pedido passado por refer�ncia.

@return ${_lRet}  , ${L�gico}, Retorno se conseguiu encontrar ou n�o pedido de venda emitido.

@example _VerPed('0123456789')
/*/
Static Function _VerPed( _cNumPed, _cPedNeoGrid )

//  �ltima querie executada ->>> GetLastQuery()[2]
_cAlias := GetNextAlias()


BEGINSQL ALIAS _cAlias
	
	%noParser%
	
	SELECT  C5_NUM
	
	FROM
	%Table:SC5% SC5
	WHERE
	C5_FILIAL	   =  %XFilial:SC5%
	AND C5_XPEDCLI =  %Exp:_cPedNeoGrid%
	AND SC5.%notDel%
ENDSQL

// Incluindo as linhas
(_cAlias)->( DbGotop() )

if !(_cAlias)->( Eof() )
	
	_cNumPed := (_cAlias)->C5_NUM
	
Endif

(_cAlias)->(DbCloseArea())

Return !empty(_cNumPed)
