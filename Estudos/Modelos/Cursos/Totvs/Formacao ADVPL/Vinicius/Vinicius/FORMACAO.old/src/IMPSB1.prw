// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : IMPSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 13/04/19 | TOTVS | Developer Studio | Gerado pelo Assistente de C?digo
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C?digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
user function IMPSB1()
	local oDlgLeTxt
	Local aDados := {}
	Local nOpc   := 3 // Incluir
	Private lMsErroAuto := .F.
	
	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgLeTxt title "Importa??o de Arquivo Texto"
	@ 02, 10 to 65, 180
	
	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa ira ler o conteudo de um arquivo texto, conforme"
	@ 18, 18 say "definidos pelo desenvolvedor ou usu?rio."
	@ 34, 18 say "Destino dos dados:"
	@ 34, 80 say "SB1"
	
	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgLeTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgLeTxt)
	activate dialog oDlgLeTxt centered
	
	
return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execu??o do processo de exporta??o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C?digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
static function doIt()
	local nHdl
	local cArqTxt := cGetFile() //"C:\Arquivo.txt"

	//--< abre o arquivo de entrada >-----------------------------------------------------------
	
	if ! file(cArqTxt)
		msgAlert("N?o foi poss?vel abrir o arquivo de entrada."+chr(13)+"Favor verificar par?metros.", "Aten??o.")
	else
		//--< inicializa a regua de processamento >-------------------------------------------------
		Processa({|| doProcess(cArqtxt) }, "Processando...")
	endif
	
return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processo de exporta??o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C?digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
static function doProcess(TXT)
	Local cLinha:=""
	Local Dados := {}
	Local nOpc   := 3 // Incluir
	Private lMsErroAuto := .F.
	
	ft_fuse(TXT)
	ft_fgotop()//inicio do arquivo
	ft_fskip()//pula o cabe?alho
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
while  ! ft_feof()
	clinha := ft_freadln() //lendo a linha
	aDados := strtokarr2(cLinha,";",.T.)
	//RpcSetEnv("99","01")
	
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" 

	Dados:= {{"B1_FILIAL",xFilial("SB1"),Nil},;
			 {"B1_COD"  ,aDados[1] ,NIL},;
             {"B1_DESC"  ,aDados[2] ,NIL},;
             {"B1_LOCPAD",aDados[3] ,Nil},;
             {"B1_GRUPO" ,aDados[4] ,Nil},;
             {"B1_UM"    ,aDados[5] ,Nil},;
             {"B1_TIPO"  ,aDados[6] ,Nil}}
 
	MSExecAuto({|x,y| Mata010(x,y)},Dados,nOpc)

	If lMsErroAuto
		MostraErro()
		lMsErroAuto := .F.		
		//Alert("Produto Incluido com sucesso!!!!")
	Endif
	
	/*If ! Msseek(xFilial("SB1")+ aDados[1])
	MsgInfo(aDados[2])
	
	RecLock("SB1",.T.)
	SB1->B1_COD:= aDados[1]
    SB1->B1_DESC:= aDados[2]
    SB1->B1_LOCPAD:= aDados[3]
    SB1->B1_GRUPO:= aDados[4]
    SB1->B1_UM:= aDados[5]
   	SB1->B1_TIPO:= aDados[6]
  	MsUnLock()
  	endif*/
  	
	ft_fskip()// pula linha
enddo	
return
//--< fim de arquivo >----------------------------------------------------------------------
