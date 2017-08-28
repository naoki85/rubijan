module Rubijan
  class Yaku
    module AllSimples
      NOT_INCLUDED_TILES = [11, 19, 21, 29, 31, 39, 41, 42, 43, 44, 45, 46, 47].freeze

      def self.name
        'タンヤオ'
      end

      # @param  [Hash] {:all_hand => [...]}
      # @return [Boolean]
      def self.check(count_group_by_tile_not_claimed)
        count_group_by_tile_not_claimed.each_key do |tile|
          return false if NOT_INCLUDED_TILES.include?(tile)
        end
        true
      end
    end
  end
end