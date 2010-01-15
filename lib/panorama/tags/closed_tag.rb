module Panorama
  class ClosedTag < Tag
    def self.head
      @head ||= "<#{type}#{SUBSTITUTION_STRING}" 
    end  
    
    def self.tail
      @tail ||= " />"
    end 
      
    def render(level=nil) 
      super(level)
      output = head
      output << tail
      output
    end  

    METHOD_NAMES = ['area', 'base', 'br', 'col', 'frame', 'hr', 'img', 'input', 'link', 'meta']
    CLASS_NAMES = METHOD_NAMES.map{|str| str.upcase } 
  end
  
  ClosedTag::CLASS_NAMES.each do |name| 
    Panorama.class_eval "
      class #{name} < ClosedTag; end
    "
  end
  
  class XML < ClosedTag
    def default_attrs
      Gnash.new( :version => "1.0", :encoding => "utf-8" )
    end
    
    def self.head
      @head ||= "<?#{type}#{SUBSTITUTION_STRING}"
    end
    
    def self.tail
      @tail ||= " ?>" 
    end   
  end 
  
  class Doctype < ClosedTag 
    XHTML_TYPES = { 
      :transitional => ["-//W3C//DTD XHTML 1.0 Transitional//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"], 
      :strict => ["-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"], 
      :frameset => ["-//W3C//DTD XHTML 1.0 Frameset//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"],
      :"1.1" => ["-//W3C//DTD XHTML 1.1//EN", "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"],
      :basic => ["-//W3C//DTD XHTML Basic 1.1//EN", "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd"],
      :mobile => ["-//WAPFORUM//DTD XHTML Mobile 1.2//EN", "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd"],
      :"5" => []
    }
    
    HTML_TYPES = {
      :transitional => ["-//W3C//DTD HTML 4.01 Transitional//EN", "http://www.w3.org/TR/html4/loose.dtd"],
      :strict => ["-//W3C//DTD HTML 4.01//EN", "http://www.w3.org/TR/html4/strict.dtd"],
      :frameset => ["-//W3C//DTD HTML 4.01 Frameset//EN", "http://www.w3.org/TR/html4/frameset.dtd"]
    }
    
    TYPE_CASTING = {
      true => XHTML_TYPES,
      false => HTML_TYPES
    }
    
    attr_reader :xhtml, :flavor
    
    def initialize( *args ) 
      type = args.shift
      @xhtml = true
      if type.is_a?( Hash ) 
        @xhtml = false if ['html', :html].include?( type.keys.first ) 
        @flavor = type.values.first.to_sym
      else
        @flavor = (type || :transitional).to_sym 
      end
      super({})    
    end  
      
    def public_declaration 
      flavor != :"5" ? "PUBLIC" : ""
    end
     
    def self.head
      @head ||= "<!DOCTYPE html #{SUBSTITUTION_STRING}"
    end 
    
    def attrs
      str = TYPE_CASTING[xhtml][flavor]
      str = str ? str.join('" "') : ''
      str.empty? ? str : " \"#{str}\""
    end  
    
    def head 
      super( "#{public_declaration}#{attrs}" )
    end  
    
    def self.tail
      @tail ||= ">" 
    end
  end      
end    