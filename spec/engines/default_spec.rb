require File.dirname(__FILE__) + '/../spec_helper' 
require File.dirname(__FILE__) + '/../templates/collection'

describe "Default Views" do
  before(:each) do  
    @view = Panorama::View.new
  end
  
  describe 'tag methods' do 
    ([
      'a', 'abbr', 'acronym', 'address', 
      'b', 'bdo', 'big', 'blockquote', 'button', 
      'caption', 'center', 'cite', 'code', 'colgroup',
      'dd', 'del', 'dfn', 'div', 'dl', 'dt', 'em',
      'embed', 'fieldset', 'form', 'frameset',
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'i',
      'iframe', 'ins', 'kbd', 'label', 'legend', 'li', 'map',
      'noframes', 'noscript', 
      'object', 'ol', 'optgroup', 'option', 'p', 'param', 'pre',
      'q', 's', 'samp', 'select', 'small', 'span', 'strike',
      'strong', 'style', 'sub', 'sup',
      'table', 'tbody', 'td', 'textarea', 'tfoot', 
      'th', 'thead', 'tr', 'tt', 'u', 'ul', 'var'
    ] + ['area', 'base', 'br', 'col', 'frame', 'hr', 'img', 'input', 'link'] +
        ['comment', 'raw_text', 'text', 'h'] ).each do |method|
      
      it "should have a method ##{method}" do
        @view.should respond_to(method)
      end 
    end
  end
  
  describe 'proxy buffering' do
    it 'view should pass the proxy buffer into the proxy' do 
      view = SimpleTag.new
      view.markup
       
      proxy = view.proxy_buffer.first
      proxy.proxy_buffer.should === view.proxy_buffer
    end  
    
    it 'should pass the proxy buffer down to the tag' do
      view = SimpleTag.new
      view.markup
      
      proxy = view.proxy_buffer.first   
      proxy.proxy_buffer.should == view.proxy_buffer
      proxy.tag.proxy_buffer.should === view.proxy_buffer
    end  
    
    it '#markup should add first level proxies to the proxy buffer' do 
      view = SimpleTag.new  
      view.markup
      view.proxy_buffer.size.should == 1
      
      view2 = DoubleDown.new
      view2.markup
      view2.proxy_buffer.size.should == 2
    end
      
    it 'first level proxies with nested content should add the next level to the proxy buffer' do
      view = BlockWithTag.new
      view.markup 
      # this mocks the render process: 
      # 1) dumping the proxy buffer
      # 2) then for each (or in this case the first proxy) the block is called
      
      # 1)
      proxy = view.proxy_buffer.first
      view.proxy_buffer.clear  
      view.proxy_buffer.size.should == 0
      # 2)
      proxy.tag.content.call
      
      # Expectation:
      view.proxy_buffer.size.should == 1
    end
    
    it 'nested proxies should also add their block proxies into the buffer' do 
      view = NestedBlock.new
      view.markup
      
      # p
      first_layer = view.proxy_buffer.dump 
      first_layer.size.should == 1
      
      first_layer_proxy = first_layer.first 
      first_layer_proxy.tag.content.call 
      
      #a 
      second_layer = view.proxy_buffer.dump 
      second_layer.size.should == 1
      
      # the rest
      second_layer.first.tag.content.call
      third_layer = view.proxy_buffer.dump
      third_layer.size.should == 2
    end  
  end  
  
  describe 'rendering' do 
    it 'should render first level tag proxies' do 
      SimpleTag.render.should match(/<p>\s*simple tag\s*<\/p>/)
    end 
    
    it 'should render first level tag proxies with blocks' do 
      BlockWithString.render.should match(/<p>\s*block with string\s*<\/p>/)
    end
    
    it 'should render a second level nested proxy' do
      BlockWithTag.render.should match(/<p>\s*<b>\s*block with tag\s*<\/b>\s*<\/p>/)
    end     
        
    it 'should render nested proxies' do 
      NestedBlock.render.should match(
        /<p>\s*<a href="http:\/\/rubyghetto.com"\>\s*<h1>\s*Ruby Ghetto\s*<\/h1>\s*<img src="http:\/\/rubyghetto.com\/images\/ruby_ghetto.gif" \/>\s*<\/a>\s*<\/p>/
      )
    end
    
    describe 'special tags' do 
      it '#comment should comment out blocks of html markup' do 
        class SpecialTaggifying < Panorama::View 
          def markup
            comment do 
              p "not gonna show this"
            end
          end   
        end
        output = SpecialTaggifying.render
        output.should match(/<!--\s*<p>\s*not gonna show this\s*<\/p>\s*-->/)  
      end
      
      it 'tag contents that are strings should be escaped by default' do 
        class SpecialTaggifying < Panorama::View 
          def markup
            p "got some <script>illegalling()</script> to do??"
          end   
        end
        output = SpecialTaggifying.render
        output.should include('got some &lt;script&gt;illegalling()&lt;/script&gt; to do??')
      end  
    
      it 'should add escaped text via #h' do  
        class SpecialTaggifying < Panorama::View 
          def markup
            h "got some <script>illegalling()</script> to do??"
          end   
        end
        output = SpecialTaggifying.render
        output.should include('got some &lt;script&gt;illegalling()&lt;/script&gt; to do??')
      end
        
      it 'should add escaped text via #text' do  
        class SpecialTaggifying < Panorama::View 
          def markup
            text "got some <script>illegalling()</script> to do??"
          end   
        end
        output = SpecialTaggifying.render
        output.should include('got some &lt;script&gt;illegalling()&lt;/script&gt; to do??')
      end
        
      it 'should add unescaped text via #raw_text' do
        class SpecialTaggifying < Panorama::View 
          def markup
            raw_text "got some <script>illegalling()</script> to do??"
          end   
        end
        output = SpecialTaggifying.render
        output.should include('got some <script>illegalling()</script> to do??')
      end  
    end        
  
    describe 'blocks' do 
      before(:each) do  
        @regex = /<p>\s*<a href="http:\/\/rubyghetto.com"\>\s*<h1>\s*Ruby Ghetto\s*<\/h1>\s*<img src="http:\/\/rubyghetto.com\/images\/ruby_ghetto.gif" \/>\s*<\/a>\s*<\/p>/
      end
        
      describe 'instance methods' do
        it '#render should accept a block with an argument' do 
          view = Yielding.new
          output = view.render do |html|
            html.a :href => 'http://rubyghetto.com' do
              html.h1 "Ruby Ghetto"
              html.img :src => 'http://rubyghetto.com/images/ruby_ghetto.gif'
            end   
          end 
          output = output.join('')
          output.should match( @regex ) 
        end
      
        it '#render should accept a block with an argument' do
          view = Yielding.new
          output = view.renders do |html|
            html.a :href => 'http://rubyghetto.com' do
              html.h1 "Ruby Ghetto"
              html.img :src => 'http://rubyghetto.com/images/ruby_ghetto.gif'
            end   
          end 
          output.should match( @regex ) 
        end 
      end
      
      describe 'class #render' do
        it 'should accept a block with an argument' do 
          output = Yielding.render do |html|
            html.a :href => 'http://rubyghetto.com' do
              html.h1 "Ruby Ghetto"
              html.img :src => 'http://rubyghetto.com/images/ruby_ghetto.gif'
            end   
          end 
          output.should match( @regex ) 
        end  
      end       
    end  
  end 

  describe '#partial' do 
    it 'should create a parial proxy for the view' do   
      class Partialed < Panorama::View 
        def markup
          partial( SimpleTag.new )
        end    
      end 
      view = Partialed.new 
      view.markup 
      view.proxy_buffer.size.should == 1
      view.proxy_buffer.first.class.should == Panorama::PartialProxy
    end  
    
    it 'render an instance inline' do 
      class Partialed < Panorama::View 
        def markup
          p{ partial( SimpleTag.new ) }
        end    
      end 
      output = Partialed.render
      output.should match(/<p>\s*<p>\s*simple tag\s*<\/p>\s*<\/p>/) 
    end 
    
    it 'should indent properly' do 
      class Partialed < Panorama::View 
        def markup
          p{ partial( SimpleTag.new ) }
        end    
      end 
      output = Partialed.render
      output.should match(/<p>\n  <p>\n    simple tag\n  <\/p>\n<\/p>/)
    end 
    
    it 'can work with instance derived from a variable' do 
      class Partialed < Panorama::View
        requires :template
        def markup
          p{ partial( self[:template] ) }
        end
      end    
      output = Partialed.render(:template => SimpleTag.new)
      output.should match(/<p>\s*<p>\s*simple tag\s*<\/p>\s*<\/p>/)  
    end
    
    it 'should pass arguments from the parent view down to the partial view' do 
      class Piece < Panorama::View
        requires :current_user
        def markup
          h self[:current_user]
        end 
      end   
      class Partialed < Panorama::View
        requires :current_user => 'Kane'
        def markup
          p{ partial( Piece.new ) }
        end
      end 
      view = Partialed.new
      view.renders.should include "Kane"
    end 
    
    describe 'external engines' do 
      it 'should render :erb partials when passed engine information and a file' do
        class Partialed < Panorama::View
          requires :pastie
          def markup
            p{ partial(:erb, File.new(File.dirname(__FILE__) + "/../templates/erb.html.erb"))}
          end
        end
        output = Partialed.render(:pastie => 'eat my local')
        output.should include("From the land of ERB")
        output.should include("eat my local")    
      end
      
      it 'should render :haml partials when passed engine information and a file' do
        class Partialed < Panorama::View
          requires :pastie
          def markup
            p{ partial(:haml, File.new(File.dirname(__FILE__) + "/../templates/haml.html.haml"))}
          end
        end
        output = Partialed.render(:pastie => 'eat my local')
        output.should include("From the land of Haml")
        output.should include("eat my local")    
      end
      
      it 'should render engine partial when passed a string representing the path from the view directory'  
    end     
  end    

  describe 'indentation' do
    describe 'levels' do
      before do 
        @str =  Panorama.indentation_string 
      end
        
      it 'should not indent first level tags' do 
        SimpleTag.render.should match(/^<p>\s*simple tag\s*<\/p>\s*$/)
      end
      
      it 'should indent second level tags' do 
        BlockWithTag.render.should match(
          /\A<p>\n?#{@str}<b>\n?#{@str*2}block with tag\n?#{@str}<\/b>\n?<\/p>\n?\z/
        ) 
      end
      
      it 'should indent nested tags to an appropriate level' do 
        NestedBlock.render.should match(
          /\A<p>\n*#{@str}<a href="http:\/\/rubyghetto.com"\>\n*#{@str*2}<h1>\n*#{@str*3}Ruby Ghetto\n*#{@str*2}<\/h1>\n*#{@str*2}<img src="http:\/\/rubyghetto.com\/images\/ruby_ghetto.gif" \/>\n*#{@str}<\/a>\n*<\/p>\s*\z/
        ) 
      end
    end  
    
    describe 'line breaks' do    
      it 'should add a new line after each tag and around content' do
        SimpleTag.render.should match(/^<p>\n\s*simple tag\s*\n<\/p>\n$/) 
        BlockWithTag.render.should match(/\A<p>\n\s*<b>\n\s*block with tag\n\s*<\/b>\n<\/p>\n\z/)
      end   
    end  
  end    
end