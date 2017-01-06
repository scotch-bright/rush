var a = "this";
(function() {
  if (typeof elvis !== "undefined" && elvis !== null) {
    alert("I knew it!");
  }

}).call(this);

var this_is_c = 20;