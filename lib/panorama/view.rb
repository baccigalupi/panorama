module Panorama
  class View
    attr_reader :locals 
    
    def initialize(opts={})
      defaults = self.class.defaults
      @locals = Gnash.new( defaults.merge(opts) ) 
      required = self.class.required
      if (keys = locals.keys) && required && !required.empty?
        missing = (required - keys)
        raise ArgumentError, "#{self.class} initialization requires additional variable(s): #{missing.inspect}" unless missing.empty?
        if self.class.selective_require 
          extra = keys - self.class.required
          raise ArgumentError, "#{self.class} initialization only takes the following variable(s): #{required.inspect}. Additional variables were passed in: #{extra.inspect}" unless extra.empty?
        end  
      end  
    end 
    
    def self.requires(*args)
      if args.last.class == Hash
        @defaults = Hash.new( args.pop )
        args += defaults.keys
      end 
      if superclass.respond_to?( :required ) 
        args = (superclass.required || []) + args  
      end  
      @required = args.uniq.map{ |x| x.to_s }
    end 
    
    def self.defaults
      @defaults ||= Hash.new
    end  
    
    def self.required 
      @required
    end  
    
    def self.requires_only(*args)
      @selective_require = true
      requires(*args)
    end
    
    def self.selective_require 
      @selective_require
    end      
    
    def [](val) 
      locals[val]
    end   
    
    extend HasEngine
    
    def self.default_engine_type
      superclass.respond_to?(:engine_type) ? superclass.engine_type : Panorama.engine_type
    end
    
    # Instance Pooling --------------------------
    def self.pool
      @pool ||= Pool.new(max_pool_size)
    end
    
    def self.max_pool_size(val=nil)
      if !val.nil? or @max_pool_size.nil? 
        self.max_pool_size = val || 20
      end
      @max_pool_size  
    end 
    
    def self.max_pool_size=(val) 
      @max_pool_size = val
    end    
    
    def recycle
     clear
     self.class.pool.put( self ) 
    end 
    
    def clear
      @locals = Gnash.new
    end      
    
    # Rendering --------------------------------
    def self.render(opts={})
      view = self.pool.get || new(opts) 
      output = view.render
      view.recycle
      output
    end
    
    # needed by erb to grab the bindings of the object
    def context
      return binding
    end  
    
    def markup
      ""
    end
    
    def engine_type
      self.class.engine_type
    end    
     
    def render
      if engine_type == :panorama
        render_panorama
      else
        render_external
      end    
    end 
    
    def render_panorama
      clear_output
      markup
      output_proxies.dup.map{|proxy| proxy.render}.flatten
    end
    
    def clear_output 
      output.clear 
      output_proxies.clear
    end  
    
    def output
      @output ||= []
    end 
    
    def output_proxies
      @output_proxies ||= []
    end   
    
    def render_external 
      opts = locals.merge(:scope => self)
      self.class.engine.render(markup, opts)
    end  
    
    include Engine::HtmlMethods      
  end
end    