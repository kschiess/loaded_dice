class LoadedDie
  attr_reader :sides
  attr_reader :probabilities
  
  def initialize(*probabilities)
    @probabilities = probabilities
    @sides = probabilities.size
    
    init(*@probabilities)
  end
  
  def init(*probabilities)
    @alias = Array.new(sides)
    @prob  = Array.new(sides)
    
    # The original algorithm calls for probabilities that sum to 1. 
    sum = probabilities.inject(0) { |a,e| a + e }
    mul_probabilities = probabilities.map { |e| e*sides/Float(sum) }
    
    # Partition into worklists small and large
    small, large = mul_probabilities.
      # generate tuples <p(i), i>
      zip((0..sides).to_a).
      # partition into small and large
      partition { |p,i| p < 1 }

    until large.empty? || small.empty?      
      pl, l = small.pop
      pg, g = large.pop
      
      @prob[l] = pl
      @alias[l] = g
      
      pg = (pg + pl) - 1
      tuple = [pg, g]
      (pg < 1 ? small : large).
        push tuple
    end
    
    # large will mostly not be empty at this point. Small can be non-empty due
    # to floating point numerical instability.
    [large, small].each do |list|
      until list.empty? 
        pg, g = list.pop
        @prob[g] = 1
      end
    end
  end
  
  def roll
    # First roll a die with homogenous distribution: 
    n = rand(sides)
    # And now a biased coin with prob(head) == @prob[n]
    return n if rand() < @prob[n]
    return @alias[n]
  end
end