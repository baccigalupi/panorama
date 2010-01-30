require File.dirname(__FILE__) + '/../spec_helper'

describe Panorama::ClosedTag  do
  before(:all) do
    Panorama.instance_variable_set("@indentation_string", nil)
  end
   
  describe 'rendering' do
    before(:each) do
      class HR < Panorama::ClosedTag
      end   
      @tag = HR.new
    end  
    it 'should be self closing html' do 
      @tag.renders.should include "<hr />"
    end
    
    it 'should include classes' do
      @tag * [:red, :shadowed]
      @tag.renders.should include "<hr class=\"red shadowed\" />"
    end
    
    it 'should include the id' do
      @tag[:my_id] 
      @tag.renders.should include "<hr id=\"my_id\" />"
    end
    
    it 'should include other data attributes' do   
      HR.new(:this => 'that').renders.should include "<hr this=\"that\" />"
    end       
  
    describe 'indentation' do
      it 'should prepend no indentation if the indentation level is 0' do  
        @tag.renders.should match /\A<hr \/>/
      end  
      
      it 'should prepend an indentation for first level indents' do
        tag = HR.new(:indentation_level => 1)
        tag.renders.should match /\A  <hr \/>/ 
      end 
       
      it 'should prepend indentations for deeper levels' do  
        tag = HR.new(:indentation_level => 5)
        tag.renders.should match /\A          <hr \/>/
      end  
    end  
  end  
  
  it 'should have a constant that holds calculated class names for all tags' do
    Panorama::ClosedTag::CLASS_NAMES.should include("BR", "HR")   # just a random assortment
  end
  
  it 'should generate subclasses' do  
    lambda{ Panorama::BR.new }.should_not raise_error
  end
  
  describe 'special tags' do 
    it 'xml should default to version 1.0 utf' do
      tag = Panorama::XML.new.renders
      tag.should match /\A<\?xml [^\>\?]*\?>\n\z/
      tag.should include "version=\"1.0\""
      tag.should include "encoding=\"utf-8\""
    end
    
    describe 'doctype' do
      describe 'html' do
        Panorama::DOCTYPE::HTML_TYPES.each do |html_type, attrs| 
          it "should construct #{html_type}" do
            attrs.each do |attr|
              Panorama::DOCTYPE.new(:html => html_type).renders.should match(Regexp.new(attr)) 
            end  
          end  
        end  
      end  
      
      describe 'xhtml' do
        Panorama::DOCTYPE::XHTML_TYPES.each do |html_type, attrs|
          it "should construct #{html_type}" do 
            attrs.each do |attr|
              Panorama::DOCTYPE.new(html_type).renders.should match(Regexp.new(attr)) 
            end  
          end  
        end
      end   
           
    end    
  end    
end 