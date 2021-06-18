// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : EXPORSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 06/10/18 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a geração de um arquivo formato texto usando a uma tabela como fonte de dados.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     6/10/2018
/*/
//------------------------------------------------------------------------------------------
user function EXPORSB1()
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
@since     6/10/2018
/*/
//------------------------------------------------------------------------------------------
static function doIt()
	local nHdl
	local cArqTxt := "C:\Relatorio\Arquivo.txt"
	
//	//--< procedimentos >-----------------------------------------------------------------------
//	cAlias := "SB1"
//	chkFile(cAlias)
//	dbSelectArea(cAlias)
//	//indices
//	dbSetOrder(1)
	
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
	nHdl := nil
	
return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processo de exportação.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     6/10/2018
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
	
	dbSelectArea("SB1")
	dbGoTop()
	while !eof()
		//Para melhor performance, recomenda-se o uso de incProc em lotes de registro
		if (nRecLote > nLenLote)
			incProc(SB1->B1_COD) //Mostra na tela o registro sendo executado
			nRecLote := 0
		endif
	
		//prepara buffer para receber os dados
	    cLin := ALLTRIM(SB1->B1_COD   ) + ";" 
	    cLin += ALLTRIM(SB1->B1_DESC  ) + ";" 
	    cLin += ALLTRIM(SB1->B1_UM    ) + ";" 
	    cLin += ALLTRIM(SB1->B1_GRUPO ) + ";" 
	    cLin += ALLTRIM(SB1->B1_LOCPAD) + ";"
	    cLin += ALLTRIM(SB1->B1_TIPO  ) + ";"
	    cLin += ALLTRIM(SB1->B1_POSIPI) + cEOL
	    
	    
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
