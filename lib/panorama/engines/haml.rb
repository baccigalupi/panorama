require 'haml'

module Panorama
  module Engine
    class Haml 

      def self.render(text, options = {}, &block)
        scope  = options.delete(:scope)  
        raise ArgumentError, "Missing scope for Haml's engine." unless scope
        locals = options.delete(:locals) || {}
        engine(text, options).to_html(scope, locals, &block)
      end 
      
      def self.engine( text, options ) 
        begin
          ::Haml::Engine.new(text, options)
        rescue
          text = strip_leading_indent(text)
          ::Haml::Engine.new( text, options )
        end    
      end
      
      def self.strip_leading_indent(text)
        indent = nil
        new_text = ""
        text.each_line do |line|
          unless indent
            line.match(/(\s*)[\S]/)
            indent = $1 
          end
          new_text << ( indent ? line.gsub(indent, '') : line )
        end
        new_text 
      end    
    end  
  end
end    