$(document).ready(function() {
  // スクロールトップボタンをクリックしたときの処理
  $('#top a').click(function(e) {
    $('html, body').animate({ scrollTop: 0 }, 800);
    e.preventDefault();// ページトップへスクロール
  });

  // ページが100ピクセルまでスクロールされたらボタンを表示
  // $(window).scroll(function() {
    // if ($(this).scrollTop() > 100) {
      // $('.scroll-top-btn').fadeIn();
    // } else {
      // $('.scroll-top-btn').fadeOut();
    // }
  // });
});