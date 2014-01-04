#!/usr/bin/env ruby
=begin
ugPhD9AaOqVywCGi1R5YFblM
=end
require 'crocodoc'
Crocodoc.api_token = 'ugPhD9AaOqVywCGi1R5YFblM'

pdf = File.open('vitalsource.pdf', 'r')
#uuid = Crocodoc::Document.upload(pdf)
uuid = "b504bf86-5f4f-48e2-9371-1337199c0e1b"
puts uuid
session_key = Crocodoc::Session.create(uuid)
puts session_key
