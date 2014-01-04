function print(p){
    p = 20;
    console.log(p); //print 20
}

var a = 10;
console.log(a); // 10

print(a);
console.log(a); // 10
function print(p){
p = 20;
console.log(p); //print 20
}

var a = 10;
console.log(a); // 10

print(a);
console.log(a); // 10


function print(p){
p.prop1 = 20;
console.log(p.prop1); //print 20
}

var a = {};
a.prop1 = 10;f
console.log(a.prop1); // 10

print(a);
console.log(a.prop1); // 10

----------------------------

Write a class in javascript with a private member and a public member

function Class1(param1){
	this.member1 =  param1; //private
}
Class1.prototype.member2 = param2;

c = new Class1();
c.member1 // throw error because it is private ?
c.member2 // fine ?

-----------------------------










.green{
 color: green;
}

.red{
color: red
}

div{
color: black;
}

<div class=”red green”>color me</div>

-----------------------

1) Compress



Implement a Carousel plugin in JQuery
    
   ----------    ---------
< |	   |   |	       |  …..   >
   ----------    ---------

<p>---------- 


http://getbootstrap.com/javascript/#carousel

---------------------

Event delegation ??
ul
	li’ id = “li1”
	li id = “li2”
ul.addEventListener(.’click’, myfun, false)
myfun(e){
	var target = e.taget || e.scrElement;
	switch(taget.id){
		case “li1”:
			do something
			break;
		case 
}

HTML5 ? No

