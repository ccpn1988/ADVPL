#include 'protheus.ch'
#include 'parmtype.ch'

user function xVariav()
	Local aArea := GetArea()
	
	//DECLARANDO VARIAVEIS
	Local nValor := 0
	Local dData := Date()
	Local lTeste := .T.
	Local cTexto := "Terminal de Informa��o"
	Local oObjeto := TFont():New("Tahoma")
	Local xInfo := 0
	Local aDados := {"Daniel", "Atilio",dData}
	Local bBloco1 := {|| 		nValor := 1,;
								Alert("Valor � igual: " + cValToChar(nValor))}
	Local bBloco2 :={|nValor| nValor += 2,;
								Alert("Valor � igual: " + cValToChar(nValor))}

//IMPIME BLOCO DE C�DIGO
	Eval(bBloco1)
	Eval(bBloco2, 5)//ACRESCENTA O VALOR DEFINIDO em bBloco2 com 5
	MsgAlert(aDados[1])
	
//ALTERANDO VALORES
	xInfo := "TESTE" //VARIAVEL DECLARADA COM x N�O TEM TIPO PODENDO SER ALTERADA
	
	RestArea(aArea)
Return