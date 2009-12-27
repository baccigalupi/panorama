require 'haml'

module Arch
  module Engine
    class Haml 
      def self.render(text, options = {}, &block)
        scope  = options.delete(:scope)  || Object.new
        locals = options.delete(:locals) || {}
        ::Haml::Engine.new(text, options).to_html(scope, locals, &block)
      end 
    end  
  end
end    