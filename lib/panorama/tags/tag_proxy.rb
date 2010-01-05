module Panorama
  class TagProxy < Proxy
    attr_reader :tag
    
    def initialize( *args, &blk ) 
      super( *args )
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