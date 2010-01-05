require File.dirname(__FILE__) + '/spec_helper'

describe Panorama::View do
  describe 'local variables' do 
    class NeedyView < Panorama::View
      requires :x, :y 
    end
    
    class SelectiveView < Panorama::View 
      requires_only :x, :y
    end   
    
    it 'the class should store a list of required local variables' do 
      NeedyView.required.should == ['x', 'y']
      SelectiveView.required.should == ['x', 'y'] 
    end  
    
    it 'should add to the required local of the subclass' do
      class ExtraNeedy < NeedyView  
        requires :z
      end 
      ExtraNeedy.required.should == ['x', 'y', 'z'] 
    end  
    
    it '#requires and #requires_only should allow the last argument to be a hash with default values' do 
      class LessNeedy < Panorama::View 
        requires :x => 'x', :y => 'y'
      end 
      lambda{ LessNeedy.new }.should_not raise_error
    end    
    
    describe 'initialization' do 
      it 'should make local variables accessible as a hash in @locals' do  
        view = Panorama::View.new(:this => 'that')
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
      
      it 'should initialize a pool object with #load' do
        opts = {:x => 'x', :y => 'y'}
        view = NeedyView.new(opts)
        view.recycle
        view = NeedyView.pool.get
        view.load( opts )
        view.locals.should == Gnash.new( opts )
      end      
    end
    
    it 'locals should be accessible via the [] accessor' do
      view = Panorama::View.new(:this => 'that')
      view['this'].should == 'that'
      view[:this].should == 'that'
    end 
  end  
  
  describe 'engine' do 
    it 'should default to Panorama default engine' do 
      Panorama.engine_type = :panorama
      Panorama::View.engine.should == Panorama.engine
      Panorama::View.instance_variable_set("@engine_type", nil)
      Panorama.engine_type = :haml      
      Panorama::View.engine.should == Panorama.engine
    end 
    
    it 'should be settable' do
      Panorama::View.engine_type = :erb
      Panorama::View.engine.should == Panorama::Engine::ERB
    end  
    
    it 'should inherit default from superclass' do  
      Panorama::View.engine_type = :haml 
      class Partial < Panorama::View
      end  
      Partial.engine.should == Panorama::Engine::Haml
    end    
  end
  
  describe 'rendering' do 
    before(:each) do  
      Panorama::View.instance_variable_set("@pool", nil) # clearing it out
    end
    
    it 'should create an instance' do 
      view = Panorama::View.new
      Panorama::View.should_receive(:new).and_return( view )
      Panorama::View.render
    end 
    
    it 'should recycle instances to the pool' do
      view = Panorama::View.new
      Panorama::View.should_receive(:new).and_return( view )
      view.should_receive(:recycle)
      Panorama::View.render
    end
    
    it 'should grab a recycled instance instead of creating a new one' do 
      view = Panorama::View.new
      Panorama::View.render 
      Panorama::View.should_not_receive(:new)
      pool = Panorama::Pool.new(20)
      Panorama::View.stub!(:pool).and_return( pool )
      pool.should_receive(:get).and_return( view)
      Panorama::View.render
    end 
    
    describe 'engine proxies' do
      class Hamler < Panorama::View
        engine_type :panorama 
        def haml_method
          'haml'
        end
        
        def markup
          h1 "heading and"
          haml "= haml_method" 
        end  
      end
      
      class Erber < Panorama::View 
        engine_type :panorama 
        def erb_method
          'erb'
        end
          
        def markup
          h1 "heading and"
          erb "<p><%= erb_method %></p>" 
        end
      end  
        
      [:haml, :erb].each do |method| 
        it "should have a proxy for ##{method}" do 
          view = Panorama::View.new
          view.should respond_to(method)
        end
        
        it 'should render via a proxy' do 
          klass = (method.to_s.camelize + 'er').constantize
          renderings = klass.render  
          renderings[1].should include method.to_s
        end  
      end  
    end  
  end
  
  describe 'pooling' do
    describe 'max pool size' do  
      it 'should have a default' do  
        Panorama::View.max_pool_size.should == 20
      end 
      
      it 'should be settable' do 
        Panorama::View.max_pool_size = 30
        Panorama::View.max_pool_size.should == 30
        Panorama::View.max_pool_size( 15 )
        Panorama::View.max_pool_size.should == 15
      end   
    end 
    
    describe 'clearing instances' do 
      it 'should clear important values' do 
        view = Panorama::View.new(:this => 'that')
        view[:this].should == 'that'
        view.clear
        view[:this].should == nil
      end 
      
      it 'should be called by #recycle' do
        view = Panorama::View.new
        view.should_receive(:clear)
        view.recycle
      end   
    end  
    
    describe 'pool' do
      before(:each) do  
        Panorama::View.instance_variable_set("@pool", nil) # clearing it out
      end
         
      it 'should be an empty by default' do
        Panorama::View.pool.empty?.should == true
      end 
      
      it 'should add instances when they are recycled' do 
        Panorama::View.pool.should be_empty
        Panorama::View.new.recycle
        Panorama::View.pool.size.should == 1
      end   
    end    
  end      
end
