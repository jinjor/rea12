(function(){
	'ahoge1'(3)(4);
	a=function(a){
		return 234;
	};
	b=function(b){
		return a(1);
	}(function(a){
		return 345;
	});
});