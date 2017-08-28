module Rubijan
  class Yaku
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
    def initialize(input_hand)
      raise InvalidInputError unless input_hand.is_a?(Hash) && input_hand.key?(:not_claimed)
      @input_hands = input_hand
      @count_of_tiles = 0
      @claimed_set_array = []

      # Case not claimed,
      set_count_group_by_tile_not_claimed(input_hand[:not_claimed])
      return @win_hand if @win_hand = check_special_patterns_of_not_claimed
      shape_not_claimed_hand

      # Case claimed,
      set_claimed_set_array(input_hand[:claimed]) if input_hand.key?(:claimed)

      # Case kan,
      set_kan_melted_and_concealed(input_hand)
      raise InvalidInputError unless appropriate_hands_count?
      @win_hand
    end

    private

    def check_special_patterns_of_not_claimed
      # Special pattern 1: Thirteen orphans
      if ThirteenOrphans.check(@count_group_by_tile_not_claimed)
        return ThirteenOrphans.shape(@count_group_by_tile_not_claimed)
      end

      # Special pattern 2: Seven pairs
      if SevenPairs.check(@count_group_by_tile_not_claimed)
        return SevenPairs.shape(@count_group_by_tile_not_claimed)
      end
      false
    end

    def set_count_group_by_tile_not_claimed(input_hands_of_not_claimed)
      tmp_count_group_by_tile_not_claimed = {}

      input_hands_of_not_claimed.each do |tile|
        raise InvalidInputError unless TILE_TYPES.include?(tile.to_i)
        if tmp_count_group_by_tile_not_claimed.key?(tile)
          tmp_count_group_by_tile_not_claimed[tile] += 1
          raise InvalidInputError if tmp_count_group_by_tile_not_claimed[tile] > 4
        else
          tmp_count_group_by_tile_not_claimed[tile] = 1
        end
        @count_of_tiles += 1
      end
      @count_group_by_tile_not_claimed = Hash[tmp_count_group_by_tile_not_claimed.sort]
    end

    def shape_not_claimed_hand
      @count_group_by_tile_not_claimed.each do |tile, count|
        @tmp_win_hand = []
        @tmp_count_group_by_tile_not_claimed = @count_group_by_tile_not_claimed.dup
        next if count < 2
        @tmp_count_group_by_tile_not_claimed[tile] -= 2
        @tmp_win_hand << Array.new(2, tile)

        # 1. Check pungs of honours or suits
        check_pungs_of_alone_or_honour_tiles
        # 2. Check chows
        check_chows
        # 3. Again, Check pungs
        check_pungs
        # 4. Check whether this pattern OK?
        next unless checking_not_claimed_finished?

        @tmp_win_hand.each do |set|
          @win_hand << set
        end
        return true
      end
      return false unless @win_hand
    end

    def set_claimed_set_array(input_hands_of_claimed)
      input_hands_of_claimed.each do |set|
        tmp_count_group_by_tile_claimed = []
        raise InvalidInputError unless set.count == 3

        set.each do |tile|
          raise InvalidInputError unless TILE_TYPES.include?(tile.to_i)
          tmp_count_group_by_tile_claimed << tile.to_i
          @count_of_tiles += 1
        end
        check_pung(tmp_count_group_by_tile_claimed)
        check_chow(tmp_count_group_by_tile_claimed)
        @claimed_set_array << tmp_count_group_by_tile_claimed
      end
    end

    def set_kan_melted_and_concealed(input_hands)
      @kan = {}
      @kan[:melted] = []
      @kan[:concealed] = []
      return unless input_hands.key?(:melted_kan) || input_hands.key?(:concealed_kan)

      set_kan_and_win_hand(input_hands, 'melted_kan')
      set_kan_and_win_hand(input_hands, 'concealed_kan')
    end

    # If count of honour or suit is over 3, suppose this tiles is pung.
    # @return [void]
    def check_pungs_of_alone_or_honour_tiles
      @tmp_count_group_by_tile_not_claimed.each do |tile, count|
        next if count < 3
        if alone?(tile) || HONOURS.include?(tile)
          @tmp_count_group_by_tile_not_claimed[tile] -= 3
          @tmp_win_hand << Array.new(3, tile)
        end
      end
    end

    def alone?(tile)
      !(@tmp_count_group_by_tile_not_claimed.key?(tile - 1) &&
          @tmp_count_group_by_tile_not_claimed.key?(tile + 1))
    end

    # @return [void]
    def check_pungs
      @tmp_count_group_by_tile_not_claimed.each do |tile, count|
        next unless count >= 3
        @tmp_count_group_by_tile_not_claimed[tile] -= 3
        @tmp_win_hand << Array.new(3, tile)
      end
    end

    # @return [void]
    def check_chows
      @tmp_count_group_by_tile_not_claimed.each do |tile, count|
        next if count <= 0
        count.times do
          if @tmp_count_group_by_tile_not_claimed.key?(tile + 1) && @tmp_count_group_by_tile_not_claimed[tile + 1] > 0
            if @tmp_count_group_by_tile_not_claimed.key?(tile + 2) && @tmp_count_group_by_tile_not_claimed[tile + 2] > 0
              @tmp_count_group_by_tile_not_claimed[tile]     -= 1
              @tmp_count_group_by_tile_not_claimed[tile + 1] -= 1
              @tmp_count_group_by_tile_not_claimed[tile + 2] -= 1
              @tmp_win_hand << [tile, tile + 1, tile + 2]
            end
          end
        end
      end
    end

    # @return [Boolean]
    def checking_not_claimed_finished?
      flg_win = false
      @tmp_count_group_by_tile_not_claimed.each_value do |count|
        flg_win = true
        unless count.zero?
          flg_win = false
          break
        end
      end
      flg_win
    end

    def set_kan_and_win_hand(hash, target_symbol)
      if hash.key?(target_symbol.to_sym)
        hash[target_symbol.to_sym].each do |kan|
          raise InvalidInputError unless kan == 4
          raise InvalidInputError unless TILE_TYPES.include?(kan[0].to_i)
          @kan[target_symbol.to_sym] << kan[0].to_i
          @win_hand.push(kan[0].to_i, kan[0].to_i, kan[0].to_i)
          @count_of_tiles += 3
        end
      end
    end

    def appropriate_hands_count?
      @count_of_tiles == 14
    end

    def check_pung(set)
      set.sort!
      if set[0] == set[1] && set[0] == set[2]
        @win_hand << set
      end
    end

    def check_chow(set)
      set.sort!
      if set.include?(set[0] + 1) && set.include?(set[0] + 1)
        @win_hand << set
      end
    end
  end
end