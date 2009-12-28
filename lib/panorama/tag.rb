module Panorama
  class Tag 
    SUBSTITUTION_STRING = "{{}}"
    
    attr_reader :element_id, :data_attrs
    def initialize(opts={})
      opts = Gnash.new(opts)
      self*(opts.delete(:class))
      self|(opts.delete(:id))
      self.data_attrs = opts 
    end  
     
    def self.type
      @tag ||= self.to_s.downcase.gsub("panorama::", '').to_sym
    end 
    
    def type
      self.class.type
    end   
    
    def classes
      @classes ||= []
    end 
    
    def *( *arg )
      arg.flatten.each do |sym|
        if sym
          sym = sym.to_sym 
          classes << sym unless classes.include?( sym )  
        end  
      end
      self
    end 
    
    def |( val )
      if val 
        begin
          @element_id = val.to_sym
        rescue 
          if val.is_a?(Array) && val.size == 1
            val = val.first 
            self | val
          else 
            raise ArgumentError, "A tag can only have one element id. Please assign it with a string or symbol."
          end
        end
      end    
      self  
    end
    
    def [](val)
      self|(val)
    end 
    
    def data_attrs=( hash )
      @data_attrs ||= Gnash.new
      hash.each do |key, value|
        @data_attrs[key] = value.to_s
      end  
      @data_attrs  
    end  
    
    def attributes
      att = Gnash.new
      att[:class] = classes.join(' ')  unless classes.empty?
      att[:id] = element_id.to_s if element_id 
      att.merge!(data_attrs) if data_attrs && !data_attrs.empty?
      att
    end 
    
    # Rendering: Used by subclasses ----------
        def head( str=attribute_string )
      self.class.head.gsub( SUBSTITUTION_STRING, str )
    end
    
    def tail
      self.class.tail
    end 
    
    def attribute_string 
      output = ""
      attributes.each do |arr|
        output << " #{arr[0]}=\"#{arr[1]}\""
      end
      output  
    end     
  end
end    