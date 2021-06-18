// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : impSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 13/04/19 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
user function ExecSB1()

	/*FUNÇÂO PARA SIMULAR ABERTURA DO SISTEMA*/
	local oDlgLeTxt
	
	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgLeTxt title "Importação de Arquivo Texto"
	@ 02, 10 to 65, 180
	
	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa ira ler o conteudo de um arquivo texto, conforme"
	@ 18, 18 say "definidos pelo desenvolvedor ou usuário."
	@ 34, 18 say "Destino dos dados:"
	@ 34, 80 say "SB1"
	
	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgLeTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgLeTxt)
	activate dialog oDlgLeTxt centered
	
	
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
	local cArqTxt := cGetFile()

	//--< abre o arquivo de entrada >-----------------------------------------------------------
	if ! File(cArqTxt)
		msgAlert("Não foi possível abrir o arquivo de entrada."+chr(13)+"Favor verificar parâmetros.", "Atenção.")
	else
		//--< inicializa a regua de processamento >-------------------------------------------------
		Processa({|| doProcess(cArqTxt) }, "Processando...")
	endif
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
static function doProcess(Arquivo)
	
	Local aDados := {}
	Local nOpc   := 3 // Incluir
	Local cLinha := ""
	/*CRIA UMA RRAY DEVIDO A CAMPOS QUE FORAM PREENCHIDOS SEM CONTEUDO EM NOSSO ARQUIVO*/
	Local aDadosExec := {}
	Private lMsErroAuto := .F.
	
	ft_fuse(Arquivo)
	ft_fgotop()
	ft_fskip()//PULA CABEÇALHO

	/*FUNÇÂO PARA SIMULAR ABERTURA DO SISTEMA*/
	RpcSetEnv("99","01")
	while !(ft_feof())
		cLinha := ft_freadln()
		aDados := strtokarr2(cLinha,";",.T.)
		
		aDadosExec:= {{"B1_FILIAL",xFilial("SB1"),NIL},;
			 {"B1_COD",aDados[1],NIL},;
             {"B1_DESC",aDados[2],NIL},;
             {"B1_LOCPAD",aDados[3],Nil},;
             {"B1_GRUPO",aDados[4],Nil},;
             {"B1_UM",aDados[5],Nil},;
             {"B1_TIPO" ,aDados[6],Nil}}

		MSExecAuto({|x,y| Mata010(x,y)},aDadosExec,nOpc)

		If lMsErroAuto
			MostraErro()
		Else
			lMsErroAuto := .F.
			//Alert("Produto Incluido com sucesso!!!!")
		Endif
	
		ft_fskip()
	EndDo
return
//--< fim de arquivo >----------------------------------------------------------------------
