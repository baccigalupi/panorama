require File.dirname(__FILE__) + '/../spec_helper'

describe "Default Views" do
  before(:each) do  
    @view = Panorama::View.new
  end
  
  describe 'tag methods' do 
    ([
      'a', 'abbr', 'acronym', 'address', 
      'b', 'bdo', 'big', 'blockquote', 'body', 'button', 
      'caption', 'center', 'cite', 'code', 'colgroup',
      'dd', 'del', 'dfn', 'div', 'dl', 'dt', 'em',
      'embed',
      'fieldset', 'form', 'frameset',
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'html', 'i',
      'iframe', 'ins', 'kbd', 'label', 'legend', 'li', 'map',
      'noframes', 'noscript', 
      'object', 'ol', 'optgroup', 'option', 'p', 'param', 'pre',
      'q', 's',
      'samp', 'script', 'select', 'small', 'span', 'strike',
      'strong', 'style', 'sub', 'sup',
      'table', 'tbody', 'td', 'textarea', 'tfoot', 
      'th', 'thead', 'title', 'tr', 'tt', 'u', 'ul', 'var'
    ] + ['area', 'base', 'br', 'col', 'frame', 'hr', 'img', 'input', 'link', 'meta']).each do |method|
      
      it "should have a method ##{method}" do
        @view.should respond_to(method)
      end 
    end
  end
  
  describe 'rendering' do
    class SimpleView < Panorama::View 
      requires :name
      def markup
        h1 self[:name] 
      end  
    end
  
    class WordierView < SimpleView 
      requires :job_title
      def markup
        super
        p(:class => 'clearfix', :id => 'jabber') do 
          span "I am just a "
          b self[:job_title]
        end  
      end  
    end   
    
    it 'should have an empty array for output as default' do 
      @view.output.should == []
    end
    
    it 'should clear the output at each render' do
      @view.output.should_receive(:clear)
      @view.render
    end
    
    it 'should add proxies to the output_proxies list' do 
      view = SimpleView.new(:name => 'Kane') 
      view.markup
      view.output_proxies.size.should == 1
    end 
    
    it 'should render a really simple view' do 
      view = SimpleView.new(:name => 'Kane')
      view.render.should == ["<h1>Kane</h1>"]  
    end
    
    it 'should render via supering to the superclass' do  
      view = WordierView.new(:name => 'Kane', :job_title => 'Cog in Wheel')
      view.render.first.should == "<h1>Kane</h1>"
    end
    
    it 'should render in order' do 
      view = WordierView.new(:name => 'Kane', :job_title => 'Cog in Wheel')
      view.render[1].should == "<p class=\"clearfix\" id=\"jabber\"><span>I am just a</span><b>Cog in Wheel</b></p>"
    end      
        
  end   
end