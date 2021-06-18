#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410STTS  �Autor  � Joni Fujiyama      � Data �  16/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada no t�rmino da grava��o do pedido de venda  ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M410STTS()

Local _aArea		:= GetArea()
Local cAmbiente	:= upper(alltrim(GetEnvServer()))

//16/06/2015 - Rafael Leite - Corre��o do fonte troca do comando para AND. Valida��o realizada para que o processo n�o seja executado quando � exclus�o.
If !Inclui .and. !Altera //NAO EXECUTA NA EXCLUSAO
	Return()
Endif

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011C")
	Return .T.
EndIf

If FunName()=="MATA410" .and. !(SC5->C5_TIPO $ 'BD')

	//Bloqueio de pedido por valor m�nimo
	U_GENA008()
	
	//Bloqueio por alteracao do frete ou condicao de pagamento
	U_GENA014()

	//Atualizacao de Peso, Preco e Qtd (SC5)
	U_GENA016()
	
	//Bloqueio por alteracao de desconto 
	U_GENA017()
	
	//������������������������������������������������������Ŀ
	//�Cleuto Lima - 08/04/2016                              �
	//�                                                      �
	//�Implementado bloqueio de regra para pedidos em remessa�
	//�em consigna��o.                                       �
	//��������������������������������������������������������
	If Empty(SC5->C5_BLQ)
		BloqConsig()
	EndIf
		
Endif

//��������������������������Ŀ
//�Cleuto/Renato - 22/06/2016�
//�                          �
//�Bloqueio por Black List   �
//����������������������������
//���������������������������������������������������������������������Ŀ
//�Cleuto Lima - 20/03/2017 - 09h27                                     �
//�                                                                     �
//�desativar valida��o da blacklist                                     �
//�                                                                     �
//�Vivaz: 33408 - Desativar blacklist de pedidos da loja GEN no Protheus�
//�����������������������������������������������������������������������
/*
If !(SC5->C5_TIPO $ 'BD')
	SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	U_GENA047(SA1->A1_EMAIL,SA1->A1_NOME,SA1->A1_CGC,SA1->A1_CEP) 
EndIf
*/

If FunName()=="MATA410" .AND. !(upper(alltrim(GetEnvServer())) $ "SCHEDULE")

	U_GENA041()	
	
Endif
   
If SC5->C5_XPEDWEB <> ' '
	tcsqlexec("UPDATE "+RetSqlName("SC6")+" SET C6_XPEDWEB = '"+SC5->C5_XPEDWEB+"' WHERE C6_FILIAL = '"+SC5->C5_FILIAL+"' AND C6_NUM = '"+SC5->C5_NUM+"' AND D_E_L_E_T_ = ' '")
EndIf

RestArea(_aArea)

If !(cAmbiente $ "SCHEDULE") .AND. (Inclui .and. !Altera) .AND. cFilAnt == "1022" .AND. FunName()=="MATA410" /* DEVE IMPRIMRI AUTOMATICAMENTE O ESPELHO APENAS NA INCLUS�O DO PEDIDO */
	If !Empty(SC5->C5_XNUMESP)
		/* corrigi o numero do pedido no espelho pois no momento to TudoOk onde a ZZB � gravada o numero do pedido pode ser alterado pelo protheus */
		cUpd := "UPDATE "+RetSqlName("ZZB")+" SET ZZB_NUM = '"+SC5->C5_NUM+"' WHERE ZZB_FILIAL = '"+SC5->C5_FILIAL+"' AND ZZB_MSIDEN = '"+SC5->C5_XNUMESP+"'"	
		Begin transaction		
			Tcsqlexec(cUpd)
		End Transaction
		U_GENR068("",SC5->C5_XNUMESP,SC5->C5_FILIAL,SC5->C5_VEND1,SC5->C5_XPEDCLI,ALLTRIM(SC5->C5_CONDPAG),ALLTRIM(SC5->C5_TRANSP),SC5->C5_TPFRETE)
	EndIf	
EndIf

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BloqConsig�Autor  �Cleuto Lima         � Data �  08/04/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Bloqueio de pedidos para remessa em consigna��o.            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gen.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function BloqConsig()

Local aAreaSC6	:= SC6->(GetArea())
Local cInTES	:= SuperGetMv("GEN_FAT094",.F.,"")
Local lBloq		:= .F.

If Empty(cInTES)
	Return nil
EndIf

SC6->(DbSetOrder(1))//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
While SC6->(!EOF()) .AND. SC6->C6_FILIAL+SC6->C6_NUM == SC5->C5_FILIAL+SC5->C5_NUM
	
	If SC6->C6_TES $ cInTES
		lBloq	:= .T.
	EndIf
	
	SC6->(DbSkip())
EndDo

If lBloq
	
	RecLock("SC5",.F.)
	SC5->C5_BLQ	:= "3"
	MsUnLock()
		
	MsgStop("Pedido de Vendas com Bloqueio por regra de consigna��o")	
	
EndIf

RestArea(aAreaSC6)

Return nil	