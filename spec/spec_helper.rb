require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../lib/panorama'


Spec::Runner.configure do |config| 
  Panorama::View.directory = File.dirname(__FILE__) + '/templates'
end