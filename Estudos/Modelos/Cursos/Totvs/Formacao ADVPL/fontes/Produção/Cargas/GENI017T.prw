#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GENI017T  ºAutor  ³Danilo Azevedo      º Data ³  28/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para importacao de produtos de uso e consumo       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GEN                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GENI017T()

Local lRotMens:=.F.
Private cFunName := PROCNAME()

Prepare Environment Empresa "00" Filial "1001"
Importa()
Reset Environment

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Importa   ºAutor  ³Danilo Azevedo      º Data ³  28/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Responsavel pelo processamento da rotina                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Importa()

Local lErro   	:= .F.
Local cPath   	:= "\LogSiga\Produtos\"
Local cFile   	:= ""
Local cQuery

Private lMSHelpAuto := .T. // para nao mostrar os erro na tela
Private lMSErroAuto := .F. // inicializa como falso, se voltar verdadeiro e'que deu erro

aProd := {}
aAdd(aProd,"ALCOOL")
aAdd(aProd,"APONTADOR")
aAdd(aProd,"ARQUIVO MORTO GRANDE")
aAdd(aProd,"ARQUIVO MORTO PEQUENO")
aAdd(aProd,"BOBINA P/MÁQ DE CALCULAR")
aAdd(aProd,"BORRACHA")
aAdd(aProd,"CANETA BIC CRISTAL VER/VRD")
aAdd(aProd,"CANETA BIC DIAMANTE AZL/PRT")
aAdd(aProd,"CANETA MICROLINE 0,4MM COMPACTOR")
aAdd(aProd,"CANETA STABILO 68")
aAdd(aProd,"CANETA STABILO 808")
aAdd(aProd,"CANETA STABILO 88")
aAdd(aProd,"CART HP951XL AMAR/CIANO/MAG CN046/47/48")
aAdd(aProd,"CARTUCHO HP 662XL CZ105AB (PRETO)")
aAdd(aProd,"CARTUCHO HP 662XL CZ106AB (COLOR)")
aAdd(aProd,"CARTUCHO HP 901 CC656AL COLOR")
aAdd(aProd,"CARTUCHO HP 901XL CC654 PRETO")
aAdd(aProd,"CARTUCHO HP 950XL PRETO CN045 AL")
aAdd(aProd,"CARTUCHO HP 951XL MAGENTA CN047 AL")
aAdd(aProd,"CARTUCHO TINTA HP 21")
aAdd(aProd,"CARTUCHO TINTA HP 22")
aAdd(aProd,"CARTUCHO TINTA HP 92")
aAdd(aProd,"CARTUCHO TINTA HP 93")
aAdd(aProd,"CARTUCHO TINTA HP 96")
aAdd(aProd,"CARTUCHO TINTA HP 97")
aAdd(aProd,"CD-R")
aAdd(aProd,"CERA BECKER  4 X 5 LTS")
aAdd(aProd,"CERA BRIOSOL 4 X 5 LTS PRETA")
aAdd(aProd,"CLIPS 2/0 CX C/100")
aAdd(aProd,"CLORO 5 LT")
aAdd(aProd,"COLA 40 GR")
aAdd(aProd,"COLA 90 GR")
aAdd(aProd,"COLA BASTÃO 10 GR")
aAdd(aProd,"COPO 200 ML")
aAdd(aProd,"CORRETIVO LÍQUIDO")
aAdd(aProd,"DESINFETANTE BRIOSOL 4 X 5 LTS LAVANDA")
aAdd(aProd,"DESINFETANTE JARDIM BECKER")
aAdd(aProd,"DETERGENTE DESENGRAXANTE BECKER")
aAdd(aProd,"DETERGENTE LÍQUIDO 500 ML")
aAdd(aProd,"DETERGENTE TRIPOLIM BRIOSOL 4 X 5 LTS")
aAdd(aProd,"DVD-R")
aAdd(aProd,"ENVELOPE GEN GRANDE")
aAdd(aProd,"ENVELOPE GEN PEQUENO")
aAdd(aProd,"ENVELOPE PARDO GRANDE 24 X 34")
aAdd(aProd,"ENVELOPE PARDO PEQUENO 20 X 28")
aAdd(aProd,"ESPONJA DE AÇO")
aAdd(aProd,"ESPONJA DUPLA FACE")
aAdd(aProd,"ESTILETE GR")
aAdd(aProd,"ESTILETE PQ")
aAdd(aProd,"EXTRATOR DE GRAMPO")
aAdd(aProd,"FILME P/FAX 15 CR")
aAdd(aProd,"FILME P/FAZ 91/52")
aAdd(aProd,"FITA ADESIVA 12X30")
aAdd(aProd,"FITA ADESIVA 25X50")
aAdd(aProd,"FITA DUPLA FACE BANANA 12 X 1,5")
aAdd(aProd,"FITA DUPLA FACE BANANA 24 X 1,5")
aAdd(aProd,"FITA P/EMBRULHO MARROM")
aAdd(aProd,"FLANELA")
aAdd(aProd,"GRAFITE 0,5 C/10 UND")
aAdd(aProd,"GRAFITE 0,7 C/10 UNDS")
aAdd(aProd,"GRAFITE 0,9 C/10")
aAdd(aProd,"GRAMPEADOR PEQUENO")
aAdd(aProd,"GRAMPO 13")
aAdd(aProd,"GRAMPO 15")
aAdd(aProd,"GRAMPO 26/6 C/1000")
aAdd(aProd,"GRAMPO 80")
aAdd(aProd,"GRAMPO 9/8")
aAdd(aProd,"LÂMINA GRANDE C/10")
aAdd(aProd,"LÂMINA PEQUENA")
aAdd(aProd,"LÁPIS")
aAdd(aProd,"LAPISEIRA 0,5")
aAdd(aProd,"LUSTRA MÓVEL")
aAdd(aProd,"LUVA LATEX")
aAdd(aProd,"MARCA TEXTO")
aAdd(aProd,"ODORIZANTE DE AMBIENTE UNIQUE")
aAdd(aProd,"PANO DE CHÃO  PCT C/5")
aAdd(aProd,"PANO MULTIUSO C/5")
aAdd(aProd,"PAPEL A3 BRANCO RESMA C/500")
aAdd(aProd,"PAPEL A4 BRANCO RESMA C/500")
aAdd(aProd,"PAPEL A4 RECICLADO RESMA C/500")
aAdd(aProd,"PAPEL CARTA BRANCO RESMA C/500")
aAdd(aProd,"PAPEL HIGIÊNICO INTERF 60 X 200")
aAdd(aProd,"PAPEL OFÍCIO 1 BRANCO RESMA C/500")
aAdd(aProd,"PAPEL OFÍCIO 2 BRANCO RESMA C/500")
aAdd(aProd,"PASTA REGISTRADORA OFÍCIO")
aAdd(aProd,"PASTA SAPONACEA CRISTAL 500G")
aAdd(aProd,"PASTA SUSPENSA")
aAdd(aProd,"PERFURADOR DE PAPEL")
aAdd(aProd,"PINCEL ATÔMICO")
aAdd(aProd,"PLÁSTICO 4 FUROS")
aAdd(aProd,"RÉGUA 20 CM")
aAdd(aProd,"RÉGUA 30 CM")
aAdd(aProd,"SABÃO PASTOSO 500 G")
aAdd(aProd,"SABONETE LÍQUIDO REFIL 5 X 950 ML")
aAdd(aProd,"SACO DE LIXO 60L C/100")
aAdd(aProd,"SACO LIXO 100 L C/100")
aAdd(aProd,"TESOURA COSTURA")
aAdd(aProd,"TOALHA DE PAPEL PCT C/2.400 FLS")
aAdd(aProd,"TOALHA DE PAPEL ROLO  8 X 200 M")
aAdd(aProd,"TONER 12 A")
aAdd(aProd,"TONER 15 X")
aAdd(aProd,"TONER 35 A")
aAdd(aProd,"TONER 5949A/7553A (CONJUGADO)")
aAdd(aProd,"TONER HP 05A")
aAdd(aProd,"TONER HP CC530A (BLACK) ORIG")
aAdd(aProd,"TONER HP CC531A /532 /533")
aAdd(aProd,"TONER HP CE255X ORIG")
aAdd(aProd,"TONER HP CF210 (BLACK)")
aAdd(aProd,"TONER HP CF211 / 212 / 213")
aAdd(aProd,"VASELINA")
aAdd(aProd,"VASSOURA PIAÇAVA Nº3")
aAdd(aProd,"VEJA MULTIUSO 500 ML")
cCod := "9000"

For i := 1 to len(aProd)
	
	aProduto := {}
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+cCod,.F.)
	aAdd(aProduto, {"B1_COD", cCod									, Nil})
	aAdd(aProduto, {"B1_DESC", aProd[i]								, Nil})
	aAdd(aProduto, {"B1_TIPO", "MC"									, Nil})
	aAdd(aProduto, {"B1_UM", "UN"									, Nil})
	aAdd(aProduto, {"B1_LOCPAD", "01"								, Nil})
	aAdd(aProduto, {"B1_GRUPO", "9999"								, Nil})
	aAdd(aProduto, {"B1_ORIGEM", "0"								, Nil})
	//aAdd(aProduto, {"B1_TNATREC", alltrim((cAlias)->B1_TNATREC)	, Nil})
	aAdd(aProduto, {"B1_MSBLQL", "2"							   	, Nil})
	//aAdd(aProduto, {"B1_CODBAR", alltrim((cAlias)->B1_CODBAR)		, Nil})
	//aAdd(aProduto, {"B1_ISBN", alltrim((cAlias)->B1_ISBN)			, Nil})
	aAdd(aProduto, {"B1_POSIPI", "99999999"							, Nil})
	//aAdd(aProduto, {"B1_XSITOBR", alltrim((cAlias)->B1_XSITOBR)	, Nil})
	//aAdd(aProduto, {"B1_XEMPRES", alltrim((cAlias)->B1_XEMPRES)	, Nil})
	//aAdd(aProduto, {"B1_XIDMAE", alltrim((cAlias)->B1_XIDMAE)		, Nil})
	//aAdd(aProduto, {"B1_XIDTPPU", alltrim((cAlias)->B1_XIDTPPU)	, Nil})
	//aAdd(aProduto, {"B1_XPERCRM", alltrim((cAlias)->B1_XPERCRM)	, Nil})
	//aAdd(aProduto, {"B1_XSITOBR", alltrim((cAlias)->B1_XSITOBR)	, Nil})
	//aAdd(aProduto, {"B1_XPSITEG", alltrim((cAlias)->B1_XPSITEG)	, Nil})
	//aAdd(aProduto, {"B1_PESO", (cAlias)->B1_PESO					, Nil})
	//aAdd(aProduto, {"B1_PROC", cFab, Nil}) //FORNECEDOR PADRAO
	//aAdd(aProduto, {"B1_LOJPROC", "01", Nil}) //LOJA FORNECEDOR PADRAO

	MSExecAuto({|x,y| Mata010(x,y)},aProduto,3)
	
	If lMSErroAuto
		lErro := .T.
		cFile := Dtos(dDataBase) + " - Produto "+Alltrim(cCod)+".log"
		MostraErro(cpath,cfile)
		lMsErroAuto := .F.
		lMSHelpAuto	:= .F.
	Endif
	
	cCod := soma1(cCod)
	
Next i


Return()
