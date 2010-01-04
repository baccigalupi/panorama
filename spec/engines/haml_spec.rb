require File.dirname(__FILE__) + '/../spec_helper'

class Simple < Panorama::View
  engine_type :haml 
  requires :name, :indented => false
  
  def markup
    self[:indented] ? unindented_markup : indented_markup
  end  
  
  def unindented_markup
"%h1 
Hello
= self[:name]"
  end

  def indented_markup 
    "
    %h1
      Hello
      = self[:name]
    "
  end
end     

class Titleous < Simple 
  requires :title
  
  def long_name
    "#{self[:name]}: #{self[:title]}"
  end
  
  def markup
    self[:indented] ? unindented_markup : indented_markup
  end  
  
  def indented_markup 
    "
    #{super}
    %p  
      Your full designation is:
      %b 
        = long_name  
    "   
  end 
  
  def unindented_markup 
"
#{super}
%p  
Your full designation is:
%b 
  = long_name  
" 
  end   
end  


describe "Haml Views" do 
  
  describe Panorama::Engine::Haml do
    it 'should render an empty string' do
      Panorama::Engine::Haml.render("", {:scope => Object.new}).should == ""
    end
  
    it 'should do some other hamlish stuff' do
      Panorama::Engine::Haml.render("%p\n foo\n%q\n bar\n %a\n  baz", {:scope => Object.new}).should == "<p>\n  foo\n</p>\n<q>\n  bar\n  <a>\n    baz\n  </a>\n</q>\n"
      Panorama::Engine::Haml.render('%p Hello #{who}', {:scope => Object.new, :locals => {:who => 'World'}}).should == "<p>Hello World</p>\n"
    end  
  end 
  
  describe 'unindented markup' do 
    it 'should render local variables' do 
      output = Simple.render(:name => 'Kane')
      output.should include( "Kane" ) 
    end
  
    it 'should render methods' do
      output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
      output.should match(/<h1>\s*Hello\s*Kane\s<\/h1>/) 
      output.should match(/Kane: Cog in Wheel/)
    end 
  end 

  describe 'indented markup' do
    it 'should strip leading indents' do 
       @indented_string = "
        SUPER
        %p
          Your full designation is:
          %b LONG_NAME
        "
      @fixed_string = 
"
SUPER
%p
  Your full designation is:
  %b LONG_NAME
"     
      Panorama::Engine::Haml.strip_leading_indent(@indented_string).should == @fixed_string
    end    
    
    it 'should render' do
      output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
      output.should match(/<h1>\s*Hello\s*Kane\s<\/h1>/) 
      output.should match(/Kane: Cog in Wheel/)
    end
    
  end  
     
end   