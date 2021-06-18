#INCLUDE "rwmake.ch"
#include "report.ch"

User Function GENRCFG3   

Local oReport

oReport := f001()
oReport:PrintDialog()

Return()
         
Static Function f001()
Local oReport				//Objeto relatorio TReport (Release 4)
Local oSection1 			//Objeto secao 1 do relatorio

DEFINE REPORT oReport NAME "GENRCFG3" TITLE "GENRCFG3" ACTION {|oReport| f002( oReport )} DESCRIPTION "Rotinas dos menus de acesso"

oReport:SetLandScape()

DEFINE SECTION oSection1 OF oReport TITLE "Menus" TABLES ""      // SECAO 1

DEFINE CELL NAME "MENU"	OF oSection1 ALIAS "" SIZE 100 TITLE "Menu"
DEFINE CELL NAME "TITULO"	OF oSection1 ALIAS "" SIZE 100 TITLE "Titulo"
DEFINE CELL NAME "ROTINA"	OF oSection1 ALIAS "" SIZE 50  TITLE "Rotina"
DEFINE CELL NAME "ACESSOS"	OF oSection1 ALIAS "" SIZE 20  TITLE "Acessos"

Return oReport

//Impressão dos apontamentos
Static Function f002(oReport)

Local oSection1 := oReport:Section(1)		//Objeto secao 1 do relatorio (Cabecalho, campos da tabela SU7)
Local cBuffer
Local ny,nw,nx	:= 0

Private nHandle		:= 0
Private _aMenuRel 	:= {}
Private _lMenuItem 	:= .F.
Private _lMenuAcc  	:= .F.
Private _cMenuItem 	:= '<MenuItem Status'
Private _cMenuGrupo	:= '<Menu Status'
Private _cHidden	:= 'Hidden'
Private _cEnable	:= 'Enable'

Private _cAccess	:= '<Access>'
Private _cCol1 		:= ''
Private _cCol2 		:= ''
Private _cCol3 		:= ''
Private _aSysMenu 	:= {}
Private _aLocais 	:= {}

AADD(_aLocais,"\system\*.xnu")
AADD(_aLocais,"\system\menus\_GEN\*.xnu")

For nw:=1 To Len(_aLocais)
	
	_aSysMenu := Directory(_aLocais[nw], "S")
	
	For ny:=1 To Len(_aSysMenu)
		
		If ('sigacon' $ _aSysMenu[ny][1])
			
		
		oReport:IncMeter()
		nHandle	:= FT_FUse(Left(_aLocais[nw],Len(_aLocais[nw])-5) + _aSysMenu[ny][1])
		
		If nHandle == -1
			MsgAlert("O arquivo nao pode ser aberto! Verifique os parametros.","Atencao!")
			Return
		Endif
		
		FT_FGoTop()
		
		While !FT_FEOF()
			cBuffer  := FT_FReadLn()
			If _cMenuGrupo $ cBuffer
				If _cHidden $ cBuffer
					_cSit := "H"
				Else
					_cSit := ""	
				Endif
				FT_FSKIP()
				cBuffer  := FT_FReadLn()
				_nPosTab := At("<",cBuffer)
				If _nPosTab > 0
					_nPosTab -= 1
				Endif
				
				_nPosIni := At(">",cBuffer)
				_col1 := AllTrim(Substr(cBuffer,_nPosIni+1,100))
				_nPosFim := At("</",_col1)
				_col1 := _cSit + Replicate(">",_nPosTab) + Left(_col1,_nPosFim-1)
				AADD(_aMenuRel,{_aSysMenu[ny][1],_col1,"",""})
				
			EndIf
			
			If _cMenuItem $ cBuffer
				If _cHidden $ cBuffer
					_cSit := "H"
				Else
					_cSit := ""	
				Endif
				FT_FSKIP()
				cBuffer  := FT_FReadLn()
				_nPosTab := At("<",cBuffer)
				If _nPosTab > 0
					_nPosTab -= 1
				Endif
				
				_nPosIni := At(">",cBuffer)
				_col1 := AllTrim(Substr(cBuffer,_nPosIni+1,100))
				_nPosFim := At("</",_col1)
				_col1 := _cSit + Replicate("-",_nPosTab) + Left(_col1,_nPosFim-1)
				FT_FSKIP(3)
				
				cBuffer  := FT_FReadLn()
				
				_nPosIni := At(">",cBuffer)
				_col2 := AllTrim(Substr(cBuffer,_nPosIni+1,100))
				_nPosFim := At("</",_col2)
				_col2 := Left(_col2,_nPosFim-1)
				
				AADD(_aMenuRel,{_aSysMenu[ny][1],_col1,_col2,""})
				
			EndIf
			
			If _cAccess $ cBuffer
				_nPosIni := At(">",cBuffer)
				_col3 := AllTrim(Substr(cBuffer,_nPosIni+1,100))
				_nPosFim := At("</",_col3)
				_col3 := Left(_col3,_nPosFim-1)
				_aMenuRel[Len(_aMenuRel)][4] := _col3
			Endif
			FT_FSKIP()
		EndDo
		Endif
		FT_FUSE()
	Next ny
Next nw

oSection1:Init()

For nx := 1 To Len(_aMenuRel)
	If oReport:Cancel()
		Exit
	EndIf
	      
	oReport:IncMeter()
	oSection1:Cell("MENU"):SetValue(_aMenuRel[nx][1])
	oSection1:Cell("TITULO"):SetValue(_aMenuRel[nx][2])
	oSection1:Cell("ROTINA"):SetValue(_aMenuRel[nx][3])
	oSection1:Cell("ACESSOS"):SetValue(_aMenuRel[nx][4])
	
	oSection1:PrintLine()
Next nx

oSection1:Finish()

Return(.T.)
