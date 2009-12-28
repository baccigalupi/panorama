require File.dirname(__FILE__) + '/../spec_helper'

describe Panorama::ClosedTag  do 
  describe 'rendering' do
    before(:each) do
      class HR < Panorama::ClosedTag
      end   
      @tag = HR.new
    end  
    it 'should be self closing html' do 
      @tag.render.should == "<hr />"
    end
    
    it 'should include classes' do
      @tag * [:red, :shadowed]
      @tag.render.should == "<hr class=\"red shadowed\" />"
    end
    
    it 'should include the id' do
      @tag[:my_id] 
      @tag.render.should == "<hr id=\"my_id\" />"
    end
    
    it 'should include other data attributes' do   
      HR.new(:this => 'that').render.should == "<hr this=\"that\" />"
    end       
  end  
  
  it 'should have a constant that holds calculated class names for all tags' do
    Panorama::ClosedTag::CLASS_NAMES.should include("BR", "HR")   # just a random assortment
  end
  
  it 'should generate subclasses' do  
    lambda{ Panorama::BR.new }.should_not raise_error
  end  
end 