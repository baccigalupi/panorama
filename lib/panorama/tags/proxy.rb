module Panorama
  class Proxy
    attr_reader :view, :content, :opts, :type
    
    def initialize( *args ) 
      @content = args.shift if args.first.is_a?( String )
      @opts = Gnash.new( args.shift )
      @type = opts.delete(:type)
      @view = opts.delete(:view) 
      raise ArgumentError, "View with proxy_buffer required." unless view && proxy_buffer
    end
    
    def output
      view.output
    end  
    
    def proxy_buffer
      view.proxy_buffer
    end 
  end
end    