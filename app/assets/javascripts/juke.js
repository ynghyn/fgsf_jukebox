$(document).ready(
  function() {
    $('.btn_add_song').click(function() {
      var url = this.name;
      var $this = $(this);
      $.getJSON(url, function(data) {
        $('#notice-flash').text(data.msg);
        $('#notice-flash').fadeIn(200);
        $('#notice-flash').fadeOut(3000);
        $this.fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
      }).error(function() {
        $('#alert-flash').text('Reached limit! 10분후에 또 예약 해주세요~');
        $('#alert-flash').fadeIn(200);
        $('#alert-flash').fadeOut(3000);
      });
    });

    $('#juke_control').delegate('span', 'click', function() {
      var url = $(this).attr('data_url');
      $.getJSON(url, function() {
        $('li#play_button_container').load('/juke/play_button');
        $('#playing_now').load('/juke/playing_now');
      });
    });

    function api_and(url) {
      $.getJSON(url, function() {
        $('li#play_button_container').load('/juke/play_button');
        $('#playing_now').load('/juke/playing_now');
      });
    }
  }
);


