#INCLUDE "TOTVS.CH" 
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*
AUTORA....: CLAUDIA BALESTRI   DATA: 03/04/2019
DESCRIÇÃO.: Rel. MAPA PARA EXPEDIÇÃO  - ESTOQUE ATUAL
*/

User Function RMAPAEXP(pProd)                                                                                                          
                                                                                                       
Private oReport   := Nil                                
Private oSection1 := Nil    //PRODUTO
Private oSection2 := Nil    //ENDEREÇO X SALDO

    oReport := ReportDef(pProd)
    oReport:PrintDialog()   

Return 

//--------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function ReportDef(pProd)                
//---------------------------------------
// Criação do componente de impressão
  
	oReport := TReport():New("","Mapa p/ Exped - Sld Estoq",, {|oReport| ReportPrint(oReport,pProd)}, "Mapa p/ Exped - Sld Estoq" )
    oReport:SetPortrait()   //SetLandscape()
	oReport:nfontbody:=11
	oReport:cfontbody:="Arial"
	oReport:oPage:setPaperSize(10) 

	
       
	//---------------------------------------	
	// Criação da seção utilizada pelo relatório
	//Seção 1//     
    
	oSection1 := TRSection():New(oReport, "Produto", {"TQ2"} /*,{Array com as ordens do relat?io}*/, /*Campos do SX3*/, /*Campos do SIX*/)		       
	TRCell():New(oSection1,"B1_COD",,"Produto","@!",18,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"B1_DESC",,"","@!",50,/*lPixel*/,/*{|| code-block de impressao }*/) 		                         

	//oSection1:SetTotalInLine(.F.)                                                                            
 	//TRFunction():New(oSection1:Cell("B1_COD"),NIL,"COUNT", /*oBreak*/,"TOTAL DE PRODUTO.: ","@E@Z 999",,.F.,.T.,.F.) 
 	
  //Fim Seção 1//
	
	
	//----------------------------------------------------------
  //Seção 2//               
      
	oSection2 := TRSection():New(oReport, "Endereços x Saldos", {"TQ1"} /*,{Array com as ordens do relat?io}*/, /*Campos do SX3*/, /*Campos do SIX*/)		       
	TRCell():New(oSection2,"CB0_LOCALI",,"Endereço","@!",25,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"QTP",,"Qt Pallet","@E@Z 9,999,999",15,/*lPixel*/,/*{|| code-block de impressao }*/) 		
	TRCell():New(oSection2,"QTL",,"Qt Litros","@E@Z 9,999,999",15,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection2,"CB0_DTNASC",,"Dt. Produz","@!",20,/*lPixel*/,/*{|| code-block de impressao }*/) 
	TRCell():New(oSection2,"CB0_DTVLD",,"Dt.Valid","@!",20,/*lPixel*/,/*{|| code-block de impressao }*/)               
	TRCell():New(oSection2,"D7_LIBERA",,"Liberado","@!",01,/*lPixel*/,/*{|| code-block de impressao }*/)   	                              

	oSection2:SetTotalInLine(.F.)                                                                            
 	TRFunction():New(oSection2:Cell("QTP"),NIL,"SUM", /*oBreak*/,"TOTAL DE PALLETS.: ","@E@Z 9,999,999",,.F.,.T.,.F.) 
 	TRFunction():New(oSection2:Cell("QTL"),NIL,"SUM", /*oBreak*/,"TOTAL EM LITROS..: ","@E@Z 9,999,999",,.F.,.T.,.F.)
	       
  //Fim Seção 2
  
  //---------------------------------------------------------------------------------------------------------------------------------  

Return oReport   

// ====================================================================================================================================

Static Function ReportPrint(oReport,pProd)             
Local   cDtProd    := ""
Local   cDtVal     := ""               
Local   cDProd     := ""
Private _cBanco    := alltrim(getmv("MV_UBDOFI"))
Private _cBancoACD := alltrim(getmv("MV_UBDACD"))                 

	
	
	cQ1:=" SELECT B1_COD, B1_DESC
	cQ1+=" FROM "+_cBancoACD+" SB1010 SB1 "
	cQ1+=" WHERE "
	cQ1+="       B1_FILIAL = '"+XFILIAL("SB1")+"'"
	cQ1+="   AND B1_COD    = '"+pPROD+"'"
	TCQUERY cQ1 NEW ALIAS "TQ2"  
	
	oSection1:Init()   	                    
    oSection1:Cell("B1_COD"):SetValue(TQ2->B1_COD)  
	oSection1:Cell("B1_DESC"):SetValue(TQ2->B1_DESC)
	oSection1:PrintLine(.F.)
	oSection1:Finish()                                              
	
	cQ1 := " SELECT CB0_LOCALI,SUM(CB0_QTDE)/1080 QTP, SUM(CB0_QTDE) QTL, CB0_DTNASC,CB0_DTVLD, D7_LIBERA "
	cQ1 += " FROM "+_cBancoACD+" CB0010 CB0," 
	cQ1 +=          _cBancoACD+" SD7010 SD7 "
	cQ1 += " WHERE "
	cQ1 += "   CB0_CODPRO  = '"+pProd+"'"  
	cQ1 += "   AND CB0_UORDCA  = ' '"
	cQ1 += "   AND CB0_UCAN    = ' '"  
	cQ1 += "   AND CB0_LOCAL   = '01'" 
	cQ1 += "   AND (CB0_LOCALI  LIKE 'BLOCO%' OR  CB0_LOCALI  LIKE 'ARM%')"
	cQ1 += "   AND D7_FILIAL   = CB0_FILIAL"
	cQ1 += "   AND D7_NUMSEQ   = CB0_NUMSEQ"
	cQ1 += "   AND D7_LIBERA   = 'S'"
	cQ1 += "   AND CB0.D_E_L_E_T_ = ' '" 
	cQ1 += "   GROUP BY CB0_LOCALI, CB0_DTNASC,CB0_DTVLD, D7_LIBERA" 
	cQ1 += "   ORDER BY D7_LIBERA, CB0_DTVLD,CB0_LOCALI,CB0_DTNASC"
	TCQUERY cQ1 NEW ALIAS "TQ1"  
  
  
	dbselectarea("TQ1")
	Do while !eof()
   
  //Carregar dados da secao 2 ---------------------------------------      
    
		  cDtPro:= substr(TQ1->CB0_DTNASC,7,2)+"/"+substr(TQ1->CB0_DTNASC,5,2)+"/"+substr(TQ1->CB0_DTNASC,1,4) 
		  cDtVal:= substr(TQ1->CB0_DTVLD,7,2)+"/"+substr(TQ1->CB0_DTVLD,5,2)+"/"+substr(TQ1->CB0_DTVLD,1,4) 
      
      oSection2:Init()   	                    
      oSection2:Cell("CB0_LOCALI"):SetValue(TQ1->CB0_LOCALI)  
      oSection2:Cell("QTP"):SetValue(TQ1->QTP) 
	    oSection2:Cell("QTL"):SetValue(TQ1->QTL) 
	    oSection2:Cell("CB0_DTNASC"):SetValue(cDtPro) 
	    oSection2:Cell("CB0_DTVLD"):SetValue(cDtVal) 
	    oSection2:Cell("D7_LIBERA"):SetValue(TQ1->D7_LIBERA) 	         
	    oSection2:PrintLine() //claudia - 06/06/2018
	        
	    //Fim Seção 2    
	    
    	DbSelectArea("TQ1")   
      Dbskip()                  
                 
  Enddo
                                        
  oSection2:Finish()       
    
	DbSelectArea("TQ1")   
	DbClosearea()          
	
	DbSelectArea("TQ2")   
	DbClosearea()                 
	                    
 Return                             

//=======================================================================================================================================================