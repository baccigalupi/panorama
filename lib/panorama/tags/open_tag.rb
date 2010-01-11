module Panorama
  class OpenTag < Tag
    attr_accessor :content, :rendered_content 
    
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
    
    attr_writer :output
    def output 
      @output ||= view ? view.output : []
    end
    
    def render(level=nil, &blk)
      super(level)
      self.content = blk if block_given? 
      render_content
      
      self.output = head 
      middle # renders to output itself!
      self.output << tail
      output
    end
    
    def tail
      "#{has_content? ? "\n" : ""}#{indentation}#{super}"
    end    
    
    def render_content
      @has_content = nil
      @rendered_content = content.is_a?(Proc) ? content.call : content
    end
    
    def has_content?
      @has_content ||= rendered_content && (
        (rendered_content.class == String && !rendered_content.empty?) ||
        (rendered_content.is_a? Panorama::Proxy)
      )
    end  
    
    def content_indentation
      Panorama.indentation(indentation_level+1)
    end  
    
    def middle
      buffer = proxy_buffer.dump 
      if buffer.empty?
        output << "\n#{content_indentation}#{rendered_content}" if has_content?
      else
        buffer.map{|proxy| proxy.render(output, indentation_level+1 )}
      end
    end
    
    def inspect
      "#<#{self.class} #{head}#{content.is_a?(String) ? content : '{block}'}#{tail.gsub(/\s/, '')} >"
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

    