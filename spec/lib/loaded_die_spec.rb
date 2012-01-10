require 'spec_helper'

require 'loaded_die'

describe LoadedDie do
  def throw_n(die, n=100)
    count = Array.new(die.sides, 0)
    n.times do
      count[die.roll] += 1
    end
    count
  end
  
  describe 'slightly biased (1,1,10)' do
    let(:die) { described_class.new(1,1,10) }
    it "generates more 2s than other numbers" do
      throw_n(die)[2].should > throw_n(die)[1]
      throw_n(die)[2].should > throw_n(die)[0]
    end
    it "generates >0 0s" do
      throw_n(die)[0].should >= 0
    end
    it "generates >0 1s" do
      throw_n(die)[1].should >= 0
    end
  end
  describe 'severely biased (0,1,0)' do
    let(:die) { described_class.new(0,1,0) }
    it "generates a 1 roll every time" do
      100.times do
        die.roll.should == 1
      end
    end 
  end
end