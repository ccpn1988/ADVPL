
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103SE2  ºAutor  ³cleuto Lima         º Data ³  22/10/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Possibilita a adição de campos ao aCols de informação.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gen                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function MT103SE2()

Local aHead     := PARAMIXB[1]
Local lVisual   := PARAMIXB[2]
Local aRet      := {}
Local cAuxSX    := "SX3"
local aCampos   := FWSX3Util():GetAllFields( "SX3", .F. )

AADD(aRet,{ TRIM(Posicione("SX3",2,"E2_XFORPGT","X3_TITULO")),(cAuxSX)->X3_CAMPO, (cAuxSX)->X3_PICTURE,(cAuxSX)->X3_TAMANHO,;
(cAuxSX)->X3_DECIMAL, "",(cAuxSX)->X3_USADO,(cAuxSX)->X3_TIPO,(cAuxSX)->X3_F3,(cAuxSX)->X3_CONTEXT,;
(cAuxSX)->X3_CBOX, (cAuxSX)->X3_RELACAO, ".T."})

AADD(aRet,{ TRIM(Posicione("SX3",2,"E2_HIST","X3_TITULO")),(cAuxSX)->X3_CAMPO, (cAuxSX)->X3_PICTURE,(cAuxSX)->X3_TAMANHO,;
(cAuxSX)->X3_DECIMAL, "",(cAuxSX)->X3_USADO,(cAuxSX)->X3_TIPO,(cAuxSX)->X3_F3,(cAuxSX)->X3_CONTEXT,;
(cAuxSX)->X3_CBOX, (cAuxSX)->X3_RELACAO, ".T."})

Return (aRet)