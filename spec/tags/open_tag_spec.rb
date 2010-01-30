require File.dirname(__FILE__) + '/../spec_helper'

describe Panorama::OpenTag  do
  before(:each) do
    Panorama.instance_variable_set("@indentation_string", nil)
  end
    
  describe 'rendering' do
    class A < Panorama::OpenTag; end   
      
    before(:each) do
      @tag = A.new
    end
    
    it 'should have a #renders method that renders to string' do 
      @tag.renders.class.should == String
    end    
    
    it 'should include opening and closing tags' do 
      @tag.renders.should match /<a>\s*<\/a>\s*/
    end
    
    describe 'attributes' do
      it 'should include classes' do
        @tag * [:red, :shadowed]
        @tag.renders.should match /<a class=\"red shadowed\">\s*<\/a>\s*/
      end
    
      it 'should include the id' do
        @tag[:my_id] 
        @tag.renders.should match /<a id=\"my_id\">\s*<\/a>\s*/
      end 
      
      it 'should include other data attributes' do   
        A.new(:data => 'do this').renders.should match /<a data=\"do this\">\s*<\/a>\s*/
      end 
    end
    
    describe 'content' do
      describe 'string' do 
        it 'should content should be rendered if a block is not given' do
          @tag.content = "my cool link"
          @tag.renders.should match /<a>\s*my cool link\s*<\/a>\s*/ 
        end  
      end
      
      describe 'blocks' do
        it 'render can receive a block and will insert it into the tag body' do
          @tag.renders{'my cool link'}.should match /<a>\s*my cool link\s*<\/a>/
        end 
        
        it 'initialize can receive a block and will render it into the tag body' do 
          tag = A.new(:href => 'http://rubyghetto.com') do 
            'my crappy blog'
          end
          tag.renders.should match /<a href=\"http:\/\/rubyghetto.com\">\s*my crappy blog\s*<\/a>/  
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
  
    describe 'indentation' do
      before(:all) do 
        Panorama.indentation_string("  ")
      end
         
      it 'should prepend no indentation if the indentation level is 0' do  
        @tag.renders.should match /\A<a>\s*<\/a>/
      end  
      
      it 'should prepend an indentation for first level indents' do
        tag = A.new(:indentation_level => 1)
        tag.renders.should match /\A  <a>\s*<\/a>/ 
      end 
       
      it 'should prepend indentations for deeper levels' do  
        tag = A.new(:indentation_level => 5)
        tag.renders.should match /\A          <a>\s*<\/a>/
      end
      
      it 'render should set and use the indentation level if recieved' do  
        @tag.renders(5).should match /\A          <a>\s*<\/a>/ 
        @tag.indentation_level.should == 5
      end 
      
      it 'should indent content' do  
        @tag.content = "my content"
        @tag.renders.should match(/\A<a>\n  my content\n<\/a>\n\z/)
      end
      
      it 'should properly indent self and content' do 
        @tag.content = "my content"
        @tag.renders(1).should match(/\A  <a>\n    my content\n  <\/a>/)
        @tag.clear_output
        @tag.renders(5).should match(/\A          <a>\n            my content\n          <\/a>/)
      end
      
      it 'should not indent empty content' do  
        @tag.renders.should match(/<a><\/a>/)
      end      
    end  
  end    
end