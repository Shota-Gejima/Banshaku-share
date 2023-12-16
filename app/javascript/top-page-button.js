$(document).ready(function() {
  // スクロールトップボタンをクリックしたときの処理
  $('.scroll-top-btn').on('click', function(e) {
  	e.preventDefault(); 
    $('html, body').animate({ scrollTop: 0 }, 'slow');
    // ページトップへスクロール
  });
  // ページが100ピクセルまでスクロールされたらボタンを表示
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.scroll-top-btn').fadeIn();
    } else {
      $('.scroll-top-btn').fadeOut();
    }
  });
});