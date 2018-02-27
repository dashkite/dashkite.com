(function() {
  $.ready.then(function() {
    var nouns, rotate;
    nouns = $(".tagline span");
    rotate = (function(index) {
      var next;
      next = function(n) {};
      return function() {
        $(nouns.get(index++)).toggleClass("selected");
        index %= nouns.length;
        $(nouns.get(index)).toggleClass("selected");
        return setTimeout(rotate, 2000);
      };
    })(0);
    return setTimeout(rotate, 2000);
  });

}).call(this);
