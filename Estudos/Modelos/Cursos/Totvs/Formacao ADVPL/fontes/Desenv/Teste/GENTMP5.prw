#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GenTmp5   � Autor � Danilo Azevedo     � Data �  29/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Importacao de transportadoras (Temporario)                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENTMP5()

cQry := "SELECT T.*, U.DESCRICAO EST, M.DESCRICAO MUN FROM TRANSPORTADORA T INNER JOIN MUNICIPIO M ON T.IDMUNICIPIO = M.IDMUNICIPIO INNER JOIN UF U ON T.IDUF = U.IDUF ORDER BY IDTRANSPORTADORA"
cAlias := Criatrab(Nil,.F.)
MsgRun("Selecionando registros...","Processando", {||DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAlias,.T.,.T.)})

dbSelectArea("SA4")
dbSetOrder(1)
Do while !(cAlias)->(eof())
	
	If dbSeek(xFilial("SA4")+cValToChar((cAlias)->IDTRANSPORTADORA))
		RecLock("SA4",.F.)
	Else
		RecLock("SA4",.T.)
		SA4->A4_FILIAL := xFilial("SA4")
		SA4->A4_COD := STRZERO((cAlias)->IDTRANSPORTADORA,6)
		SA4->A4_NOME := (cAlias)->DESCRICAO
	Endif
	
	SA4->A4_END := (cAlias)->ENDERECO
	SA4->A4_BAIRRO := (cAlias)->BAIRRO
	SA4->A4_CEP := (cAlias)->CEP
	SA4->A4_MUN := (cAlias)->MUN
	SA4->A4_EST := (cAlias)->EST
	SA4->A4_VIA := (cAlias)->VIATRANSPORTADA
	//SA4->A4_DDD := (cAlias)->SITUACAO
	SA4->A4_TEL := (cAlias)->TEL
	SA4->A4_CGC := (cAlias)->CGC
	SA4->A4_INSEST := (cAlias)->IE
	SA4->A4_EMAIL := (cAlias)->EMAIL
	
	MsUnlock()
	(cAlias)->(dbskip())
Enddo

fErase(cAlias)

Return()
