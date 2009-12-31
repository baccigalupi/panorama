module Panorama
  class Proxy 
    attr_reader :tag, :view
    
    def initialize( *args, &blk ) 
      content = args.shift if args.first.is_a?( String )
      opts = Gnash.new( args.shift ) 
      type = opts.delete(:type)
      @view = opts.delete(:view)
      raise ArgumentError, "View with proxy_buffer required." unless view && proxy_buffer
      @output = opts.delete(:output)
      @tag = "Panorama::#{type.upcase}".constantize.new(opts, &blk) if type
      raise ArgumentError, 
        "Valid tag type required to generate a tag proxy. '#{type}' is not a valid tag type." unless @tag
      @tag.content = content if @tag && content && !@tag.content
      @tag.view = self.view
    end
    
    def render(buffer = output)
      buffer << tag.render
    end 
    
    def output
      view.output
    end  
    
    def proxy_buffer
      view.proxy_buffer
    end  
      
  end 
end      