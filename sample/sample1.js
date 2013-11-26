Async.bind(Async.unit(),function(){
    return Async.bind((function(){
            return Async.bind(as,function(a){
                return Async.bind(bs,function(b){
          var d=2;
          return Async.bind(cs(b),function(c){
            return Async.unit(eval('a+b+c+d'));
          });
        });
      });
    })(),function(r){
    return Async.unit(r);
  });
})(function(e){console.log(e);});
