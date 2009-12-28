require 'erb'

module Panorama
  module Engine
    class ERB
      def self.render(text, options = {}, &block)
        engine = ::ERB.new(text)
        scope = options[:scope] 
        scope = scope.class.ancestors.include?(Panorama::View) ? scope.context : scope.instance_eval("binding") 
        engine.result(scope)
      end 
    end
  end
end       
