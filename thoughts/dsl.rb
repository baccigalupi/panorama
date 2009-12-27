# possible operators &   *   +   -   <<   <=>   ==   []   []   []=  |  
h1 "some text"
p * "my_class" | "my_id" {
  b "I love you!"
} 

def markup
  doctype :transitional
  html :version do
    head {
      page_title "It would be sweet if this worked"
      meta_description "my big description"
      # more meta stuff here
    } 
    body do 
      # class designated with an *
      * :header  {  
        # courtesy of haml's map benchmarking file
        h "Yes, ladies and gentileman. He is just that egotistical.
        Fantastic! This should be multi-line output
        The question is if this would translate! Ahah!"
        h 1 + 9 + 8 + 2 
      }
    
      # id is designated with an !, A string can be appended to the argument list and get contained
      ! :body, "Quotes should be loved! Just like people!" 
    
      # loop it good!
      (1..3).each do |number|
        p "#{number}" + number == 3 ? 'times a lady' : 'ce!'
      end 
    
      # silent appendorama
      * :silent do 
        foo = String.new
        foo << "this"
        foo << " shouldn't"
        foo << " evaluate"
        h foo + " but now it should!"
      end 
    
      ul * :really_cool {
        ('a'..'f').each do |letter|
          li letter
        end  
      }
    
      * :footer { strong * shout "This is a really long ruby quote. It should be loved and wrapped because its more than 50 characters. This value may change in the future and this test may look stupid. \nSo, I'm just making it *really* long. God, I hope this works"}
    end
  end    
end                                                                                                                                                                                                                                                                        