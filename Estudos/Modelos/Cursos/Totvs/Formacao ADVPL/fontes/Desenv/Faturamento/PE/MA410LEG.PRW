
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG  �Autor  �Cleuto Lima         � Data �  04/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para alterar cores da legenda             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA410LEG()

Local aCores	:= aClone(ParamIXB)
                                  
If aScan(aCores, {|x| x[1] == "BR_AMARELO" } ) <> 0
	aCores[ aScan(aCores, {|x| x[1] == "BR_AMARELO" } ) ,1] := "PMSTASK2"
EndIF

If aScan(aCores, {|x| x[1] == "ENABLE" } ) <> 0
	aCores[ aScan(aCores, {|x| x[1] == "ENABLE" } ) ,2]	:= "Pedido de Venda Digitado"
EndIF
If aScan(aCores, {|x| x[1] == "DISABLE" } ) <> 0
	aCores[ aScan(aCores, {|x| x[1] == "DISABLE" } ) ,2]	:= "Pedido de Venda Faturado"
EndIF

Aadd(aCores, {"BR_MARROM",	"Pedido de Venda com Bloqueio de Estoque"} )
Aadd(aCores, {"PMSTASK3",	"Pedido de Venda com Bloqueio Financeiro"} )
Aadd(aCores, {'br_pink',	"Pedido de Venda com Bloqueio por regra de consigna��o"} )
Aadd(aCores, {'BR_PRETO',	"Pedido de Venda com Bloqueio por black list"} )

Return aCores