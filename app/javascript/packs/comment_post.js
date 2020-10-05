$(document).on("turbolinks:load", function() {
  $("#add-comment-0").css("display", "flex");

  $(document).on("click", ".reply", function() {
    var comment_id = this.id.split("-");
    comment_id = comment_id[comment_id.length - 1];
    comment = $("#add-comment-" + comment_id);
    if(comment.css("display") == "flex") {
      comment.css("display", "none");
    }
    else {
      comment.css("display", "flex");
    }
  });
});
