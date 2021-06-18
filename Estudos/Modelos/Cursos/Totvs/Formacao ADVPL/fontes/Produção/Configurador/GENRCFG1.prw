#include "PROTHEUS.CH"
#include "REPORT.CH"
#include "TOPCONN.CH"

#define DMPAPER_A4 9

//RELATORIO DE IMPRESSAO DO PERFIL DE ACESSO DOS GRUPOS DE USUARIOS
User Function GENRCFG1

local oReport

oReport := reportDef()
oReport:printDialog()

Return

static function reportDef

local oReport
local cTitulo := "Grupos de Usuário"
local cPerg := ""

oReport := TReport():New('GENRCFG1', cTitulo, cPerg , {|oReport| PrintReport(oReport)})

oReport:SetLandScape()

oReport:SetTotalInLine(.F.)

oReport:ShowHeader()

oSection0 := TRSection():New(oReport,"Grupode de Usuário",{""})
oSection1 := TRSection():New(oSection0,"Dados do Grupo",{""})
oSection2 := TRSection():New(oSection0,"Empresas do Grupo",{""})
oSection3 := TRSection():New(oSection0,"Módulos do Grupo",{""})

oSection1:SetTotalInLine(.F.)

TRCell():New(oSection0,"CODIGO"		,,"Grupo",,6)
TRCell():New(oSection0,"NOME"		,,"Nome",,20)
TRCell():New(oSection0,"BLOQUEADO"	,,"Bloqueado",,30)

TRCell():New(oSection1,"DESCRICAO"	,,"Descrição",,30)

TRCell():New(oSection2,"EMPCODIGO"	,,"Empresa",,2)
TRCell():New(oSection2,"EMPNOME"	,,"Nome da empresa",,30)
TRCell():New(oSection2,"FILCODIGO"	,,"Filial",,2)
TRCell():New(oSection2,"FILNOME"	,,"Nome da Filial",,30)

TRCell():New(oSection3,"CODIGO"		,,"Módulo",,2)
TRCell():New(oSection3,"NIVEL"		,,"Nível de acesso",,2)
TRCell():New(oSection3,"NOME"		,,"Nome",,20)
TRCell():New(oSection3,"DESCRICAO"	,,"Descrição",,30)
TRCell():New(oSection3,"MENU"		,,"Menu",,20)

return (oReport)

Static Function PrintReport(oReport)

Local oSection0 := oReport:Section(1)
Local oSection1 := oSection0:Section(1)
Local oSection2 := oSection0:Section(2)
Local oSection3 := oSection0:Section(3)
Local _aGrpRel  := AllGroups()
Local _aEmpRel	:= {}
Local _aXNURel	:= {}

Local _aMenuRel := {{"01","SIGAATF ","Ativo Fixo "},;
{"02","SIGACOM ","Compras "},;
{"03","SIGACON ","Contabilidade "},;
{"04","SIGAEST ","Estoque/Custos "},;
{"05","SIGAFAT ","Faturamento "},;
{"06","SIGAFIN ","Financeiro "},;
{"07","SIGAGPE ","Gestao de Pessoal "},;
{"08","SIGAFAS ","Faturamento Servico "},;
{"09","SIGAFIS ","Livros Fiscais "},;
{"10","SIGAPCP ","Planej.Contr.Producao "},;
{"11","SIGAVEI ","Veiculos "},;
{"12","SIGALOJA","Controle de Lojas "},;
{"13","SIGATMK ","Call Center "},;
{"14","SIGAOFI ","Oficina "},;
{"15","SIGARPM ","Gerador de Relatorios Beta1 "},;
{"16","SIGAPON ","Ponto Eletronico "},;
{"17","SIGAEIC ","Easy Import Control "},;
{"18","SIGAGRH ","Gestao de R.Humanos "},;
{"19","SIGAMNT ","Manutencao de Ativos "},;
{"20","SIGARSP ","Recrutamento e Selecao Pessoal "},;
{"21","SIGAQIE ","Inspecao de Entrada "},;
{"22","SIGAQMT ","Metrologia "},;
{"23","SIGAFRT ","Front Loja "},;
{"24","SIGAQDO ","Controle de Documentos "},;
{"25","SIGAQIP ","Inspecao de Projetos "},;
{"26","SIGATRM ","Treinamento "},;
{"27","SIGAEIF ","Importacao - Financeiro "},;
{"28","SIGATEC ","Field Service "},;
{"29","SIGAEEC ","Easy Export Control "},;
{"30","SIGAEFF ","Easy Financing "},;
{"31","SIGAECO ","Easy Accounting "},;
{"32","SIGAAFV ","Administracao de Forca de Vendas "},;
{"33","SIGAPLS ","Plano de Saude "},;
{"34","SIGACTB ","Contabilidade Gerencial "},;
{"35","SIGAMDT ","Medicina e Seguranca no Trabalho "},;
{"36","SIGAQNC ","Controle de Nao-Conformidades "},;
{"37","SIGAQAD ","Controle de Auditoria "},;
{"38","SIGAQCP ","Controle Estatistico de Processos "},;
{"39","SIGAOMS ","Gestao de Distribuicao "},;
{"40","SIGACSA ","Cargos e Salarios "},;
{"41","SIGAPEC ","Auto Pecas "},;
{"42","SIGAWMS ","Gestao de Armazenagem "},;
{"43","SIGATMS ","Gestao de Transporte "},;
{"44","SIGAPMS ","Gestao de Projetos "},;
{"45","SIGACDA ","Controle de Direitos Autorais "},;
{"46","SIGAACD ","Automacao Coleta de Dados "},;
{"47","SIGAPPAP","PPAP "},;
{"48","SIGAREP ","Replica "},;
{"49","SIGAGAC ","Gerenciamento Academico "},;
{"50","SIGAEDC ","Easy DrawBack Control "},;
{"97","SIGAESP ","Especificos "},;
{"98","SIGAESP1","Especificos I "}}

For nx:=1 To Len(_aGrpRel)

	oReport:IncMeter()
	
	_cBloqueado := FWGrpParam(_aGrpRel[nx][1][1])[1][3]
	
	If _cBloqueado == "1" 
		_cBloqueado := "Sim" 
	Elseif _cBloqueado == "2" 
		_cBloqueado :=  "Não"
	Endif
	
	oSection0:Init()
	
	oSection0:Cell("CODIGO"):SetValue(_aGrpRel[nx][1][1])
	oSection0:Cell("NOME"):SetValue(_aGrpRel[nx][1][2])
	oSection0:Cell("BLOQUEADO"):SetValue(_cBloqueado)
			
	oSection0:PrintLine()
		
	oSection1:Init()
	
	oSection1:Cell("DESCRICAO"):SetValue(_aGrpRel[nx][1][3])

	oSection1:PrintLine()
	oSection1:Finish()
	
	_aEmpRel := FWGrpEmp(_aGrpRel[nx][1][1])
	
	For ny:=1 To Len(_aEmpRel)
				
		SM0->(DbSetOrder(1))
		If SM0->(DbSeek(_aEmpRel[ny]))
			
			oSection2:Init()
			
			oSection2:Cell("EMPCODIGO"):SetValue(SM0->M0_CODIGO)
			oSection2:Cell("EMPNOME"):SetValue(SM0->M0_NOME)
			oSection2:Cell("FILCODIGO"):SetValue(SM0->M0_CODFIL)
			oSection2:Cell("FILNOME"):SetValue(SM0->M0_FILIAL)
			
			oSection2:PrintLine()
		Endif
		
	Next ny
	
	oSection2:Finish()
	
	_aXNURel := FWGrpMenu(_aGrpRel[nx][1][1])
	
	For ny:=1 To Len(_aXNURel)
		
		_nPos1 := aScan(_aMenuRel,{|x| x[1] == Left(_aXNURel[ny],2)})
		
		If Substr(_aXNURel[ny],3,1) <> "X"
			If _nPos1 > 0
				
				oSection3:Init()
				
				oSection3:Cell("CODIGO"):SetValue(_aMenuRel[_nPos1][1])
				oSection3:Cell("NIVEL"):SetValue(Substr(_aXNURel[ny],3,1))
				oSection3:Cell("NOME"):SetValue(_aMenuRel[_nPos1][2])
				oSection3:Cell("DESCRICAO"):SetValue(_aMenuRel[_nPos1][3])
				oSection3:Cell("MENU"):SetValue(Substr(_aXNURel[ny],12,50))
				
				oSection3:PrintLine()
			Endif
		Endif
				
	Next ny
	
	oSection3:Finish()
	oSection0:Finish()
	
Next nx

Return
