Async.bind(Async.unit(),function(){
    return Async.bind(Async.bind(Async.unit(),function(){
            return Async.bind(ajaxmock1(''),function(a){
                return Async.bind(ajaxmock2(a),function(b){
          return Async.unit(b);
        });
      });
    }),function(r){
    return Async.unit(r);
  });
})(function(e){console.log(e);});
