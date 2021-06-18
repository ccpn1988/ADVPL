#include "rwmake.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUMOEDA  บAutor  ณDanilo Azevedo      บ Data ณ  06/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza moedas (SM2) a partir de informacoes do Banco Cen- บฑฑ
ฑฑบ          ณtral (BACEN).                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Schedule                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AtuMoeda()

Private lAuto := .F.
Private lErro := lErro := .F.
Private dDataRef
Private dData := ctod("01/01/2014")
Private nValDolar := 0
Private nValFrS := 0
Private nValLib := 0
Private nValEuro := 0

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	lAuto := .T.
	RPCSetType(3)
	//RpcSetEnv('00','1001',,,,GetEnvServer(),{"SM2"})
	RESET ENVIRONMENT
	Prepare Environment EMPRESA "00" FILIAL "1001"
	//sleep(6000)
	ConOut('### ATUMOEDA ###   Atualizando Moedas... '+DTOC(DATE())+' - '+Time())
EndIf

If (!lAuto)
	If MsgYesNo("Esta rotina foi desenvolvida para executar automaticamente. Deseja executar manualmente assim mesmo?","Aten็ใo")
		MsgRun(OemToAnsi("Atualiza็ใo online - Banco Central do Brasil"),"Processando",{|| ExecBacen()} )
		MsgInfo("Processo concluํdo.","Aten็ใo")
	Endif
Else
	ExecBacen()
	//RpcClearEnv()
	RESET ENVIRONMENT
	ConOut('### ATUMOEDA ###   Moedas Atualizadas... '+DTOC(DATE())+' - '+Time())
EndIf

Return()


Static Function ExecBacen()

Local nPass, cFile, cTexto, nLinhas, cLinha, cData, cCompra, cVenda

For nPass := 10 to 0 step -1		//Refaz os ultimos 6 dias. O BCB nao disponibiliza periodo anterior a uma semana.
	dDataRef := dDataBase - nPass
	
	If Dow(dDataRef) == 1	//Domingo
		cFile := Dtos(dDataRef - 2)+'.csv'
	ElseIf Dow(dDataRef) == 7	//Sabado
		cFile := Dtos(dDataRef - 1)+'.csv'
	Else
		cFile := Dtos(dDataRef)+'.csv'
	EndIf
	
	If (lAuto)
		ConOut('### ATUMOEDA ###   Obtendo arquivo: '+cFile+' - '+DTOC(DATE()))
	EndIf
	
	cTexto  := HttpGet('https://www4.bcb.gov.br/Download/fechamento/'+cFile)
	
	If !Empty(cTexto) .and. substr(cTexto,1,1) <> '<' //Trata arquivo vazio ou nao encontrado (caso de feriados, etc.)
		nLinhas := MLCount(cTexto)
		For J := 1 to nLinhas
			cLinha	:= Memoline(cTexto,,j)
			cData  	:= Substr(cLinha,1,10)
			dData	:= CTOD(cData)
			
			cCompra := StrTran(Substr(cLinha,22,10),',','.')	//Caso a empresa use o Valor de Compra, nas linhas abaixo substitua por esta variavel
			cVenda  := StrTran(Substr(cLinha,33,10),',','.')	//Para conversใo interna nas empresas normalmente usa-se Valor de Venda
			
			If (Substr(cLinha,12,3)=='220')		//Seleciona o Valor do Dolar
				nValDolar	:= Val(cVenda)
			ElseIf (Substr(cLinha,12,3)=='425')	//Seleciona o Valor do Franco Suico
				nValFrS		:= Val(cVenda)
			ElseIf (Substr(cLinha,12,3)=='540')	//Seleciona o Valor da Libra Esterlina
				nValLib		:= Val(cVenda)
			ElseIf (Substr(cLinha,12,3)=='978')	//Seleciona o Valor do Euro
				nValEuro	:= Val(cVenda)
			EndIf
		Next J
		
		//Grava Moedas
		DbSelectArea("SM2")
		SM2->(DbSetorder(1))
		
		If SM2->(DbSeek(dData))
			Reclock('SM2',.F.)
		Else
			Reclock('SM2',.T.)
			SM2->M2_DATA:=dData
		EndIf
		SM2->M2_MOEDA1	:= 1					//Real
		SM2->M2_MOEDA2	:= nValDolar			//Dolar
		SM2->M2_MOEDA3	:= nValFrS				//Franco Suico
		SM2->M2_MOEDA4	:= nValEuro				//Euro
		SM2->M2_MOEDA5	:= nValLib				//Libra Esterlina
		SM2->M2_INFORM	:= "S"
		MsUnlock('SM2')
		
		If Dow(dData) == 6 //SE FOR SEXTA FEIRA, REPLICA VALORES PARA SABADO E DOMINGO

			dData++ //GRAVA SABADO
			If SM2->(DbSeek(dData))
				Reclock('SM2',.F.)
			Else
				Reclock('SM2',.T.)
				SM2->M2_DATA:=dData
			EndIf
			SM2->M2_MOEDA1	:= 1					//Real
			SM2->M2_MOEDA2	:= nValDolar			//Dolar
			SM2->M2_MOEDA3	:= nValFrS				//Franco Suico
			SM2->M2_MOEDA4	:= nValEuro				//Euro
			SM2->M2_MOEDA5	:= nValLib				//Libra Esterlina
			SM2->M2_INFORM	:= "S"
			MsUnlock('SM2')

			dData++ //GRAVA DOMINGO
			If SM2->(DbSeek(dData))
				Reclock('SM2',.F.)
			Else
				Reclock('SM2',.T.)
				SM2->M2_DATA:=dData
			EndIf
			SM2->M2_MOEDA1	:= 1					//Real
			SM2->M2_MOEDA2	:= nValDolar			//Dolar
			SM2->M2_MOEDA3	:= nValFrS				//Franco Suico
			SM2->M2_MOEDA4	:= nValEuro				//Euro
			SM2->M2_MOEDA5	:= nValLib				//Libra Esterlina
			SM2->M2_INFORM	:= "S"
			MsUnlock('SM2')

		Endif
		
	Else
		If lAuto
			Conout('### ATUMOEDA ###   ERRO AO PROCESSAR DATA '+DTOC(dDataRef))
		Else
			MsgBox("Erro ao processar data "+DTOC(dDataRef)+".","Aten็ใo")
		Endif
	Endif
	
Next nPass

Return()
