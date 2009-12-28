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
          "I am just a " + self[:job_title]
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
    
    it 'should add proxies to the output' do 
      view = SimpleView.new(:name => 'Kane')
      view.render                
      view.output.size.should == 1
    end 
    
    it 'should render all the proxies in order' do 
      view = SimpleView.new(:name => 'Kane')
      view.render.should == ["<h1>Kane</h1>"]
    end       
  end   
end