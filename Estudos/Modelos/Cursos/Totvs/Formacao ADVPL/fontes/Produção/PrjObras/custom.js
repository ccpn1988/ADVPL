jQuery(document).ready(function() {
   
});


function TesteCod(){
	
	//alert(ckeditor.getData());
	 alert(jQuery('#ckeditor').getData);
	
};

 function GetContents(cField) {
      // Get the editor instance that you want to interact with.
      var editor = CKEDITOR.instances.ckeditor;
      var text = CKEDITOR.instances.ckeditor.document.getBody().getText();
      
      // Get editor content.
      // https://ckeditor.com/docs/ckeditor4/latest/api/CKEDITOR_editor.html#method-getData
      dialog.jsToAdvpl(cField, editor.getData());
      //dialog.jsToAdvpl("B1_XTEXTO", editor.getData());
      //dialog.jsToAdvpl("B1_XTEXTO", text);
    }

 function SetInofTextArea(cTexto){
	
 	var editor = CKEDITOR.instances.ckeditor;
 	var cNoCod = window.atob(cTexto);
 	
 	//alert(cTexto);
 	editor.setData(cNoCod);
 	document.getElementById("ckeditor").value = cNoCod;
 
 }; 