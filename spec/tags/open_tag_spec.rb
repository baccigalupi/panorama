require File.dirname(__FILE__) + '/../spec_helper'

describe Panorama::OpenTag  do
  describe 'rendering' do
    class A < Panorama::OpenTag; end   
      
    before(:each) do
      @tag = A.new
    end  
    
    it 'should include opening and closing tags' do 
      @tag.render.should == "<a></a>"
    end
    
    describe 'attributes' do
      it 'should include classes' do
        @tag * [:red, :shadowed]
        @tag.render.should == "<a class=\"red shadowed\"></a>"
      end
    
      it 'should include the id' do
        @tag[:my_id] 
        @tag.render.should == "<a id=\"my_id\"></a>"
      end 
      
      it 'should include other data attributes' do   
        A.new(:data => 'do this').render.should == "<a data=\"do this\"></a>"
      end 
    end
    
    describe 'content' do
      describe 'string' do 
        it 'should content should be rendered if a block is not given' do
          @tag.content = "my cool link"
          @tag.render.should == '<a>my cool link</a>' 
        end  
      end
      
      describe 'blocks' do
        it 'render can receive a block and will insert it into the tag body' do
          @tag.render {'my cool link'}.should == '<a>my cool link</a>'
        end 
        
        it 'initialize can receive a block and will render it into the tag body' do 
          tag = A.new(:href => 'http://rubyghetto.com') do 
            'my crappy blog'
          end
          tag.render.should == "<a href=\"http://rubyghetto.com\">my crappy blog</a>"  
        end 
      end 
    end
    
    it 'should have a constant that holds calculated class names for all tags' do
      Panorama::OpenTag::CLASS_NAMES.should include("A", "EM", "UL", "LI")   # just a random assortment
    end
    
    it 'should generate subclasses' do  
      lambda{ Panorama::EM.new }.should_not raise_error
    end
    
    it 'should inspect in a meaningful way' do 
      tag = A.new(:class => [:external]) 
      tag.content = 'my link'
      tag.inspect.should == "#<A <a class=\"external\">my link</a> >"
      
      tag_with_block = A.new(:href => 'http://rubyghetto.com') {'my crappy blog'}
      tag_with_block.inspect.should == "#<A <a href=\"http://rubyghetto.com\">{block}</a> >"
    end            
  end    
end