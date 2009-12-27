require File.dirname(__FILE__) + '/../spec_helper'

describe "Haml Views" do
  describe Arch::Engine::Haml do
    it 'should render an empty string' do
      Arch::Engine::Haml.render("").should == ""
    end
  
    it 'should do some other hamlish stuff' do
      Arch::Engine::Haml.render("%p\n foo\n%q\n bar\n %a\n  baz").should == "<p>\n  foo\n</p>\n<q>\n  bar\n  <a>\n    baz\n  </a>\n</q>\n"
      Arch::Engine::Haml.render('%p Hello #{who}', :locals => {:who => 'World'}).should == "<p>Hello World</p>\n"
    end  
  end 
  
  class Simple < Arch::View
    engine_type :haml 
    requires :name
    
    def markup
"""      
%h1 Hello #{self[:name]}
"""
    end
  end     
  
  class Titleous < Simple 
    requires :name, :title
    
    def long_name
      "#{self[:name]}: #{self[:title]}"
    end
    
    def markup
"""      
#{super}
%p  
  Your full designation is:
  %b #{long_name}     
"""
    end
  end
  
  it 'should render local variables' do 
    output = Simple.render(:name => 'Kane')
    output.should == "<h1>Hello Kane</h1>\n"
  end
  
  it 'should render method inline' do
    output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
    output.should == 
"<h1>Hello Kane</h1>
<p>
  Your full designation is:
  <b>Kane: Cog in Wheel</b>
</p>
"
  end      
     
end   