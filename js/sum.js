#!/usr/bin/env node

function sum(){
    var result = 0;
    for(var i=0; i<arguments.length; i++){
        result += arguments[i];
    }
    return result;
}
var data = [1,2,3];
console.log(sum.apply(null,data));
