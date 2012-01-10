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
  
  describe 'random bias, 6 sides' do
    let(:die) { described_class.new(*6.times.map { rand(10) }) }

    let(:experimental_distr) { throw_n(die, 100_000) }
    let(:theoretical_distr) { die.normalized_probabilities.
      map { |e| e * 100_000 }}
    
    def chi2_score(de, dt)
      de.zip(dt).inject(1) { |a, (o, e)|
        a * ((o - e)**2 / Float(e))
      }
    end
    
    describe 'chi-square test at a level of p=0.05' do
      it "should pass" do
        score = chi2_score(experimental_distr, theoretical_distr)
        unless score.nan?
          score.should < 11.071
        end
      end 
    end
  end
  describe 'slightly biased (1,1,10)' do
    let(:die) { described_class.new(1,1,8) }
    
    it "has the correct normalized probabilities" do
      die.normalized_probabilities.should == [0.1, 0.1, 0.8]
    end 
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