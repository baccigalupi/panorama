require File.dirname(__FILE__) + '/../spec_helper'

describe "Tag Proxying"  do 
  before do 
    @view = Panorama::View.new
  end  

  describe 'html view methods' do
    it 'should return a proxy' do
      @view.p.class.should == Panorama::Proxy
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
    it 'should have a tag' do
      proxy = Panorama::Proxy.new(
        :type => 'em'
      )  
      proxy.tag.class.should == Panorama::EM 
    end

    it 'should add options to the tag' do
      proxy = Panorama::Proxy.new(
        :type => 'em',
        :class => [:one, :two],
        :id => :my_id
      )
      proxy.tag.classes.should include( :one, :two )
      proxy.tag.element_id.should == :my_id
    end
    
    it 'should add blocks to the tag' do
      proxy = Panorama::Proxy.new(:type => 'em') {"my text"}
      proxy.tag.content.class.should == Proc
      proxy.tag.content.call.should == "my text"
    end 
    
    it 'should receive a content string as the first argument' do 
      proxy = Panorama::Proxy.new('my text', :type => 'em')
      proxy.tag.content.should == 'my text'
    end
    
    it 'should delegate render to the tag' do 
      proxy = Panorama::Proxy.new('my text', :type => 'em')
      proxy.render.should == proxy.tag.render
    end       
    
    describe 'better dsl' do
      # ???
    end    
  end
end