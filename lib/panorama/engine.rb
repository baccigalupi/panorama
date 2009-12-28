module Panorama
  module Engine
    class Default
    end
    
    module HtmlMethods
      (ClosedTag::METHOD_NAMES + OpenTag::METHOD_NAMES).each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            output << build_tag_proxy( '#{method_name}', *args, &blk )
          end
        " 
        
        def build_tag_proxy( type, *args, &blk )
          content = args.first.is_a?( String ) ? args.shift  : nil  
          opts = args.first || Gnash.new
          opts.merge!(:type => type) 
          new_args = [opts]
          new_args.unshift(content) if content
          Proxy.new( *new_args, &blk )
        end  
      end
    end
  end
end    