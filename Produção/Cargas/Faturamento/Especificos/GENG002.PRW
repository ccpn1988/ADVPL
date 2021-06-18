#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENG002   ºAutor  ³ Joni Fujiyama      º Data ³  23/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para calcular o peso, qtde e valor no pedido de ven- º±±
±±º          ³da.								                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Parâmetros:
_cOpcao:	1=Peso
2=Quantidade
3=Peso
*/

User Function GENG002(_cOpcao)

Local _aArea	:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local _nRet 	:= 0.00
Local na		:= 0
Local nPrd		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_PRODUTO"})
Local nQtd		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_QTDVEN"})
Local nPrc		:= ascan(aHeader,{|x| alltrim(x[2])=="C6_PRCVEN"})

//Percorre todos os itens do Acols
For na := 1 to LEN(aCols)
	//Considera somente os validados
	IF !GDDeleted(na)
		//Pesquisa por produto
		DBSelectArea("SB1")
		DbSetOrder(1)
		IF DBSEEK(xfilial("SB1") + aCols[na][nPrd] )
			If _cOpcao = "1" //Atualiza peso
				_nRet := _nRet + (SB1->B1_PESO * aCols[na][nQtd])
			ElseIf _cOpcao = "2" //Atualiza quantidade
				_nRet := _nRet + aCols[na][nQtd]
			Else //Atualiza preço
				_nRet := _nRet + (aCols[na][nQtd] * aCols[na][nPrc])
			Endif
		Endif
	Endif
Next

RestArea(aAreaSB1)
RestArea(_aArea)

Return _nRet
