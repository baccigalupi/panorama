module Panorama
  class Proxy
    attr_reader :view, :content, :opts, :type
    
    # todo: initialization takes a hash of opts, :args option is passed to proxy target
    def initialize( args ) 
      raise ArgumentError, 'Proxies must initialize with a Hash-like object' unless args.respond_to?(:keys)
      @opts = args
      @content = args.delete(:content)
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