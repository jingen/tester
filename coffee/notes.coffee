# syntax
+ is, isnt => === !==
+ not
+ name?
+ person?.name
+ name ?= "Joe"
+ if 0 <= x <= 10
+ if condition then statement
+ statement if condition
+ unless (if not)
+ switch person.job
    when "Programmer"
        statement
    when "Designer"
        statement
    else
        statement
+ msg = if ... / switch ..
+ obj =
    name: "openassembly"
    topic: "Web Developer"
    editor: "Jingen"
+ for item in myarray
+ for item, index in myarray
+ for item, i in arr when condition
+ for item in arr by 2
+ console.log item for item in arr
+ console.log (item for item in arr) # [1, 2, 3, 4, 5, 6]
+ for key, value of obj
+ for own key, value of obj # not include property in prototype
+ while i is arr.length
+ until i is arr.length
+ loop break
# javascript:
#    var counter = {
#        count: 0,
#        inc: function(){
#            return this.count++;
#        }
#    };
#    var inc = counter.inc;
#    console.log (inc.call({count:10}));

+ this.courseTopic = courseTopic
+ root = (exports ? window)
  root.courseTopic = courseTopic
+ # var self = this; we use "=>"
###
function Dog(name) {
    this.name = name
}
Dog.prototype.growl = function(){ statement; }
rusty = new Dog("Rusty")
###
Dog = (@name) ->
Dog::growl = ->
    statement
rusty = new Dog "Rusty"

SubDog = (@name, @tricks) ->
SubDog::perform = (trick) ->
    statement
# inheritance
SubDog extends Dog

# class
class Dog
    constructor: (@name) ->
    growl: -> console.log "Growl"

class SubDog extends Dog
    constructor: (@name, @tricks=[]) ->
    perform: (trick) -> console.log if statement
    #override
    growl: (person) ->
        if person is @master
            console.log '....'
        else
            super() #if only super, person will be passed

#regular expression
emailRegex = ///
    ([\W\.+-]+) #unique name
    @ #at-sign
    (\w+) #domain name
    (\.\w+[\w\.]*) #tid
///
for email in emails
    match = email.match emailRegex
    console.log match #if matched, match is any array, [0:match string, 1: group 1, 2.., index: 0, input: string]

# jQuery
###
<script src="jQuery.js"></script>
<script src="script.js"></script>
###
$ ->
    menu = $ '#menu'
    dropdown = $ '#dropdown'
    dropdown.hide()
    menu.on 'mouseover', (e) ->
        dropdown.stop().show 200
    menu.on 'mouseover', (e) ->
        dropdown.stop().show 200
        
