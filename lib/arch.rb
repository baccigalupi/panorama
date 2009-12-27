lib = File.dirname(__FILE__) + '/arch/'
require lib + 'support/gnash'
require lib + 'has_engine'
require lib + 'pool'
require lib + 'engine'
require lib + 'engines/haml'
require lib + 'engines/erb' 
require lib + 'view'

module Arch 
  AVAILABLE_ENGINES =  {
    :arch =>  Arch::Engine::Default, 
    :haml =>  Arch::Engine::Haml, 
    :erb =>   Arch::Engine::ERB
  }
  
  extend HasEngine
end  