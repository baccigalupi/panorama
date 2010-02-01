module Panorama
  module HasDirectories 
    attr_writer :directory, :pub_directory, :js_directory, :css_directory
    
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
    
    def publication_directory(dir=nil)
      if !dir.nil? or @pub_directory.nil? 
        self.pub_directory =  dir || directory + '/externals'
      end
      @pub_directory 
    end
    
    def js_directory(dir=nil)
      if !dir.nil? or @js_directory.nil? 
        self.js_directory =  dir || publication_directory + '/js'
      end
      @js_directory 
    end  
    
    def css_directory(dir=nil)
      if !dir.nil? or @css_directory.nil? 
        self.css_directory =  dir || publication_directory + '/css'
      end
      @css_directory 
    end  
  end
end   