module Panorama
  class Proxy
    attr_reader :tag
    
    def initialize( *args, &blk ) 
      content = args.shift if args.first.is_a?( String )
      opts = Gnash.new( args.shift ) 
      type = opts.delete(:type)
      @tag = "Panorama::#{type.upcase}".constantize.new(opts, &blk) if type
      @tag.content = content if @tag && content && !@tag.content 
      raise ArgumentError, 
        "Valid tag type required to generate a tag proxy. '#{type}' is not a valid tag type." unless @tag
    end
    
    def render
      content = tag.render
    end
      
  end 
end      