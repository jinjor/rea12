var End = Object.create(null);
var Nil = Object.create(null);

var log = function(e){
  console.log(e);
}
var id = function(e){
  return e;
}
var compose = function(f, g){
  return function(a){
    return g(f(a));
  };
}
var Async = {
  unit: function(e) { return function(next){ next(e);next(End);} },
  bind: function(a, f){
    return function(next){
      var aEnd = false;
      var count = 0;
      a(function(e){
        if(e === End){
          aEnd = true;
          if(count === 0){
            next(End)
          }
        } else {
          count++;
          f(e)(function(e){
            if(e === End){
              count--;
              if(aEnd && count === 0){
                next(End);
              }
            }else{
              next(e);
            }
          });
        }
      });
    };
  },
  reduce: function(async, f, memo){
    return function(next){
      async(function(_){
        if(_ === End){
          next(memo);
          next(End);
        }else{
          memo = f(memo, _);
        }
      });
    };
  }
}
var join = function(list1, list2){
  if(list1 === Nil){
    return list2;
  }
  return [list1[0], join(list1[1], list2)];
}
var concat= function(list){
  if(list === Nil){
    return Nil;
  }
  head = list[0];
  tail = list[1];
  return join(head, concat(tail));
}
var flatMap = function(list, f){
  return concat(map(list, f));
}
var map = function(list, f){
  if(list === Nil){
    return Nil;
  }
  head = list[0];
  tail = list[1];
  return [f(head), map(tail, f)];
};
var add = function(memo, e){ return memo + e; };
Async.bind(Async.unit(),function(){
  return Async.unit(Async.bind(Async.unit(),(function(){
      var a=1;
      return Async.bind(bs,function(b){
        var d=2;
        return Async.bind(cs,function(c){
          return Async.unit(a(b)(c));
        });
      });
    })()));
})(function(){});
