require File.dirname(__FILE__) + '/spec_helper'

describe Arch::View do
  describe 'engine' do 
    it 'should default to Arch default engine' do 
      Arch.engine_type = :arch
      Arch::View.engine.should == Arch.engine
      Arch::View.instance_variable_set("@engine_type", nil)
      Arch.engine_type = :haml      
      Arch::View.engine.should == Arch.engine
    end 
    
    it 'should be settable' do
      Arch::View.engine_type = :erb
      Arch::View.engine.should == Arch::Engine::ERB
    end  
    
    it 'should inherit default from superclass' do  
      Arch::View.engine_type = :haml 
      class Partial < Arch::View
      end  
      Partial.engine.should == Arch::Engine::Haml
    end    
  end  
end
