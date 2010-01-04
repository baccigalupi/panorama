require File.dirname(__FILE__) + '/../spec_helper'

describe "ERB Views" do
  class Simple < Panorama::View
    engine_type :erb 
    requires :name
  
    def markup
      "<h1>Hello <%= self[:name] %></h1>"
    end
  end     

  class Titleous < Simple 
    requires :title
  
    def long_name
      "#{self[:name]}: #{self[:title]}"
    end
  
     def markup
      "
      #{super}
      <p>
        Your full designation is:
        <b><%= self.long_name %></b>
      </p>
      "
    end   
  end      


  describe Panorama::Engine::ERB do
    it 'should render an empty string' do
      Panorama::Engine::ERB.render("").should == ""
    end
  end 
  
  describe 'rendering' do
    describe 'simple' do 
      it 'should render methods' do 
        output = Simple.render(:name => 'Kane')  
        output.should match(/<h1>\s{0,5}Hello\s*Kane\s{0,5}<\/h1>/) 
      end  
    end  
    
    describe 'inheritance' do 
      it 'should render local variables' do
        output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
        output.should match(/<h1>\s{0,5}Hello\s*Kane\s{0,5}<\/h1>/) 
      end
  
    
      it 'should render inherited methods' do 
        output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
        output.should match(/Kane: Cog in Wheel/)
      end
    end  
  end 
     
end   