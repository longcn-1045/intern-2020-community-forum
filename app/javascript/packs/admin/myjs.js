$(document).on('turbolinks:load', function(){
  $('.selectall-checkbox').click(function() {
     if (this.checked) {
       $(':checkbox').each(function() {
         this.checked = true;
       });
     }
     else {
      $(':checkbox').each(function() {
        this.checked = false;
       });
     }
  });
  $('.post_select').select2({
    placeholder: "--All--",
    allowClear: true
  });
});
