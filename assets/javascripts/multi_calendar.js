//alert('Trigger was!');

function validate_form_new_calendar() {
    
        if (jQuery("#id_new_calendar").val().length == 0){
            alert('Name field is required');
            return false;
        }
         return true;
}

function select_all() {
    if (jQuery("#all_select").is(':checked')){
        jQuery(".select_all").attr('checked', "checked"); //true
    }else{       
       jQuery(".select_all").removeAttr("checked");
    }
}