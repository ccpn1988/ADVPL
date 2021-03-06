#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA075      � Autor � cleuto Lima     � Data �  20/08/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � fun��es para arquivos cnab                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
                       
User Function GENA075()

Local aArea	:= GetArea()
Local nRet		:= 0
Local cAliTmp	:= GetNextAlias()

BeginSql Alias cAliTmp
	SELECT COUNT(*) QTD FROM %Table:SEA% SEA
	WHERE SEA.EA_FILIAL = %xFilial:SEA%
	AND EA_NUMBOR = %Exp:SEA->EA_NUMBOR%
	AND SEA.%NotDel%	
EndSql

(cAliTmp)->(DbGoTop())
nRet := (cAliTmp)->QTD

(cAliTmp)->(DbCloseArea())
RestArea(aArea)

Return nRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA075A     � Autor � cleuto Lima     � Data �  20/08/2018 ���
�������������������������������������������������������������������������͹��
���Descricao � gera nosso numero de acordo com padr�o banestes            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA075A()

Local aArea	:= GetArea()
Local nDv1		:= 0
Local nDv2		:= 0
Local nAuxDv	:= 0
Local nAuxA	:= 0
Local nResto	:= 0
Local cNumBco	:= "" 

SEE->( dbSetOrder( 1 ) )
SEE->( MsSeek( xFilial( "SEE" ) + AllTrim(SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA)) ) )// Banco / Agencia / Conta / Sub-conta

If Empty(SE1->E1_NUMBCO)

	If AllTrim(SEE->EE_FAXFIM) == AllTrim(SEE->EE_FAXATU)
		MsgStop("Limite de numera��o de do nosso numero atingido, o campo nosso numero do cnab n�o ser� gerado, verifique os parametros de banco!")
		return ""		
	EndIf

	cNumBco := AllTrim(SEE->EE_FAXATU)
	
	Reclock("SEE",.F.)
	SEE->EE_FAXATU	:= Soma1(AllTrim(SEE->EE_FAXATU))
	MsUnLock()
	
	// calculo digito verificador 1
	nAuxA	:= 1 
	For nAuxDv := 9 To 2 step -1
		nDv1+= nAuxDv*Val(SubStr(cNumBco,nAuxA,1))
		nAuxA++	
	Next
	
	nResto	:= Mod(nDv1,11)
	If nResto > 1
		nDv1 := 11-nResto 
	Else
		nDv1 := 0
	EndIf
	
	// calculo digito verificador 2
	cNumBco	:= cNumBco + cValToChar(nDv1)
	nAuxA	:= 1 
	For nAuxDv := 10 To 2 step -1
		nDv2+= nAuxDv*Val(SubStr(cNumBco,nAuxA,1))
		nAuxA++	
	Next
	
	nResto	:= Mod(nDv2,11)
	If nResto > 1
		nDv2 := 11-nResto 
	Else
		nDv2 := 0
	EndIf
	
	cNumBco := cNumBco + cValToChar(nDv2)

	RecLock("SE1",.F.)
	SE1->E1_NUMBCO	:= cNumBco
	msUnLock() 
Else
	cNumBco := AllTrim(SE1->E1_NUMBCO)
EndIf

RestArea(aArea)

Return cNumBco