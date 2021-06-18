// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : IMPSB1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 13/04/19 | TOTVS | Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Leitura de Arquivo Texto

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
user function IMPSB1()
	local oDlgLeTxt
	
	//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgLeTxt title "Importa��o de Arquivo Texto"
	@ 02, 10 to 65, 180
	
	//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa ira ler o conteudo de um arquivo texto, conforme"
	@ 18, 18 say "definidos pelo desenvolvedor ou usu�rio."
	@ 34, 18 say "Destino dos dados:"
	@ 34, 80 say "SB1"
	
	@ 68, 128 bmpButton type 01 action eval({ || doIt(), close(oDlgLeTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgLeTxt)
	activate dialog oDlgLeTxt centered
	
	
return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execu��o do processo de exporta��o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
static function doIt()
	local nHdl
	local cArqTxt := cGetFile()
	
	
	//--< abre o arquivo de entrada >-----------------------------------------------------------
	if !File(cArqTxt)
		msgAlert("N�o foi poss�vel abrir o arquivo de entrada."+chr(13)+"Favor verificar par�metros.", "Aten��o.")
	else
		//--< inicializa a regua de processamento >-------------------------------------------------
		Processa({|| doProcess(cArqTxt) }, "Processando...")
	endif
	
return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processo de exporta��o.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     13/04/2019
/*/
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
static function doProcess(CSV)
	Local cLine := ""
	Local aDados:= {}
	
      ft_fuse(CSV)
      ft_fGotop() //incio do arquivo
      ft_fskip()//Pula o cabec
      
      dbSelectArea ("SB1")
      dbSetOrder(1)
          
While ! ft_feof() 

        cLinha := ft_freadln() //Lendo a linha
        aDados := StrTokarr2(cLinha,";",.T.)
        MsgInfo(aDados[2])          
     
    If !MsSeek(xFilial("SB1") + aDados[1])
   
    RecLock ("SB1",.T.) //Incluir  
    
     	 SB1->B1_FILIAL := xFilial("SB1") 	 
         SB1->B1_COD    := aDados[1]
         SB1->B1_DESC   := aDados[2]
         SB1->B1_LOCPAD := aDados[3]
         SB1->B1_GRUPO  := aDados[4]
         SB1->B1_UM     := aDados[5]
         SB1->B1_TIPO   := aDados[6]         
    
    MsUnlock()//Libera o registro
    
   EndIf
      ft_fskip() //Pula Linha     
EndDo
Return