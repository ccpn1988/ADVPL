#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA063   �Autor  � Erica Vieites      � Data �  17/01/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se pedido est� abaixo do valor m�nimo		      ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GENA063()

Local _aArea	:= GetArea()
Local _aAreaSA1	:= SA1->(GetArea())
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())
Local _nValMin	:= SuperGetMv( "MV_XVALMIN" , , 1500.00 )
Local _cAlias2	:= GetNextAlias()
Local _cAlias3	:= GetNextAlias()
Local _cSQL		:= "" 
Local _lRet63   := .T.
Local _dia      := DOW(DATE()) 

//Verifica se existe algum item com a TES que contemple o Valor M�nimo
_cSQL := "SELECT F4_XVALMIN "
_cSQL += "FROM " + RetSQLName("SF4") + " SF4 "
_cSQL += "WHERE SF4.F4_XVALMIN = 'S' "
_cSQL += "AND SF4.D_E_L_E_T_ = ' ' "
_cSQL += "AND SF4.F4_CODIGO = '" + GdFieldGet("C6_TES") + "'

_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias2) New   


/*INCLUIDO ERICA*/
//Selecao para verificar se existe CLIENTE fob COM MAIS DE 1 PEDIDO CIF DURANTE A SEMANA
_cSQL := "SELECT COUNT(*) QTDE "
_cSQL += "FROM " + RetSQLName("SA1") + " SA1 INNER JOIN " + RetSQLName("SF2") + " SF2 ON  SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA "
_cSQL += "WHERE SA1.A1_TPFRET = 'F' AND SA1.A1_COD = '" + M->C5_CLIENTE + "' AND SA1.A1_LOJA = '" + M->C5_LOJACLI + "' AND SA1.D_E_L_E_T_ = ' ' AND SF2.F2_TPFRETE = 'C' AND SF2.D_E_L_E_T_ = ' ' " 
//_cSQL += "AND SF2.F2_EMISSAO BETWEEN TO_CHAR(SYSDATE-7,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') " 

IF _dia == 1 
_cSQL += "AND SF2.F2_EMISSAO = TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 2 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-1,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 3 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-2,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 4 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-3,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 5 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-4,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 6 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-5,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF

IF _dia == 7 
_cSQL += "AND SF2.F2_EMISSAO  BETWEEN TO_CHAR(SYSDATE-6,'YYYYMMDD') AND TO_CHAR(SYSDATE,'YYYYMMDD') "
ENDIF      


         
_cSQL := ChangeQuery(_cSQL)

TcQuery _cSQL Alias (_cAlias3) New

//Verifica se CLIENTE FOB COM MAIS DE UM PEDIDO E SE pedido est� abaixo do valor m�nimo

IF _nValMin > (M->C5_XVALTOT) .AND. (_cAlias2)->F4_XVALMIN == "S" .AND. (_cAlias3)->QTDE >= 1 .AND. Empty(M->C5_XMOTIVO) .AND. (M->C5_TPFRETE) == "C"       
   	MsgStop("Necess�rio preencher o campo Justif. Ped." )  
   	_lRet63 := .F.
   	Return _lRet63
END IF  
  



(_cAlias3)->(DbCloseArea())
(_cAlias2)->(DbCloseArea())

RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSA1)
RestArea(_aArea)

Return _lRet63
