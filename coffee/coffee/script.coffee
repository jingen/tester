#!/usr/bin/env coffee
class Dog
    constructor: (@name) ->
    growl: -> console.log "#{@name} is Growling"

dog = new Dog("Rusty")
dog.growl()

$ ->
    menu = $ '#menu'
    dropdown = $('#dropdown')
    dropdown.hide()
    menu.on 'mouseover', (e) ->
        dropdown.stop().show 200
    menu.on 'mouseover', (e) ->
        dropdown.stop().show 200
        

