#include "rwmake.ch" 
#include "protheus.ch" 
#include "colors.ch"
                             
#DEFINE C_FOX_WIN7_64X_PT "C:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Reader.exe"
#DEFINE C_FOX_WIN7_32X_PT "C:\Arquivos de programas\Foxit Software\Foxit Reader\Foxit Reader.exe"
#DEFINE C_FOX_WIN7_32X_IN "C:\Program Files\Foxit Software\Foxit Reader\Foxit Reader.exe"
#DEFINE C_FOX_WIN8_64X_PT "C:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Reader.exe"
#DEFINE C_FOX_WIN8_32X_PT "C:\Arquivos de programas\Foxit Software\Foxit Reader\Foxit Reader.exe"
#DEFINE C_FOX_WIN8_32X_IN "C:\Program Files\Foxit Software\Foxit Reader\Foxit Reader.exe"     

// cleuto - incluidos novos caminhos para o windows 10
#DEFINE C_FOX_WINA_32X_PT "C:\Arquivos de programas\Foxit Software\Foxit Reader\Foxit Reader.exe" 	// ainda não utilizado, precisa informar o caminho correto
#DEFINE C_FOX_WINA_32X_IN "C:\Program Files\Foxit Software\Foxit Reader\Foxit Reader.exe"			// ainda não utilizado, precisa informar o caminho correto
#DEFINE C_FOX_WINA_64X_PT "C:\Arquivos de programas\Foxit Software\Foxit Reader\Foxit Reader.exe"	// ainda não utilizado, precisa informar o caminho correto
#DEFINE C_FOX_WINA_64X_IN "C:\Program Files\Foxit Software\Foxit Reader\Foxit Reader.exe"			// ainda não utilizado, precisa informar o caminho correto
#DEFINE C_FOX_WINA_64X_PTU "C:\Program Files (x86)\FOXIT SOFTWARE\FOXIT READER\FoxitReader.exe"
#DEFINE C_FOX_WINO_64X_PTU "C:\Program Files\FOXIT SOFTWARE\FOXIT READER\FoxitReader.exe"

/*{Protheus.doc} GENI030
		 	ROTINA IMPRESSÃO DE NOTAS FISCAIS NA BANCADA.
@author  	Ivan de Oliveira  
@since   	23/02/2018
@version 	1.0
@type    	User function
@Parâmetros {Nulo}, {Nulo} 
@Retorno	{Nulo}, {Nulo} 
*/
 
User Function GENI034()   
 
Local oButton1
Local oButton2
Local oButton3
Local oButton4
Local _lMarDes 		:= .F.
Local aSize     	:= {}
Local aObjects  	:= {} 
Local aInfo     	:= {} 
Local _aParam       := {}

Private _aItBrow 	:= {}
Private aHeadCpos 	:= {}   
Private _aItTesPai  := {'Todos'}  
Private _aItTransp  := {'Todos'}
Private _cFiltro    := ""  
Private _cFilTes    := "" 
Private _cDtFiltro  := ""  
Private _cDriveImpr := ""
Private oOK  		:= LoadBitmap( GetResources(), "LBOK" )
Private oNO 		:= LoadBitmap( nil, "LBNO" )
Private oVERDE    	:= LoadBitmap(GetResources(),'BR_VERDE')
Private oAMARELO  	:= LoadBitmap(GetResources(),'BR_AMARELO')
Private oAZUL	 	:= LoadBitmap(GetResources(),'BR_AZUL')
Private oPRETO	 	:= LoadBitmap(GetResources(),'BR_PRETO')                

// Verifica se a estrutura de impressão esta presente
if _ImpOk()

	// Obtém a a área de trabalho e tamanho da dialog
	aSize := MsAdvSize()
	 
	AAdd( aObjects, { 200, 200, .T., .T. } ) 
	
	// Dados da área de trabalho e separação
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
	
	// Chama MsObjSize e recebe array e tamanhos
	aPosObj := MsObjSize( aInfo, aObjects,.T.) 
	// Usa tamanhos da dialog
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta dinamicamente o bline do CodeBlock                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//bLine := &( "{ || " + cLine + " }" ) 
	
	// Criando Parâmetros.
	Aadd( _aParam, {'GEN_FAT193' , 'N', 'Define quantidade de dias' ,'a retrogir na consulta '	,'das NFs para emissão bancada.', '', 0	} )
	 
	// Criando os Parâmetros.
	u_GENI033(_aParam)   
	
	_cDtFiltro:=  dtos(date()-SuperGetmv(_aParam[01][01], .T.,30 ))	
	_aHeadCpos:= { "M/D","LEG", "Nota fiscal","Serie","Mensagem SEFAZ","Nome do cliente","Dt.Emissão NF",  "Nro.Pedido Protheus","Dt.Emissão Pedido", "Pedido Web","Pedido OLD","Nome da transportadora", "Descrição da TES", "Impressa", "Registro"} 
	    
	DEFINE MSDIALOG oDlg TITLE 'Impressao de NF Bancada' From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL 
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula dimensões                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSize := FwDefSize():New(.T.,,,oDlg)
				          
		oSize:AddObject( "CABECALHO",  100, 10, .T., .T. ) // Totalmente dimensionavel
		oSize:AddObject( "GETDADOS" ,  100, 80, .T., .T. ) // Totalmente dimensionavel      
		        
		oSize:lProp 	:= .T. 				// Proporcional             
		oSize:aMargins 	:= { 3, 3, 3, 3 } 	// Espaco ao lado dos objetos 0, entre eles 3 
		oSize:Process() 	   				// Dispara os calculos   
			
		// Grupo de Filtros
		oGrpFilt:= TGroup():New(oSize:GetDimension("CABECALHO","LININI") - 32,oSize:GetDimension("CABECALHO","COLINI")-2,;
						        oSize:GetDimension("GETDADOS","LINEND") - 237.5 , oSize:GetDimension("GETDADOS","COLEND") - 200 ,;
							    'Filtros',oDlg,,,.T.)  
		/* 
	 	Status NFe Sped050 
		[1] NFe Recebida
		[2] NFe Assinada
		[3] NFe com falha no schema XML                                                                              
		[4] NFe transmitida
		[5] NFe com problemas
		[6] NFe autorizada
		[7] Cancelamento
		*/   
	 	cTxtPesq:= Space(50)
		oTPesq  := TGet():New( oSize:GetDimension("CABECALHO","LININI") - 25 , oSize:GetDimension("CABECALHO","COLINI"),{|u| if(PCount()>0,cTxtPesq:=u,cTxtPesq) },oDlg,200,015,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTxtPesq,,,, )
		oTBPara := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 24, oSize:GetDimension("CABECALHO","COLINI")+ 200 ,"Buscar",{||if (!empty(cTxtPesq),_PesqTexto(cTxtPesq), MsgAlert('Digite um texto para pesquisa','Atenção'))},050,015,,,,.T.,,'Buscar',,,,) 
		//oTBImpr := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 24, oSize:GetDimension("CABECALHO","COLINI")+ 252 ,"Parâmetros",{||alert("Botão 04")},050,015,,,,.T.,,'Definir Parâmetros',,,,)
		oTBSair := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") + 02, oSize:GetDimension("CABECALHO","COLINI")+ 252 ,"Sair",{||oDlg:End()},050,015,,,,.T.,,'Sair da rotina',,,,)
		oTBSair:SetCss( "QPushButton{ background-color:Yellow;}")
		
		oTBBusc := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 03, oSize:GetDimension("CABECALHO","COLINI"),;
					"Impressão NF",{|| (_cFiltro:="%( ZZ5_STSEFA = 6 AND ZZ5_NFIMP <> 'S')%",_CarregaNF(_cFiltro) )},060,020,,,,.T.,,'Filtra todas NF',,,,)
		oTBBusc:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )    
		
		oTBBloq := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 03, oSize:GetDimension("CABECALHO","COLINI")+60,;
									"Com Bloqueio",{||(_cFiltro:="%ZZ5_STSEFA IN ( 3,5 )%" , _CarregaNF(_cFiltro) )},060,020,,,,.T.,,'Filtra NF´s Com Bloqueio',,,,)
		oTBBloq:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" ) 
		
		oTBImpr := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 03, oSize:GetDimension("CABECALHO","COLINI")+120,;
									"Ja impressas",{||(_cFiltro:="%ZZ5_STSEFA IN ( 6 ) AND ZZ5_NFIMP = 'S'%",_CarregaNF(_cFiltro) )},060,020,,,,.T.,,'Filtra NFs Autorizadas',,,,)
		oTBImpr:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" ) 
		
		oTBFila := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 03, oSize:GetDimension("CABECALHO","COLINI")+180,;
					"Fila Transmissão",{|| (_cFiltro:="%ZZ5_STSEFA IN ( 0,1,2,4 )%",_CarregaNF(_cFiltro,nil,.T.) )},060,020,,,,.T.,,'Filtra notas não transmitidas',,,,)
		oTBFila:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
		                                                                   
		// Grupo de Funções.
		oGrpFunc:= TGroup():New( oSize:GetDimension("CABECALHO","LININI") - 32 , oSize:GetDimension("GETDADOS","COLINI") + 305 , oSize:GetDimension("GETDADOS","LINEND") - 237  ,   oSize:GetDimension("GETDADOS","COLEND"), 'Funções',oDlg,,,.T.)
		
		oTBDanfe:= TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 15, oSize:GetDimension("CABECALHO","COLINI")+308,"Danfe",{|| _ImpDanfe() },060,020,,,,.T.,,'Danfe',,{|| !Empty(oBrowse:AARRAY) },,)
		oTBDanfe:SetCss( "QPushButton{ background-color:Yellow;}" )  
		oTBSelTo:= TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") - 15, oSize:GetDimension("CABECALHO","COLINI")+370,"Selecionar Todas",{|| _Inverter()},060,020,,,,.T.,,'Marca/Desmarca itens',,,,)
		oTBSelTo:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )  
		
		_lChkNat:= .T. 
		_lChkTr := .T.  
		/*
		oCkTran := TCheckBox():New(oSize:GetDimension("CABECALHO","LININI")    ,oSize:GetDimension("CABECALHO","COLINI")+440,'Transportadora',{|| _lChkTr },oDlg,100,400,,,,,,,,.T.,,,)
		oCkNatur:= TCheckBox():New(oSize:GetDimension("CABECALHO","LININI") - 15,oSize:GetDimension("CABECALHO","COLINI")+440,'Natureza Operação',{|| _lChkNat },oDlg,100,400,,,,,,,,.T.,,,)
		*/
		_cItNat := _aItTesPai[1]
		oCboNat := TComboBox():New(oSize:GetDimension("CABECALHO","LININI") - 15,oSize:GetDimension("CABECALHO","COLINI")+450,{|u|if(PCount()>0,_cItNat:=u,_cItNat)}, _aItTesPai,150,10,oDlg,,{|| .T.},,,,.T.,,,,{|| _lChkNat },,,,,'_cItNat')
		
		_cItTra	:= _aItTransp[1]
		oCboTra := TComboBox():New(oSize:GetDimension("CABECALHO","LININI") ,oSize:GetDimension("CABECALHO","COLINI")+450,{|u|if(PCount()>0,_cItTra:=u,_cItTra)}, _aItTransp,150,10,oDlg,,{|| .T.},,,,.T.,,,,{|| _lChkTr },,,,,'_cItTra')
		oTBFilt := TButton():Create(oDlg,oSize:GetDimension("CABECALHO","LININI") + 12 , oSize:GetDimension("CABECALHO","COLINI")+550,"Filtrar",{|| _cFiltro() },050,015,,,,.T.,,'Filtrar itens',,,,) 
		
			/*
			
			oTBBusc:SetCss( "QPushButton{ background-color:LightSalmon; font:italic bold 16px/34px Tahoma, serif; }" )
	    	oTBBusc:SetCss( "QPushButton{ background-color:DeepSkyBlue;}" )
			oButton3:SetCss( "QPushButton{ background-color:LightGreen; font:italic bold 16px/34px Tahoma, serif; }" )
			oButton5:SetCss( "QPushButton{ background-color:LightPink; font:italic bold 16px/34px Tahoma, serif; }" )
			
			*/
	
		oGrpBro:= TGroup():New( oSize:GetDimension("CABECALHO","LININI") +31, oSize:GetDimension("CABECALHO","COLINI")-2 , oSize:GetDimension("GETDADOS","LINEND")    ,   oSize:GetDimension("GETDADOS","COLEND"), '',oDlg,,,.T.)
		oBrowse:= TWBrowse():New( oSize:GetDimension("GETDADOS","LININI") + 5 ,oSize:GetDimension("GETDADOS","COLINI"),;
		                           oSize:GetDimension("GETDADOS","COLEND")-5,oSize:GetDimension("GETDADOS","LINEND") - 74.5,;
								   ,_aHeadCpos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)       
		oTBBusc:Click()
		oBrowse:SetArray(_aItBrow)
	    oBrowse:bLine 		:= {||{ If(_aItBrow[oBrowse:nAt,01],oOK,oNO), _MudaCor(_aItBrow[oBrowse:nAt,02],_aItBrow[oBrowse:nAt,14]) ,;
	    					_aItBrow[oBrowse:nAt,03],;
	    					_aItBrow[oBrowse:nAt,04],;
	    					_aItBrow[oBrowse:nAt,05],;
	    					_aItBrow[oBrowse:nAt,06],;
	    					_aItBrow[oBrowse:nAt,07],;
	    					_aItBrow[oBrowse:nAt,08],;
	    					_aItBrow[oBrowse:nAt,09],;
	    					_aItBrow[oBrowse:nAt,10],;
	    					_aItBrow[oBrowse:nAt,11],;
	    					_aItBrow[oBrowse:nAt,12],;  
	    			   		_aItBrow[oBrowse:nAt,13],;
	    			   		_aItBrow[oBrowse:nAt,14],_aItBrow[oBrowse:nAt,15] } }
	    					
		oBrowse:lAdJustColSize := .T.
	 	oBrowse:bLDblClick 	   :=  {|| IIF( _aItBrow[oBrowse:nAt,02] == 6 , _aItBrow[oBrowse:nAt][01] := !_aItBrow[oBrowse:nAt][01] , nil ) }
	  
	  ACTIVATE MSDIALOG oDlg CENTERED  
	  
Endif
		
Return   

/*{Protheus.doc} _MudaCor
		 	MUDA COR DO BROWSE NOTAS FISCAIS NA BANCADA.
@author  	Ivan de Oliveira  
@since   	23/02/2018
@version 	1.0
@type    	Static function
@Parâmetros {_nOp}, {Caractere} , Tipo Status NF
@Retorno	{Nulo}, {Nulo} 
*/
    

Static Function _MudaCor(_nOp, _cImp) 
                                         
_oRet := ""

do case

	case _nOp == 6 .and. _cImp == 'N'
		_oRet := oVERDE
	case _nOp == 0
	    _oRet := oAMARELO
	case _nOp == 1 .or. _nOp == 2 .or. _nOp = 4
		_oRet := oAZUL 
	case _nOp == 3 .or. _nOp = 5
		_oRet := oPRETO   
		
Endcase

Return _oRet   

/*{Protheus.doc} _CarregaNF
//			Função que seleciona as NFs a imprimir
@author 	iVan de Oliveira  
@since 		23/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _CarregaNF(_cFil,_nRegistro,lFila)  
 
Local _aItBrowse	:= {} 
Local _lMarcar	:= .f.
Local aUsrDep		:= Separa(SuperGetMv("GEN_USRWMS",.f.,"PIX;000218#"),"#")
Local _cFilUs		:= ""
Local cAllDep		:= SuperGetMv("GEN_ALLWMS",.f.,"000218#")  

Default _nRegistro	:= 0
Default lFila			:= .F.

nPosUsr	:= aScan(aUsrDep, {|x| AllTrim(Right(x,6)) == RetCodUsr() } )

If nPosUsr > 0
	_cFilUs	:= "%ZZ5_USUBAN ='" + Separa(aUsrDep[nPosUsr],";")[1] + "'%"
ElseIf RetCodUsr() $ cAllDep .OR. lFila
	_cFilUs	:= "%ZZ5_USUBAN <> '******'%"
Else
	MsgStop("Usuário não identificado!")
	Return nil	
EndIf

// CONSULTA AS NFS DISPONIVEIS.  
_cAlias 	:= GetNextAlias()
_aItBrow	:= {}         
_aItTesPai  := {'Todas'}  
_aItTransp  := {'Todas'}  
oTPesq:CTEXT:= space(50) 

BeginSql ALIAS _cAlias  

   %noParser%
   SELECT 
		X.*, 
		( SELECT C6_TES FROM %table:SC6% SC6 WHERE SC6.D_E_L_E_T_ = X.SC5DEL  AND C6_NUM = X.ZZ5_PEDIDO 
											   AND ROWNUM = 1 ) AS SC6TES
	FROM
		(
			SELECT 	
					ZZ5_FILIAL, ZZ5_STATUS, ZZ5_NOTA, ZZ5_SERIE   , A1_NOME  , ZZ5_IDFUNC, ZZ5_DTNF,  
					ZZ5_PEDIDO,C5_EMISSAO , C5_XPEDWEB, C5_XPEDOLD, C5_TRANSP, A4_NOME   ,  ZZ5_STSEFA, 
					SC5.D_E_L_E_T_ SC5DEL , ZZ5_NFIMP, ZZ5_DSEF, ZZ5.R_E_C_N_O_ REGIS 
           
			FROM %table:ZZ5% ZZ5    
        
			INNER JOIN %table:SC5%  SC5 ON SC5.D_E_L_E_T_ = ZZ5.D_E_L_E_T_ AND C5_FILIAL  = ZZ5_FILIAL AND 
			                         C5_NUM = ZZ5_PEDIDO  

			INNER JOIN %table:SA1%  SA1 ON SA1.D_E_L_E_T_ = SC5.D_E_L_E_T_  AND A1_FILIAL = %xfilial:SA1% AND 
									 A1_COD = C5_CLIENTE AND  A1_LOJA = C5_LOJACLI

		    LEFT JOIN %table:SA4%   SA4 ON SA4.D_E_L_E_T_ = SC5.D_E_L_E_T_  AND A4_FILIAL = %xfilial:SA4% AND 
									A4_COD = C5_TRANSP  

			WHERE 
					ZZ5.%notDel% 
					AND ZZ5_FILIAL = %xfilial:ZZ5%
					/*AND ZZ5_NOTA   <>' '*/
					AND ZZ5_IDFUNC = '0004'
					/*AND ZZ5_STATUS = '01'*/
					/*AND ZZ5_NFIMP = ' '*/ 
					/*AND ZZ5_STSEFA NOT IN(3,5,7)*/
					AND %Exp:_cFil%	
					AND %Exp:_cFilUs% 
					AND ZZ5_DTNF >= %Exp:_cDtFiltro% 
					) X
 
			 
	ORDER BY X.ZZ5_FILIAL, X.ZZ5_NOTA, X.ZZ5_SERIE 
	
	Endsql  
	                                       
	//GETLASTQUERY()[2] //--> CONSULTA QUERY
	
	TcSetfield( _cAlias,'ZZ5_DTNF'  ,"D", 10 ) 
	TcSetfield( _cAlias,'C5_EMISSAO',"D", 10 )
	TcSetfield( _cAlias,'ZZ5_STSEFA',"N", 1,0 )	
	
	// Processando as linhas 
	(_cAlias)->( DbGotop() ) 
	While !(_cAlias)->( Eof() )   
	
	 	_cTmpTes := GetAdvFVal("SF4","F4_XTESPAI",FwXFilial("SF4") + (_cAlias)->SC6TES,1,"N") 
	 	_cTesPai := Alltrim(GetAdvFVal("SF4","F4_FINALID",FwXFilial("SF4") + _cTmpTes,1,"N"))    
	 	  
		_lFilTes := .F.
	 	if !empty(_cFilTes) 
	 	
	 		_lFilTes := alltrim(_cFilTes)#_cTmpTes
	 	
	 	Endif           
	 	
	 	// Filtro por Registro de consulta geral
	 	if _nRegistro > 0 
	 	
	 		_lFilTes := _nRegistro#(_cAlias)->REGIS
	 	
	 	Endif
	 	
	 	if !_lFilTes
	 	
			Aadd(_aItBrow, { _lMarcar,;
						   	(_cAlias)->ZZ5_STSEFA,;
						   	Alltrim((_cAlias)->ZZ5_NOTA),;
					        Alltrim((_cAlias)->ZZ5_SERIE),; 
					        Alltrim((_cAlias)->ZZ5_DSEF),; 
					    	Alltrim((_cAlias)->A1_NOME),;
					    	dtoc((_cAlias)->ZZ5_DTNF),;
					   		(_cAlias)->ZZ5_PEDIDO,;     
					   		dtoc((_cAlias)->C5_EMISSAO),;  
					   		Alltrim((_cAlias)->C5_XPEDWEB),; 
					   		Alltrim((_cAlias)->C5_XPEDOLD),;
					   		Alltrim((_cAlias)->A4_NOME),;
					   		_cTesPai,;
					   		if((_cAlias)->ZZ5_NFIMP<>'S', 'N','S'),;
					   		(_cAlias)->REGIS }) 
					   		
			// Preenchendo TES PAI e Transportadora 
			if ascan( _aItTesPai, alltrim(_cTmpTes) + '-' +  _cTesPai ) == 0 
			
				aadd( _aItTesPai, alltrim(_cTmpTes) + '-' +  _cTesPai )
			
			Endif  
			
			if ascan( _aItTransp, Alltrim((_cAlias)->A4_NOME) + '-' + (_cAlias)->C5_TRANSP ) == 0  
			
				aadd( _aItTransp, Alltrim((_cAlias)->A4_NOME) + '-' + (_cAlias)->C5_TRANSP )
			
			Endif 
					   		
		Endif
		  
	   (_cAlias)->(DbSkip())
			                                   
	Enddo

	(_cAlias)->(DbCloseArea())  	
   
	if empty(_aItBrow)
	
		_aItBrow  := { {_lMarcar,0,' ',' ',' ','  /  /    ',' ','  /  /    ',' ',' ',' ' ,' ',' ' , ' ', 0 } } 
		
	Endif  
	
	//Atualiza filtros    
	oCboNat:SetItems(_aItTesPai)
	oCboTra:SetItems(_aItTransp)
	_cFilTes:= ""
	     
	// Atualiza o Browse
	oBrowse:aArray := _aItBrow
	oBrowse:Gotop()
	oBrowse:Refresh() 
	
Return  
 
 /*{Protheus.doc} _CarregaNF
//			Função que filtra os itens dos combo(Transp./Tes)
@author 	iVan de Oliveira  
@since 		23/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _cFiltro()  
_cContTr  := Upper(oCboTra:AITEMS[oCboTra:NAT]) 
_cContTes := Upper(oCboNat:AITEMS[oCboNat:NAT]) 
_nPosCTr  := Rat('-',_cContTr)   
_nPosCTes := at('-',_cContTes) 
_cFiltTmp := _cFilTes := ""

if _cContTr#'TODAS'.and._nPosCTr>0
                                   
	_cCod     := Alltrim(Substr(_cContTr,_nPosCTr+1,len(_cContTr))) 
	_cFiltTmp +=	" AND C5_TRANSP = '" + _cCod + "'"
    
Endif

if _cContTes#'TODAS' .and._nPosCTes>0

	_cFilTes := Alltrim(Substr(_cContTes,1, _nPosCTes-1 ))
	 
Endif  

_cFiltTmp+= "%"   
_cFilFin := if ( len(_cFiltTmp) > 2, Substr(_cFiltro,1,len(_cFiltro)-1) + _cFiltTmp, _cFiltro )

//Carrega os itens filtrados ou n]ao em tela.
_CarregaNF(_cFilFin )  
	
 Return    
 
/*{Protheus.doc} _Inverter
//			Inverte as Marcações(Marca/Desmarca)
@author 	iVan de Oliveira  
@since 		23/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _Inverter() 
   
Local _nIt := 0    

//Marcando/Desmarca itens
for _nIt := 1 to len(oBrowse:AARRAY)  
     
	// Somente NF autorizadas podem ser emitidas Danfe
	if oBrowse:AARRAY[_nIt][02] == 6

		oBrowse:AARRAY[_nIt][01] := !oBrowse:AARRAY[_nIt][01] 
		
	Endif
	
Next
  
// Atualiza browse.
oBrowse:Gotop()
oBrowse:Refresh() 

Return 

/*{Protheus.doc} _PesqTexto
//			Realiza pesquisa por qualuer texto
@author 	iVan de Oliveira  
@since 		23/02/2018
@version 	1.0

@type 		Static function
*/
Static Function _PesqTexto(_uTexto)           

Local _nIt := 0
Local _nHea:= 0 
Local _nReg:= 0
 
// Se foi informado algo a pesquisar.               
if !empty(_uTexto)

	//Marcando/Desmarca itens
	for _nIt := 1 to len(oBrowse:AARRAY)   
	
		for _nHea := 1 to len(_aHeadCpos) 
		      
			// Pesquisa somente por texto válido ao usuário
			if _nHea < len(_aHeadCpos)-2 .and._nHea>2
		         
				// Campos do tipo caracter
				if valtype(oBrowse:AARRAY[_nIt][_nHea]) $ '|C|L|' 
				
					if Alltrim(upper(_uTexto)) $ upper( Alltrim(cValtoChar(oBrowse:AARRAY[_nIt][_nHea])) )
					
						_nReg := _nIt//oBrowse:AARRAY[_nIt][len(_aHeadCpos)] 
						_nHea := len(_aHeadCpos) + 1
					 	_nIt  := len(oBrowse:AARRAY) + 1
					
					Endif  
					
				// Campos do tipo numérico
				ElseIf Valtype(oBrowse:AARRAY[_nIt][_nHea]) == 'N'  
				
				   if Alltrim(upper(_uTexto)) == upper( Alltrim(cValtoChar(oBrowse:AARRAY[_nIt][_nHea])) )
				   
				   		_nReg := _nIt//oBrowse:AARRAY[_nIt][len(_aHeadCpos)]  
				   		_nHea := len(_aHeadCpos) + 1
					 	_nIt  := len(oBrowse:AARRAY) + 1
				   
				   Endif
			
		   		Endif   
		   		
		 	Endif
	     
	 	Next
		
	Next    
	
	// COnteúdo não encontrado
	if _nReg == 0 
	
		MsgAlert ('O conteúdo: ' + Alltrim(upper(_uTexto)) + ' não foi localizado', 'Atenção' )
		
	Else
	
		// Posicionando no item. 
		oBrowse:GoPosition( _nReg)
	
	Endif 
	
Endif 

oTPesq:CTEXT:= space(50) 
	
Return

/*{Protheus.doc} _PesqTexto
//			Imprime as Danfe selecionadas.
@author 	iVan de Oliveira  
@since 		24/02/2018
@version 	1.0
@type 		Static function
*/
Static Function _ImpDanfe  

Local _lEncDanfe := .F. 
lOCAL _nIt       := 0  
Local _cPastaPDF := SuperGetmv('GEN_FAT191', .T., '\DANFE_PDF\')   
Local _cTmpDir   := "c:\temp\" //GetTempPath()   
Local _cIniDir   := "c:\" //Left(GetTempPath(),3)
Local cParam		:= " /t "
Local lPreview	:= .F.

//Marcando/Desmarca itens
for _nIt := 1 to len(oBrowse:AARRAY) 

	if oBrowse:AARRAY[_nIt][01]  
	   
		_cNomePDF  := Alltrim(FwXfilial('SF2')) + Alltrim(oBrowse:AARRAY[_nIt][03]) + Alltrim(oBrowse:AARRAY[_nIt][04]) + '.pdf'
		  
		// Verifica se o PDF esta na pasta para impressão.
		if file(_cPastaPDF + _cNomePDF) 
			Ferase( _cTmpDir + _cNomePDF)
	   		// Copia arquivos do servidor para o remote local 
			_bOk := CpyS2T( _cPastaPDF + _cNomePDF, _cTmpDir, .F. )
			//_bOk := __Copyfile(_cPastaPDF + _cNomePDF, _cTmpDir+_cNomePDF) 
			//IIF( File(_cTmpDir+_cNomePDF) , "achou pdf "+_cTmpDir+_cNomePDF , "não achou pdf"+_cTmpDir+_cNomePDF )
			
			if _bOk .AND. File(_cTmpDir+_cNomePDF)
				
			Do Case
				Case File(C_FOX_WIN7_64X_PT)
					_cLinExec	:= C_FOX_WIN7_64X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')
				Case File(C_FOX_WIN7_32X_PT)	
					_cLinExec	:= C_FOX_WIN7_32X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')
					
				Case File(C_FOX_WIN7_32X_IN)	
					_cLinExec	:= C_FOX_WIN7_32X_IN+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')	
					
				Case File(C_FOX_WIN8_64X_PT)
					_cLinExec	:= C_FOX_WIN8_64X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')
					
				Case File(C_FOX_WIN8_32X_PT)	
					_cLinExec	:= C_FOX_WIN8_32X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')
					
				Case File(C_FOX_WIN8_32X_IN)	
					_cLinExec	:= C_FOX_WIN8_32X_IN+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')			
					
				Case File(C_FOX_WINA_32X_PT)
					_cLinExec	:= C_FOX_WINA_32X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')				
					
				Case File(C_FOX_WINA_32X_IN)
					_cLinExec	:= C_FOX_WINA_32X_IN+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')				
					
				Case File(C_FOX_WINA_64X_PT)
					_cLinExec	:= C_FOX_WINA_64X_PT+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')				
				
				Case File(C_FOX_WINA_64X_PTU)
					_cLinExec	:= C_FOX_WINA_64X_PTU+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')						
				
				Case File(C_FOX_WINO_64X_PTU)
					_cLinExec	:= C_FOX_WINO_64X_PTU+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')						
					
				Case File(C_FOX_WINA_64X_IN)
					_cLinExec	:= C_FOX_WINA_64X_IN+cParam+' "'+_cTmpDir+_cNomePDF+'" '+IIF(lPreview,"",' "'+_cDriveImpr+'" ')				
					
				Otherwise
					MsgStop("Não localizei o Software 'Foxit Reader', informe ao departamnto de TI.") 
			EndCase	
			 	 
				_nRet := WinExec(_cLinExec)	
				
				if _nRet == 0  
				
					_nReg 	   := oBrowse:AARRAY[_nIt][len(oBrowse:AARRAY[_nIt])]
					_lEncDanfe := .T.
					
					dbSelectArea("ZZ5")
					dbGoto(_nReg) 
				
					RecLock("ZZ5",.F.)
					ZZ5->ZZ5_NFIMP	:= 'S' 
					MsUnLock()  
					
				Else
				
					MsgAlert ('Não foi possível realizar a impressão do arquivo para impressora, verifique com o suporte esta ocorrência e tente novamente !','Atenção')	
							
				Endif 
				
				// Apagar arquivo temporário
				//Ferase( _cTmpDir + _cNomePDF)
				
			Else
			
				MsgAlert ('Não foi possível copiar o arquivo .pdf da NF do local: ' + _cPastaPDF + _cNomePDF +', verifique com o suporte esta ocorrência e tente novamente !','Atenção')
				
			Endif
				 
		Else 
		
			MsgAlert ('Não foi possível encontrar o arquivo .pdf da NF no local: ' + _cPastaPDF + _cNomePDF +', verifique com o suporte esta ocorrência e tente novamente !','Atenção')
		
		Endif
	
	Endif

Next  
 
// Danfe não encontrada
if !_lEncDanfe 
                         
	MsgAlert ('Nenhuma NF foi selecionada para impressão !', 'Atenção' ) 
	
Else 
     
	// Carrega os itens novamente
	oTBBusc:Click()

Endif

Return  

/*{Protheus.doc} _ImpOk
//			Verifica se o ambiente de impressão esta correto.
@author 	iVan de Oliveira  
@since 		24/02/2018
@version 	1.0
@type 		Static function
*/
Static Function _ImpOk  

lOCAL _lRet    := .F.  
Local _cIniDir := Left(GetTempPath(),3)

// Verifica se o Foxit Reader adminesta instalado na estação.
_nRet := 0//ShellExecute( "find", "%PROGRAMFILES%\Foxit Software\Foxit Readex\", "", _cIniDir, 2 )

//  Retorno 2 inexistência do aplicativo.
if _nRet == 2 

	MsgStop("Não foi possível executar o Software Foxit Reader. Solicite ao suporte sua instalação para prosseguir !", "Atenção")  

Else
	
	// Verifica se existe a seção no .ini Smartclient. 
	cClientIni := GetRemoteIniName() 
	cSession   := "printer_"+lower(Alltrim(GetComputerName()))  
	cPadrao    := "" 
	cChave1	   := "default" 
	cChave2	   := "local"
	_cDriveImpr:= GetPvProfString(cSession, cChave1 , cPadrao, cClientIni)
	
	// Caso não exista a chave, solicitar impressora padrão.
	if empty(_cDriveImpr)   
	
		cTitulo	:= 'Impressão'
		cTexto	:= 'Selecione a impressão que deseja enviar o arquivo!' 
		cTexto2	:= 'Confirma impressora?'
	 	
	  	aVizu	:= {'Sim','Nao'}
	 	cPrinter:= ""
	  	cVizu	:= ""
	  	cRecno	:= 0
		aImpress:= GetImpWindows( .f. )
	
		DEFINE MSDIALOG _oDlg TITLE cTitulo FROM 000,000 TO 200,330 OF oMainWnd Pixel	
			_oPanel1:=  TPanel():New( 10, 10, ,_oDlg, , , , , , 150, 80, .F.,.F. )
	
			@ 01,01 Say _oSay VAR ""  SIZE LEN(cTexto),01 OF _oPanel1 
			_oSay:SetText(" "+OemToAnsi(cTexto))
			_oSay:Align := CONTROL_ALIGN_TOP
			
			olCombo:= tComboBox():New(37,300,{|u|if(PCount()>0,cPrinter:=u,cPrinter)},aImpress,100,20,_oPanel1,,{|| },,,,.T.,,,,,,,,,"clCombo")
			olCombo:Align := CONTROL_ALIGN_TOP
			
			@ 00,00 Say _oSayB VAR ""  SIZE 10,1 OF _oPanel1
			_oSayB:SetText(" "+OemToAnsi(SPACE(10)))	
			_oSayB:Align := CONTROL_ALIGN_TOP
					
			@ 00,00 Say _oSayA VAR ""  SIZE LEN(cTexto2),01 OF _oPanel1
			_oSayA:SetText(" "+OemToAnsi(cTexto2))	
			_oSayA:Align := CONTROL_ALIGN_TOP
			
			olComboB:= tComboBox():New(37,300,{|u|if(PCount()>0,cVizu:=u,cVizu)},aVizu,100,20,_oPanel1,,{|| },,,,.T.,,,,,,,,,"cVizu")
			olComboB:Align := CONTROL_ALIGN_TOP
				
			DEFINE SBUTTON oBut1 FROM 50, 50  TYPE 1 ACTION (_oDlg:End())	 ENABLE of _oPanel1
			oBut1:Align:= CONTROL_ALIGN_RIGHT    
	
		ACTIVATE MSDIALOG _oDlg CENTERED
	
		_cDriveImpr	:= cPrinter
	     
		// Grava no .INI do server.
	 	//WriteProfString(cSession,cChave1, cPrinter, .T.)
	   	//WriteProfString(cSession,cChave2, "CLIENT", .T.) 
	                                                    
	 	WritePProString ( cSession, cChave1, cPrinter, cClientIni ) 
	 	WritePProString ( cSession, cChave2, "CLIENT", cClientIni )
	 
		_lRet := IIF(cVizu=='Sim',.T.,.F.)
    
    Else
    
    	_lRet    := .T.
    
 	Endif
    
Endif

Return _lRet