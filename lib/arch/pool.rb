module Arch
  class Pool < Array 
    undef_method :[]
    undef_method :[]=
    undef_method :&
    undef_method :*
    undef_method :+
    undef_method :-
    undef_method :<<
    undef_method :at
    undef_method :collect
    undef_method :compact
    undef_method :delete
    undef_method :delete_at
    undef_method :delete_if
    undef_method :each
    undef_method :fetch
    undef_method :first
    undef_method :flatten
    undef_method :insert 
    undef_method :join
    undef_method :last
    undef_method :map
    undef_method :pack
    undef_method :reject   
    undef_method :replace   
    undef_method :reverse   
    undef_method :select   
    undef_method :slice   
    undef_method :sort   
    undef_method :uniq   
    undef_method :unshift   
  
    attr_accessor :max_size
    def initialize( max_size ) 
      self.max_size = max_size
      super()
    end  
  
    def push( val )
      super if size < max_size
    end
    
    alias :put :push
    alias :get :shift  
    
    def inspect
      "<#{self.class} @max_size=#{max_size}>"
    end  
     
  end  
end          