require File.dirname(__FILE__) + '/../spec_helper'

describe "Tag Proxying"  do 
  before do 
    @view = Panorama::View.new
  end
  
  describe 'superclass' do 
    it 'should take initialize an opts hash' do
      proxy = Panorama::Proxy.new(:content => 'my content', :type => 'em', :view => @view) 
      proxy.content.should == 'my content'
    end  
  end    

  describe 'html view methods' do
    it 'should return a proxy' do
      @view.p.class.should == Panorama::TagProxy
    end
    
    it 'should build a tag' do  
      @view.p.tag.class.should == Panorama::P
    end  
    
    it 'should pass info down to the tag' do 
      proxy = @view.p('my text', :id => 'my_id', :class => [:one, :two])
      proxy.tag.content.should == 'my text'
      proxy.tag.element_id.should == :my_id
      proxy.tag.classes.should == [:one, :two]
    end
    
    it 'should pass down a block to the tag' do 
      proxy = @view.p do
        "my other text"
      end
      proxy.tag.content.class.should == Proc
      proxy.tag.content.call.should == "my other text"  
    end    
  end  
  
  describe 'Proxy' do 
     describe 'initialization' do
      it 'insists on a valid tag type' do
        lambda{ Panorama::TagProxy.new(:contet => 'my text', :view => @view)}.should raise_error(
          ArgumentError, "Valid tag type required to generate a tag proxy. '' is not a valid tag type."
        )
      end
      
      it 'insists on proxy_buffer object' do
        lambda{ Panorama::TagProxy.new(:content => 'my text', :type => 'em')}.should raise_error(
          ArgumentError, "View with proxy_buffer required."
        )
      end      
    end
    
    it 'should have a tag' do
      proxy = Panorama::TagProxy.new(
        :type => 'em',
        :view => @view
      )  
      proxy.tag.class.should == Panorama::EM 
    end

    it 'should add options to the tag' do
      proxy = Panorama::TagProxy.new(
        :type => 'em',
        :class => [:one, :two],
        :id => :my_id,
        :view => @view 
      )
      proxy.tag.classes.should include( :one, :two )
      proxy.tag.element_id.should == :my_id
    end
    
    it 'should add blocks to the tag' do
      proxy = Panorama::TagProxy.new(:type => 'em', :view => @view ) {"my text"}
      proxy.tag.content.class.should == Proc
      proxy.tag.content.call.should == "my text"
    end 
    
    it 'should receive a content string as the first argument' do 
      proxy = Panorama::TagProxy.new(:content => 'my text', :type => 'em', :view => @view )
      proxy.tag.content.should == 'my text'
    end
    
    describe 'rendering' do
      it 'should delegate render to the tag' do 
        proxy = Panorama::TagProxy.new(:content => 'my text', :type => 'em', :view => @view)
        proxy.render.should == [proxy.tag.render]
      end 
    end   
    
    describe 'better dsl' do
      # ???
    end    
  end
end