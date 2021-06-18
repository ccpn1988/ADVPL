#include 'protheus.ch'   

/*
Função: GENA052

Descrição: cria novos armazéns com saldo zerado

Data:06/09/2016
*/

User Function GENA052

Local _cPerg := "GEN052A"
Local _cArmazem
Local _cProdDe
Local _cProdAte
Local _cAlias1 := GetNextAlias()
Local _aSldIni  := {}  

Private lMSHelpAuto := .T. 
Private lMSErroAuto := .F. 

      
PutSx1(_cPerg, "01", "Armazém" 		, ".", ".","mv_ch1","C",TamSx3("B2_LOCAL")[1]	, 0, 0, "G","", "", 	"", "", "MV_PAR01","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "02", "Produto de"	, ".", ".","mv_ch2","C",TamSx3("B1_COD")[1]		, 0, 0, "G","", "SB1", 	"", "", "MV_PAR02","","","","","","","","","","","","","","","","")
PutSx1(_cPerg, "03", "Produto ate"	, ".", ".","mv_ch3","C",TamSx3("B1_COD")[1]		, 0, 0, "G","", "SB1", 	"", "", "MV_PAR03","","","","","","","","","","","","","","","","")

If Pergunte(_cPerg,.T.)

	_cArmazem	:= MV_PAR01
	_cProdDe	:= MV_PAR02
	_cProdAte	:= MV_PAR03
	
	If MsgYesNo("Confirma a criação do armazém " + _cArmazem + " na filial " + xFilial("SB9") + " para os produtos " + Alltrim(_cProdDe) + " até " + Alltrim(_cProdAte) + " ?")
	
		BeginSql Alias _cAlias1
			SELECT B1_COD
			FROM %table:SB1% SB1
			WHERE SB1.B1_FILIAL =  %xFilial:SB1%
			AND SB1.B1_COD BETWEEN %Exp:_cProdDe% 	AND %Exp:_cProdAte% 
			AND SB1.B1_MSBLQL = '2'
			AND SB1.%NotDel%
			AND NOT EXISTS (SELECT 1 
							FROM %table:SB9% SB9
							WHERE SB9.B9_FILIAL =  %xFilial:SB9%
							AND SB9.B9_COD = SB1.B1_COD
							AND SB9.B9_LOCAL = %Exp:_cArmazem% 
							AND SB9.%NotDel%)
		EndSql		
        
		While !(_cAlias1)->(EOF())
		
			_aSldIni  := {}
			
			aAdd(_aSldIni	,{"B9_COD"		,(_cAlias1)->B1_COD,Nil})
			aAdd(_aSldIni  	,{"B9_LOCAL"	,_cArmazem,Nil})
			aAdd(_aSldIni  	,{"B9_QINI"		,0,Nil})
			
			MsExecAuto({|x,y,z|MATA220(x,y,z)},_aSldIni,3)
			
			If lMSErroAuto
				MostraErro()

				lMsErroAuto := .F.
			Endif
		
			(_cAlias1)->(DbSkip())
		End
		
		MsgInfo("Fim do processamento.")		 
	Endif
Endif

Return