#include 'protheus.ch'

//Adiciona botões no Documento de Entrada
User Function MA103OPC()

Local aRet := {}

aAdd(aRet,{'Acerto Cliente'		, 'U_GENA013', 0, 5})
aAdd(aRet,{'XML Atlas'			, 'U_GENA021A("1")', 0, 3})
aAdd(aRet,{'XML Ret. Grafica'	, 'U_GENA021A("4")', 0, 3})
aAdd(aRet,{'XML Dev. Intercia'	, 'U_GENA021A("5")', 0, 3})
aAdd(aRet,{'XML Dev. Consig.'	, 'U_GENA021A("2")', 0, 3})
aAdd(aRet,{'XML Ret. Oferta'	, 'U_GENA021A("9")', 0, 3})
aAdd(aRet,{'XML TES 414'		, 'U_GENA021A("A")', 0, 3})
AADD(aRet,{"Ret.Origem Aparas"	,"Processa( {|| U_GENA021A('C')})"	,0,3})
aAdd(aRet,{'Títulos a Pagar'	, 'FINR150', 0, 3})
                                                                        
Return(aRet)