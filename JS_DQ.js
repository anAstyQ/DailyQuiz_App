    jQuery( document ).ready( function() {
        initEventHandlers();
        
        jQuery('#mainTable td[data-label="Commerce"]').filter(function(index){
            return jQuery(this).find('img[alt="Not Checked"]').length > 0
        }).css('border','1px solid red');
    });

    function initEventHandlers(){ 
        jQuery('a.collapse').on('click', function (){
            var elemToShow = jQuery(this).closest('p').next('div');
    
            console.log(elemToShow);
            console.log(elemToShow.css('display'));
            if(elemToShow.css('display') == 'none') { 
                console.log('none');
                elemToShow.show();
            } else {
                console.log('block');
                elemToShow.hide();
            } 
        });
    }
