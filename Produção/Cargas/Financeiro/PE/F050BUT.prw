#INCLUDE "PROTHEUS.CH"
#DEFINE cEnt      CHR(13)+CHR(10)
#DEFINE TITULO  'Entidades Contabeis'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050BUT   �Autor  �Vinicius Lan�a      � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicionar botao na Rotina de Contas  ���
���          � a Pagar.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION F050BUT

Local aArea		:= GetArea()
Local aBotao    := {}


If Altera

aAdd( aBotao, { "OBJETIVO", { || U_GravaE2("F") }, "Entidades Contabeis", "Ent. Contabil." } )

EndIf

RestArea(aArea)

Return aBotao


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050BUT   �Autor  �Vinicius Lan�a      � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Insere Classe de Valor na Fatura.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GravaE2()

Local  	cTitulo := Upper( TITULO )
Private	cContad := SPACE(Tamsx3("E2_CONTAD")[1])
Private	cCusto  := SPACE(Tamsx3("E2_CCD")[1])
Private	cClasse	:= SPACE(Tamsx3("E2_CLVLDB")[1])
Private lFim
//���������������������������������������������������������������������Ŀ
//� Monta Tela de Dialogo                                               �
//�����������������������������������������������������������������������
Define Font oFontBold Name 'Arial' Size 0, -13 Bold
Define Font oFontNor  Name 'Arial' Size 0, -11
Define Font oFontNorB Name 'Arial' Size 0, -11 Bold

Define MSDialog oDlg From 89, 180 To 265, 500 Title cTitulo Style DS_MODALFRAME Pixel Of oMainWnd

//�������������������������������������������������Ŀ
//�Insere apenas os campos que n�o est�o preenchidos�
//���������������������������������������������������
If EMPTY(SE2->E2_CONTAD)
	cContad := SE2->E2_CONTAD
	@ 012, 016 Say 'Conta Contabil:'     Font oFontNorB of oDlg PIXEL
	@ 010, 066 MsGet oCompet Var cContad Size 080,010 PIXEL Picture OF oDlg F3 "CT1"
Else
	cContad := SE2->E2_CONTAD
EndIf

If EMPTY(SE2->E2_CCD)
	cCusto := SE2->E2_CCD
	@ 027, 016 Say 'Centro de Custo:'    Font oFontNorB of oDlg PIXEL
	@ 025, 066 MsGet oCompet Var cCusto  Size 040,010 PIXEL Picture OF oDlg F3 "CTT"
Else
	cCusto := SE2->E2_CCD
EndIf

If EMPTY(SE2->E2_CLVLDB)
	cClasse := SE2->E2_CLVLDB
	@ 042, 016 Say 'Classe de Valor:'    Font oFontNorB of oDlg PIXEL
	@ 040, 066 MsGet oCompet Var cClasse Size 040,010 PIXEL Picture OF oDlg F3 "CTH"
Else
  	cClasse := SE2->E2_CLVLDB
EndIf

//Bot�es
@ 070, 033 Button oButGera Prompt 'OK'   Size 36, 12 Pixel Action ( lOk := .T., Alte2(), lOk := .F., IIf(lFim ,oDlg:End(),) ) Message 'Gravar' Of oDlg
@ 070, 100 Button oButSair Prompt 'Sair' Size 36, 12 Pixel Action ( lOk := .F., oDlg:End() ) Message 'Sair' Of oDlg

Activate MSDialog oDlg Centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050BUT   �Autor  �Vinicius Lan�a      � Data �  12/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Valores Inseridos                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Alte2()


DbSelectArea("SE2")
DbsetOrder(1)
//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
DbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA )

//Grava valores nos campos
M->E2_CLVLDB  := cClasse
M->E2_XDESPRO := If(!Empty(cClasse),Posicione("CTH",1,xFilial("CTH")+cClasse,"CTH_DESC01"),"")
M->E2_CONTAD  := cContad
M->E2_XCONDES := If(!Empty(cContad),Posicione("CT1",1,xFilial("CT1")+cContad,"CT1_DESC01"),"")
M->E2_CCD     := cCusto
M->E2_XDESCUS := If(!Empty(cCusto),Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_DESC01"),"")

/*
*'-------------------------------------
RecLock("SE2",.F.)

SE2->E2_CLVLDB := cClasse
SE2->E2_CONTAD := cContad
SE2->E2_CCD    := cCusto

SE2->(MsUnlock())
*'-------------------------------------
  */
lFim := .T.

Return
