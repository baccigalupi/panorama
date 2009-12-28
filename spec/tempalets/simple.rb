class Simple < Panorama::View 
  def markup 
    h1 "some text"
    p * "my_class" | "my_id" {
      b "I love you!"
    }
  end  
end  