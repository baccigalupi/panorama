class SimpleTag < Panorama::View
  def markup
    p "simple tag"
  end
end 

class DoubleDown < Panorama::View  
  def markup
    p "simple tag"
    p "simple tag too"
  end  
end     

class BlockWithString < Panorama::View
  def markup
    p {
      "block with string"
    } 
  end  
end 

class BlockWithTag < Panorama::View 
  def markup
    p {
      b "block with tag"
    }
  end  
end

class NestedBlock < Panorama::View 
  def markup
    p do
      a :href => 'http://rubyghetto.com' do
        h1 "Ruby Ghetto"
        img :src => 'http://rubyghetto.com/images/ruby_ghetto.gif'
      end
    end
  end  
end  

class TagWithVariable < Panorama::View 
  requires :name
  def markup
    h1 self[:name] 
  end
  
  def super_special
    "everyone is so special"
  end    
end

class SuperingIt < TagWithVariable 
  def markup
    super
    p "super" 
  end  
end

class Inheritance < TagWithVariable
  requires :occupation, :special_name => true, :super_special => true 
  
  def special_naming
    "#{self[:name]} is special"
  end
  
  def markup
    super 
    p do 
      b self[:occupation]
      em special_naming if special_name 
      em super_special if super_special
    end  
  end
end 

class Yielding < Panorama::View 
  def markup
    p do 
      yield self if block_given?
    end  
  end  
end 

class LightlyYield < Panorama::View
  def markup
    p do
      yield if block_given?
    end
  end
end                