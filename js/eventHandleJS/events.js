var element = document.getElementById('myElement');
var div = document.getElementById('myDiv');
//element.onclick = function(e){
//    alert("Hello world!");
//    console.log(e);
//    this.style.backgroundColor = "red";
//}
function myFunc(){
    alert("Coming from addEventListener");
}

//element.addEventListener('click', myFunc, false);
//element.removeEventListener('click', myFunc, false);
element.addEventListener('click', function(e){
    
    e.stopPropagation();
    console.log("Coming from addEventListener");
    console.log(e);
    console.dir(e);
    target = e.target || e.srcElement;
    //window.event.cancelBubble = true;
    //currentTarget

}, false);
div.addEventListener('click', function(){console.log("div");}, false);
/*attachEvent is for old IE version 5-8*/
//element.attachEvent('click', myFunc);
//element.attachEvent('click', myFunc2);
//element.detachEvent('click', myFunc);

//delegation

function delegate(e){
    var target = e.target || e.srcElement;

    switch(target.id){
        case 'home':
            alert('home');
            break;
        case 'portfolio':
            alert('portfolio');
            break;
        case 'contact':
            alert('contact');
            break;
        case 'about':
            alert('about');
            break;
        default:
            alert('default');
    }
}

var myNav = document.getElementById('nav');
//myNav.addEventListener('click', delegate, false);

// 

var arr = ['click', 'dbclick', 'mousedown', 'mouseup', 'mouseover', 'mouseout'];

for (var i=0; i<arr.length; i++){
    // self invoking anonymous function
    // use the closure, can think of it as a retained scope, to retain the outer execution context of the function
    Element.prototype[arr[i]] = (function(i){
        return function(fn){
            this.addEventListener(i, fn);
        }
    })(arr[i]);
    //Element.prototype[arr[i]] = function(fn){
    //        this.addEventListener(arr[i], fn);
    //}
}
myNav.mouseover(function(){
    alert('mouseover');
});
