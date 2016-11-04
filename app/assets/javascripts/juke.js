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

    $('.toggle-song').click(function() {
      var dataId = $(this).attr('dataId');
      var $jacket = $('#' + dataId + 'Jacket');
      var fileName = $jacket.attr('fileName');
      $jacket.html('<img src="/juke/mp3_image?file=' + fileName + '" width="100" height="100">');
    });

    $('.under-construction').click(function () {
      var href = $(this).attr('href');
      var $div = $('#' + href.substr(1));
      $div.html('<img src="/juke/construction" width="200" height="200">');
    });

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

    $('body').delegate('form', 'submit', function(e) {
      // and you'll need this to prevent
      // the form's 'default' action
      e.preventDefault();
      var url = "/comments";
      $.ajax({
        type: "POST",
        url: url,
        data: $("#new_comment").serialize(), // serializes the form's elements.
        success: function(data) {
          $('#pageFeed').html(data);
        }
      });
    });
    $('#pageSearchLocator').click(function() {
      $('#pageSearch').load('/juke/lib_search');
    });

    $('#pageFeedLocator').click(function() {
      $('#pageFeed').load('/juke/feed_comment');
    });

    $('#pageNowLocator').click(function() {
      $('#pageNow').load('/juke/music_now');
    });


  }
);
