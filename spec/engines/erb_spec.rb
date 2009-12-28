require File.dirname(__FILE__) + '/../spec_helper'

describe "ERB Views" do
  describe Panorama::Engine::ERB do
    it 'should render an empty string' do
      Panorama::Engine::ERB.render("").should == ""
    end
  end 
  
  class Simple < Panorama::View
    engine_type :erb 
    requires :name 
    
    def markup
      "<h1>Hello <%= self[:name] %></h1>" 
    end
  end     
  
  class Titleous < Simple 
    requires :name, :title
    
    def long_name
      "#{self[:name]}: #{self[:title]}"
    end 
    
    def markup
      "
      #{super}
      <p>
        Your full designation is:
        <b><%= long_name %></b>
      </p>
      "
    end  
  end
  
  
  describe 'markup' do
    it 'should render local variables' do 
      output = Simple.render(:name => 'Kane')
      output.should include "<h1>Hello Kane</h1>"
    end
  
    it 'should render methods' do
      output = Titleous.render(:name => 'Kane', :title => 'Cog in Wheel')
      output.should include "<h1>Hello Kane</h1>"
    end 
  end 
     
end   