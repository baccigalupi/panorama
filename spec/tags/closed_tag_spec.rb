require File.dirname(__FILE__) + '/../spec_helper'

describe Arch::ClosedTag  do 
  describe 'rendering' do
    before(:each) do
      class HR < Arch::ClosedTag
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
end 