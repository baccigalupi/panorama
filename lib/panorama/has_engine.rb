module Panorama
  module HasEngine
    def default_engine_type 
      :panorama
    end
    
    def engine_type(t=nil)
      if !t.nil? or @engine_type.nil? 
        self.engine_type =  t || default_engine_type
      end
      @engine_type  
    end 
  
    def engine_type=( t )
      raise ArgumentError, "Rendering engine :#{t} unknown" unless Panorama::AVAILABLE_ENGINES.keys.include?( t )
      @engine_type = t
    end  
  
    def engine
      Panorama::AVAILABLE_ENGINES[engine_type]  
    end      
  end
end    