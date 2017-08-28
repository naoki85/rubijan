require 'spec_helper'

RSpec.describe Rubijan::Yaku::MixedOutside do
  describe '#name' do
    it 'return right name in japanese' do
      expect(Rubijan::Yaku::AllSimples.name).to eq 'チャンタ'
    end
  end

  describe '#check' do
    it 'with appropriate hand will return true' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 2}
      expect(Rubijan::Yaku::AllSimples.check(hand)).to eq true
    end

    it 'with hand of not thirteen orphans will return false' do
      hand = {11 => 2, 19 => 2, 21 => 2, 29 => 2, 31 => 2, 39 => 2, 41 => 1, 43 => 1}
      expect(Rubijan::Yaku::AllSimples.check(hand)).to eq false
    end
  end
end
