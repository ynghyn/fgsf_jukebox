$(document).ready(
  function() {
    $('.btn_add_song').click(function() {
      var url = this.name;
      var $this = $(this);
      $.getJSON(url, function(data) {
        $('#notice-flash').text(data.msg);
        $('#notice-flash').fadeIn(500);
        $('#notice-flash').fadeOut(1000);
        $this.addClass('btn-primary');
        $this.fadeOut(200).fadeIn(200).fadeOut(200).fadeIn(200);
        $this.removeClass('btn-primary');
      }).error(function(data, textStatus, error) {
        $('#alert-flash').text(error);
        $('#alert-flash').fadeIn(500);
        $('#alert-flash').fadeOut(1000);
      });
    });

    $('#juke_control').delegate('span', 'click', function() {
      var url = $(this).attr('data_url');
      $.getJSON(url, function() {
        $('li#play_button_container').load('/juke/play_button');
        $('#playing_now').load('/juke/playing_now');
      });
    });
  }
);


