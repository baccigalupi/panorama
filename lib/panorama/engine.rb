module Panorama
  module Engine
    class Default
    end  
    
    module HtmlMethods
      (ClosedTag::METHOD_NAMES + OpenTag::METHOD_NAMES).each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            add_proxy_to_buffer( '#{method_name}', *args, &blk )
          end
        " 
      end 
      
      def add_proxy_to_buffer( tag_type, *args, &blk ) 
        proxy = build_tag_proxy( tag_type, *args, &blk )
        proxy_buffer << proxy
        proxy
      end  
      
      [:haml, :erb].each do |engine_type|
        module_eval "
          def #{engine_type}( content )
            build_engine_proxy( content, :#{engine_type} )
          end
        "
      end  
      
      def build_tag_proxy( type, *args, &blk )
        content = [String, Symbol].include?(args.first.class) ? args.shift  : nil 
        opts = args.first || Gnash.new
        opts.merge!(:type => type, :view => self, :content => content)
        TagProxy.new( opts, &blk )
      end 
      
      def build_engine_proxy( content, type )
        proxy = EngineProxy.new( {:content => content, :type => type, :view => self})
        proxy_buffer << proxy
        proxy
      end    
    end
    
    module PageHtmlMethods 
      ['xml', 'doctype'].each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            add_proxy_to_buffer( '#{method_name}', *args, &blk )
          end
        "  
      end
    end
      
  end
end    