//BIBLIOTECAS
#include 'protheus.ch'
#include 'parmtype.ch'
/*
[BIBLIOTECAS == INCLUDES]
[CONSTANTES DECLARADAS (NAO MUDAM) - DEFINES]
*/

//CONSTANTES
#DEFINE STR_PULA Chr(13)+Chr(10) //SIMULA ENTER

/*/DECLARAÇÃO DO PROJETO
EXEMPLO DE CORPO DE PROGRAMA
AUTHOR: CAIO NEVES
DATA: 23/04/2019
NOME: U_XCONCEITOS
/*/

User Function xConceitos()
	//{DECLARAÇÃO DE VARIAVEIS}
	Local aArea := GetArea() //RESERVA A AREA
	Local cHora := Time()
	
	//{LÓGICA DE PROGRAMAÇÃO}
	MsgInfo("Hora Atual: " + STR_PULA + cHora, "Horário")
		
	//{ENCERRAMENTO DE VARIÁVEIS}
	RestArea(aArea)//ENCERRA A AREA RESERVADA
return

//--------------------------------------------------------------------------------

