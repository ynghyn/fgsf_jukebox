$(document).ready(
  function() {
    $('.btn_add_song').click(function(data) {
      var url = this.name;
      $.getJSON(url, function() {
        $(".notice" ).show();
        $(".notice" ).fadeOut(2000);
        $('div.notice').text('추가되었습니다');
      });
    });
  }
);


