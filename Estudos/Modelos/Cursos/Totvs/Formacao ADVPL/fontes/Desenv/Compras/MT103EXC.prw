#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MT103EXC  ?Autor  ?Danilo Azevedo      ? Data ?  25/08/15   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Ponto de Entrada na exclusao do documento de entrada.       ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? GEN - Compras/Estoque                                      ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function MT103EXC() 

TcSqlExec("UPDATE "+RetSqlName("SZB")+" SET ZB_SITUACA = '1' WHERE ZB_FILIAL = '"+xFilial("SZB")+"' AND ZB_DOC = '"+SF1->F1_DOC+"' AND ZB_SERIE = '"+SF1->F1_SERIE+"' AND ZB_CLIENTE = '"+SF1->F1_FORNECE+"' AND ZB_LOJA = '"+SF1->F1_LOJA+"' AND D_E_L_E_T_ = ' '")

Return(.T.)