require 'spec_helper'

RSpec.describe Rubijan::Yaku do
  describe '#name' do
    it 'return right name in japanese' do
      expect(RubijanYaku::Tanyao.name).to eq 'タンヤオ'
    end
  end

  describe '#able_to_claim?' do
    it 'return true regardless of the param.' do
      expect(RubijanYaku::Tanyao.able_to_claim?).to eq true
    end
  end

  describe '#right_shape?' do
    it 'return true when correct pattern.' do
      hand = [12, 12, 12, 12, 13, 14, 15, 16, 17, 18, 17, 18, 18, 18]
      expect(RubijanYaku::Tanyao.right_shape?({:all_hand => hand})).to eq true
    end

    it 'return false when incorrect pattern.' do
      hand = [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19]
      expect(RubijanYaku::Tanyao.right_shape?({:all_hand => hand})).to eq false
    end
  end
end