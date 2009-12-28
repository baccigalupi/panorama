module Panorama
  class Proxy
    attr_reader :tag
    
    def initialize( *args, &blk ) 
      content = args.shift if args.first.is_a?( String )
      opts = Gnash.new( args.shift ) 
      type = opts.delete(:type) unless type
      @tag = "Panorama::#{type.upcase}".constantize.new(opts, &blk) if type
      @tag.content = content if @tag && content && !@tag.content  
    end
    
    def render
      tag.render if tag
    end
      
  end 
end      