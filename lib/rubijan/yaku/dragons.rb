module Rubijan
  class Yaku
    module Dragons

      WHITE_DRAGON = 45
      GREEN_DRAGON = 46
      RED_DRAGON   = 47

      def self.name(flg_white, flg_green, flg_red)
        '役牌'
      end

      # @param  [Hash] {:all_hand => [...]}
      # @return [Boolean]
      def self.check(count_group_by_tile_not_claimed, count_group_by_tile_claimed)
        flg_white = false
        flg_green = false
        flg_red   = false

        count_group_by_tile_not_claimed.each do |tile, count|
          if tile == WHITE_DRAGON && count == 3
            flg_white = true
          end
          if tile == GREEN_DRAGON && count == 3
            flg_green = true
          end
          if tile == RED_DRAGON && count == 3
            flg_red   = true
          end
        end

        count_group_by_tile_claimed.each do |tile, count|
          if tile == WHITE_DRAGON && count == 3
            flg_white = true
          end
          if tile == GREEN_DRAGON && count == 3
            flg_green = true
          end
          if tile == RED_DRAGON && count == 3
            flg_red   = true
          end
        end
        return flg_white, flg_green, flg_red
      end
    end
  end
end