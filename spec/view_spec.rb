require File.dirname(__FILE__) + '/spec_helper'

describe Arch::View do
  describe 'local variables' do 
    class NeedyView < Arch::View
      requires :x, :y 
    end
    
    class SelectiveView < Arch::View 
      requires_only :x, :y
    end   
    
    it 'the class should store a list of required local variables' do 
      NeedyView.required.should == ['x', 'y']
      SelectiveView.required.should == ['x', 'y'] 
    end
    
    it '#requires and #requires_only should allow the last argument to be a hash with default values' do 
      class LessNeedy < Arch::View 
        requires :x => 'x', :y => 'y'
      end 
      lambda{ LessNeedy.new }.should_not raise_error
    end    
    
    describe 'initialization' do 
      it 'should make local variables accessible as a hash in @locals' do  
        view = Arch::View.new(:this => 'that')
        view.instance_variable_get("@locals").should == Gnash.new(:this => 'that')
      end 
      
      it 'should raise an error if it does not get the variables it needs' do
        lambda{ NeedyView.new(:x => 'x') }.should raise_error( 
          ArgumentError, 
          "NeedyView initialization requires additional variable(s): #{['y'].inspect}"
        )
        lambda{ SelectiveView.new(:x => 'x') }.should raise_error( 
          ArgumentError, 
          "SelectiveView initialization requires additional variable(s): #{['y'].inspect}" 
        )
      end  
      
      it 'should not raise an error if it defined with #requires and then receives addition variables' do  
        NeedyView.new(:x => 'x', :y => 'y', :alhpa => 'omega')
      end
      
      it 'should raise an error if defined with #requires_only and receives additional variables' do
        # this wasn't working the raise_error way 
        begin
          SelectiveView.new(:x => 'x', :y => 'y', :alhpa => 'omega') 
          raise "No error was raised"
        rescue Exception => e
          e.class.should == ArgumentError 
          e.message.should match(/SelectiveView/)
          e.message.should match(/#{['x', 'y'].inspect}/) 
          e.message.should match(/#{['alpha'].inspect}/)
        end
      end    
    end
    
    it 'locals should be accessible via the [] accessor' do
      view = Arch::View.new(:this => 'that')
      view['this'].should == 'that'
      view[:this].should == 'that'
    end 
    
     
  end  
  
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
  
  describe 'rendering' do 
    before(:each) do  
      Arch::View.instance_variable_set("@pool", nil) # clearing it out
    end
    
    it 'should create an instance' do 
      view = Arch::View.new
      Arch::View.should_receive(:new).and_return( view )
      Arch::View.render
    end 
    
    it 'should recycle instances to the pool' do
      view = Arch::View.new
      Arch::View.should_receive(:new).and_return( view )
      view.should_receive(:recycle)
      Arch::View.render
    end
    
    it 'should grab a recycled instance instead of creating a new one' do 
      view = Arch::View.new
      Arch::View.render 
      Arch::View.should_not_receive(:new)
      pool = Arch::Pool.new(20)
      Arch::View.stub!(:pool).and_return( pool )
      pool.should_receive(:get).and_return( view)
      Arch::View.render
    end     
  end
  
  describe 'pooling' do
    describe 'max pool size' do  
      it 'should have a default' do  
        Arch::View.max_pool_size.should == 20
      end 
      
      it 'should be settable' do 
        Arch::View.max_pool_size = 30
        Arch::View.max_pool_size.should == 30
        Arch::View.max_pool_size( 15 )
        Arch::View.max_pool_size.should == 15
      end   
    end 
    
    describe 'clearing instances' do 
      it 'should clear important values' do 
        pending( 'there aren\'t yet important values')
      end 
      
      it 'should be called by #recycle' do
        view = Arch::View.new
        view.should_receive(:clear)
        view.recycle
      end   
    end  
    
    describe 'pool' do
      before(:each) do  
        Arch::View.instance_variable_set("@pool", nil) # clearing it out
      end
         
      it 'should be an empty by default' do
        Arch::View.pool.empty?.should == true
      end 
      
      it 'should add instances when they are recycled' do 
        Arch::View.pool.should be_empty
        Arch::View.new.recycle
        Arch::View.pool.size.should == 1
      end   
    end    
  end      
end
