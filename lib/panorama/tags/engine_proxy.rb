module Panorama
  class EngineProxy < Proxy
    def initialize( *args, &blk ) 
      super(*args) 
    end 
    
    def engine
      @engine ||= Panorama::AVAILABLE_ENGINES[type]  
    end 
    
    def render(buffer = output)
      buffer << engine.render( content, {:scope => view} )
    end 
  end
end  