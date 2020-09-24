$(document).on('turbolinks:load', function(){
  $('#event_topic_id').select2();

  let post_topic_ids = $('#post_post_topic_ids').val();

  $('#event_topic_id').val(post_topic_ids);
  $('#event_topic_id').trigger('change');
});
