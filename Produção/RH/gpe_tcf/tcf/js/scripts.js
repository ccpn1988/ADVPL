<!--
    function letternumber(e)
    {
        var key;
        var keychar;
    
        if (window.event)
            key = window.event.keyCode;
        else if (e)
            key = e.which;
        else
            return true;
    
        keychar = String.fromCharCode(key);
        keychar = keychar.toLowerCase();
    
        // control keys
        if ((key==null) || (key==0) || (key==8) || (key==9) || (key==13) || (key==27) )
            return true;
        // alphas and numbers
        else if ((("abcdefghijklmnopqrstuvwxyz0123456789").indexOf(keychar) > -1))
            return true;
        else
            return false;
    }
    
    var downStrokeField;
    function autojump(fieldName,nextFieldName,fakeMaxLength)
        {
            var myForm=document.forms[document.forms.length - 1];
            var myField=myForm.elements[fieldName];
            
            myField.nextField=myForm.elements[nextFieldName];
    
            if (myField.maxLength == null)
                myField.maxLength=fakeMaxLength;
                myField.onkeydown=autojump_keyDown;
                myField.onkeyup=autojump_keyUp;
        }
    
    function autojump_keyDown()
        {
            this.beforeLength=this.value.length;
            downStrokeField=this;
        }
    
        function autojump_keyUp()
        {
            if (
                (this == downStrokeField) && 
                (this.value.length > this.beforeLength) && 
                (this.value.length >= this.maxLength)
               )
            this.nextField.focus();
            downStrokeField=null;
        }

    function autotab(elemento)
    {
        if (elemento.value.length < elemento.getAttribute("maxlength")) return;
        var formulario = elemento.form;
        var els = formulario.elements;
        var x, autotab;
        for (var i = 0, len = els.length; i < len; i++)
        {
            x = els[i];
            if (elemento == x && (autotab = els[i+1]))
            {
                if (autotab.focus) autotab.focus();
            }
        }
    }

    function PrintDemonstrativo(cIdDemo,cIdPop_Span)
    {
        var StateDisplay = document.getElementById(cIdDemo).style.display;
        document.getElementById(cIdDemo).style.display="block";
        if ( StateDisplay != "block" )
        {
            document.getElementById(cIdPop_Span).innerHTML='[-] Ocultar';
        }   
        print();
    }

    function IsNumber()
    {   
        var Key = event.keyCode; 
        if ((Key > 47 && Key < 58)) // numeros de 0 a 9   
            return true;
        else
        {   
            if (Key != 8) // backspace   
                //event.keyCode = 0;   
                return false;   
            else   
                return true;   
        }
    }

    function MinMaxChar(valor, minimo, maximo,campo)
    {
        if ( valor.value.length < minimo || valor.value.length > maximo ) {
            window.alert("Atenção: " + campo + " deve conter " + minimo +" caracteres");
            //valor.focus();
        }
    }

    function ValidarCPF(Objcpf)
    {
        var cpf = Objcpf.value;
        exp = /\.|\-/g
        cpf = cpf.toString().replace( exp, "" );
        var digitoDigitado = eval(cpf.charAt(9)+cpf.charAt(10));
        var soma1=0, soma2=0;
        var vlr =11;
        
        for(i=0;i<9;i++){
            soma1+=eval(cpf.charAt(i)*(vlr-1));
            soma2+=eval(cpf.charAt(i)*vlr);
            vlr--;
        }    
        soma1 = (((soma1*10)%11)==10 ? 0:((soma1*10)%11));
        soma2=(((soma2+(2*soma1))*10)%11);
        
        var digitoGerado=(soma1*10)+soma2;
        if(digitoGerado!=digitoDigitado)    
            alert('CPF Invalido!');        
    }

    function MascaraCPF(cpf)
    {
        if(mascaraInteiro(cpf)==false){
            event.returnValue = false;
        }    
        return formataCampo(cpf, '000.000.000-00', event);
    }

    function mascaraInteiro(){
        if (event.keyCode < 48 || event.keyCode > 57){
            event.returnValue = false;
            return false;
        }
        return true;
    }

    function formataCampo(campo, Mascara, evento) {
        var boleanoMascara;
        
        var Digitato = evento.keyCode;
        exp = /\-|\.|\/|\(|\)| /g
        campoSoNumeros = campo.value.toString().replace( exp, "" );
      
        var posicaoCampo = 0;    
        var NovoValorCampo="";
        var TamanhoMascara = campoSoNumeros.length;;
        
        if (Digitato != 8) { // backspace
            for(i=0; i<= TamanhoMascara; i++) {
                boleanoMascara  = ((Mascara.charAt(i) == "-") || (Mascara.charAt(i) == ".")
                                    || (Mascara.charAt(i) == "/"))
                boleanoMascara  = boleanoMascara || ((Mascara.charAt(i) == "(")
                                    || (Mascara.charAt(i) == ")") || (Mascara.charAt(i) == " "))
                if (boleanoMascara) {
                    NovoValorCampo += Mascara.charAt(i);
                      TamanhoMascara++;
                }else {
                    NovoValorCampo += campoSoNumeros.charAt(posicaoCampo);
                    posicaoCampo++;
                  }           
              }    
            campo.value = NovoValorCampo;
              return true;
        }else {
            return true;
        }
    }   
    
    function verificaCampoVazio(formulario)
    {
    	if (formulario == "login") {
    		
    		cEmpFil     = document.forms[0].cEmpFil.value
            cMatricula  = document.forms[0].cMatricula.value;
    		cPassWord   = document.forms[0].cPassWord.value;

       		if (cEmpFil == "")
            {
    			window.alert("Por favor, Escolha a Empresa/Filial");
                //document.forms[0].cEmpFil.focus();
                return false;
    		}
    		
    		if (cMatricula == "")
            {
    			window.alert("Por favor, preencha sua Matrícula");
                document.forms[0].cMatricula.focus();
                return false;
    		}			

    		if (cPassWord == "")
            {
    			window.alert("Por favor, preencha sua Senha");
                //document.forms[0].cPassWord.focus();
                return false;
    		}

        }

    	if (formulario == "alterarsenha")
        {
    		
    		cMatricula      = document.forms[0].cMatricula.value;
    		cPassWord       = document.forms[0].cPassWord.value;
    		cCpf            = document.forms[0].cCPF.value;
    		cDiaAdmissao    = document.forms[0].cDiaAdmissao.value;
            cMesAdmissao    = document.forms[0].cMesAdmissao.value;
            cAnoAdmissao    = document.forms[0].cAnoAdmissao.value;
    		cDiaNascimento  = document.forms[0].cDiaNascimento.value;
            cMesNascimento  = document.forms[0].cMesNascimento.value;
            cAnoNascimento  = document.forms[0].cAnoNascimento.value;
    		cPassWord       = document.forms[0].cPassWord.value;
    		cNewPassWord    = document.forms[0].cNewPassWord.value;
    		cConNewPassWord = document.forms[0].cConNewPassWord.value;
                
    		if (cMatricula == "")
            {
    			window.alert("Por favor, preencha sua Matrícula");
                //document.forms[0].cMatricula.focus();
    			return false;
    		}	
    		
    		if (cCPF == "")
            {
    			window.alert("Por favor, preencha seu CPF");
                //document.forms[0].cCPF.focus();
    			return false;
    		}	
    		
    		if (cDiaAdmissao == "")
            {
    			window.alert("Por favor, preencha o dia de sua data de admissão");
                //document.forms[0].cPassWord.focus();
    			return false;
    		}
    		
            if (cMesAdmissao == "")
            {
    			window.alert("Por favor, preencha o mes de sua data de admissão");
                //document.forms[0].cMesAdmissao.focus();
    			return false;
    		}
            
            if (cAnoAdmissao == "")
            {
    			window.alert("Por favor, preencha o ano de sua data de admissão");
                //document.forms[0].cAnoAdmissao.focus();
    			return false;
    		}
    		
    		if (cDiaNascimento == "")
            {
    			window.alert("Por favor, preencha o dia de sua data de nascimento");
                //document.forms[0].cDiaNascimento.focus();
    			return false;
    		}	
    		
            if (cMesNascimento == "")
            {
    			window.alert("Por favor, preencha o mês de sua data de nascimento");
                //document.forms[0].cMesNascimento.focus();
    			return false;
    		}	
    		
            if (cAnoNascimento == "")
            {
    			window.alert("Por favor, preencha o ano de sua data de nascimento");
                //document.forms[0].cAnoNascimento.focus();
    			return false;
    		}	
    		
    		if (cPassWord == "")
            {
    			window.alert("Por favor, preencha sua senha anterior");
                //document.forms[0].cPassWord.focus();
    			return false;
    		}	
    		
    		if (cNewPassWord == "")
            {
    			window.alert("Por favor, preencha sua nova senha");
                //document.forms[0].cNewPassWord.focus();
    			return false;
    		}	
    		
    		if (cConNewPassWord == "")
            {
    			window.alert("Por favor, preencha a confirmação de sua nova Senha");
                //document.forms[0].cConNewPassWord.focus();
    			return false;
    		}			

    	}
    }

    function ChkNewPassWord()
    {
        if (document.forms[0].cNewPassWord.value != document.forms[0].cConNewPassWord.value)
        {
            window.alert("Desculpe, a Confirmação de senha não confere com a Nova Senha");
            document.forms[0].cNewPassWord.value="";
            document.forms[0].cConNewPassWord.value="";
            //document.forms[0].cNewPassWord.focus();
        }  
    }
   
   function ShowHideDemo(cIdDemo,cIdPop_Span)
   {
        if ( document.getElementById(cIdDemo).style.display != 'block' )
        {
            document.getElementById(cIdPop_Span).innerHTML='[-] Ocultar';
            document.getElementById(cIdDemo).style.display='block';
        }
        else
        {
            document.getElementById(cIdPop_Span).innerHTML='[+] Exibir';
            document.getElementById(cIdDemo).style.display='none';
        }
   }
   
//-->