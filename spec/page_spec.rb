require File.dirname(__FILE__) + '/spec_helper'

describe Panorama::Page do
  before(:each) do
    MyLayout.clear_html_opts
  end  
  
  class MyLayout < Panorama::Page 
    def head
    end  
  end   
  
  describe 'special tags' do
    describe 'html declaration' do
      describe 'default' do 
        it 'should build an xml opening tag by default' do 
          MyLayout.render.should match /\A<\?xml encoding=\"utf-8\" version=\"1.0\" \?>/ 
        end
        
        it 'should build a xhtml transitional doctype tag by default' do
          MyLayout.render.should match /<!DOCTYPE.*XHTML 1.0 Transitional/
        end      
        
        it '#xml? should be true by default' do
          MyLayout.xml?.should == true
        end 
        
        it '#xml_options should be an empty hash by default' do
          MyLayout.xml_options.should == Gnash.new({})
        end
      end
      
      describe 'customization' do 
        it '#html should set xml encoding options' do 
          MyLayout.html :encoding => 'asci'
          MyLayout.xml_options.should == Gnash.new({:encoding => 'asci'})
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
        
        it '#html should pass options to xml_options even when a splatted array is passed in' do
          MyLayout.html :strict, :encoding => 'asci' 
          MyLayout.xml_options.should == Gnash.new({:encoding => 'asci'}) 
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
    end  
    
    describe 'special head tags' do 
      it 'page should by default have a head section' do   
        MyLayout.render.should match(/<head>\s*<\/head>/) 
      end  
      
      it 'should render head content into head tags' do 
        class MyLayout
          def head
            p do 
              "some content"
            end
          end
        end      
        output = MyLayout.render 
        output.should match /<head>\s*<p>\s*some content\s*<\/p>\s*<\/head>/ 
      end    
      
      it 'should have a #page_title tag proxy method that creates a title tag' do
        class MyLayout < Panorama::Page
          requires :description
          def head
            page_title "#{self.class.to_s} | #{self[:description]}"
          end
        end
        
        output = MyLayout.render(:description => 'partial description here!') 
        output.should include "MyLayout"
        output.should include "partial description here!"    
      end 
      
      
      it '#page_title should alias to #title' do
        class MyLayout < Panorama::Page
          requires :description
          def head
            title "#{self.class.to_s} | #{self[:description]}"
          end
        end
        
        output = MyLayout.render(:description => 'partial description here!') 
        output.should include "MyLayout"
        output.should include "partial description here!"
      end
        
      it '#title should not exist is View classes, just in Page classes' do 
        Panorama::View.new.should_not respond_to(:title)
      end
        
      it '#meta should take a hash with the first pair mapping key to "name" and value to "content"' do  
        class MyLayout < Panorama::Page 
          requires :description
          def head
            meta :description => self[:description]
          end
        end 
        output = MyLayout.render(:description => "fruitty goodness")
        output.should match(/<meta name=\"description\" content=\"fruitty goodness\"/)
      end
        
      it '#meta should not get smart about the first pair if it special' do 
        class MyLayout < Panorama::Page 
          requires :description
          def head
            meta :name => "description", :content => self[:description]
          end
        end                     
        output = MyLayout.render(:description => "fruitty goodness")
        output.should match(/<meta name=\"description\" content=\"fruitty goodness\"/)
        
        class MyLayout < Panorama::Page 
          requires :description
          def head
            meta :lang => 'fr', :name => "description", :content => self[:description]
          end
        end                     
        output = MyLayout.render(:description => "fruitty goodness")
        output.should match(/<meta name=\"description\"/)
        output.should match(/content=\"fruitty goodness\"/)  
      end
        
      it 'should have a #meta_description proxier' do  
        class MyLayout < Panorama::Page
          requires :description
          def head 
            meta_description self[:description]
          end
        end
        output = MyLayout.render(:description => 'fruitty goodness') 
        output.should match(/<meta name=\"description\" content=\"fruitty goodness\"/)  
      end
        
      it 'should have a #meta_author proxier' do
        class MyLayout < Panorama::Page
          requires # clear previous class requires statements
          def head 
            meta_author "Kane Baccigalupi"
          end
        end
        output = MyLayout.render 
        output.should match(/<meta name=\"author\" content=\"Kane Baccigalupi\"/)
      end
        
      it 'should have a #meta_keywords proxier' do 
        class MyLayout < Panorama::Page
          def head 
            meta_keywords "ruby views, erector, haml, erb"
          end
        end
        output = MyLayout.render 
        output.should match(/<meta name=\"keywords\" content=\"ruby views, erector, haml, erb\"/) 
      end
    end
    
    describe 'yielding and partials' do
    end        
  end  
   
end  