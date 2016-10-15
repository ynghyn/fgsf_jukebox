$(document).ready(
  function() {
    setInterval(function() {
      $('#playing_now').load('/juke/playing_now');
    }, 2000);

    setTimeout(function() { window.location=window.location;}, 60000);
  }
);
