require 'spec_helper'

RSpec.describe Rubijan::Yaku::NineGates do
  describe '#name' do
    it 'return right name in japanese' do
      expect(Rubijan::Yaku::NineGates.name).to eq '九連宝灯'
    end
  end

  describe '#check' do
    it 'with appropriate hand will return true' do
      hand = {11 => 4, 12 => 1, 13 => 1, 14 => 1, 15 => 1, 16 => 1,
              17 => 1, 18 => 1, 19 => 3}
      expect(Rubijan::Yaku::NineGates.check(hand)).to eq true
    end

    it 'with hand of not nine gates will return false' do
      hand = {11 => 4, 12 => 2, 13 => 1, 14 => 1, 15 => 1, 16 => 1,
              17 => 1, 18 => 1, 19 => 3}
      expect(Rubijan::Yaku::NineGates.check(hand)).to eq false
    end
  end
end
