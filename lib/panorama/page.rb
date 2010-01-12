module Panorama
  class Page < View 
    def self.html( *args )
      @html_opts = args
    end
    
    def page_markup(markup_method = :markup)
      html do
        head_html
        render_external(markup_method)    
      end  
    end 
    
    def html(&blk)
      build_tag_proxy( 'xml', :version => "1.0", :encoding => "utf-8" )
    end  
    
    def head_html
      head
    end
    
    def render(markup_method = :markup)
      page_markup(markup_method)
    end
    
    # methods to be overwritten in the descendents
    def head
    end 
    
    def markup
    end  
  end
end    