module Panorama
  class OpenTag < Tag
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
    
    def [](val, &blk)
      super(val) 
      self.content = blk
    end  
    
    attr_accessor :content 
    def render_content
      content.is_a?(Proc) ? content.call : content
    end
    
    attr_writer :output
    def output 
      @output ||= []
    end
    
    require 'cgi'  
    def render(&blk)
      self.content = blk if block_given? 
      self.output = head 
      self.output << middle  
      self.output << tail
      output
    end
    
    def middle
      buffer = content ? render_content : ''
      return buffer if buffer.is_a? String 
      if buffer.respond_to?(:each)
        buffer.each {|element| element.inpsect } 
      else
        buffer.render
      end    
    end
    
    def inspect
      "#<#{self.class} #{head}#{content.is_a?(String) ? content : '{block}'}#{tail} >"
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

    