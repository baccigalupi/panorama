module Panorama
  class OpenTag < Tag
    attr_accessor :content
    
    def initialize(opts={}, &blk) 
      super(opts)
      self.content = blk
     end  
    
    def self.head
      @head ||= "<#{type}#{SUBSTITUTION_STRING}>" 
    end  
    
    def self.tail
      @tail ||= "</#{type}>"
    end
    
    def [](val)
      super(val) 
      self.content = blk
    end  
    
    def render_content
      content.is_a?(Proc) ? content.call : content
    end   
      
    def render(&blk) 
      output = head 
      if block_given? 
        output << yield
      elsif content 
        output << render_content
      end  
      output << tail
      output
    end  

    METHOD_NAMES = [
      'a', 'abbr', 'acronym', 'address', 
      'b', 'bdo', 'big', 'blockquote', 'body', 'button', 
      'caption', 'center', 'cite', 'code', 'colgroup',
      'dd', 'del', 'dfn', 'div', 'dl', 'dt', 'em',
      'embed',
      'fieldset', 'form', 'frameset',
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'html', 'i',
      'iframe', 'ins', 'kbd', 'label', 'legend', 'li', 'map',
      'noframes', 'noscript', 
      'object', 'ol', 'optgroup', 'option', 'p', 'param', 'pre',
      'q', 's',
      'samp', 'script', 'select', 'small', 'span', 'strike',
      'strong', 'style', 'sub', 'sup',
      'table', 'tbody', 'td', 'textarea', 'tfoot', 
      'th', 'thead', 'title', 'tr', 'tt', 'u', 'ul', 'var'
    ]
  
    CLASS_NAMES = METHOD_NAMES.map{|str| str.upcase } 
  end
  
  OpenTag::CLASS_NAMES.each do |name| 
    Panorama.class_eval "
      class #{name} < OpenTag; end
    "
  end   
end

    