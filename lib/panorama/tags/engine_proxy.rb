module Panorama
  class EngineProxy < Proxy
    def initialize( *args, &blk ) 
      super(*args) 
    end 
    
    def engine
      @engine ||= Panorama::AVAILABLE_ENGINES[type]  
    end 
    
    def render(level=0)
      # todo: figure out how to make engines start at a given indent level
      self.output << engine.render( content, {:scope => view} )
    end 
  end
end  