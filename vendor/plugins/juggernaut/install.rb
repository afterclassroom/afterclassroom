require 'fileutils'

here = File.dirname(__FILE__)
there = RAILS_ROOT

FileUtils.mkdir_p("#{there}/public/javascripts/juggernaut/")
FileUtils.mkdir_p("#{there}/public/juggernaut/")

puts "Installing Juggernaut..."
FileUtils.cp("#{here}/media/swfobject.js", "#{there}/public/javascripts/juggernaut/")
FileUtils.cp("#{here}/media/juggernaut.js", "#{there}/public/javascripts/juggernaut/")
FileUtils.cp("#{here}/media/juggernaut.swf", "#{there}/public/juggernaut/")
FileUtils.cp("#{here}/media/expressinstall.swf", "#{there}/public/juggernaut/")

FileUtils.cp("#{here}/media/juggernaut_hosts.yml", "#{there}/config/")
puts "Juggernaut has been successfully installed."
puts
puts "Please refer to the readme file #{File.expand_path(here)}/JUGGERNAUT-README"