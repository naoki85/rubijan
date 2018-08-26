require 'rubijan/errors'
require 'rubijan/version'
require 'rubijan/yaku_identifier'

module Rubijan

  # The format of `input_hands` is two dimensions array.
  # For Example,
  # with claim...
  # {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16],
  #  claimed: [[17, 18, 19], [19, 19, 19]]}
  # without claim...
  # {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19],
  #  claimed: []]}
  # Decide yaku from input hands.
  # Return value is for example,
  # ['タンヤオ', '平和', '一盃口']
  # @param  [Hash]
  # @return [String]
  def self.decision_yaku(input_hands)
    YakuIdentifier.new(input_hands)
  end

end
