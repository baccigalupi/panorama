require File.dirname(__FILE__) + '/../spec_helper'

describe "Haml Views" do
  before do
    @output = "<h1>Hello Kane</h1>
<p>
  Your full designation is:
  <b>Kane: Cog in Wheel</b>
</p>
" 
  end
    
  describe Arch::Engine::Haml do
    it 'should render an empty string' do
      Arch::Engine::Haml.render("", {:scope => Object.new}).should == ""
    end
  
    it 'should do some other hamlish stuff' do
      Arch::Engine::Haml.render("%p\n foo\n%q\n bar\n %a\n  baz", {:scope => Object.new}).should == "<p>\n  foo\n</p>\n<q>\n  bar\n  <a>\n    baz\n  </a>\n</q>\n"
      Arch::Engine::Haml.render('%p Hello #{who}', {:scope => Object.new, :locals => {:who => 'World'}}).should == "<p>Hello World</p>\n"
    end  
  end 
  
  class Simple < Arch::View
    engine_type :haml 
    requires :name
  end     
  
  class Titleous < Simple 
    requires :name, :title
    
    def long_name
      "#{self[:name]}: #{self[:title]}"
    end
  end
  
  
  describe 'unindented markup' do 
    before do
      @title = "<h1>Hello Kane</h1>"
    end  
    
# SETUP THE CLASSES WITH SOME MARKUP ---------------    
class Simple 
  def markup
"%h1 
  Hello
  = self[:name]"
  end
end  
   
method = 
'
#{super}
%p  
  Your full designation is:
  %b 
    = long_name  
'    
    Titleous.class_eval "
        def markup 
          \"#{method}\"
        end
    "   
# FINISH: SETUP THE CLASSES WITH SOME MARKUP -----    
    
    it 'should render local variables' do 
      output = Simple.render(:name => 'Kane')
      output.should include( "Kane" ) 
    end
  
    it 'should render methods' do
      output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
      output.should include( "Kane" )
      output.should include( "Cog in Wheel" )
    end 
  end 

  describe 'indented markup' do
    before do
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
    end  
    
    class Titleous
      def markup
        "
        #{super}
        %p  
          Your full designation is:
          %b #{long_name}  
        "   
      end   
    end 
    
    it 'should strip leading indents' do
      Arch::Engine::Haml.strip_leading_indent(@indented_string).should == @fixed_string
    end    
    
    it 'should render' do
      output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
      output.should == @output
    end
    
  end  
     
end   