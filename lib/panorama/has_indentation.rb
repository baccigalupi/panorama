module Panorama
  module HasIndentation
    DEFAULT_INDENTATION_STRING = "  "
    
    def default_indentation_string
      DEFAULT_INDENTATION_STRING
    end  
    
    def indentation_string( str=nil )
      @indentation_string ||= (str || default_indentation_string)
    end
    
    def indentation( times )
      indentation_string * times
    end     
  end
end 