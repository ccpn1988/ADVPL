//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zTransNum
Fun��o para convers�o de valor num�rico para texto conforme quantidade de decimais informada 
@author Daniel Atilio
@since  05/06/2014
@version 1.0
	@param nValor,		Num�rico, Valor que ser� convertido
	@param nTotal,		Num�rico, Quantidade total de casas
	@param nDec,		Num�rico, Quantidade de casas decimais
	@param lConsDec,	L�gico,   Considera a quantidade de decimais no tamanho final
	@return cTexto, Conte�do texto da convers�o
	@example
	u_zTransNum(15.23, 5, 2)
/*/
 
User Function zTransNum(nValor, nTotal, nDec, lConsDec)
	Local cMascara := "@E 9,999,999,999,999,999,999"
	Local cTexto := ""
	Default lConsDec := .F.
	
	//Decimais
	cMascara += "."+Replicate('9',nDec)
	
	//Transformando conforme m�scara
	cTexto := Alltrim(Transform(nValor,cMascara))
	
	//Retirando ponto e v�rgula
	cTexto := StrTran(cTexto,',','')
	cTexto := StrTran(cTexto,'.','')
	
	//Colocando zeros a esquerda
	cTexto := StrZero(Val(cTexto),nTotal+Iif(lConsDec, nDec, 0))
	
/*	MsgInfo(	'nValor: '+cValToChar(nValor)+Chr(13)+Chr(10)+;
				'cMascara: '+cMascara+Chr(13)+Chr(10)+;
				'cTexto: '+cTexto+Chr(13)+Chr(10)+;
				'nTotal: '+cValToChar(nTotal)+Chr(13)+Chr(10)+;
				'nDec: '+cValToChar(nDec))*/
Return cTexto