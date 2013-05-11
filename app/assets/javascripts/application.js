// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function getElement(id) {
	var element = null; 
	if (document.getElementById)
		element = document.getElementById(id);
	else if (document.layers) 
		element = document.layers[id];
	else if (document.all)
		element = document.all[id];
	return element; 
}

// $('input').keyup(function(){
//     $this = $(this);
//     if($this.val().length == 1)
//     {
//         var x =  new RegExp("[\x00-\x80]+"); // is ascii
        
//         //alert(x.test($this.val()));
        
//         var isAscii = x.test($this.val());
        
//         if(isAscii)
//         {
//             $this.css("direction", "ltr");
//         }
//         else
//         {
//             $this.css("direction", "rtl");
//         }
//     }
        
// });

function keyPress(event,element) {        
	var el = getElement(element);
	var value = el.value;
	value = value.replace(/ /g,'');
	var err = 0;
	if (value.length == 3) {
		var letters = new Array();
		var reg = new RegExp("[\u0600-\u06FF]");       //"[\x00-\x80]+");
		for (var i=0; i<3; i++){
			letters[i] = value.charAt(i);
			if( reg.test(letters[i]) ) { // 
				err = err +1;
			} else {
				err = err -1;
			}
		}
	}

	if ( err>=3 ) {
		el.style.direction = "rtl";
	}
	if ( err<=-3 ) {
		el.style.direction = "ltr";
	}

}
	