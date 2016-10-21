$(document).ready(
  function() {
    $('.btn_add_song').click(function() {
      var url = this.name;
      $.getJSON(url, function(data) {
        if (data.status == 200) {
          $('#notice-flash').text(data.msg);
          $('#notice-flash').show();
          setTimeout(function() {$('#notice-flash').fadeOut(1000)}, 2000);
        } else {
          $('#warning-flash').text(data.msg);
          $('#warning-flash').show();
          setTimeout(function() {$('#warning-flash').fadeOut(1000)}, 2000);
        }
      }).error(function() {
        $('#alert-flash').text('Reached limit! 10분후에 또 예약 해주세요~');
        $('#alert-flash').show();
        setTimeout(function() {$('#alert-flash').fadeOut(1000)}, 2000);
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


