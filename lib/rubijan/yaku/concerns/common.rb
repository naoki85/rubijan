module Rubijan
  class Yaku
    module Concerns
      module Common
        def self.shape(count_group_by_tile_not_claimed)
          hand = []

          count_group_by_tile_not_claimed.each_key do |tile, count|
            count.times do
              hand << tile.to_i
            end
          end
          hand.sort!
        end
      end
    end
  end
end