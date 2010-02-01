module Panorama
  class View
    extend HasDirectories
     
    attr_accessor :locals 
    
    def initialize(opts={})
      load( opts ) 
    end
    
    def defaults
      self.class.superclass.ancestors.include?(Panorama::View) ? 
        self.class.superclass.defaults.merge(self.class.defaults) : 
        self.class.defaults
    end 
    
    def required
      self.class.required
    end   
    
    def load( opts )
      self.locals = Gnash.new( defaults.merge(opts) )  
    end 
    
    def raise_require_exceptions
      if (keys = locals.keys) && required && !required.empty?
        missing = (required - keys)
        raise ArgumentError, "#{self.class} initialization requires additional variable(s): #{missing.inspect}" unless missing.empty?
        if self.class.selective_require 
          extra = keys - self.class.required
          raise ArgumentError, "#{self.class} initialization only takes the following variable(s): #{required.inspect}. Additional variables were passed in: #{extra.inspect}" unless extra.empty?
        end  
      end
    end    
    
    def self.dir
      # TODO: change to point to the file of directory of the actual view file
      File.dirname(__FILE__)
    end  
    
    def self.requires(*args)
      if args.last.class == Hash 
        @defaults = args.pop 
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
    def self.render(opts={}, &blk) 
      view = self.pool.get 
      if view
        view.load(opts)
      else  
        view = new(opts)
      end  
      output = view.renders(&blk)
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
     
    def render(opts={}, &blk)
      raise_require_exceptions
      markup_method = opts.delete(:method) || :markup
      level = opts.delete(:level) || 0
      if engine_type == :panorama
        render_panorama(markup_method, level, &blk)
      else
        render_external(markup_method)
      end    
    end
    
    def renders(opts={}, &blk)
      out = render(opts, &blk)
      out.is_a?( Array ) ? out.join('') : out
    end  
    
    def render_panorama(meth, level, &blk) 
      clear_output
      build_proxy(meth, &blk) 
      first_level = proxy_buffer.dump
      first_level.map{ |proxy| proxy.render(level) }
      output
    end
    
    def build_proxy(meth, &blk)
      send(meth, &blk)
    end  
    
    def clear_output 
      output.clear 
      proxy_buffer.clear
    end  
    
    def output
      @output ||= []
    end 
          
    def proxy_buffer
      @proxy_buffer ||= []
    end  
    
    def render_external(meth) 
      opts = locals.merge(:scope => self)
      self.class.engine.render(send(meth), opts)
    end  
    
    include Engine::HtmlMethods 
    
    def indentation( times )
      Panorama.indentation( times )
    end
          
  end
end    