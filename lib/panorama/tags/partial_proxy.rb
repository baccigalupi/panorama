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
      if partial_output.is_a?(Array)
        self.output += partial_output
      else
        self.output << partial_output
      end    
    end 
  end 
end   