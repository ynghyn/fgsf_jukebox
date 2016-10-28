"use strict";

$(document).ready(
  function() {
    var setInterval = null;
    var noticeFlash = $('#notice-flash');
    var warningFlash = $('#warning-flash');
    var alertFlash = $('#alert-flash');

    function clearIntervalAndHide() {
      clearInterval(setInterval);
      noticeFlash.hide();
      warningFlash.hide();
      alertFlash.hide();
    }

    $('.btn_add_song').click(function() {
      var url = this.name;
      $.getJSON(url, function(data) {
        clearIntervalAndHide();
        if (data.status == 200) {
          noticeFlash.text(data.msg);
          noticeFlash.show();
          setInterval = setTimeout(function() { noticeFlash.fadeOut(1000) }, 2000);
        } else {
          warningFlash.text(data.msg);
          warningFlash.show();
          setInterval = setTimeout(function()  { warningFlash.fadeOut(1000) }, 2000);
        }
      }).error(function(data) {
        clearIntervalAndHide();
        alertFlash.text(data.responseJSON.msg);
        alertFlash.show();
        setInterval = setTimeout(function() { alertFlash.fadeOut(1000) }, 2000);
      });
    });

    $('#juke_control').delegate('span', 'click', function() {
      var url = $(this).attr('data_url');
      $.getJSON(url, function() {
        $('#title').load('/juke/title');
        $('#playing_now').load('/juke/playing_now');
        $('li#play_button_container').load('/juke/play_button');
      });
    });
  }
);


