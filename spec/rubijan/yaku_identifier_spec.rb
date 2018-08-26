require 'spec_helper'

RSpec.describe Rubijan::YakuIdentifier do

  describe '#initialize' do
    it 'invalid parameters' do
      invalid_params = 1
      expect { Rubijan::YakuIdentifier.new(invalid_params) }.to raise_error(Rubijan::InvalidInputError)
    end
  end

  describe '#identify' do
    it 'only reach' do
      params = { not_claimed: [11, 12, 13, 22, 23, 24, 35, 35, 35, 41, 41, 41, 42, 42] }
      yaku_identifier = Rubijan::YakuIdentifier.new(params)
      expect(yaku_identifier.identify).to eq [[11, 12, 13], [22, 23, 24], [35, 35, 35], [41, 41, 41], [42, 42]]
    end
  end
end
