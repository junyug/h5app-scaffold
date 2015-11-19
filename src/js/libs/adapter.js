(function() {
  var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  (function(doc, win) {
    var docEl, recalc, resizeEvt;
    docEl = doc.documentElement;
    resizeEvt = indexOf.call(win, 'orientationchange') >= 0 ? 'orientationchange' : 'resize';
    recalc = function() {
      var clientWidth;
      clientWidth = docEl.clientWidth;
      if (!clientWidth) {
        return;
      }
      return docEl.style.fontSize = 10 * (clientWidth / 750) + 'px';
    };
    if (!doc.addEventListener) {
      return;
    }
    win.addEventListener(resizeEvt, recalc, false);
    return doc.addEventListener('DOMContentLoaded', recalc, false);
  })(document, window);

}).call(this);
