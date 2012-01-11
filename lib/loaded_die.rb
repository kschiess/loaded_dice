# A loaded die that takes a probability map as constructor argument and will
# generate die rolls every time you call #roll. Die sides are numbered 0-n,
# where n is the size of the probability map. 
#
# Example: 
#   # A three sided die with probabilities 1/6, 2/6, 3/6
#   die = LoadedDie.new(1,2,3)
#   die.roll    # => one of {0, 1, 2}
#
# This is Voses Alias Method from an excellent description of the various
# algorithms by Keith Schwarz. It has a setup cost of O(n), a cost for each
# roll of O(1) and uses O(n) memory. I recommend reading "Darts, Dice and
# Coins: Sampling from a Discrete Distribution" by Keith Schwarz.
#
class LoadedDie
  # Returns the number of sides this die has. 
  attr_reader :sides
  # The original probability map. 
  attr_reader :probabilities
  attr_reader :normalized_probabilities
  
  # Sets up a die with the given probabilities. No need to have a probability
  # map that sums to 1, the code will normalize the numbers and provide you
  # with #normalized_probabilities. 
  #
  def initialize(*probabilities)
    init(*probabilities)
  end
  def init(*probabilities) # :nodoc: 
    @probabilities = probabilities
    @sides = probabilities.size
    
    @alias = Array.new(sides)
    @prob  = Array.new(sides)
    
    # The original algorithm calls for probabilities that sum to 1. 
    sum = probabilities.inject(0) { |a,e| a + e }

    # This is not needed for the algorithm, but is a nice thing to have.
    @normalized_probabilities = 
      probabilities.map { |e| e/Float(sum) }

    # This is what we'll work with.
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
  
  # Rolls the die once and returns a number in the range 0...sides. Numbers
  # will be distributed relative to the probabilities given in
  # #normalized_probabilities.
  #
  def roll
    # First roll a die with homogenous distribution: 
    n = rand(sides)
    # And now a biased coin with prob(head) == @prob[n]
    return n if rand() < @prob[n]
    return @alias[n]
  end
end