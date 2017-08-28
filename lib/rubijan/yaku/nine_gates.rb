module Rubijan
  class Yaku
    module NineGates
      NUMBER_PATTERN = {1 => 3, 2 => 1, 3 => 1, 4 => 1, 5 => 1, 6 => 1, 7 => 1,
                        8 => 1, 9 => 3}.freeze

      def self.name
        '九連宝灯'
      end

      # @param  [Hash] {:all_hand => [...]}
      # @return [Boolean]
      def self.check(count_group_by_tile_not_claimed)
        return false unless count_group_by_tile_not_claimed.count == 9
        flg_duplication = false
        before_tile = 0
        count_group_by_tile_not_claimed.each do |tile, count|
          return false if tile >= 40
          if before_tile > 0
            return false if (tile - before_tile).abs > 8
          end
          before_tile = tile

          next if NUMBER_PATTERN[tile % 10] == count
          return false if flg_duplication
          if NUMBER_PATTERN[tile % 10] < count && NUMBER_PATTERN[tile % 10] == count - 1
            flg_duplication = true
            next
          end
          return false
        end
        true
      end
    end
  end
end