#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMMSGRH    บ Autor ณ Danilo Azevedo     บ Data ณ  27/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Aviso de alteracao de situacao do colaborador disparado porบฑฑ
ฑฑบ          ณ m-messenger atraves de formula.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cTipo                                                      บฑฑ
ฑฑบ          ณ   C = Contratado                                           บฑฑ
ฑฑบ          ณ   D = Desligado                                            บฑฑ
ฑฑบ          ณ   A = Afastado                                             บฑฑ
ฑฑบ          ณ   F = Ferias                                               บฑฑ
ฑฑบ          ณ   T = Transferido                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ MV_XTICAD = Emails dos destinatatios.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GEN - TI                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MSGRH(cTp)

Prepare Environment Empresa "00" Filial "1001"

Private lOk 			:= .F.
Private cErro 		:= Space(0)
Private cServer   	:= GETMV("MV_RELSERV")
Private cAccount  	:= GETMV("MV_RELACNT")
Private cPassword 	:= GETMV("MV_RELPSW")
Private cMensa		:= Space(0)
Private nTenta        := 0

cSubject:= oemtoansi("[Protheus GPE] Atualiza็ใo de Colaborador")
//cTo 	:= alltrim(GETMV("MV_XTICAD"))
cTo 	:= "dpazevedo@gmail.com"
cCc		:= Space(0)
cBcc 	:= Space(0)

cMensa := U_MMSGRH(cTp)

Do While nTenta <= 5
	nTenta++
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lOK
	If lOk
		MailAuth(cAccount,cPassword)
		SEND MAIL FROM cAccount;
		TO cTo ;
		CC cCc ;
		BCC cBcc ;
		SUBJECT cSubject ;
		BODY cMensa ;
		RESULT lOk
		If !lOk
			GET MAIL ERROR cErro
		Endif
		DISCONNECT SMTP SERVER RESULT lOK
		If !lOk
			GET MAIL ERROR cErro
			For vs = 1 to 5000000
			Next
			Loop
		Else
			Exit
		EndIf
	Else
		GET MAIL ERROR cErro
		For qwerti = 1 to 5000000
		Next
		Loop
	EndIf
Enddo

Reset Environment

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณProcHtml  บAutor  ณDanilo Azevedo      บ Data ณ  27/02/14   บฑฑ
ฑฑศออออออออออฯออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MMSGRH(cTipo)

Private cAlias := CriaTrab(Nil,.F.)
Private cQry := "SELECT RA_MAT MATRICULA, RA_NOME NOME, RA_EMAIL EMAIL, NVL(Q3_DESCSUM,' ') CARGO, RA_CC CCUSTO, NVL(CTT_DESC01,' ') DESC_CCUSTO, NVL(QB_DESCRIC,' ') DEPTO
cQry += " FROM "+RetSqlName("SRA")+" RA
cQry += " LEFT JOIN "+RetSqlName("SQ3")+" Q3 ON RA_CARGO = Q3_CARGO AND Q3_FILIAL = '"+xFilial("SQ3")+"' AND Q3.D_E_L_E_T_ <> '*'
cQry += " LEFT JOIN "+RetSqlName("CTT")+" CTT ON RA_CC = CTT_CUSTO AND CTT_FILIAL = '"+xFilial("CTT")+"' AND CTT.D_E_L_E_T_ <> '*'
cQry += " LEFT JOIN "+RetSqlName("SQB")+" QB ON RA_DEPTO = QB_DEPTO AND QB_FILIAL = '"+xFilial("SQB")+"' AND QB.D_E_L_E_T_ <> '*'
cQry += " WHERE RA_FILIAL = '"+xFilial("SRA")+"'
cQry += " AND RA_MAT = '"+SRA->RA_MAT+"'
cQry += " AND RA.D_E_L_E_T_ <> '*'

cQry := ChangeQuery(cQry)
DbUseArea(.T., "TOPCONN", TcGenQry(,, cQry), cAlias, .T., .T.)
DbGotop()

//INICIO CABECALHO
cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">
cMensagem += '<head>
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
cMensagem += '<title>Pedido de Compra</title>
cMensagem += '<style type="text/css">
cMensagem += '.Cabec1 {
cMensagem += '	font-family: Verdana, Geneva, sans-serif;
cMensagem += '	font-size: 16px;
cMensagem += '}
cMensagem += 'body,td,th {
cMensagem += '	font-family: Verdana, Geneva, sans-serif;
cMensagem += '	font-size: 12px;
cMensagem += '	color: #000;
cMensagem += '}
cMensagem += 'body {
cMensagem += '	background-color: #FFF;
cMensagem += '}
cMensagem += '</style>
cMensagem += '</head>
cMensagem += '<body>
cMensagem += '<table width="100%" height="70" border="0" bgcolor="#FFFFFF" frame="void" rules="none">
cMensagem += '  <tr>
cMensagem += '    <td width="100%" height="66" align="center"><img src="http://tigen.com.br/images/gen_logo_blue_all.png" alt="" width="560" height="156" align="center" /></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td width="100%" height="50" align="center"><span style="font-family: Verdana, Geneva, sans-serif"><strong><font color="0062A1" size="4">RH GEN - </font></strong></span><span class="Cabec1"><strong><font color="0062A1" size="4">ALTERAวรO DE COLABORADOR</font></strong></span></td>
cMensagem += '  </tr>
cMensagem += '</table>
//FIM CABECALHO

cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<p><font size="3"><strong>Informamos que o colaborador abaixo '
If cTipo = "C" //CONTRATADO
	cMensagem += 'foi ADMITIDO.'
ElseIf cTipo = "D" //DESLIGADO
	cMensagem += 'foi DESLIGADO.'
ElseIf cTipo = "A" //AFASTADO
	cMensagem += 'foi AFASTADO.'
ElseIf cTipo = "F" //FERIAS
	cMensagem += 'estแ em FษRIAS.'
ElseIf cTipo = "T" //TRANSFERIDO
	cMensagem += 'foi TRANSFERIDO.'
Endif
cMensagem += '</font><br />
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '</p>
cMensagem += '<table width="100%" border="0">
cMensagem += '  <tr>
cMensagem += '    <td width="20%"><font size="2"><strong>Matrํcula:</strong></font></td>
cMensagem += '    <td><font size="2">'+(cAlias)->MATRICULA+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>Nome:</strong></font></td>
cMensagem += '    <td><font size="2">'+alltrim((cAlias)->NOME)+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>E-mail:</strong></font></td>
cMensagem += '    <td><font size="2">'+alltrim(Iif(!Empty((cAlias)->EMAIL),(cAlias)->EMAIL,'Nใo informado.'))+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>Cargo:</strong></font></td>
cMensagem += '    <td><font size="2">'+alltrim((cAlias)->CARGO)+'</font></td>
cMensagem += '  </tr>
cMensagem += '  <tr>
cMensagem += '    <td><font size="2"><strong>Centro de Custo:</strong></font></td>
cMensagem += '    <td><font size="2">'+alltrim((cAlias)->CCUSTO)+' - '+alltrim((cAlias)->DESC_CCUSTO)+'</font></td>
cMensagem += '  </tr>
If !Empty((cAlias)->DEPTO)
	cMensagem += '  <tr>
	cMensagem += '    <td><font size="2"><strong>Departamento:</strong></font></td>
	cMensagem += '    <td><font size="2">'+(cAlias)->DEPTO+'</font></td>
	cMensagem += '  </tr>
Endif
cMensagem += '</table>
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<br />
cMensagem += '<p> MENSAGEM AUTOMมTICA GERADA PELO SISTEMA PROTHEUS. FAVOR NรO RESPONDER.
cMensagem += '<br />
cMensagem += '</p></body>
cMensagem += '</html>

cMensagem := oemtoansi(cMensagem)

fErase(cAlias)

Return(cMensagem)
