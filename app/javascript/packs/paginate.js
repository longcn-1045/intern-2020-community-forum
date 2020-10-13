$(document).on('turbolinks:load', function () {
  var CONFIG = require('./config.json');

  if ($('.pagination').length && $('.post-list').length) {
    $(window).on('scroll', function(){
      more_posts_url = $('.pagination .next_page a').attr('href');
      if(more_posts_url) {
        more_posts_url = more_posts_url;
      } else {
        more_posts_url= $('.pagination .next a').attr('href');
      }
      if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
        $('.pagination').html('<img src=' + CONFIG.paginate_gif + ' />');
        $.getScript(more_posts_url);
      }
    });
  }
});
