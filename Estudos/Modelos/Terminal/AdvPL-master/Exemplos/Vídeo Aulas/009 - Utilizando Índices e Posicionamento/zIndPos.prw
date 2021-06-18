//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} zIndPos
Fun��o de exemplo de �ndices e posicionamento
@type function
@author Atilio
@since 18/11/2015
@version 1.0
	@example
	u_zIndPos()
/*/

User Function zIndPos()
	Local aArea := GetArea()
	Local cDescri := ""
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //Nesta fun��o, parametrizo que irei utilizar o �ndice 1... ap�s o 9, na tabela de �ndices ser� gravado A (10), B (11), C (12)...
	SB1->(DbGoTop()) //Garantindo que ap�s a ordena��o, minha tabela fique no topo
	
	//Posicionando conforme DbSeek, onde passo os campos na sequ�ncia do �ndice... utilizamos a FWxFilial que retorna a filial atual para essa tabela
	If SB1->(DbSeek(FWxFilial('SB1') + 'E00001'))
		MsgInfo("Descri��o 1: "+SB1->B1_DESC, "Aten��o")
	EndIf
	
	//Tamb�m posso utilizar o DbOrderNickName, caso o �ndice tenha um apelido, por exemplo:
	//SE1->(DbOrderNickName("TITPAI"))
	
	//Por �ltimo, existe tamb�m a fun��o Posicione, que me retorna um campo qualquer da tabela
	cDescri := Posicione(	'SB1',;						//Alias da Tabela
								1,;								//�ndice de pesquisa
								FWxFilial('SB1')+'E00002',;	//Chave da Pesquisa
								'B1_DESC')						//Campo de retorno
	MsgInfo("Descri��o 2: "+cDescri, "Aten��o")
	
	RestArea(aArea)
Return