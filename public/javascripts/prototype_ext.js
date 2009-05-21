Array.prototype.has = function(value) {
  var i;
  for (var i = 0, loopCnt = this.length; i < loopCnt; i++) {
    if (this[i] == value) {
      return true;
    }
  }
  return false;
};