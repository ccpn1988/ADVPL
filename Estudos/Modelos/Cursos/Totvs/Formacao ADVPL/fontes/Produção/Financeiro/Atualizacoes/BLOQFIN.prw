#Include "rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BloqFin   ºAutor  ³Danilo Azevedo      º Data ³  18/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para definicao da data de bloqueio das movimentacoesº±±
±±º          ³ financeiras.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Financeiro                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BLOQFIN()

Private cEmailblq := allTrim( getMV( "GEN_CON001",, " " ) )     
Private dMVDataF := GetMV("MV_DATAFIN")
Private oDlgTab
Private oEdit1
Private cEdit1 := dMVDataF

If !RetCodUsr() $ GetMV("GEN_CON002") //ALEXANDRE, FABIO, LUIZ
	MsgBox("Usuario sem permissão para executar esta rotina.","Atencao",)
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
Elseif MsgYesNo("A data informada é anterior a data já gravada no parâmetro. Tem certeza?","Atenção")
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

cMsg := "### EMAIL AUTOMÁTICO - FAVOR NÃO RESPONDER ###"
cMsg += cEol
cMsg += cEol
cMsg += cEol
cMsg += "Parâmetro: MV_DATAFIN - Data limite para realização de operações financeiras"
cMsg += cEol
cMsg += cEol
cMsg += "Data: "+dtoc(MsDate())+" - "+Time()
cMsg += cEol
cMsg += "Usuário: "+alltrim(UsrFullName(RetCodUsr()))
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
cMsg += "### EMAIL AUTOMÁTICO - FAVOR NÃO RESPONDER ###"

cMsg := oemtoansi(cMsg)

aDest := {}
aAdd(aDest,cEmailblq)
For _nX := 1 to len(aDest)
	U_GenSendMail(,,,"noreply@grupogen.com.br",aDest[_nX],oemtoansi("Protheus Financeiro - Parâmetro alterado"),oemtoansi(cMsg),,,.F.)
Next _nX

Return()
