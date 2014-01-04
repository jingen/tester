// Define class Foo
function Foo () {
        this.a = [];
}
 
// Define class Bar which inherits from Foo
function Bar () {}
Bar.prototype = new Foo();
Bar.prototype.constructor = Bar;
