module Panorama
  class TagProxy < Proxy
    attr_reader :tag
    
    def initialize( args, &blk ) 
      super( args )
      @tag = "Panorama::#{type.upcase}".constantize.new(opts, &blk) if type
      raise ArgumentError, 
        "Valid tag type required to generate a tag proxy. '#{type}' is not a valid tag type." unless @tag
      if @tag.is_a?(OpenTag)
        @tag.content = content if @tag && content && !@tag.content 
      else
        
      end    
      @tag.view = self.view
    end
    
    def render(buffer = output, level = 0)
      buffer << tag.render(level)
    end 
  end 
end      