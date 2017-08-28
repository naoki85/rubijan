require 'spec_helper'

RSpec.describe Rubijan do
  describe '#initialize' do
    it 'with invalid hand will occur a error' do
      inappropriate_hands = [
        # Array
        [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19],
        # The number of factor is over 14.
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19, 19],
         claimed: []},
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18],
         claimed: [[19, 19, 19], [19, 19]]},
        # Hand has some inappropriate number.
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19, 20],
         claimed: []}
      ]

      inappropriate_hands.each do |inappropriate_hand|
        expect {
          Rubijan.decision_yaku(inappropriate_hand)
        }.to raise_error 'Rubijan::InvalidInputError'
      end
    end

    it 'with appropriate hand will not occur any errors' do
      appropriate_hands = [
        # Without claim
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19],
         claimed: []},
        # With claim
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19],
         claimed:[[19, 19, 19]]}
      ]

      appropriate_hands.each do |appropriate_hand|
        expect {
          Rubijan.decision_yaku(appropriate_hand)
        }.not_to raise_error
      end
    end
  end

  describe '#decision' do
    context 'Test 1: Whether input hands is win.' do
      it 'When input hands is win, method #decision returns true' do
        input_hand = {not_claimed: [11, 11, 11, 22, 23, 24, 35, 36, 37, 41, 41, 42, 42, 42],
                      claimed: []}
        win_hand = [[41, 41], [11, 11, 11], [42, 42, 42], [22, 23, 24], [35, 36, 37]]
        expect(Rubijan.decision_yaku(input_hand)).to eq win_hand

        input_hand = {not_claimed: [21, 22, 22, 22, 22, 23, 32, 33, 34, 15, 15, 15, 47, 47],
                      claimed: []}
        win_hand = [[47, 47], [15, 15, 15], [21, 22, 23], [32, 33, 34], [22, 22, 22]]
        expect(Rubijan.decision_yaku(input_hand)).to eq win_hand
      end

      it 'When input hands is\'nt win, method #decision returns true' do
        input_hands = [
          {not_claimed: [11, 12, 11, 22, 23, 24, 35, 36, 37, 41, 41, 42, 42, 42],
           claimed: []},
          {not_claimed: [46, 46, 47, 47, 11, 12, 13, 21, 22, 23, 31, 32, 33, 34],
           claimed: []},
        ]
        input_hands.each do |input_hand|
          expect(Rubijan.decision_yaku(input_hand)).to eq []
        end
      end
    end
  end
end
