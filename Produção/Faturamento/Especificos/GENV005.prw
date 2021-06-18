#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENV005   � Autor � DANILO AZEVEDO     � Data �  25/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao dos campos C5_XPEDOLD e C5_XPEDWEB.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Faturamento                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENV005(_nPar)

Local lAtivaVld	:= GetMv("GEN_FAT238",.f.,.T.)

cAmbiente := upper(alltrim(GetEnvServer()))
If !lAtivaVld .OR. (cAmbiente $ "SCHEDULE-PRE") .OR.  ( "GENI023" $ FunName() .OR. ( Type("_cView") == "C" .AND. AllTrim(_cView) == "TT_I32_PEDIDOS_SERVICO")/* Cleuto Lima - 02/03/2016 - n�o validar quando AVA pois n�o � necessario */)
	Return(.T.)
Endif

_lRet := .F.
_nTp := 0
_cView	:= SUPERGETMV("MV_XVIEWPD",.T.,"TT_I29_PEDIDOS_SATELITES") //Par�metro que cont�m o nome da view que ser� consultada para a cria��o do Pedido de Vendas
Private _cArqTmp	:= GetNextAlias()

_cQry := "SELECT COUNT(*) QT FROM "+_cView
If _nPar = 1 //VALIDA XPEDOLD
	
	If empty(M->C5_XPEDWEB)
		_cQry += " WHERE C5_XPEDOLD = '"+alltrim(M->C5_XPEDOLD)+"'
		_nTp := 1
	Else
		_cQry += " WHERE C5_XPEDOLD = '"+alltrim(M->C5_XPEDOLD)+"' AND C5_XPEDWEB = '"+alltrim(M->C5_XPEDWEB)+"'
		_nTp := 2
	Endif
	
Else //VALIDA XPEDWEB
	
	If empty(M->C5_XPEDOLD)
		_cQry += " WHERE C5_XPEDWEB = '"+alltrim(M->C5_XPEDWEB)+"'
		_nTp := 1
	Else
		_cQry += " WHERE C5_XPEDWEB = '"+alltrim(M->C5_XPEDWEB)+"' AND C5_XPEDOLD = '"+alltrim(M->C5_XPEDOLD)+"'
		_nTp := 2
	Endif
	
Endif

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf
dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQry), _cArqTmp, .F., .T.)

If (_cArqTmp)->QT > 0
	_lRet := .T.
Else
	If _nTp = 1
		Msgbox("N�mero n�o encontrado. Certifique-se que este n�mero encontra-se na fila de pedidos a serem importados (view "+alltrim(_cView)+").","Aten��o")
	Else
		If _nPar = 1 //XPEDOLD
			Msgbox("N�mero n�o encontrado ou n�o confere com o Pedido WEB informado. "+CHR(13)+CHR(10)+"Certifique-se que este n�mero encontra-se na fila de pedidos a serem importados (view "+alltrim(_cView)+").","Aten��o")
		Else
			Msgbox("N�mero n�o encontrado ou n�o confere com o Pedido Antigo informado. "+CHR(13)+CHR(10)+"Certifique-se que este n�mero encontra-se na fila de pedidos a serem importados (view "+alltrim(_cView)+").","Aten��o")
		Endif
	Endif
Endif

If Select(_cArqTmp) > 0
	dbSelectArea(_cArqTmp)
	(_cArqTmp)->(dbCloseArea())
EndIf

Return(_lRet)
