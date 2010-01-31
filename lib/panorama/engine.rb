module Panorama
  module Engine
    class Default
    end  
    
    module HtmlMethods
      ( ClosedTag::METHOD_NAMES + OpenTag::METHOD_NAMES - 
        ['title', 'meta', 'head'] + ['comment', 'text', 'rawtext'] ).each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            add_tag_proxy_to_buffer( '#{method_name}', *args, &blk )
          end
        " 
      end  
      alias :h :text  
      alias :raw_text :rawtext  
      
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
        opts.merge!(:type => type, :view => self, :proxy_content => content)
        TagProxy.new( opts, &blk )
      end 
      
      def add_tag_proxy_to_buffer( tag_type, *args, &blk ) 
        append_proxy( build_tag_proxy( tag_type, *args, &blk ) )
      end  
      
      def append_proxy( proxy ) 
        proxy_buffer << proxy
        proxy
      end  
      
      def build_engine_proxy( content, type )
        append_proxy( EngineProxy.new( :proxy_content => content, :type => type, :view => self ) )
      end
      
      def partial( *args )
        if args.size == 1 
          instance = args.first
          instance.locals = self.locals.merge( instance.locals ) 
          append_proxy( PartialProxy.new( :partial => instance, :view => self ) )
        else
          engine_type = args[0]
          file = args[1]
          append_proxy( EngineProxy.new( :proxy_content => file.read, :type => engine_type, :view => self ) )
        end    
      end      
    end
    
    module PageHtmlMethods 
      ['xml', 'doctype'].each do |method_name|
        module_eval "
          def #{method_name}( *args, &blk )
            add_tag_proxy_to_buffer( '#{method_name}', *args, &blk )
          end
        "  
      end
      
      def head_html(*args, &blk)
        add_tag_proxy_to_buffer( 'head', *args, &blk )
      end  
      
      def page_title(*args, &blk) 
        add_tag_proxy_to_buffer( 'title', *args, &blk )
      end 
      
      alias :title :page_title  
      
      def meta(opts)
        opts = Gnash.new( opts )
        keys = opts.keys 
        first_key = keys.first
        unless ['lang', 'dir'].include?(first_key) || keys.include?('content')
          content = opts[first_key]
          opts.delete(first_key)
          opts[:name] = first_key
          opts[:content] = content
        end 
        add_tag_proxy_to_buffer('meta', opts) 
      end 
      
      def metanize(type, content, opts={}) 
        opts = Gnash.new(opts)
        opts[:content] = content
        opts[:name] = type
        meta(opts) 
      end  
      
      ['meta_description', 'meta_author', 'meta_keywords'].each do |method_name|
        module_eval "
          def #{method_name}( content, opts={} )
            metanize('#{method_name.gsub('meta_', '')}', content, opts)
          end
        " 
      end 
        
    end # PageHtmlMethods
  end # Engine
end # Panorama   