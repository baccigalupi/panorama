require 'rubygems'
require File.expand_path( File.dirname(__FILE__)  + "/../../lib/panorama" )

class MyPage < Panorama::Page 
  def markup
    body :class => 'my_page' do 
      h1 "This is a Layout", :class => 'red'
      p do 
        a "Ruby Ghetto", :href => 'http://rubyghetto.com'
        caption "going no where fast"
      end
      #yield
    end  
  end  
end

puts MyPage.render.inspect 
      
      
class MyView < Panorama::View 
  def markup
    body :class => 'my_page' do 
      h1 "This is a Layout", :class => 'red'
    end
  end  
end

# puts MyView.render.inspect                   
