#include "PROTHEUS.ch"                 
#Include "TopConn.Ch"   
#DEFINE cEnt CHR(13)+CHR(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK  � Autor � Danilo Azevedo     � Data �  14/05/14   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na inclusao/alteracao do cliente.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Clientes                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA030TOK()

lRet := .T.

Private cFunName := FUNNAME()

If cFunName = "RPC" //SCHEDULE
	Return(.T.)
Endif

If upper(alltrim(GetEnvServer())) $ "PRODUCAO-PRE"
	
	//Valida��o retirada devido vendedor n�o ser mais espec�fico do canal vendas institucionais [Bruno Parreira, 18/09/2020] GMUD 51818
	/*If !((alltrim(M->A1_XCANALV)="2" .and. M->A1_VEND$GETMV("GEN_FAT136")).or.(alltrim(M->A1_XCANALV)<>"2" .and. !(M->A1_VEND$GETMV("GEN_FAT136"))))
		lRet := .F.
		cMsg := "O vendedor informado "+alltrim(Posicione("SA3",1,xFilial("SA3")+M->A1_VEND,"A3_NOME"))+" � incompat�vel com o canal de venda "+alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+M->A1_XCANALV,"X5_DESCRI"))+". Verifique e tente novamente."
		MsgAlert(cMsg,"Aten��o")
	Endif*/
	 
	If !((alltrim(M->A1_XCANALV)="1" .and. alltrim(M->A1_XTIPCLI)$GETMV("GEN_FAT137")) .or. (alltrim(M->A1_XCANALV)="2" .and. alltrim(M->A1_XTIPCLI)$GETMV("GEN_FAT138")) .or. (alltrim(M->A1_XCANALV)="3" .and. alltrim(M->A1_XTIPCLI)$GETMV("GEN_FAT139")) .or. (alltrim(M->A1_XCANALV)="4" .and. alltrim(M->A1_XTIPCLI)$GETMV("GEN_FAT140"));
			 .or. (alltrim(M->A1_XCANALV)="5" .and. alltrim(M->A1_XTIPCLI)$GETMV("GEN_FAT203")))
		lRet := .F.
		cMsg := "O tipo de cliente informado "+alltrim(Posicione("SX5",1,xFilial("SX5")+"TP"+M->A1_XTIPCLI,"X5_DESCRI"))+" � incompat�vel com o canal de venda "+alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+M->A1_XCANALV,"X5_DESCRI"))+". Verifique e tente novamente."
		MsgAlert(cMsg,"Aten��o")
	Endif
	
	If SA1->A1_EST <> "EX" .and. empty(SA1->A1_CGC)
		cMsg := "CNPJ/CPF n�o informado para cliente nacional. Deseja incluir assim mesmo?"+cEnt+"Caso sim, o CNPJ/CPF n�o poder� ser alterado futuramente e n�o ser� poss�vel emitir uma nota fiscal para este cliente."
		If MsgYesNo(cMsg,"Aten��o")
			lRet := Verif()
		Endif
		If !lRet //MANTER SEPARADO PARA VALIDAR POSSIVEL ALTERACAO DURANTE EXECUCAO DO Verif() ACIMA
			MsgBox("Opera��o cancelada. Corrija a informa��o e tente novamente.","Aten��o")
		Endif
	Endif
Endif

Return(lRet)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �VERIF     �Autor  �Danilo Azevedo      � Data �  05/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exibe uma tela com um codigo aleatorio para o usuario repe- ���
���          �tir e confirmar a operacao.                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Verif()

lVerif := .F.
nTam := 7
cDigi := Space(nTam)
cAleat := strzero(Aleatorio((10^nTam)-1,0),nTam)
cMens := "Para confirmar a opera��o digite o c�digo "+cAleat+"."

DEFINE MSDIALOG oDlg TITLE "Valida��o" FROM 000,000 TO 90,360 PIXEL

@ 003,003 TO 040,140 OF oDlg PIXEL
@ 010,007 SAY cMens SIZE 150,07 OF oDlg PIXEL
@ 022,080 MSGET cDigi SIZE 55,11 OF oDlg PIXEL PICTURE "@!"// VALID !Vazio()

DEFINE SBUTTON FROM 010, 150 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
//DEFINE SBUTTON FROM 020, 120 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

lVerif := (cDigi = cAleat)

Return(lVerif)
