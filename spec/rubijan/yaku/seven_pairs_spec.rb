require 'spec_helper'

RSpec.describe Rubijan::Yaku::SevenPairs do
  describe '#name' do
    it 'return right name in japanese' do
      expect(Rubijan::Yaku::SevenPairs.name).to eq '七対子'
    end
  end

  describe '#check' do
    it 'with appropriate hand will return true' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 2}
      expect(Rubijan::Yaku::SevenPairs.check(hand)).to eq true
    end

    it 'with hand of not thirteen orphans will return false' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 1, 43 => 1}
      expect(Rubijan::Yaku::SevenPairs.check(hand)).to eq false
    end
  end

  describe '#shape' do
    it 'with appropriate hand will return one dimension array' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 2}
      expect = [11, 11, 19, 19, 21, 21, 29, 29, 31, 31, 39, 39, 41, 41]
      expect(Rubijan::Yaku::SevenPairs.shape(hand)).to eq expect
    end

    it 'with hand of not thirteen orphans will one dimension array' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 1, 43 => 1}
      expect = [11, 11, 19, 19, 21, 21, 29, 29, 31, 31, 39, 39, 41, 43]
      expect(Rubijan::Yaku::SevenPairs.shape(hand)).to eq expect
    end
  end
end
