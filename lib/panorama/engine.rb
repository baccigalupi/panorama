module Panorama
  module Engine
    class Default
    end
    
    module HtmlMethods
      (ClosedTag::METHOD_NAMES + OpenTag::METHOD_NAMES).each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            proxy = build_tag_proxy( '#{method_name}', *args, &blk )
            proxy_buffer << proxy
            proxy
          end
        " 
      end
      
      def build_tag_proxy( type, *args, &blk )
        content = args.first.is_a?( String ) ? args.shift  : nil  
        opts = args.first || Gnash.new
        opts.merge!(:type => type, :view => self)
        new_args = [opts]
        new_args.unshift(content) if content
        TagProxy.new( *new_args, &blk )
      end
      
      def haml( content )
        EngineProxy.new( content, {:type => :haml, :view => self})
      end
      
      def erb( content )
        EngineProxy.new( content, {:type => :erb, :view => self})
      end    
    end
  end
end    