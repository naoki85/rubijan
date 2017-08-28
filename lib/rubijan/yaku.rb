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
    #
    # @param [Hash]
    def initialize(input_hands)
      @win_hands = []
      validate_input_hands(input_hands)

      # Case not claimed,
      @count_of_tiles = 0
      set_count_group_by_tile_not_claimed(input_hands[:not_claimed])
      # Case claimed,
      @claimed_set_array = []
      set_claimed_set_array(input_hands[:claimed]) if input_hands.key?(:claimed)
      # Case kan,
      set_kan(input_hands)
      raise InvalidInputError unless appropriate_hands_count?
      @yaku = []
    end

    # Decide yaku from input hands.
    # Return value is for example,
    # ['タンヤオ', '平和', '一盃口']
    # @return [String]
    def decision
      # pattern 1: Thirteen orphans
      if ThirteenOrphans.check(@count_group_by_tile_not_claimed)
        return @yaku << ThirteenOrphans.name
      end

      # Pattern 2: Nine gates
      if NineGates.check(@count_group_by_tile_not_claimed)
        return @yaku << NineGates.name
      end

      # pattern 3: Seven pairs
      if SevenPairs.check(@count_group_by_tile_not_claimed)
        @yaku << SevenPairs.name
        check_yaku_with_seven_pairs
        return @yaku
      end

      @count_group_by_tile_not_claimed.each do |tile, count|
        @tmp_win_hands = []
        @tmp_count_group_by_tile_not_claimed = @count_group_by_tile_not_claimed.dup
        next if count < 2
        @tmp_count_group_by_tile_not_claimed[tile] -= 2
        @tmp_win_hands << Array.new(2, tile)

        # 1. Check pungs of honours or suits
        check_pungs_of_alone_or_honour_tiles
        # 2. Check chows
        check_chows
        # 3. Again, Check pungs
        check_pungs
        # 4. Check whether this pattern win?
        next unless win?

        @tmp_win_hands.each do |set|
          @win_hands << set
        end
        break
      end
      @win_hands
    end

    private

    def validate_input_hands(input_hands)
      raise InvalidInputError unless input_hands.is_a?(Hash) && input_hands.key?(:not_claimed)
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

    def set_kan(input_hands)
      @kan = {}
      @kan[:melted] = []
      @kan[:concealed] = []
      return unless input_hands.key?(:melted_kan) || input_hands.key?(:concealed_kan)

      set_kan_and_win_hands(input_hands, 'melted_kan')
      set_kan_and_win_hands(input_hands, 'concealed_kan')
    end

    def set_kan_and_win_hands(hash, target_symbol)
      if hash.key?(target_symbol.to_sym)
        hash[target_symbol.to_sym].each do |kan|
          raise InvalidInputError unless kan == 4
          raise InvalidInputError unless TILE_TYPES.include?(kan[0].to_i)
          @kan[target_symbol.to_sym] << kan[0].to_i
          @win_hands.push(kan[0].to_i, kan[0].to_i, kan[0].to_i)
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
        @win_hands << set
      end
    end

    def check_chow(set)
      set.sort!
      if set.include?(set[0] + 1) && set.include?(set[0] + 1)
        @win_hands << set
      end
    end

    # @return [Boolean]
    def claimed?
      @claimed_set_array.count > 0
    end

    # If count of honour or suit is over 3, suppose this tiles is pung.
    # @return [void]
    def check_pungs_of_alone_or_honour_tiles
      @tmp_count_group_by_tile_not_claimed.each do |tile, count|
        next if count < 3
        if alone?(tile) || HONOURS.include?(tile)
          @tmp_count_group_by_tile_not_claimed[tile] -= 3
          @tmp_win_hands << Array.new(3, tile)
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
        @tmp_win_hands << Array.new(3, tile)
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
              @tmp_win_hands << [tile, tile + 1, tile + 2]
            end
          end
        end
      end
    end

    # @return [Boolean]
    def win?
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

    # @return [Boolean]
    def one_color?
      before_tile = 0
      @hands_one_dimension.each do |tile|
        unless before_tile.zero?
          return false if (tile - before_tile).abs >= 9
        end
        before_tile = tile
      end
    end

    # @return [Boolean]
    def one_color_with_honours?
      before_tile = 0
      @hands_one_dimension.each do |tile|
        unless before_tile.zero?
          if (tile - before_tile).abs >= 9
            next if HONOURS.include?(tile)
            return false
          end
        end
        before_tile = tile
      end
    end

    def check_yaku_with_seven_pairs
      if AllSimples.check(@count_group_by_tile_not_claimed)
        @yaku << AllSimples.name
      end
      if MixedOutside.check(@count_group_by_tile_not_claimed)
        @yaku << MixedOutside.name
      end
    end
  end
end