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
  end
end    