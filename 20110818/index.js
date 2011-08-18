// まずはページ幅取得
var width = document.documentElement.clientWidth;
document.body.className = 'slidemode';
// フォントサイズ調整
document.body.style.fontSize = width / 5 + '%';

var slides = [];
var SV = 'slide view';
var SR = 'slide right';
var SL = 'slide left';
// スライドの各ページを取得
// divタグのクラス名で判定
var divs = document.body.getElementsByTagName('div');
for (var i = 0,l = divs.length;i<l;i++){
  if(/^slide/i.test(divs[i].className)){
    divs[i].className = SR;
    slides.push(divs[i]);
  }
}
//現在のページ
var current = 0;
var count = slides.length;

document.body.onclick = function(e){
  var ev = e||window.event;
  var x = ev.clientX;
  if (width*0.95 < x && slides[current+1]){
    //右余白がクリックされたとき
    next();
  } else if (width*0.05 > x && slides[current-1]) {
    //左余白がクリックされたとき
    prev();
  }
};
var Down = -1, Up = 1;
if (document.body.onmousewheel !== void 0 || window.opera){
  // onmousewheelが使えるか判定(Firefox以外はこちら)
  document.body.onmousewheel = mousewheel;
} else {
  // 実質Firefox用の処理。onmousewheelをサポートしたら上の処理だけで済むようになるはず
  document.body.addEventListener('DOMMouseScroll',mousewheel,false);
}
function mousewheel(e){
  var ev = e||window.event;
  var dir = ev.wheelDelta || -ev.detail;
  dir = dir < 0 ? Down : Up;
  if (dir === Down && slides[current+1]){
    next();
  } else if (dir === Up && slides[current-1]) {
    prev();
  }
};
document.onkeydown = key_slide;
var J = 74, K = 75, Left = 37, Right = 39;
function key_slide(evt){
  if (!evt) {
    evt = window.event;
  }
  if ((evt.keyCode === K || evt.keyCode === Left) && slides[current-1]){// k
    prev();
    return false;
  } else if ((evt.keyCode === J || evt.keyCode === Right) && slides[current+1]) {// j
    next();
    return false;
  }
}
function next(){
  slides[current++].className = SL;
  slides[current].className = SV;
  location.hash = 'Page'+current;
}
function prev(){
  slides[current--].className = SR;
  slides[current].className = SV;
  location.hash = 'Page'+current;
}

setTimeout(function(){
  var m;
  if (m=location.hash.match(/^#Page(\d+)$/)){
    current = +m[1];
    for (var i = 0;i < current && slides[i];i++){
      slides[i].className = SL;
    }
    slides[current].className = SV;
  } else {
    slides[0].className = SV;
  }
}, 500);
if(top == self){
  document.body.className += ' top';
}
