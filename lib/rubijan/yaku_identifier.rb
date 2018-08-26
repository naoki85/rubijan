module Rubijan
  class YakuIdentifier
    # The number in the tenth place shows color.
    # And the number in the first place shows tile number.
    # CHARACTERS are called '萬子' in Japanese.
    # CIRCLES are called '筒子' in Japanese.
    # BAMBOOS are called '索子' in Japanese.
    CHARACTERS = [11, 12, 13, 14, 15, 16, 17, 18, 19].freeze
    CIRCLES    = [21, 22, 23, 24, 25, 26, 27, 28, 29].freeze
    BAMBOOS    = [31, 32, 33, 34, 35, 36, 37, 38, 39].freeze
    # 41: East, 42: South, 43: West, 44: North
    # 45: White Dragon, 46: Green Dragon, 47: Red Dragon
    HONOURS = [41, 42, 43, 44, 45, 46, 47].freeze

    TILE_TYPES = (CHARACTERS + CIRCLES + BAMBOOS + HONOURS).freeze

    UNNECESSARY_TILES_FOR_ALL_SIMPLES = [11, 19, 21, 29, 31, 39, 41, 42, 43, 44, 45, 46, 47].freeze

    # The format of `input_hands` is two dimensions array.
    # Hash parameters...
    # :not_claimed
    # :claimed
    # :melted_kan
    # :concealed_kan
    #
    # For Example,
    # with claim...
    # {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16],
    #  claimed: [[17, 18, 19], [19, 19, 19]]}
    # without claim...
    # {not_claimed: [11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 19, 19, 19]}
    # when four quads...
    # {not_claimed: [11, 11],
    #  melted_kan: [[12, 12, 12, 12], [25, 25, 25, 25]],
    #  concealed_kan: [[36, 36, 36, 36], [47, 47, 47, 47]]}
    def initialize(input_hands)
      raise InvalidInputError unless valid_input_hands?(input_hands)
      @input_hands = input_hands
      @not_claimed_hands = input_hands[:not_claimed]
      @claimed_hands = input_hands[:claimed]
      @melted_kan_hands = input_hands[:melted_kan]
      @concealed_kan_hands = input_hands[:concealed_kan]
      @tmp_win_hand = nil
      @win_hand = []
      @tmp_count_group_by_tile = nil
    end

    def identify
      set_win_hand
      sort_win_hand
      @win_hand
    end

    private

    def valid_input_hands?(input_hands)
      input_hands.is_a?(Hash) && input_hands.key?(:not_claimed)
    end

    def set_win_hand
      count_group_by_tile = get_count_group_by_tile
      count_group_by_tile.each do |tile, count|
        next if count < 2
        @tmp_win_hand = []
        @tmp_count_group_by_tile = count_group_by_tile.dup
        # First, set the pair
        @tmp_count_group_by_tile[tile] -= 2
        @tmp_win_hand << Array.new(2, tile)

        # 1. Check pungs of honours or suits
        check_pungs do |check_pungs_tile, check_pungs_count|
          if alone?(check_pungs_tile) || HONOURS.include?(check_pungs_count)
            @tmp_count_group_by_tile[check_pungs_tile] -= 3
            @tmp_win_hand << Array.new(3, check_pungs_tile)
          end
        end

        # 2. Check chows
        check_chows

        # 3. Again, Check pungs
        check_pungs

        # 4. Check whether this pattern OK?
        next unless checking_not_claimed_finished?

        @tmp_win_hand.each do |set|
          @win_hand << set
        end
      end
      return false unless @win_hand
    end

    def get_count_group_by_tile
      tmp_count_group_by_tile_not_claimed = {}

      @not_claimed_hands.each do |tile|
        raise InvalidInputError unless TILE_TYPES.include?(tile.to_i)
        if tmp_count_group_by_tile_not_claimed.key?(tile)
          tmp_count_group_by_tile_not_claimed[tile] += 1
          raise InvalidInputError if tmp_count_group_by_tile_not_claimed[tile] > 4
        else
          tmp_count_group_by_tile_not_claimed[tile] = 1
        end
      end
      Hash[tmp_count_group_by_tile_not_claimed.sort]
    end

    # If count of honour or suit is over 3, suppose this tiles is pung.
    # @return [void]
    def check_pungs
      @tmp_count_group_by_tile.each do |tile, count|
        next if count < 3
        if block_given?
          yield(tile, count)
        else
          @tmp_count_group_by_tile[tile] -= 3
          @tmp_win_hand << Array.new(3, tile)
        end
      end
    end

    def alone?(tile)
      !(@tmp_count_group_by_tile.key?(tile - 1) &&
          @tmp_count_group_by_tile.key?(tile + 1))
    end

    # @return [void]
    def check_chows
      @tmp_count_group_by_tile.each do |tile, count|
        next if count <= 0
        count.times do
          if @tmp_count_group_by_tile.key?(tile + 1) && @tmp_count_group_by_tile[tile + 1] > 0
            if @tmp_count_group_by_tile.key?(tile + 2) && @tmp_count_group_by_tile[tile + 2] > 0
              @tmp_count_group_by_tile[tile]     -= 1
              @tmp_count_group_by_tile[tile + 1] -= 1
              @tmp_count_group_by_tile[tile + 2] -= 1
              @tmp_win_hand << [tile, tile + 1, tile + 2]
            end
          end
        end
      end
    end

    # @return [Boolean]
    def checking_not_claimed_finished?
      flg_win = false
      @tmp_count_group_by_tile.each_value do |count|
        flg_win = true
        unless count.zero?
          flg_win = false
          break
        end
      end
      flg_win
    end

    def sort_win_hand
      @win_hand.sort_by! { |set|
        set[0]
      }
    end
  end
end