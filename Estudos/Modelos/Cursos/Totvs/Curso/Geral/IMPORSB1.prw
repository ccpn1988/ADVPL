// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : IMPORSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 06/10/18 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     6/10/2018
/*/
//------------------------------------------------------------------------------------------
user function IMPORSB1()
	local oDlgLeTxt
	
	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgLeTxt title "Geração de Arquivo Texto"
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
@since     6/10/2018
/*/
//------------------------------------------------------------------------------------------
static function doIt()
local nHdl
local cArqTxt := cGetFile() //cGetFile() - Abre uma caixa de dialogo do windows solicitando onde esta o arquivo. | "C:\Arquivo.txt"
	
	if ! File(cArqTxt) //Se o arquivo não for valido
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
@since     6/10/2018
/*/
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
static function doProcess(cArqTxt)
Local   aDados
Local   nReg        := 0	
Local   aVetor      := {} //Cria a matriz aVetor
Private lMsErroAuto := .F. //Informa se tem erro no execauto

RPCSETENV("99","01")

	ft_fuse(cArqTxt) //ft_fuse - Função para abrir o arquivo cArqTxt
	ft_fgotop()      // Posiciona na primeira linha do arquivo
	
	
	
	While ! ft_feof() //Verifica se não é o fim do arquivo
		
		aDados := StrToKarr2(ft_freadln(),";",.T.) //StrToKarr2 - Faz a quebra do ; | ft_freadln() - le a linha | 000001;PROD.ACABADO 1;UN;"";01
		
	// aDados[1] => 000001 
	// aDados[2] => PROD. ACABADO 1
	// aDados[3] => UN 
	// aDados[4] => ""
	// aDados[5] => 01
	// aDados[6] => PA
	// aDados[7] => ""
	
		
				
	// Exercício gravar os dados no banco
//		RecLock("SB1",.T.)
//		
//			SB1->B1_COD    := aDados[1]
//			SB1->B1_DESC   := aDados[2]
//			SB1->B1_UM     := aDados[3]
//			SB1->B1_GRUPO  := aDados[4]
//			SB1->B1_LOCPAD := aDados[5]
//			SB1->B1_TIPO   := aDados[6]
//			SB1->B1_POSIPI := aDados[7]
//		
//		MsUnlock()
//	nReg++
//	ft_fskip() //Pula para o proximo resgistro
	
		aVetor:= { {"B1_COD"   ,aDados[1],NIL},; //Campos da matriz - campo - codigo - vazio 
	               {"B1_DESC"  ,aDados[2],NIL},; 
	 			   {"B1_UM"    ,aDados[3],Nil},; 
				   {"B1_GRUPO" ,aDados[4],Nil},; 
				   {"B1_LOCPAD",aDados[5],Nil},; 
				   {"B1_TIPO"  ,aDados[6],Nil},; 
				   {"B1_POSIPI",aDados[7],Nil}}  
	  
	MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Seta o comando execauto
	               // Adicionar a rotina padrão  a ser executada o execauto
	                             // Adicionar a matriz e a operação (3 inclusão, 4 alteração, 5 exclusão) 	
	
	If lMsErroAuto
		MostraErro() //MostraErro() - função que cria a tela de erro
		lMsErroAuto := .F.
	Endif

	ft_fskip() //pula linha
				
	EndDo	
	
	
	
	
	
	//MsgInfo("Foram importados " + cValToChar(nReg) + " registros!")
	
	
return
//--< fim de arquivo >----------------------------------------------------------------------

