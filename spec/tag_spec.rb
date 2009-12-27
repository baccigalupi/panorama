require File.dirname(__FILE__) + '/spec_helper'

describe Arch::Tag  do
  it 'should infer the type of tag from the class' do 
    Arch::Tag.type.should == :tag 
    Arch::Tag.new.type.should == :tag
    
    # oh, inheritance!
    class Hr < Arch::Tag; end
    Hr.type.should == :hr     
  end
  
  describe 'css classes' do 
    before(:each) do
      @tag = Arch::Tag.new
    end 
    
    it 'should * a class in' do 
      @tag * :my_class
      @tag.classes.should include(:my_class)
    end
    
    it 'should not add duplicate classes' do
      @tag * :my_class
      @tag * :my_class
      @tag.classes.size.should == 1
      @tag * 'my_class'
      @tag.classes.size.should == 1
    end
    
    it 'should take an array of classes' do 
      @tag * [:my_class, :my_other_class, 'my_class']
      @tag.classes.size.should == 2
      @tag.classes.should include( :my_class, :my_other_class )
    end 
    
    it 'should return self for chaining' do
      (@tag * :one).should == @tag 
      @tag * :two * :three
      @tag.classes.should include(:one, :two, :three)
    end 
    
    it 'should receive classes from options in inintialization' do 
      tag = Arch::Tag.new(:class => [:one, 'two'])
      tag.classes.should include(:one, :two)
    end    
  end
  
  describe 'element id' do
    before(:each) do
      @tag = Arch::Tag.new
    end 
    
    it 'should | an id into the tag ' do 
      @tag | :my_id
      @tag.element_id.should == :my_id
    end
    
    it 'should replace ids not add them to the list' do
      @tag | :my_id
      @tag.element_id.should == :my_id
      @tag | 'my_new_id'
      @tag.element_id.should == :my_new_id
    end
    
    it 'should return self for chaining' do
      (@tag | :one).should == @tag 
      (@tag | :two) * :three # parens necessary because of Ruby precedence in operators
      @tag.element_id.should == :two
      @tag.classes.should include :three
    end 
    
    it 'should receive id from options in inintialization' do 
      tag = Arch::Tag.new(:id => 'one')
      tag.element_id.should == :one
    end
    
    it 'should receive id with [] too' do 
      @tag[:my_id] * :my_class
      @tag.element_id.should == :my_id
      @tag.classes.should include(:my_class)
    end  
    
    it 'should raise a readable error if a non-string/symbol is sent to id' do 
      lambda{ @tag | [:my_id, :my_other_id] }.should raise_error( ArgumentError, "A tag can only have one element id. Please assign it with a string or symbol.")
    end     
  end
  
  describe 'attributes' do 
    before(:each) do
      @tag = Arch::Tag.new
    end 
    
    it 'should have attributes' do
      @tag.attributes.should == Gnash.new
    end
    
    it 'should contain class information' do 
      @tag * [:one, :two, :three]
      @tag.attributes[:class].should == "one two three"
    end 
    
    it 'should contain id information' do  
      @tag[:my_id]
      @tag.attributes[:id].should == 'my_id'
    end 
    
    it 'should concatenate other passed in arguments' do 
      tag = Arch::Tag.new(:this => 'that')
      tag.attributes[:this].should == 'that'
    end      
  end     
end