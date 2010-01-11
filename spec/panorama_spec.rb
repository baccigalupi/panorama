require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Panorama do 
  describe 'default engine' do
    before(:each) do 
      Panorama.instance_variable_set("@engine_type", nil)
    end
      
    it 'should be of type :panorama' do
      Panorama.engine_type.should == :panorama
      Panorama.engine.should == Panorama::Engine::Default
    end 
  
    it 'should be changable to known types' do  
      Panorama.engine_type = :haml
      Panorama.engine_type.should == :haml
      Panorama.engine.should == Panorama::Engine::Haml
      Panorama.engine_type( :erb )
      Panorama.engine_type.should == :erb
      Panorama.engine.should == Panorama::Engine::ERB 
    end
  
    it 'should raise an error when assigning to unknown engine' do 
      lambda { Panorama.engine_type = :goofy }.should raise_error(ArgumentError, "Rendering engine :#{:goofy} unknown")
    end 
  end
  
  describe 'default indentation string' do 
    before(:each) do
      Panorama.instance_variable_set("@indentation_string", nil)
    end
    
    it 'should be 2 spaces by default' do
      Panorama.indentation_string.should == "  "
    end
      
    it 'should be customizable' do 
      Panorama.indentation_string( "\t" )
      Panorama.indentation_string.should == "\t"
    end    
  end     
end        