lib = File.expand_path( File.dirname(__FILE__) + '/panorama/' )
require lib + '/support/gnash'
require lib + '/support/string'
require lib + '/support/array'
require lib + '/tag'
require lib + '/tags/closed_tag'
require lib + '/tags/open_tag'
require lib + '/tags/proxy'
require lib + '/tags/tag_proxy' 
require lib + '/tags/engine_proxy' 
require lib + '/has_engine'
require lib + '/has_indentation'
require lib + '/pool'
require lib + '/engine'
require lib + '/engines/erb'
require lib + '/engines/haml'
require lib + '/view'
require lib + '/page'

module Panorama 
  AVAILABLE_ENGINES =  {
    :panorama =>  Panorama::Engine::Default, 
    :haml =>  Panorama::Engine::Haml, 
    :erb =>   Panorama::Engine::ERB
  }
  
  extend HasEngine
  extend HasIndentation
end  