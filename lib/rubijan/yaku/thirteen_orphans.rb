module Rubijan
  class Yaku
    module ThirteenOrphans

      NECESSARY_TILES = [11, 19, 21, 29, 31, 39, 41, 42, 43, 44, 45, 46, 47].freeze

      def self.name
        '国士無双'
      end

      def self.check(count_group_by_tile_not_claimed)
        return false unless count_group_by_tile_not_claimed.count == 13
        flg_duplication = false

        count_group_by_tile_not_claimed.each do |tile, count|
          return false unless NECESSARY_TILES.include?(tile)
          return false if count > 2
          if count == 2
            return false if flg_duplication
            flg_duplication = true
            next
          end
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