require File.dirname(__FILE__) + '/spec_helper'

describe Panorama::Page do
  
  class MyLayout < Panorama::Page
  end   
  
  describe 'special tags' do
    # 'head', 'html', 'title', 'link', 'body'
    describe 'class level:' do
      describe 'html' do
        it 'should build an xml opening tag by default' do 
          pending
          MyLayout.render.first.should match /\A<\?xml version=\"1.0\" encoding=\"utf-8\" \?>/
        end
          
        it 'should build a xhtml transitional doctype tag by default'
        it 'should take an encoding option'
        describe ':xhtml' do 
          it 'should have the xml tag in the first line'
          {  
            :strict => ["-//W3C//DTD XHTML 1.0 Strict//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"], 
            :frameset => ["-//W3C//DTD XHTML 1.0 Frameset//EN", "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"],
            '1.1' => ["-//W3C//DTD XHTML 1.1//EN", "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"],
            :basic => ["-//W3C//DTD XHTML Basic 1.1//EN", "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd"],
            :mobile => ["-//WAPFORUM//DTD XHTML Mobile 1.2//EN", "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd"]
          }.each do |html_option, contents|
            it "#{html_option.inspect} should build a tag proxy for document type"
            it "#{html_option.inspect}'s proxy should render the content"
          end  
        end
        
        describe ':html4' do 
          {
            :transitional => ["-//W3C//DTD HTML 4.01 Transitional//EN", "http://www.w3.org/TR/html4/loose.dtd"],
            :strict => ["-//W3C//DTD HTML 4.01//EN", "http://www.w3.org/TR/html4/strict.dtd"],
            :frameset => ["-//W3C//DTD HTML 4.01 Frameset//EN", "http://www.w3.org/TR/html4/frameset.dtd"]
          }.each do |html_option, contents|
            it "#{html_option.inspect} should build a tag proxy for docmuent type"
            it "#{html_option.inspect}'s proxy should render the content"
          end  
        end
        
        it ':html5 should build a tag proxy for document type'
        it ':html5\'s proxy should render the content'     
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