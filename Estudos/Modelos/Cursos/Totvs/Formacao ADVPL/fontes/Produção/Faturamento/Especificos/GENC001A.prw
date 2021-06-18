#include "protheus.ch"
#include "topconn.ch"

//CODIGO ISBN
User Function GENC0101(_cItm)

Private _xRet

//Selecion os dados
_cSQL := " SELECT DISTINCT B1_ISBN AS CAMPO, B1_DESC AS DESCRICAO "
_cSQL += " FROM " + RetSqlName("SB1") + " "
_cSQL += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' " 
_cSQL += " AND B1_ISBN <> ' ' " 
_cSQL += " AND D_E_L_E_T_ = ' ' "
_cSQL += " ORDER BY CAMPO "

_xRet := U_GENC01A(_cSQL,_cItm,.T.,"1")

If Len(Alltrim(_xRet)) > 500
	Alert("Atenção! Foram selecionados muitos ISBN. Verifique se todos foram gravados no filtro do relatório. Se deseja exibir todos os códigos deixe o campo de filtro em branco.")
Endif

Return _xRet

//CODIGO CLIENTE
User Function GENC0102(_cItm)

Private _xRet

//Selecion os dados
_cSQL := " SELECT DISTINCT A1_COD||A1_LOJA AS CAMPO, A1_NOME AS DESCRICAO "
_cSQL += " FROM " + RetSqlName("SA1") + " "
_cSQL += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' " 
_cSQL += " AND A1_XCANALV <> '3' "
_cSQL += " AND D_E_L_E_T_ = ' ' "
_cSQL += " ORDER BY CAMPO "

_xRet := U_GENC01A(_cSQL,_cItm,.T.,"2")

If Len(Alltrim(_xRet)) > 500
	Alert("Atenção! Foram selecionados muitos clientes. Verifique se todos foram gravados no filtro do relatório. Se deseja exibir todos os códigos deixe o campo de filtro em branco.")
Endif

Return _xRet
      
//CGC CLIENTE
User Function GENC0103(_cItm)

Private _xRet

//Selecion os dados
_cSQL := " SELECT DISTINCT A1_CGC AS CAMPO, A1_NOME AS DESCRICAO "
_cSQL += " FROM " + RetSqlName("SA1") + " "
_cSQL += " WHERE A1_FILIAL = '" + xFilial("SA1") + "' " 
_cSQL += " AND A1_XCANALV <> '3' "
_cSQL += " AND A1_CGC <> ' ' "
_cSQL += " AND D_E_L_E_T_ = ' ' "
_cSQL += " ORDER BY CAMPO "

_xRet := U_GENC01A(_cSQL,_cItm,.T.,"3")

If Len(Alltrim(_xRet)) > 500
	Alert("Atenção! Foram selecionados muitos clientes. Verifique se todos foram gravados no filtro do relatório. Se deseja exibir todos os CGCs deixe o campo de filtro em branco.")
Endif

Return _xRet

//Seleciona dados
User Function GENC01A(_cParSQL,_cItm,_lUpPq,_cTpPsq)

Private _aCodigo := {}
Private _cAliasT := GetNextAlias()

_cParSQL := ChangeQuery(_cParSQL)

TCQUERY _cParSQL NEW ALIAS (_cAliasT)

While !(_cAliasT)->(EOF())

	AADD(_aCodigo,{(_cAliasT)->CAMPO,(_cAliasT)->DESCRICAO})
	
	(_cAliasT)->(DbSkip())
	
End

(_cAliasT)->(DbCloseArea())

_aItmAtu1 := Separa(_cItm,";")
_aItmAtu2 := {}

If _cTpPsq == "1"

	SB1->(DbOrderNickName("GENISBN"))
	For _nw:=1 To Len(_aItmAtu1)
	
		If SB1->(DbSeek(xFilial("SB1")+_aItmAtu1[_nw])) .and. !Empty(_aItmAtu1[_nw])
			AADD(_aItmAtu2,{_aItmAtu1[_nw],SB1->B1_DESC})
		Else
			AADD(_aItmAtu2,{_aItmAtu1[_nw],""})
		Endif
	Next _nw 
	
ElseIf _cTpPsq == "2"

	SA1->(DbSetOrder(1))
	For _nw:=1 To Len(_aItmAtu1)
	
		If SA1->(DbSeek(xFilial("SA1")+_aItmAtu1[_nw])) .and. !Empty(_aItmAtu1[_nw])	
			AADD(_aItmAtu2,{_aItmAtu1[_nw],SA1->A1_NOME})
		Else                                             
			AADD(_aItmAtu2,{_aItmAtu1[_nw],""})
		Endif
	Next _nw 		

ElseIf _cTpPsq == "3"

	SA1->(DbSetOrder(3))
	For _nw:=1 To Len(_aItmAtu1)
	
		If SA1->(DbSeek(xFilial("SA1")+_aItmAtu1[_nw])) .and. !Empty(_aItmAtu1[_nw])	
			AADD(_aItmAtu2,{_aItmAtu1[_nw],SA1->A1_NOME})
		Else                                             
			AADD(_aItmAtu2,{_aItmAtu1[_nw],""})
		Endif
	Next _nw 		
Endif

_xRet := U_GENC01B(_aCodigo,_aItmAtu2,_lUpPq,_cTpPsq)

Return _xRet

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description
@return xRet Return Description
@author Rafael Costa Leite - rafael.leite@totvspartners.com.br
@since 07/02/2014
/*/
//--------------------------------------------------------------
/*
User Function GENC01B(_aPar1,_aPar2,_lPar3,_cPar4)

Private _aItens1 := _aPar1
Private _aItens2 := _aPar2
Private _lUp := _lPar3
Private _lArray := Iif(_cPar4=="A",.T.,.F.)
Private _oButton1
Private _oButton2
Private _oButton3
Private _oButton4
Private _oButton5
Private _oButton6
Private _oButton7
Private _oGet1
Private _cGet1 := Space(50)
Private _oScrollB1
Private _oScrollB2
Private _oDlg      
Private _oSay1
Private _oSay2
Private _oSay3
Private _oListBox1
Private _nListBox1
Private _oListBox2
Private _nListBox2
Private _xRet := ""  
Private _lTela := .T.

If Empty(_aItens1)
	_aItens1 := {}
Endif

If Empty(_aItens2)
	_aItens2 := {}
Endif
 
While _lTela
	DEFINE MSDIALOG _oDlg TITLE "Selecione os dados" FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL
	
		@ 008, 010 SAY _oSay1 PROMPT "Pesquise na lista de opções" SIZE 100, 007 OF _oDlg COLORS 0, 16777215 PIXEL
		@ 015, 010 MSGET _oGet1 VAR _cGet1 SIZE 100, 010 OF _oDlg COLORS 0, 16777215 PIXEL
	    @ 015, 125 BUTTON _oButton1 PROMPT "Pesquisar" SIZE 037, 012 OF _oDlg ACTION {|| f001()} PIXEL
	    @ 050, 125 BUTTON _oButton2 PROMPT "Adiciona >" SIZE 037, 012 OF _oDlg ACTION {|| f002()} PIXEL
	    @ 070, 125 BUTTON _oButton3 PROMPT "Todos >>" SIZE 037, 012 OF _oDlg ACTION {|| f003()} PIXEL
	    @ 115, 125 BUTTON _oButton4 PROMPT "<< Todos" SIZE 037, 012 OF _oDlg ACTION {|| f004()} PIXEL
	    @ 135, 125 BUTTON _oButton5 PROMPT "< Remover " SIZE 037, 012 OF _oDlg ACTION {|| f005()} PIXEL
	    @ 175, 194 BUTTON _oButton6 PROMPT "Confirmar" SIZE 037, 012 OF _oDlg ACTION {|| f006()} PIXEL
	    @ 175, 243 BUTTON _oButton7 PROMPT "Cancelar" SIZE 037, 012 OF _oDlg ACTION {|| f007()} PIXEL
	  		
		@ 038, 012 SAY _oSay2 PROMPT "Lista de opções" SIZE 050, 007 OF _oDlg COLORS 0, 16777215 PIXEL
		@ 038, 180 SAY _oSay3 PROMPT "Itens selecionados" SIZE 050, 007 OF _oDlg COLORS 0, 16777215 PIXEL
	
		//@ 045, 010 LISTBOX _oListBox1 VAR _nListBox1 ITEMS _aItens1 SIZE 100, 120 OF _oDlg COLORS 0, 16777215 PIXEL
		
		@ 045, 010 LISTBOX _oListBox1 Fields HEADER "Codigo","Descricao" SIZE 100, 120 OF _oDlg COLORS 0, 16777215 PIXEL
    	_oListBox1:SetArray(_aItens1)
	    _oListBox1:bLine := {|| {	_aItens1[_oListBox1:nAt,1],;
	      							_aItens1[_oListBox1:nAt,2];
	      							}}
	      
		// DoubleClick event
		_oListBox1:bLDblClick := {|| _aItens1[_oListBox1:nAt,1] := !_aItens1[_oListBox1:nAt,1],;
		_oListBox1:DrawSelect()}
      
		@ 045, 180 LISTBOX _oListBox2 VAR _nListBox2 ITEMS _aItens2 SIZE 100, 120 OF _oDlg COLORS 0, 16777215 PIXEL
	
	ACTIVATE MSDIALOG _oDlg CENTERED

End

Return _xRet               
*/

//Botão pesquisar
Static Function f001()

//Verifica se eh primeira pesquisa
If _lUp

	_cGtUp  := Alltrim(UPPER(_cGet1)) 
	_cItmUp := Alltrim(UPPER(_aItens1[_oListBox1:NAT][_nRadMenu1])) 
Else

	_cGtUp  := Alltrim(_cGet1) 
	_cItmUp := Alltrim(_aItens1[_oListBox1:NAT][_nRadMenu1])
Endif

If _cGtUp $ _cItmUp
	_nPsqTwo := _oListBox1:NAT + 1
	
	//Verifica para nao estourar o for
	If _nPsqTwo > Len(_aItens1)
		_nPsqTwo := Len(_aItens1)
	Endif
Else
	_nPsqTwo := 1
Endif

For _nx:=_nPsqTwo To Len(_aItens1)

	If _lUp
	
		_cGtUp  := Alltrim(UPPER(_cGet1)) 
		_cItmUp := Alltrim(UPPER(_aItens1[_nx][_nRadMenu1])) 
	Else

		_cGtUp  := Alltrim(_cGet1) 
		_cItmUp := Alltrim(_aItens1[_nx][_nRadMenu1])
	Endif
	
	If _cGtUp $ _cItmUp
		
		_oListBox1:NAT := _nx
		
		_oListBox1:Refresh()
		
		Return				
	Endif

Next _nx

Return 

//Botão adicionar
Static Function f002()

Local _nPadPos := Iif(_oListBox1:NAT==0,1,_oListBox1:NAT)

If Len(_aItens2) > 0 .and. Empty(_aItens2[1][1])
	_aItens2[1][1] := _oListBox1:AARRAY[_nPadPos][1]
	_aItens2[1][2] := _oListBox1:AARRAY[_nPadPos][2]
Else
	AADD(_aItens2,{_oListBox1:AARRAY[_nPadPos][1],_oListBox1:AARRAY[_nPadPos][2]})
Endif

_oListBox2:SetArray(_aItens2)
_oListBox2:bLine := {|| {_aItens2[_oListBox2:nAt,1],_aItens2[_oListBox2:nAt,2]}}
_oListBox2:bLDblClick := {|| _aItens2[_oListBox2:nAt,1] := !_aItens2[_oListBox2:nAt,1],_oListBox2:DrawSelect()}
                         	
Return

//Botão adicionar todos
Static Function f003()

_aItens2 := {}

For _nx:=1 To Len(_aItens1)

	AADD(_aItens2,{_aItens1[_nx][1],_aItens1[_nx][2]})	

Next _nx

_oListBox2:SetArray(_aItens2)
_oListBox2:bLine := {|| {_aItens2[_oListBox2:nAt,1],_aItens2[_oListBox2:nAt,2]}}
_oListBox2:bLDblClick := {|| _aItens2[_oListBox2:nAt,1] := !_aItens2[_oListBox2:nAt,1],_oListBox2:DrawSelect()}

Return

//Botão remover todos
Static Function f004()

_aItens2 := {}

_oListBox2:SetArray(_aItens2)
_oListBox2:bLine := {|| {_aItens2[_oListBox2:nAt,1],_aItens2[_oListBox2:nAt,2]}}
_oListBox2:bLDblClick := {|| _aItens2[_oListBox2:nAt,1] := !_aItens2[_oListBox2:nAt,1],_oListBox2:DrawSelect()}

Return

//Botão remover
Static Function f005()

_aTmpLst := {}

For _nx:=1 To Len(_aItens2)

	If _nx <> _oListBox2:NAT
		AADD(_aTmpLst,{_aItens2[_nx][1],_aItens2[_nx][2]})
	Endif              
	
Next _nx

_aItens2 := _aTmpLst

_oListBox2:SetArray(_aItens2)
_oListBox2:bLine := {|| {_aItens2[_oListBox2:nAt,1],_aItens2[_oListBox2:nAt,2]}}
_oListBox2:bLDblClick := {|| _aItens2[_oListBox2:nAt,1] := !_aItens2[_oListBox2:nAt,1],_oListBox2:DrawSelect()}

Return

//Botão confirmar
Static Function f006()

_xRet := ""

For _nx:=1 To Len(_aItens2)
    
	If _nx == 1
		_xRet += _aItens2[_nx][1]	
	Else
		_xRet += ";" + _aItens2[_nx][1]
	Endif

Next nx	
	
_lTela := .F.
_oDlg:End()

Return

//Botão cancelar
Static Function f007()

_xRet := ""

_lTela := .F.
_oDlg:End()

Return

/*
		@ 045, 010 LISTBOX _oListBox1 Fields HEADER "Codigo","Descricao" SIZE 100, 120 OF _oDlg COLORS 0, 16777215 PIXEL
    	_oListBox1:SetArray(_aItens1)
	    _oListBox1:bLine := {|| {	_aItens1[_oListBox1:nAt,1],;
	      							_aItens1[_oListBox1:nAt,2];
	      							}}
	      
		// DoubleClick event
		_oListBox1:bLDblClick := {|| _aItens1[_oListBox1:nAt,1] := !_aItens1[_oListBox1:nAt,1],;
		_oListBox1:DrawSelect()}
*/

//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Rafael Costa Leite - rafael.leite@totvspartners.com.br                                              
@since 23/02/2015                                                   
/*/                                                             
//--------------------------------------------------------------
User Function GENC01B(_aPar1,_aPar2,_lPar3,_cPar4)

Private _aItens1 := _aPar1
Private _aItens2 := _aPar2
Private _lUp := _lPar3

Private _oDlg
Private _oButton1
Private _oButton2
Private _oButton3
Private _oButton4
Private _oButton5
Private _oButton6
Private _oButton7
Private _oGet1
Private _cGet1 := Space(200)
Private _oListBox1
Private _oListBox2
Private _oRadMenu1   
Private _nRadMenu1 := 1
Private _lTela := .T.

Private _cTitulo1 := ""
Private _cTitulo2 := ""

If _cPar4 == "1"
	_cTitulo1 := "ISBN"
	_cTitulo2 := "Descrição produto"
Elseif _cPar4 == "2"
	_cTitulo1 := "Cliente + Loja"
	_cTitulo2 := "Nome cliente"
Elseif _cPar4 == "3"
	_cTitulo1 := "CGC"
	_cTitulo2 := "Nome cliente"
Else
	_cTitulo1 := "Código"
	_cTitulo2 := "Descrição"
Endif

If Empty(_aItens1)
	Aadd(_aItens1,{"",""})
Endif

If Empty(_aItens2)
	Aadd(_aItens2,{"",""})
Endif

While _lTela
  DEFINE MSDIALOG _oDlg TITLE "Selecione os códigos" FROM 000, -029  TO 520, 1100 COLORS 0, 16777215 PIXEL
  
    @ 012, 012 MSGET _oGet1 VAR _cGet1 SIZE 234, 010 OF _oDlg COLORS 0, 16777215 PIXEL
    @ 011, 255 BUTTON _oButton1 PROMPT "Pesquisar" SIZE 037, 012 OF _oDlg ACTION {|| f001()} PIXEL    
    
    @ 070, 255 BUTTON _oButton2 PROMPT "Adicionar >" SIZE 037, 012 OF _oDlg ACTION {|| f002()} PIXEL
    @ 095, 255 BUTTON _oButton3 PROMPT "Todos >>" SIZE 037, 012 OF _oDlg ACTION {|| f003()} PIXEL
    @ 145, 255 BUTTON _oButton4 PROMPT "<< Todos" SIZE 037, 012 OF _oDlg ACTION {|| f004()} PIXEL
    @ 170, 255 BUTTON _oButton5 PROMPT "< Remover" SIZE 037, 012 OF _oDlg ACTION {|| f005()} PIXEL
    
    @ 236, 451 BUTTON _oButton6 PROMPT "Confirmar" SIZE 037, 012 OF _oDlg ACTION {|| f006()} PIXEL
    @ 235, 502 BUTTON _oButton7 PROMPT "Cancelar" SIZE 037, 012 OF _oDlg ACTION {|| f007()} PIXEL 

    @ 009, 304 RADIO _oRadMenu1 VAR _nRadMenu1 ITEMS _cTitulo1,_cTitulo2 SIZE 092, 017 OF _oDlg COLOR 0, 16777215 PIXEL
        
    fWBrowse1()
    fWBrowse2()

  ACTIVATE MSDIALOG _oDlg CENTERED
End

Return _xRet

//------------------------------------------------ 
Static Function fWBrowse1()
//------------------------------------------------ 

    @ 045, 010 LISTBOX _oListBox1 Fields HEADER _cTitulo1,_cTitulo2 SIZE 235, 175 OF _oDlg PIXEL ColSizes 50,50
    _oListBox1:SetArray(_aItens1)
    _oListBox1:bLine := {|| {_aItens1[_oListBox1:nAt,1],_aItens1[_oListBox1:nAt,2]}}
    _oListBox1:bLDblClick := {|| _aItens1[_oListBox1:nAt,1] := !_aItens1[_oListBox1:nAt,1],_oListBox1:DrawSelect()}

Return

//------------------------------------------------ 
Static Function fWBrowse2()                                                               
//------------------------------------------------ 

    @ 045, 304 LISTBOX _oListBox2 Fields HEADER _cTitulo1,_cTitulo2 SIZE 235, 175 OF _oDlg PIXEL ColSizes 50,50
    _oListBox2:SetArray(_aItens2)
    _oListBox2:bLine := {|| {_aItens2[_oListBox2:nAt,1],_aItens2[_oListBox2:nAt,2]}}
    _oListBox2:bLDblClick := {|| _aItens2[_oListBox2:nAt,1] := !_aItens2[_oListBox2:nAt,1],_oListBox2:DrawSelect()}

Return