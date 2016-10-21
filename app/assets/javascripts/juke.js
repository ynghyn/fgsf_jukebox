$(document).ready(
  function() {
    $('.btn_add_song').click(function() {
      var url = this.name;
      var $this = $(this);
      $.getJSON(url, function(data) {
        if (data.status == 200) {
          $('#notice-flash').text(data.msg);
          $('#notice-flash').fadeIn(500);
          $('#notice-flash').fadeOut(4000);
          $this.fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
        } else {
          $('#warning-flash').text(data.msg);
          $('#warning-flash').fadeIn(500);
          $('#warning-flash').fadeOut(4000);
          $this.fadeOut(100).fadeIn(100).fadeOut(100).fadeIn(100);
        }
      }).error(function() {
        $('#alert-flash').text('Reached limit! 10분후에 또 예약 해주세요~');
        $('#alert-flash').fadeIn(500);
        $('#alert-flash').fadeOut(4000);
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


