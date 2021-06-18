// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ExpSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 13/04/19 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a geração de um arquivo formato texto usando a uma tabela como fonte de dados.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
user function ExpSB1()
	local oDlgGeraTxt
	
	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgGeraTxt title "Geração de Arquivo Texto"
	@ 02, 10 to 65, 180
	
	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa gera um arquivo texto, conforme parametros"
	@ 18, 18 say "definidos pelo desenvolvedor ou usuário."
	@ 34, 18 say "Fonte de dados:"
	@ 34, 80 say "SB1"
	
	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgGeraTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgGeraTxt)
	activate dialog oDlgGeraTxt centered
	
	
return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execução do processo de exportação.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
static function doIt()
	local nHdl
	local cArqTxt := "\data\DadosSB1.CSV"
	
	//--< cria o arquivo de saida >-------------------------------------------------------------
	nHdl := fCreate(cArqTxt)
	if nHdl == -1
		msgAlert("Não foi possível criar o arquivo de saída."+chr(13)+"Favor verificar parâmetros.", "Atenção.")
	else
		//--< inicializa a regua de processamento >-------------------------------------------------
		Processa({|| doProcess(nHdl) }, "Processando...")
	endif
	//--< encerramento >------------------------------------------------------------------------
	fClose(nHdl)
	nDhl := nil
	
return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processo de exportação.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
static function doProcess(nHdl)
	
	//Variáveis
	local cLin, cCpo
	local nRecLote, nLenLote
	local cEOL := chr(13) + chr(10)
	
	//--< posicionamento do primeiro registro e loop principal >--------------------------------
	/*
	* Posicione no primeiro registro da filial corrente e processe
	* enquanto a filial do registro for a filial corrente. Por exemplo:
	*   dbSeek(xFilial())
	*   while !eof() .and. xFilial() == ??_FILIAL
	*   ...
	*/
	//------------------------------------------------------------------------------------------
	
	//Recomenda-se o uso de procRegua usando 100 (representando 100%)
	nLenLote := recCount()
	if nLenLote > 100
		procRegua(100)
		nLenLote := int(nLenLote * 0.05)
	else
		procRegua(nLenLote)
	endif
	nRecLote := 0
	
	//--< leiaute do arquivo de saída >---------------------------------------------------------
	// [%s] Campo obrigatório. |     Inicio |    Tamanho
	//------------------------------------------------------------------------------------------
	// ??_FILIAL       |       0001 |       0002
	//------------------------------------------------------------------------------------------
	
	
	dbGoTop()
	while !eof()
		//Para melhor performance, recomenda-se o uso de incProc em lotes de registro
		if (nRecLote > nLenLote)
			incProc()
			nRecLote := 0
		endif
		
		//grava o buffer no arquivo de saida
		cLin := cLin + cEOL
		if fWrite(nHdl, cLin, len(cLin)) != len(cLin)
			if !msgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atenção.")
				exit
			endif
		endif
		
		nRecLote++
		dbSkip()
	endDo
	
return
//--< fim de arquivo >----------------------------------------------------------------------
