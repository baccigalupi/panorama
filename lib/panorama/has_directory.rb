module Panorama
  module HasDirectory 
    attr_writer :directory
    
    def global_default_directory
      defined?( RAILS_ROOT ) ? RAILS_ROOT + '/app/views' : ''
    end
    
    def default_directory
      superclass.ancestors.include?( Panorama::View ) ? superclass.directory : global_default_directory
    end  
    
    def directory(dir=nil)
      if !dir.nil? or @directory.nil? 
        self.directory =  dir || default_directory
      end
      @directory  
    end 
  end
end   