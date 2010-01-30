module Panorama
  class Page < View 
    include Engine::PageHtmlMethods
    
    # Allows the class-level definition of html declaration in one simple place
    def self.html( *args )
      easy_opt = if [Symbol, String].include?( args.first.class )
        @xhml = false 
        args.shift
      end 
      opts = Gnash.new(args.first) 
      
      @xhtml = opts.keys.include?( 'html' ) ? false : true  
      
      encoding = opts.delete(:encoding)
      self.xml_options.merge!(:encoding => encoding) if encoding
      version = opts.delete(:version)
      self.xml_options.merge!(:version => version) if version
      
      @doctype_opts = if easy_opt 
        [easy_opt, opts]
      else  
        [opts]
      end  
    end
    
    def self.doctype_options
      @doctype_opts ||= Gnash.new
    end  
    
    def self.xml? 
      @xhtml.nil?  ? true : @xhtml
    end
    
    def self.xml_options
      @xml_opts ||= Gnash.new
    end 
    
    def self.clear_html_opts 
      @xml_opts = @xhml = @doctype_opts = nil
    end 
     
    def page_markup(meth)
      html_declaration
      html do
        head_html
        send(meth)
      end  
    end 
    
    def html_declaration
      xml if self.class.xml?
      doctype *self.class.doctype_options
    end  
    
    def head_html
      head
    end
    
    def build_proxy(meth)
      page_markup(meth) 
    end  
    
    # methods to be overwritten in the descendents
    def head
    end 
    
    def markup
    end  
  end
end    