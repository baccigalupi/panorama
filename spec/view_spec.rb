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
        view.locals.should == Gnash.new(:this => 'that')
      end 
      
      it 'should raise an error if it does not get the variables it needs at render time' do
        lambda{ NeedyView.render(:x => 'x') }.should raise_error( 
          ArgumentError, 
          "NeedyView initialization requires additional variable(s): #{['y'].inspect}"
        )
        lambda{ SelectiveView.render(:x => 'x') }.should raise_error( 
          ArgumentError, 
          "SelectiveView initialization requires additional variable(s): #{['y'].inspect}" 
        )
      end  
      
      it 'should not raise an error at render time if it defined with #requires and then receives addition variables' do  
        NeedyView.render(:x => 'x', :y => 'y', :alhpa => 'omega')
      end
      
      it 'should raise an error at render time if defined with #requires_only and receives additional variables' do
        # this wasn't working the raise_error way 
        begin
          SelectiveView.render(:x => 'x', :y => 'y', :alhpa => 'omega') 
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
    
    it 'should include default values in locals' do
      class DefaultingView < Panorama::View   
        requires :template, :current_user => 'Kane'
      end
      DefaultingView.new(:template => true)[:current_user].should == 'Kane' 
    end 
    
    it 'should inherit default values from superclasses' do 
      class DefaultingView < Panorama::View 
        requires :current_user => 'Kane'
      end
      class SuperDefaulting < DefaultingView; end
      SuperDefaulting.new[:current_user].should == "Kane" 
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
    
    describe 'instance pooling' do
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
    end   
    
    describe 'markup method rendering' do
      class MyView < Panorama::View
        engine_type :panorama
        def markup
          p "go view"
        end
      end
      
      it 'class level #render should render to a string' do 
        rendered = MyView.render
        rendered.class.should == String
        rendered.should include('go view')
      end    
        
      it 'instance #renders should flatten render to string' do
        view = MyView.new
        view.renders.class.should == String
        view.renders.should include('go view')                   
      end    
    
      it 'should render #markup by default' do 
        class StandardMark < Panorama::View
          engine_type :panorama
          def markup
            p "standard fair"
          end
        end
        view = StandardMark.new 
        view.renders.should include('standard fair')    
      end
    
      it 'should render a custom markup methods' do
        class AltMark < Panorama::View 
          engine_type :panorama 
          def alt_markup
            p "I am alternative markup"
          end
        end  
        view = AltMark.new 
        view.renders(:method => :alt_markup).should include('alternative') 
      end 
      
      it 'should have a class method #renders that renders to string' do 
        view = MyView.new
        MyView.render.should == view.renders
      end 
      
      it 'should take an option indentatin level' do
        view = MyView.new
        output = view.renders(:method => :markup, :level => 2)
        output.should match(/    <p>\n      go view\n    <\/p>/) 
      end   
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
          renderings.should include method.to_s
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
