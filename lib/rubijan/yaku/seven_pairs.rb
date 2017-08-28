module Rubijan
  class Yaku
    module SevenPairs

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

      def self.shape(count_group_by_tile_not_claimed)
        hand = []

        count_group_by_tile_not_claimed.each do |tile, count|
          count.times do
            hand << tile.to_i
          end
        end
        hand.sort!
      end
    end
  end
end