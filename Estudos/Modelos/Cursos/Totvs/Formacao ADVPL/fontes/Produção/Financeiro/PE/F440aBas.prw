
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F440ABAS  �Autor  �Cleuto Lima         � Data �  28/03/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada no fonte FINA440.PRX para manipular       ���
���          � o array aBase no calcululo de comiss�o.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Gen                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function F440aBas()

Local abases		:= {} 
Local nLenAux		:= 0    
Local nAuxClone		:= 0 
Local nAuxCompat	:= 0

/* <26983> */
/* Cleuto Lima - 28/03/2016
Chamado: 26983
O fonte padr�o FINA440.PRX contem uma falha de progra��o no calculo da base de comiss�o que est� montando o array aBase com apenas 7 posi��es.
Este tratamento foi inclido para compatibilizar o array aBase com 11 posi��es pava evitar erro ao acessar as posi��es acima de [7]
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