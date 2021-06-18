#Include "rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BloqFin   �Autor  �Danilo Azevedo      � Data �  18/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para definicao da data de bloqueio das movimentacoes���
���          � financeiras.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � GEN - Financeiro                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BLOQFIN()

Private cEmailblq := allTrim( getMV( "GEN_CON001",, " " ) )     
Private dMVDataF := GetMV("MV_DATAFIN")
Private oDlgTab
Private oEdit1
Private cEdit1 := dMVDataF

If !RetCodUsr() $ GetMV("GEN_CON002") //ALEXANDRE, FABIO, LUIZ
	MsgBox("Usuario sem permiss�o para executar esta rotina.","Atencao",)
	Return()
EndIf

DEFINE MSDIALOG oDlgTab TITLE "Financeiro" FROM C(360),C(520) TO C(422),C(779) PIXEL

// Cria as Groups do Sistema
@ C(005),C(005) TO C(028),C(125) LABEL "Informe a data para bloqueio de movimentacoes Finaceiras" PIXEL OF oDlgTab
@ C(013),C(010) MsGet oEdit1 Var cEdit1 Size C(050),C(009) COLOR CLR_BLACK PIXEL OF oDlgTab
@ C(013),C(80) Button "OK" Size C(035),C(010) PIXEL OF oDlgTab  Action GrvParam()

ACTIVATE MSDIALOG oDlgTab CENTERED

Return()


/****************************
GRAVACAO DA DATA NO PARAMETRO
*****************************/
Static Function GrvParam()

oEdit1:Refresh()

If cEdit1 >= dMVDataF
	PutMV("MV_DATAFIN",cEdit1)
	EnvMail()
Elseif MsgYesNo("A data informada � anterior a data j� gravada no par�metro. Tem certeza?","Aten��o")
	PutMV("MV_DATAFIN",cEdit1)
	EnvMail()
Endif

oDlgTab:End()

Return()

/*************
ENVIO DE EMAIL
**************/
Static Function EnvMail()

cEol := CHR(13)+CHR(10)

cMsg := "### EMAIL AUTOM�TICO - FAVOR N�O RESPONDER ###"
cMsg += cEol
cMsg += cEol
cMsg += cEol
cMsg += "Par�metro: MV_DATAFIN - Data limite para realiza��o de opera��es financeiras"
cMsg += cEol
cMsg += cEol
cMsg += "Data: "+dtoc(MsDate())+" - "+Time()
cMsg += cEol
cMsg += "Usu�rio: "+alltrim(UsrFullName(RetCodUsr()))
cMsg += cEol
cMsg += "Empresa/Filial: "+cEmpAnt+"/"+cFilAnt
cMsg += cEol
cMsg += cEol
cMsg += "Valor Antigo: "+dtoc(dMVDataF)
cMsg += cEol
cMsg += "Valor Novo: "+dtoc(cEdit1)
cMsg += cEol
cMsg += cEol
cMsg += cEol
cMsg += "### EMAIL AUTOM�TICO - FAVOR N�O RESPONDER ###"

cMsg := oemtoansi(cMsg)

aDest := {}
aAdd(aDest,cEmailblq)
For _nX := 1 to len(aDest)
	U_GenSendMail(,,,"noreply@grupogen.com.br",aDest[_nX],oemtoansi("Protheus Financeiro - Par�metro alterado"),oemtoansi(cMsg),,,.F.)
Next _nX

Return()
