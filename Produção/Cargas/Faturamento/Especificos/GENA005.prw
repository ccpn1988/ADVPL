#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA005   �Autor  �Angelo Henrique     � Data �  16/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para mostrar a tela que ser� visualizada ao ser      ���
���          �inserido o c�digo ISBN do produto                           ���
�������������������������������������������������������������������������͹��
���Alteracoes� 29/11/14 - Ajustado p/ funcionar tambem no MATA103-MATA140 ���
���          � 06/05/17 - Ajustado p/ funcionar tambem no MATA415         ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GENA005()

Local _oPesq		:= Nil
Local _lRet		:= .T.
Private _cCodPrd	:= ""
Static _oDlg		:= Nil

If ISINCALLSTACK("U_GENA011T") .OR. ISINCALLSTACK("U_GENA011")
	Return .T.
EndIf

If UPPER(AllTrim(FUNNAME())) == "MATA410" .OR. IsInCallStack("U_GENA013")//PEDIDO DE VENDA
	cCampo := "M->C6_PRODUTO"
ElseIf UPPER(AllTrim(FUNNAME())) $ "MATA103-MATA140" //DOC.ENTRADA E PRE NOTA ENTRADA
	cCampo := "M->D1_COD"
ElseIf UPPER(AllTrim(FUNNAME())) $ "GENA024" //PRE AUTORIZACAO
	cCampo := "M->ZC_PROD"
ElseIf UPPER(AllTrim(FUNNAME())) $ "MATA415	" //OR�AMENTOS
	cCampo := "M->CK_PRODUTO"
Endif
cInfo := Alltrim(&cCampo)

DbSelectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+cInfo)
	//�������������������������������������������������������������������������Ŀ
	//�Rotina para validar se o existem mais de uma op��o no cadastro de produto�
	//���������������������������������������������������������������������������
	If GENA005C(cInfo)
		DEFINE MSDIALOG _oDlg TITLE "Pesquisa de Produto" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
		@ 009, 011 GROUP _oPesq TO 202, 382 PROMPT "Pesquisa de Produto" OF _oDlg COLOR 0, 16777215 PIXEL
		//���������������������������������������������������������������������Ŀ
		//�Ir� realizar a montagem do array onde estar� contido o c�digo do ISBN�
		//�����������������������������������������������������������������������
		_cCodPrd := cInfo
		GENA005A(_cCodPrd)
		@ 215,279 BUTTON "Confirmar" SIZE 037,012 PIXEL OF _oDlg ACTION (GENA005B(), Close(_oDlg))
		@ 215,335 BUTTON "Sair" SIZE 037,012 PIXEL OF _oDlg ACTION Close(_oDlg)
		ACTIVATE MSDIALOG _oDlg CENTERED
	EndIf
EndIf

Return(_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA005A  �Autor  �Angelo Henrique     � Data �  16/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para montagem do acols contendo os produtos          ���
���          �relacionados com o c�digo digitado.                         ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GENA005A(_cCodPrd)

Local _nX		:= 0
Local _aHeadB1 	:= {}
Local _aColsB1 	:= {}
Local _aAltFiel := {}
Local _nUsado	:= 0
Local _cQuery	:= ""
Local _cAliSB1	:= GetNextAlias()
Local _nPosCod	:= 0
Local _nPosDsc	:= 0
Local _nPosIsb	:= 0
Local n_i 		:= 0
Local aCampos 	:= {}

Static _oMsNGtDd


//Bloco descuntinuado Lucas Ribeiro 16.07.2019
/*
DbSelectArea("SX3")
DbSeek("SB1")
While !Eof().And.(X3_ARQUIVO=="SB1")
If AllTrim(X3_CAMPO) == "B1_COD" .OR. AllTrim(X3_CAMPO) == "B1_DESC" .OR. AllTrim(X3_CAMPO) == "B1_ISBN"

_nUsado:= _nUsado+1
AADD(_aHeadB1,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
X3_TAMANHO, X3_DECIMAL,"ALLWAYSTRUE()",;
X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )

EndIf
dbSkip()
EndDo
*/

aCampos := FWSX3Util():GetAllFields( "SB1", .F. )
For xB1 := 1 To Len(aCampos)
	If aCampos[xB1] == "B1_COD" .OR. aCampos[xB1] == "B1_DESC" .OR. aCampos[xB1] == "B1_ISBN"
		
		_nUsado:= _nUsado+1
		/*                                (X3_TITULO), 					X3_CAMPO, 						X3_PICTURE					X3_TAMANHO, 				X3_DECIMAL,		  "ALLWAYSTRUE()",				X3_USADO,							 				X3_TIPO,		 				X3_ARQUIVO,						 					X3_CONTEXT } )*/		
		Aadd(_aHeadB1, {Posicione("SX3",2,aCampos[xB1],"X3_TITULO"),aCampos[xB1],Posicione("SX3",2,aCampos[xB1],"X3_PICTURE"),TamSx3(aCampos[xB1])[1],TamSx3(aCampos[xB1])[2],"ALLWAYSTRUE()",Posicione("SX3",2,aCampos[xB1],"X3_USADO"),FWSX3Util():GetFieldType(aCampos[xB1]),Posicione("SX3",2,aCampos[xB1],"X3_ARQUIVO"),Posicione("SX3",2,aCampos[xB1],"X3_CONTEXT")} )		
		
	EndIf
Next xB1


_aColsB1:={Array(_nUsado+1)}
_aColsB1[1,_nUsado+1]:=.F.

For _nX:=1 to _nUsado
	_aColsB1[1,_nX]:= CriaVar(_aHeadB1[_nX,2])
Next

_nPosCod	:= aScan(_aHeadB1, { |x| Alltrim(x[2]) == 'B1_COD' })
_nPosDsc	:= aScan(_aHeadB1, { |x| Alltrim(x[2]) == 'B1_DESC'})
_nPosIsb	:= aScan(_aHeadB1, { |x| Alltrim(x[2]) == 'B1_ISBN'})

//�������������������������������������������������������������Ŀ
//�Alimentando o aCols com as informa��es pertinentes ao produto�
//���������������������������������������������������������������

_cQuery := "SELECT B1_COD, B1_ISBN, B1_DESC
_cQuery += " FROM " + RetSqlName("SB1")
_cQuery += " WHERE (B1_ISBN LIKE '%" +AllTrim(_cCodPrd) + "'"
_cQuery += " OR B1_DESC like '%" +AllTrim(_cCodPrd) + "%')
_cQuery += " AND D_E_L_E_T_ <> '*'
_cQuery += " ORDER BY B1_DESC

//_cQuery := ChangeQuery(_cQuery)

If Select(_cAliSB1) > 0
	dbSelectArea(_cAliSB1)
	(_cAliSB1)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliSB1, .F., .T.)

n_i := 1

While (_cAliSB1)->(!EOF())
	//Na primeira vez o vetor ja esta criado
	If n_i == 1
		_aColsB1[n_i][_nPosCod] := AllTrim((_cAliSB1)->B1_COD)
		_aColsB1[n_i][_nPosDsc] := AllTrim((_cAliSB1)->B1_DESC)
		_aColsB1[n_i][_nPosIsb] := AllTrim((_cAliSB1)->B1_ISBN)
	Else
		aAdd(_aColsB1, {"","","", .F.})
		_aColsB1[n_i][_nPosCod] := AllTrim((_cAliSB1)->B1_COD)
		_aColsB1[n_i][_nPosDsc] := AllTrim((_cAliSB1)->B1_DESC)
		_aColsB1[n_i][_nPosIsb] := AllTrim((_cAliSB1)->B1_ISBN)
	EndIf
	n_i ++
	(_cAliSB1)->(DbSkip())
EndDo

_oMsNGtDd := MsNewGetDados():New( 023, 019, 192, 375, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", _aAltFiel,, 999, "AllwaysTrue", "", "AllwaysTrue", _oDlg, _aHeadB1, _aColsB1)
_oMsNGtDd:oBrowse:bLDblClick := {|| (GENA005B(),Close(_oDlg))}

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA005B  �Autor  �Angelo Henrique     � Data �  21/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina utilizada para alimentar o campo C6_PRODUTO com o    ���
���          �registro selecionado na tela                                ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GENA005B()

Local _aArea 	:= GetArea()
Local _nPosCod  := aScan(_oMsNGtDd:aHeader, { |x| Alltrim(x[2]) == 'B1_COD' })

&cCampo := AllTrim(_oMsNGtDd:aCols[_oMsNGtDd:nAt][_nPosCod])

RestArea(_aArea)

Return()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENA005C  �Autor  �Angelo Henrique     � Data �  21/07/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina utilizada para validar o produto, caso o conteudo    ���
���          �digitado traga mais de um resultado a tela deve ser exibida ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GENA005C(_cCodPrd)

Local _aArea 	:= GetArea()
Local _cQuery   := ""
Local _cAliVer	:= GetNextAlias()
Local _lRet		:= .T.
Local _cAliVer2	:= GetNextAlias()

//����������������������������������������������������������������������������������Ŀ
//�Query para listar as informa��es conforme o campo C6_PRODUTO digitado pelo usu�rio�
//������������������������������������������������������������������������������������
_cQuery := "SELECT COUNT(B1_COD) CONTA
_cQuery += " FROM " + RetSqlName("SB1")
_cQuery += " WHERE (B1_ISBN LIKE '%" +AllTrim(_cCodPrd) + "'"
_cQuery += " OR B1_DESC like '%" +AllTrim(_cCodPrd) + "%')
_cQuery += " AND D_E_L_E_T_ <> '*'

//_cQuery := ChangeQuery(_cQuery)

If Select(_cAliVer) > 0
	dbSelectArea(_cAliVer)
	(_cAliVer)->(dbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliVer, .F., .T.)

If (_cAliVer)->(!EOF()) .And. (_cAliVer)->CONTA == 1
	
	//����������������������������������������������������������������������Ŀ
	//�Query para pegar as informa��es caso seja achado apenas uma informa��o�
	//������������������������������������������������������������������������
	_cQuery := "SELECT B1_COD
	_cQuery += " FROM " + RetSqlName("SB1")
	_cQuery += " WHERE (B1_ISBN LIKE '%" +AllTrim(_cCodPrd) + "'"
	_cQuery += " OR B1_DESC like '%" +AllTrim(_cCodPrd) + "%')
	_cQuery += " AND D_E_L_E_T_ <> '*'
	//_cQuery := ChangeQuery(_cQuery)
	
	If Select(_cAliVer2) > 0
		dbSelectArea(_cAliVer2)
		(_cAliVer2)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAliVer2, .F., .T.)
	
	If (_cAliVer2)->(!EOF())
		
		&cCampo := (_cAliVer2)->B1_COD
		
		_lRet := .F.
	EndIf
	If Select(_cAliVer2) > 0
		dbSelectArea(_cAliVer2)
		(_cAliVer2)->(dbCloseArea())
	EndIf
	
EndIf

If Select(_cAliVer) > 0
	dbSelectArea(_cAliVer)
	(_cAliVer)->(dbCloseArea())
EndIf

RestArea(_aArea)

Return(_lRet)
