module Arch
  class View 
    extend HasEngine
    
    def self.default_engine_type
      superclass.respond_to?(:engine_type) ? superclass.engine_type : Arch.engine_type
    end  
  end
end    