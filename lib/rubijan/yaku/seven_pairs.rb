require 'concerns/common'

module Rubijan
  class Yaku
    module SevenPairs
      include Concerns::Common

      def self.name
        '七対子'
      end

      def self.check(count_group_by_tile_not_claimed)
        return false unless count_group_by_tile_not_claimed.count == 7

        count_group_by_tile_not_claimed.each_value do |count|
          return false unless count == 2
        end
        true
      end
    end
  end
end