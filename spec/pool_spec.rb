require File.dirname(__FILE__) + '/spec_helper'

describe Panorama::Pool do
  it 'should require a max size' do  
    lambda{ Panorama::Pool.new }.should raise_error
    pool = Panorama::Pool.new(15)
    pool.max_size.should == 15  
    pool.size.should == 0
  end
  
  it 'should be pushable' do 
    pool = Panorama::Pool.new(5)
    pool.push("string") 
    pool.size.should == 1
  end
  
  it 'should not grow larger than the max size' do  
    pool = Panorama::Pool.new( 2 )
    pool.push(1)  
    pool.size.should == 1
    pool.push(2)
    pool.size.should == 2 
    pool.push(3)
    pool.size.should == 2
  end
  
  it 'should shift values from the top of the array' do
    pool = Panorama::Pool.new( 2 )
    pool.push(1)  
    pool.size.should == 1
    pool.push(2)
    pool.size.should == 2 
    pool.shift.should == 1
    pool.size.should == 1
  end
  
  it 'should have aliased methods #get and #put for convenience' do 
    pool = Panorama::Pool.new( 2 )
    pool.put(1)  
    pool.size.should == 1
    pool.put(2) 
    pool.get.should == 1
    pool.get.should == 2
    pool.size.should == 0
  end
  
  it 'should #inspect well' do
    pool = Panorama::Pool.new( 2 )
    pool.inspect.should == "<Panorama::Pool @max_size=2>"
  end            
end