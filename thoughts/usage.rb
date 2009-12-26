# pages are really about class level stuff ??
class MyLayout < Page
  # setup
  version :xml # etc 
  
  # head stuff 
  stylesheets "string path", "string path 2"
  scripts     "string path 3", "string path 3"
  meta_description "my static web page description" 
   
  # body - erector style
  def markup
    body :class => "my_layout" do
      div :class => 'main' do
        h "I am some escaped text!"
        render # or render [:markup] where [] accesses the passed in istance arguments
      end
    end  
  end 
  
  # haml style
  # def markup(:haml) 
  #   '%body.my_layout
  #     .main "I am some escaped text!"
  #     = render 
  #   '  
  # end   
end 

class MyAction < Partial
  def markup
    div.my_class.my_other_class.my_id! do 
      h 'my great content'
    end
  end  
end   

inner_markup = MyAction.new(:vars => 'here')           
MyLayout.render( 
  :markup => inner_markup, 
  :more => 'more'
)

 


