module Panorama
  class Proxy 
    attr_reader :tag, :output
    
    def initialize( *args, &blk ) 
      content = args.shift if args.first.is_a?( String )
      opts = Gnash.new( args.shift ) 
      type = opts.delete(:type)
      @output = opts.delete(:output)
      @tag = "Panorama::#{type.upcase}".constantize.new(opts, &blk) if type
      @tag.content = content if @tag && content && !@tag.content 
      raise ArgumentError, 
        "Valid tag type required to generate a tag proxy. '#{type}' is not a valid tag type." unless @tag
    end
    
    def render(buffer = output)
      raise "Output required to render a tag proxy. Please set it on proxy initialization, or pass it in to render as the first argument" unless buffer
      buffer << tag.render
    end
      
  end 
end      