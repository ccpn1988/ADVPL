#ifdef SPANISH
	#define STR0001 "Este programa emitira el informe de movimientos"
	#define STR0002 "bancarios en orden de fecha. Podra usarse para "
	#define STR0003 "verific. del extracto."
	#define STR0004 "Extracto Banc."
	#define STR0005 "A Rayas"
	#define STR0006 "Administrac."
	#define STR0007 "EXTRACTO BANCARIO ENTRE"
	#define STR0008 "BANCO "
	#define STR0009 "   AGENCIA "
	#define STR0010 "   CUENTA"
	#define STR0011 "FECHA       OPERACION                                                        DOCUMENTO         PREFIJO/TITULO                 ENTRADAS             SALIDAS      SALDO ACTUAL"
	#define STR0012 "Seleccionando registros.."
	#define STR0013 "Anulado por el operador"
	#define STR0014 "SALDO INICIAL...........: "
	#define STR0015 "NO  CONCILIADOS"
	#define STR0016 "CONCILIADOS"
	#define STR0017 "TOTAL"
	#define STR0018 "ENTRADAS EN EL PERIODO..: "
	#define STR0019 "SALIDAS EN EL PERIODO ..: "
	#define STR0020 "SALDO ACTUAL ...........: "
	#define STR0021 "LIMITE DE CREDITO.......: "
	#define STR0022 "SALDO DISPONIBLE........: "
	#define STR0023 "SALDO BLOQUEADO CIP (2).: "
	#define STR0024 "SALDO BLOQUEADO COMP (3):"
	#define STR0025 "FCH."
	#define STR0026 "OPERAC."
	#define STR0027 "DOCUMENTO"
	#define STR0028 "PREF. / TITULO"
	#define STR0029 "ENTRADAS"
	#define STR0030 "SDAS."
	#define STR0031 "SDO. ACTUAL"
	#define STR0032 "Tot."
	#define STR0033 "DESCRIPC."
	#define STR0034 "SALDO INICIAL"
	#define STR0035 "Datos Bancarios"
	#define STR0036 "Movim. Bancarios"
	#define STR0037 "Tasa Moneda"
	#define STR0038 "FECHA       OPERACION                                                        DOCUMENTO         PREFIJO/TITULO                 ENTRADAS             SALIDAS      SALDO ACTUAL"
	#define STR0039 "  EN "
	#define STR0040 " y "
#else
	#ifdef ENGLISH
		#define STR0001 "This program prints the report of Bank Transactions, "
		#define STR0002 "ordered by date. It can be used to check the "
		#define STR0003 "Bank statement.        "
		#define STR0004 "Bank Statement  "
		#define STR0005 "Z.Form "
		#define STR0006 "Management   "
		#define STR0007 "BANK STATEMENT BETWEEN "
		#define STR0008 "BANK  "
		#define STR0009 "   BRANCH  "
		#define STR0010 "  ACCOUNT"
		#define STR0011 "DATE        OPERATION                      DOCUMENT                                           PREFIX/TITLE            INFLOW            OUTFLOW        CURR.BALANCE"
		#define STR0012 "Selecting Records......"
		#define STR0013 "Cancelled by the operator"
		#define STR0014 "INITIAL BALANCE.........: "
		#define STR0015 "NOT RECONCILED "
		#define STR0016 "RECONCILED "
		#define STR0017 "TOTAL"
		#define STR0018 "INFLOWS DURING PERIOD...: "
		#define STR0019 "OUTFLOWS DURING PERIOD..: "
		#define STR0020 "CURRENT BALANCE.........: "
		#define STR0021 "CREDIT LIMIT ...........: "
		#define STR0022 "AVAILABLE BALANCE.......: "
		#define STR0023 "LOCKED BALANCE  CIP (2).: "
		#define STR0024 "LOCKED BALANCE  COMP (3):"
		#define STR0025 "DATE"
		#define STR0026 "OPERATION"
		#define STR0027 "DOCUMENT "
		#define STR0028 "PREFIX/BILL   "
		#define STR0029 "INFLOWS "
		#define STR0030 "OUTFL."
		#define STR0031 "CURRENT BLN"
		#define STR0032 "Totals"
		#define STR0033 "DESCRIPT."
		#define STR0034 "INITIAL BLNCE"
		#define STR0035 "Bank information"
		#define STR0036 "Bank movements      "
		#define STR0037 "Currency Tax"
		#define STR0038 "DATE        OPERATION                      DOCUMENT                                           PREFIX/TITLE            INFLOW            OUTFLOW        CURR.BALANCE"
		#define STR0039 "  IN  "
		#define STR0040 " and "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Este programa ir� emitir o relat�rio de movimenta��es", "Este programa ir� emitir o relat�rio de movimenta��es" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Banc�rias por ordem de data. poder� ser utilizado para", "banc�rias em ordem de data. Poder� ser utilizado para" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Acordo de extracto.", "conferencia de extrato." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Extracto Banc�rio", "Extrato Bancario" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0006 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administracao" )
		#define STR0007 If( cPaisLoc $ "ANG|PTG", "Extracto banc�rio entre ", "EXTRATO BANCARIO ENTRE " )
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "Banco ", "BANCO " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "   ag�ncia ", "   AGENCIA " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "   conta ", "   CONTA " )
		#define STR0011 If( cPaisLoc $ "ANG|PTG", "DATA        OPERA��O                                                        DOCUMENTO         PREFIXO/T�TULO                 ENTRADAS             SA�DAS      SALDO ACTUAL", "DATA        OPERACAO                                                        DOCUMENTO         PREFIXO/TITULO                 ENTRADAS             SAIDAS      SALDO ATUAL" )
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "A Seleccionar Registos...", "Selecionando Registros..." )
		#define STR0013 "Cancelado pelo operador"
		#define STR0014 If( cPaisLoc $ "ANG|PTG", "Saldo inicial...........: ", "SALDO INICIAL...........: " )
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "N�o Conciliados", "NAO CONCILIADOS" )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Conciliados", "CONCILIADOS" )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Total", "TOTAL" )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Entradas no per�odo.....: ", "ENTRADAS NO PERIODO.....: " )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Sa�das no per�odo ......: ", "SAIDAS NO PERIODO ......: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Saldo actual ............: ", "SALDO ATUAL ............: " )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "Limite de cr�dito.......: ", "LIMITE DE CREDITO.......: " )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "Saldo dispon�vel........: ", "SALDO DISPONIVEL........: " )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "Saldo bloqueado cip (2).: ", "SALDO BLOQUEADO CIP (2).: " )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Saldo bloqueado comp (3):", "SALDO BLOQUEADO COMP (3):" )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Data", "DATA" )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "Opera��o", "OPERACAO" )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "Documento", "DOCUMENTO" )
		#define STR0028 If( cPaisLoc $ "ANG|PTG", "Prefixo/t�tulo", "PREFIXO/TITULO" )
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "Entradas", "ENTRADAS" )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", "Sa�das", "SAIDAS" )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Saldo Actual", "SALDO ATUAL" )
		#define STR0032 "Totais"
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Descri��o", "DESCRICAO" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Saldo Inicial", "SALDO INICIAL" )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "Dados Banc�rios", "Dados Bancarios" )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "Movimentos Banc�rios", "Movimentos Bancarios" )
		#define STR0037 "Taxa Moeda"
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "DATA        OPERA��O                                                        DOCUMENTO         PREFIXO/T�TULO                              ENTRADAS              SA�DAS       SALDO ACTUAL", "DATA        OPERACAO                                                        DOCUMENTO         PREFIXO/TITULO                              ENTRADAS              SAIDAS       SALDO ATUAL" )
		#define STR0039 "  EM  "
		#define STR0040 " e "
	#endif
#endif
