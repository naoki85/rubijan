require 'spec_helper'

RSpec.describe Rubijan::Yaku::ThirteenOrphans do
  describe '#name' do
    it 'return right name in japanese' do
      expect(Rubijan::Yaku::ThirteenOrphans.name).to eq '国士無双'
    end
  end

  describe '#check' do
    it 'with appropriate hand will return true' do
      hand = {11 => 2, 19 => 1, 21 => 1, 29 => 1, 31 => 1, 39 => 1,
              41 => 1, 42 => 1, 43 => 1, 44 => 1, 45 => 1, 46 => 1, 47 => 1}
      expect(Rubijan::Yaku::ThirteenOrphans.check(hand)).to eq true
    end

    it 'with hand of not thirteen orphans will return false' do
      hand = {11 => 3, 21 => 1, 29 => 1, 31 => 1, 39 => 1,
              41 => 1, 42 => 1, 43 => 1, 44 => 1, 45 => 1, 46 => 1, 47 => 1}
      expect(Rubijan::Yaku::ThirteenOrphans.check(hand)).to eq false
    end
  end

  describe '#shape' do
    it 'with appropriate hand will return one dimension array' do
      hand = {11 => 2, 19 => 1, 21 => 1, 29 => 1, 31 => 1, 39 => 1,
              41 => 1, 42 => 1, 43 => 1, 44 => 1, 45 => 1, 46 => 1, 47 => 1}
      expect = [11, 11, 19, 21, 29, 31, 39, 41, 42, 43, 44, 45, 46, 47]
      expect(Rubijan::Yaku::SevenPairs.shape(hand)).to eq expect
    end

    it 'with hand of not thirteen orphans will return one dimension array' do
      hand = {11 => 3, 21 => 1, 29 => 1, 31 => 1, 39 => 1,
              41 => 1, 42 => 1, 43 => 1, 44 => 1, 45 => 1, 46 => 1, 47 => 1}
      expect = [11, 11, 11, 21, 29, 31, 39, 41, 42, 43, 44, 45, 46, 47]
      expect(Rubijan::Yaku::SevenPairs.shape(hand)).to eq expect
    end
  end
end
