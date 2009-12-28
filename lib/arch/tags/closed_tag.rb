module Arch
  class ClosedTag < Tag
    def self.head
      @head ||= "<#{type}#{SUBSTITUTION_STRING}" 
    end  
    
    def self.tail
      @tail ||= " />"
    end 
      
    def render 
      output = head
      output << tail
      output
    end  

    METHOD_NAMES = ['area', 'base', 'br', 'col', 'frame', 'hr', 'img', 'input', 'link', 'meta']
    CLASS_NAMES = METHOD_NAMES.map{|str| str.upcase } 
  end
  
  ClosedTag::CLASS_NAMES.each do |name| 
    Arch.class_eval "
      class #{name} < ClosedTag; end
    "
  end    
end    