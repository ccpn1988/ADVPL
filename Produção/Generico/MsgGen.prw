#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MsgGen    ºAutor  ³Danilo Azevedo      º Data ³  04/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao utilizada para montar as mensagens do M-MESSENGER   º±±
±±º          ³ a serem enviadas nos eventos de todos os modulos.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN - Configuracao M-Messenger pelo SIGATMK - Call Center  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MsgGen(nTipo)

cEnt := Chr(13)+Chr(10)
cMsg := "###############   M E N S A G E M   A U T O M Á T I C A   ###############"+cEnt+cEnt

If nTipo = 1 //ADMISSAO DE FUNCIONARIO
	
	cMsg += "Funcionário admitido: "+SRA->RA_NOME +cEnt
	cMsg += "Cargo: "+Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") +cEnt
	cMsg += "Centro de Custo/Departamento: "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") +cEnt
	cMsg += "Matricula: "+SRA->RA_MAT +cEnt
	cMsg += "CPF: "+SRA->RA_CIC +cEnt
	cMsg += "E-Mail: "+SRA->RA_EMAIL +cEnt
	cMsg += cEnt
	cMsg += cEnt
	cMsg += "Favor providenciar a liberação dos acessos e permissões."+cEnt
	
ElseIf nTipo = 2 //DEMISSAO DE FUNCIONARIO
	
	cMsg += "Funcionário desligado: "+SRA->RA_NOME +cEnt
	cMsg += "Cargo: "+Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC") +cEnt
	cMsg += "Centro de Custo/Departamento: "+Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01") +cEnt
	cMsg += "Matricula: "+SRA->RA_MAT +cEnt
	cMsg += "CPF: "+SRA->RA_CIC +cEnt
	cMsg += "E-Mail: "+SRA->RA_EMAIL +cEnt
	cMsg += cEnt
	cMsg += cEnt
	cMsg += "Favor providenciar o bloqueio dos acessos e permissões."+cEnt
	
Endif

Return(cMsg)
