
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF440ABAS  บAutor  ณCleuto Lima         บ Data ณ  28/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada no fonte FINA440.PRX para manipular       บฑฑ
ฑฑบ          ณ o array aBase no calcululo de comissใo.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Grupo Gen                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function F440aBas()

Local abases		:= {} 
Local nLenAux		:= 0    
Local nAuxClone		:= 0 
Local nAuxCompat	:= 0

/* <26983> */
/* Cleuto Lima - 28/03/2016
Chamado: 26983
O fonte padrใo FINA440.PRX contem uma falha de progra็ใo no calculo da base de comissใo que estแ montando o array aBase com apenas 7 posi็๕es.
Este tratamento foi inclido para compatibilizar o array aBase com 11 posi็๕es pava evitar erro ao acessar as posi็๕es acima de [7]
 */
For nAuxClone := 1 To Len(paramixb)

	Aadd(abases, aClone(paramixb[nAuxClone]) )
    
    nLenAux := Len(abases[nAuxClone])
    If nLenAux < 11
		For nAuxCompat := nLenAux To 11
			If Len(abases[nAuxClone]) < 11
				Aadd(abases[nAuxClone], 0 )
			EndIF	
		Next
	EndIf
		
Next
/* </26983> */

Return abases