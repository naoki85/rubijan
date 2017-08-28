module Rubijan
  class Yaku
    module PureOutside
      NECESSARY_TILES = [11, 19, 21, 29, 31, 39].freeze

      def self.name
        'ジュンチャンタ'
      end

      # @param  [Hash] {:all_hand => [...]}
      # @return [Boolean]
      def self.check(count_group_by_tile_not_claimed)
        count_group_by_tile_not_claimed.each_key do |tile|
          return false if NECESSARY_TILES.include?(tile)
        end
        true
      end
    end
  end
end