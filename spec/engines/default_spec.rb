require File.dirname(__FILE__) + '/../spec_helper' 
require File.dirname(__FILE__) + '/../templates/collection'

describe "Default Views" do
  before(:each) do  
    @view = Panorama::View.new
  end
  
  describe 'tag methods' do 
    ([
      'a', 'abbr', 'acronym', 'address', 
      'b', 'bdo', 'big', 'blockquote', 'button', 
      'caption', 'center', 'cite', 'code', 'colgroup',
      'dd', 'del', 'dfn', 'div', 'dl', 'dt', 'em',
      'embed', 'fieldset', 'form', 'frameset',
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'i',
      'iframe', 'ins', 'kbd', 'label', 'legend', 'li', 'map',
      'noframes', 'noscript', 
      'object', 'ol', 'optgroup', 'option', 'p', 'param', 'pre',
      'q', 's', 'samp', 'select', 'small', 'span', 'strike',
      'strong', 'style', 'sub', 'sup',
      'table', 'tbody', 'td', 'textarea', 'tfoot', 
      'th', 'thead', 'tr', 'tt', 'u', 'ul', 'var'
    ] + ['area', 'base', 'br', 'col', 'frame', 'hr', 'img', 'input', 'link', 'meta']).each do |method|
      
      it "should have a method ##{method}" do
        @view.should respond_to(method)
      end 
    end
  end
  
  describe 'proxy buffering' do
    it 'view should pass the proxy buffer into the proxy' do 
      view = SimpleTag.new
      view.markup
       
      proxy = view.proxy_buffer.first
      proxy.proxy_buffer.should === view.proxy_buffer
    end  
    
    it 'should pass the proxy buffer down to the tag' do
      view = SimpleTag.new
      view.markup
      
      proxy = view.proxy_buffer.first   
      proxy.proxy_buffer.should == view.proxy_buffer
      proxy.tag.proxy_buffer.should === view.proxy_buffer
    end  
    
    it '#markup should add first level proxies to the proxy buffer' do 
      view = SimpleTag.new  
      view.markup
      view.proxy_buffer.size.should == 1
      
      view2 = DoubleDown.new
      view2.markup
      view2.proxy_buffer.size.should == 2
    end
      
    it 'first level proxies with nested content should add the next level to the proxy buffer' do
      view = BlockWithTag.new
      view.markup 
      # this mocks the render process: 
      # 1) dumping the proxy buffer
      # 2) then for each (or in this case the first proxy) the block is called
      
      # 1)
      proxy = view.proxy_buffer.first
      view.proxy_buffer.clear  
      view.proxy_buffer.size.should == 0
      # 2)
      proxy.tag.content.call
      
      # Expectation:
      view.proxy_buffer.size.should == 1
    end
    
    it 'nested proxies should also add their block proxies into the buffer' do 
      view = NestedBlock.new
      view.markup
      
      # p
      first_layer = view.proxy_buffer.dump 
      first_layer.size.should == 1
      
      first_layer_proxy = first_layer.first 
      first_layer_proxy.tag.content.call 
      
      #a 
      second_layer = view.proxy_buffer.dump 
      second_layer.size.should == 1
      
      # the rest
      second_layer.first.tag.content.call
      third_layer = view.proxy_buffer.dump
      third_layer.size.should == 2
    end  
  end  
  
  describe 'rendering' do 
    it 'should render first level tag proxies' do 
      SimpleTag.render.should match(/<p>\s*simple tag\s*<\/p>/)
    end 
    
    it 'should render first level tag proxies with blocks' do 
      BlockWithString.render.should match(/<p>\s*block with string\s*<\/p>/)
    end
    
    it 'should render a second level nested proxy' do
      BlockWithTag.render.should match(/<p>\s*<b>\s*block with tag\s*<\/b>\s*<\/p>/)
    end     
        
    it 'should render nested proxies' do 
      NestedBlock.render.should match(
        /<p>\s*<a href="http:\/\/rubyghetto.com"\>\s*<h1>\s*Ruby Ghetto\s*<\/h1>\s*<img src="http:\/\/rubyghetto.com\/images\/ruby_ghetto.gif" \/>\s*<\/a>\s*<\/p>/
      )
    end      
  end 
  
  describe 'indentation' do
    describe 'levels' do
      before do 
        @str =  Panorama.indentation_string 
      end
        
      it 'should not indent first level tags' do 
        SimpleTag.render.should match(/^<p>\s*simple tag\s*<\/p>\s*$/)
      end
      
      it 'should indent second level tags' do 
        BlockWithTag.render.should match(
          /\A<p>\n?#{@str}<b>\n?#{@str*2}block with tag\n?#{@str}<\/b>\n?<\/p>\n?\z/
        ) 
      end
      
      it 'should indent nested tags to an appropriate level' do 
        NestedBlock.render.should match(
          /\A<p>\n*#{@str}<a href="http:\/\/rubyghetto.com"\>\n*#{@str*2}<h1>\n*#{@str*3}Ruby Ghetto\n*#{@str*2}<\/h1>\n*#{@str*2}<img src="http:\/\/rubyghetto.com\/images\/ruby_ghetto.gif" \/>\n*#{@str}<\/a>\n*<\/p>\s*\z/
        ) 
      end
    end  
    
    describe 'line breaks' do    
      it 'should add a new line after each tag and around content' do
        SimpleTag.render.should match(/^<p>\n\s*simple tag\s*\n<\/p>\n$/) 
        BlockWithTag.render.should match(/\A<p>\n\s*<b>\n\s*block with tag\n\s*<\/b>\n<\/p>\n\z/)
      end   
    end  
  end    
end