#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} AVETOR
//TODO Descri��o auto-gerada.
@author rcti treinamentos
@since 2018
@version undefined

@type function
/*/
user function AVETOR()
	// Arrays: S�O COLE��ES DE VALORES, SEMELHANTES A UMA LISTA
	//CADA ITEM EM UM ARRAY � REFERENCIADO PELA INDICA��O DE SUA POSICAO NUMERICA, INICIANDO PELO NUMERO 1.
	Local dData := Date()
	Local aValores := {"Jo�o",dData,100}
	
	Alert(aValores[2]) //Exibe a posicao 2 do array 
	Alert(aValores[3])
	
return