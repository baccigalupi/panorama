require File.dirname(__FILE__) + '/spec_helper'

describe Panorama::Page do
  before(:each) do
    MyLayout.clear_html_opts
  end  
  
  class MyLayout < Panorama::Page
  end   
  
  describe 'special tags' do
    # 'head', 'html', 'title', 'link', 'body' 
    
    describe 'html declaration' do
      describe 'default' do 
        it 'should build an xml opening tag by default' do 
          MyLayout.render.first.should match /<\?xml encoding=\"utf-8\" version=\"1.0\" \?>/
        end
        
        it 'should build a xhtml transitional doctype tag by default' do
          MyLayout.render[1].should match /<!DOCTYPE.*XHTML 1.0 Transitional/
        end      
      end
      
      describe 'customization' do 
        it 'should render custom xml options' do
          MyLayout.html :strict, :encoding => 'asci'
          MyLayout.render.first.should match /<\?xml encoding=\"asci\" version=\"1.0\" \?>/ 
        end  
      end  
    end  
      
    describe 'class level xml and doctype opts' do
      it '#xml? should be true by default' do
        MyLayout.xml?.should == true
      end
      
      it '#xml_options should be an empty hash by default' do
        MyLayout.xml_options.should == Gnash.new({})
      end
      
      it '#html should set xml encoding options' do 
        MyLayout.html :encoding => 'fr'
        MyLayout.xml_options.should == Gnash.new({:encoding => 'fr'})
      end
      
      it '#html should set xml version options' do 
        MyLayout.html :version => 1.1
        MyLayout.xml_options.should == Gnash.new({:version => 1.1})
      end
      
      it '#html should not pass version or encoding down to doctype options' do 
        MyLayout.html :version => '1.1', :encoding => 'fr'
        MyLayout.xml_options.should == Gnash.new({:version => '1.1', :encoding => 'fr'}) 
        MyLayout.doctype_options.should == [Gnash.new({})]
      end
      
      it '#xml? should be true if the first argument received by #html is a string or symbol' do 
        MyLayout.html :strict
        MyLayout.xml?.should == true
        MyLayout.html 'transitional'
        MyLayout.xml?.should == true
      end 
      
      it '#xml? should be false if :html is a key in the hash' do 
        MyLayout.html :html => :transitional
        MyLayout.xml?.should == false
      end 
      
      it '#xml? should be true when :xhtml is a key in the hash' do
        MyLayout.html :xhtml => :strict
        MyLayout.xml?.should == true
      end 
      
      it '#html should pass hash options down into the doctype options' do 
        MyLayout.html :html => :transitional
        MyLayout.doctype_options.first[:html].should == :transitional
      end
      
      it '#html should pass string/symbol arguments down to the doctype options' do
        MyLayout.html :strict
        MyLayout.doctype_options.should == [:strict, Gnash.new]
      end             
    end  
    
    describe 'head' do
      it 'should create an tag proxy'
    end
    
    describe 'title' do 
      it 'should have a page_title'
      it 'should be aliased to #title'
    end  
    
    describe 'meta tags' do 
      it '#meta_description should make a meta description tag'
      it '#meta_author should make a meta author tag'
      it '#meta_keywords should make a meta keyword tag'
      describe '#meta' do
        it 'should take a hash with one pair mapping the key to name and the value to content'
        it 'takes additional keys :lang and :dir' 
      end
      it '#meta_equiv should make a meta http-equiv tag'
    end       
  end  
   
end  