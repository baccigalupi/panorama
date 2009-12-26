require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Arch do 
  describe 'default engine' do
    it 'should be of type :arch' do
      Arch.engine_type.should == :arch
      Arch.engine.should == Arch::Engine::Default
    end 
  
    it 'should be changable to known types' do  
      Arch.engine_type = :haml
      Arch.engine_type.should == :haml
      Arch.engine.should == Arch::Engine::Haml
      Arch.engine_type( :erb )
      Arch.engine_type.should == :erb
      Arch.engine.should == Arch::Engine::ERB 
    end
  
    it 'should raise an error when assigning to unknown engine' do 
      lambda { Arch.engine_type = :goofy }.should raise_error(ArgumentError, "Rendering engine :#{:goofy} unknown")
    end 
  end   
end        