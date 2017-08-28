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
         claimed: []},
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19, 20],
         claimed: [],
         melted_kan: [21, 21, 21, 21, 21]},
        {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19, 20],
         claimed: [],
         concealed_kan: [21, 21, 21, 21, 21]}
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
end
