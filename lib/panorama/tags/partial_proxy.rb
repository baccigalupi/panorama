module Panorama
  class PartialProxy < Proxy
    attr_reader :partial
    
    def initialize( args, &blk ) 
      super( args )
      @partial = opts[:partial]
      raise ArgumentError, "Partial must respond to render" unless @partial.respond_to?(:render)
    end
    
    def render(level = 0) 
      partial_output = partial.render(:level => level) 
      self.output << partial_output
      self.output.flatten!   
    end 
  end 
end   