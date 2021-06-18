#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function MA030ROT()

Local aMenu := {}
AADD(aMenu, {"Teste Ponto de Entrada", "U_xCadSA1MSG" , 0, 1})

return aMenu


User Function xCadSA1MSG()

MsgInfo("Teste de Ponto de Entrada no cadastro de Clientes " + CRLF + "NOME: " + SA1->A1_NOME)

return

/*EXCLUS�O DE CLIENTES*/
User Function M030DEL()
/*GUARDANDO OS DADOS ANTES DE ENTRAR EM UM REGISTRO*/
Local aAreaSA1 := SA1->(GetArea())

/*USADO PARA O BLOQUEIO DE UMA ROTINA PARA UM USUARIO*/
Local lRet := .T.
	MsgInfo(cUserName ,"Usu�rio - Corrente")
	/*POSICIONANDO NO RECNO NUMERO 5*/
	dbGoto(5)
	If cUserName $ 'Administrador'
		lRet := .F.
		MsgInfo("Teste de Valida��o para Exclus�o Ponto de Entrada ","Exemplo M030DEL")
	EndIf
/*VOLTANDO PARA A POSI��O INICIAL*/	
RestArea(aAreaSA1)	
return lRet


User Function MT110LOK()
/*GUARDANDO OS DADOS ANTES DE ENTRAR EM UM REGISTRO*/
Local aAreaSC1 := SC1->(GetArea())
Local lRet := .T.
/*BUSCA POSI��O DENTRO DO PARAMETRO DOIS DOS CAMPOS< RETORNANDO A POSI��O*/
Local nObs := Ascan(aHeader,{|x| Trim(x[2])=="C1_OBS"})

	//For x := 1 To Len(ACols)
		If ! aCols[N, Len(AHeader)+1]
			if Empty(aCols[N, nObs])
				MsgInfo("Teste de Valida��o Tudo OK Solicita��o de Compras ","Exemplo MT110TOK")
				lRet := .F.
			EndIf
		EndIf		
	//Next x
		
/*VOLTANDO PARA A POSI��O INICIAL*/	
RestArea(aAreaSC1)	
return lRet