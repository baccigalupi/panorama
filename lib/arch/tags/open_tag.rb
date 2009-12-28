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
  end
end    