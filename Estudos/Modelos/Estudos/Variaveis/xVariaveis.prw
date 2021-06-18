#include 'protheus.ch'
#include 'parmtype.ch'

user function xVariav()
	Local aArea := GetArea()
	
	//DECLARANDO VARIAVEIS
	Local nValor := 0
	Local dData := Date()
	Local lTeste := .T.
	Local cTexto := "Terminal de Informação"
	Local oObjeto := TFont():New("Tahoma")
	Local xInfo := 0
	Local aDados := {"Daniel", "Atilio",dData}
	Local bBloco1 := {|| 		nValor := 1,;
								Alert("Valor é igual: " + cValToChar(nValor))}
	Local bBloco2 :={|nValor| nValor += 2,;
								Alert("Valor é igual: " + cValToChar(nValor))}

//IMPIME BLOCO DE CÓDIGO
	Eval(bBloco1)
	Eval(bBloco2, 5)//ACRESCENTA O VALOR DEFINIDO em bBloco2 com 5
	MsgAlert(aDados[1])
	
//ALTERANDO VALORES
	xInfo := "TESTE" //VARIAVEL DECLARADA COM x NÃO TEM TIPO PODENDO SER ALTERADA
	
	RestArea(aArea)
Return