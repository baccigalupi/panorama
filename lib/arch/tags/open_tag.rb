module Arch
  class OpenTag < Tag
    attr_accessor :content
    attr_reader :block
    
    def initialize(opts={}, &blk) 
      super(opts)
      @block = blk
     end  
    
    def self.head
      @head ||= "<#{type}#{SUBSTITUTION_STRING}>" 
    end  
    
    def self.tail
      @tail ||= "</#{type}>"
    end 
      
    def render(&blk) 
      output = head 
      if block_given? 
        output << yield
      elsif block
        output << block.call  
      elsif content 
        output << content
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
    Arch.class_eval "
      class #{name} < OpenTag; end
    "
  end   
end

    