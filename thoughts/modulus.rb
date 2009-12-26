class Modulus
  def %( arg )
    puts arg.inspect
  end 
  
  def self.%( arg ) 
    puts arg.inspect
  end  
end

m = Modulus.new 
m %'this'
m % 'this' 
Modulus % 'that'
Modulus.%'that'

# Proof that the % modulus operator can be overwritten! 


class Gnash < Hash
  def get(sym)
    [sym]
  end
end

gnash = Gnash.new(:one => 'one') 
puts gnash.get(:one) 
    
