$(document).on('turbolinks:load', function(){
  $(document).on("click", ".form-check-label", function() {
    let data = this.id.split("-");
    report_data_id = data[data.length - 1];
    post_id = data[data.length - 2];

    textarea = $("#form-check-textarea-" + post_id + " textarea");
    if(report_data_id == 6) {
      textarea.css("display", "block");
    }
    else {
      textarea.css("display", "none");
      textarea.val("");
    }
  });
});
