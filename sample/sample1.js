Async.bind(Async.unit(), function(){
  return Async.unit((function(){
    var a=1;
    return Async.bind(bs,function(b){
      var d=2;
      return Async.bind(cs,function(c){
        return Async.unit(a(b)(c));

      });

    });

  }));
})(function(){});
