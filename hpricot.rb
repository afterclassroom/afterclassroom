#!/usr/bin/env ruby
# myscript.rb

# If you are a Ruby Programmer, this script may be interesting to you.

# 1st, You may need to install Hpricot and rest-open-uri:
# gem install hpricot       --source http://gemcutter.org
# gem install rest-open-uri --source http://gemcutter.org

# Then you can try 1 of these command lines:
# ruby myscript.rb
# or
# irb -r myscript.rb
# or
# irb
# then 
# load 'myscript.rb'
#

require 'rubygems'
require 'hpricot'
require 'rest-open-uri'

# What does the Hpricot module look like?
@empty_doc= Hpricot
p "@empty_doc is this: "
p @empty_doc


p "@empty_doc.class is this: "
p @empty_doc.class

p("Here are some @empty_doc methods: ")
(@empty_doc.methods - 1.methods).each{ |m| p(m)}

# Older versions of Hpricot were helped by a larger buffer_size
Hpricot.buffer_size = 262144

# Here is a more interesting Hpricot object:
@small_doc= Hpricot("<div id='abc'>I am a small div-element.</div>")
p "@small_doc is this: "
p @small_doc

p "@small_doc.class is this: "
p @small_doc.class

p("Here are some @small_doc methods: ")
(@small_doc.methods - 1.methods).each{ |m| p(m)}

p("Here is the HTML inside of @small_doc: ")
p @small_doc.to_html

# Build an Hpricot object from a web page:
hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
my_html = ""
open("http://hpricot.com", hdrs).each {|s| my_html << s}
@web_doc= Hpricot(my_html)

p("Here are the links inside of this web page:")
@web_doc.search("a").each{ |e| p(e.to_html) }

# Questions?
# bikle@bikle.com 
# Subject: I have a question about Hpricot.
