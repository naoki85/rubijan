require 'rubijan/errors'
require 'rubijan/version'
require 'rubijan/yaku'
require 'rubijan/yaku/all_simples'
require 'rubijan/yaku/mixed_outside'
require 'rubijan/yaku/pure_outside'
require 'rubijan/yaku/seven_pairs'
require 'rubijan/yaku/thirteen_orphans'

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
    Yaku.new(input_hands).decision
  end

end
